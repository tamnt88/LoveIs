using System;
using System.IO;
using System.Linq;

public partial class AdminCmsTagsEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadTag();
        }
    }

    private void LoadTag()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var tag = db.CfPostTags.FirstOrDefault(t => t.Id == id);
            if (tag == null)
            {
                return;
            }

            TagId.Value = tag.Id.ToString();
            TagNameInput.Text = tag.TagName;
            SortOrderInput.Text = tag.SortOrder.ToString();
            StatusInput.Checked = tag.Status;

            ImageUrlValue.Value = tag.ImageUrl;
            SetPreview(ImagePreview, tag.ImageUrl);

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "PostTag" && s.EntityId == tag.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;

            SeoTitleInput.Text = tag.SeoTitle;
            SeoDescriptionInput.Text = tag.SeoDescription;
            SeoKeywordsInput.Text = tag.SeoKeywords;
            CanonicalUrlInput.Text = tag.CanonicalUrl;
            RobotsInput.Text = tag.Robots;

            OgTitleInput.Text = tag.OgTitle;
            OgDescriptionInput.Text = tag.OgDescription;
            OgImageValue.Value = tag.OgImage;
            SetPreview(OgImagePreview, tag.OgImage);
            OgTypeInput.Text = tag.OgType;

            TwitterTitleInput.Text = tag.TwitterTitle;
            TwitterDescriptionInput.Text = tag.TwitterDescription;
            TwitterImageValue.Value = tag.TwitterImage;
            SetPreview(TwitterImagePreview, tag.TwitterImage);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string tagName = (TagNameInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string imageUrl = SaveUploadedFile(ImageUpload, "cms/tags/image", ImageUrlValue.Value);
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "cms/tags/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "cms/tags/twitter", TwitterImageValue.Value);

        int sortOrder;
        if (!int.TryParse(SortOrderInput.Text, out sortOrder))
        {
            sortOrder = 0;
        }

        if (string.IsNullOrWhiteSpace(tagName))
        {
            FormMessage.CssClass = "text-danger small d-block mb-2";
            FormMessage.Text = "Vui lòng nhập tên tag.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.CssClass = "text-danger small d-block mb-2";
            FormMessage.Text = "Vui lòng nhập slug.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            CfPostTag tag;
            int id;
            if (int.TryParse(TagId.Value, out id) && id > 0)
            {
                tag = db.CfPostTags.FirstOrDefault(t => t.Id == id);
                if (tag == null)
                {
                    FormMessage.CssClass = "text-danger small d-block mb-2";
                    FormMessage.Text = "Không tìm thấy tag.";
                    return;
                }
            }
            else
            {
                tag = new CfPostTag
                {
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfPostTags.Add(tag);
            }

            tag.TagName = tagName;
            tag.ImageUrl = string.IsNullOrWhiteSpace(imageUrl) ? null : imageUrl;
            tag.SortOrder = sortOrder;
            tag.Status = StatusInput.Checked;
            tag.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            tag.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            tag.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            tag.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            tag.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            tag.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            tag.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            tag.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            tag.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            tag.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            tag.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            tag.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            tag.UpdatedAt = DateTime.UtcNow;
            tag.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "PostTag" || s.EntityId != tag.Id));
            if (slugExists)
            {
                FormMessage.CssClass = "text-danger small d-block mb-2";
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "PostTag" && s.EntityId == tag.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "PostTag",
                    EntityId = tag.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = tag.Status;
            slug.SortOrder = tag.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu tag thành công.";
        TagId.Value = string.Empty;
    }

    protected void ImageRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("image");
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
        if (!int.TryParse(TagId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var tag = db.CfPostTags.FirstOrDefault(t => t.Id == id);
            if (tag == null)
            {
                return;
            }

            switch (type)
            {
                case "image":
                    tag.ImageUrl = null;
                    ImageUrlValue.Value = string.Empty;
                    SetPreview(ImagePreview, null);
                    break;
                case "og":
                    tag.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    tag.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            tag.UpdatedAt = DateTime.UtcNow;
            tag.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }
    }

    private string SaveUploadedFile(System.Web.UI.WebControls.FileUpload upload, string folder, string existingPath)
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

    private static void SetPreview(System.Web.UI.WebControls.Image image, string url)
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
}
