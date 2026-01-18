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

            shop.ShopName = (ShopNameInput.Text ?? string.Empty).Trim();
            shop.Description = (DescriptionInput.Text ?? string.Empty).Trim();
            shop.Phone = (PhoneInput.Text ?? string.Empty).Trim();
            shop.Email = (EmailInput.Text ?? string.Empty).Trim();
            shop.BusinessType = BusinessTypeDropDown.SelectedValue;
            shop.TaxCode = (TaxCodeInput.Text ?? string.Empty).Trim();

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

            ShopNameInput.Text = shop.ShopName;
            DescriptionInput.Text = shop.Description;
            PhoneInput.Text = shop.Phone;
            EmailInput.Text = shop.Email;
            BusinessTypeDropDown.SelectedValue = string.IsNullOrWhiteSpace(shop.BusinessType) ? "individual" : shop.BusinessType;
            TaxCodeInput.Text = shop.TaxCode;

            LogoPreview.ImageUrl = string.IsNullOrWhiteSpace(shop.LogoUrl) ? "/images/fav.png" : shop.LogoUrl;
            BannerPreview.ImageUrl = string.IsNullOrWhiteSpace(shop.BannerUrl) ? "/images/fav.png" : shop.BannerUrl;
        }
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
