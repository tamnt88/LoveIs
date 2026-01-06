using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminCmsCategoriesEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategory();
        }
    }

    private void LoadCategory()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            BindParentCategories(null, null);
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var category = db.CfPostCategories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                BindParentCategories(null, null);
                return;
            }

            CategoryId.Value = category.Id.ToString();
            CategoryNameInput.Text = category.CategoryName;
            DescriptionInput.Text = category.Description;
            ImageUrlValue.Value = category.ImageUrl;
            BannerUrlValue.Value = category.BannerUrl;
            SetPreview(ImagePreview, category.ImageUrl);
            SetPreview(BannerPreview, category.BannerUrl);
            SortOrderInput.Text = category.SortOrder.ToString();
            StatusInput.Checked = category.Status;

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "PostCategory" && s.EntityId == category.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;

            SeoTitleInput.Text = category.SeoTitle;
            SeoDescriptionInput.Text = category.SeoDescription;
            SeoKeywordsInput.Text = category.SeoKeywords;
            CanonicalUrlInput.Text = category.CanonicalUrl;
            RobotsInput.Text = category.Robots;

            OgTitleInput.Text = category.OgTitle;
            OgDescriptionInput.Text = category.OgDescription;
            OgImageValue.Value = category.OgImage;
            SetPreview(OgImagePreview, category.OgImage);
            OgTypeInput.Text = category.OgType;

            TwitterTitleInput.Text = category.TwitterTitle;
            TwitterDescriptionInput.Text = category.TwitterDescription;
            TwitterImageValue.Value = category.TwitterImage;
            SetPreview(TwitterImagePreview, category.TwitterImage);

            BindParentCategories(category.ParentId, category.Id);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string categoryName = (CategoryNameInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string imageUrl = SaveUploadedFile(ImageUpload, "cms/categories/image", ImageUrlValue.Value);
        string bannerUrl = SaveUploadedFile(BannerUpload, "cms/categories/banner", BannerUrlValue.Value);
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "cms/categories/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "cms/categories/twitter", TwitterImageValue.Value);

        int sortOrder;
        if (!int.TryParse(SortOrderInput.Text, out sortOrder))
        {
            sortOrder = 0;
        }

        if (string.IsNullOrWhiteSpace(categoryName))
        {
            FormMessage.CssClass = "text-danger small d-block mb-2";
            FormMessage.Text = "Vui lòng nhập tên danh mục.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.CssClass = "text-danger small d-block mb-2";
            FormMessage.Text = "Vui lòng nhập slug.";
            return;
        }

        int? parentId = null;
        int parsedParentId;
        if (int.TryParse(ParentIdInput.SelectedValue, out parsedParentId) && parsedParentId > 0)
        {
            parentId = parsedParentId;
        }

        using (var db = new BeautyStoryContext())
        {
            CfPostCategory category;
            int id;
            if (int.TryParse(CategoryId.Value, out id) && id > 0)
            {
                category = db.CfPostCategories.FirstOrDefault(c => c.Id == id);
                if (category == null)
                {
                    FormMessage.CssClass = "text-danger small d-block mb-2";
                    FormMessage.Text = "Không tìm thấy danh mục.";
                    return;
                }

                if (parentId.HasValue && parentId.Value == category.Id)
                {
                    FormMessage.CssClass = "text-danger small d-block mb-2";
                    FormMessage.Text = "Danh mục cha không hợp lệ.";
                    return;
                }
            }
            else
            {
                category = new CfPostCategory
                {
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfPostCategories.Add(category);
            }

            if (parentId.HasValue)
            {
                var parent = db.CfPostCategories.FirstOrDefault(c => c.Id == parentId.Value);
                if (parent == null)
                {
                    FormMessage.CssClass = "text-danger small d-block mb-2";
                    FormMessage.Text = "Danh mục cha không tồn tại.";
                    return;
                }
            }

            category.CategoryName = categoryName;
            category.ParentId = parentId;
            category.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            category.ImageUrl = string.IsNullOrWhiteSpace(imageUrl) ? null : imageUrl;
            category.BannerUrl = string.IsNullOrWhiteSpace(bannerUrl) ? null : bannerUrl;
            category.SortOrder = sortOrder;
            category.Status = StatusInput.Checked;
            category.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            category.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            category.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            category.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            category.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            category.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            category.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            category.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            category.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            category.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            category.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            category.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            category.UpdatedAt = DateTime.UtcNow;
            category.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "PostCategory" || s.EntityId != category.Id));
            if (slugExists)
            {
                FormMessage.CssClass = "text-danger small d-block mb-2";
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "PostCategory" && s.EntityId == category.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "PostCategory",
                    EntityId = category.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = category.Status;
            slug.SortOrder = category.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu danh mục thành công.";
    }

    private static void AddCategoryOptions(ListControl target, List<CfPostCategory> categories, int? parentId, int level)
    {
        var items = categories
            .Where(c => c.ParentId == parentId)
            .OrderBy(c => c.SortOrder)
            .ThenBy(c => c.CategoryName)
            .ToList();

        string prefix = string.Empty;
        for (int i = 0; i < level; i++)
        {
            prefix += "|-- ";
        }

        foreach (var item in items)
        {
            string label = string.Concat(prefix, item.CategoryName);
            target.Items.Add(new ListItem(label, item.Id.ToString()));
            AddCategoryOptions(target, categories, item.Id, level + 1);
        }
    }

    private void BindParentCategories(int? selectedId, int? excludeId)
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories
                .Where(c => !excludeId.HasValue || c.Id != excludeId.Value)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            ParentIdInput.Items.Clear();
            ParentIdInput.Items.Add(new ListItem("Không có", ""));
            AddCategoryOptions(ParentIdInput, categories, null, 0);

            if (selectedId.HasValue)
            {
                var item = ParentIdInput.Items.FindByValue(selectedId.Value.ToString());
                if (item != null)
                {
                    ParentIdInput.ClearSelection();
                    item.Selected = true;
                }
            }
        }
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

    protected void ImageRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("image");
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
        if (!int.TryParse(CategoryId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var category = db.CfPostCategories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return;
            }

            switch (type)
            {
                case "image":
                    category.ImageUrl = null;
                    ImageUrlValue.Value = string.Empty;
                    SetPreview(ImagePreview, null);
                    break;
                case "banner":
                    category.BannerUrl = null;
                    BannerUrlValue.Value = string.Empty;
                    SetPreview(BannerPreview, null);
                    break;
                case "og":
                    category.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    category.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            category.UpdatedAt = DateTime.UtcNow;
            category.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }
    }
}
