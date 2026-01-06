using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminProductFiltersEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && id > 0)
            {
                LoadGroupToForm(id);
            }

            BindOptions();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (GroupNameInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "filters/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "filters/twitter", TwitterImageValue.Value);
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên nhóm lọc.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.Text = "Vui lòng nhập slug cho nhóm lọc.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortOrderText))
        {
            int.TryParse(sortOrderText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            CfFilterGroup group;
            int id;
            if (int.TryParse(GroupId.Value, out id) && id > 0)
            {
                group = db.CfFilterGroups.FirstOrDefault(g => g.Id == id);
                if (group == null)
                {
                    FormMessage.Text = "Nhóm lọc không tồn tại.";
                    return;
                }
            }
            else
            {
                group = new CfFilterGroup();
                group.CreatedAt = DateTime.UtcNow;
                group.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfFilterGroups.Add(group);
            }

            group.GroupName = name;
            group.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            group.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            group.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            group.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            group.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            group.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            group.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            group.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            group.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            group.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            group.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            group.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            group.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            group.SortOrder = sortOrder;
            group.Status = status;
            group.UpdatedAt = DateTime.UtcNow;
            group.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "FilterGroup" || s.EntityId != group.Id));
            if (slugExists)
            {
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "FilterGroup" && s.EntityId == group.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "FilterGroup",
                    EntityId = group.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = group.Status;
            slug.SortOrder = group.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();

            GroupId.Value = group.Id.ToString();
            SetPreview(OgImagePreview, group.OgImage);
            SetPreview(TwitterImagePreview, group.TwitterImage);
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
        BindOptions();
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
        BindOptions();
    }

    protected void OgRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("og");
    }

    protected void TwitterRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("twitter");
    }

    protected void OptionSaveButton_Click(object sender, EventArgs e)
    {
        OptionMessage.Text = string.Empty;

        int groupId;
        if (!int.TryParse(GroupId.Value, out groupId) || groupId <= 0)
        {
            OptionMessage.Text = "Vui lòng lưu nhóm lọc trước khi thêm tuỳ chọn.";
            return;
        }

        string name = (OptionNameInput.Text ?? string.Empty).Trim();
        string description = (OptionDescriptionInput.Text ?? string.Empty).Trim();
        string sortText = (OptionSortOrderInput.Text ?? string.Empty).Trim();
        bool status = OptionStatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            OptionMessage.Text = "Vui lòng nhập tên tuỳ chọn.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            CfFilterOption option;
            int optionId;
            if (int.TryParse(OptionEditId.Value, out optionId) && optionId > 0)
            {
                option = db.CfFilterOptions.FirstOrDefault(o => o.Id == optionId && o.GroupId == groupId);
                if (option == null)
                {
                    OptionMessage.Text = "Tuỳ chọn không tồn tại.";
                    return;
                }
            }
            else
            {
                option = new CfFilterOption();
                option.GroupId = groupId;
                option.CreatedAt = DateTime.UtcNow;
                option.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfFilterOptions.Add(option);
            }

            option.OptionName = name;
            option.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            option.SortOrder = sortOrder;
            option.Status = status;
            option.UpdatedAt = DateTime.UtcNow;
            option.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        OptionMessage.CssClass = "text-success small d-block mb-2";
        OptionMessage.Text = "Lưu tuỳ chọn thành công.";
        ResetOptionForm();
        BindOptions();
    }

    protected void OptionResetButton_Click(object sender, EventArgs e)
    {
        ResetOptionForm();
    }

    protected void OptionRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditOption")
        {
            LoadOptionToForm(id);
        }
        else if (e.CommandName == "DeleteOption")
        {
            DeleteOption(id);
            BindOptions();
        }
    }

    private void LoadGroupToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var group = db.CfFilterGroups.FirstOrDefault(g => g.Id == id);
            if (group == null)
            {
                return;
            }

            GroupId.Value = group.Id.ToString();
            GroupNameInput.Text = group.GroupName;
            DescriptionInput.Text = group.Description;
            SeoTitleInput.Text = group.SeoTitle;
            SeoDescriptionInput.Text = group.SeoDescription;
            SeoKeywordsInput.Text = group.SeoKeywords;
            OgTitleInput.Text = group.OgTitle;
            OgDescriptionInput.Text = group.OgDescription;
            OgImageValue.Value = group.OgImage;
            SetPreview(OgImagePreview, group.OgImage);
            OgTypeInput.Text = group.OgType;
            TwitterTitleInput.Text = group.TwitterTitle;
            TwitterDescriptionInput.Text = group.TwitterDescription;
            TwitterImageValue.Value = group.TwitterImage;
            SetPreview(TwitterImagePreview, group.TwitterImage);
            CanonicalUrlInput.Text = group.CanonicalUrl;
            RobotsInput.Text = group.Robots;
            SortOrderInput.Text = group.SortOrder.ToString();
            StatusInput.Checked = group.Status;

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "FilterGroup" && s.EntityId == group.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;
        }
    }

    private void BindOptions()
    {
        int groupId;
        if (!int.TryParse(GroupId.Value, out groupId) || groupId <= 0)
        {
            OptionRepeater.DataSource = null;
            OptionRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var options = db.CfFilterOptions
                .Where(o => o.GroupId == groupId)
                .OrderBy(o => o.SortOrder)
                .ThenBy(o => o.OptionName)
                .Select(o => new
                {
                    o.Id,
                    o.OptionName,
                    o.SortOrder,
                    o.Status
                })
                .ToList();

            OptionRepeater.DataSource = options;
            OptionRepeater.DataBind();
        }
    }

    private void LoadOptionToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var option = db.CfFilterOptions.FirstOrDefault(o => o.Id == id);
            if (option == null)
            {
                return;
            }

            OptionEditId.Value = option.Id.ToString();
            OptionNameInput.Text = option.OptionName;
            OptionDescriptionInput.Text = option.Description;
            OptionSortOrderInput.Text = option.SortOrder.ToString();
            OptionStatusInput.Checked = option.Status;
        }
    }

    private void DeleteOption(int id)
    {
        OptionMessage.Text = string.Empty;

        using (var db = new BeautyStoryContext())
        {
            var option = db.CfFilterOptions.FirstOrDefault(o => o.Id == id);
            if (option == null)
            {
                OptionMessage.Text = "Tuỳ chọn không tồn tại.";
                return;
            }

            bool usedByProducts = db.CfProductFilters.Any(p => p.OptionId == id);
            if (usedByProducts)
            {
                OptionMessage.Text = "Không thể xóa tuỳ chọn đang được sử dụng.";
                return;
            }

            db.CfFilterOptions.Remove(option);
            db.SaveChanges();
        }

        OptionMessage.CssClass = "text-success small d-block mb-2";
        OptionMessage.Text = "Xóa tuỳ chọn thành công.";
        ResetOptionForm();
    }

    private void ResetForm()
    {
        GroupId.Value = string.Empty;
        GroupNameInput.Text = string.Empty;
        DescriptionInput.Text = string.Empty;
        SeoTitleInput.Text = string.Empty;
        SeoSlugInput.Text = string.Empty;
        SeoDescriptionInput.Text = string.Empty;
        SeoKeywordsInput.Text = string.Empty;
        OgTitleInput.Text = string.Empty;
        OgDescriptionInput.Text = string.Empty;
        OgImageValue.Value = string.Empty;
        SetPreview(OgImagePreview, null);
        OgTypeInput.Text = string.Empty;
        TwitterTitleInput.Text = string.Empty;
        TwitterDescriptionInput.Text = string.Empty;
        TwitterImageValue.Value = string.Empty;
        SetPreview(TwitterImagePreview, null);
        CanonicalUrlInput.Text = string.Empty;
        RobotsInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        StatusInput.Checked = true;
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
        ResetOptionForm();
    }

    private void ResetOptionForm()
    {
        OptionEditId.Value = string.Empty;
        OptionNameInput.Text = string.Empty;
        OptionDescriptionInput.Text = string.Empty;
        OptionSortOrderInput.Text = "0";
        OptionStatusInput.Checked = true;
        OptionMessage.Text = string.Empty;
        OptionMessage.CssClass = "text-danger small d-block mb-2";
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

    private void RemoveImage(string type)
    {
        int id;
        if (!int.TryParse(GroupId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var group = db.CfFilterGroups.FirstOrDefault(g => g.Id == id);
            if (group == null)
            {
                return;
            }

            switch (type)
            {
                case "og":
                    group.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    group.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            group.UpdatedAt = DateTime.UtcNow;
            group.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }
    }
}
