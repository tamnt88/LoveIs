using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

public partial class SellerReturns : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReturns();
            DataBind();
        }
    }

    private const int PageSize = 10;
    private int _currentPage = 1;
    private string _statusKey = "all";
    private Dictionary<string, string> _statusNameLookup = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

    private void BindReturns()
    {
        _statusKey = (Request.QueryString["status"] ?? "all").Trim();
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
                TotalRequestLiteral.Text = "0";
                PendingRequestLiteral.Text = "0";
                ApprovedRequestLiteral.Text = "0";
                RejectedRequestLiteral.Text = "0";
                ReturnRepeater.DataSource = new List<ReturnRowViewModel>();
                ReturnRepeater.DataBind();
                PaginationLiteral.Text = string.Empty;
                return;
            }

            var statusLookup = db.CfReturnStatuses
                .Where(s => s.Status)
                .OrderBy(s => s.SortOrder)
                .ToList()
                .ToDictionary(s => s.Code, s => s.Name, StringComparer.OrdinalIgnoreCase);

            _statusNameLookup = statusLookup;

            var requests = db.CfReturnRequests
                .Where(r => r.Status != null && shopIds.Contains(r.ShopId))
                .OrderByDescending(r => r.CreatedAt)
                .ToList();

            var totalCount = requests.Count;
            var pendingCount = requests.Count(r => IsStatusMatch(r.Status, "PENDING"));
            var approvedCount = requests.Count(r => IsStatusMatch(r.Status, "APPROVED"));
            var rejectedCount = requests.Count(r => IsStatusMatch(r.Status, "REJECTED"));

            TotalRequestLiteral.Text = totalCount.ToString();
            PendingRequestLiteral.Text = pendingCount.ToString();
            ApprovedRequestLiteral.Text = approvedCount.ToString();
            RejectedRequestLiteral.Text = rejectedCount.ToString();

            var filtered = string.Equals(_statusKey, "all", StringComparison.OrdinalIgnoreCase)
                ? requests
                : requests.Where(r => IsStatusMatch(r.Status, _statusKey)).ToList();

            var totalPages = (int)Math.Ceiling(filtered.Count / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var paged = filtered
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var orderIds = paged.Select(r => r.OrderId).Distinct().ToList();
            var orders = db.CfOrders
                .Where(o => orderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var returnIds = paged.Select(r => r.Id).Distinct().ToList();
            var returnItems = db.CfReturnItems
                .Where(ri => returnIds.Contains(ri.ReturnRequestId))
                .ToList();

            var orderItemIds = returnItems.Select(ri => ri.OrderItemId).Distinct().ToList();
            var orderItems = db.CfOrderItems
                .Where(oi => orderItemIds.Contains(oi.Id))
                .ToList()
                .ToDictionary(oi => oi.Id, oi => oi);

            var rows = new List<ReturnRowViewModel>();
            foreach (var request in paged)
            {
                CfOrder order;
                orders.TryGetValue(request.OrderId, out order);

                var items = returnItems
                    .Where(ri => ri.ReturnRequestId == request.Id)
                    .ToList();

                var firstItem = items
                    .Select(ri =>
                    {
                        CfOrderItem orderItem;
                        return orderItems.TryGetValue(ri.OrderItemId, out orderItem) ? orderItem : null;
                    })
                    .FirstOrDefault(i => i != null);

                var total = items.Sum(ri =>
                {
                    CfOrderItem orderItem;
                    if (!orderItems.TryGetValue(ri.OrderItemId, out orderItem))
                    {
                        return 0m;
                    }
                    var unit = orderItem.SalePrice.HasValue && orderItem.SalePrice.Value > 0
                        ? orderItem.SalePrice.Value
                        : orderItem.Price;
                    return unit * ri.Quantity;
                });

                var statusLabel = ResolveStatusLabel(request.Status);
                var statusClass = ResolveStatusClass(request.Status);

                rows.Add(new ReturnRowViewModel
                {
                    RequestCode = "TR" + request.Id.ToString("D6"),
                    OrderCode = order != null ? order.OrderCode : "-",
                    CustomerName = order != null ? order.CustomerName : "-",
                    ProductName = firstItem != null ? firstItem.ProductName : "-",
                    Reason = string.IsNullOrWhiteSpace(request.Reason) ? "-" : request.Reason,
                    TotalLabel = string.Format("{0:N0} đ", total),
                    RequestedAt = request.CreatedAt.ToString("dd/MM/yyyy"),
                    StatusLabel = statusLabel,
                    StatusClass = statusClass,
                    ActionUrl = "/seller/return-detail.aspx?id=" + request.Id
                });
            }

            ReturnRepeater.DataSource = rows;
            ReturnRepeater.DataBind();
            PaginationLiteral.Text = BuildPagination(totalPages);
        }
    }

    public string GetTabClass(string key)
    {
        return string.Equals(_statusKey, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    private static bool IsStatusMatch(string rawStatus, string statusKey)
    {
        if (string.IsNullOrWhiteSpace(rawStatus))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(statusKey))
        {
            return false;
        }

        return string.Equals(rawStatus.Trim(), statusKey.Trim(), StringComparison.OrdinalIgnoreCase);
    }

    private string ResolveStatusLabel(string rawStatus)
    {
        if (string.IsNullOrWhiteSpace(rawStatus))
        {
            return "Chờ xử lý";
        }

        string name;
        return _statusNameLookup.TryGetValue(rawStatus, out name) ? name : rawStatus;
    }

    private string ResolveStatusClass(string rawStatus)
    {
        if (IsStatusMatch(rawStatus, "APPROVED"))
        {
            return "return-approved";
        }
        if (IsStatusMatch(rawStatus, "REJECTED"))
        {
            return "return-rejected";
        }
        if (IsStatusMatch(rawStatus, "PICKUP") || IsStatusMatch(rawStatus, "RETURNED") || IsStatusMatch(rawStatus, "REFUNDED"))
        {
            return "return-approved";
        }
        if (IsStatusMatch(rawStatus, "CLOSED"))
        {
            return "return-closed";
        }
        return "return-pending";
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

    private string BuildBaseUrl()
    {
        var query = new List<string>();
        if (!string.IsNullOrWhiteSpace(_statusKey))
        {
            query.Add("status=" + HttpUtility.UrlEncode(_statusKey));
        }

        if (query.Count == 0)
        {
            return "/seller/returns.aspx";
        }
        return "/seller/returns.aspx?" + string.Join("&", query);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    public class ReturnRowViewModel
    {
        public string RequestCode { get; set; }
        public string OrderCode { get; set; }
        public string CustomerName { get; set; }
        public string ProductName { get; set; }
        public string Reason { get; set; }
        public string TotalLabel { get; set; }
        public string RequestedAt { get; set; }
        public string StatusLabel { get; set; }
        public string StatusClass { get; set; }
        public string ActionUrl { get; set; }
    }
}
