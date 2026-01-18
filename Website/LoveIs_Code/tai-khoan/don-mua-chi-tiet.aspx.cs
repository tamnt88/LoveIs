                                                                                                               using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CustomerOrderDetail : CustomerPageBase
{
    private class OrderHistoryItem
    {
        public string Note { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    private class ReturnItemOption
    {
        public int OrderItemId { get; set; }
        public string ProductName { get; set; }
        public string VariantName { get; set; }
        public int Quantity { get; set; }
    }

        protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack && OpenCancelModalField != null && OpenCancelModalField.Value == "1")
        {
            OpenCancelModalField.Value = string.Empty;
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "openCancelModal",
                "var modal = new bootstrap.Modal(document.getElementById('CancelOrderModal')); modal.show();",
                true);
        }

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

            OrderInfoLiteral.Text = string.Format("<p>Mã đơn: {0} | Tổng: {1:N0} đ</p>", order.OrderCode, order.Total);
                        var orderStatusText = string.IsNullOrWhiteSpace(order.OrderStatus) ? "Đang xử lý" : order.OrderStatus;
            var paymentStatusText = string.IsNullOrWhiteSpace(order.PaymentStatus) ? "Chưa thanh toán" : order.PaymentStatus;
            var shippingText = string.IsNullOrWhiteSpace(order.ShippingMethod) ? "Chưa cập nhật" : order.ShippingMethod;

            OrderStatusLiteral.Text = BuildStatusTag(orderStatusText, GetOrderStatusClass(orderStatusText), GetOrderStatusIcon(orderStatusText));
            PaymentStatusLiteral.Text = BuildStatusTag(paymentStatusText, GetPaymentStatusClass(paymentStatusText), GetPaymentStatusIcon(paymentStatusText));
            ShippingMethodLiteral.Text = BuildStatusTag(shippingText, "status-tag status-tag--info", "fa-solid fa-truck-fast");            ShippingFeeLiteral.Text = order.ShippingFee > 0 ? string.Format("{0:N0} đ", order.ShippingFee) : "Miễn phí";
            OrderDateLiteral.Text = order.CreatedAt.ToString("dd/MM/yyyy HH:mm");

            var addressText = string.Format("{0} {1} {2}", order.AddressLine, order.WardName, order.ProvinceName).Trim();
            ShippingAddressLiteral.Text = string.IsNullOrWhiteSpace(addressText) ? "Chưa cập nhật" : addressText;
            OrderNoteLiteral.Text = string.IsNullOrWhiteSpace(order.Note) ? "Không có" : order.Note;

            InvoiceInfoButton.Visible = order.InvoiceRequired;
            InvoiceNoneLiteral.Text = order.InvoiceRequired ? string.Empty : "Không xuất hóa đơn";
            InvoiceCompanyLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceCompanyName) ? "Không có" : order.InvoiceCompanyName;
            InvoiceTaxLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceTaxCode) ? "Không có" : order.InvoiceTaxCode;
            InvoiceEmailLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceEmail) ? "Không có" : order.InvoiceEmail;
            InvoiceAddressLiteral.Text = string.IsNullOrWhiteSpace(order.InvoiceAddress) ? "Không có" : order.InvoiceAddress;

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

            var shopOrders = db.CfShopOrders
                .Where(so => so.OrderId == orderId)
                .ToList()
                .ToDictionary(so => so.ShopId, so => so);

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
                        ShopStatusText = shopOrders.ContainsKey(shopId) && !string.IsNullOrWhiteSpace(shopOrders[shopId].OrderStatus)
                            ? shopOrders[shopId].OrderStatus
                            : "Đang xử lý",
                        ShopStatusClass = GetOrderStatusClass(shopOrders.ContainsKey(shopId) ? shopOrders[shopId].OrderStatus : string.Empty),
                        ShopStatusIconClass = GetOrderStatusIcon(shopOrders.ContainsKey(shopId) ? shopOrders[shopId].OrderStatus : string.Empty),
                        ShopPaymentStatusText = shopOrders.ContainsKey(shopId) && !string.IsNullOrWhiteSpace(shopOrders[shopId].PaymentStatus)
                            ? shopOrders[shopId].PaymentStatus
                            : "Chưa thanh toán",
                        ShopPaymentStatusClass = GetPaymentStatusClass(shopOrders.ContainsKey(shopId) ? shopOrders[shopId].PaymentStatus : string.Empty),
                        ShopPaymentIconClass = GetPaymentStatusIcon(shopOrders.ContainsKey(shopId) ? shopOrders[shopId].PaymentStatus : string.Empty),
                        ShopShippingFeeText = shopOrders.ContainsKey(shopId) && shopOrders[shopId].ShippingFee > 0
                            ? string.Format("{0:N0} đ", shopOrders[shopId].ShippingFee)
                            : "Miễn phí",
                        ShopSubtotalText = shopOrders.ContainsKey(shopId) && shopOrders[shopId].Subtotal > 0
                            ? string.Format("{0:N0} đ", shopOrders[shopId].Subtotal)
                            : "0 đ",
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
            ShippingFeeLiteral.Text = order.ShippingFee > 0 ? string.Format("{0:N0} đ", order.ShippingFee) : "Miễn phí";
            OrderTotalLiteral.Text = order.Total > 0 ? string.Format("{0:N0} đ", order.Total) : "0 đ";

            OrderIdField.Value = order.Id.ToString();

            var statusCode = GetOrderStatusCode(db, order.OrderStatusId);
            var hasReturn = db.CfReturnRequests.Any(r => r.OrderId == order.Id);

            OrderActionPanel.Visible = true;
            CancelOrderButton.Visible = statusCode == "NEW" || statusCode == "CONFIRMED";
            RequestRefundButton.Visible = statusCode == "COMPLETED" && !hasReturn;
            RequestReturnButton.Visible = statusCode == "COMPLETED" && !hasReturn;
            ReturnItemsPanel.Visible = RequestRefundButton.Visible || RequestReturnButton.Visible;
            ReturnReasonPanel.Visible = RequestRefundButton.Visible || RequestReturnButton.Visible;
            ReorderButton.Visible = true;

            BindReturnItems(items);

            if (hasReturn)
            {
                ActionMessageLiteral.Text = "<div class='text-muted'>Đơn hàng đã có yêu cầu đổi/trả hoặc hoàn tiền.</div>";
            }
        }
    }

    private void BindReturnItems(List<CfOrderItem> items)
    {
        if (ReturnItemsRepeater == null)
        {
            return;
        }

        var options = items != null
            ? items.Select(i => new ReturnItemOption
            {
                OrderItemId = i.Id,
                ProductName = i.ProductName,
                VariantName = i.VariantName,
                Quantity = i.Quantity
            }).ToList()
            : new List<ReturnItemOption>();

        ReturnItemsRepeater.DataSource = options;
        ReturnItemsRepeater.DataBind();
    }

    private static string GetOrderStatusCode(BeautyStoryContext db, int? statusId)
    {
        if (db == null || !statusId.HasValue)
        {
            return string.Empty;
        }

        var status = db.CfOrderStatuses.FirstOrDefault(s => s.Id == statusId.Value);
        return status != null ? (status.Code ?? string.Empty).Trim().ToUpperInvariant() : string.Empty;
    }

    
    
    
    
    
    private static bool IsCompletedStatus(CfOrderStatus status)
    {
        if (status == null)
        {
            return false;
        }

        var code = (status.Code ?? string.Empty).Trim().ToLowerInvariant();
        var name = (status.Name ?? string.Empty).Trim().ToLowerInvariant();
        var normalized = RemoveDiacritics(name);

        return code == "completed"
            || normalized.Contains("hoan thanh")
            || normalized.Contains("hoan tat")
            || normalized.Contains("completed");
    }

    private static CfOrderStatus FindCancelledStatus(BeautyStoryContext db)
    {
        if (db == null)
        {
            return null;
        }

        var statuses = db.CfOrderStatuses.Where(s => s.Status).ToList();
        return statuses.FirstOrDefault(s =>
        {
            var code = (s.Code ?? string.Empty).Trim().ToLowerInvariant();
            var name = (s.Name ?? string.Empty).Trim().ToLowerInvariant();
            var normalized = RemoveDiacritics(name);

            return code == "cancelled"
                || code == "canceled"
                || normalized.Contains("huy")
                || normalized.Contains("cancel");
        });
    }

    private static string RemoveDiacritics(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        var normalized = value.Normalize(NormalizationForm.FormD);
        var builder = new StringBuilder();
        foreach (var ch in normalized)
        {
            var category = CharUnicodeInfo.GetUnicodeCategory(ch);
            if (category != UnicodeCategory.NonSpacingMark)
            {
                builder.Append(ch);
            }
        }

        return builder.ToString().Normalize(NormalizationForm.FormC);
    }

    private static string GetOrderStatusClass(string status)
    {
        var normalized = RemoveDiacritics(status ?? string.Empty).ToLowerInvariant();
        if (normalized.Contains("huy") || normalized.Contains("cancel"))
        {
            return "status-tag status-tag--danger";
        }

        if (normalized.Contains("hoan thanh") || normalized.Contains("hoan tat") || normalized.Contains("completed"))
        {
            return "status-tag status-tag--success";
        }

        if (normalized.Contains("giao") || normalized.Contains("van chuyen") || normalized.Contains("shipping"))
        {
            return "status-tag status-tag--info";
        }

        if (normalized.Contains("xac nhan") || normalized.Contains("confirmed"))
        {
            return "status-tag status-tag--primary";
        }

        if (normalized.Contains("dat hang") || normalized.Contains("new"))
        {
            return "status-tag status-tag--warning";
        }

        return "status-tag status-tag--neutral";
    }

    private static string GetOrderStatusIcon(string status)
    {
        var normalized = RemoveDiacritics(status ?? string.Empty).ToLowerInvariant();
        if (normalized.Contains("huy") || normalized.Contains("cancel"))
        {
            return "fa-solid fa-circle-xmark";
        }

        if (normalized.Contains("hoan thanh") || normalized.Contains("hoan tat") || normalized.Contains("completed"))
        {
            return "fa-solid fa-circle-check";
        }

        if (normalized.Contains("giao") || normalized.Contains("van chuyen") || normalized.Contains("shipping"))
        {
            return "fa-solid fa-truck-fast";
        }

        if (normalized.Contains("xac nhan") || normalized.Contains("confirmed"))
        {
            return "fa-solid fa-clipboard-check";
        }

        if (normalized.Contains("dat hang") || normalized.Contains("new"))
        {
            return "fa-solid fa-receipt";
        }

        return "fa-solid fa-tag";
    }

    private static string GetPaymentStatusClass(string status)
    {
        var normalized = RemoveDiacritics(status ?? string.Empty).ToLowerInvariant();
        if (normalized.Contains("da thanh toan") || normalized.Contains("paid") || normalized.Contains("success"))
        {
            return "status-tag status-tag--success";
        }

        if (normalized.Contains("cho") || normalized.Contains("pending"))
        {
            return "status-tag status-tag--warning";
        }

        return "status-tag status-tag--neutral";
    }

    private static string GetPaymentStatusIcon(string status)
    {
        var normalized = RemoveDiacritics(status ?? string.Empty).ToLowerInvariant();
        if (normalized.Contains("da thanh toan") || normalized.Contains("paid") || normalized.Contains("success"))
        {
            return "fa-solid fa-circle-check";
        }

        if (normalized.Contains("cho") || normalized.Contains("pending"))
        {
            return "fa-solid fa-hourglass-half";
        }

        return "fa-solid fa-credit-card";
    }

    private static string BuildStatusTag(string text, string cssClass, string iconClass)
    {
        var safeText = string.IsNullOrWhiteSpace(text) ? "Không có" : text;
        var safeClass = string.IsNullOrWhiteSpace(cssClass) ? "status-tag status-tag--neutral" : cssClass;
        var safeIcon = string.IsNullOrWhiteSpace(iconClass) ? "fa-solid fa-tag" : iconClass;

        return string.Format("<span class=\"{0}\"><i class=\"{1}\"></i>{2}</span>", safeClass, safeIcon, safeText);
    }

    private static void RestockOrderItems(BeautyStoryContext db, int orderId)
    {
        if (db == null || orderId <= 0)
        {
            return;
        }

        var items = db.CfOrderItems
            .Where(i => i.OrderId == orderId)
            .Select(i => new { i.VariantId, i.Quantity })
            .ToList();

        var variantIds = items.Select(i => i.VariantId).Distinct().ToList();
        if (variantIds.Count == 0)
        {
            return;
        }

        var variants = db.CfProductVariants
            .Where(v => variantIds.Contains(v.Id))
            .ToList()
            .ToDictionary(v => v.Id, v => v);

        foreach (var item in items)
        {
            if (variants.ContainsKey(item.VariantId))
            {
                variants[item.VariantId].StockQty += item.Quantity;
            }
        }
    }

    private static void RestockReturnItems(BeautyStoryContext db, Dictionary<int, int> selected)
    {
        if (db == null || selected == null || selected.Count == 0)
        {
            return;
        }

        var itemIds = selected.Keys.ToList();
        var items = db.CfOrderItems
            .Where(i => itemIds.Contains(i.Id))
            .Select(i => new { i.Id, i.VariantId })
            .ToList();

        var variantIds = items.Select(i => i.VariantId).Distinct().ToList();
        if (variantIds.Count == 0)
        {
            return;
        }

        var variants = db.CfProductVariants
            .Where(v => variantIds.Contains(v.Id))
            .ToList()
            .ToDictionary(v => v.Id, v => v);

        foreach (var item in items)
        {
            if (!variants.ContainsKey(item.VariantId))
            {
                continue;
            }

            var qty = selected.ContainsKey(item.Id) ? selected[item.Id] : 0;
            if (qty > 0)
            {
                variants[item.VariantId].StockQty += qty;
            }
        }
    }

        protected void CancelOrderButton_Click(object sender, EventArgs e)
    {
        ActionMessageLiteral.Text = string.Empty;
        CancelReasonMessageLiteral.Text = string.Empty;

        int orderId;
        if (!int.TryParse(OrderIdField.Value, out orderId))
        {
            return;
        }

        var cancelReason = (CancelReasonInput.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(cancelReason))
        {
            CancelReasonMessageLiteral.Text = "<div class='text-danger mb-2'>Vui l?ng nh?p l? do h?y.</div>";
            OpenCancelModalField.Value = "1";
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.Id == orderId && o.CustomerId == customerId.Value);
            if (order == null)
            {
                return;
            }

            var status = order.OrderStatusId.HasValue
                ? db.CfOrderStatuses.FirstOrDefault(s => s.Id == order.OrderStatusId.Value)
                : null;

            var statusCode = status != null ? (status.Code ?? string.Empty).Trim().ToUpperInvariant() : string.Empty;
            if (statusCode != "NEW" && statusCode != "CONFIRMED")
            {
                ActionMessageLiteral.Text = "<div class='text-danger'>??n h?ng kh?ng th? h?y ? tr?ng th?i hi?n t?i.</div>";
                return;
            }

            var cancelStatus = FindCancelledStatus(db);
            if (cancelStatus == null)
            {
                ActionMessageLiteral.Text = "<div class='text-danger'>Ch?a c?u h?nh tr?ng th?i h?y.</div>";
                return;
            }

            order.OrderStatusId = cancelStatus.Id;
            order.OrderStatus = cancelStatus.Name;
            order.UpdatedAt = DateTime.UtcNow;
            order.UpdatedBy = "customer";

            db.CfOrderHistories.Add(new CfOrderHistory
            {
                OrderId = order.Id,
                Action = "H?y ??n h?ng",
                Note = cancelReason,
                Status = true,
                CreatedAt = DateTime.UtcNow,
                CreatedBy = "customer",
                SortOrder = 0
            });

            RestockOrderItems(db, order.Id);

            db.SaveChanges();
        }

        BindOrder();
    }

    protected void RequestRefundButton_Click(object sender, EventArgs e)
    {
        CreateReturnRequest("REFUND");
    }

    protected void RequestReturnButton_Click(object sender, EventArgs e)
    {
        CreateReturnRequest("RETURN");
    }

    protected void ReorderButton_Click(object sender, EventArgs e)
    {
        ActionMessageLiteral.Text = string.Empty;

        int orderId;
        if (!int.TryParse(OrderIdField.Value, out orderId))
        {
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.Id == orderId && o.CustomerId == customerId.Value);
            if (order == null)
            {
                return;
            }

            var items = db.CfOrderItems
                .Where(i => i.OrderId == orderId)
                .ToList();

            var addedTotal = 0;
            foreach (var item in items)
            {
                addedTotal += CartService.AddVariantWithResult(item.VariantId, item.Quantity);
            }

            if (addedTotal > 0)
            {
                Response.Redirect("/gio-hang");
                return;
            }

            ActionMessageLiteral.Text = "<div class='text-muted'>Không có sản phẩm nào có thể thêm vào giỏ hàng.</div>";
        }
    }

    private void CreateReturnRequest(string requestType)
    {
        ActionMessageLiteral.Text = string.Empty;

        int orderId;
        if (!int.TryParse(OrderIdField.Value, out orderId))
        {
            return;
        }

        var reason = (ReturnReasonInput.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(reason))
        {
            CancelReasonMessageLiteral.Text = "<div class='text-danger mb-2'>Vui l?ng nh?p l? do h?y.</div>";
            OpenCancelModalField.Value = "1";
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.Id == orderId && o.CustomerId == customerId.Value);
            if (order == null)
            {
                return;
            }

            var status = order.OrderStatusId.HasValue
                ? db.CfOrderStatuses.FirstOrDefault(s => s.Id == order.OrderStatusId.Value)
                : null;

            if (!IsCompletedStatus(status))
            {
                CancelReasonMessageLiteral.Text = "<div class='text-danger mb-2'>Vui l?ng nh?p l? do h?y.</div>";
            OpenCancelModalField.Value = "1";
                return;
            }

            if (db.CfReturnRequests.Any(r => r.OrderId == order.Id))
            {
                ActionMessageLiteral.Text = "<div class='text-muted'>Đơn hàng đã có yêu cầu đổi/trả hoặc hoàn tiền.</div>";
                return;
            }

            var selected = new Dictionary<int, int>();
            foreach (RepeaterItem item in ReturnItemsRepeater.Items)
            {
                var check = item.FindControl("ReturnItemCheckBox") as CheckBox;
                var qtyBox = item.FindControl("ReturnQtyInput") as TextBox;
                var idField = item.FindControl("ReturnItemIdField") as HiddenField;

                if (check == null || qtyBox == null || idField == null)
                {
                    continue;
                }

                if (!check.Checked)
                {
                    continue;
                }

                int orderItemId;
                int qty;
                if (!int.TryParse(idField.Value, out orderItemId) || !int.TryParse(qtyBox.Text, out qty))
                {
                    continue;
                }

                if (qty < 1)
                {
                    continue;
                }

                selected[orderItemId] = qty;
            }

            if (selected.Count == 0)
            {
                CancelReasonMessageLiteral.Text = "<div class='text-danger mb-2'>Vui l?ng nh?p l? do h?y.</div>";
            OpenCancelModalField.Value = "1";
                return;
            }

            var orderItems = db.CfOrderItems.Where(i => i.OrderId == order.Id).ToList();
            var orderItemLookup = orderItems.ToDictionary(i => i.Id, i => i);

            foreach (var pair in selected)
            {
                if (!orderItemLookup.ContainsKey(pair.Key))
                {
                    CancelReasonMessageLiteral.Text = "<div class='text-danger mb-2'>Vui l?ng nh?p l? do h?y.</div>";
            OpenCancelModalField.Value = "1";
                    return;
                }

                if (pair.Value > orderItemLookup[pair.Key].Quantity)
                {
                    CancelReasonMessageLiteral.Text = "<div class='text-danger mb-2'>Vui l?ng nh?p l? do h?y.</div>";
            OpenCancelModalField.Value = "1";
                    return;
                }
            }

            var productIds = orderItems.Select(i => i.ProductId).Distinct().ToList();
            var products = db.CfProducts.Where(p => productIds.Contains(p.Id)).ToList();
            var productLookup = products.ToDictionary(p => p.Id, p => p);

            var itemsByShop = orderItems
                .Where(i => selected.ContainsKey(i.Id))
                .GroupBy(i =>
                {
                    if (!productLookup.ContainsKey(i.ProductId))
                    {
                        return 0;
                    }

                    return productLookup[i.ProductId].ShopId.HasValue ? productLookup[i.ProductId].ShopId.Value : 0;
                })
                .ToList();

            foreach (var group in itemsByShop)
            {
                if (group.Key <= 0)
                {
                    continue;
                }

                var request = new CfReturnRequest
                {
                    OrderId = order.Id,
                    ShopId = group.Key,
                    RequestType = requestType,
                    Reason = reason,
                    Status = "NEW",
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = "customer",
                    SortOrder = 0
                };

                db.CfReturnRequests.Add(request);
                db.SaveChanges();

                foreach (var item in group)
                {
                    db.CfReturnItems.Add(new CfReturnItem
                    {
                        ReturnRequestId = request.Id,
                        OrderItemId = item.Id,
                        Quantity = selected.ContainsKey(item.Id) ? selected[item.Id] : item.Quantity,
                        Status = true,
                        CreatedAt = DateTime.UtcNow,
                        CreatedBy = "customer",
                        SortOrder = 0
                    });
                }

                db.SaveChanges();
            }

            RestockReturnItems(db, selected);

            db.CfOrderHistories.Add(new CfOrderHistory
            {
                OrderId = order.Id,
                Action = requestType == "REFUND" ? "Yêu cầu hoàn tiền" : "Yêu cầu đổi/trả",
                Note = reason,
                Status = true,
                CreatedAt = DateTime.UtcNow,
                CreatedBy = "customer",
                SortOrder = 0
            });

            db.SaveChanges();
        }

        BindOrder();
    }
}

