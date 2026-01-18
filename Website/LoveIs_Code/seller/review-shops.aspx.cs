using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;

public partial class SellerShopReviews : System.Web.UI.Page
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
                return;
            }

            var reviewsQuery = db.CfShopReviews
                .Where(r => r.Status && shopIds.Contains(r.ShopId));

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
                var matchedCustomerIds = db.CfCustomers
                    .Where(c => c.DisplayName.Contains(_searchText) || c.Username.Contains(_searchText))
                    .Select(c => c.Id)
                    .ToList();

                reviewsQuery = reviewsQuery.Where(r =>
                    matchedCustomerIds.Contains(r.CustomerId)
                    || (r.Content != null && r.Content.Contains(_searchText)));
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

            var customerIds = reviews.Select(r => r.CustomerId).Distinct().ToList();
            var customerLookup = db.CfCustomers
                .Where(c => customerIds.Contains(c.Id))
                .ToList()
                .ToDictionary(c => c.Id, c => c);

            var orderCounts = db.CfShopOrders
                .Where(o => shopIds.Contains(o.ShopId))
                .Join(db.CfOrders, so => so.OrderId, o => o.Id, (so, o) => new { o.CustomerId })
                .Where(x => x.CustomerId.HasValue)
                .GroupBy(x => x.CustomerId.Value)
                .ToDictionary(g => g.Key, g => g.Count());

            var viewModels = new List<ShopReviewViewModel>();
            foreach (var review in reviews)
            {
                CfCustomer customer;
                customerLookup.TryGetValue(review.CustomerId, out customer);

                var buyerName = customer != null
                    ? (!string.IsNullOrWhiteSpace(customer.DisplayName) ? customer.DisplayName : customer.Username)
                    : "-";

                var orderCount = orderCounts.ContainsKey(review.CustomerId) ? orderCounts[review.CustomerId] : 0;

                viewModels.Add(new ShopReviewViewModel
                {
                    BuyerName = buyerName,
                    BuyerAvatarUrl = "/images/fav.png",
                    OrderCount = orderCount,
                    CreatedAtLabel = review.CreatedAt.ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture),
                    Rating = review.Rating,
                    Content = review.Content,
                    QualityRating = review.QualityRating,
                    DescriptionRating = review.DescriptionRating,
                    ShippingRating = review.ShippingRating,
                    ServiceRating = review.ServiceRating,
                    HelpfulCount = review.HelpfulCount,
                    ReplyContent = review.ReplyContent,
                    HasReply = !string.IsNullOrWhiteSpace(review.ReplyContent)
                });
            }

            ShopReviewRepeater.DataSource = viewModels;
            ShopReviewRepeater.DataBind();

            BindCounts(shopIds);
            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(totalReviews);
            SearchTextBox.Text = _searchText;
        }
    }

    private void BindCounts(List<int> shopIds)
    {
        using (var db = new BeautyStoryContext())
        {
            var baseQuery = db.CfShopReviews
                .Where(r => r.Status && shopIds.Contains(r.ShopId));

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
        ShopReviewRepeater.DataSource = new List<ShopReviewViewModel>();
        ShopReviewRepeater.DataBind();
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

    public class ShopReviewViewModel
    {
        public string BuyerName { get; set; }
        public string BuyerAvatarUrl { get; set; }
        public int OrderCount { get; set; }
        public string CreatedAtLabel { get; set; }
        public int Rating { get; set; }
        public string Content { get; set; }
        public int QualityRating { get; set; }
        public int DescriptionRating { get; set; }
        public int ShippingRating { get; set; }
        public int ServiceRating { get; set; }
        public int HelpfulCount { get; set; }
        public string ReplyContent { get; set; }
        public bool HasReply { get; set; }
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
            return "/seller/review-shops.aspx";
        }

        var parts = query.Select(kv => kv.Key + "=" + HttpUtility.UrlEncode(kv.Value));
        return "/seller/review-shops.aspx?" + string.Join("&", parts);
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
