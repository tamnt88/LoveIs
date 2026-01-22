using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;

public partial class SellerSettingsAccount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSellerInfo();
            BindMessages();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        AccountMessageLiteral.Text = string.Empty;

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            AccountMessageLiteral.Text = "<div class='text-danger small'>Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shop = db.CfShops.FirstOrDefault(s => s.SellerId == sellerId.Value);
            if (shop == null)
            {
                AccountMessageLiteral.Text = "<div class='text-danger small'>Không tìm thấy thông tin shop.</div>";
                return;
            }

            shop.ShopName = (ShopNameInput.Text ?? string.Empty).Trim();
            shop.Description = (DescriptionInput.Text ?? string.Empty).Trim();

            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId.Value);
            if (seller != null)
            {
                seller.Phone = (PhoneInput.Text ?? string.Empty).Trim();
                seller.Email = (EmailInput.Text ?? string.Empty).Trim();
                seller.UpdatedAt = DateTime.Now;
            }

            var logoUrl = SaveUpload(LogoUpload, shop.LogoUrl, "logo");
            if (!string.IsNullOrWhiteSpace(logoUrl))
            {
                shop.LogoUrl = logoUrl;
            }

            var bannerUrl = SaveUpload(BannerUpload, shop.BannerUrl, "banner");
            if (!string.IsNullOrWhiteSpace(bannerUrl))
            {
                shop.BannerUrl = bannerUrl;
            }

            shop.UpdatedAt = DateTime.Now;
            shop.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
            db.SaveChanges();
        }

        BindSellerInfo();
        RedirectWithMessage("profile", "Cập nhật thông tin thành công.");
    }

    protected void ChangePasswordButton_Click(object sender, EventArgs e)
    {
        PasswordMessageLiteral.Text = string.Empty;

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            PasswordMessageLiteral.Text = "<div class='text-danger small'>Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.</div>";
            return;
        }

        var currentPassword = (CurrentPasswordInput.Text ?? string.Empty).Trim();
        var newPassword = (NewPasswordInput.Text ?? string.Empty).Trim();
        var confirmPassword = (ConfirmPasswordInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(currentPassword) || string.IsNullOrWhiteSpace(newPassword))
        {
            PasswordMessageLiteral.Text = "<div class='text-danger small'>Vui lòng nhập đầy đủ mật khẩu.</div>";
            return;
        }

        if (newPassword.Length < 6)
        {
            PasswordMessageLiteral.Text = "<div class='text-danger small'>Mật khẩu mới phải có ít nhất 6 ký tự.</div>";
            return;
        }

        if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
        {
            PasswordMessageLiteral.Text = "<div class='text-danger small'>Xác nhận mật khẩu không khớp.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId.Value);
            if (seller == null)
            {
                PasswordMessageLiteral.Text = "<div class='text-danger small'>Không tìm thấy tài khoản.</div>";
                return;
            }

            if (!Pbkdf2Hasher.Verify(currentPassword, seller.PasswordSalt, seller.PasswordHash, seller.PasswordIterations))
            {
                PasswordMessageLiteral.Text = "<div class='text-danger small'>Mật khẩu hiện tại không đúng.</div>";
                return;
            }

            int iterations = seller.PasswordIterations > 0 ? seller.PasswordIterations : 100000;
            byte[] salt;
            byte[] hash;
            Pbkdf2Hasher.Create(newPassword, iterations, out salt, out hash);

            seller.PasswordSalt = salt;
            seller.PasswordHash = hash;
            seller.PasswordIterations = iterations;
            seller.PasswordChangedAt = DateTime.Now;
            seller.UpdatedAt = DateTime.Now;

            db.SaveChanges();
        }

        CurrentPasswordInput.Text = string.Empty;
        NewPasswordInput.Text = string.Empty;
        ConfirmPasswordInput.Text = string.Empty;

        BindSellerInfo();
        RedirectWithMessage("password", "Đổi mật khẩu thành công.");
    }

    private void BindSellerInfo()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            PasswordChangedAtLiteral.Text = "Chưa có";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId.Value);
            if (seller == null)
            {
                PasswordChangedAtLiteral.Text = "Chưa có";
                return;
            }

            if (seller.PasswordChangedAt.HasValue)
            {
                PasswordChangedAtLiteral.Text = seller.PasswordChangedAt.Value.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture);
            }
            else
            {
                PasswordChangedAtLiteral.Text = "Chưa có";
            }

            var shop = db.CfShops.FirstOrDefault(s => s.SellerId == sellerId.Value);
            if (shop == null)
            {
                return;
            }

            ShopNameInput.Text = shop.ShopName ?? string.Empty;
            DescriptionInput.Text = shop.Description ?? string.Empty;
            LogoPreview.ImageUrl = string.IsNullOrWhiteSpace(shop.LogoUrl) ? "/images/fav.png" : shop.LogoUrl;
            BannerPreview.ImageUrl = string.IsNullOrWhiteSpace(shop.BannerUrl) ? "/images/fav.png" : shop.BannerUrl;

            PhoneInput.Text = seller.Phone ?? string.Empty;
            EmailInput.Text = seller.Email ?? string.Empty;
        }
    }

    private void BindMessages()
    {
        var messageType = Request.QueryString["msg"];
        var messageText = Request.QueryString["msgText"];
        if (string.IsNullOrWhiteSpace(messageType) || string.IsNullOrWhiteSpace(messageText))
        {
            return;
        }

        var safeText = HttpUtility.HtmlEncode(messageText);
        var html = "<div class='text-success small'>" + safeText + "</div>";
        if (string.Equals(messageType, "profile", StringComparison.OrdinalIgnoreCase))
        {
            AccountMessageLiteral.Text = html;
        }
        else if (string.Equals(messageType, "password", StringComparison.OrdinalIgnoreCase))
        {
            PasswordMessageLiteral.Text = html;
        }
    }

    private void RedirectWithMessage(string type, string message)
    {
        var url = Request.Path + "?msg=" + HttpUtility.UrlEncode(type) + "&msgText=" + HttpUtility.UrlEncode(message);
        Response.Redirect(url, true);
    }

    private static bool IsAllowedImageExtension(string ext)
    {
        if (string.IsNullOrWhiteSpace(ext))
        {
            return false;
        }

        var lower = ext.ToLowerInvariant();
        return lower == ".png" || lower == ".jpg" || lower == ".jpeg" || lower == ".gif";
    }

    private string SaveUpload(System.Web.UI.WebControls.FileUpload upload, string existingUrl, string prefix)
    {
        if (upload == null || !upload.HasFile)
        {
            return string.Empty;
        }

        var extension = Path.GetExtension(upload.FileName);
        if (!IsAllowedImageExtension(extension))
        {
            return string.Empty;
        }

        var safeExt = extension.ToLowerInvariant();
        var folder = "/upload/seller";
        var physicalFolder = Server.MapPath(folder);
        if (!Directory.Exists(physicalFolder))
        {
            Directory.CreateDirectory(physicalFolder);
        }

        var fileName = string.Format("{0}-{1}{2}", prefix, Guid.NewGuid().ToString("N"), safeExt);
        var physicalPath = Path.Combine(physicalFolder, fileName);
        upload.SaveAs(physicalPath);

        return folder + "/" + fileName;
    }
}
