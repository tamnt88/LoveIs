using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

public partial class AdminCmsPostsEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategories();
            BindTags();
            LoadPost();
        }
    }

    private void BindCategories()
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            CategoryInput.Items.Clear();
            CategoryInput.Items.Add(new ListItem("-- Chọn danh mục --", string.Empty));
            AddCategoryOptions(CategoryInput, categories, null, 0);
        }
    }

    private void BindTags()
    {
        using (var db = new BeautyStoryContext())
        {
            var tags = db.CfPostTags
                .Where(t => t.Status)
                .OrderBy(t => t.SortOrder)
                .ThenBy(t => t.TagName)
                .ToList();

            TagListInput.Items.Clear();
            foreach (var tag in tags)
            {
                TagListInput.Items.Add(new ListItem(tag.TagName, tag.Id.ToString()));
            }
        }
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
            target.Items.Add(new ListItem(string.Concat(prefix, item.CategoryName), item.Id.ToString()));
            AddCategoryOptions(target, categories, item.Id, level + 1);
        }
    }

    private void LoadPost()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var post = db.CfPosts.FirstOrDefault(p => p.Id == id);
            if (post == null)
            {
                return;
            }

            PostId.Value = post.Id.ToString();
            TitleInput.Text = post.Title;
            CategoryInput.SelectedValue = post.CategoryId.ToString();
            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Post" && s.EntityId == post.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;
            SummaryInput.Text = post.Summary;
            ContentInput.Text = post.Content;
            FeaturedImageValue.Value = post.FeaturedImage;
            SetPreview(FeaturedImagePreview, post.FeaturedImage);
            SortOrderInput.Text = post.SortOrder.ToString();
            StatusInput.Checked = post.Status;

            SeoTitleInput.Text = post.SeoTitle;
            SeoDescriptionInput.Text = post.SeoDescription;
            SeoKeywordsInput.Text = post.SeoKeywords;
            CanonicalUrlInput.Text = post.CanonicalUrl;
            RobotsInput.Text = post.Robots;

            OgTitleInput.Text = post.OgTitle;
            OgDescriptionInput.Text = post.OgDescription;
            OgImageValue.Value = post.OgImage;
            SetPreview(OgImagePreview, post.OgImage);
            OgTypeInput.Text = post.OgType;
            TwitterTitleInput.Text = post.TwitterTitle;
            TwitterDescriptionInput.Text = post.TwitterDescription;
            TwitterImageValue.Value = post.TwitterImage;
            SetPreview(TwitterImagePreview, post.TwitterImage);

            var tagIds = db.CfPostTagMaps
                .Where(m => m.PostId == id)
                .Select(m => m.TagId)
                .ToList();

            foreach (ListItem item in TagListInput.Items)
            {
                int tagId;
                if (int.TryParse(item.Value, out tagId))
                {
                    item.Selected = tagIds.Contains(tagId);
                }
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        int sortOrder;
        if (!int.TryParse(SortOrderInput.Text, out sortOrder))
        {
            sortOrder = 0;
        }

        string title = (TitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        int categoryId;
        if (!int.TryParse(CategoryInput.SelectedValue, out categoryId))
        {
            categoryId = 0;
        }

        if (string.IsNullOrWhiteSpace(title))
        {
            FormMessage.CssClass = "text-danger small d-block mb-2";
            FormMessage.Text = "Vui lòng nhập tiêu đề.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.CssClass = "text-danger small d-block mb-2";
            FormMessage.Text = "Vui lòng nhập slug.";
            return;
        }

        string featuredImage = SaveUploadedFile(FeaturedImageUpload, "posts/featured", FeaturedImageValue.Value);
        string ogImage = SaveUploadedFile(OgImageUpload, "posts/og", OgImageValue.Value);
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "posts/twitter", TwitterImageValue.Value);

        using (var db = new BeautyStoryContext())
        {
            CfPost post;
            int id;
            if (int.TryParse(PostId.Value, out id) && id > 0)
            {
                post = db.CfPosts.FirstOrDefault(p => p.Id == id);
                if (post == null)
                {
                    FormMessage.CssClass = "text-danger small d-block mb-2";
                    FormMessage.Text = "Không tìm thấy bài viết.";
                    return;
                }
            }
            else
            {
                post = new CfPost
                {
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfPosts.Add(post);
            }

            post.Title = title;
            post.CategoryId = categoryId;
            post.Summary = SummaryInput.Text;
            post.Content = ContentInput.Text;
            post.FeaturedImage = string.IsNullOrWhiteSpace(featuredImage) ? null : featuredImage;
            post.SortOrder = sortOrder;
            post.Status = StatusInput.Checked;
            post.SeoTitle = SeoTitleInput.Text;
            post.SeoDescription = SeoDescriptionInput.Text;
            post.SeoKeywords = SeoKeywordsInput.Text;
            post.CanonicalUrl = CanonicalUrlInput.Text;
            post.Robots = RobotsInput.Text;
            post.OgTitle = OgTitleInput.Text;
            post.OgDescription = OgDescriptionInput.Text;
            post.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            post.OgType = OgTypeInput.Text;
            post.TwitterTitle = TwitterTitleInput.Text;
            post.TwitterDescription = TwitterDescriptionInput.Text;
            post.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            post.UpdatedAt = DateTime.UtcNow;
            post.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "Post" || s.EntityId != post.Id));
            if (slugExists)
            {
                FormMessage.CssClass = "text-danger small d-block mb-2";
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Post" && s.EntityId == post.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "Post",
                    EntityId = post.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = post.Status;
            slug.SortOrder = post.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();

            SaveTags(db, post.Id);
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu bài viết thành công.";
        Response.Redirect(string.Format("/admin/cms/posts/edit.aspx?id={0}", PostId.Value));
    }

    protected void FeaturedImageRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("featured");
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
        if (!int.TryParse(PostId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var post = db.CfPosts.FirstOrDefault(p => p.Id == id);
            if (post == null)
            {
                return;
            }

            switch (type)
            {
                case "featured":
                    post.FeaturedImage = null;
                    FeaturedImageValue.Value = string.Empty;
                    SetPreview(FeaturedImagePreview, null);
                    break;
                case "og":
                    post.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    post.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            post.UpdatedAt = DateTime.UtcNow;
            post.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
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

    private void SaveTags(BeautyStoryContext db, int postId)
    {
        var existingMaps = db.CfPostTagMaps.Where(m => m.PostId == postId).ToList();
        db.CfPostTagMaps.RemoveRange(existingMaps);

        var selectedIds = TagListInput.Items.Cast<ListItem>()
            .Where(i => i.Selected)
            .Select(i => int.Parse(i.Value))
            .ToList();

        foreach (var tagId in selectedIds)
        {
            var tag = db.CfPostTags.FirstOrDefault(t => t.Id == tagId);
            if (tag == null)
            {
                continue;
            }

            var map = new CfPostTagMap
            {
                PostId = postId,
                TagId = tag.Id,
                Status = true,
                CreatedAt = DateTime.UtcNow,
                CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
            };
            db.CfPostTagMaps.Add(map);
        }

        db.SaveChanges();
    }

    private static string NormalizeSlug(string input)
    {
        string slug = (input ?? string.Empty).Trim().ToLowerInvariant();
        slug = Regex.Replace(slug, "\\s+", "-");
        slug = Regex.Replace(slug, "[^a-z0-9\u0080-\uFFFF-]", string.Empty);
        slug = Regex.Replace(slug, "-+", "-");
        return slug.Trim('-');
    }

    private static string EnsureUniqueSlug(BeautyStoryContext db, string baseSlug, string entityType, int? entityId)
    {
        string slug = baseSlug;
        int counter = 1;
        while (db.CfSeoSlugs.Any(s => s.SeoSlug == slug && (s.EntityType != entityType || s.EntityId != (entityId ?? 0))))
        {
            slug = string.Format("{0}-{1}", baseSlug, counter);
            counter++;
        }

        return slug;
    }
}
