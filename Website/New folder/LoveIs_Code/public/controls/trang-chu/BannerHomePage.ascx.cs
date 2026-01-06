using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

public partial class public_controls_trang_chu_BannerHomePage : System.Web.UI.UserControl
{
    protected string VideoUrl { get; private set; }
    protected string VideoPosterUrl { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBanners();
        }
    }

    private void BindBanners()
    {
        List<BannerSlide> slides;
        using (var db = new BeautyStoryContext())
        {
            var banners = db.CfBanners
                .Where(b => b.Status && b.Position == "1")
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .ToList();

            var videoBanner = banners.FirstOrDefault(b =>
                string.Equals(b.MediaType, "Video", StringComparison.OrdinalIgnoreCase)
                && !string.IsNullOrWhiteSpace(b.MediaUrl));

            if (videoBanner != null)
            {
                var posterFallback = string.IsNullOrWhiteSpace(videoBanner.ImageUrl)
                    ? "/public/theme/assets/images/slider/22.png"
                    : videoBanner.ImageUrl;

                VideoUrl = videoBanner.MediaUrl;
                VideoPosterUrl = string.IsNullOrWhiteSpace(videoBanner.PosterUrl)
                    ? posterFallback
                    : videoBanner.PosterUrl;

                VideoOnlyPanel.Visible = true;
                SliderPanel.Visible = false;
                return;
            }

            VideoOnlyPanel.Visible = false;
            SliderPanel.Visible = true;

            slides = banners
                .Select(b =>
                {
                    var mediaType = string.IsNullOrWhiteSpace(b.MediaType) ? "Image" : b.MediaType;
                    var imageUrl = string.IsNullOrWhiteSpace(b.ImageUrl) ? "/public/theme/assets/images/slider/22.png" : b.ImageUrl;
                    var mediaUrl = string.IsNullOrWhiteSpace(b.MediaUrl) ? imageUrl : b.MediaUrl;
                    var posterUrl = string.IsNullOrWhiteSpace(b.PosterUrl) ? imageUrl : b.PosterUrl;
                    bool isVideo = string.Equals(mediaType, "Video", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrWhiteSpace(mediaUrl);

                    return new BannerSlide
                    {
                        TitleLine1 = string.IsNullOrWhiteSpace(b.TitleLine1) ? "Deal Upto 30%" : b.TitleLine1,
                        TitleLine2 = string.IsNullOrWhiteSpace(b.TitleLine2) ? "Beauty Care" : b.TitleLine2,
                        TitleLine3 = string.IsNullOrWhiteSpace(b.TitleLine3) ? "Price Starting<br>From <span class=\"text-primary font-600 font-large\"> $29.99</span>" : b.TitleLine3,
                        ImageUrl = imageUrl,
                        MediaUrl = mediaUrl,
                        PosterUrl = posterUrl,
                        IsVideo = isVideo,
                        LinkUrl = string.IsNullOrWhiteSpace(b.LinkUrl) ? "#" : b.LinkUrl,
                        LinkText = string.IsNullOrWhiteSpace(b.LinkText) ? "SHOP NOW" : b.LinkText,
                        ShowLink = b.ShowLink
                    };
                })
                .ToList();
        }

        if (slides.Count == 0)
        {
            slides.Add(new BannerSlide
            {
                TitleLine1 = "Deal Upto 30%",
                TitleLine2 = "Beauty Care",
                TitleLine3 = "Price Starting<br>From <span class=\"text-primary font-600 font-large\"> $29.99</span>",
                ImageUrl = "/public/theme/assets/images/slider/22.png",
                MediaUrl = "/public/theme/assets/images/slider/22.png",
                PosterUrl = "/public/theme/assets/images/slider/22.png",
                IsVideo = false,
                LinkUrl = "#",
                LinkText = "SHOP NOW",
                ShowLink = true
            });
        }

        BannerRepeater.DataSource = slides;
        BannerRepeater.DataBind();
    }

    private sealed class BannerSlide
    {
        public string TitleLine1 { get; set; }
        public string TitleLine2 { get; set; }
        public string TitleLine3 { get; set; }
        public string ImageUrl { get; set; }
        public string MediaUrl { get; set; }
        public string PosterUrl { get; set; }
        public bool IsVideo { get; set; }
        public string LinkUrl { get; set; }
        public string LinkText { get; set; }
        public bool ShowLink { get; set; }
    }
}
