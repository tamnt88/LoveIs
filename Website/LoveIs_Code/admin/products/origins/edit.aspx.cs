using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminProductOriginsEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && id > 0)
            {
                LoadOriginToForm(id);
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (OriginNameInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string iconUrl = SaveUploadedFile(IconUpload, "origins/icon", IconUrlValue.Value);
        string logoUrl = SaveUploadedFile(LogoUpload, "origins/logo", LogoUrlValue.Value);
        string bannerUrl = SaveUploadedFile(BannerUpload, "origins/banner", BannerUrlValue.Value);
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "origins/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "origins/twitter", TwitterImageValue.Value);
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        string viewCountText = (ViewCountInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên xuất xứ.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.Text = "Vui lòng nhập slug cho xuất xứ.";
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
            CfOrigin origin;
            int id;
            if (int.TryParse(OriginId.Value, out id) && id > 0)
            {
                origin = db.CfOrigins.FirstOrDefault(o => o.Id == id);
                if (origin == null)
                {
                    FormMessage.Text = "Xuất xứ không tồn tại.";
                    return;
                }
            }
            else
            {
                origin = new CfOrigin();
                origin.CreatedAt = DateTime.UtcNow;
                origin.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfOrigins.Add(origin);
            }

            origin.OriginName = name;
            origin.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            origin.IconUrl = string.IsNullOrWhiteSpace(iconUrl) ? null : iconUrl;
            origin.LogoUrl = string.IsNullOrWhiteSpace(logoUrl) ? null : logoUrl;
            origin.BannerUrl = string.IsNullOrWhiteSpace(bannerUrl) ? null : bannerUrl;
            origin.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            origin.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            origin.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            origin.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            origin.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            origin.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            origin.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            origin.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            origin.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            origin.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            origin.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            origin.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            origin.SortOrder = sortOrder;
            origin.ViewCount = viewCount;
            origin.Status = status;
            origin.UpdatedAt = DateTime.UtcNow;
            origin.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "Origin" || s.EntityId != origin.Id));
            if (slugExists)
            {
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Origin" && s.EntityId == origin.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "Origin",
                    EntityId = origin.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = origin.Status;
            slug.SortOrder = origin.SortOrder;
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

    private void LoadOriginToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var origin = db.CfOrigins.FirstOrDefault(o => o.Id == id);
            if (origin == null)
            {
                return;
            }

            OriginId.Value = origin.Id.ToString();
            OriginNameInput.Text = origin.OriginName;
            DescriptionInput.Text = origin.Description;
            IconUrlValue.Value = origin.IconUrl;
            LogoUrlValue.Value = origin.LogoUrl;
            BannerUrlValue.Value = origin.BannerUrl;
            SetPreview(IconPreview, origin.IconUrl);
            SetPreview(LogoPreview, origin.LogoUrl);
            SetPreview(BannerPreview, origin.BannerUrl);
            SeoTitleInput.Text = origin.SeoTitle;
            SeoDescriptionInput.Text = origin.SeoDescription;
            SeoKeywordsInput.Text = origin.SeoKeywords;
            OgTitleInput.Text = origin.OgTitle;
            OgDescriptionInput.Text = origin.OgDescription;
            OgImageValue.Value = origin.OgImage;
            SetPreview(OgImagePreview, origin.OgImage);
            OgTypeInput.Text = origin.OgType;
            TwitterTitleInput.Text = origin.TwitterTitle;
            TwitterDescriptionInput.Text = origin.TwitterDescription;
            TwitterImageValue.Value = origin.TwitterImage;
            SetPreview(TwitterImagePreview, origin.TwitterImage);
            CanonicalUrlInput.Text = origin.CanonicalUrl;
            RobotsInput.Text = origin.Robots;
            SortOrderInput.Text = origin.SortOrder.ToString();
            ViewCountInput.Text = origin.ViewCount.ToString();
            StatusInput.Checked = origin.Status;

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Origin" && s.EntityId == origin.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;
        }
    }

    private void ResetForm()
    {
        OriginId.Value = string.Empty;
        OriginNameInput.Text = string.Empty;
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
        if (!int.TryParse(OriginId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var origin = db.CfOrigins.FirstOrDefault(o => o.Id == id);
            if (origin == null)
            {
                return;
            }

            switch (type)
            {
                case "icon":
                    origin.IconUrl = null;
                    IconUrlValue.Value = string.Empty;
                    SetPreview(IconPreview, null);
                    break;
                case "logo":
                    origin.LogoUrl = null;
                    LogoUrlValue.Value = string.Empty;
                    SetPreview(LogoPreview, null);
                    break;
                case "banner":
                    origin.BannerUrl = null;
                    BannerUrlValue.Value = string.Empty;
                    SetPreview(BannerPreview, null);
                    break;
                case "og":
                    origin.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    origin.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            origin.UpdatedAt = DateTime.UtcNow;
            origin.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }
    }
}
