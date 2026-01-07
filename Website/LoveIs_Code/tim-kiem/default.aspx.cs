using System;
using System.Linq;
using System.Data.Entity;
using System.Collections.Generic;

public partial class SearchDefault : System.Web.UI.Page
{
    private const int PageSize = 30;
    private int _currentPage = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ApplySeo();
            BindSearch();
        }
    }

    private void ApplySeo()
    {
        string canonical = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Path) : string.Empty;
        SystemPageSeoApplier.Apply("search", SeoTitleLiteral, SeoMetaLiteral, "Tìm kiếm | LoveIs Store", canonical);
    }

    private void BindSearch()
    {
        string query = (Request.QueryString["q"] ?? string.Empty).Trim();
        _currentPage = ParsePage(Request.QueryString["page"]);
        if (string.IsNullOrWhiteSpace(query))
        {
            SearchSummary.Text = "Vui lòng nhập từ khóa để tìm kiếm.";
            EmptyResultPanel.Visible = true;
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var productQuery = db.CfProducts.AsNoTracking()
                .Where(p => p.Status && p.ProductName.Contains(query));

            var totalProducts = productQuery.Count();
            SearchSummary.Text = "Từ khóa: " + query + " - " + totalProducts + " sản phẩm";
            if (totalProducts == 0)
            {
                EmptyResultPanel.Visible = true;
                return;
            }

            int totalPages = (int)Math.Ceiling(totalProducts / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var products = ProductRanking.Apply(productQuery)
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName,
                    CategoryId = p.CategoryId
                })
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var productIds = products.Select(p => p.Id).ToList();
            var categoryIds = products.Select(p => p.CategoryId).Distinct().ToList();
            var categories = db.CfCategories.AsNoTracking()
                .Where(c => categoryIds.Contains(c.Id))
                .Select(c => new { c.Id, c.CategoryName })
                .ToList()
                .ToDictionary(c => c.Id, c => c.CategoryName);
            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();
            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => (s.EntityType == "Product" && productIds.Contains(s.EntityId))
                            || (s.EntityType == "Category" && categoryIds.Contains(s.EntityId)))
                .ToList();
            var productSlugs = slugs.Where(s => s.EntityType == "Product").ToDictionary(s => s.EntityId, s => s.SeoSlug);
            var categorySlugs = slugs.Where(s => s.EntityType == "Category").ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var primaryImageLookup = new Dictionary<int, string>();
            foreach (var group in images.GroupBy(i => i.ProductId))
            {
                var primary = group.FirstOrDefault(i => i.IsPrimary);
                if (primary != null)
                {
                    primaryImageLookup[group.Key] = primary.ImageUrl;
                    continue;
                }
                var fallback = group.FirstOrDefault();
                if (fallback != null)
                {
                    primaryImageLookup[group.Key] = fallback.ImageUrl;
                }
            }

            var variantsByProduct = variants.ToLookup(v => v.ProductId);
            var variantSummaryLookup = new Dictionary<int, VariantSummary>();
            foreach (var group in variantsByProduct)
            {
                var list = group.ToList();
                variantSummaryLookup[group.Key] = new VariantSummary
                {
                    PriceLabel = FormatPriceHtml(list),
                    SaleBadge = BuildSaleBadgeHtml(list)
                };
            }

            SearchRepeater.DataSource = products
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : "-",
                    CategorySlug = categorySlugs.ContainsKey(p.CategoryId) ? categorySlugs[p.CategoryId] : "",
                    SeoSlug = productSlugs.ContainsKey(p.Id) ? productSlugs[p.Id] : "",
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) ? primaryImageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = variantSummaryLookup.ContainsKey(p.Id) ? variantSummaryLookup[p.Id].PriceLabel : "Liên hệ",
                    SaleBadge = variantSummaryLookup.ContainsKey(p.Id) ? variantSummaryLookup[p.Id].SaleBadge : string.Empty
                })
                .Where(p => !string.IsNullOrWhiteSpace(p.SeoSlug))
                .ToList();
            SearchRepeater.DataBind();

            RenderPagination(totalPages, query);

            SchemaLiteral.Text = BuildItemListSchema(
                products.Select(p => new SchemaItem
                {
                    Name = p.ProductName,
                    Url = "/san-pham/" + (productSlugs.ContainsKey(p.Id) ? productSlugs[p.Id] : string.Empty),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) ? primaryImageLookup[p.Id] : "/images/fav.png"
                }).ToList());
        }
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

    private void RenderPagination(int totalPages, string query)
    {
        if (totalPages <= 1)
        {
            PaginationLiteral.Text = string.Empty;
            return;
        }

        var links = new List<string>();
        string baseUrl = "/tim-kiem/default.aspx?q=" + Server.UrlEncode(query);

        int groupSize = 5;
        int currentGroup = (int)Math.Ceiling(_currentPage / (double)groupSize);
        int groupStart = (currentGroup - 1) * groupSize + 1;
        int groupEnd = Math.Min(groupStart + groupSize - 1, totalPages);

        links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page=1\">&laquo;</a></li>", baseUrl));
        if (_currentPage > 1)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">&lsaquo;</a></li>", baseUrl, _currentPage - 1));
        }

        for (int i = groupStart; i <= groupEnd; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<li class=\"page-item active\"><span class=\"page-link\">{0}</span></li>", i));
            }
            else
            {
                links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">{1}</a></li>", baseUrl, i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">&rsaquo;</a></li>", baseUrl, _currentPage + 1));
        }
        links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">&raquo;</a></li>", baseUrl, totalPages));

        PaginationLiteral.Text = string.Format("<nav><ul class=\"pagination justify-content-center\">{0}</ul></nav>", string.Join("", links));
    }

    
    private class ProductLite
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
        public int CategoryId { get; set; }
    }

    private class VariantSummary
    {
        public string PriceLabel { get; set; }
        public string SaleBadge { get; set; }
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




