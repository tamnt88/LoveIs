using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

public partial class public_controls_trang_chu_BannerFourHomePage : System.Web.UI.UserControl
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
                .Where(b => b.Status && b.Position == "4")
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .ToList()
                .Select(b => new BannerItem
                {
                    ImageUrl = string.IsNullOrWhiteSpace(b.ImageUrl) ? "/public/theme/assets/images/slider/22.png" : b.ImageUrl,
                    LinkUrl = string.IsNullOrWhiteSpace(b.LinkUrl) ? "#" : b.LinkUrl,
                    LinkText = string.IsNullOrWhiteSpace(b.LinkText) ? "Xem them" : b.LinkText,
                    AltText = string.IsNullOrWhiteSpace(b.TitleLine2) ? "Banner" : b.TitleLine2,
                    ShowLink = b.ShowLink
                })
                .ToList();
        }

        if (items.Count == 0)
        {
            items.AddRange(new[]
            {
                new BannerItem { ImageUrl = "/public/theme/assets/images/products/squire-221.png", LinkUrl = "#", LinkText = "Xem them", AltText = "Banner", ShowLink = false },
                new BannerItem { ImageUrl = "/public/theme/assets/images/products/squire-222.png", LinkUrl = "#", LinkText = "Xem them", AltText = "Banner", ShowLink = false },
                new BannerItem { ImageUrl = "/public/theme/assets/images/products/squire-223.png", LinkUrl = "#", LinkText = "Xem them", AltText = "Banner", ShowLink = false },
                new BannerItem { ImageUrl = "/public/theme/assets/images/products/squire-224.png", LinkUrl = "#", LinkText = "Xem them", AltText = "Banner", ShowLink = false },
                new BannerItem { ImageUrl = "/public/theme/assets/images/products/squire-225.png", LinkUrl = "#", LinkText = "Xem them", AltText = "Banner", ShowLink = false },
                new BannerItem { ImageUrl = "/public/theme/assets/images/products/squire-226.png", LinkUrl = "#", LinkText = "Xem them", AltText = "Banner", ShowLink = false }
            });
        }

        BannerRepeater.DataSource = items;
        BannerRepeater.DataBind();
    }

    private sealed class BannerItem
    {
        public string ImageUrl { get; set; }
        public string LinkUrl { get; set; }
        public string LinkText { get; set; }
        public string AltText { get; set; }
        public bool ShowLink { get; set; }
    }
}
