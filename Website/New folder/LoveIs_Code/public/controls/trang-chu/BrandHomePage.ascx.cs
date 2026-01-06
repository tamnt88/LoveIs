using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class public_controls_trang_chu_BrandHomePage : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindShowcases();
        }
    }

    protected void ShowcaseRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        var showcase = e.Item.DataItem as BrandShowcaseView;
        if (showcase == null)
        {
            return;
        }

        var bannerRepeater = e.Item.FindControl("ShowcaseBannerRepeater") as Repeater;
        if (bannerRepeater == null)
        {
            return;
        }

        bannerRepeater.DataSource = showcase.Banners;
        bannerRepeater.DataBind();
    }

    private void BindShowcases()
    {
        List<BrandShowcaseView> result = new List<BrandShowcaseView>();
        using (var db = new BeautyStoryContext())
        {
            var showcases = db.CfBrandShowcases
                .Where(s => s.Status)
                .OrderBy(s => s.SortOrder)
                .ThenBy(s => s.Id)
                .ToList();

            if (showcases.Count == 0)
            {
                ShowcaseRepeater.DataSource = result;
                ShowcaseRepeater.DataBind();
                return;
            }

            var showcaseIds = showcases.Select(s => s.Id).ToList();
            var brandIds = showcases.Select(s => s.BrandId).Distinct().ToList();

            var brandLookup = db.CfBrands
                .Where(b => brandIds.Contains(b.Id))
                .ToDictionary(b => b.Id, b => b.BrandName);

            var slugLookup = db.CfSeoSlugs
                .Where(s => s.EntityType == "Brand" && brandIds.Contains(s.EntityId))
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var banners = db.CfBrandShowcaseBanners
                .Where(b => b.Status && showcaseIds.Contains(b.ShowcaseId))
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.Id)
                .ToList();

            var bannerLookup = banners
                .GroupBy(b => b.ShowcaseId)
                .ToDictionary(g => g.Key, g => g.Select(b => new BrandShowcaseBannerView
                {
                    TitleLine1 = b.TitleLine1 ?? string.Empty,
                    TitleLine2 = b.TitleLine2 ?? string.Empty,
                    TitleLine3 = b.TitleLine3 ?? string.Empty,
                    ImageUrl = string.IsNullOrWhiteSpace(b.ImageUrl) ? "/public/theme/assets/images/banner/59.png" : b.ImageUrl,
                    LinkUrl = string.IsNullOrWhiteSpace(b.LinkUrl) ? "#" : b.LinkUrl,
                    LinkText = string.IsNullOrWhiteSpace(b.LinkText) ? "Xem thêm" : b.LinkText,
                    ShowLink = b.ShowLink
                }).Take(4).ToList());

            foreach (var showcase in showcases)
            {
                string brandName;
                brandLookup.TryGetValue(showcase.BrandId, out brandName);
                if (string.IsNullOrWhiteSpace(brandName))
                {
                    brandName = "Thương hiệu";
                }

                string slug;
                slugLookup.TryGetValue(showcase.BrandId, out slug);
                if (string.IsNullOrWhiteSpace(slug))
                {
                    slug = "thuong-hieu-" + showcase.BrandId;
                }

                List<BrandShowcaseBannerView> bannerItems;
                if (!bannerLookup.TryGetValue(showcase.Id, out bannerItems))
                {
                    bannerItems = new List<BrandShowcaseBannerView>();
                }

                result.Add(new BrandShowcaseView
                {
                    Id = showcase.Id,
                    BrandName = brandName,
                    BrandUrl = "/thuong-hieu/" + slug,
                    Title = string.IsNullOrWhiteSpace(showcase.Title) ? null : showcase.Title,
                    VideoUrl = string.IsNullOrWhiteSpace(showcase.VideoUrl) ? string.Empty : showcase.VideoUrl,
                    HasVideo = !string.IsNullOrWhiteSpace(showcase.VideoUrl),
                    PosterUrl = "/public/theme/assets/images/banner/58.png",
                    Banners = bannerItems
                });
            }
        }

        ShowcaseRepeater.DataSource = result;
        ShowcaseRepeater.DataBind();
    }

    private sealed class BrandShowcaseView
    {
        public int Id { get; set; }
        public string BrandName { get; set; }
        public string BrandUrl { get; set; }
        public string Title { get; set; }
        public string VideoUrl { get; set; }
        public bool HasVideo { get; set; }
        public string PosterUrl { get; set; }
        public List<BrandShowcaseBannerView> Banners { get; set; }
    }

    private sealed class BrandShowcaseBannerView
    {
        public string TitleLine1 { get; set; }
        public string TitleLine2 { get; set; }
        public string TitleLine3 { get; set; }
        public string ImageUrl { get; set; }
        public string LinkUrl { get; set; }
        public string LinkText { get; set; }
        public bool ShowLink { get; set; }
    }
}
