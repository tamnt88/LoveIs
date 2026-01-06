using System;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminUsersDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindUsers();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string username = (UsernameInput.Text ?? string.Empty).Trim();
        string displayName = (DisplayNameInput.Text ?? string.Empty).Trim();
        string email = (EmailInput.Text ?? string.Empty).Trim();
        string password = PasswordInput.Text ?? string.Empty;
        string confirm = ConfirmPasswordInput.Text ?? string.Empty;
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(username))
        {
            FormMessage.Text = "Vui lòng nhập tên đăng nhập.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortOrderText))
        {
            int.TryParse(sortOrderText, out sortOrder);
        }

        int id;
        int.TryParse(UserId.Value, out id);
        bool isEdit = id > 0;

        if (!isEdit && string.IsNullOrEmpty(password))
        {
            FormMessage.Text = "Vui lòng nhập mật khẩu.";
            return;
        }

        if (!string.IsNullOrEmpty(password))
        {
            if (password.Length < 6)
            {
                FormMessage.Text = "Mật khẩu phải có ít nhất 6 ký tự.";
                return;
            }
            if (!string.Equals(password, confirm, StringComparison.Ordinal))
            {
                FormMessage.Text = "Xác nhận mật khẩu không khớp.";
                return;
            }
        }

        using (var db = new BeautyStoryContext())
        {
            bool exists = db.CfUsers.Any(u => u.Username == username && u.Id != id);
            if (exists)
            {
                FormMessage.Text = "Tên đăng nhập đã tồn tại.";
                return;
            }

            CfUser user;
            if (isEdit)
            {
                user = db.CfUsers.FirstOrDefault(u => u.Id == id);
                if (user == null)
                {
                    FormMessage.Text = "User không tồn tại.";
                    return;
                }
            }
            else
            {
                user = new CfUser();
                user.CreatedAt = DateTime.UtcNow;
                user.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfUsers.Add(user);
            }

            user.Username = username;
            user.DisplayName = string.IsNullOrWhiteSpace(displayName) ? null : displayName;
            user.Email = string.IsNullOrWhiteSpace(email) ? null : email;
            user.SortOrder = sortOrder;
            user.Status = status;
            user.UpdatedAt = DateTime.UtcNow;
            user.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            if (!string.IsNullOrEmpty(password))
            {
                byte[] salt;
                byte[] hash;
                int iterations = 100000;
                Pbkdf2Hasher.Create(password, iterations, out salt, out hash);
                user.PasswordSalt = salt;
                user.PasswordHash = hash;
                user.PasswordIterations = iterations;
            }

            db.SaveChanges();
        }

        ResetForm();
        BindUsers();
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void UserRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditUser")
        {
            LoadUserToForm(id);
        }
        else if (e.CommandName == "DeleteUser")
        {
            DeleteUser(id);
            BindUsers();
        }
    }

    private void BindUsers()
    {
        using (var db = new BeautyStoryContext())
        {
            var users = db.CfUsers
                .OrderBy(u => u.SortOrder)
                .ThenBy(u => u.Username)
                .ToList();
            UserRepeater.DataSource = users;
            UserRepeater.DataBind();
        }
    }

    private void LoadUserToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var user = db.CfUsers.FirstOrDefault(u => u.Id == id);
            if (user == null)
            {
                return;
            }

            UserId.Value = user.Id.ToString();
            UsernameInput.Text = user.Username;
            DisplayNameInput.Text = user.DisplayName;
            EmailInput.Text = user.Email;
            SortOrderInput.Text = user.SortOrder.ToString();
            StatusInput.Checked = user.Status;
            PasswordInput.Text = string.Empty;
            ConfirmPasswordInput.Text = string.Empty;
        }
    }

    private void DeleteUser(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var user = db.CfUsers.FirstOrDefault(u => u.Id == id);
            if (user == null)
            {
                return;
            }

            if (string.Equals(user.Username, "admin", StringComparison.OrdinalIgnoreCase))
            {
                FormMessage.Text = "Không thể xóa tài khoản admin.";
                return;
            }

            db.CfUsers.Remove(user);
            db.SaveChanges();
        }
    }

    private void ResetForm()
    {
        UserId.Value = string.Empty;
        UsernameInput.Text = string.Empty;
        DisplayNameInput.Text = string.Empty;
        EmailInput.Text = string.Empty;
        PasswordInput.Text = string.Empty;
        ConfirmPasswordInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        StatusInput.Checked = true;
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
    }
}
