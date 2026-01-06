using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminCmsPagesEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["saved"] == "1")
            {
                FormMessage.CssClass = "text-success small d-block mb-2";
                FormMessage.Text = "Lưu trang thành công.";
            }

            LoadPage();
        }
    }

    private void LoadPage()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var page = db.CfStaticPages.FirstOrDefault(p => p.Id == id);
            if (page == null)
            {
                return;
            }

            PageId.Value = page.Id.ToString();
            PageNameInput.Text = page.PageName;
            ContentInput.Text = page.Content;
            SortOrderInput.Text = page.SortOrder.ToString();
            StatusInput.Checked = page.Status;

            SeoTitleInput.Text = page.SeoTitle;
            SeoDescriptionInput.Text = page.SeoDescription;
            SeoKeywordsInput.Text = page.SeoKeywords;
            CanonicalUrlInput.Text = page.CanonicalUrl;
            RobotsInput.Text = page.Robots;

            OgTitleInput.Text = page.OgTitle;
            OgDescriptionInput.Text = page.OgDescription;
            OgImageValue.Value = page.OgImage;
            SetPreview(OgImagePreview, page.OgImage);
            OgTypeInput.Text = page.OgType;
            TwitterTitleInput.Text = page.TwitterTitle;
            TwitterDescriptionInput.Text = page.TwitterDescription;
            TwitterImageValue.Value = page.TwitterImage;
            SetPreview(TwitterImagePreview, page.TwitterImage);

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "StaticPage" && s.EntityId == page.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";

        int sortOrder;
        if (!int.TryParse(SortOrderInput.Text, out sortOrder))
        {
            sortOrder = 0;
        }

        string name = (PageNameInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên trang.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.Text = "Vui lòng nhập slug.";
            return;
        }

        string ogImage = SaveUploadedFile(OgImageUpload, "pages/og", OgImageValue.Value);
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "pages/twitter", TwitterImageValue.Value);

        using (var db = new BeautyStoryContext())
        {
            CfStaticPage page;
            int id;
            if (int.TryParse(PageId.Value, out id) && id > 0)
            {
                page = db.CfStaticPages.FirstOrDefault(p => p.Id == id);
                if (page == null)
                {
                    FormMessage.Text = "Trang không tồn tại.";
                    return;
                }
            }
            else
            {
                page = new CfStaticPage
                {
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfStaticPages.Add(page);
            }

            page.PageName = name;
            page.Content = ContentInput.Text;
            page.SortOrder = sortOrder;
            page.Status = StatusInput.Checked;
            page.SeoTitle = SeoTitleInput.Text;
            page.SeoDescription = SeoDescriptionInput.Text;
            page.SeoKeywords = SeoKeywordsInput.Text;
            page.CanonicalUrl = CanonicalUrlInput.Text;
            page.Robots = RobotsInput.Text;
            page.OgTitle = OgTitleInput.Text;
            page.OgDescription = OgDescriptionInput.Text;
            page.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            page.OgType = OgTypeInput.Text;
            page.TwitterTitle = TwitterTitleInput.Text;
            page.TwitterDescription = TwitterDescriptionInput.Text;
            page.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            page.UpdatedAt = DateTime.UtcNow;
            page.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "StaticPage" || s.EntityId != page.Id));
            if (slugExists)
            {
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "StaticPage" && s.EntityId == page.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "StaticPage",
                    EntityId = page.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = page.Status;
            slug.SortOrder = page.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();

            PageId.Value = page.Id.ToString();
        }

        Response.Redirect(string.Format("/admin/cms/pages/edit.aspx?id={0}&saved=1", PageId.Value));
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
        if (!int.TryParse(PageId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var page = db.CfStaticPages.FirstOrDefault(p => p.Id == id);
            if (page == null)
            {
                return;
            }

            switch (type)
            {
                case "og":
                    page.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    page.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            page.UpdatedAt = DateTime.UtcNow;
            page.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
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
}
