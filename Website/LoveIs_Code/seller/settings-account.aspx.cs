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
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId.Value);
            if (seller == null)
            {
                AccountMessageLiteral.Text = "<div class='text-danger small'>Không tìm thấy tài khoản.</div>";
                return;
            }

            seller.DisplayName = (DisplayNameInput.Text ?? string.Empty).Trim();
            seller.Email = (EmailInput.Text ?? string.Empty).Trim();
            seller.Phone = (PhoneInput.Text ?? string.Empty).Trim();

            var birthDateRaw = (BirthDateInput.Text ?? string.Empty).Trim();
            if (string.IsNullOrWhiteSpace(birthDateRaw))
            {
                seller.BirthDate = null;
            }
            else
            {
                DateTime birthDate;
                if (DateTime.TryParseExact(birthDateRaw, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out birthDate))
                {
                    seller.BirthDate = birthDate;
                }
                else
                {
                    AccountMessageLiteral.Text = "<div class='text-danger small'>Ngày sinh không hợp lệ.</div>";
                    return;
                }
            }

            if (AvatarUpload.HasFile)
            {
                var ext = Path.GetExtension(AvatarUpload.FileName);
                if (!IsAllowedImageExtension(ext))
                {
                    AccountMessageLiteral.Text = "<div class='text-danger small'>Định dạng ảnh không hợp lệ.</div>";
                    return;
                }

                var fileName = "seller-avatar-" + seller.Id + "-" + DateTime.Now.ToString("yyyyMMddHHmmss") + ext;
                var relativePath = "/upload/seller/" + fileName;
                var savePath = Server.MapPath(relativePath);
                var directory = Path.GetDirectoryName(savePath);
                if (!string.IsNullOrWhiteSpace(directory) && !Directory.Exists(directory))
                {
                    Directory.CreateDirectory(directory);
                }

                AvatarUpload.SaveAs(savePath);
                seller.AvatarUrl = relativePath;
            }

            seller.UpdatedAt = DateTime.Now;
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

            DisplayNameInput.Text = seller.DisplayName ?? string.Empty;
            EmailInput.Text = seller.Email ?? string.Empty;
            PhoneInput.Text = seller.Phone ?? string.Empty;
            BirthDateInput.Text = seller.BirthDate.HasValue ? seller.BirthDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : string.Empty;

            if (seller.PasswordChangedAt.HasValue)
            {
                PasswordChangedAtLiteral.Text = seller.PasswordChangedAt.Value.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture);
            }
            else
            {
                PasswordChangedAtLiteral.Text = "Chưa có";
            }

            if (!string.IsNullOrWhiteSpace(seller.AvatarUrl))
            {
                AvatarImage.ImageUrl = seller.AvatarUrl;
                AvatarImage.Visible = true;
                AvatarInitialsLiteral.Visible = false;
            }
            else
            {
                var initials = "NA";
                if (!string.IsNullOrWhiteSpace(seller.DisplayName))
                {
                    var parts = seller.DisplayName.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length >= 2)
                    {
                        initials = (parts[0][0].ToString() + parts[parts.Length - 1][0]).ToUpperInvariant();
                    }
                    else if (parts.Length == 1)
                    {
                        initials = parts[0][0].ToString().ToUpperInvariant();
                    }
                }

                AvatarInitialsLiteral.Text = initials;
                AvatarInitialsLiteral.Visible = true;
                AvatarImage.Visible = false;
            }
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
}
