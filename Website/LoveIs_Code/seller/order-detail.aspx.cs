using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

public partial class SellerOrderDetail : System.Web.UI.Page
{
    private int _shopOrderId;
    private int? _orderId;
    private Dictionary<int, CfOrderStatus> _statusLookup = new Dictionary<int, CfOrderStatus>();
    private int _progressStep = 1;
    private string _progressStatusCode = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        _shopOrderId = ParseInt(Request.QueryString["id"]);
        if (_shopOrderId <= 0)
        {
            Response.Redirect("/seller/order-list.aspx");
            return;
        }
        BindDetail();
        }
    }

    private void BindDetail()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopOrder = db.CfShopOrders.FirstOrDefault(o => o.Id == _shopOrderId && o.Status);
            if (shopOrder == null)
            {
                Response.Redirect("/seller/order-list.aspx");
                return;
            }

            var shop = db.CfShops.FirstOrDefault(s => s.Id == shopOrder.ShopId && s.SellerId == sellerId.Value);
            if (shop == null)
            {
                Response.Redirect("/seller/order-list.aspx");
                return;
            }

            var order = db.CfOrders.FirstOrDefault(o => o.Id == shopOrder.OrderId && o.Status);
            if (order == null)
            {
                Response.Redirect("/seller/order-list.aspx");
                return;
            }

            _orderId = order.Id;
            ShopOrderIdField.Value = shopOrder.Id.ToString(CultureInfo.InvariantCulture);

            var statusRows = db.CfOrderStatuses
                .Where(s => s.Status)
                .ToList();
            _statusLookup = statusRows.ToDictionary(s => s.Id, s => s);

            var statusName = order.OrderStatusId.HasValue && _statusLookup.ContainsKey(order.OrderStatusId.Value)
                ? _statusLookup[order.OrderStatusId.Value].Name
                : (string.IsNullOrWhiteSpace(order.OrderStatus) ? "-" : order.OrderStatus);
            _progressStatusCode = ResolveStatusCode(order.OrderStatusId, order.OrderStatus, shopOrder.OrderStatus);
            _progressStep = ResolveProgressStep(_progressStatusCode);
            ApplyProgressStepStyles();

            OrderCodeLiteral.Text = HttpUtility.HtmlEncode(order.OrderCode ?? "-");
            StatusLabelLiteral.Text = HttpUtility.HtmlEncode(statusName);
            StatusClassField.Value = GetStatusClass(order.OrderStatusId, order.OrderStatus);
            OrderCreatedLiteral.Text = order.CreatedAt.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);

            CustomerNameLiteral.Text = HttpUtility.HtmlEncode(order.CustomerName ?? "-");
            CustomerPhoneLiteral.Text = HttpUtility.HtmlEncode(order.Phone ?? "-");
            ShippingAddressLiteral.Text = HttpUtility.HtmlEncode(BuildAddress(order));
            OrderNoteLiteral.Text = HttpUtility.HtmlEncode(order.Note ?? "-");

            ShippingMethodLiteral.Text = HttpUtility.HtmlEncode(shopOrder.ShippingMethod ?? order.ShippingMethod ?? "-");
            ShippingCodeLiteral.Text = HttpUtility.HtmlEncode(ResolveShippingCode(db, shopOrder.ShippingMethod ?? order.ShippingMethod));
            ShippingFeeLiteral.Text = FormatCurrency(shopOrder.ShippingFee);
            PaymentStatusLiteral.Text = HttpUtility.HtmlEncode(order.PaymentStatus ?? "-");

            if (order.InvoiceRequired)
            {
                InvoicePanel.Visible = true;
                InvoiceNoneLiteral.Text = string.Empty;
                InvoiceCompanyLiteral.Text = HttpUtility.HtmlEncode(order.InvoiceCompanyName ?? "-");
                InvoiceTaxLiteral.Text = HttpUtility.HtmlEncode(order.InvoiceTaxCode ?? "-");
                InvoiceEmailLiteral.Text = HttpUtility.HtmlEncode(order.InvoiceEmail ?? "-");
                InvoiceAddressLiteral.Text = HttpUtility.HtmlEncode(order.InvoiceAddress ?? "-");
            }
            else
            {
                InvoicePanel.Visible = false;
                InvoiceNoneLiteral.Text = "<div>Chưa có yêu cầu hóa đơn</div>";
            }

            var shopProductIds = db.CfProducts
                .Where(p => p.ShopId.HasValue && p.ShopId.Value == shop.Id)
                .Select(p => p.Id)
                .ToList();

            var orderItems = db.CfOrderItems
                .Where(i => i.OrderId == order.Id && shopProductIds.Contains(i.ProductId))
                .ToList();

            var images = db.CfProductImages
                .Where(i => i.Status && shopProductIds.Contains(i.ProductId))
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .ToList()
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.First().ImageUrl);

            var itemModels = orderItems.Select(i => new
            {
                ProductName = i.ProductName,
                VariantLabel = string.IsNullOrWhiteSpace(i.VariantName) ? "-" : i.VariantName,
                Quantity = i.Quantity,
                ImageUrl = images.ContainsKey(i.ProductId) ? images[i.ProductId] : "/images/fav.png",
                LineTotalLabel = FormatCurrency(i.LineTotal > 0 ? i.LineTotal : ((i.SalePrice.HasValue && i.SalePrice.Value > 0 ? i.SalePrice.Value : i.Price) * i.Quantity))
            }).ToList();

            OrderItemRepeater.DataSource = itemModels;
            OrderItemRepeater.DataBind();

            var subtotal = orderItems.Sum(i => i.LineTotal > 0 ? i.LineTotal : ((i.SalePrice.HasValue && i.SalePrice.Value > 0 ? i.SalePrice.Value : i.Price) * i.Quantity));
            SubtotalLiteral.Text = FormatCurrency(subtotal);
            ShopShippingFeeLiteral.Text = FormatCurrency(shopOrder.ShippingFee);
            TotalLiteral.Text = FormatCurrency(subtotal + shopOrder.ShippingFee);

            var histories = db.CfOrderHistories
                .Where(h => h.OrderId == order.Id && h.Status)
                .OrderByDescending(h => h.CreatedAt)
                .ToList()
                .Select(h => new
                {
                    Note = string.IsNullOrWhiteSpace(h.Note) ? "-" : h.Note,
                    CreatedAt = h.CreatedAt,
                    CreatedBy = string.IsNullOrWhiteSpace(h.CreatedBy) ? "-" : h.CreatedBy
                })
                .ToList();
            OrderHistoryRepeater.DataSource = histories;
            OrderHistoryRepeater.DataBind();
        }
    }


    private static string ResolveShippingCode(BeautyStoryContext db, string shippingName)
    {
        if (string.IsNullOrWhiteSpace(shippingName))
        {
            return "-";
        }
        var method = db.CfShippingMethods.FirstOrDefault(s => s.Status && s.Name == shippingName);
        return method != null && !string.IsNullOrWhiteSpace(method.Code) ? method.Code : "-";
    }

    private static string BuildAddress(CfOrder order)
    {
        if (order == null)
        {
            return "-";
        }

        var parts = new List<string>();
        if (!string.IsNullOrWhiteSpace(order.AddressLine))
        {
            parts.Add(order.AddressLine);
        }
        if (!string.IsNullOrWhiteSpace(order.WardName))
        {
            parts.Add(order.WardName);
        }
        if (!string.IsNullOrWhiteSpace(order.ProvinceName))
        {
            parts.Add(order.ProvinceName);
        }
        return parts.Count > 0 ? string.Join(", ", parts) : "-";
    }

    private string GetStatusClass(int? statusId, string statusCode)
    {
        string code = statusCode ?? string.Empty;
        if (statusId.HasValue && _statusLookup.ContainsKey(statusId.Value))
        {
            code = _statusLookup[statusId.Value].Code ?? code;
        }

        var upper = code.ToUpperInvariant();
        if (upper == "CANCELLED")
        {
            return "status-returns";
        }
        if (upper == "COMPLETED" || upper == "DELIVERED")
        {
            return "status-completed";
        }
        if (upper == "SHIPPING" || upper == "DELIVERING")
        {
            return "status-shipping";
        }
        if (upper == "CONFIRMED" || upper == "READY_TO_SHIP" || upper == "PACKING" || upper == "SHIPPED")
        {
            return "status-ready";
        }
        return "status-pending";
    }

    protected string GetProgressClass(int step)
    {
        if (_progressStep <= 0)
        {
            return string.Empty;
        }
        if (step < _progressStep)
        {
            return "completed";
        }
        if (step == _progressStep)
        {
            return "active";
        }
        return string.Empty;
    }

    protected void UpdateStatusButton_Command(object sender, CommandEventArgs e)
    {
        var statusCode = e != null ? (e.CommandArgument ?? string.Empty).ToString() : string.Empty;
        if (string.IsNullOrWhiteSpace(statusCode))
        {
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        _shopOrderId = ParseInt(Request.QueryString["id"]);
        if (_shopOrderId <= 0)
        {
            Response.Redirect("/seller/order-list.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopOrder = db.CfShopOrders.FirstOrDefault(o => o.Id == _shopOrderId && o.Status);
            if (shopOrder == null)
            {
                Response.Redirect("/seller/order-list.aspx");
                return;
            }

            var shop = db.CfShops.FirstOrDefault(s => s.Id == shopOrder.ShopId && s.SellerId == sellerId.Value);
            if (shop == null)
            {
                Response.Redirect("/seller/order-list.aspx");
                return;
            }

            var order = db.CfOrders.FirstOrDefault(o => o.Id == shopOrder.OrderId && o.Status);
            if (order == null)
            {
                Response.Redirect("/seller/order-list.aspx");
                return;
            }

            var allowedCodes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "NEW",
                "CONFIRMED",
                "PACKING",
                "READY_TO_SHIP",
                "SHIPPED",
                "DELIVERING",
                "DELIVERED",
                "COMPLETED"
            };
            if (!allowedCodes.Contains(statusCode))
            {
                return;
            }

            var statusRow = db.CfOrderStatuses.FirstOrDefault(s => s.Status && s.Code == statusCode);
            if (statusRow == null)
            {
                return;
            }

            order.OrderStatusId = statusRow.Id;
            order.OrderStatus = statusRow.Name;
            shopOrder.OrderStatus = statusRow.Name;

            db.SaveChanges();
        }

        BindDetail();
    }

    private void ApplyProgressStepStyles()
    {
        SetStepClass(StepNewButton, 1);
        SetStepClass(StepConfirmedButton, 2);
        SetStepClass(StepPackingButton, 3);
        SetStepClass(StepReadyButton, 4);
        SetStepClass(StepShippedButton, 5);
        SetStepClass(StepDeliveringButton, 6);
        SetStepClass(StepDeliveredButton, 7);
        SetStepClass(StepCompletedButton, 8);
    }

    private void SetStepClass(LinkButton button, int step)
    {
        if (button == null)
        {
            return;
        }
        var className = "order-progress-step";
        if (step <= _progressStep)
        {
            className += " completed";
        }
        else if (step == _progressStep + 1)
        {
            className += " active";
        }
        button.CssClass = className;
    }

    private int ResolveProgressStep(string statusCode)
    {
        var code = (statusCode ?? string.Empty).ToUpperInvariant();
        if (code == "NEW")
        {
            return 1;
        }
        if (code == "CONFIRMED")
        {
            return 2;
        }
        if (code == "PACKING")
        {
            return 3;
        }
        if (code == "READY_TO_SHIP")
        {
            return 4;
        }
        if (code == "SHIPPED")
        {
            return 5;
        }
        if (code == "DELIVERING")
        {
            return 6;
        }
        if (code == "DELIVERED")
        {
            return 7;
        }
        if (code == "COMPLETED")
        {
            return 8;
        }
        if (code == "CANCELLED")
        {
            return 1;
        }
        return 1;
    }

    private string ResolveStatusCode(int? statusId, string statusCode, string fallbackCode)
    {
        if (statusId.HasValue && _statusLookup.ContainsKey(statusId.Value))
        {
            return _statusLookup[statusId.Value].Code ?? string.Empty;
        }

        if (!string.IsNullOrWhiteSpace(statusCode))
        {
            return statusCode;
        }

        return fallbackCode ?? string.Empty;
    }

    private static string FormatCurrency(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private static int ParseInt(string raw)
    {
        int value;
        return int.TryParse(raw, out value) ? value : 0;
    }
}
