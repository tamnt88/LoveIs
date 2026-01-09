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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReviews();
        }
    }

    private void BindReviews()
    {
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

            var productIds = db.CfProducts
                .Where(p => p.Status && p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => p.Id)
                .ToList();

            if (productIds.Count == 0)
            {
                BindEmpty();
                return;
            }

            var reviewsQuery = db.CfProductReviews
                .Where(r => r.Status && productIds.Contains(r.ProductId))
                .OrderByDescending(r => r.CreatedAt);

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

                var imageUrl = imageLookup.ContainsKey(review.ProductId) ? imageLookup[review.ProductId] : "/images/fav.png";
                var buyerName = customer != null
                    ? (!string.IsNullOrWhiteSpace(customer.DisplayName) ? customer.DisplayName : customer.Username)
                    : "-";

                viewModels.Add(new ProductReviewViewModel
                {
                    ProductName = product != null ? product.ProductName : "-",
                    ProductMeta = "-",
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

            BindCounts(productIds, totalReviews);
            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(totalReviews);
        }
    }

    private void BindCounts(List<int> productIds, int totalReviews)
    {
        using (var db = new BeautyStoryContext())
        {
            var counts = db.CfProductReviews
                .Where(r => r.Status && productIds.Contains(r.ProductId))
                .GroupBy(r => r.Rating)
                .Select(g => new RatingCount { Rating = g.Key, Count = g.Count() })
                .ToList();

            var repliedCount = db.CfProductReviews
                .Count(r => r.Status && productIds.Contains(r.ProductId) && r.ReplyContent != null && r.ReplyContent != "");
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
        var baseUrl = "/seller/review-products.aspx";

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
        return baseUrl + "?page=" + page;
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
}
