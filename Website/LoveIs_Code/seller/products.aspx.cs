using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

public partial class SellerProducts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProducts();
            DataBind();
        }
    }

    private const int PageSize = 10;
    private int _currentPage = 1;
    private string _statusKey = "all";

    private void BindProducts()
    {
        _statusKey = (Request.QueryString["status"] ?? "all").Trim().ToLowerInvariant();
        _currentPage = ParsePage(Request.QueryString["page"]);

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                BindEmpty();
                return;
            }

            var products = db.CfProducts
                .Where(p => shopIds.Contains(p.ShopId ?? 0))
                .ToList();

            var productIds = products.Select(p => p.Id).ToList();
            var categories = db.CfCategories
                .Where(c => c.Status)
                .ToList()
                .ToDictionary(c => c.Id, c => c.CategoryName);

            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            var images = db.CfProductImages
                .Where(i => i.Status && productIds.Contains(i.ProductId))
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .ToList()
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.First().ImageUrl);

            var totalCount = products.Count;
            var activeCount = products.Count(p => p.Status);
            var hiddenCount = products.Count(p => !p.Status);
            var outOfStockCount = products.Count(p => GetStockQty(variants, p.Id) <= 0);

            TotalProductLiteral.Text = totalCount.ToString();
            ActiveProductLiteral.Text = activeCount.ToString();
            HiddenProductLiteral.Text = hiddenCount.ToString();
            OutOfStockLiteral.Text = outOfStockCount.ToString();

            TabAllLiteral.Text = totalCount.ToString();
            TabActiveLiteral.Text = activeCount.ToString();
            TabHiddenLiteral.Text = hiddenCount.ToString();
            TabOutLiteral.Text = outOfStockCount.ToString();

            var filtered = FilterProducts(products, variants, _statusKey);
            var totalPages = (int)Math.Ceiling(filtered.Count / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var paged = filtered
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var viewModels = paged.Select(p =>
            {
                var stockQty = GetStockQty(variants, p.Id);
                var rating = p.RatingAvg;
                var reviewCount = p.RatingCount;
                var imageUrl = images.ContainsKey(p.Id) ? images[p.Id] : "/images/fav.png";
                var priceLabel = GetPriceLabel(variants, p.Id);

                return new ProductRowViewModel
                {
                    ProductName = p.ProductName,
                    Sku = GetSku(variants, p.Id),
                    PriceLabel = priceLabel,
                    CategoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : "-",
                    StockLabel = stockQty.ToString(CultureInfo.InvariantCulture),
                    SoldLabel = p.Sold30d.ToString(CultureInfo.InvariantCulture),
                    RatingLabel = rating.ToString("0.0", CultureInfo.InvariantCulture),
                    ReviewLabel = string.Format("{0} đánh giá", reviewCount),
                    ViewLabel = p.ViewCount.ToString("N0", CultureInfo.InvariantCulture),
                    ImageUrl = imageUrl,
                    StatusLabel = ResolveStatusLabel(p, stockQty),
                    StatusClass = ResolveStatusClass(p, stockQty),
                    ViewUrl = "/san-pham/" + p.Id,
                    EditUrl = "/seller/products/edit.aspx?id=" + p.Id
                };
            }).ToList();

            ProductRepeater.DataSource = viewModels;
            ProductRepeater.DataBind();

            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(filtered.Count);
        }
    }

    public string GetTabClass(string key)
    {
        return string.Equals(_statusKey, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    private static List<CfProduct> FilterProducts(List<CfProduct> products, List<CfProductVariant> variants, string statusKey)
    {
        if (string.IsNullOrWhiteSpace(statusKey) || statusKey == "all")
        {
            return products;
        }

        if (statusKey == "active")
        {
            return products.Where(p => p.Status).ToList();
        }

        if (statusKey == "hidden")
        {
            return products.Where(p => !p.Status).ToList();
        }

        if (statusKey == "out")
        {
            return products.Where(p => GetStockQty(variants, p.Id) <= 0).ToList();
        }

        return products;
    }

    private static int GetStockQty(List<CfProductVariant> variants, int productId)
    {
        return variants
            .Where(v => v.ProductId == productId)
            .Sum(v => v.StockQty);
    }

    private static string GetSku(List<CfProductVariant> variants, int productId)
    {
        var sku = variants
            .Where(v => v.ProductId == productId && !string.IsNullOrWhiteSpace(v.Sku))
            .OrderBy(v => v.SortOrder)
            .Select(v => v.Sku)
            .FirstOrDefault();
        return string.IsNullOrWhiteSpace(sku) ? "-" : sku;
    }

    private static string GetPriceLabel(List<CfProductVariant> variants, int productId)
    {
        var productVariants = variants.Where(v => v.ProductId == productId).ToList();
        if (productVariants.Count == 0)
        {
            return "Liên hệ";
        }

        var saleVariant = productVariants
            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();

        var variant = saleVariant ?? productVariants.OrderBy(v => v.Price).First();
        var price = variant.SalePrice.HasValue && variant.SalePrice.Value > 0 ? variant.SalePrice.Value : variant.Price;
        return string.Format("{0:N0} đ", price);
    }

    private static string ResolveStatusLabel(CfProduct product, int stockQty)
    {
        if (!product.Status)
        {
            return "Tạm ẩn";
        }
        if (stockQty <= 0)
        {
            return "Hết hàng";
        }
        return "Đang bán";
    }

    private static string ResolveStatusClass(CfProduct product, int stockQty)
    {
        if (!product.Status)
        {
            return "status-hidden";
        }
        if (stockQty <= 0)
        {
            return "status-out";
        }
        return "status-selling";
    }

    private void BindEmpty()
    {
        TotalProductLiteral.Text = "0";
        ActiveProductLiteral.Text = "0";
        HiddenProductLiteral.Text = "0";
        OutOfStockLiteral.Text = "0";
        TabAllLiteral.Text = "0";
        TabActiveLiteral.Text = "0";
        TabHiddenLiteral.Text = "0";
        TabOutLiteral.Text = "0";
        ProductRepeater.DataSource = new List<ProductRowViewModel>();
        ProductRepeater.DataBind();
        PaginationLiteral.Text = string.Empty;
    }

    private static int ParsePage(string raw)
    {
        int page;
        if (int.TryParse(raw, out page) && page > 0)
        {
            return page;
        }
        return 1;
    }

    private string BuildPagination(int totalPages)
    {
        if (totalPages <= 1)
        {
            return string.Empty;
        }

        var links = new List<string>();
        var baseUrl = BuildBaseUrl();

        links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&laquo;</a>", BuildPageUrl(baseUrl, 1)));
        if (_currentPage > 1)
        {
            links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&lsaquo;</a>", BuildPageUrl(baseUrl, _currentPage - 1)));
        }

        var start = Math.Max(1, _currentPage - 2);
        var end = Math.Min(totalPages, _currentPage + 2);
        for (int i = start; i <= end; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<span class=\"page-link active\">{0}</span>", i));
            }
            else
            {
                links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">{1}</a>", BuildPageUrl(baseUrl, i), i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&rsaquo;</a>", BuildPageUrl(baseUrl, _currentPage + 1)));
        }
        links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&raquo;</a>", BuildPageUrl(baseUrl, totalPages)));

        return string.Join("", links);
    }

    private string BuildPaginationInfo(int totalItems)
    {
        if (totalItems == 0)
        {
            return "Hiển thị 0 trong tổng số 0 sản phẩm";
        }

        int start = (_currentPage - 1) * PageSize + 1;
        int end = Math.Min(_currentPage * PageSize, totalItems);
        return string.Format("Hiển thị {0}-{1} trong tổng số {2} sản phẩm", start, end, totalItems);
    }

    private string BuildBaseUrl()
    {
        var query = new List<string>();
        if (!string.IsNullOrWhiteSpace(_statusKey))
        {
            query.Add("status=" + HttpUtility.UrlEncode(_statusKey));
        }

        if (query.Count == 0)
        {
            return "/seller/products.aspx";
        }
        return "/seller/products.aspx?" + string.Join("&", query);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    public class ProductRowViewModel
    {
        public string ProductName { get; set; }
        public string Sku { get; set; }
        public string PriceLabel { get; set; }
        public string CategoryName { get; set; }
        public string StockLabel { get; set; }
        public string SoldLabel { get; set; }
        public string RatingLabel { get; set; }
        public string ReviewLabel { get; set; }
        public string ViewLabel { get; set; }
        public string ImageUrl { get; set; }
        public string StatusLabel { get; set; }
        public string StatusClass { get; set; }
        public string ViewUrl { get; set; }
        public string EditUrl { get; set; }
    }
}
