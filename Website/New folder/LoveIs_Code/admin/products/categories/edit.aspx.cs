using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminProductCategoriesEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && id > 0)
            {
                LoadCategoryToForm(id);
            }
            else
            {
                BindParentCategories(null, null);
                BindFilterGroups(null);
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (CategoryNameInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string iconUrl = SaveUploadedFile(IconUpload, "categories/icon", IconUrlValue.Value);
        string logoUrl = SaveUploadedFile(LogoUpload, "categories/logo", LogoUrlValue.Value);
        string bannerUrl = SaveUploadedFile(BannerUpload, "categories/banner", BannerUrlValue.Value);
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "categories/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "categories/twitter", TwitterImageValue.Value);
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui l�ng nh?p t�n danh m?c.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.Text = "Vui l�ng nh?p slug cho danh m?c.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortOrderText))
        {
            int.TryParse(sortOrderText, out sortOrder);
        }

        int? parentId = null;
        int parsedParentId;
        if (int.TryParse(ParentIdInput.SelectedValue, out parsedParentId) && parsedParentId > 0)
        {
            parentId = parsedParentId;
        }

        using (var db = new BeautyStoryContext())
        {
            CfCategory category;
            int id;
            if (int.TryParse(CategoryId.Value, out id) && id > 0)
            {
                category = db.CfCategories.FirstOrDefault(c => c.Id == id);
                if (category == null)
                {
                    FormMessage.Text = "Danh m?c kh�ng t?n t?i.";
                    return;
                }

                if (parentId.HasValue && parentId.Value == category.Id)
                {
                    FormMessage.Text = "Danh m?c cha kh�ng h?p l?.";
                    return;
                }
            }
            else
            {
                category = new CfCategory();
                category.CreatedAt = DateTime.UtcNow;
                category.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfCategories.Add(category);
            }

            if (parentId.HasValue)
            {
                var parent = db.CfCategories.FirstOrDefault(c => c.Id == parentId.Value);
                if (parent == null)
                {
                    FormMessage.Text = "Danh m?c cha kh�ng t?n t?i.";
                    return;
                }
            }

            category.CategoryName = name;
            category.ParentId = parentId;
            category.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            category.IconUrl = string.IsNullOrWhiteSpace(iconUrl) ? null : iconUrl;
            category.LogoUrl = string.IsNullOrWhiteSpace(logoUrl) ? null : logoUrl;
            category.BannerUrl = string.IsNullOrWhiteSpace(bannerUrl) ? null : bannerUrl;
            category.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            category.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            category.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            category.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            category.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            category.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            category.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            category.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            category.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            category.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            category.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            category.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            category.SortOrder = sortOrder;
            category.Status = status;
            category.UpdatedAt = DateTime.UtcNow;
            category.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "Category" || s.EntityId != category.Id));
            if (slugExists)
            {
                FormMessage.Text = "Slug d� t?n t?i. Vui l�ng ch?n slug kh�c.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Category" && s.EntityId == category.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "Category",
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
            SaveCategoryFilterGroups(db, category.Id);
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Luu th�nh c�ng.";
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
        BindParentCategories(null, null);
    }
    private static void AddCategoryOptions(ListControl target, List<CfCategory> categories, int? parentId, int level)
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
            var categories = db.CfCategories
                .Where(c => !excludeId.HasValue || c.Id != excludeId.Value)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

                        ParentIdInput.Items.Clear();
            ParentIdInput.Items.Add(new ListItem("Khong co", ""));
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

    private void LoadCategoryToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var category = db.CfCategories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return;
            }

            CategoryId.Value = category.Id.ToString();
            CategoryNameInput.Text = category.CategoryName;
            DescriptionInput.Text = category.Description;
            IconUrlValue.Value = category.IconUrl;
            LogoUrlValue.Value = category.LogoUrl;
            BannerUrlValue.Value = category.BannerUrl;
            SetPreview(IconPreview, category.IconUrl);
            SetPreview(LogoPreview, category.LogoUrl);
            SetPreview(BannerPreview, category.BannerUrl);
            SeoTitleInput.Text = category.SeoTitle;
            SeoDescriptionInput.Text = category.SeoDescription;
            SeoKeywordsInput.Text = category.SeoKeywords;
            OgTitleInput.Text = category.OgTitle;
            OgDescriptionInput.Text = category.OgDescription;
            OgImageValue.Value = category.OgImage;
            SetPreview(OgImagePreview, category.OgImage);
            OgTypeInput.Text = category.OgType;
            TwitterTitleInput.Text = category.TwitterTitle;
            TwitterDescriptionInput.Text = category.TwitterDescription;
            TwitterImageValue.Value = category.TwitterImage;
            SetPreview(TwitterImagePreview, category.TwitterImage);
            CanonicalUrlInput.Text = category.CanonicalUrl;
            RobotsInput.Text = category.Robots;
            SortOrderInput.Text = category.SortOrder.ToString();
            StatusInput.Checked = category.Status;

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Category" && s.EntityId == category.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;

            BindParentCategories(category.ParentId, category.Id);
            BindFilterGroups(category.Id);
        }
    }

    private void BindFilterGroups(int? categoryId)
    {
        FilterMessage.Text = string.Empty;

        using (var db = new BeautyStoryContext())
        {
            var groups = db.CfFilterGroups
                .Where(g => g.Status)
                .OrderBy(g => g.SortOrder)
                .ThenBy(g => g.GroupName)
                .Select(g => new { g.Id, g.GroupName })
                .ToList();

            FilterGroupInput.Items.Clear();
            foreach (var group in groups)
            {
                FilterGroupInput.Items.Add(new ListItem(group.GroupName, group.Id.ToString()));
            }

            if (!categoryId.HasValue || categoryId.Value <= 0)
            {
                FilterGroupInput.Enabled = false;
                FilterMessage.Text = "Vui lòng lưu danh mục trước khi cấu hình bộ lọc.";
                return;
            }

            var selectedIds = db.CfCategoryFilterGroups
                .Where(c => c.CategoryId == categoryId.Value && c.Status)
                .Select(c => c.GroupId)
                .ToList();

            foreach (ListItem item in FilterGroupInput.Items)
            {
                item.Selected = selectedIds.Contains(int.Parse(item.Value));
            }

            FilterGroupInput.Enabled = true;
        }
    }

    private void SaveCategoryFilterGroups(BeautyStoryContext db, int categoryId)
    {
        if (FilterGroupInput == null || !FilterGroupInput.Enabled)
        {
            return;
        }

        var selectedIds = FilterGroupInput.Items.Cast<ListItem>()
            .Where(i => i.Selected)
            .Select(i => int.Parse(i.Value))
            .ToList();

        var existing = db.CfCategoryFilterGroups.Where(c => c.CategoryId == categoryId).ToList();
        if (existing.Count > 0)
        {
            db.CfCategoryFilterGroups.RemoveRange(existing);
        }

        var now = DateTime.UtcNow;
        var admin = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
        int sortOrder = 0;
        foreach (var groupId in selectedIds)
        {
            db.CfCategoryFilterGroups.Add(new CfCategoryFilterGroup
            {
                CategoryId = categoryId,
                GroupId = groupId,
                Status = true,
                SortOrder = sortOrder++,
                CreatedAt = now,
                CreatedBy = admin,
                UpdatedAt = now,
                UpdatedBy = admin
            });
        }

        db.SaveChanges();
    }
    private void ResetForm()
    {
        CategoryId.Value = string.Empty;
        ParentIdInput.ClearSelection();
        CategoryNameInput.Text = string.Empty;
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
        if (!int.TryParse(CategoryId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var category = db.CfCategories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return;
            }

            switch (type)
            {
                case "icon":
                    category.IconUrl = null;
                    IconUrlValue.Value = string.Empty;
                    SetPreview(IconPreview, null);
                    break;
                case "logo":
                    category.LogoUrl = null;
                    LogoUrlValue.Value = string.Empty;
                    SetPreview(LogoPreview, null);
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











