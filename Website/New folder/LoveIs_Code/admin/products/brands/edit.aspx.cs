using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminProductBrandsEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && id > 0)
            {
                LoadBrandToForm(id);
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (BrandNameInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string iconUrl = SaveUploadedFile(IconUpload, "brands/icon", IconUrlValue.Value);
        string logoUrl = SaveUploadedFile(LogoUpload, "brands/logo", LogoUrlValue.Value);
        string bannerUrl = SaveUploadedFile(BannerUpload, "brands/banner", BannerUrlValue.Value);
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "brands/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "brands/twitter", TwitterImageValue.Value);
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        string viewCountText = (ViewCountInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên thương hiệu.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.Text = "Vui lòng nhập slug cho thương hiệu.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortOrderText))
        {
            int.TryParse(sortOrderText, out sortOrder);
        }

        int viewCount = 0;
        if (!string.IsNullOrWhiteSpace(viewCountText))
        {
            int.TryParse(viewCountText, out viewCount);
        }

        using (var db = new BeautyStoryContext())
        {
            CfBrand brand;
            int id;
            if (int.TryParse(BrandId.Value, out id) && id > 0)
            {
                brand = db.CfBrands.FirstOrDefault(b => b.Id == id);
                if (brand == null)
                {
                    FormMessage.Text = "Thương hiệu không tồn tại.";
                    return;
                }
            }
            else
            {
                brand = new CfBrand();
                brand.CreatedAt = DateTime.UtcNow;
                brand.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfBrands.Add(brand);
            }

            brand.BrandName = name;
            brand.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            brand.IconUrl = string.IsNullOrWhiteSpace(iconUrl) ? null : iconUrl;
            brand.LogoUrl = string.IsNullOrWhiteSpace(logoUrl) ? null : logoUrl;
            brand.BannerUrl = string.IsNullOrWhiteSpace(bannerUrl) ? null : bannerUrl;
            brand.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            brand.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            brand.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            brand.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            brand.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            brand.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            brand.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            brand.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            brand.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            brand.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            brand.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            brand.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            brand.SortOrder = sortOrder;
            brand.ViewCount = viewCount;
            brand.Status = status;
            brand.UpdatedAt = DateTime.UtcNow;
            brand.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "Brand" || s.EntityId != brand.Id));
            if (slugExists)
            {
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Brand" && s.EntityId == brand.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "Brand",
                    EntityId = brand.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = brand.Status;
            slug.SortOrder = brand.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void LoadBrandToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var brand = db.CfBrands.FirstOrDefault(b => b.Id == id);
            if (brand == null)
            {
                return;
            }

            BrandId.Value = brand.Id.ToString();
            BrandNameInput.Text = brand.BrandName;
            DescriptionInput.Text = brand.Description;
            IconUrlValue.Value = brand.IconUrl;
            LogoUrlValue.Value = brand.LogoUrl;
            BannerUrlValue.Value = brand.BannerUrl;
            SetPreview(IconPreview, brand.IconUrl);
            SetPreview(LogoPreview, brand.LogoUrl);
            SetPreview(BannerPreview, brand.BannerUrl);
            SeoTitleInput.Text = brand.SeoTitle;
            SeoDescriptionInput.Text = brand.SeoDescription;
            SeoKeywordsInput.Text = brand.SeoKeywords;
            OgTitleInput.Text = brand.OgTitle;
            OgDescriptionInput.Text = brand.OgDescription;
            OgImageValue.Value = brand.OgImage;
            SetPreview(OgImagePreview, brand.OgImage);
            OgTypeInput.Text = brand.OgType;
            TwitterTitleInput.Text = brand.TwitterTitle;
            TwitterDescriptionInput.Text = brand.TwitterDescription;
            TwitterImageValue.Value = brand.TwitterImage;
            SetPreview(TwitterImagePreview, brand.TwitterImage);
            CanonicalUrlInput.Text = brand.CanonicalUrl;
            RobotsInput.Text = brand.Robots;
            SortOrderInput.Text = brand.SortOrder.ToString();
            ViewCountInput.Text = brand.ViewCount.ToString();
            StatusInput.Checked = brand.Status;

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Brand" && s.EntityId == brand.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;
        }
    }

    private void ResetForm()
    {
        BrandId.Value = string.Empty;
        BrandNameInput.Text = string.Empty;
        DescriptionInput.Text = string.Empty;
        IconUrlValue.Value = string.Empty;
        LogoUrlValue.Value = string.Empty;
        BannerUrlValue.Value = string.Empty;
        SeoTitleInput.Text = string.Empty;
        SeoSlugInput.Text = string.Empty;
        SeoDescriptionInput.Text = string.Empty;
        SeoKeywordsInput.Text = string.Empty;
        OgTitleInput.Text = string.Empty;
        OgDescriptionInput.Text = string.Empty;
        OgImageValue.Value = string.Empty;
        OgTypeInput.Text = string.Empty;
        TwitterTitleInput.Text = string.Empty;
        TwitterDescriptionInput.Text = string.Empty;
        TwitterImageValue.Value = string.Empty;
        SetPreview(IconPreview, null);
        SetPreview(LogoPreview, null);
        SetPreview(BannerPreview, null);
        SetPreview(OgImagePreview, null);
        SetPreview(TwitterImagePreview, null);
        CanonicalUrlInput.Text = string.Empty;
        RobotsInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        ViewCountInput.Text = "0";
        StatusInput.Checked = true;
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
    }

    private string SaveUploadedFile(FileUpload upload, string folder, string existingPath)
    {
        if (upload == null || !upload.HasFile)
        {
            return existingPath;
        }

        string fileName = Path.GetFileName(upload.FileName);
        string extension = Path.GetExtension(fileName);
        string uniqueName = string.Format("{0}_{1:yyyyMMddHHmmssfff}{2}", Guid.NewGuid().ToString("N"), DateTime.UtcNow, extension);
        string virtualFolder = string.Format("~/upload/{0}", folder.Trim('/'));
        string physicalFolder = Server.MapPath(virtualFolder);

        if (!Directory.Exists(physicalFolder))
        {
            Directory.CreateDirectory(physicalFolder);
        }

        string physicalPath = Path.Combine(physicalFolder, uniqueName);
        upload.SaveAs(physicalPath);
        return string.Format("/upload/{0}/{1}", folder.Trim('/'), uniqueName);
    }

    private static void SetPreview(Image image, string url)
    {
        if (image == null)
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(url))
        {
            image.Visible = false;
            image.ImageUrl = string.Empty;
            return;
        }

        image.Visible = true;
        image.ImageUrl = url;
    }

    protected void IconRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("icon");
    }

    protected void LogoRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("logo");
    }

    protected void BannerRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("banner");
    }

    protected void OgRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("og");
    }

    protected void TwitterRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("twitter");
    }

    private void RemoveImage(string type)
    {
        int id;
        if (!int.TryParse(BrandId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var brand = db.CfBrands.FirstOrDefault(b => b.Id == id);
            if (brand == null)
            {
                return;
            }

            switch (type)
            {
                case "icon":
                    brand.IconUrl = null;
                    IconUrlValue.Value = string.Empty;
                    SetPreview(IconPreview, null);
                    break;
                case "logo":
                    brand.LogoUrl = null;
                    LogoUrlValue.Value = string.Empty;
                    SetPreview(LogoPreview, null);
                    break;
                case "banner":
                    brand.BannerUrl = null;
                    BannerUrlValue.Value = string.Empty;
                    SetPreview(BannerPreview, null);
                    break;
                case "og":
                    brand.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    brand.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            brand.UpdatedAt = DateTime.UtcNow;
            brand.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }
    }
}
