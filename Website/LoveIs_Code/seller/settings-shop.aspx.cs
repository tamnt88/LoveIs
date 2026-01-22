using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;

public partial class SellerSettingsShop : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindShop();
            BindKyc();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shop = db.CfShops.FirstOrDefault(s => s.SellerId == sellerId.Value);
            if (shop == null)
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-warning\">Chưa tìm thấy thông tin shop.</div>";
                return;
            }

            shop.BusinessType = BusinessTypeDropDown.SelectedValue;
            shop.TaxCode = (TaxCodeInput.Text ?? string.Empty).Trim();

            shop.UpdatedAt = DateTime.Now;
            shop.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);

            db.SaveChanges();
        }

        FormMessageLiteral.Text = "<div class=\"alert alert-success\">Đã lưu cập nhật shop.</div>";
        BindShop();
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        BindShop();
    }

    private void BindShop()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shop = db.CfShops.FirstOrDefault(s => s.SellerId == sellerId.Value);
            if (shop == null)
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-warning\">Chưa tìm thấy thông tin shop.</div>";
                return;
            }

            BusinessTypeDropDown.SelectedValue = string.IsNullOrWhiteSpace(shop.BusinessType) ? "individual" : shop.BusinessType;
            TaxCodeInput.Text = shop.TaxCode;
        }
    }

    protected void SubmitKycButton_Click(object sender, EventArgs e)
    {
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

            var hasFrontUpload = KycFrontUpload != null && KycFrontUpload.HasFile;
            var hasBackUpload = KycBackUpload != null && KycBackUpload.HasFile;

            if (kyc == null && (!hasFrontUpload || !hasBackUpload))
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

            var existingTypes = kyc.Id > 0
                ? db.SellerKycFiles
                    .Where(f => f.SellerKycId == kyc.Id && f.Status)
                    .Select(f => f.FileType)
                    .ToList()
                : new System.Collections.Generic.List<string>();

            var hasFront = hasFrontUpload || existingTypes.Contains("cccd_front");
            var hasBack = hasBackUpload || existingTypes.Contains("cccd_back");
            if (!hasFront || !hasBack)
            {
                KycMessageLiteral.Text = "<div class=\"alert alert-warning\">Vui lòng tải đủ ảnh CCCD mặt trước và mặt sau.</div>";
                return;
            }

            kyc.FullName = (KycFullNameInput.Text ?? string.Empty).Trim();
            kyc.BirthDate = ParseDate(KycBirthDateInput.Text);
            kyc.IdNumber = (KycIdNumberInput.Text ?? string.Empty).Trim();
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

        KycMessageLiteral.Text = "<div class=\"alert alert-success\">Đã gửi hồ sơ KYC. Vui lòng chờ duyệt.</div>";
        BindKyc();
    }

    private void BindKyc()
    {
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

            if (kyc == null)
            {
                KycStatusInput.Text = "Chưa gửi hồ sơ";
                KycStatusNote.InnerText = "Vui lòng gửi đầy đủ hồ sơ để được duyệt.";
                KycFrontPreview.ImageUrl = "/images/fav.png";
                KycBackPreview.ImageUrl = "/images/fav.png";
                KycSelfiePreview.ImageUrl = "/images/fav.png";
                return;
            }

            KycFullNameInput.Text = kyc.FullName;
            KycBirthDateInput.Text = kyc.BirthDate.HasValue ? kyc.BirthDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : string.Empty;
            KycIdNumberInput.Text = kyc.IdNumber;
            KycIdIssuedDateInput.Text = kyc.IdIssuedDate.HasValue ? kyc.IdIssuedDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : string.Empty;
            KycIdIssuedPlaceInput.Text = kyc.IdIssuedPlace;
            KycStatusInput.Text = ResolveKycStatusName(db, kyc.Status);
            KycStatusNote.InnerText = string.IsNullOrWhiteSpace(kyc.RejectedReason) ? string.Empty : ("Lý do từ chối: " + kyc.RejectedReason);

            var fileLookup = db.SellerKycFiles
                .Where(f => f.SellerKycId == kyc.Id && f.Status)
                .GroupBy(f => f.FileType)
                .ToDictionary(g => g.Key, g => g.OrderByDescending(x => x.Id).First().FileUrl);

            KycFrontPreview.ImageUrl = fileLookup.ContainsKey("cccd_front") ? fileLookup["cccd_front"] : "/images/fav.png";
            KycBackPreview.ImageUrl = fileLookup.ContainsKey("cccd_back") ? fileLookup["cccd_back"] : "/images/fav.png";
            KycSelfiePreview.ImageUrl = fileLookup.ContainsKey("selfie_with_cccd") ? fileLookup["selfie_with_cccd"] : "/images/fav.png";
        }
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

    private string SaveUpload(System.Web.UI.WebControls.FileUpload upload, string existingUrl, string prefix)
    {
        if (upload == null || !upload.HasFile)
        {
            return string.Empty;
        }

        var extension = Path.GetExtension(upload.FileName);
        if (string.IsNullOrWhiteSpace(extension))
        {
            return string.Empty;
        }

        var safeExt = extension.ToLowerInvariant();
        if (safeExt != ".png" && safeExt != ".jpg" && safeExt != ".jpeg" && safeExt != ".gif")
        {
            return string.Empty;
        }

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
