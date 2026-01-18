using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class public_controls_trang_chu_BestSellingHomePageNew : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindTrending();
        }
    }

    private void BindTrending()
    {
        using (var db = new BeautyStoryContext())
        {
            var products = ProductRanking.Apply(db.CfProducts.AsNoTracking()
                    .Where(p => p.Status && p.IsTrending))
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName
                })
                .Take(20)
                .ToList();

            if (products.Count == 0)
            {
                TrendingRepeater.DataSource = null;
                TrendingRepeater.DataBind();
                return;
            }

            var productIds = products.Select(p => p.Id).ToList();
            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants.AsNoTracking()
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

            var items = products
                .Select(p =>
                {
                    var priceInfo = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : new PriceInfo();
                    return new TrendingProductView
                    {
                        ProductName = p.ProductName,
                        Url = slugLookup.ContainsKey(p.Id) ? string.Format("/san-pham/{0}", slugLookup[p.Id]) : "/san-pham",
                        ImageUrl = imageLookup.ContainsKey(p.Id) ? imageLookup[p.Id] : "/images/fav.png",
                        PriceHtml = BuildPriceHtml(priceInfo),
                        DiscountBadge = BuildDiscountBadge(priceInfo)
                    };
                })
                .ToList();

            TrendingRepeater.DataSource = items;
            TrendingRepeater.DataBind();
        }
    }

    private static string BuildPriceHtml(PriceInfo priceInfo)
    {
        if (priceInfo.Price <= 0)
        {
            return "Liên hệ";
        }

        if (priceInfo.Sale > 0 && priceInfo.Sale < priceInfo.Price)
        {
            return string.Format("<span>{0}</span><del>{1}</del>", FormatMoney(priceInfo.Sale), FormatMoney(priceInfo.Price));
        }

        return string.Format("<span>{0}</span>", FormatMoney(priceInfo.Price));
    }

    private static string BuildDiscountBadge(PriceInfo priceInfo)
    {
        if (priceInfo.Price <= 0 || priceInfo.Sale <= 0 || priceInfo.Sale >= priceInfo.Price)
        {
            return string.Empty;
        }

        var percent = (int)Math.Round((priceInfo.Price - priceInfo.Sale) / priceInfo.Price * 100m, 0);
        return string.Format("<span class=\"best-selling-sale\">Giảm {0}%</span>", percent);
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private class PriceInfo
    {
        public decimal Price { get; set; }
        public decimal Sale { get; set; }
    }

    private class TrendingProductView
    {
        public string ProductName { get; set; }
        public string Url { get; set; }
        public string ImageUrl { get; set; }
        public string PriceHtml { get; set; }
        public string DiscountBadge { get; set; }
    }

    private class ProductLite
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
    }
}
