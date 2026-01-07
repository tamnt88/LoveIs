using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class public_controls_trang_chu_TrendingHomePage : System.Web.UI.UserControl
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
            var trendingProducts = ProductRanking.Apply(db.CfProducts.AsNoTracking()
                .Where(p => p.Status && p.IsTrending && p.CategoryId > 0))
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName,
                    CategoryId = p.CategoryId
                })
                .ToList();

            if (trendingProducts.Count == 0)
            {
                TrendingTabRepeater.DataSource = null;
                TrendingTabRepeater.DataBind();
                TrendingPanelRepeater.DataSource = null;
                TrendingPanelRepeater.DataBind();
                return;
            }

            var categoryIds = trendingProducts.Select(p => p.CategoryId).Distinct().ToList();
            var categories = db.CfCategories.AsNoTracking()
                .Where(c => c.Status && categoryIds.Contains(c.Id))
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            var productIds = trendingProducts.Select(p => p.Id).ToList();
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

            var orderLookup = trendingProducts
                .Select((p, index) => new { p.Id, index })
                .ToDictionary(x => x.Id, x => x.index);

            var productsLookup = trendingProducts
                .GroupBy(p => p.CategoryId)
                .ToDictionary(
                    g => g.Key,
                    g => g
                        .OrderBy(p => orderLookup.ContainsKey(p.Id) ? orderLookup[p.Id] : int.MaxValue)
                        .Take(10)
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
                        .ToList());

            var items = new List<TrendingCategoryView>();
            foreach (var category in categories)
            {
                var list = productsLookup.ContainsKey(category.Id)
                    ? productsLookup[category.Id]
                    : new List<TrendingProductView>();

                if (list.Count == 0)
                {
                    continue;
                }

                items.Add(new TrendingCategoryView
                {
                    CategoryId = category.Id,
                    CategoryName = category.CategoryName,
                    Products = list
                });
            }

            TrendingTabRepeater.DataSource = items;
            TrendingTabRepeater.DataBind();
            TrendingPanelRepeater.DataSource = items;
            TrendingPanelRepeater.DataBind();
        }
    }

    protected void TrendingPanelRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        var view = e.Item.DataItem as TrendingCategoryView;
        if (view == null)
        {
            return;
        }

        var repeater = e.Item.FindControl("TrendingProductRepeater") as Repeater;
        if (repeater == null)
        {
            return;
        }

        repeater.DataSource = view.Products;
        repeater.DataBind();
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

    private class TrendingCategoryView
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public List<TrendingProductView> Products { get; set; }
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
        public int CategoryId { get; set; }
    }
}

