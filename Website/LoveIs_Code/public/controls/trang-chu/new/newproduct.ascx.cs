using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

public partial class public_controls_trang_chu_new_newproduct : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindNewProducts();
        }
    }

    private void BindNewProducts()
    {
        using (var db = new BeautyStoryContext())
        {
            var productQuery = db.CfProducts.AsNoTracking()
                .Where(p => p.Status && p.IsBestSelling);

            var products = ProductRanking.Apply(productQuery)
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName
                })
                .Take(25)
                .ToList();

            if (products.Count == 0)
            {
                products = ProductRanking.Apply(db.CfProducts.AsNoTracking().Where(p => p.Status))
                    .Select(p => new ProductLite
                    {
                        Id = p.Id,
                        ProductName = p.ProductName
                    })
                    .Take(25)
                    .ToList();
            }

            if (products.Count == 0)
            {
                NewProductRepeater.DataSource = null;
                NewProductRepeater.DataBind();
                return;
            }

            var productIds = products.Select(p => p.Id).ToList();
            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .Select(i => new ProductImageLite
                {
                    ProductId = i.ProductId,
                    ImageUrl = i.ImageUrl,
                    IsPrimary = i.IsPrimary,
                    SortOrder = i.SortOrder
                })
                .ToList();

            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .Select(v => new VariantLite
                {
                    ProductId = v.ProductId,
                    Price = v.Price,
                    SalePrice = v.SalePrice,
                    SortOrder = v.SortOrder
                })
                .ToList();

            var imageLookup = new Dictionary<int, string>();
            foreach (var group in images.GroupBy(i => i.ProductId))
            {
                var primary = group.FirstOrDefault(i => i.IsPrimary);
                if (primary != null)
                {
                    imageLookup[group.Key] = primary.ImageUrl;
                    continue;
                }
                var fallback = group.FirstOrDefault();
                if (fallback != null)
                {
                    imageLookup[group.Key] = fallback.ImageUrl;
                }
            }

            var variantsByProduct = variants.OrderBy(v => v.SortOrder).ToLookup(v => v.ProductId);
            var priceLookup = new Dictionary<int, string>();
            var saleBadgeLookup = new Dictionary<int, string>();
            foreach (var group in variantsByProduct)
            {
                var list = group.ToList();
                priceLookup[group.Key] = FormatPriceHtml(list);
                saleBadgeLookup[group.Key] = BuildSaleBadgeHtml(list);
            }

            var likedProductIds = new HashSet<int>();
            var customerId = CustomerAuth.GetCustomerId();
            if (customerId.HasValue && productIds.Count > 0)
            {
                likedProductIds = db.CfWishlists.AsNoTracking()
                    .Where(w => w.CustomerId == customerId.Value && productIds.Contains(w.ProductId))
                    .Select(w => w.ProductId)
                    .ToHashSet();
            }

            NewProductRepeater.DataSource = products
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    SeoSlug = slugLookup.ContainsKey(p.Id) ? slugLookup[p.Id] : string.Empty,
                    ImageUrl = imageLookup.ContainsKey(p.Id) && !string.IsNullOrWhiteSpace(imageLookup[p.Id]) ? imageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : "Liên hệ",
                    SaleBadge = saleBadgeLookup.ContainsKey(p.Id) ? saleBadgeLookup[p.Id] : string.Empty,
                    WishlistClass = likedProductIds.Contains(p.Id) ? "is-active" : string.Empty,
                    WishlistIconClass = likedProductIds.Contains(p.Id) ? "fa-solid fa-heart" : "fa-regular fa-heart"
                })
                .Where(p => !string.IsNullOrWhiteSpace(p.SeoSlug))
                .ToList();

            NewProductRepeater.DataBind();
        }
    }

    private static string FormatPriceHtml(List<VariantLite> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return "Liên hệ";
        }
        var sale = variants
            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();
        var variant = sale ?? variants.OrderBy(v => v.Price).FirstOrDefault();
        if (variant == null)
        {
            return "Liên hệ";
        }
        if (variant.SalePrice.HasValue && variant.SalePrice.Value > 0 && variant.SalePrice.Value < variant.Price)
        {
            return string.Format("<span class=\"price-old\">{0:N0} đ</span> <span class=\"price-current\">{1:N0} đ</span>", variant.Price, variant.SalePrice.Value);
        }
        return string.Format("<span class=\"price-current\">{0:N0} đ</span>", variant.Price);
    }

    private static string BuildSaleBadgeHtml(List<VariantLite> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return string.Empty;
        }
        var saleVariant = variants
            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderByDescending(v => (v.Price - v.SalePrice.Value) / v.Price)
            .FirstOrDefault();
        if (saleVariant == null)
        {
            return string.Empty;
        }
        var percent = (int)Math.Round((saleVariant.Price - saleVariant.SalePrice.Value) / saleVariant.Price * 100m, 0);
        if (percent <= 0)
        {
            return string.Empty;
        }
        return string.Format("<span class=\"sale-badge\">-{0}%</span>", percent);
    }

    private class ProductLite
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
    }

    private class ProductImageLite
    {
        public int ProductId { get; set; }
        public string ImageUrl { get; set; }
        public bool IsPrimary { get; set; }
        public int SortOrder { get; set; }
    }

    private class VariantLite
    {
        public int ProductId { get; set; }
        public decimal Price { get; set; }
        public decimal? SalePrice { get; set; }
        public int SortOrder { get; set; }
    }
}
