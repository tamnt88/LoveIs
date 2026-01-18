using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class public_controls_trang_chu_new_banner : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBanners();
        }
    }

    private void BindBanners()
    {
        using (var db = new BeautyStoryContext())
        {
            var banners = db.CfBanners
                .Where(b => b.Status && (b.Position == "Vị trí 1" || b.Position == "1"))
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .ToList();

            var slides = banners
                .Select(b => new BannerSlide
                {
                    ImageUrl = string.IsNullOrWhiteSpace(b.ImageUrl)
                        ? "/public/theme/assets/images/slider/22.png"
                        : b.ImageUrl,
                    LinkUrl = string.IsNullOrWhiteSpace(b.LinkUrl) ? "#" : b.LinkUrl,
                    AltText = string.IsNullOrWhiteSpace(b.TitleLine1) ? "Banner" : b.TitleLine1
                })
                .ToList();

            if (slides.Count == 0)
            {
                BannerPanel.Visible = false;
                return;
            }

            BannerPanel.Visible = true;
            BannerRepeater.DataSource = slides;
            BannerRepeater.DataBind();
        }
    }

    private sealed class BannerSlide
    {
        public string ImageUrl { get; set; }
        public string LinkUrl { get; set; }
        public string AltText { get; set; }
    }
}
