using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public partial class SearchSuggest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentType = "application/json";
        Response.Charset = "utf-8";

        string query = (Request.QueryString["q"] ?? string.Empty).Trim();
        if (query.Length < 2)
        {
            Response.Write("[]");
            return;
        }

        string cacheKey = "search_suggest_" + query.ToLowerInvariant();
        var result = PublicCache.GetOrCreate(cacheKey, 1, () => BuildSuggest(query));
        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        Response.Write(serializer.Serialize(result));
    }

    private static List<SuggestItem> BuildSuggest(string query)
    {
        using (var db = new BeautyStoryContext())
        {
            var products = ProductRanking.Apply(db.CfProducts
                .Where(p => p.Status && p.ProductName.Contains(query)))
                .Select(p => new { p.Id, p.ProductName })
                .Take(8)
                .ToList();

            if (products.Count == 0)
            {
                return new List<SuggestItem>();
            }

            var productIds = products.Select(p => p.Id).ToList();
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
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

            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();
            var priceLookup = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g =>
                    {
                        var sale = g.Where(v => v.SalePrice.HasValue).OrderBy(v => v.SalePrice.Value).FirstOrDefault();
                        var variant = sale ?? g.OrderBy(v => v.Price).FirstOrDefault();
                        if (variant == null)
                        {
                            return "Liên hệ";
                        }
                        var price = variant.SalePrice.HasValue ? variant.SalePrice.Value : variant.Price;
                        return string.Format("{0:N0} đ", price);
                    });

            return products
                .Select(p => new SuggestItem
                {
                    Name = p.ProductName,
                    Slug = slugLookup.ContainsKey(p.Id) ? slugLookup[p.Id] : "",
                    ImageUrl = imageLookup.ContainsKey(p.Id) ? imageLookup[p.Id] : "/images/fav.png",
                    Price = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : "Liên hệ"
                })
                .Where(x => !string.IsNullOrWhiteSpace(x.Slug))
                .ToList();
        }
    }

    private class SuggestItem
    {
        public string Name { get; set; }
        public string Slug { get; set; }
        public string ImageUrl { get; set; }
        public string Price { get; set; }
    }
}
