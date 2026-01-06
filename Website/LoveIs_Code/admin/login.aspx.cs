using System;
using System.Linq;

public partial class AdminLogin : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["AdminUserId"] != null)
        {
            Response.Redirect("~/admin/default.aspx");
        }
    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        ErrorMessage.Text = string.Empty;

        string username = (Username.Text ?? string.Empty).Trim();
        string password = Password.Text ?? string.Empty;

        if (string.IsNullOrWhiteSpace(username) || string.IsNullOrEmpty(password))
        {
            ErrorMessage.Text = "Please enter username and password.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var user = db.CfUsers.FirstOrDefault(u => u.Username == username);
            if (user == null || !user.Status)
            {
                ErrorMessage.Text = "Invalid username or password.";
                return;
            }

            if (user.LockedUntil.HasValue && user.LockedUntil.Value > DateTime.UtcNow)
            {
                ErrorMessage.Text = "Account is locked.";
                return;
            }

            bool ok = Pbkdf2Hasher.Verify(password, user.PasswordSalt, user.PasswordHash, user.PasswordIterations);
            if (!ok)
            {
                ErrorMessage.Text = "Invalid username or password.";
                return;
            }

            user.LastLoginAt = DateTime.UtcNow;
            db.SaveChanges();

            Session["AdminUserId"] = user.Id;
            Session["AdminUsername"] = user.Username;
            Session["AdminDisplayName"] = string.IsNullOrWhiteSpace(user.DisplayName) ? user.Username : user.DisplayName;
            Session["IsAdminSuper"] = string.Equals(user.Username, "admin", StringComparison.OrdinalIgnoreCase);

            if (RememberMe.Checked)
            {
                string token = RememberMeHelper.BuildToken(user.Id, user.Username, user.PasswordHash);
                var cookie = new System.Web.HttpCookie("AdminRemember");
                cookie.Values["uid"] = user.Id.ToString();
                cookie.Values["un"] = user.Username;
                cookie.Values["tk"] = token;
                cookie.Expires = DateTime.UtcNow.AddDays(30);
                cookie.HttpOnly = true;
                cookie.Secure = Request.IsSecureConnection;
                Response.Cookies.Add(cookie);
            }
            else
            {
                if (Request.Cookies["AdminRemember"] != null)
                {
                    var cookie = new System.Web.HttpCookie("AdminRemember");
                    cookie.Expires = DateTime.UtcNow.AddDays(-1);
                    Response.Cookies.Add(cookie);
                }
            }

            Response.Redirect("~/admin/default.aspx");
        }
    }
}
