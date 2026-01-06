using System;
using System.Linq;
using System.Collections.Generic;

public partial class SearchDefault : System.Web.UI.Page
{
    private const int PageSize = 24;
    private int _currentPage = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSearch();
        }
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
            var productQuery = db.CfProducts
                .Where(p => p.Status && p.ProductName.Contains(query));

            var totalProducts = productQuery.Count();
            SearchSummary.Text = string.Format("Từ khóa: \"{0}\" - {1} sản phẩm", query, totalProducts);
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

            var products = productQuery
                .OrderByDescending(p => p.CreatedAt)
                .ThenByDescending(p => p.Id)
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var productIds = products.Select(p => p.Id).ToList();
            var categories = db.CfCategories.ToDictionary(c => c.Id, c => c.CategoryName);
            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

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
                        return fallback != null ? fallback.ImageUrl : "/images/fav.png";
                    });

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

            SearchRepeater.DataSource = products
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : "-",
                    SeoSlug = slugLookup.ContainsKey(p.Id) ? slugLookup[p.Id] : "",
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) ? primaryImageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : "Liên hệ"
                })
                .Where(p => !string.IsNullOrWhiteSpace(p.SeoSlug))
                .ToList();
            SearchRepeater.DataBind();

            RenderPagination(totalPages, query);
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

        int start = Math.Max(1, _currentPage - 2);
        int end = Math.Min(totalPages, _currentPage + 2);

        if (_currentPage > 1)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">Trước</a></li>", baseUrl, _currentPage - 1));
        }

        for (int i = start; i <= end; i++)
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
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">Sau</a></li>", baseUrl, _currentPage + 1));
        }

        PaginationLiteral.Text = string.Format("<nav><ul class=\"pagination\">{0}</ul></nav>", string.Join("", links));
    }
}
