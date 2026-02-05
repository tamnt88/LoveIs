using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web.UI;

public partial class public_controls_trang_chu_new_topcollection : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindTopCollection();
        }
    }

    private void BindTopCollection()
    {
        using (var db = new BeautyStoryContext())
        {
            var products = ProductRanking.Apply(db.CfProducts.AsNoTracking()
                    .Where(p => p.Status && (p.IsNewArrival || p.IsTrending)))
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName,
                    ShopId = p.ShopId
                })
                .Take(12)
                .ToList();
            if (products.Count == 0)
            {
                products = ProductRanking.Apply(db.CfProducts.AsNoTracking()
                        .Where(p => p.Status))
                    .Select(p => new ProductLite
                    {
                        Id = p.Id,
                        ProductName = p.ProductName,
                        ShopId = p.ShopId
                    })
                    .Take(12)
                    .ToList();
            }
            if (products.Count == 0)
            {
                TopCollectionRepeater.DataSource = null;
                TopCollectionRepeater.DataBind();
                return;
            }

            var productIds = products.Select(p => p.Id).ToList();
            var shopIds = products.Where(p => p.ShopId.HasValue).Select(p => p.ShopId.Value).Distinct().ToList();
            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();
            var likedProductIds = new HashSet<int>();
            var customerId = CustomerAuth.GetCustomerId();
            if (customerId.HasValue && productIds.Count > 0)
            {
                likedProductIds = db.CfWishlists.AsNoTracking()
                    .Where(w => w.CustomerId == customerId.Value && productIds.Contains(w.ProductId))
                    .Select(w => w.ProductId)
                    .ToHashSet();
            }
            var shops = shopIds.Count > 0
                ? db.CfShops.AsNoTracking()
                    .Where(s => shopIds.Contains(s.Id))
                    .ToList()
                : new List<CfShop>();
            var provinceIds = shops.Where(s => s.ProvinceId.HasValue).Select(s => s.ProvinceId.Value).Distinct().ToList();
            var provinces = provinceIds.Count > 0
                ? db.CfProvinces.AsNoTracking()
                    .Where(p => provinceIds.Contains(p.Id))
                    .ToDictionary(p => p.Id, p => p.ProvinceName)
                : new Dictionary<int, string>();

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
                string provinceName = "Toàn quốc";
                if (p.ShopId.HasValue)
                {
                    var shop = shops.FirstOrDefault(s => s.Id == p.ShopId.Value);
                    if (shop != null)
                    {
                        if (!string.IsNullOrWhiteSpace(shop.ProvinceName))
                        {
                            provinceName = shop.ProvinceName;
                        }
                        else if (shop.ProvinceId.HasValue && provinces.ContainsKey(shop.ProvinceId.Value))
                        {
                            provinceName = provinces[shop.ProvinceId.Value];
                        }
                    }
                }
                return new TopCollectionView
                {
                    ProductId = p.Id,
                    ProductName = p.ProductName,
                    Url = slugLookup.ContainsKey(p.Id) ? string.Format("/san-pham/{0}", slugLookup[p.Id]) : "/san-pham",
                    ImageUrl = imageLookup.ContainsKey(p.Id) ? imageLookup[p.Id] : "/images/fav.png",
                    PriceText = FormatMoney(priceInfo.Sale > 0 && priceInfo.Sale < priceInfo.Price ? priceInfo.Sale : priceInfo.Price),
                    DiscountText = BuildDiscountText(priceInfo),
                    SaleBadge = BuildSaleBadgeHtml(priceInfo),
                    ProvinceName = provinceName,
                    WishlistClass = likedProductIds.Contains(p.Id) ? "is-active" : string.Empty,
                    WishlistIconClass = likedProductIds.Contains(p.Id) ? "fa-solid fa-heart" : "fa-regular fa-heart"
                };
            }).ToList();

            TopCollectionRepeater.DataSource = items;
            TopCollectionRepeater.DataBind();
        }
    }

    private static string BuildDiscountText(PriceInfo priceInfo)
    {
        if (priceInfo.Price <= 0 || priceInfo.Sale <= 0 || priceInfo.Sale >= priceInfo.Price)
        {
            return string.Empty;
        }
        var percent = (int)Math.Round((priceInfo.Price - priceInfo.Sale) / priceInfo.Price * 100m, 0);
        return string.Format("-{0}%", percent);
    }

    private static string FormatMoney(decimal value)
    {
        if (value <= 0)
        {
            return "Liên hệ";
        }
        return string.Format("{0:N0} đ", value);
    }

    private static string BuildSaleBadgeHtml(PriceInfo priceInfo)
    {
        if (priceInfo.Price <= 0 || priceInfo.Sale <= 0 || priceInfo.Sale >= priceInfo.Price)
        {
            return string.Empty;
        }
        var percent = (int)Math.Round((priceInfo.Price - priceInfo.Sale) / priceInfo.Price * 100m, 0);
        if (percent <= 0)
        {
            return string.Empty;
        }
        return string.Format("<span class=\"sale-badge\">-{0}%</span>", percent);
    }

    private class PriceInfo
    {
        public decimal Price { get; set; }
        public decimal Sale { get; set; }
    }

    private class ProductLite
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
        public int? ShopId { get; set; }
    }

    private class TopCollectionView
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Url { get; set; }
        public string ImageUrl { get; set; }
        public string PriceText { get; set; }
        public string DiscountText { get; set; }
        public string SaleBadge { get; set; }
        public string ProvinceName { get; set; }
        public string WishlistClass { get; set; }
        public string WishlistIconClass { get; set; }
    }
}
