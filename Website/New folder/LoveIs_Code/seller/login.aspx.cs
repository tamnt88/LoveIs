using System;
using System.Linq;

public partial class SellerLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.Charset = "utf-8";

        BindLogo();

        if (SellerAuth.IsSignedIn())
        {
            RedirectAfterLogin();
        }
    }

    private void BindLogo()
    {
        if (LogoImage == null)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var info = db.CfContactInfos
                .Where(i => i.Status)
                .OrderBy(i => i.SortOrder)
                .ThenBy(i => i.Id)
                .FirstOrDefault();

            var logoUrl = info != null && !string.IsNullOrWhiteSpace(info.LogoHorizontalUrl)
                ? info.LogoHorizontalUrl
                : (info != null && !string.IsNullOrWhiteSpace(info.LogoVerticalUrl) ? info.LogoVerticalUrl : "/images/logo_ngang.png");

            LogoImage.ImageUrl = ResolveUrl(logoUrl);
        }
    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        ErrorMessage.Text = string.Empty;
        string username = (UsernameInput.Text ?? string.Empty).Trim();
        string password = (PasswordInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
        {
            ErrorMessage.Text = "Vui lòng nhập tên người dùng và mật khẩu.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Username == username);
            if (seller == null || !seller.Status)
            {
                ErrorMessage.Text = "Đăng nhập không hợp lệ.";
                return;
            }

            if (seller.LockedUntil.HasValue && seller.LockedUntil.Value > DateTime.UtcNow)
            {
                ErrorMessage.Text = "Tài khoản đã bị khóa.";
                return;
            }

            bool ok = Pbkdf2Hasher.Verify(password, seller.PasswordSalt, seller.PasswordHash, seller.PasswordIterations);
            if (!ok)
            {
                ErrorMessage.Text = "Đăng nhập không hợp lệ.";
                return;
            }

            seller.LastLoginAt = DateTime.UtcNow;
            db.SaveChanges();

            SellerAuth.SignIn(seller);
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

        Response.Redirect("/seller");
    }
}
