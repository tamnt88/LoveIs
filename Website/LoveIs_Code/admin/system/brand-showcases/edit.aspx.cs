using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminSystemBrandShowcasesEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBrands();
            LoadShowcase();
            BindBanners();
        }
    }

    private int GetShowcaseId()
    {
        int id;
        return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
    }

    private void BindBrands()
    {
        using (var db = new BeautyStoryContext())
        {
            var brands = db.CfBrands
                .OrderBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();

            BrandInput.Items.Clear();
            BrandInput.Items.Add(new ListItem("-- Chọn thương hiệu --", ""));
            foreach (var brand in brands)
            {
                BrandInput.Items.Add(new ListItem(brand.BrandName, brand.Id.ToString()));
            }
        }
    }

    private void LoadShowcase()
    {
        int id = GetShowcaseId();
        if (id <= 0)
        {
            BannerPanel.Visible = false;
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var showcase = db.CfBrandShowcases.FirstOrDefault(s => s.Id == id);
            if (showcase == null)
            {
                return;
            }

            ShowcaseId.Value = showcase.Id.ToString();
            if (BrandInput.Items.FindByValue(showcase.BrandId.ToString()) != null)
            {
                BrandInput.SelectedValue = showcase.BrandId.ToString();
            }
            TitleInput.Text = showcase.Title;
            SortOrderInput.Text = showcase.SortOrder.ToString();
            StatusInput.Checked = showcase.Status;

            if (!string.IsNullOrWhiteSpace(showcase.VideoUrl))
            {
                VideoPreviewPanel.Visible = true;
                VideoPreview.Attributes["src"] = showcase.VideoUrl;
            }

            BannerPanel.Visible = true;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        int id;
        int sortOrder;
        int.TryParse(ShowcaseId.Value, out id);
        int.TryParse(SortOrderInput.Text, out sortOrder);

        int brandId;
        if (!int.TryParse(BrandInput.SelectedValue, out brandId) || brandId <= 0)
        {
            return;
        }

        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        int targetId = id;
        using (var db = new BeautyStoryContext())
        {
            CfBrandShowcase showcase;
            if (id > 0)
            {
                showcase = db.CfBrandShowcases.FirstOrDefault(s => s.Id == id);
                if (showcase == null)
                {
                    return;
                }
            }
            else
            {
                showcase = new CfBrandShowcase
                {
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    SortOrder = 0
                };
                db.CfBrandShowcases.Add(showcase);
            }

            showcase.BrandId = brandId;
            showcase.Title = TitleInput.Text.Trim();
            showcase.VideoUrl = ResolveMediaValue(VideoRemove.Checked, VideoUpload, "brand-showcases", showcase.VideoUrl);
            showcase.SortOrder = sortOrder;
            showcase.Status = StatusInput.Checked;
            showcase.UpdatedAt = DateTime.Now;
            showcase.UpdatedBy = updatedBy;

            db.SaveChanges();
            targetId = showcase.Id;
        }

        Response.Redirect(string.Format("/admin/system/brand-showcases/edit.aspx?id={0}", targetId));
    }

    private void BindBanners()
    {
        int showcaseId;
        if (!int.TryParse(ShowcaseId.Value, out showcaseId) || showcaseId <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var banners = db.CfBrandShowcaseBanners
                .Where(b => b.ShowcaseId == showcaseId)
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .ToList();

            BannerRepeater.DataSource = banners;
            BannerRepeater.DataBind();
        }
    }

    protected void SaveBannerButton_Click(object sender, EventArgs e)
    {
        int showcaseId;
        if (!int.TryParse(ShowcaseId.Value, out showcaseId) || showcaseId <= 0)
        {
            BannerMessage.Text = "Vui lòng lưu thương hiệu trước khi thêm banner.";
            return;
        }

        int id;
        int sortOrder;
        int.TryParse(BannerId.Value, out id);
        int.TryParse(BannerSortOrderInput.Text, out sortOrder);

        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            CfBrandShowcaseBanner banner;
            if (id > 0)
            {
                banner = db.CfBrandShowcaseBanners.FirstOrDefault(b => b.Id == id);
                if (banner == null)
                {
                    return;
                }
            }
            else
            {
                banner = new CfBrandShowcaseBanner
                {
                    ShowcaseId = showcaseId,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    SortOrder = 0
                };
                db.CfBrandShowcaseBanners.Add(banner);
            }

            banner.TitleLine1 = BannerLine1Input.Text.Trim();
            banner.TitleLine2 = BannerLine2Input.Text.Trim();
            banner.TitleLine3 = BannerLine3Input.Text.Trim();
            banner.ImageUrl = ResolveMediaValue(BannerImageRemove.Checked, BannerImageUpload, "brand-banners", BannerImageUrlInput.Text.Trim());
            banner.LinkUrl = BannerLinkUrlInput.Text.Trim();
            banner.LinkText = BannerLinkTextInput.Text.Trim();
            banner.ShowLink = BannerShowLinkInput.Checked;
            banner.SortOrder = sortOrder;
            banner.Status = BannerStatusInput.Checked;
            banner.UpdatedAt = DateTime.Now;
            banner.UpdatedBy = updatedBy;

            db.SaveChanges();
        }

        ResetBannerForm();
        BannerMessage.Text = "Đã lưu banner.";
        BindBanners();
    }

    protected void ResetBannerButton_Click(object sender, EventArgs e)
    {
        ResetBannerForm();
    }

    private void ResetBannerForm()
    {
        BannerId.Value = string.Empty;
        BannerLine1Input.Text = string.Empty;
        BannerLine2Input.Text = string.Empty;
        BannerLine3Input.Text = string.Empty;
        BannerImageUrlInput.Text = string.Empty;
        BannerLinkUrlInput.Text = string.Empty;
        BannerLinkTextInput.Text = string.Empty;
        BannerShowLinkInput.Checked = true;
        BannerSortOrderInput.Text = "0";
        BannerStatusInput.Checked = true;
        BannerImageRemove.Checked = false;
        BannerImagePreview.Visible = false;
    }

    protected void BannerRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int bannerId;
        if (!int.TryParse(e.CommandArgument.ToString(), out bannerId) || bannerId <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var banner = db.CfBrandShowcaseBanners.FirstOrDefault(b => b.Id == bannerId);
            if (banner == null)
            {
                return;
            }

            if (e.CommandName == "delete")
            {
                db.CfBrandShowcaseBanners.Remove(banner);
                db.SaveChanges();
                BindBanners();
                return;
            }

            BannerId.Value = banner.Id.ToString();
            BannerLine1Input.Text = banner.TitleLine1;
            BannerLine2Input.Text = banner.TitleLine2;
            BannerLine3Input.Text = banner.TitleLine3;
            BannerImageUrlInput.Text = banner.ImageUrl;
            BannerLinkUrlInput.Text = banner.LinkUrl;
            BannerLinkTextInput.Text = banner.LinkText;
            BannerShowLinkInput.Checked = banner.ShowLink;
            BannerSortOrderInput.Text = banner.SortOrder.ToString();
            BannerStatusInput.Checked = banner.Status;

            if (!string.IsNullOrWhiteSpace(banner.ImageUrl))
            {
                BannerImagePreview.Visible = true;
                BannerImagePreview.ImageUrl = banner.ImageUrl;
            }
        }
    }

    private string ResolveMediaValue(bool remove, FileUpload upload, string folder, string existingPath)
    {
        if (remove)
        {
            return string.Empty;
        }

        return SaveUploadedFile(upload, folder, existingPath);
    }

    private string SaveUploadedFile(FileUpload upload, string folder, string existingPath)
    {
        if (upload == null || !upload.HasFile)
        {
            return existingPath;
        }

        string fileName = Path.GetFileName(upload.FileName);
        string extension = Path.GetExtension(fileName);
        if (string.IsNullOrWhiteSpace(extension))
        {
            return existingPath;
        }

        string uniqueName = string.Format("{0}_{1}{2}", Path.GetFileNameWithoutExtension(fileName), DateTime.Now.ToString("yyyyMMddHHmmssfff"), extension);
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
}
