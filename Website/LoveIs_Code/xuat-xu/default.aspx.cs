using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web;

public partial class OriginDefault : System.Web.UI.Page
{
    private int _activeOriginId;
    private int _currentPage = 1;
    private const int PageSize = 30;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindOriginPage();
        }
    }

    private void BindOriginPage()
    {
        using (var db = new BeautyStoryContext())
        {
            var slugTypes = new[] { "Origin", "Category", "Product" };
            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => slugTypes.Contains(s.EntityType))
                .ToList();
            var slugLookup = slugs
                .GroupBy(s => s.EntityType)
                .ToDictionary(
                    g => g.Key,
                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            string slug = GetSlugFromRequest();
            if (string.IsNullOrWhiteSpace(slug))
            {
                var firstSlug = slugs.FirstOrDefault(s => s.EntityType == "Origin");
                slug = firstSlug != null ? firstSlug.SeoSlug : string.Empty;
            }

            _activeOriginId = ResolveOriginId(slugLookup, slug);
            if (_activeOriginId == 0)
            {
                OriginTitle.Text = "Xuáº¥t xá»©";
                OriginSubTitle.Text = "KhÃ´ng tÃ¬m tháº¥y xuáº¥t xá»©.";
                OriginProductRepeater.DataSource = new List<object>();
                OriginProductRepeater.DataBind();
                return;
            }

            var origin = db.CfOrigins.AsNoTracking().FirstOrDefault(o => o.Id == _activeOriginId);
            OriginTitle.Text = origin != null ? origin.OriginName : "Xuáº¥t xá»©";
            OriginSubTitle.Text = string.Empty;
            OriginTitleTop.Text = origin != null ? origin.OriginName : "Xuáº¥t xá»©";

            string bannerUrl = origin != null && !string.IsNullOrWhiteSpace(origin.BannerUrl)
                ? origin.BannerUrl
                : "/public/theme/assets/images/slider/22.png";
            OriginBannerImage.ImageUrl = bannerUrl;

            OriginBreadcrumb.Text = BuildOriginBreadcrumb(origin, slugLookup);

            string slugUrl = !string.IsNullOrWhiteSpace(slug) ? "/xuat-xu/" + slug : "/xuat-xu";
            string title = origin != null && !string.IsNullOrWhiteSpace(origin.SeoTitle)
                ? origin.SeoTitle
                : (origin != null ? origin.OriginName : "Xuáº¥t xá»©");
            string description = origin != null && !string.IsNullOrWhiteSpace(origin.SeoDescription)
                ? origin.SeoDescription
                : title;
            string keywords = origin != null && !string.IsNullOrWhiteSpace(origin.SeoKeywords)
                ? origin.SeoKeywords
                : title;
            string siteUrl = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Authority) : string.Empty;
            string canonical = origin != null && !string.IsNullOrWhiteSpace(origin.CanonicalUrl)
                ? origin.CanonicalUrl
                : (siteUrl + slugUrl);
            string robots = origin != null ? origin.Robots : string.Empty;
            string ogTitle = origin != null && !string.IsNullOrWhiteSpace(origin.OgTitle) ? origin.OgTitle : title;
            string ogDescription = origin != null && !string.IsNullOrWhiteSpace(origin.OgDescription) ? origin.OgDescription : description;
            string ogImage = origin != null && !string.IsNullOrWhiteSpace(origin.OgImage) ? origin.OgImage : bannerUrl;
            string ogType = origin != null && !string.IsNullOrWhiteSpace(origin.OgType) ? origin.OgType : "website";
            string twitterTitle = origin != null && !string.IsNullOrWhiteSpace(origin.TwitterTitle) ? origin.TwitterTitle : title;
            string twitterDescription = origin != null && !string.IsNullOrWhiteSpace(origin.TwitterDescription) ? origin.TwitterDescription : description;
            string twitterImage = origin != null && !string.IsNullOrWhiteSpace(origin.TwitterImage) ? origin.TwitterImage : bannerUrl;

            SeoTitleLiteral.Text = HttpUtility.HtmlEncode(title + " | Beauty Story");
            SeoMetaLiteral.Text = string.Join(Environment.NewLine, BuildSeoMeta(canonical, description, keywords, robots, ogTitle, ogDescription, ogImage, ogType, twitterTitle, twitterDescription, twitterImage));

            _currentPage = ParsePage(Request.QueryString["page"]);

            var productQuery = db.CfProducts.AsNoTracking()
                .Where(p => p.Status && p.OriginId == _activeOriginId);

            var totalProducts = productQuery.Count();
            int totalPages = (int)Math.Ceiling(totalProducts / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var pagedProductIds = ProductRanking.Apply(productQuery)
                .Select(p => p.Id)
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var products = db.CfProducts.AsNoTracking()
                .Where(p => pagedProductIds.Contains(p.Id))
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName,
                    CategoryId = p.CategoryId,
                    SortOrder = p.SortOrder
                })
                .ToList();
            var productIds = products.Select(p => p.Id).ToList();
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

            var categoryIds = products.Select(p => p.CategoryId).Distinct().ToList();
            var categoryLookup = db.CfCategories.AsNoTracking()
                .Where(c => c.Status && categoryIds.Contains(c.Id))
                .ToList()
                .ToDictionary(c => c.Id, c => c.CategoryName);

            var variantsByProduct = variants
                .OrderBy(v => v.SortOrder)
                .ToLookup(v => v.ProductId);
            var priceLookup = new Dictionary<int, string>();
            var saleBadgeLookup = new Dictionary<int, string>();
            foreach (var group in variantsByProduct)
            {
                var list = group.ToList();
                priceLookup[group.Key] = FormatPriceHtml(list);
                saleBadgeLookup[group.Key] = BuildSaleBadgeHtml(list);
            }


            var primaryImageLookup = images
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
                        return fallback != null ? fallback.ImageUrl : null;
                    });

            var orderLookup = pagedProductIds
                .Select((id, index) => new { id, index })
                .ToDictionary(x => x.id, x => x.index);
            OriginProductRepeater.DataSource = products
                .OrderBy(p => orderLookup[p.Id])
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categoryLookup.ContainsKey(p.CategoryId) ? categoryLookup[p.CategoryId] : "-",
                    CategorySlug = GetSlug(slugLookup, "Category", p.CategoryId),
                    SeoSlug = GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) && !string.IsNullOrWhiteSpace(primaryImageLookup[p.Id]) ? primaryImageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : "LiÃªn há»‡",
                    SaleBadge = saleBadgeLookup.ContainsKey(p.Id) ? saleBadgeLookup[p.Id] : string.Empty
                })
                .ToList();
            OriginProductRepeater.DataBind();

            RenderPagination(totalPages, slug);

            SchemaLiteral.Text = BuildItemListSchema(
                products.Select(p => new SchemaItem
                {
                    Name = p.ProductName,
                    Url = "/san-pham/" + GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) ? primaryImageLookup[p.Id] : "/images/fav.png"
                }).ToList());
        }
    }

    private static string GetSlug(Dictionary<string, Dictionary<int, string>> lookup, string entityType, int entityId)
    {
        if (!lookup.ContainsKey(entityType))
        {
            return string.Empty;
        }

        var entityLookup = lookup[entityType];
        return entityLookup.ContainsKey(entityId) ? entityLookup[entityId] : string.Empty;
    }

    private static int ResolveOriginId(Dictionary<string, Dictionary<int, string>> lookup, string slug)
    {
        if (!lookup.ContainsKey("Origin"))
        {
            return 0;
        }

        var match = lookup["Origin"].FirstOrDefault(kv => string.Equals(kv.Value, slug, StringComparison.OrdinalIgnoreCase));
        return match.Key;
    }

    private static string GetSlugFromRequest()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return string.Empty;
        }

        var slug = context.Items["slug"] as string;
        if (!string.IsNullOrWhiteSpace(slug))
        {
            return slug;
        }

        var routeSlug = context.Request.RequestContext.RouteData.Values["slug"] as string;
        return routeSlug ?? string.Empty;
    }

    private static int ParsePage(string raw)
    {
        int page = 1;
        if (int.TryParse(raw, out page) && page > 0)
        {
            return page;
        }

        return 1;
    }

    private void RenderPagination(int totalPages, string slug)
    {
        if (totalPages <= 1)
        {
            PaginationLiteral.Text = string.Empty;
            return;
        }

        var links = new List<string>();
        string baseUrl = string.IsNullOrWhiteSpace(slug) ? "/xuat-xu" : "/xuat-xu/" + slug;

        int groupSize = 5;
        int currentGroup = (int)Math.Ceiling(_currentPage / (double)groupSize);
        int groupStart = (currentGroup - 1) * groupSize + 1;
        int groupEnd = Math.Min(groupStart + groupSize - 1, totalPages);

        links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&laquo;</a></li>", BuildPageUrl(baseUrl, 1)));
        if (_currentPage > 1)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&lsaquo;</a></li>", BuildPageUrl(baseUrl, _currentPage - 1)));
        }

        for (int i = groupStart; i <= groupEnd; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<li class=\"page-item active\"><span class=\"page-link\">{0}</span></li>", i));
            }
            else
            {
                links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">{1}</a></li>", BuildPageUrl(baseUrl, i), i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&rsaquo;</a></li>", BuildPageUrl(baseUrl, _currentPage + 1)));
        }
        links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&raquo;</a></li>", BuildPageUrl(baseUrl, totalPages)));

        PaginationLiteral.Text = string.Format("<nav><ul class=\"pagination justify-content-center\">{0}</ul></nav>", string.Join("", links));
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    private static string FormatPriceHtml(List<VariantLite> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return "LiÃªn há»‡";
        }

        var sale = variants.Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();
        var variant = sale ?? variants.OrderBy(v => v.Price).FirstOrDefault();
        if (variant == null)
        {
            return "LiÃªn há»‡";
        }

        if (variant.SalePrice.HasValue && variant.SalePrice.Value > 0 && variant.SalePrice.Value < variant.Price)
        {
            return string.Format("<span class=\"price-old\">{0:N0} Ä‘</span> <span class=\"price-current\">{1:N0} Ä‘</span>", variant.Price, variant.SalePrice.Value);
        }

        return string.Format("<span class=\"price-current\">{0:N0} Ä‘</span>", variant.Price);
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

    private class SchemaItem
    {
        public string Name { get; set; }
        public string Url { get; set; }
        public string ImageUrl { get; set; }
    }

    private sealed class ProductLite
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
        public int CategoryId { get; set; }
        public int SortOrder { get; set; }
    }

    private sealed class ProductImageLite
    {
        public int ProductId { get; set; }
        public string ImageUrl { get; set; }
        public bool IsPrimary { get; set; }
        public int SortOrder { get; set; }
    }

    private sealed class VariantLite
    {
        public int ProductId { get; set; }
        public decimal Price { get; set; }
        public decimal? SalePrice { get; set; }
        public int SortOrder { get; set; }
    }

    private string BuildItemListSchema(List<SchemaItem> items)
    {
        if (items == null || items.Count == 0)
        {
            return string.Empty;
        }

        var list = items.Select((item, index) => new
        {
            @type = "ListItem",
            position = index + 1,
            url = item.Url,
            name = item.Name,
            image = item.ImageUrl
        }).ToList();

        var schema = new
        {
            @context = "https://schema.org",
            @type = "ItemList",
            itemListElement = list
        };

        var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(schema);
        return "<script type=\"application/ld+json\">" + json + "</script>";
    }

    private static IEnumerable<string> BuildSeoMeta(string canonical, string description, string keywords, string robots, string ogTitle, string ogDescription, string ogImage, string ogType, string twitterTitle, string twitterDescription, string twitterImage)
    {
        return new[]
        {
            string.Format("<meta name=\"description\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(description)),
            string.Format("<meta name=\"keywords\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(keywords)),
            string.Format("<meta name=\"robots\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(robots)),
            string.Format("<link rel=\"canonical\" href=\"{0}\" />", HttpUtility.HtmlAttributeEncode(canonical)),
            string.Format("<meta property=\"og:title\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogTitle)),
            string.Format("<meta property=\"og:description\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogDescription)),
            string.Format("<meta property=\"og:image\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogImage)),
            string.Format("<meta property=\"og:type\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogType)),
            string.Format("<meta property=\"og:url\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(canonical)),
            string.Format("<meta name=\"twitter:card\" content=\"summary_large_image\" />"),
            string.Format("<meta name=\"twitter:title\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(twitterTitle)),
            string.Format("<meta name=\"twitter:description\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(twitterDescription)),
            string.Format("<meta name=\"twitter:image\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(twitterImage))
        };
    }

    private static string BuildOriginBreadcrumb(CfOrigin origin, Dictionary<string, Dictionary<int, string>> slugLookup)
    {
        string originName = origin != null ? origin.OriginName : "Xuáº¥t xá»©";

        var links = new List<string>
        {
            "<li class=\"breadcrumb-item\"><a href=\"/\">Trang chá»§</a></li>",
            "<li class=\"breadcrumb-item\"><a href=\"/xuat-xu\">Xuáº¥t xá»©</a></li>",
            string.Format("<li class=\"breadcrumb-item active\" aria-current=\"page\">{0}</li>", HttpUtility.HtmlEncode(originName))
        };

        return string.Join("", links);
    }
}


