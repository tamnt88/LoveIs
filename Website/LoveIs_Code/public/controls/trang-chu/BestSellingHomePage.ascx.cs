using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

public partial class public_controls_trang_chu_BestSellingHomePage : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBestSelling();
        }
    }

    private void BindBestSelling()
    {
        using (var db = new BeautyStoryContext())
        {
            var products = ProductRanking.Apply(db.CfProducts
                .Where(p => p.Status && p.IsBestSelling))
                .Take(12)
                .ToList();

            if (products.Count == 0)
            {
                BestSellingRepeater.DataSource = null;
                BestSellingRepeater.DataBind();
                return;
            }

            var productIds = products.Select(p => p.Id).ToList();
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);
            var imageLookup = images
                .GroupBy(i => i.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g =>
                    {
                        var primary = g.FirstOrDefault(i => i.IsPrimary);
                        if (primary != null)
                        {
                            return primary.ImageUrl;
                        }
                        var fallback = g.FirstOrDefault();
                        return fallback != null ? fallback.ImageUrl : "/images/fav.png";
                    });

            var priceLookup = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g =>
                    {
                        var prices = g
                            .Where(v => v.Price > 0)
                            .Select(v => new
                            {
                                Price = v.Price,
                                Sale = v.SalePrice.HasValue ? v.SalePrice.Value : 0
                            })
                            .ToList();

                        if (prices.Count == 0)
                        {
                            return new PriceInfo();
                        }

                        var best = prices
                            .OrderBy(p => p.Sale > 0 && p.Sale < p.Price ? p.Sale : p.Price)
                            .First();

                        return new PriceInfo
                        {
                            Price = best.Price,
                            Sale = best.Sale
                        };
                    });

            var items = products.Select(p =>
            {
                var priceInfo = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : new PriceInfo();
                var priceHtml = BuildPriceHtml(priceInfo);
                var badge = BuildDiscountBadge(priceInfo);
                return new
                {
                    ProductName = p.ProductName,
                    Url = slugLookup.ContainsKey(p.Id) ? string.Format("/san-pham/{0}", slugLookup[p.Id]) : "/san-pham",
                    ImageUrl = imageLookup.ContainsKey(p.Id) ? imageLookup[p.Id] : "/images/fav.png",
                    PriceHtml = priceHtml,
                    DiscountBadge = badge
                };
            }).ToList();

            BestSellingRepeater.DataSource = items;
            BestSellingRepeater.DataBind();
        }
    }

    private static string BuildPriceHtml(PriceInfo priceInfo)
    {
        if (priceInfo.Price <= 0)
        {
            return "Lien he";
        }

        if (priceInfo.Sale > 0 && priceInfo.Sale < priceInfo.Price)
        {
            return string.Format("<ins>{0}</ins><del>{1}</del>", FormatMoney(priceInfo.Sale), FormatMoney(priceInfo.Price));
        }

        return string.Format("<ins>{0}</ins>", FormatMoney(priceInfo.Price));
    }

    private static string BuildDiscountBadge(PriceInfo priceInfo)
    {
        if (priceInfo.Price <= 0 || priceInfo.Sale <= 0 || priceInfo.Sale >= priceInfo.Price)
        {
            return string.Empty;
        }

        var percent = (int)Math.Round((priceInfo.Price - priceInfo.Sale) / priceInfo.Price * 100m, 0);
        return string.Format("<div class=\"on-sale\">- {0}%</div>", percent);
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} d", value);
    }

    private class PriceInfo
    {
        public decimal Price { get; set; }
        public decimal Sale { get; set; }
    }
}
