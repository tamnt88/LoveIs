using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

public partial class public_controls_trang_chu_BannerThreeHomePage : System.Web.UI.UserControl
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
        List<BannerItem> items;
        using (var db = new BeautyStoryContext())
        {
            items = db.CfBanners
                .Where(b => b.Status && b.Position == "3")
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .ToList()
                .Select(b => new BannerItem
                {
                    ImageUrl = string.IsNullOrWhiteSpace(b.ImageUrl) ? "/public/theme/assets/images/slider/22.png" : b.ImageUrl,
                    LinkUrl = string.IsNullOrWhiteSpace(b.LinkUrl) ? "#" : b.LinkUrl,
                    AltText = string.IsNullOrWhiteSpace(b.TitleLine2) ? "Banner" : b.TitleLine2,
                    ShowLink = b.ShowLink
                })
                .ToList();
        }

        if (items.Count == 0)
        {
            items.AddRange(new[]
            {
                new BannerItem { ImageUrl = "/public/theme/assets/images/banner/63.png", LinkUrl = "#", AltText = "Banner", ShowLink = false },
                new BannerItem { ImageUrl = "/public/theme/assets/images/banner/64.png", LinkUrl = "#", AltText = "Banner", ShowLink = false }
            });
        }

        BannerRepeater.DataSource = items;
        BannerRepeater.DataBind();
    }

    private sealed class BannerItem
    {
        public string ImageUrl { get; set; }
        public string LinkUrl { get; set; }
        public string AltText { get; set; }
        public bool ShowLink { get; set; }
    }
}
