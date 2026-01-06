using System;
using System.Linq;

public partial class CustomerOrderDetail : CustomerPageBase
{
    private class OrderHistoryItem
    {
        public string Note { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindOrder();
        }
    }

    private void BindOrder()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        int orderId;
        if (!int.TryParse(Request.QueryString["id"], out orderId))
        {
            EmptyPanel.Visible = true;
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.Id == orderId && o.CustomerId == customerId.Value);
            if (order == null)
            {
                EmptyPanel.Visible = true;
                return;
            }

            OrderInfoLiteral.Text = string.Format("<p>Mã đơn: {0} | Tổng: {1:N0} đ</p>",
                order.OrderCode,
                order.Total);

            OrderStatusLiteral.Text = string.IsNullOrWhiteSpace(order.OrderStatus) ? "Đang xử lý" : order.OrderStatus;
            PaymentStatusLiteral.Text = string.IsNullOrWhiteSpace(order.PaymentStatus) ? "Chưa thanh toán" : order.PaymentStatus;
            ShippingMethodLiteral.Text = string.IsNullOrWhiteSpace(order.ShippingMethod) ? "Chưa cập nhật" : order.ShippingMethod;
            ShippingFeeLiteral.Text = order.ShippingFee > 0 ? string.Format("{0:N0} đ", order.ShippingFee) : "Miễn phí";
            OrderDateLiteral.Text = order.CreatedAt.ToString("dd/MM/yyyy HH:mm");

            var addressText = string.Format("{0} {1} {2}",
                order.AddressLine,
                order.WardName,
                order.ProvinceName).Trim();
            ShippingAddressLiteral.Text = string.IsNullOrWhiteSpace(addressText) ? "Chưa cập nhật" : addressText;
            OrderNoteLiteral.Text = string.IsNullOrWhiteSpace(order.Note) ? "Không có" : order.Note;

            var items = db.CfOrderItems
                .Where(i => i.OrderId == orderId)
                .OrderByDescending(i => i.Id)
                .ToList();

            var productIds = items.Select(i => i.ProductId).Distinct().ToList();
            var productShopMap = db.CfProducts
                .Where(p => productIds.Contains(p.Id))
                .Select(p => new { p.Id, p.ShopId })
                .ToList()
                .ToDictionary(p => p.Id, p => p.ShopId ?? 0);

            var shopIds = productShopMap.Values.Where(v => v > 0).Distinct().ToList();
            var shopLookup = db.CfShops
                .Where(s => shopIds.Contains(s.Id))
                .ToList()
                .ToDictionary(s => s.Id, s => new { s.ShopName, s.ShopCode });

            var orderHistories = db.CfOrderHistories
                .Where(h => h.OrderId == orderId)
                .OrderByDescending(h => h.CreatedAt)
                .Select(h => new OrderHistoryItem { Note = h.Note, CreatedAt = h.CreatedAt })
                .ToList();

            var grouped = items
                .GroupBy(i => productShopMap.ContainsKey(i.ProductId) ? productShopMap[i.ProductId] : 0)
                .Select(g =>
                {
                    var shopId = g.Key;
                    return new
                    {
                        ShopId = shopId,
                        ShopName = shopId > 0 && shopLookup.ContainsKey(shopId) ? shopLookup[shopId].ShopName : "LoveIs",
                        ShopUrl = shopId > 0 && shopLookup.ContainsKey(shopId) && !string.IsNullOrWhiteSpace(shopLookup[shopId].ShopCode)
                            ? "/cua-hang/" + shopLookup[shopId].ShopCode
                            : "#",
                        Items = g.ToList()
                    };
                })
                .ToList();

            ShopRepeater.DataSource = grouped;
            ShopRepeater.DataBind();
            EmptyPanel.Visible = items.Count == 0;

            if (orderHistories.Count == 0)
            {
                orderHistories.Add(new OrderHistoryItem
                {
                    Note = "Chưa có cập nhật",
                    CreatedAt = order.CreatedAt
                });
            }
            OrderHistoryRepeater.DataSource = orderHistories;
            OrderHistoryRepeater.DataBind();

            SubtotalLiteral.Text = order.Subtotal > 0 ? string.Format("{0:N0} đ", order.Subtotal) : "0 đ";
            OrderShippingFeeLiteral.Text = order.ShippingFee > 0 ? string.Format("{0:N0} đ", order.ShippingFee) : "0 đ";
            OrderTotalLiteral.Text = order.Total > 0 ? string.Format("{0:N0} đ", order.Total) : "0 đ";
        }
    }
}
