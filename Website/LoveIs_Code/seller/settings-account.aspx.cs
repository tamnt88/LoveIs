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

        BindKycSummary();
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
            shop.BusinessType = BusinessTypeDropDown.SelectedValue;
            shop.TaxCode = (TaxCodeInput.Text ?? string.Empty).Trim();

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
            PasswordMessageLiteral.Text = "<div class='alert alert-danger'>Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.</div>";
            return;
        }

        var currentPassword = (CurrentPasswordInput.Text ?? string.Empty).Trim();
        var newPassword = (NewPasswordInput.Text ?? string.Empty).Trim();
        var confirmPassword = (ConfirmPasswordInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(currentPassword) || string.IsNullOrWhiteSpace(newPassword))
        {
            PasswordMessageLiteral.Text = "<div class='alert alert-danger'>Vui lòng nhập đầy đủ mật khẩu.</div>";
            return;
        }

        if (newPassword.Length < 6)
        {
            PasswordMessageLiteral.Text = "<div class='alert alert-danger'>Mật khẩu mới phải có ít nhất 6 ký tự.</div>";
            return;
        }

        if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
        {
            PasswordMessageLiteral.Text = "<div class='alert alert-danger'>Xác nhận mật khẩu không khớp.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId.Value);
            if (seller == null)
            {
                PasswordMessageLiteral.Text = "<div class='alert alert-danger'>Không tìm thấy tài khoản.</div>";
                return;
            }

            if (!Pbkdf2Hasher.Verify(currentPassword, seller.PasswordSalt, seller.PasswordHash, seller.PasswordIterations))
            {
                PasswordMessageLiteral.Text = "<div class='alert alert-danger'>Mật khẩu hiện tại không đúng.</div>";
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
            BusinessTypeDropDown.SelectedValue = string.IsNullOrWhiteSpace(shop.BusinessType) ? "individual" : shop.BusinessType;
            TaxCodeInput.Text = shop.TaxCode ?? string.Empty;

            PhoneInput.Text = seller.Phone ?? string.Empty;
            EmailInput.Text = seller.Email ?? string.Empty;
        }
    }

    protected void SubmitKycButton_Click(object sender, EventArgs e)
    {
        KycMessageLiteral.Text = string.Empty;

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var kyc = db.SellerKycs
                .Where(k => k.SellerId == sellerId.Value)
                .OrderByDescending(k => k.CreatedAt)
                .FirstOrDefault();

            if (kyc != null && (string.Equals(kyc.Status, "pending", StringComparison.OrdinalIgnoreCase)
                || string.Equals(kyc.Status, "approved", StringComparison.OrdinalIgnoreCase)))
            {
                BindKycSummary();
                return;
            }

            var hasFrontUpload = KycFrontUpload != null && KycFrontUpload.HasFile;
            var hasBackUpload = KycBackUpload != null && KycBackUpload.HasFile;
            var hasFrontExisting = !string.IsNullOrWhiteSpace(KycFrontExistingInput.Value);
            var hasBackExisting = !string.IsNullOrWhiteSpace(KycBackExistingInput.Value);

            if (!hasFrontUpload && !hasFrontExisting || !hasBackUpload && !hasBackExisting)
            {
                KycMessageLiteral.Text = "<div class=\"alert alert-warning\">Vui lòng tải đủ ảnh CCCD mặt trước và mặt sau.</div>";
                return;
            }

            if (kyc == null)
            {
                kyc = new SellerKyc
                {
                    SellerId = sellerId.Value,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture)
                };
                db.SellerKycs.Add(kyc);
            }

            kyc.FullName = (KycFullNameInput.Text ?? string.Empty).Trim();
            kyc.BirthDate = ParseDate(KycBirthDateInput.Text);
            kyc.IdNumber = (KycIdNumberInput.Text ?? string.Empty).Replace(" ", string.Empty).Trim();
            kyc.IdIssuedDate = ParseDate(KycIdIssuedDateInput.Text);
            kyc.IdIssuedPlace = (KycIdIssuedPlaceInput.Text ?? string.Empty).Trim();
            kyc.Status = "pending";
            kyc.RejectedReason = string.Empty;
            kyc.UpdatedAt = DateTime.Now;
            kyc.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);

            db.SaveChanges();

            SaveKycFile(db, kyc, KycFrontUpload, "cccd_front", "cccd-front");
            SaveKycFile(db, kyc, KycBackUpload, "cccd_back", "cccd-back");
            SaveKycFile(db, kyc, KycSelfieUpload, "selfie_with_cccd", "selfie-cccd");

            db.SaveChanges();
        }

        BindKycSummary();
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
        var html = "<div class='alert alert-success'>" + safeText + "</div>";
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

    private void BindKycSummary()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var kyc = db.SellerKycs
                .Where(k => k.SellerId == sellerId.Value)
                .OrderByDescending(k => k.CreatedAt)
                .FirstOrDefault();

            if (kyc == null)
            {
                ApplyKycStatus("Chưa gửi hồ sơ", "Vui lòng gửi hồ sơ để được duyệt.", "empty", "fa-regular fa-circle-question");
                OpenKycFlow.Visible = true;
                KycApprovedBanner.Visible = false;
                KycRejectedActionsInline.Visible = false;
                KycPendingPill.Visible = false;
                return;
            }

            KycFullNameInput.Text = kyc.FullName ?? string.Empty;
            KycBirthDateInput.Text = kyc.BirthDate.HasValue ? kyc.BirthDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : string.Empty;
            KycIdNumberInput.Text = string.IsNullOrWhiteSpace(kyc.IdNumber) ? string.Empty : FormatIdNumber(kyc.IdNumber);
            KycIdIssuedDateInput.Text = kyc.IdIssuedDate.HasValue ? kyc.IdIssuedDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : string.Empty;
            KycIdIssuedPlaceInput.Text = kyc.IdIssuedPlace ?? string.Empty;

            var fileLookup = db.SellerKycFiles
                .Where(f => f.SellerKycId == kyc.Id && f.Status)
                .GroupBy(f => f.FileType)
                .ToDictionary(g => g.Key, g => g.OrderByDescending(x => x.Id).First().FileUrl);

            var frontUrl = fileLookup.ContainsKey("cccd_front") ? fileLookup["cccd_front"] : string.Empty;
            var backUrl = fileLookup.ContainsKey("cccd_back") ? fileLookup["cccd_back"] : string.Empty;
            var selfieUrl = fileLookup.ContainsKey("selfie_with_cccd") ? fileLookup["selfie_with_cccd"] : string.Empty;

            KycFrontPreview.ImageUrl = frontUrl;
            KycBackPreview.ImageUrl = backUrl;
            KycSelfiePreview.ImageUrl = selfieUrl;
            KycFrontExistingInput.Value = frontUrl;
            KycBackExistingInput.Value = backUrl;
            KycSelfieExistingInput.Value = selfieUrl;

            var statusName = ResolveKycStatusName(db, kyc.Status);
            if (string.Equals(kyc.Status, "approved", StringComparison.OrdinalIgnoreCase))
            {
                ApplyKycStatus(statusName, "Tài khoản đã được xác thực.", "approved", "fa-solid fa-circle-check");
                OpenKycFlow.Visible = false;
                KycApprovedBanner.Visible = true;
                KycRejectedActionsInline.Visible = false;
                KycPendingPill.Visible = false;
            }
            else if (string.Equals(kyc.Status, "rejected", StringComparison.OrdinalIgnoreCase))
            {
                var reason = string.IsNullOrWhiteSpace(kyc.RejectedReason) ? "Hồ sơ cần bổ sung lại." : ("Từ chối: " + kyc.RejectedReason);
                ApplyKycStatus(statusName, reason, "rejected", "fa-solid fa-triangle-exclamation");
                OpenKycFlow.Visible = false;
                KycApprovedBanner.Visible = false;
                KycRejectedActionsInline.Visible = true;
                KycPendingPill.Visible = false;
            }
            else
            {
                ApplyKycStatus(statusName, "Hồ sơ của bạn đang được xét duyệt. Vui lòng quay lại sau 24h.", "pending", "fa-solid fa-clock");
                OpenKycFlow.Visible = false;
                KycApprovedBanner.Visible = false;
                KycRejectedActionsInline.Visible = false;
                KycPendingPill.Visible = true;
            }

            if (kyc.Status == null)
            {
                OpenKycFlow.Visible = true;
                KycApprovedBanner.Visible = false;
                KycRejectedActionsInline.Visible = false;
                KycPendingPill.Visible = false;
            }

            var rejectedReason = string.IsNullOrWhiteSpace(kyc.RejectedReason) ? "Chưa có lý do từ chối." : kyc.RejectedReason;
            KycRejectedReasonLiteral.Text = HttpUtility.HtmlEncode(rejectedReason);
            KycReviewNameLiteral.Text = HttpUtility.HtmlEncode(kyc.FullName ?? string.Empty);
            KycReviewIdLiteral.Text = HttpUtility.HtmlEncode(FormatIdNumber(kyc.IdNumber));
            KycReviewBirthLiteral.Text = kyc.BirthDate.HasValue ? kyc.BirthDate.Value.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture) : string.Empty;
            KycReviewIssuedLiteral.Text = kyc.IdIssuedDate.HasValue ? kyc.IdIssuedDate.Value.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture) : string.Empty;
            KycReviewPlaceLiteral.Text = HttpUtility.HtmlEncode(kyc.IdIssuedPlace ?? string.Empty);
            KycReviewFrontPreview.ImageUrl = frontUrl;
            KycReviewBackPreview.ImageUrl = backUrl;
            KycReviewSelfiePreview.ImageUrl = selfieUrl;
            KycReviewSelfieEmpty.Visible = string.IsNullOrWhiteSpace(selfieUrl);
        }
    }

    private void ApplyKycStatus(string title, string description, string statusClass, string iconClass)
    {
        KycStatusTitleLiteral.Text = HttpUtility.HtmlEncode(title ?? string.Empty);
        KycStatusDescLiteral.Text = HttpUtility.HtmlEncode(description ?? string.Empty);
        KycStatusIconLiteral.Text = string.IsNullOrWhiteSpace(iconClass) ? string.Empty : ("<i class=\"" + iconClass + "\"></i>");
        var baseClass = "security-icon kyc";
        KycStatusIcon.Attributes["class"] = string.IsNullOrWhiteSpace(statusClass)
            ? baseClass
            : baseClass + " " + statusClass;
    }

    private static DateTime? ParseDate(string raw)
    {
        DateTime value;
        return DateTime.TryParse(raw, out value) ? value : (DateTime?)null;
    }

    private string ResolveKycStatusName(BeautyStoryContext db, string statusCode)
    {
        if (string.IsNullOrWhiteSpace(statusCode))
        {
            return "Chưa gửi hồ sơ";
        }

        var status = db.SellerKycStatuses.FirstOrDefault(s => s.Status && s.Code == statusCode);
        return status != null ? status.Name : statusCode;
    }

    private void SaveKycFile(BeautyStoryContext db, SellerKyc kyc, System.Web.UI.WebControls.FileUpload upload, string fileType, string prefix)
    {
        if (upload == null || !upload.HasFile || kyc == null)
        {
            return;
        }

        var fileUrl = SaveUpload(upload, string.Empty, prefix);
        if (string.IsNullOrWhiteSpace(fileUrl))
        {
            return;
        }

        var existing = db.SellerKycFiles.FirstOrDefault(f => f.SellerKycId == kyc.Id && f.FileType == fileType);
        if (existing == null)
        {
            existing = new SellerKycFile
            {
                SellerKycId = kyc.Id,
                FileType = fileType,
                Status = true,
                CreatedAt = DateTime.Now,
                CreatedBy = "Seller:" + kyc.SellerId.ToString(CultureInfo.InvariantCulture)
            };
            db.SellerKycFiles.Add(existing);
        }

        existing.FileUrl = fileUrl;
        existing.FileName = Path.GetFileName(fileUrl);
        existing.FileSize = upload.PostedFile != null ? (int?)upload.PostedFile.ContentLength : null;
        existing.MimeType = upload.PostedFile != null ? upload.PostedFile.ContentType : null;
        existing.UpdatedAt = DateTime.Now;
        existing.UpdatedBy = "Seller:" + kyc.SellerId.ToString(CultureInfo.InvariantCulture);
    }

    private static string FormatIdNumber(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return string.Empty;
        }

        var digits = new string(raw.Where(char.IsDigit).ToArray());
        if (digits.Length <= 3)
        {
            return digits;
        }

        var groups = new System.Collections.Generic.List<string>();
        for (var i = 0; i < digits.Length; i += 3)
        {
            var length = Math.Min(3, digits.Length - i);
            groups.Add(digits.Substring(i, length));
        }

        return string.Join(" ", groups);
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
