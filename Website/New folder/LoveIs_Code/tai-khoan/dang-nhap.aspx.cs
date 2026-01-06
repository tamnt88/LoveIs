using System;
using System.Linq;

public partial class CustomerLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (CustomerAuth.IsSignedIn())
        {
            RedirectAfterLogin();
        }
    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        ErrorMessage.Text = string.Empty;

        string username = (UsernameInput.Text ?? string.Empty).Trim();
        string password = (PasswordInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(username) || string.IsNullOrEmpty(password))
        {
            ErrorMessage.Text = "Vui lòng nhập đầy đủ thông tin.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Username == username);
            if (customer == null || !customer.Status)
            {
                ErrorMessage.Text = "Thông tin đăng nhập không đúng.";
                return;
            }

            if (!customer.EmailVerified)
            {
                ErrorMessage.Text = "Tài khoản chưa xác nhận email. Vui lòng kiểm tra hộp thư.";
                return;
            }

            if (customer.LockedUntil.HasValue && customer.LockedUntil.Value > DateTime.UtcNow)
            {
                ErrorMessage.Text = "Tài khoản đang bị tạm khóa.";
                return;
            }

            bool ok = Pbkdf2Hasher.Verify(password, customer.PasswordSalt, customer.PasswordHash, customer.PasswordIterations);
            if (!ok)
            {
                ErrorMessage.Text = "Thông tin đăng nhập không đúng.";
                return;
            }

            customer.LastLoginAt = DateTime.UtcNow;
            db.SaveChanges();

            CustomerAuth.SignIn(customer);
        }

        RedirectAfterLogin();
    }

    private void RedirectAfterLogin()
    {
        var returnUrl = Request.QueryString["returnUrl"];
        if (!string.IsNullOrWhiteSpace(returnUrl) && returnUrl.StartsWith("/"))
        {
            Response.Redirect(returnUrl);
            return;
        }

        Response.Redirect("/");
    }
}
