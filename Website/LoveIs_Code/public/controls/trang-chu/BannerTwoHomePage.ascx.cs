using System;
using System.Linq;

public partial class public_controls_trang_chu_BannerTwoHomePage : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBanner();
        }
    }

    private void BindBanner()
    {
        using (var db = new BeautyStoryContext())
        {
            var banner = db.CfBanners
                .Where(b => b.Status && b.Position == "2")
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .FirstOrDefault();

            if (banner == null)
            {
                BannerSection.Visible = false;
                return;
            }

            BannerSection.Visible = true;
            BannerSection.Style["background-image"] = string.Format("url({0})", string.IsNullOrWhiteSpace(banner.ImageUrl)
                ? "/public/theme/assets/images/background/1.png"
                : banner.ImageUrl);

            TitleLine1Literal.Text = banner.TitleLine1 ?? string.Empty;
            TitleLine2Literal.Text = banner.TitleLine2 ?? string.Empty;
            TitleLine3Literal.Text = banner.TitleLine3 ?? string.Empty;

            if (banner.ShowLink && !string.IsNullOrWhiteSpace(banner.LinkUrl))
            {
                BannerLink.NavigateUrl = banner.LinkUrl;
                BannerLink.Visible = true;
                BannerLink.Text = string.IsNullOrWhiteSpace(banner.LinkText) ? "Xem thêm" : banner.LinkText;
            }
            else
            {
                BannerLink.Visible = false;
            }
        }
    }
}
