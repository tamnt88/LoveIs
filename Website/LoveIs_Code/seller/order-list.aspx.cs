using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

public partial class SellerOrders : System.Web.UI.Page
{
    private const int PageSize = 10;
    private int _currentPage = 1;
    private string _statusKey = "all";
    private Dictionary<string, string> _statusNameLookup = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindOrders();
            DataBind();
        }
    }

    private void BindOrders()
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
                OrderTitleLiteral.Text = "Đơn hàng";
                OrderSummaryLiteral.Text = "0 Đơn hàng";
                OrderRepeater.DataSource = new List<OrderViewModel>();
                OrderRepeater.DataBind();
                PaginationLiteral.Text = string.Empty;
                return;
            }

            var statusLookup = db.CfOrderStatuses
                .Where(s => s.Status)
                .OrderBy(s => s.SortOrder)
                .ToList()
                .ToDictionary(s => s.Code, s => s.Name, StringComparer.OrdinalIgnoreCase);

            _statusNameLookup = statusLookup;

            var shopOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId))
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            var filteredOrders = ApplyStatusFilter(shopOrders, _statusKey);
            var totalOrders = filteredOrders.Count;
            var totalPages = (int)Math.Ceiling(totalOrders / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var pagedOrders = filteredOrders
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var shopOrderIds = pagedOrders.Select(o => o.Id).Distinct().ToList();
            var orderIds = pagedOrders.Select(o => o.OrderId).Distinct().ToList();
            var orders = db.CfOrders
                .Where(o => orderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var orderItems = db.CfOrderItems
                .Where(i => orderIds.Contains(i.OrderId))
                .ToList();

            var productIds = orderItems.Select(i => i.ProductId).Distinct().ToList();
            var images = db.CfProductImages
                .Where(i => i.Status && productIds.Contains(i.ProductId))
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .ToList()
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.First().ImageUrl);

            var trackingLookup = db.CfShippingTrackings
                .Where(t => shopOrderIds.Contains(t.ShopOrderId))
                .ToList()
                .GroupBy(t => t.ShopOrderId)
                .ToDictionary(g => g.Key, g => g.OrderByDescending(x => x.Id).FirstOrDefault());

            var viewModels = new List<OrderViewModel>();
            foreach (var shopOrder in pagedOrders)
            {
                CfOrder order;
                orders.TryGetValue(shopOrder.OrderId, out order);

                var items = orderItems
                    .Where(i => i.OrderId == shopOrder.OrderId)
                    .ToList();

                var itemModels = new List<OrderItemViewModel>();
                for (int i = 0; i < items.Count; i++)
                {
                    var item = items[i];
                    var imageUrl = images.ContainsKey(item.ProductId) ? images[item.ProductId] : "/images/fav.png";
                    itemModels.Add(new OrderItemViewModel
                    {
                        ProductName = item.ProductName,
                        VariantLabel = string.IsNullOrWhiteSpace(item.VariantName) ? "-" : item.VariantName,
                        Quantity = item.Quantity,
                        ImageUrl = imageUrl,
                        ShowSummary = i == 0
                    });
                }

                var orderTotalHtml = string.Format(
                    "<div class=\"price-strong\">{0}</div><div class=\"price-sub\">{1}</div>",
                    FormatCurrency(shopOrder.Total),
                    string.IsNullOrWhiteSpace(shopOrder.PaymentStatus) ? "-" : HttpUtility.HtmlEncode(shopOrder.PaymentStatus));
                var statusHtml = BuildStatusHtml(shopOrder.OrderStatus, shopOrder.CreatedAt);
                var tracking = trackingLookup.ContainsKey(shopOrder.Id) ? trackingLookup[shopOrder.Id] : null;
                var shippingHtml = BuildShippingHtml(shopOrder, tracking);
                var actionHtml = string.Format("<a class=\"btn-primary small\" href=\"/seller/order-detail.aspx?id={0}\">Chi tiết</a>", shopOrder.Id);

                foreach (var item in itemModels)
                {
                    if (!item.ShowSummary)
                    {
                        continue;
                    }
                    item.OrderTotalHtml = orderTotalHtml;
                    item.OrderStatusHtml = statusHtml;
                    item.ShippingHtml = shippingHtml;
                    item.ActionHtml = actionHtml;
                    break;
                }

                if (itemModels.Count == 0)
                {
                    itemModels.Add(new OrderItemViewModel
                    {
                        ProductName = "-",
                        VariantLabel = "-",
                        Quantity = 0,
                        ImageUrl = "/images/fav.png",
                        ShowSummary = true,
                        OrderTotalHtml = orderTotalHtml,
                        OrderStatusHtml = statusHtml,
                        ShippingHtml = shippingHtml,
                        ActionHtml = actionHtml
                    });
                }

                viewModels.Add(new OrderViewModel
                {
                    CustomerName = order != null ? order.CustomerName : "-",
                    OrderCode = order != null ? order.OrderCode : "-",
                    Items = itemModels
                });
            }

            OrderTitleLiteral.Text = BuildTitle(_statusKey);
            OrderSummaryLiteral.Text = string.Format("{0} Đơn hàng | Trang {1}/{2}", totalOrders, _currentPage, Math.Max(totalPages, 1));

            OrderRepeater.DataSource = viewModels;
            OrderRepeater.DataBind();

            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(totalOrders);

        }
    }

    public string GetTabClass(string key)
    {
        return string.Equals(_statusKey, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    private static string BuildTitle(string statusKey)
    {
        if (string.IsNullOrWhiteSpace(statusKey) || string.Equals(statusKey, "all", StringComparison.OrdinalIgnoreCase))
        {
            return "Tất cả";
        }

        if (string.Equals(statusKey, "NEW", StringComparison.OrdinalIgnoreCase))
        {
            return "Chờ xác nhận";
        }
        if (string.Equals(statusKey, "CONFIRMED", StringComparison.OrdinalIgnoreCase))
        {
            return "Chờ lấy hàng";
        }
        if (string.Equals(statusKey, "SHIPPING", StringComparison.OrdinalIgnoreCase))
        {
            return "Đang giao";
        }
        if (string.Equals(statusKey, "COMPLETED", StringComparison.OrdinalIgnoreCase))
        {
            return "Đã giao";
        }
        if (string.Equals(statusKey, "CANCELLED", StringComparison.OrdinalIgnoreCase))
        {
            return "Trả hàng/Hoàn tiền/Hủy";
        }

        return statusKey;
    }

    private static List<CfShopOrder> ApplyStatusFilter(List<CfShopOrder> orders, string statusKey)
    {
        if (string.IsNullOrWhiteSpace(statusKey) || string.Equals(statusKey, "all", StringComparison.OrdinalIgnoreCase))
        {
            return orders;
        }

        return orders
            .Where(o => IsStatusMatch(o != null ? o.OrderStatus : null, statusKey))
            .ToList();
    }

    private static bool IsStatusMatch(string rawStatus, string statusKey)
    {
        if (string.IsNullOrWhiteSpace(rawStatus))
        {
            return false;
        }

        return string.Equals(rawStatus.Trim(), statusKey, StringComparison.OrdinalIgnoreCase);
    }


    private string BuildStatusHtml(string orderStatus, DateTime createdAt)
    {
        var label = ResolveStatusName(orderStatus);
        var className = GetStatusClass(orderStatus);
        return string.Format(
            "<span class=\"status-pill {0}\">{1}</span><div class=\"status-time\">{2}</div>",
            className,
            HttpUtility.HtmlEncode(label),
            createdAt.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture));
    }

    private static string BuildShippingHtml(CfShopOrder shopOrder, CfShippingTracking tracking)
    {
        var shipName = !string.IsNullOrWhiteSpace(shopOrder.ShippingMethod) ? shopOrder.ShippingMethod : "-";
        var carrier = tracking != null && !string.IsNullOrWhiteSpace(tracking.Carrier) ? tracking.Carrier : "-";
        var code = tracking != null && !string.IsNullOrWhiteSpace(tracking.TrackingCode) ? tracking.TrackingCode : "-";
        return string.Format(
            "<div class=\"ship-name\">{0}</div><div class=\"ship-meta\">{1}</div><div class=\"ship-code\">{2}</div>",
            HttpUtility.HtmlEncode(shipName),
            HttpUtility.HtmlEncode(carrier),
            HttpUtility.HtmlEncode(code));
    }

    private static string GetStatusClass(string orderStatus)
    {
        if (string.IsNullOrWhiteSpace(orderStatus))
        {
            return "status-pending";
        }

        var status = orderStatus.ToUpperInvariant();
        if (status == "SHIPPING")
        {
            return "status-shipping";
        }
        if (status == "COMPLETED")
        {
            return "status-completed";
        }
        if (status == "CANCELLED")
        {
            return "status-returns";
        }
        if (status == "CONFIRMED")
        {
            return "status-ready";
        }
        return "status-pending";
    }

    private static string FormatCurrency(decimal value)
    {
        return string.Format("{0:N0} đ", value);
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
            return "Hiển thị 0 trong tổng số 0 đơn hàng";
        }

        int start = (_currentPage - 1) * PageSize + 1;
        int end = Math.Min(_currentPage * PageSize, totalItems);
        return string.Format("Hiển thị {0}-{1} trong tổng số {2} đơn hàng", start, end, totalItems);
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
            return "/seller/order-list.aspx";
        }
        return "/seller/order-list.aspx?" + string.Join("&", query);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    public class OrderViewModel
    {
        public string CustomerName { get; set; }
        public string OrderCode { get; set; }
        public List<OrderItemViewModel> Items { get; set; }
    }

    public class OrderItemViewModel
    {
        public string ProductName { get; set; }
        public string VariantLabel { get; set; }
        public int Quantity { get; set; }
        public string ImageUrl { get; set; }
        public bool ShowSummary { get; set; }
        public string OrderTotalHtml { get; set; }
        public string OrderStatusHtml { get; set; }
        public string ShippingHtml { get; set; }
        public string ActionHtml { get; set; }
    }

    private string ResolveStatusName(string statusCode)
    {
        if (string.IsNullOrWhiteSpace(statusCode))
        {
            return "Đang xử lý";
        }

        string name;
        return _statusNameLookup.TryGetValue(statusCode, out name) ? name : statusCode;
    }
}

