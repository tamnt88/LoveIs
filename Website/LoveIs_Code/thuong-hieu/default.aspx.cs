using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public partial class BrandDefault : System.Web.UI.Page
{
    private int _activeBrandId;
    private int _currentPage = 1;
    private const int PageSize = 30;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBrandPage();
        }
    }

    private void BindBrandPage()
    {
        using (var db = new BeautyStoryContext())
        {
            var slugs = db.CfSeoSlugs.ToList();
            var slugLookup = slugs
                .GroupBy(s => s.EntityType)
                .ToDictionary(
                    g => g.Key,
                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            string slug = GetSlugFromRequest();
            if (string.IsNullOrWhiteSpace(slug))
            {
                var firstSlug = slugs.FirstOrDefault(s => s.EntityType == "Brand");
                slug = firstSlug != null ? firstSlug.SeoSlug : string.Empty;
            }

            _activeBrandId = ResolveBrandId(slugLookup, slug);
            if (_activeBrandId == 0)
            {
                BrandTitle.Text = "Thương hiệu";
                BrandSubTitle.Text = "Không tìm thấy thương hiệu.";
                BrandProductRepeater.DataSource = new List<object>();
                BrandProductRepeater.DataBind();
                return;
            }

            var brand = db.CfBrands.FirstOrDefault(b => b.Id == _activeBrandId);
            BrandTitle.Text = brand != null ? brand.BrandName : "Thương hiệu";
            BrandSubTitle.Text = string.Empty;
            BrandTitleTop.Text = brand != null ? brand.BrandName : "Thương hiệu";

            string bannerUrl = brand != null && !string.IsNullOrWhiteSpace(brand.BannerUrl)
                ? brand.BannerUrl
                : "/public/theme/assets/images/slider/22.png";
            BrandBannerImage.ImageUrl = bannerUrl;

            BrandBreadcrumb.Text = BuildBrandBreadcrumb(brand, slugLookup);

            string slugUrl = !string.IsNullOrWhiteSpace(slug) ? "/thuong-hieu/" + slug : "/thuong-hieu";
            string title = brand != null && !string.IsNullOrWhiteSpace(brand.SeoTitle)
                ? brand.SeoTitle
                : (brand != null ? brand.BrandName : "Thương hiệu");
            string description = brand != null && !string.IsNullOrWhiteSpace(brand.SeoDescription)
                ? brand.SeoDescription
                : title;
            string keywords = brand != null && !string.IsNullOrWhiteSpace(brand.SeoKeywords)
                ? brand.SeoKeywords
                : title;
            string siteUrl = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Authority) : string.Empty;
            string canonical = brand != null && !string.IsNullOrWhiteSpace(brand.CanonicalUrl)
                ? brand.CanonicalUrl
                : (siteUrl + slugUrl);
            string robots = brand != null ? brand.Robots : string.Empty;
            string ogTitle = brand != null && !string.IsNullOrWhiteSpace(brand.OgTitle) ? brand.OgTitle : title;
            string ogDescription = brand != null && !string.IsNullOrWhiteSpace(brand.OgDescription) ? brand.OgDescription : description;
            string ogImage = brand != null && !string.IsNullOrWhiteSpace(brand.OgImage) ? brand.OgImage : bannerUrl;
            string ogType = brand != null && !string.IsNullOrWhiteSpace(brand.OgType) ? brand.OgType : "website";
            string twitterTitle = brand != null && !string.IsNullOrWhiteSpace(brand.TwitterTitle) ? brand.TwitterTitle : title;
            string twitterDescription = brand != null && !string.IsNullOrWhiteSpace(brand.TwitterDescription) ? brand.TwitterDescription : description;
            string twitterImage = brand != null && !string.IsNullOrWhiteSpace(brand.TwitterImage) ? brand.TwitterImage : bannerUrl;

            SeoTitleLiteral.Text = HttpUtility.HtmlEncode(title + " | LoveIs Store");
            SeoMetaLiteral.Text = string.Join(Environment.NewLine, BuildSeoMeta(canonical, description, keywords, robots, ogTitle, ogDescription, ogImage, ogType, twitterTitle, twitterDescription, twitterImage));

            _currentPage = ParsePage(Request.QueryString["page"]);

            var productQuery = db.CfProducts
                .Where(p => p.Status && p.BrandId == _activeBrandId);

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

            var products = db.CfProducts
                .Where(p => pagedProductIds.Contains(p.Id))
                .ToList();
            var productIds = products.Select(p => p.Id).ToList();
            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            var categoryLookup = db.CfCategories
                .Where(c => c.Status)
                .ToList()
                .ToDictionary(c => c.Id, c => c.CategoryName);

            var priceLookup = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g => FormatPriceHtml(g.ToList()));
            var saleBadgeLookup = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g => BuildSaleBadgeHtml(g.ToList()));


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

            BrandProductRepeater.DataSource = products
                .OrderBy(p => pagedProductIds.IndexOf(p.Id))
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categoryLookup.ContainsKey(p.CategoryId) ? categoryLookup[p.CategoryId] : "-",
                    CategorySlug = GetSlug(slugLookup, "Category", p.CategoryId),
                    SeoSlug = GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) && !string.IsNullOrWhiteSpace(primaryImageLookup[p.Id]) ? primaryImageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : "Liên hệ",
                    SaleBadge = saleBadgeLookup.ContainsKey(p.Id) ? saleBadgeLookup[p.Id] : string.Empty
                })
                .ToList();
            BrandProductRepeater.DataBind();

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

    private static int ResolveBrandId(Dictionary<string, Dictionary<int, string>> lookup, string slug)
    {
        if (!lookup.ContainsKey("Brand"))
        {
            return 0;
        }

        var match = lookup["Brand"].FirstOrDefault(kv => string.Equals(kv.Value, slug, StringComparison.OrdinalIgnoreCase));
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
        string baseUrl = string.IsNullOrWhiteSpace(slug) ? "/thuong-hieu" : "/thuong-hieu/" + slug;

        int groupSize = 5;
        int totalGroups = (int)Math.Ceiling(totalPages / (double)groupSize);
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

    private static string FormatPriceHtml(List<CfProductVariant> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return "Liên hệ";
        }

        var sale = variants.Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
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

    private static string BuildBrandBreadcrumb(CfBrand brand, Dictionary<string, Dictionary<int, string>> slugLookup)
    {
        string brandSlug = brand != null ? GetSlug(slugLookup, "Brand", brand.Id) : string.Empty;
        string brandName = brand != null ? brand.BrandName : "Thương hiệu";

        var links = new List<string>
        {
            "<li class=\"breadcrumb-item\"><a href=\"/\">Trang chủ</a></li>",
            "<li class=\"breadcrumb-item\"><a href=\"/thuong-hieu\">Thương hiệu</a></li>",
            string.Format("<li class=\"breadcrumb-item active\" aria-current=\"page\">{0}</li>", HttpUtility.HtmlEncode(brandName))
        };

        return string.Join("", links);
    }

    private static string BuildSaleBadgeHtml(List<CfProductVariant> variants)
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
}
