using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;

public partial class SellerProductReviews : System.Web.UI.Page
{
    private const int PageSize = 5;
    private int _currentPage = 1;
    private string _statusTab = "all";
    private int _ratingFilter = 0;
    private string _searchText = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReviews();
            DataBind();
        }
    }

    private void BindReviews()
    {
        _currentPage = ParsePage(Request.QueryString["page"]);
        _statusTab = (Request.QueryString["tab"] ?? "all").Trim();
        _ratingFilter = ParseRating(Request.QueryString["rating"]);
        _searchText = (Request.QueryString["q"] ?? string.Empty).Trim();

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
                BindSummaryEmpty();
                return;
            }

            var productIds = db.CfProducts
                .Where(p => p.Status && p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => p.Id)
                .ToList();

            if (productIds.Count == 0)
            {
                BindEmpty();
                BindSummaryEmpty();
                return;
            }

            var reviewsQuery = db.CfProductReviews
                .Where(r => r.Status && productIds.Contains(r.ProductId));

            if (_ratingFilter > 0)
            {
                reviewsQuery = reviewsQuery.Where(r => r.Rating == _ratingFilter);
            }

            if (string.Equals(_statusTab, "need-reply", StringComparison.OrdinalIgnoreCase))
            {
                reviewsQuery = reviewsQuery.Where(r => r.ReplyContent == null || r.ReplyContent == "");
            }
            else if (string.Equals(_statusTab, "replied", StringComparison.OrdinalIgnoreCase))
            {
                reviewsQuery = reviewsQuery.Where(r => r.ReplyContent != null && r.ReplyContent != "");
            }

            if (!string.IsNullOrWhiteSpace(_searchText))
            {
                var matchedProductIds = db.CfProducts
                    .Where(p => p.Status && productIds.Contains(p.Id) && p.ProductName.Contains(_searchText))
                    .Select(p => p.Id)
                    .ToList();

                var matchedCustomerIds = db.CfCustomers
                    .Where(c => c.DisplayName.Contains(_searchText) || c.Username.Contains(_searchText))
                    .Select(c => c.Id)
                    .ToList();

                var matchedOrderIds = db.CfOrders
                    .Where(o => o.OrderCode.Contains(_searchText))
                    .Select(o => o.Id)
                    .ToList();

                reviewsQuery = reviewsQuery.Where(r =>
                    matchedProductIds.Contains(r.ProductId)
                    || matchedCustomerIds.Contains(r.CustomerId)
                    || (r.OrderId.HasValue && matchedOrderIds.Contains(r.OrderId.Value)));
            }

            reviewsQuery = reviewsQuery.OrderByDescending(r => r.CreatedAt);

            var totalReviews = reviewsQuery.Count();
            var totalPages = (int)Math.Ceiling(totalReviews / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var reviews = reviewsQuery
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var productLookup = db.CfProducts
                .Where(p => productIds.Contains(p.Id))
                .ToList()
                .ToDictionary(p => p.Id, p => p);

            var customerIds = reviews.Select(r => r.CustomerId).Distinct().ToList();
            var customerLookup = db.CfCustomers
                .Where(c => customerIds.Contains(c.Id))
                .ToList()
                .ToDictionary(c => c.Id, c => c);

            var orderIds = reviews.Where(r => r.OrderId.HasValue).Select(r => r.OrderId.Value).Distinct().ToList();
            var orderLookup = db.CfOrders
                .Where(o => orderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var imageLookup = db.CfProductImages
                .Where(i => i.Status && productIds.Contains(i.ProductId))
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .ToList()
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.First().ImageUrl);

            var viewModels = new List<ProductReviewViewModel>();
            foreach (var review in reviews)
            {
                CfProduct product;
                productLookup.TryGetValue(review.ProductId, out product);

                CfCustomer customer;
                customerLookup.TryGetValue(review.CustomerId, out customer);

                CfOrder order;
                if (review.OrderId.HasValue)
                {
                    orderLookup.TryGetValue(review.OrderId.Value, out order);
                }
                else
                {
                    order = null;
                }

                var imageUrl = imageLookup.ContainsKey(review.ProductId) ? imageLookup[review.ProductId] : "/images/fav.png";
                var buyerName = customer != null
                    ? (!string.IsNullOrWhiteSpace(customer.DisplayName) ? customer.DisplayName : customer.Username)
                    : "-";
                var orderCode = order != null ? order.OrderCode : "-";
                var productMeta = "Đơn: " + orderCode;

                viewModels.Add(new ProductReviewViewModel
                {
                    ProductName = product != null ? product.ProductName : "-",
                    ProductMeta = productMeta,
                    ProductImageUrl = imageUrl,
                    BuyerName = buyerName,
                    BuyerAvatarUrl = "/images/fav.png",
                    CreatedAtLabel = review.CreatedAt.ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture),
                    Rating = review.Rating,
                    Content = review.Content,
                    ImageUrls = ParseImageUrls(review.ImageUrls),
                    HelpfulCount = review.HelpfulCount,
                    ReplyContent = review.ReplyContent,
                    HasReply = !string.IsNullOrWhiteSpace(review.ReplyContent),
                    ActionUrl = "/seller/product-review-detail.aspx?id=" + review.Id
                });
            }

            ProductReviewRepeater.DataSource = viewModels;
            ProductReviewRepeater.DataBind();

            BindSummary(productIds, shopIds);
            BindCounts(productIds);
            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(totalReviews);
            SearchTextBox.Text = _searchText;
        }
    }

    private void BindSummary(List<int> productIds, List<int> shopIds)
    {
        using (var db = new BeautyStoryContext())
        {
            var reviewQuery = db.CfProductReviews
                .Where(r => r.Status && productIds.Contains(r.ProductId));

            var reviews = reviewQuery.ToList();
            if (reviews.Count == 0)
            {
                BindSummaryEmpty();
                return;
            }

            var totalReviews = reviews.Count;
            var avgRating = reviews.Average(r => r.Rating);
            var goodRate = reviews.Count(r => r.Rating >= 4) / (double)totalReviews * 100.0;

            ReviewScoreLiteral.Text = avgRating.ToString("0.0", CultureInfo.InvariantCulture);
            ReviewScoreStarsLiteral.Text = RenderStars((int)Math.Round(avgRating), string.Empty);
            TotalReviewsLiteral.Text = totalReviews.ToString(CultureInfo.InvariantCulture);
            GoodReviewRateLiteral.Text = goodRate.ToString("0.#", CultureInfo.InvariantCulture) + "%";

            var totalOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId))
                .Select(o => o.OrderId)
                .Distinct()
                .Count();

            var reviewRate = totalOrders > 0 ? (totalReviews * 100.0) / totalOrders : 0.0;
            ReviewRateLiteral.Text = reviewRate.ToString("0.#", CultureInfo.InvariantCulture) + "%";

            var today = DateTime.Today;
            var start30 = today.AddDays(-30);
            var start60 = today.AddDays(-60);

            var currentReviews = reviews.Count(r => r.CreatedAt >= start30);
            var previousReviews = reviews.Count(r => r.CreatedAt >= start60 && r.CreatedAt < start30);
            SetTrend(TotalReviewsTrend, currentReviews, previousReviews);

            var currentOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= start30)
                .Select(o => o.OrderId)
                .Distinct()
                .Count();
            var previousOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= start60 && o.CreatedAt < start30)
                .Select(o => o.OrderId)
                .Distinct()
                .Count();

            var currentRate = currentOrders > 0 ? (currentReviews * 100.0) / currentOrders : 0.0;
            var previousRate = previousOrders > 0 ? (previousReviews * 100.0) / previousOrders : 0.0;
            SetTrend(ReviewRateTrend, currentRate, previousRate);

            var currentGood = reviews.Count(r => r.CreatedAt >= start30 && r.Rating >= 4);
            var previousGood = reviews.Count(r => r.CreatedAt >= start60 && r.CreatedAt < start30 && r.Rating >= 4);
            var currentGoodRate = currentReviews > 0 ? (currentGood * 100.0) / currentReviews : 0.0;
            var previousGoodRate = previousReviews > 0 ? (previousGood * 100.0) / previousReviews : 0.0;
            SetTrend(GoodReviewRateTrend, currentGoodRate, previousGoodRate);

            var highlightedGood = reviewQuery.Count(r =>
                r.Rating >= 4
                && ((r.Content != null && r.Content != "") || (r.ImageUrls != null && r.ImageUrls != "")));
            HighlightedGoodReviewLiteral.Text = highlightedGood.ToString(CultureInfo.InvariantCulture);

            var recentStart = DateTime.Now.AddHours(-48);
            var recentReviews = reviewQuery.Count(r => r.CreatedAt >= recentStart);
            RecentReviewLiteral.Text = recentReviews.ToString(CultureInfo.InvariantCulture);
        }
    }

    private void BindSummaryEmpty()
    {
        ReviewScoreLiteral.Text = "0.0";
        ReviewScoreStarsLiteral.Text = string.Empty;
        TotalReviewsLiteral.Text = "0";
        ReviewRateLiteral.Text = "0%";
        GoodReviewRateLiteral.Text = "0%";
        HighlightedGoodReviewLiteral.Text = "0";
        RecentReviewLiteral.Text = "0";

        TotalReviewsTrend.InnerText = "so với 30 ngày trước: 0%";
        ReviewRateTrend.InnerText = "so với 30 ngày trước: 0%";
        GoodReviewRateTrend.InnerText = "so với 30 ngày trước: 0%";
        TotalReviewsTrend.Attributes["class"] = "review-trend";
        ReviewRateTrend.Attributes["class"] = "review-trend";
        GoodReviewRateTrend.Attributes["class"] = "review-trend";
    }

    private static void SetTrend(System.Web.UI.HtmlControls.HtmlGenericControl target, double current, double previous)
    {
        var diff = current - previous;
        var percent = previous > 0 ? (diff / previous) * 100.0 : (current > 0 ? 100.0 : 0.0);
        var arrow = diff >= 0 ? "↑" : "↓";
        var className = diff >= 0 ? "review-trend up" : "review-trend down";

        target.Attributes["class"] = className;
        target.InnerText = string.Format("so với 30 ngày trước: {0} {1}%", arrow, Math.Abs(percent).ToString("0.#", CultureInfo.InvariantCulture));
    }

    private void BindCounts(List<int> productIds)
    {
        using (var db = new BeautyStoryContext())
        {
            var baseQuery = db.CfProductReviews
                .Where(r => r.Status && productIds.Contains(r.ProductId));

            var counts = baseQuery
                .GroupBy(r => r.Rating)
                .Select(g => new RatingCount { Rating = g.Key, Count = g.Count() })
                .ToList();

            var totalReviews = baseQuery.Count();
            var repliedCount = baseQuery.Count(r => r.ReplyContent != null && r.ReplyContent != "");
            var needReplyCount = totalReviews - repliedCount;

            TotalCountLiteral.Text = string.Format("Tất cả ({0})", totalReviews);
            NeedReplyLiteral.Text = string.Format("Cần phản hồi ({0})", needReplyCount);
            RepliedLiteral.Text = string.Format("Đã trả lời ({0})", repliedCount);
            RatingAllLiteral.Text = string.Format("Tất cả ({0})", totalReviews);
            Rating5Literal.Text = string.Format("5 sao ({0})", GetRatingCount(counts, 5));
            Rating4Literal.Text = string.Format("4 sao ({0})", GetRatingCount(counts, 4));
            Rating3Literal.Text = string.Format("3 sao ({0})", GetRatingCount(counts, 3));
            Rating2Literal.Text = string.Format("2 sao ({0})", GetRatingCount(counts, 2));
            Rating1Literal.Text = string.Format("1 sao ({0})", GetRatingCount(counts, 1));
        }
    }

    private static int GetRatingCount(List<RatingCount> counts, int rating)
    {
        var item = counts.FirstOrDefault(c => c.Rating == rating);
        return item != null ? item.Count : 0;
    }

    private void BindEmpty()
    {
        ProductReviewRepeater.DataSource = new List<ProductReviewViewModel>();
        ProductReviewRepeater.DataBind();
        TotalCountLiteral.Text = "Tất cả (0)";
        NeedReplyLiteral.Text = "Cần phản hồi (0)";
        RepliedLiteral.Text = "Đã trả lời (0)";
        RatingAllLiteral.Text = "Tất cả (0)";
        Rating5Literal.Text = "5 sao (0)";
        Rating4Literal.Text = "4 sao (0)";
        Rating3Literal.Text = "3 sao (0)";
        Rating2Literal.Text = "2 sao (0)";
        Rating1Literal.Text = "1 sao (0)";
        PaginationLiteral.Text = string.Empty;
        PaginationInfoLiteral.Text = "Hiển thị 0 trong tổng số 0 đánh giá";
    }

    private static List<string> ParseImageUrls(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return new List<string>();
        }

        return raw
            .Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(url => url.Trim())
            .Where(url => !string.IsNullOrWhiteSpace(url))
            .ToList();
    }

    protected string RenderStars(int rating, string extraClass)
    {
        var sb = new StringBuilder();
        var safeRating = Math.Max(0, Math.Min(5, rating));
        for (int i = 0; i < safeRating; i++)
        {
            sb.Append("<i class=\"fa-solid fa-star\"></i>");
        }
        return sb.ToString();
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
        var baseUrl = BuildBaseUrl(resetPage: false);

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
            return "Hiển thị 0 trong tổng số 0 đánh giá";
        }

        int start = (_currentPage - 1) * PageSize + 1;
        int end = Math.Min(_currentPage * PageSize, totalItems);
        return string.Format("Hiển thị {0}-{1} trong tổng số {2} đánh giá", start, end, totalItems);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    public class ProductReviewViewModel
    {
        public string ProductName { get; set; }
        public string ProductMeta { get; set; }
        public string ProductImageUrl { get; set; }
        public string BuyerName { get; set; }
        public string BuyerAvatarUrl { get; set; }
        public string CreatedAtLabel { get; set; }
        public int Rating { get; set; }
        public string Content { get; set; }
        public List<string> ImageUrls { get; set; }
        public int HelpfulCount { get; set; }
        public string ReplyContent { get; set; }
        public bool HasReply { get; set; }
        public string ActionUrl { get; set; }
    }

    public class RatingCount
    {
        public int Rating { get; set; }
        public int Count { get; set; }
    }

    protected void ApplyFiltersButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(BuildBaseUrl(resetPage: true));
    }

    public string GetTabClass(string key)
    {
        return string.Equals(_statusTab, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    public string GetRatingClass(int rating)
    {
        return _ratingFilter == rating ? "active" : string.Empty;
    }

    public string BuildRatingUrl(int rating)
    {
        var query = BuildQueryParams();
        if (rating > 0)
        {
            query["rating"] = rating.ToString(CultureInfo.InvariantCulture);
        }
        else
        {
            query.Remove("rating");
        }

        return BuildUrl(query);
    }

    private string BuildBaseUrl(bool resetPage)
    {
        var query = BuildQueryParams();
        if (!resetPage && _currentPage > 1)
        {
            query["page"] = _currentPage.ToString(CultureInfo.InvariantCulture);
        }
        return BuildUrl(query);
    }

    private Dictionary<string, string> BuildQueryParams()
    {
        var query = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        if (!string.IsNullOrWhiteSpace(_statusTab))
        {
            query["tab"] = _statusTab;
        }
        if (_ratingFilter > 0)
        {
            query["rating"] = _ratingFilter.ToString(CultureInfo.InvariantCulture);
        }
        if (!string.IsNullOrWhiteSpace(_searchText))
        {
            query["q"] = _searchText;
        }
        return query;
    }

    private string BuildUrl(Dictionary<string, string> query)
    {
        if (query == null || query.Count == 0)
        {
            return "/seller/review-products.aspx";
        }

        var parts = query.Select(kv => kv.Key + "=" + HttpUtility.UrlEncode(kv.Value));
        return "/seller/review-products.aspx?" + string.Join("&", parts);
    }

    private static int ParseRating(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && value >= 1 && value <= 5)
        {
            return value;
        }
        return 0;
    }
}
