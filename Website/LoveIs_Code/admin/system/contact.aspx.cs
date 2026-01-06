using System;
using System.Linq;
using System.IO;

public partial class AdminSystemContact : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            using (var db = new BeautyStoryContext())
            {
                var info = db.CfContactInfos.FirstOrDefault();
                if (info != null)
                {
                    CompanyNameInput.Text = info.CompanyName;
                    HotlineInput.Text = info.Hotline;
                    EmailInput.Text = info.Email;
                    AddressInput.Text = info.Address;
                    GoogleMapUrlInput.Text = info.GoogleMapUrl;
                    LogoHorizontalInput.Text = info.LogoHorizontalUrl;
                    LogoVerticalInput.Text = info.LogoVerticalUrl;
                    FaviconInput.Text = info.FaviconUrl;
                    GoogleMapEmbedInput.Text = info.GoogleMapEmbed;
                    BindPreview(LogoHorizontalPreview, info.LogoHorizontalUrl);
                    BindPreview(LogoVerticalPreview, info.LogoVerticalUrl);
                    BindPreview(FaviconPreview, info.FaviconUrl);
                }
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            var info = db.CfContactInfos.FirstOrDefault();
            if (info == null)
            {
                info = new CfContactInfo
                {
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    SortOrder = 0
                };
                db.CfContactInfos.Add(info);
            }

            info.CompanyName = CompanyNameInput.Text.Trim();
            info.Hotline = HotlineInput.Text.Trim();
            info.Email = EmailInput.Text.Trim();
            info.Address = AddressInput.Text.Trim();
            info.GoogleMapUrl = GoogleMapUrlInput.Text.Trim();
            info.LogoHorizontalUrl = ResolveImageValue(LogoHorizontalRemove.Checked, LogoHorizontalUpload, "system", LogoHorizontalInput.Text.Trim());
            info.LogoVerticalUrl = ResolveImageValue(LogoVerticalRemove.Checked, LogoVerticalUpload, "system", LogoVerticalInput.Text.Trim());
            info.FaviconUrl = ResolveImageValue(FaviconRemove.Checked, FaviconUpload, "system", FaviconInput.Text.Trim());
            info.GoogleMapEmbed = GoogleMapEmbedInput.Text.Trim();
            info.UpdatedAt = DateTime.Now;
            info.UpdatedBy = updatedBy;

            db.SaveChanges();
        }
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }

    private void BindPreview(System.Web.UI.WebControls.Image image, string url)
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

    private string ResolveImageValue(bool remove, System.Web.UI.WebControls.FileUpload upload, string folder, string existingPath)
    {
        if (remove)
        {
            return string.Empty;
        }

        return SaveUploadedFile(upload, folder, existingPath);
    }

    private string SaveUploadedFile(System.Web.UI.WebControls.FileUpload upload, string folder, string existingPath)
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
