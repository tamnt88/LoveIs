using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;

public partial class SellerOrders : System.Web.UI.Page
{
    private const int PageSize = 10;
    private int _currentPage = 1;
    private string _statusKey = "all";
    private string _searchCode = string.Empty;
    private int? _shippingMethodId = null;
    private bool _showExportHistory = false;
    private Dictionary<string, string> _statusNameLookup = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    private Dictionary<int, string> _statusIdNameLookup = new Dictionary<int, string>();
    private Dictionary<int, string> _statusIdCodeLookup = new Dictionary<int, string>();
    private Dictionary<string, int> _statusCodeIdLookup = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var historyExportId = ParseNullableInt(Request.QueryString["exportHistoryId"]);
            if (historyExportId.HasValue)
            {
                ExportFromHistory(historyExportId.Value);
                return;
            }

            BindShippingMethods();
            BindOrders();
            BindExportHistory();
            DataBind();
        }
    }

    private void BindOrders()
    {
        _statusKey = (Request.QueryString["status"] ?? "all").Trim();
        _currentPage = ParsePage(Request.QueryString["page"]);
        _searchCode = (Request.QueryString["code"] ?? string.Empty).Trim();
        _shippingMethodId = ParseNullableInt(Request.QueryString["shippingId"]);
        _showExportHistory = string.Equals(Request.QueryString["history"], "1", StringComparison.OrdinalIgnoreCase);

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

            var statusRows = db.CfOrderStatuses
                .Where(s => s.Status)
                .OrderBy(s => s.SortOrder)
                .ToList();

            _statusNameLookup = statusRows
                .ToDictionary(s => s.Code, s => s.Name, StringComparer.OrdinalIgnoreCase);
            _statusIdNameLookup = statusRows
                .ToDictionary(s => s.Id, s => s.Name);
            _statusIdCodeLookup = statusRows
                .ToDictionary(s => s.Id, s => s.Code);
            _statusCodeIdLookup = statusRows
                .ToDictionary(s => s.Code, s => s.Id, StringComparer.OrdinalIgnoreCase);

            var shippingCodeLookup = db.CfShippingMethods
                .Where(s => s.Status)
                .ToList()
                .GroupBy(s => s.Name ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First().Code ?? string.Empty, StringComparer.OrdinalIgnoreCase);

            var shippingName = ResolveShippingName(db, _shippingMethodId);
            var shopOrdersQuery = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId));

            if (!string.IsNullOrWhiteSpace(shippingName))
            {
                shopOrdersQuery = shopOrdersQuery.Where(o => o.ShippingMethod == shippingName);
            }

            if (!string.IsNullOrWhiteSpace(_searchCode))
            {
                var searchOrderIds = db.CfOrders
                    .Where(o => o.OrderCode.Contains(_searchCode))
                    .Select(o => o.Id)
                    .ToList();
                shopOrdersQuery = shopOrdersQuery.Where(o => searchOrderIds.Contains(o.OrderId));
            }

            var shopOrders = shopOrdersQuery
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            var allOrderIds = shopOrders.Select(o => o.OrderId).Distinct().ToList();
            var orderLookupAll = db.CfOrders
                .Where(o => allOrderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var filteredOrders = ApplyStatusFilter(shopOrders, orderLookupAll, _statusKey);
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
            var orders = orderLookupAll
                .Where(kvp => orderIds.Contains(kvp.Key))
                .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

            var shopProductIds = db.CfProducts
                .Where(p => p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => p.Id)
                .ToList();

            var orderItems = db.CfOrderItems
                .Where(i => orderIds.Contains(i.OrderId) && shopProductIds.Contains(i.ProductId))
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
                var orderStatusId = order != null ? order.OrderStatusId : null;
                var statusCode = order != null && !string.IsNullOrWhiteSpace(order.OrderStatus)
                    ? order.OrderStatus
                    : shopOrder.OrderStatus;
                var statusHtml = BuildStatusHtml(orderStatusId, statusCode, shopOrder.CreatedAt);
                var shippingCode = !string.IsNullOrWhiteSpace(shopOrder.ShippingMethod) && shippingCodeLookup.ContainsKey(shopOrder.ShippingMethod)
                    ? shippingCodeLookup[shopOrder.ShippingMethod]
                    : "-";
                var shippingHtml = BuildShippingHtml(shopOrder, shippingCode);
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

        OrderCodeTextBox.Text = _searchCode;
        if (ShippingMethodDropDown.Items.Count > 0)
        {
            ShippingMethodDropDown.SelectedValue = _shippingMethodId.HasValue ? _shippingMethodId.Value.ToString() : string.Empty;
        }

        ExportHistoryPanel.Visible = _showExportHistory;
    }

    public string GetTabClass(string key)
    {
        return string.Equals(_statusKey, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    protected void ApplyFiltersButton_Click(object sender, EventArgs e)
    {
        SyncQueryState();
        Response.Redirect(BuildFilterUrl(includeHistory: _showExportHistory, resetPage: true));
    }

    protected void ResetFiltersButton_Click(object sender, EventArgs e)
    {
        SyncQueryState();
        _searchCode = string.Empty;
        _shippingMethodId = null;
        Response.Redirect(BuildFilterUrl(includeHistory: _showExportHistory, resetPage: true, clearFilters: true));
    }

    protected void ExportHistoryButton_Click(object sender, EventArgs e)
    {
        SyncQueryState();
        Response.Redirect(BuildFilterUrl(includeHistory: true, resetPage: false));
    }

    protected void ExportButton_Click(object sender, EventArgs e)
    {
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
                return;
            }

            _statusKey = (Request.QueryString["status"] ?? "all").Trim();
            _searchCode = (OrderCodeTextBox.Text ?? string.Empty).Trim();
            _shippingMethodId = ParseNullableInt(ShippingMethodDropDown.SelectedValue);

            var shippingName = ResolveShippingName(db, _shippingMethodId);
            var shopOrdersQuery = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId));

            if (!string.IsNullOrWhiteSpace(shippingName))
            {
                shopOrdersQuery = shopOrdersQuery.Where(o => o.ShippingMethod == shippingName);
            }

            if (!string.IsNullOrWhiteSpace(_searchCode))
            {
                var orderIds = db.CfOrders
                    .Where(o => o.OrderCode.Contains(_searchCode))
                    .Select(o => o.Id)
                    .ToList();
                shopOrdersQuery = shopOrdersQuery.Where(o => orderIds.Contains(o.OrderId));
            }

            var shopOrders = shopOrdersQuery
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            var allOrderIds = shopOrders.Select(o => o.OrderId).Distinct().ToList();
            var orderLookupAll = db.CfOrders
                .Where(o => allOrderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var filteredOrders = ApplyStatusFilter(shopOrders, orderLookupAll, _statusKey);
            var orderIdsFiltered = filteredOrders.Select(o => o.OrderId).Distinct().ToList();

            var orders = orderLookupAll
                .Where(kvp => orderIdsFiltered.Contains(kvp.Key))
                .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

            var orderItems = db.CfOrderItems
                .Where(i => orderIdsFiltered.Contains(i.OrderId))
                .ToList();

            var statusRows = db.CfOrderStatuses
                .Where(s => s.Status)
                .ToList();

            _statusNameLookup = statusRows
                .ToDictionary(s => s.Code, s => s.Name, StringComparer.OrdinalIgnoreCase);
            _statusIdNameLookup = statusRows
                .ToDictionary(s => s.Id, s => s.Name);
            _statusIdCodeLookup = statusRows
                .ToDictionary(s => s.Id, s => s.Code);
            _statusCodeIdLookup = statusRows
                .ToDictionary(s => s.Code, s => s.Id, StringComparer.OrdinalIgnoreCase);

            var rows = new List<ExportRow>();
            foreach (var shopOrder in filteredOrders)
            {
                var orderCode = "-";
                CfOrder order;
                if (orders.TryGetValue(shopOrder.OrderId, out order) && !string.IsNullOrWhiteSpace(order.OrderCode))
                {
                    orderCode = order.OrderCode;
                }

                var products = orderItems
                    .Where(i => i.OrderId == shopOrder.OrderId)
                    .Select(i => i.ProductName)
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Distinct()
                    .ToList();

                var orderStatusId = orders.ContainsKey(shopOrder.OrderId) ? orders[shopOrder.OrderId].OrderStatusId : null;
                var statusCode = orders.ContainsKey(shopOrder.OrderId) && !string.IsNullOrWhiteSpace(orders[shopOrder.OrderId].OrderStatus)
                    ? orders[shopOrder.OrderId].OrderStatus
                    : shopOrder.OrderStatus;
                var statusLabel = ResolveStatusName(orderStatusId, statusCode);

                rows.Add(new ExportRow
                {
                    OrderCode = orderCode,
                    ProductNames = products.Count > 0 ? string.Join("; ", products) : "-",
                    OrderTotal = FormatCurrency(shopOrder.Total),
                    StatusLabel = statusLabel,
                    ShippingMethod = string.IsNullOrWhiteSpace(shopOrder.ShippingMethod) ? "-" : shopOrder.ShippingMethod
                });
            }

            var fileName = "don-hang-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx";
            SaveExportHistory(db, sellerId.Value, filteredOrders.Count, fileName);
            WriteXlsxResponse(rows, fileName);
        }
    }

    private static string BuildTitle(string statusKey)
    {
        if (string.IsNullOrWhiteSpace(statusKey) || string.Equals(statusKey, "all", StringComparison.OrdinalIgnoreCase))
        {
            return "Tất cả";
        }

        if (string.Equals(statusKey, "NEW", StringComparison.OrdinalIgnoreCase))
        {
            return "Đơn mới";
        }
        if (string.Equals(statusKey, "CONFIRMED", StringComparison.OrdinalIgnoreCase))
        {
            return "Đã xác nhận";
        }
        if (string.Equals(statusKey, "PACKING", StringComparison.OrdinalIgnoreCase))
        {
            return "Đang đóng gói";
        }
        if (string.Equals(statusKey, "COMPLETED", StringComparison.OrdinalIgnoreCase))
        {
            return "Hoàn tất";
        }
        if (string.Equals(statusKey, "READY_TO_SHIP", StringComparison.OrdinalIgnoreCase))
        {
            return "Sẵn sàng giao";
        }
        if (string.Equals(statusKey, "SHIPPED", StringComparison.OrdinalIgnoreCase))
        {
            return "Đã bàn giao";
        }
        if (string.Equals(statusKey, "CANCELLED", StringComparison.OrdinalIgnoreCase))
        {
            return "Đã hủy";
        }
        if (string.Equals(statusKey, "DELIVERING", StringComparison.OrdinalIgnoreCase))
        {
            return "Đang giao";
        }
        if (string.Equals(statusKey, "DELIVERED", StringComparison.OrdinalIgnoreCase))
        {
            return "Đã giao";
        }

        return statusKey;
    }

    private List<CfShopOrder> ApplyStatusFilter(List<CfShopOrder> orders, Dictionary<int, CfOrder> orderLookup, string statusKey)
    {
        if (string.IsNullOrWhiteSpace(statusKey) || string.Equals(statusKey, "all", StringComparison.OrdinalIgnoreCase))
        {
            return orders;
        }

        return orders
            .Where(o => IsStatusMatch(o, orderLookup, statusKey))
            .ToList();
    }

    private bool IsStatusMatch(CfShopOrder order, Dictionary<int, CfOrder> orderLookup, string statusKey)
    {
        if (order == null)
        {
            return false;
        }

        int statusId;
        if (_statusCodeIdLookup.TryGetValue(statusKey, out statusId))
        {
            CfOrder detail;
            if (orderLookup != null && orderLookup.TryGetValue(order.OrderId, out detail) && detail.OrderStatusId.HasValue)
            {
                return detail.OrderStatusId.Value == statusId;
            }
            return false;
        }

        var rawStatus = order.OrderStatus;
        if (orderLookup != null && orderLookup.ContainsKey(order.OrderId))
        {
            var orderDetail = orderLookup[order.OrderId];
            if (!string.IsNullOrWhiteSpace(orderDetail.OrderStatus))
            {
                rawStatus = orderDetail.OrderStatus;
            }
        }
        if (string.IsNullOrWhiteSpace(rawStatus))
        {
            return false;
        }

        return string.Equals(rawStatus.Trim(), statusKey, StringComparison.OrdinalIgnoreCase);
    }


    private string BuildStatusHtml(int? orderStatusId, string orderStatusCode, DateTime createdAt)
    {
        var label = ResolveStatusName(orderStatusId, orderStatusCode);
        var className = GetStatusClass(orderStatusId, orderStatusCode);
        return string.Format(
            "<span class=\"status-pill {0}\">{1}</span><div class=\"status-time\">{2}</div>",
            className,
            HttpUtility.HtmlEncode(label),
            createdAt.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture));
    }

    private static string BuildShippingHtml(CfShopOrder shopOrder, string shippingCode)
    {
        var shipName = !string.IsNullOrWhiteSpace(shopOrder.ShippingMethod) ? shopOrder.ShippingMethod : "-";
        return string.Format(
            "<div class=\"ship-name\">{0}</div><div class=\"ship-code\">{1}</div>",
            HttpUtility.HtmlEncode(shipName),
            HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(shippingCode) ? "-" : shippingCode));
    }

    private string GetStatusClass(int? orderStatusId, string orderStatusCode)
    {
        var statusCode = ResolveStatusCode(orderStatusId, orderStatusCode);
        if (string.IsNullOrWhiteSpace(statusCode))
        {
            return "status-pending";
        }

        var status = statusCode.ToUpperInvariant();
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

    private string ResolveStatusName(int? statusId, string statusCode)
    {
        if (statusId.HasValue && _statusIdNameLookup.ContainsKey(statusId.Value))
        {
            return _statusIdNameLookup[statusId.Value];
        }

        if (string.IsNullOrWhiteSpace(statusCode))
        {
            return "Đang xử lý";
        }

        string name;
        return _statusNameLookup.TryGetValue(statusCode, out name) ? name : statusCode;
    }

    private string ResolveStatusCode(int? statusId, string statusCode)
    {
        if (statusId.HasValue && _statusIdCodeLookup.ContainsKey(statusId.Value))
        {
            return _statusIdCodeLookup[statusId.Value];
        }

        return statusCode ?? string.Empty;
    }

    private void BindShippingMethods()
    {
        using (var db = new BeautyStoryContext())
        {
            var items = db.CfShippingMethods
                .Where(s => s.Status)
                .OrderBy(s => s.SortOrder)
                .ThenBy(s => s.Name)
                .Select(s => new { s.Id, s.Name })
                .ToList();

            ShippingMethodDropDown.Items.Clear();
            ShippingMethodDropDown.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả vị VN/VC", ""));
            foreach (var item in items)
            {
                ShippingMethodDropDown.Items.Add(new System.Web.UI.WebControls.ListItem(item.Name, item.Id.ToString()));
            }
        }
    }

    private static string ResolveShippingName(BeautyStoryContext db, int? shippingMethodId)
    {
        if (!shippingMethodId.HasValue)
        {
            return string.Empty;
        }

        var method = db.CfShippingMethods.FirstOrDefault(s => s.Id == shippingMethodId.Value);
        return method != null ? method.Name : string.Empty;
    }

    private static int? ParseNullableInt(string raw)
    {
        int value;
        if (int.TryParse(raw, out value))
        {
            return value;
        }
        return null;
    }

    private string BuildFilterUrl(bool includeHistory, bool resetPage, bool clearFilters = false)
    {
        var query = new List<string>();

        if (!string.IsNullOrWhiteSpace(_statusKey))
        {
            query.Add("status=" + HttpUtility.UrlEncode(_statusKey));
        }

        if (!clearFilters)
        {
            var code = (OrderCodeTextBox.Text ?? string.Empty).Trim();
            if (!string.IsNullOrWhiteSpace(code))
            {
                query.Add("code=" + HttpUtility.UrlEncode(code));
            }

            var shippingIdRaw = ShippingMethodDropDown.SelectedValue;
            if (!string.IsNullOrWhiteSpace(shippingIdRaw))
            {
                query.Add("shippingId=" + HttpUtility.UrlEncode(shippingIdRaw));
            }
        }

        if (!resetPage && _currentPage > 1)
        {
            query.Add("page=" + _currentPage);
        }

        if (includeHistory)
        {
            query.Add("history=1");
        }

        if (query.Count == 0)
        {
            return "/seller/order-list.aspx";
        }

        return "/seller/order-list.aspx?" + string.Join("&", query);
    }

    private void SyncQueryState()
    {
        _statusKey = (Request.QueryString["status"] ?? "all").Trim();
        _currentPage = ParsePage(Request.QueryString["page"]);
        _showExportHistory = string.Equals(Request.QueryString["history"], "1", StringComparison.OrdinalIgnoreCase);
    }

    private void BindExportHistory()
    {
        if (!_showExportHistory)
        {
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var records = db.CfOrderExportHistories
                .Where(h => h.Status && h.SellerId == sellerId.Value)
                .OrderByDescending(h => h.CreatedAt)
                .Take(10)
                .ToList();

            var viewModels = records.Select(r =>
            {
                return new ExportHistoryViewModel
                {
                    CreatedAtText = r.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
                    TotalOrders = r.TotalOrders.ToString(CultureInfo.InvariantCulture),
                    FileName = r.FileName,
                    DownloadUrl = BuildHistoryDownloadUrl(r.Id)
                };
            }).ToList();

            ExportHistoryRepeater.DataSource = viewModels;
            ExportHistoryRepeater.DataBind();

            ExportHistoryCloseLink.NavigateUrl = BuildFilterUrl(includeHistory: false, resetPage: false);
        }
    }

    private void SaveExportHistory(BeautyStoryContext db, int sellerId, int totalOrders, string fileName)
    {
        var now = DateTime.Now;
        var history = new CfOrderExportHistory
        {
            SellerId = sellerId,
            StatusKey = _statusKey,
            SearchCode = _searchCode,
            ShippingMethodId = _shippingMethodId,
            TotalOrders = totalOrders,
            FileName = fileName,
            Status = true,
            CreatedAt = now,
            CreatedBy = "Seller:" + sellerId.ToString(CultureInfo.InvariantCulture),
            SortOrder = 0
        };

        db.CfOrderExportHistories.Add(history);
        db.SaveChanges();
    }

    private void WriteXlsxResponse(List<ExportRow> rows, string fileName)
    {
        var bytes = BuildXlsx(rows);
        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        Response.BinaryWrite(bytes);
        Response.End();
    }

    private static byte[] BuildXlsx(List<ExportRow> rows)
    {
        var headers = new[] { "Mã đơn hàng", "Sản phẩm", "Tổng đơn hàng", "Trạng thái", "Đơn vị vận chuyển" };
        var data = new List<string[]>
        {
            headers
        };

        foreach (var row in rows)
        {
            data.Add(new[]
            {
                row.OrderCode ?? string.Empty,
                row.ProductNames ?? string.Empty,
                row.OrderTotal ?? string.Empty,
                row.StatusLabel ?? string.Empty,
                row.ShippingMethod ?? string.Empty
            });
        }

        using (var stream = new MemoryStream())
        {
            using (var archive = new ZipArchive(stream, ZipArchiveMode.Create, true))
            {
                AddZipEntry(archive, "[Content_Types].xml", BuildContentTypesXml());
                AddZipEntry(archive, "_rels/.rels", BuildRootRelsXml());
                AddZipEntry(archive, "xl/workbook.xml", BuildWorkbookXml());
                AddZipEntry(archive, "xl/_rels/workbook.xml.rels", BuildWorkbookRelsXml());
                AddZipEntry(archive, "xl/worksheets/sheet1.xml", BuildWorksheetXml(data));
            }

            return stream.ToArray();
        }
    }

    private static void AddZipEntry(ZipArchive archive, string path, string content)
    {
        var entry = archive.CreateEntry(path, CompressionLevel.Fastest);
        using (var writer = new StreamWriter(entry.Open(), Encoding.UTF8))
        {
            writer.Write(content);
        }
    }

    private static string BuildContentTypesXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">"
            + "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>"
            + "<Default Extension=\"xml\" ContentType=\"application/xml\"/>"
            + "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>"
            + "<Override PartName=\"/xl/worksheets/sheet1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>"
            + "</Types>";
    }

    private static string BuildRootRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorkbookXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" "
            + "xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">"
            + "<sheets><sheet name=\"Orders\" sheetId=\"1\" r:id=\"rId1\"/></sheets>"
            + "</workbook>";
    }

    private static string BuildWorkbookRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorksheetXml(List<string[]> rows)
    {
        var builder = new StringBuilder();
        builder.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        builder.Append("<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
        builder.Append("<sheetData>");

        for (var i = 0; i < rows.Count; i++)
        {
            var rowIndex = i + 1;
            builder.Append("<row r=\"").Append(rowIndex).Append("\">");
            var cols = rows[i];
            for (var c = 0; c < cols.Length; c++)
            {
                var cellRef = ColumnName(c) + rowIndex.ToString(CultureInfo.InvariantCulture);
                builder.Append("<c r=\"").Append(cellRef).Append("\" t=\"inlineStr\"><is><t xml:space=\"preserve\">");
                builder.Append(EscapeXml(cols[c] ?? string.Empty));
                builder.Append("</t></is></c>");
            }
            builder.Append("</row>");
        }

        builder.Append("</sheetData>");
        builder.Append("</worksheet>");
        return builder.ToString();
    }

    private static string ColumnName(int index)
    {
        var dividend = index + 1;
        var name = string.Empty;
        while (dividend > 0)
        {
            var modulo = (dividend - 1) % 26;
            name = Convert.ToChar(65 + modulo) + name;
            dividend = (dividend - modulo) / 26;
        }
        return name;
    }

    private static string EscapeXml(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return string.Empty;
        }

        return value
            .Replace("&", "&amp;")
            .Replace("<", "&lt;")
            .Replace(">", "&gt;")
            .Replace("\"", "&quot;")
            .Replace("'", "&apos;");
    }

    private string BuildHistoryDownloadUrl(int historyId)
    {
        var baseUrl = BuildFilterUrl(includeHistory: true, resetPage: false);
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "exportHistoryId=" + historyId.ToString(CultureInfo.InvariantCulture);
    }

    private void ExportFromHistory(int historyId)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var record = db.CfOrderExportHistories.FirstOrDefault(h => h.Id == historyId && h.SellerId == sellerId.Value && h.Status);
            if (record == null)
            {
                return;
            }

            _statusKey = string.IsNullOrWhiteSpace(record.StatusKey) ? "all" : record.StatusKey;
            _searchCode = record.SearchCode ?? string.Empty;
            _shippingMethodId = record.ShippingMethodId;

            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return;
            }

            var shippingName = ResolveShippingName(db, _shippingMethodId);
            var shopOrdersQuery = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId));

            if (!string.IsNullOrWhiteSpace(shippingName))
            {
                shopOrdersQuery = shopOrdersQuery.Where(o => o.ShippingMethod == shippingName);
            }

            if (!string.IsNullOrWhiteSpace(_searchCode))
            {
                var orderIds = db.CfOrders
                    .Where(o => o.OrderCode.Contains(_searchCode))
                    .Select(o => o.Id)
                    .ToList();
                shopOrdersQuery = shopOrdersQuery.Where(o => orderIds.Contains(o.OrderId));
            }

            var shopOrders = shopOrdersQuery
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            var allOrderIds = shopOrders.Select(o => o.OrderId).Distinct().ToList();
            var orderLookupAll = db.CfOrders
                .Where(o => allOrderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var filteredOrders = ApplyStatusFilter(shopOrders, orderLookupAll, _statusKey);
            var orderIdsFiltered = filteredOrders.Select(o => o.OrderId).Distinct().ToList();

            var orders = orderLookupAll
                .Where(kvp => orderIdsFiltered.Contains(kvp.Key))
                .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

            var orderItems = db.CfOrderItems
                .Where(i => orderIdsFiltered.Contains(i.OrderId))
                .ToList();

            var statusRows = db.CfOrderStatuses
                .Where(s => s.Status)
                .ToList();

            _statusNameLookup = statusRows
                .ToDictionary(s => s.Code, s => s.Name, StringComparer.OrdinalIgnoreCase);
            _statusIdNameLookup = statusRows
                .ToDictionary(s => s.Id, s => s.Name);
            _statusIdCodeLookup = statusRows
                .ToDictionary(s => s.Id, s => s.Code);
            _statusCodeIdLookup = statusRows
                .ToDictionary(s => s.Code, s => s.Id, StringComparer.OrdinalIgnoreCase);

            var rows = new List<ExportRow>();
            foreach (var shopOrder in filteredOrders)
            {
                var orderCode = "-";
                CfOrder order;
                if (orders.TryGetValue(shopOrder.OrderId, out order) && !string.IsNullOrWhiteSpace(order.OrderCode))
                {
                    orderCode = order.OrderCode;
                }

                var products = orderItems
                    .Where(i => i.OrderId == shopOrder.OrderId)
                    .Select(i => i.ProductName)
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Distinct()
                    .ToList();

                var orderStatusId = orders.ContainsKey(shopOrder.OrderId) ? orders[shopOrder.OrderId].OrderStatusId : null;
                var statusCode = orders.ContainsKey(shopOrder.OrderId) && !string.IsNullOrWhiteSpace(orders[shopOrder.OrderId].OrderStatus)
                    ? orders[shopOrder.OrderId].OrderStatus
                    : shopOrder.OrderStatus;
                var statusLabel = ResolveStatusName(orderStatusId, statusCode);

                rows.Add(new ExportRow
                {
                    OrderCode = orderCode,
                    ProductNames = products.Count > 0 ? string.Join("; ", products) : "-",
                    OrderTotal = FormatCurrency(shopOrder.Total),
                    StatusLabel = statusLabel,
                    ShippingMethod = string.IsNullOrWhiteSpace(shopOrder.ShippingMethod) ? "-" : shopOrder.ShippingMethod
                });
            }

            var fileName = string.IsNullOrWhiteSpace(record.FileName)
                ? "don-hang-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx"
                : record.FileName;

            WriteXlsxResponse(rows, fileName);
        }
    }

    private class ExportRow
    {
        public string OrderCode { get; set; }
        public string ProductNames { get; set; }
        public string OrderTotal { get; set; }
        public string StatusLabel { get; set; }
        public string ShippingMethod { get; set; }
    }

    private class ExportHistoryViewModel
    {
        public string CreatedAtText { get; set; }
        public string TotalOrders { get; set; }
        public string FileName { get; set; }
        public string DownloadUrl { get; set; }
    }
}

