using System;
using System.Collections.Generic;
using System.Linq;

public partial class AdminOrdersEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindStatuses();
            LoadOrder();
        }
    }

    private void BindStatuses()
    {
        using (var db = new BeautyStoryContext())
        {
            var orderStatuses = db.CfOrderStatuses.Where(s => s.Status)
                .OrderBy(s => s.SortOrder).ThenBy(s => s.Name).ToList();
            OrderStatusInput.Items.Clear();
            foreach (var item in orderStatuses)
            {
                OrderStatusInput.Items.Add(new System.Web.UI.WebControls.ListItem(item.Name, item.Id.ToString()));
            }

            var paymentStatuses = db.CfPaymentStatuses.Where(s => s.Status)
                .OrderBy(s => s.SortOrder).ThenBy(s => s.Name).ToList();
            PaymentStatusInput.Items.Clear();
            foreach (var item in paymentStatuses)
            {
                PaymentStatusInput.Items.Add(new System.Web.UI.WebControls.ListItem(item.Name, item.Id.ToString()));
            }
        }
    }

    private void LoadOrder()
    {
        int orderId;
        if (!int.TryParse(Request.QueryString["id"], out orderId))
        {
            OrderPanel.Visible = false;
            ErrorMessage.Text = "Không tìm thấy đơn hàng.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.Id == orderId);
            if (order == null)
            {
                OrderPanel.Visible = false;
                ErrorMessage.Text = "Không tìm thấy đơn hàng.";
                return;
            }

            OrderIdField.Value = order.Id.ToString();
            OrderCodeLiteral.Text = order.OrderCode;
            OrderDateLiteral.Text = order.CreatedAt.ToString("dd/MM/yyyy HH:mm");
            CustomerLiteral.Text = order.CustomerName;
            PhoneLiteral.Text = order.Phone;
            AddressLiteral.Text = string.Format("{0}, {1}, {2}", order.AddressLine, order.WardName, order.ProvinceName);
            NoteLiteral.Text = string.IsNullOrWhiteSpace(order.Note) ? "-" : order.Note;

            if (order.OrderStatusId.HasValue)
            {
                OrderStatusInput.SelectedValue = order.OrderStatusId.Value.ToString();
            }

            if (order.PaymentStatusId.HasValue)
            {
                PaymentStatusInput.SelectedValue = order.PaymentStatusId.Value.ToString();
            }

            PaymentMethodLiteral.Text = string.IsNullOrWhiteSpace(order.PaymentMethod) ? "-" : order.PaymentMethod;
            ShippingLiteral.Text = string.IsNullOrWhiteSpace(order.ShippingMethod) ? "-" : order.ShippingMethod;
            ShippingFeeLiteral.Text = FormatMoney(order.ShippingFee);
            ShippingEtaLiteral.Text = string.IsNullOrWhiteSpace(order.ShippingEta) ? "-" : order.ShippingEta;
            SubtotalLiteral.Text = FormatMoney(order.Subtotal);
            DiscountLiteral.Text = order.Discount > 0 ? "-" + FormatMoney(order.Discount) : FormatMoney(0);
            TotalLiteral.Text = FormatMoney(order.Total);

            InvoiceRequiredLiteral.Text = order.InvoiceRequired ? "Có" : "Không";
            InvoiceCompanyLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceCompanyName) ? "-" : order.InvoiceCompanyName;
            InvoiceTaxLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceTaxCode) ? "-" : order.InvoiceTaxCode;
            InvoiceEmailLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceEmail) ? "-" : order.InvoiceEmail;
            InvoiceAddressLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceAddress) ? "-" : order.InvoiceAddress;

            var items = db.CfOrderItems.Where(i => i.OrderId == order.Id)
                .OrderBy(i => i.Id)
                .Select(i => new
                {
                    i.ProductName,
                    i.VariantName,
                    i.Price,
                    i.SalePrice,
                    i.Quantity,
                    i.LineTotal
                }).ToList()
                .Select(i => new OrderItemView
                {
                    ProductName = i.ProductName,
                    VariantName = i.VariantName,
                    PriceText = FormatMoney(i.SalePrice.HasValue && i.SalePrice.Value > 0 ? i.SalePrice.Value : i.Price),
                    Quantity = i.Quantity,
                    LineTotalText = FormatMoney(i.LineTotal)
                }).ToList();

            ItemsRepeater.DataSource = items;
            ItemsRepeater.DataBind();

            var histories = db.CfOrderHistories.Where(h => h.OrderId == order.Id && h.Status)
                .OrderByDescending(h => h.CreatedAt)
                .Select(h => new
                {
                    h.Action,
                    h.Note,
                    h.CreatedAt
                }).ToList()
                .Select(h => new HistoryView
                {
                    Action = h.Action,
                    Note = h.Note,
                    CreatedAt = h.CreatedAt.ToString("dd/MM/yyyy HH:mm")
                }).ToList();

            HistoryRepeater.DataSource = histories;
            HistoryRepeater.DataBind();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        SaveMessage.Text = string.Empty;
        SaveMessage.CssClass = "text-danger small d-block mb-2";

        int orderId;
        if (!int.TryParse(OrderIdField.Value, out orderId))
        {
            SaveMessage.Text = "Không tìm thấy đơn hàng.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.Id == orderId);
            if (order == null)
            {
                SaveMessage.Text = "Không tìm thấy đơn hàng.";
                return;
            }

            int newOrderStatusId;
            int newPaymentStatusId;
            int.TryParse(OrderStatusInput.SelectedValue, out newOrderStatusId);
            int.TryParse(PaymentStatusInput.SelectedValue, out newPaymentStatusId);

            bool statusChanged = order.OrderStatusId != newOrderStatusId;
            bool paymentChanged = order.PaymentStatusId != newPaymentStatusId;

            var previousStatus = order.OrderStatusId.HasValue
                ? db.CfOrderStatuses.FirstOrDefault(s => s.Id == order.OrderStatusId.Value)
                : null;
            var newStatus = db.CfOrderStatuses.FirstOrDefault(s => s.Id == newOrderStatusId);
            var orderStatusName = newStatus != null ? newStatus.Name : null;
            var paymentStatusName = db.CfPaymentStatuses.Where(s => s.Id == newPaymentStatusId).Select(s => s.Name).FirstOrDefault();

            order.OrderStatusId = newOrderStatusId;
            order.OrderStatus = orderStatusName;
            order.PaymentStatusId = newPaymentStatusId;
            order.PaymentStatus = paymentStatusName;
            order.UpdatedAt = DateTime.UtcNow;
            order.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            if (statusChanged || paymentChanged)
            {
                var notes = new List<string>();
                if (statusChanged)
                {
                    notes.Add("Trạng thái đơn: " + (string.IsNullOrWhiteSpace(orderStatusName) ? "-" : orderStatusName));
                }
                if (paymentChanged)
                {
                    notes.Add("Thanh toán: " + (string.IsNullOrWhiteSpace(paymentStatusName) ? "-" : paymentStatusName));
                }

                db.CfOrderHistories.Add(new CfOrderHistory
                {
                    OrderId = order.Id,
                    Action = "Cập nhật trạng thái",
                    Note = string.Join("; ", notes),
                    Status = true,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin",
                    SortOrder = 0
                });
            }

            if (statusChanged && IsCompletedStatus(newStatus) != IsCompletedStatus(previousStatus))
            {
                var items = db.CfOrderItems
                    .Where(i => i.OrderId == order.Id)
                    .Select(i => new { i.ProductId, i.Quantity })
                    .ToList();
                var qtyByProduct = items
                    .GroupBy(i => i.ProductId)
                    .ToDictionary(g => g.Key, g => g.Sum(x => x.Quantity));
                var productIds = qtyByProduct.Keys.ToList();
                var products = db.CfProducts.Where(p => productIds.Contains(p.Id)).ToList();
                var delta = IsCompletedStatus(newStatus) ? 1 : -1;
                foreach (var product in products)
                {
                    int qty;
                    if (qtyByProduct.TryGetValue(product.Id, out qty))
                    {
                        product.Sold30d += qty * delta;
                        if (product.Sold30d < 0)
                        {
                            product.Sold30d = 0;
                        }
                    }
                }
            }
            db.SaveChanges();
        }

        SaveMessage.CssClass = "text-success small d-block mb-2";
        SaveMessage.Text = "Cập nhật thành công.";
        LoadOrder();
    }

    private static bool IsCompletedStatus(CfOrderStatus status)
    {
        if (status == null)
        {
            return false;
        }

        var code = (status.Code ?? string.Empty).Trim().ToLowerInvariant();
        var name = (status.Name ?? string.Empty).Trim().ToLowerInvariant();
        return code == "completed"
            || name.Contains("hoàn thành")
            || name.Contains("hoàn tất");
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    public class OrderItemView
    {
        public string ProductName { get; set; }
        public string VariantName { get; set; }
        public string PriceText { get; set; }
        public int Quantity { get; set; }
        public string LineTotalText { get; set; }
    }

    public class HistoryView
    {
        public string Action { get; set; }
        public string Note { get; set; }
        public string CreatedAt { get; set; }
    }
}
