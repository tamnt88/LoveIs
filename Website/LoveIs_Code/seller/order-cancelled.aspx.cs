using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public partial class SellerCancelledOrders : System.Web.UI.Page
{
    private const int PageSize = 10;
    private int _currentPage = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCancelledOrders();
        }
    }

    private void BindCancelledOrders()
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
                CancelTotalLiteral.Text = "0";
                CancelByCustomerLiteral.Text = "0";
                CancelByShopLiteral.Text = "0";
                CancelTotalAmountLiteral.Text = "0 đ";
                CancelRepeater.DataSource = new List<CancelRowViewModel>();
                CancelRepeater.DataBind();
                PaginationLiteral.Text = string.Empty;
                return;
            }

            var cancelledOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.OrderStatus == "CANCELLED")
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            var totalOrders = cancelledOrders.Count;
            var totalPages = (int)Math.Ceiling(totalOrders / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var pagedOrders = cancelledOrders
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var orderIds = pagedOrders.Select(o => o.OrderId).Distinct().ToList();
            var orders = db.CfOrders
                .Where(o => orderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var orderItems = db.CfOrderItems
                .Where(i => orderIds.Contains(i.OrderId))
                .ToList();

            CancelTotalLiteral.Text = totalOrders.ToString();
            CancelByCustomerLiteral.Text = totalOrders.ToString();
            CancelByShopLiteral.Text = "0";
            CancelTotalAmountLiteral.Text = string.Format("{0:N0} đ", cancelledOrders.Sum(o => o.Total));

            var rows = new List<CancelRowViewModel>();
            foreach (var shopOrder in pagedOrders)
            {
                CfOrder order;
                orders.TryGetValue(shopOrder.OrderId, out order);
                var item = orderItems.FirstOrDefault(i => i.OrderId == shopOrder.OrderId);

                rows.Add(new CancelRowViewModel
                {
                    OrderCode = order != null ? order.OrderCode : "-",
                    CustomerName = order != null ? order.CustomerName : "-",
                    ProductName = item != null ? item.ProductName : "-",
                    Quantity = item != null ? item.Quantity.ToString() : "-",
                    TotalLabel = string.Format("{0:N0} đ", shopOrder.Total),
                    CancelledAt = shopOrder.CreatedAt.ToString("dd/MM/yyyy"),
                    Reason = "Khách hàng đổi ý",
                    CancelledBy = "Khách hàng",
                    CancelledByClass = "cancel-customer"
                });
            }

            CancelRepeater.DataSource = rows;
            CancelRepeater.DataBind();
            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(totalOrders);
        }
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
        var baseUrl = "/seller/cancelled.aspx";

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
            return "Hiển thị 0 trong tổng số 0 đơn hủy";
        }
        int start = (_currentPage - 1) * PageSize + 1;
        int end = Math.Min(_currentPage * PageSize, totalItems);
        return string.Format("Hiển thị {0}-{1} trong tổng số {2} đơn hủy", start, end, totalItems);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    public class CancelRowViewModel
    {
        public string OrderCode { get; set; }
        public string CustomerName { get; set; }
        public string ProductName { get; set; }
        public string Quantity { get; set; }
        public string TotalLabel { get; set; }
        public string CancelledAt { get; set; }
        public string Reason { get; set; }
        public string CancelledBy { get; set; }
        public string CancelledByClass { get; set; }
    }
}
