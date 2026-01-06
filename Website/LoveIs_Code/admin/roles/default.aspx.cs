using System;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminRolesDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRoles();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (RoleNameInput.Text ?? string.Empty).Trim();
        string description = (RoleDescriptionInput.Text ?? string.Empty).Trim();
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên role.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortOrderText))
        {
            int.TryParse(sortOrderText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            CfRole role;
            int id;
            if (int.TryParse(RoleId.Value, out id) && id > 0)
            {
                role = db.CfRoles.FirstOrDefault(r => r.Id == id);
                if (role == null)
                {
                    FormMessage.Text = "Role không tồn tại.";
                    return;
                }
            }
            else
            {
                role = new CfRole();
                role.CreatedAt = DateTime.UtcNow;
                role.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfRoles.Add(role);
            }

            role.RoleName = name;
            role.RoleDescription = string.IsNullOrWhiteSpace(description) ? null : description;
            role.SortOrder = sortOrder;
            role.Status = status;
            role.UpdatedAt = DateTime.UtcNow;
            role.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            db.SaveChanges();
        }

        ResetForm();
        BindRoles();
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void RoleRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditRole")
        {
            LoadRoleToForm(id);
        }
        else if (e.CommandName == "DeleteRole")
        {
            DeleteRole(id);
            BindRoles();
        }
    }

    private void BindRoles()
    {
        using (var db = new BeautyStoryContext())
        {
            var roles = db.CfRoles
                .OrderBy(r => r.SortOrder)
                .ThenBy(r => r.RoleName)
                .ToList();
            RoleRepeater.DataSource = roles;
            RoleRepeater.DataBind();
        }
    }

    private void LoadRoleToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var role = db.CfRoles.FirstOrDefault(r => r.Id == id);
            if (role == null)
            {
                return;
            }

            RoleId.Value = role.Id.ToString();
            RoleNameInput.Text = role.RoleName;
            RoleDescriptionInput.Text = role.RoleDescription;
            SortOrderInput.Text = role.SortOrder.ToString();
            StatusInput.Checked = role.Status;
        }
    }

    private void DeleteRole(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var role = db.CfRoles.FirstOrDefault(r => r.Id == id);
            if (role == null)
            {
                return;
            }

            bool hasUsers = db.CfUserRoles.Any(ur => ur.RoleId == id);
            bool hasPermissions = db.CfRolePermissions.Any(rp => rp.RoleId == id);
            if (hasUsers || hasPermissions)
            {
                FormMessage.Text = "Không thể xóa role đang được sử dụng.";
                return;
            }

            db.CfRoles.Remove(role);
            db.SaveChanges();
        }
    }

    private void ResetForm()
    {
        RoleId.Value = string.Empty;
        RoleNameInput.Text = string.Empty;
        RoleDescriptionInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        StatusInput.Checked = true;
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
    }
}
