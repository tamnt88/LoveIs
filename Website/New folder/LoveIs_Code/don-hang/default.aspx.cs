using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public partial class OrderDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentEncoding = Encoding.UTF8;
        Response.Charset = "utf-8";

        if (!IsPostBack)
        {
            LoadOrder();
        }
    }

    private void LoadOrder()
    {
        var code = Request.QueryString["code"];
        if (string.IsNullOrWhiteSpace(code))
        {
            ShowNotFound();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.OrderCode == code);
            if (order == null)
            {
                ShowNotFound();
                return;
            }

            var items = db.CfOrderItems.Where(i => i.OrderId == order.Id).ToList();
            var productIds = items.Select(i => i.ProductId).Distinct().ToList();

            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .OrderByDescending(i => i.IsPrimary)
                .ToList();

            var imageLookup = images
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.First().ImageUrl);

            var productSlugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var viewItems = items.Select(i => new OrderItemView
            {
                ProductName = i.ProductName,
                VariantName = i.VariantName,
                Quantity = i.Quantity,
                ImageUrl = imageLookup.ContainsKey(i.ProductId) ? imageLookup[i.ProductId] : "/images/fav.png",
                ProductUrl = productSlugs.ContainsKey(i.ProductId) ? "/san-pham/" + productSlugs[i.ProductId] : "/san-pham/san-pham-" + i.ProductId,
                UnitPrice = FormatMoney(i.SalePrice.HasValue && i.SalePrice.Value > 0 ? i.SalePrice.Value : i.Price),
                LineTotal = FormatMoney(i.LineTotal)
            }).ToList();

            OrderCodeLiteral.Text = order.OrderCode;
            OrderDateLiteral.Text = order.CreatedAt.ToString("dd/MM/yyyy HH:mm");
            CustomerNameLiteral.Text = order.CustomerName;
            PhoneLiteral.Text = order.Phone;
            AddressLiteral.Text = BuildAddress(order);
            NoteLiteral.Text = SafeValue(order.Note);
            ShippingMethodLiteral.Text = SafeValue(order.ShippingMethod);
            ShippingEtaLiteral.Text = SafeValue(order.ShippingEta);
            PaymentMethodLiteral.Text = SafeValue(order.PaymentMethod);

            InvoicePanel.Visible = order.InvoiceRequired;
            InvoiceCompanyLiteral.Text = SafeValue(order.InvoiceCompanyName);
            InvoiceTaxLiteral.Text = SafeValue(order.InvoiceTaxCode);
            InvoiceEmailLiteral.Text = SafeValue(order.InvoiceEmail);
            InvoiceAddressLiteral.Text = SafeValue(order.InvoiceAddress);

            SubtotalLiteral.Text = FormatMoney(order.Subtotal);
            ShippingFeeLiteral.Text = FormatMoney(order.ShippingFee);
            DiscountLiteral.Text = order.Discount > 0 ? "-" + FormatMoney(order.Discount) : FormatMoney(0);
            TotalLiteral.Text = FormatMoney(order.Total);
            OrderStatusLiteral.Text = SafeValue(order.OrderStatus);

            OrderItemsRepeater.DataSource = viewItems;
            OrderItemsRepeater.DataBind();

            ApplyStatusSteps(order.OrderStatus);
            OrderPanel.Visible = true;
        }
    }

    private void ShowNotFound()
    {
        OrderPanel.Visible = false;
        NotFoundPanel.Visible = true;
    }

    private static string BuildAddress(CfOrder order)
    {
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
        return string.Join(", ", parts);
    }

    private void ApplyStatusSteps(string status)
    {
        var normalized = (status ?? string.Empty).Trim().ToLowerInvariant();
        var step = 1;
        if (normalized.Contains("confirm") || normalized.Contains("xác") || normalized.Contains("xac"))
        {
            step = 2;
        }
        else if (normalized.Contains("ship") || normalized.Contains("deliver") || normalized.Contains("giao"))
        {
            step = 3;
        }
        else if (normalized.Contains("complete") || normalized.Contains("done") || normalized.Contains("hoàn") || normalized.Contains("hoan"))
        {
            step = 4;
        }

        SetStepClass(StepPlaced, 1, step);
        SetStepClass(StepConfirmed, 2, step);
        SetStepClass(StepShipping, 3, step);
        SetStepClass(StepDone, 4, step);
    }

    private static void SetStepClass(System.Web.UI.HtmlControls.HtmlGenericControl stepControl, int index, int current)
    {
        if (stepControl == null)
        {
            return;
        }

        stepControl.Attributes["class"] = "order-step";
        if (index < current)
        {
            stepControl.Attributes["class"] += " done";
            return;
        }

        if (index == current)
        {
            stepControl.Attributes["class"] += " current";
        }
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private static string SafeValue(string value)
    {
        return string.IsNullOrWhiteSpace(value) ? "-" : value;
    }

    private sealed class OrderItemView
    {
        public string ProductName { get; set; }
        public string VariantName { get; set; }
        public int Quantity { get; set; }
        public string ImageUrl { get; set; }
        public string ProductUrl { get; set; }
        public string UnitPrice { get; set; }
        public string LineTotal { get; set; }
    }
}
