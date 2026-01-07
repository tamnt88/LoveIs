using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Text;
using System.Web.Configuration;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data.Entity;

public partial class CheckoutDefault : System.Web.UI.Page
{
    public class WardOption
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public class ShippingSummary
    {
        public string ShippingFeeText { get; set; }
        public string TotalText { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentEncoding = Encoding.UTF8;
        Response.Charset = "utf-8";

        if (!EnsureCustomerSignedIn())
        {
            return;
        }

        if (!IsPostBack)
        {
            ApplySeo();
            BindProvinces();
            BindWards(null);
            BindShippingMethods();
            BindPaymentMethods();
            BindSummary();
            BindCustomerProfile();
            BindCustomerAddresses();
        }
    }

    private void ApplySeo()
    {
        string canonical = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Path) : string.Empty;
        SystemPageSeoApplier.Apply("checkout", SeoTitleLiteral, SeoMetaLiteral, "Thanh toán | LoveIs Store", canonical);
    }

    private void BindProvinces()
    {
        using (var db = new BeautyStoryContext())
        {
            var provinces = db.CfProvinces.AsNoTracking()
                .OrderBy(p => p.SortOrder)
                .Select(p => new { p.Id, p.ProvinceName })
                .ToList();

            ProvinceDropDown.Items.Clear();
            ProvinceDropDown.Items.Add(new ListItem("-- Chọn tỉnh/thành phố --", ""));
            foreach (var item in provinces)
            {
                ProvinceDropDown.Items.Add(new ListItem(item.ProvinceName, item.Id.ToString()));
            }
        }
    }

    private void BindWards(int? provinceId)
    {
        WardDropDown.Items.Clear();
        WardDropDown.Items.Add(new ListItem("-- Chọn phường/xã --", ""));
        if (!provinceId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var wards = db.CfWards.AsNoTracking()
                .Where(w => w.ProvinceId == provinceId.Value)
                .OrderBy(w => w.WardName)
                .Select(w => new { w.Id, w.WardName })
                .ToList();

            foreach (var ward in wards)
            {
                WardDropDown.Items.Add(new ListItem(ward.WardName, ward.Id.ToString()));
            }
        }
    }

    private void BindShippingMethods()
    {
        using (var db = new BeautyStoryContext())
        {
            var methods = db.CfShippingMethods.AsNoTracking()
                .Where(m => m.Status)
                .OrderBy(m => m.SortOrder)
                .ToList();

            ShippingMethodList.Items.Clear();
            foreach (var method in methods)
            {
                var label = string.IsNullOrWhiteSpace(method.EtaText)
                    ? method.Name
                    : string.Format("{0} ({1})", method.Name, method.EtaText);
                ShippingMethodList.Items.Add(new ListItem(label, method.Id.ToString()));
            }

            var selected = methods.FirstOrDefault(m => m.IsDefault) ?? methods.FirstOrDefault();
            if (selected != null)
            {
                ShippingMethodList.SelectedValue = selected.Id.ToString();
            }
        }
    }

    private void BindPaymentMethods()
    {
        using (var db = new BeautyStoryContext())
        {
            var methods = db.CfPaymentMethods.AsNoTracking()
                .Where(m => m.Status)
                .OrderBy(m => m.SortOrder)
                .ToList();

            PaymentMethodList.Items.Clear();
            foreach (var method in methods)
            {
                PaymentMethodList.Items.Add(new ListItem(method.Name, method.Id.ToString()));
            }

            var selected = methods.FirstOrDefault(m => m.IsDefault) ?? methods.FirstOrDefault();
            if (selected != null)
            {
                PaymentMethodList.SelectedValue = selected.Id.ToString();
            }
        }
    }

    private void BindSummary()
    {
        var cart = CartService.GetCart();
        if (cart.Count == 0)
        {
            CheckoutEmptyPanel.Visible = true;
            CheckoutPanel.Visible = false;
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var variantIds = cart.Select(c => c.VariantId).ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => variantIds.Contains(v.Id))
                .ToList();
            var productIds = variants.Select(v => v.ProductId).Distinct().ToList();
            var products = db.CfProducts.AsNoTracking()
                .Where(p => productIds.Contains(p.Id))
                .ToList();
            var attributes = db.CfProductVariantAttributes.AsNoTracking()
                .Where(pva => variantIds.Contains(pva.VariantId))
                .ToList();
            var attributeIds = attributes.Select(a => a.AttributeId).Distinct().ToList();
            var valueIds = attributes.Select(a => a.AttributeValueId).Distinct().ToList();
            var attributeLookup = db.CfVariantAttributes.AsNoTracking()
                .Where(a => attributeIds.Contains(a.Id))
                .ToDictionary(a => a.Id, a => a.AttributeName);
            var valueLookup = db.CfVariantAttributeValues.AsNoTracking()
                .Where(v => valueIds.Contains(v.Id))
                .ToDictionary(v => v.Id, v => v.ValueName);

            var variantLookup = variants.ToDictionary(v => v.Id, v => v);
            var productLookup = products.ToDictionary(p => p.Id, p => p);
            var attributesByVariant = attributes
                .GroupBy(a => a.VariantId)
                .ToDictionary(g => g.Key, g => g.ToList());

            var lines = cart.Select(item =>
            {
                var variant = variantLookup.ContainsKey(item.VariantId) ? variantLookup[item.VariantId] : null;
                var product = variant != null && productLookup.ContainsKey(variant.ProductId) ? productLookup[variant.ProductId] : null;
                var price = GetEffectivePrice(variant);
                var lineTotal = price * item.Quantity;

                var attrs = new List<string>();
                if (attributesByVariant.ContainsKey(item.VariantId))
                {
                    foreach (var attr in attributesByVariant[item.VariantId])
                    {
                        var attrName = attributeLookup.ContainsKey(attr.AttributeId) ? attributeLookup[attr.AttributeId] : "";
                        var valueName = valueLookup.ContainsKey(attr.AttributeValueId) ? valueLookup[attr.AttributeValueId] : "";
                        attrs.Add(string.Format("{0}: {1}", attrName, valueName));
                    }
                }

                return new
                {
                    VariantId = item.VariantId,
                    ProductId = product != null ? product.Id : 0,
                    ProductName = product != null ? product.ProductName : "-",
                    VariantText = attrs.Count > 0 ? string.Join(", ", attrs) : "Mặc định",
                    Quantity = item.Quantity,
                    PriceValue = price,
                    LineTotalValue = lineTotal,
                    LineTotal = price > 0 ? string.Format("{0:N0} đ", lineTotal) : "Liên hệ"
                };
            }).ToList();

            SummaryRepeater.DataSource = lines;
            SummaryRepeater.DataBind();

            var subtotal = lines.Sum(x => x.LineTotalValue);
            var shippingFee = CalculateShippingFee();
            var total = subtotal + shippingFee;

            SubtotalLiteral.Text = subtotal > 0 ? string.Format("{0:N0} đ", subtotal) : "Liên hệ";
            ShippingFeeLiteral.Text = shippingFee > 0 ? string.Format("{0:N0} đ", shippingFee) : "Miễn phí";
            TotalLiteral.Text = total > 0 ? string.Format("{0:N0} đ", total) : "Liên hệ";
        }
    }

    private decimal CalculateShippingFee()
    {
        int methodId;
        if (!int.TryParse(ShippingMethodList.SelectedValue, out methodId))
        {
            return 0;
        }

        using (var db = new BeautyStoryContext())
        {
            var method = db.CfShippingMethods.FirstOrDefault(m => m.Id == methodId);
            if (method == null)
            {
                return 0;
            }

            var baseFee = method.BaseFee;
            var innerCityFee = method.InnerCityFee > 0 ? method.InnerCityFee : method.BaseFee;

            int provinceId;
            if (!int.TryParse(ProvinceDropDown.SelectedValue, out provinceId))
            {
                return baseFee;
            }

            var province = db.CfProvinces.FirstOrDefault(p => p.Id == provinceId);
            if (province != null)
            {
                var name = province.ProvinceName ?? string.Empty;
                if (name.Contains("Hồ Chí Minh") || name.Contains("Hà Nội"))
                {
                    return innerCityFee;
                }
            }

            return baseFee;
        }
    }

    private bool EnsureCustomerSignedIn()
    {
        if (CustomerAuth.IsSignedIn())
        {
            return true;
        }

        var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/thanh-toan";
        Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
        return false;
    }

    private void BindCustomerProfile()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId.Value);
            if (customer == null)
            {
                return;
            }

            if (string.IsNullOrWhiteSpace(CustomerNameInput.Text))
            {
                CustomerNameInput.Text = customer.DisplayName ?? customer.Username ?? string.Empty;
            }

            if (string.IsNullOrWhiteSpace(PhoneInput.Text))
            {
                PhoneInput.Text = customer.Phone ?? string.Empty;
            }

            if (string.IsNullOrWhiteSpace(InvoiceEmailInput.Text))
            {
                InvoiceEmailInput.Text = customer.Email ?? string.Empty;
            }
        }
    }

    private void BindCustomerAddresses()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var addresses = db.CfCustomerAddresses
                .Where(a => a.CustomerId == customerId.Value)
                .OrderByDescending(a => a.IsDefault)
                .ThenByDescending(a => a.Id)
                .ToList();

            if (addresses.Count == 0)
            {
                AddressBookPanel.Visible = false;
                return;
            }

            AddressBookPanel.Visible = true;
            AddressSelect.Items.Clear();
            AddressSelect.Items.Add(new ListItem("-- Chọn sổ địa chỉ --", ""));
            foreach (var item in addresses)
            {
                var label = string.Format("{0} | {1} | {2}", item.FullName, item.Phone, item.AddressLine);
                AddressSelect.Items.Add(new ListItem(label, item.Id.ToString()));
            }

            var selected = addresses.FirstOrDefault(a => a.IsDefault) ?? addresses.First();
            if (selected != null)
            {
                AddressSelect.SelectedValue = selected.Id.ToString();
                ApplyAddressToForm(selected);
            }
        }
    }

    protected void AddressSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        int addressId;
        if (!int.TryParse(AddressSelect.SelectedValue, out addressId))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var address = db.CfCustomerAddresses.FirstOrDefault(a => a.Id == addressId);
            if (address == null)
            {
                return;
            }

            ApplyAddressToForm(address);
        }
    }

    private void ApplyAddressToForm(CfCustomerAddress address)
    {
        if (address == null)
        {
            return;
        }

        CustomerNameInput.Text = address.FullName ?? string.Empty;
        PhoneInput.Text = address.Phone ?? string.Empty;
        AddressInput.Text = address.AddressLine ?? string.Empty;

        if (address.ProvinceId.HasValue)
        {
            ProvinceDropDown.SelectedValue = address.ProvinceId.Value.ToString();
            BindWards(address.ProvinceId);
        }
        if (address.WardId.HasValue)
        {
            WardDropDown.SelectedValue = address.WardId.Value.ToString();
        }
    }

    protected void PlaceOrderButton_Click(object sender, EventArgs e)
    {
        CheckoutMessage.Text = string.Empty;
        if (!EnsureCustomerSignedIn())
        {
            return;
        }
        var cart = CartService.GetCart();
        if (cart.Count == 0)
        {
            CheckoutMessage.Text = "Giỏ hàng đang trống.";
            return;
        }

        var customerName = (CustomerNameInput.Text ?? string.Empty).Trim();
        var phone = (PhoneInput.Text ?? string.Empty).Trim();
        var addressLine = (AddressInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(customerName) || string.IsNullOrWhiteSpace(phone) || string.IsNullOrWhiteSpace(addressLine))
        {
            CheckoutMessage.Text = "Vui lòng nhập họ và tên, điện thoại, địa chỉ.";
            return;
        }

        int provinceId;
        int wardId;
        int? provinceValue = int.TryParse(ProvinceDropDown.SelectedValue, out provinceId) ? (int?)provinceId : null;
        if (provinceValue.HasValue)
        {
            BindWards(provinceValue);
        }

        var wardSelected = WardDropDown.SelectedValue;
        if (string.IsNullOrWhiteSpace(wardSelected))
        {
            wardSelected = Request.Form[WardDropDown.UniqueID];
        }

        int? wardValue = int.TryParse(wardSelected, out wardId) ? (int?)wardId : null;

        var orderCode = GenerateOrderCode();
        var customerId = CustomerAuth.GetCustomerId();

        using (var db = new BeautyStoryContext())
        {
            var customerIdValue = customerId.HasValue ? customerId.Value : 0;
            if (customerIdValue > 0)
            {
                var hasAddress = db.CfCustomerAddresses.Any(a => a.CustomerId == customerIdValue);
                if (!hasAddress)
                {
                    var shipProvinceName = provinceValue.HasValue
                        ? db.CfProvinces.Where(p => p.Id == provinceValue.Value).Select(p => p.ProvinceName).FirstOrDefault()
                        : null;
                    var shipWardName = wardValue.HasValue
                        ? db.CfWards.Where(w => w.Id == wardValue.Value).Select(w => w.WardName).FirstOrDefault()
                        : null;

                    db.CfCustomerAddresses.Add(new CfCustomerAddress
                    {
                        CustomerId = customerIdValue,
                        FullName = customerName,
                        Phone = phone,
                        AddressLine = addressLine,
                        ProvinceId = provinceValue,
                        WardId = wardValue,
                        ProvinceName = shipProvinceName,
                        WardName = shipWardName,
                        IsDefault = true,
                        Status = true,
                        CreatedAt = DateTime.UtcNow
                    });
                    db.SaveChanges();
                }
            }

            var variantIds = cart.Select(c => c.VariantId).ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => variantIds.Contains(v.Id))
                .ToList();
            var productIds = variants.Select(v => v.ProductId).Distinct().ToList();
            var products = db.CfProducts.AsNoTracking()
                .Where(p => productIds.Contains(p.Id))
                .ToList();
            var attributes = db.CfProductVariantAttributes.AsNoTracking()
                .Where(pva => variantIds.Contains(pva.VariantId))
                .ToList();
            var attributeIds = attributes.Select(a => a.AttributeId).Distinct().ToList();
            var valueIds = attributes.Select(a => a.AttributeValueId).Distinct().ToList();
            var attributeLookup = db.CfVariantAttributes.AsNoTracking()
                .Where(a => attributeIds.Contains(a.Id))
                .ToDictionary(a => a.Id, a => a.AttributeName);
            var valueLookup = db.CfVariantAttributeValues.AsNoTracking()
                .Where(v => valueIds.Contains(v.Id))
                .ToDictionary(v => v.Id, v => v.ValueName);

            var variantLookup = variants.ToDictionary(v => v.Id, v => v);
            var productLookup = products.ToDictionary(p => p.Id, p => p);
            var attributesByVariant = attributes
                .GroupBy(a => a.VariantId)
                .ToDictionary(g => g.Key, g => g.ToList());

            var provinceName = provinceValue.HasValue
                ? db.CfProvinces.Where(p => p.Id == provinceValue.Value).Select(p => p.ProvinceName).FirstOrDefault()
                : null;
            var wardName = wardValue.HasValue
                ? db.CfWards.Where(w => w.Id == wardValue.Value).Select(w => w.WardName).FirstOrDefault()
                : null;

            var orderItems = new List<CfOrderItem>();
            decimal subtotal = 0;

            foreach (var item in cart)
            {
                var variant = variantLookup.ContainsKey(item.VariantId) ? variantLookup[item.VariantId] : null;
                var product = variant != null && productLookup.ContainsKey(variant.ProductId) ? productLookup[variant.ProductId] : null;
                if (variant == null || product == null)
                {
                    continue;
                }

                var price = GetEffectivePrice(variant);
                var lineTotal = price * item.Quantity;
                subtotal += lineTotal;

                var attrs = new List<string>();
                if (attributesByVariant.ContainsKey(item.VariantId))
                {
                    foreach (var attr in attributesByVariant[item.VariantId])
                    {
                        var attrName = attributeLookup.ContainsKey(attr.AttributeId) ? attributeLookup[attr.AttributeId] : "";
                        var valueName = valueLookup.ContainsKey(attr.AttributeValueId) ? valueLookup[attr.AttributeValueId] : "";
                        attrs.Add(string.Format("{0}: {1}", attrName, valueName));
                    }
                }

                orderItems.Add(new CfOrderItem
                {
                    ProductId = product.Id,
                    VariantId = variant.Id,
                    ProductName = product.ProductName,
                    VariantName = attrs.Count > 0 ? string.Join(", ", attrs) : "Mặc định",
                    Quantity = item.Quantity,
                    Price = variant.Price,
                    SalePrice = variant.SalePrice,
                    LineTotal = lineTotal,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    SortOrder = 0
                });
            }

            var shippingFee = CalculateShippingFee();
            var total = subtotal + shippingFee;

            int shippingMethodId;
            int? shippingMethodValue = int.TryParse(ShippingMethodList.SelectedValue, out shippingMethodId) ? (int?)shippingMethodId : null;
            int paymentMethodId;
            int? paymentMethodValue = int.TryParse(PaymentMethodList.SelectedValue, out paymentMethodId) ? (int?)paymentMethodId : null;

            var shippingMethod = shippingMethodValue.HasValue
                ? db.CfShippingMethods.FirstOrDefault(m => m.Id == shippingMethodValue.Value)
                : null;
            var paymentMethod = paymentMethodValue.HasValue
                ? db.CfPaymentMethods.FirstOrDefault(m => m.Id == paymentMethodValue.Value)
                : null;

            var orderStatus = db.CfOrderStatuses.FirstOrDefault(s => s.IsDefault) ?? db.CfOrderStatuses.FirstOrDefault();
            var paymentStatus = db.CfPaymentStatuses.FirstOrDefault(s => s.IsDefault) ?? db.CfPaymentStatuses.FirstOrDefault();

            var order = new CfOrder
            {
                OrderCode = orderCode,
                CustomerId = customerId,
                CustomerName = customerName,
                Phone = phone,
                AddressLine = addressLine,
                WardId = wardValue,
                ProvinceId = provinceValue,
                WardName = wardName,
                ProvinceName = provinceName,
                Note = NoteInput.Text,
                InvoiceRequired = InvoiceCheckBox.Checked,
                InvoiceCompanyName = InvoiceCompanyInput.Text,
                InvoiceTaxCode = InvoiceTaxInput.Text,
                InvoiceEmail = InvoiceEmailInput.Text,
                InvoiceAddress = InvoiceAddressInput.Text,
                ShippingMethodId = shippingMethod != null ? (int?)shippingMethod.Id : null,
                ShippingMethod = shippingMethod != null ? shippingMethod.Name : string.Empty,
                ShippingFee = shippingFee,
                ShippingEta = shippingMethod != null ? shippingMethod.EtaText : string.Empty,
                PaymentMethodId = paymentMethod != null ? (int?)paymentMethod.Id : null,
                PaymentMethod = paymentMethod != null ? paymentMethod.Name : string.Empty,
                PaymentStatusId = paymentStatus != null ? (int?)paymentStatus.Id : null,
                PaymentStatus = paymentStatus != null ? paymentStatus.Name : string.Empty,
                OrderStatusId = orderStatus != null ? (int?)orderStatus.Id : null,
                OrderStatus = orderStatus != null ? orderStatus.Name : string.Empty,
                Subtotal = subtotal,
                Discount = 0,
                Total = total,
                Status = true,
                CreatedAt = DateTime.Now,
                SortOrder = 0,
                Items = new List<CfOrderItem>()
            };

            db.CfOrders.Add(order);
            db.SaveChanges();

            foreach (var item in orderItems)
            {
                item.OrderId = order.Id;
                db.CfOrderItems.Add(item);
            }

            db.SaveChanges();

            CreateShopOrders(db, order, orderItems);

            db.CfOrderHistories.Add(new CfOrderHistory
            {
                OrderId = order.Id,
                Action = "Create",
                Note = "Khởi tạo đơn hàng",
                Status = true,
                CreatedAt = DateTime.Now,
                SortOrder = 0
            });

            db.SaveChanges();

            SendOrderNotification(order, orderItems);
        }

        CartService.ClearCart();
        Response.Redirect("/thanh-toan/hoan-tat.aspx?code=" + Server.UrlEncode(orderCode));
    }

        private static bool IsValidPhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone))
        {
            return false;
        }

        return Regex.IsMatch(phone, @"^(0|\+84)(\d{9,10})$");
    }
private static string GenerateOrderCode()
    {
        var random = new Random();
        return "LI" + DateTime.Now.ToString("yyyyMMddHHmmss") + random.Next(100, 999).ToString();
    }

    private static decimal GetEffectivePrice(CfProductVariant variant)
    {
        if (variant == null)
        {
            return 0;
        }

        return GetEffectivePrice(variant.Price, variant.SalePrice);
    }

    private static void CreateShopOrders(BeautyStoryContext db, CfOrder order, List<CfOrderItem> orderItems)
    {
        if (db == null || order == null || orderItems == null || orderItems.Count == 0)
        {
            return;
        }

        var productIds = orderItems.Select(i => i.ProductId).Distinct().ToList();
        var productShopMap = db.CfProducts
            .Where(p => productIds.Contains(p.Id))
            .Select(p => new { p.Id, p.ShopId })
            .ToList()
            .ToDictionary(p => p.Id, p => p.ShopId ?? 0);

        var grouped = orderItems
            .GroupBy(i => productShopMap.ContainsKey(i.ProductId) ? productShopMap[i.ProductId] : 0)
            .Where(g => g.Key > 0)
            .ToList();

        if (grouped.Count == 0)
        {
            return;
        }

        foreach (var group in grouped)
        {
            var subtotal = group.Sum(i => i.LineTotal);
            var shopOrder = new CfShopOrder
            {
                OrderId = order.Id,
                ShopId = group.Key,
                ShippingMethod = order.ShippingMethod,
                ShippingFee = order.ShippingFee,
                ShippingEta = order.ShippingEta,
                PaymentStatus = order.PaymentStatus,
                OrderStatus = order.OrderStatus,
                Subtotal = subtotal,
                Discount = 0,
                Total = subtotal + order.ShippingFee,
                Status = true,
                CreatedAt = DateTime.Now,
                SortOrder = 0
            };

            db.CfShopOrders.Add(shopOrder);
            db.SaveChanges();

            db.CfShopOrderHistories.Add(new CfShopOrderHistory
            {
                ShopOrderId = shopOrder.Id,
                Action = "Create",
                Note = "Khởi tạo đơn hàng shop",
                Status = true,
                CreatedAt = DateTime.Now,
                SortOrder = 0
            });
        }

        db.SaveChanges();
    }

    private static decimal GetEffectivePrice(decimal price, decimal? salePrice)
    {
        var sale = salePrice.HasValue ? salePrice.Value : 0;
        if (sale > 0 && sale < price)
        {
            return sale;
        }

        return price > 0 ? price : 0;
    }

    private static void SendOrderNotification(CfOrder order, List<CfOrderItem> items)
    {
        if (order == null)
        {
            return;
        }

        try
        {
            var smtpSection = WebConfigurationManager.GetSection("system.net/mailSettings/smtp") as System.Net.Configuration.SmtpSection;
            if (smtpSection == null)
            {
                return;
            }

            CfEmailAccount account;
            using (var db = new BeautyStoryContext())
            {
                account = db.CfEmailAccounts.Where(a => a.Status).OrderBy(a => a.SortOrder).ThenBy(a => a.Id).FirstOrDefault();
            }

            if (account == null || string.IsNullOrWhiteSpace(account.Email) || string.IsNullOrWhiteSpace(account.Password))
            {
                return;
            }

            if (string.IsNullOrWhiteSpace(account.OrderRecipientEmails))
            {
                return;
            }

            var fromAddress = new MailAddress(account.Email, string.IsNullOrWhiteSpace(account.DisplayName) ? "LoveIs Store" : account.DisplayName);
            var subject = string.Format("Ðơn hàng mới: {0}", order.OrderCode);

            var baseUrl = string.Empty;
            var context = System.Web.HttpContext.Current;
            if (context != null && context.Request != null && context.Request.Url != null)
            {
                baseUrl = context.Request.Url.GetLeftPart(UriPartial.Authority);
            }

            CfContactInfo contactInfo;
            using (var db = new BeautyStoryContext())
            {
                contactInfo = db.CfContactInfos
                    .Where(i => i.Status)
                    .OrderBy(i => i.SortOrder)
                    .ThenBy(i => i.Id)
                    .FirstOrDefault();
            }

            var logoUrl = contactInfo != null && !string.IsNullOrWhiteSpace(contactInfo.LogoVerticalUrl)
                ? contactInfo.LogoVerticalUrl
                : (contactInfo != null && !string.IsNullOrWhiteSpace(contactInfo.LogoHorizontalUrl) ? contactInfo.LogoHorizontalUrl : string.Empty);
            logoUrl = BuildAbsoluteUrl(baseUrl, logoUrl);

            var productIds = items != null ? items.Select(i => i.ProductId).Distinct().ToList() : new List<int>();
            var imageLookup = new Dictionary<int, string>();
            if (productIds.Count > 0)
            {
                using (var db = new BeautyStoryContext())
                {
                    var images = db.CfProductImages.AsNoTracking()
                        .Where(i => productIds.Contains(i.ProductId) && i.Status)
                        .ToList();

                    foreach (var group in images.GroupBy(i => i.ProductId))
                    {
                        var primary = group.FirstOrDefault(i => i.IsPrimary);
                        var fallback = group.FirstOrDefault();
                        var imageUrl = primary != null ? primary.ImageUrl : (fallback != null ? fallback.ImageUrl : string.Empty);
                        imageLookup[group.Key] = BuildAbsoluteUrl(baseUrl, imageUrl);
                    }
                }
            }

            var bodyBuilder = new StringBuilder();
            bodyBuilder.AppendLine("<!DOCTYPE html>");
            bodyBuilder.AppendLine("<html><head><meta charset=\"UTF-8\"></head><body style=\"margin:0;padding:0;background:#f6f6f6;font-family:Roboto,sans-serif;color:#1f1f1f;\">");
            bodyBuilder.AppendLine("<div style=\"max-width:720px;margin:0 auto;padding:24px;\">");
            bodyBuilder.AppendLine("<div style=\"background:#ffffff;border-radius:12px;overflow:hidden;border:1px solid #eee;\">");
            bodyBuilder.AppendLine("<div style=\"padding:20px 24px;border-bottom:1px solid #f0f0f0;display:flex;align-items:center;gap:16px;\">");
            if (!string.IsNullOrWhiteSpace(logoUrl))
            {
                bodyBuilder.AppendLine("<img src=\"" + logoUrl + "\" alt=\"LoveIs Store\" style=\"height:48px;\" />");
            }
            bodyBuilder.AppendLine("<div>");
            bodyBuilder.AppendLine("<div style=\"font-size:18px;font-weight:bold;\">Ðơn hàng mới</div>");
            bodyBuilder.AppendLine("<div style=\"color:#666;\">Mã đơn hàng: <strong>" + HttpUtility.HtmlEncode(order.OrderCode) + "</strong></div>");
            bodyBuilder.AppendLine("</div></div>");

            bodyBuilder.AppendLine("<div style=\"padding:24px;\">");
            bodyBuilder.AppendLine("<div style=\"margin-bottom:16px;\">");
            bodyBuilder.AppendLine("<div style=\"font-weight:bold;margin-bottom:6px;\">Thông tin khách hàng</div>");
            bodyBuilder.AppendLine("<div>Họ & tên: " + HttpUtility.HtmlEncode(order.CustomerName) + "</div>");
            bodyBuilder.AppendLine("<div>Điện thoại: " + HttpUtility.HtmlEncode(order.Phone) + "</div>");
            bodyBuilder.AppendLine("<div>Địa chỉ: " + HttpUtility.HtmlEncode(order.AddressLine) + "</div>");
            if (!string.IsNullOrWhiteSpace(order.WardName) || !string.IsNullOrWhiteSpace(order.ProvinceName))
            {
                bodyBuilder.AppendLine("<div>Khu vực: " + HttpUtility.HtmlEncode(string.Format("{0} {1}", order.WardName, order.ProvinceName).Trim()) + "</div>");
            }
            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"margin-bottom:16px;\">");
            bodyBuilder.AppendLine("<div style=\"font-weight:bold;margin-bottom:6px;\">Thông tin đơn hàng</div>");
            bodyBuilder.AppendLine("<div>Thanh toán: " + HttpUtility.HtmlEncode(order.PaymentMethod) + "</div>");
            bodyBuilder.AppendLine("<div>Vận chuyển: " + HttpUtility.HtmlEncode(order.ShippingMethod) + "</div>");
            bodyBuilder.AppendLine("<div>Ghi chú: " + HttpUtility.HtmlEncode(order.Note ?? string.Empty) + "</div>");
            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"margin-bottom:16px;\">");
            bodyBuilder.AppendLine("<div style=\"font-weight:bold;margin-bottom:10px;\">Sản phẩm</div>");
            bodyBuilder.AppendLine("<table style=\"width:100%;border-collapse:collapse;font-size:14px;\">");
            bodyBuilder.AppendLine("<thead><tr>");
            bodyBuilder.AppendLine("<th style=\"text-align:left;padding:8px;border-bottom:1px solid #eee;\">Sản phẩm</th>");
            bodyBuilder.AppendLine("<th style=\"text-align:center;padding:8px;border-bottom:1px solid #eee;\">SL</th>");
            bodyBuilder.AppendLine("<th style=\"text-align:right;padding:8px;border-bottom:1px solid #eee;\">Thành tiền</th>");
            bodyBuilder.AppendLine("</tr></thead><tbody>");

            if (items != null && items.Count > 0)
            {
                foreach (var item in items)
                {
                    var imageUrl = imageLookup.ContainsKey(item.ProductId) ? imageLookup[item.ProductId] : string.Empty;
                    bodyBuilder.AppendLine("<tr>");
                    bodyBuilder.AppendLine("<td style=\"padding:10px 8px;border-bottom:1px solid #f3f3f3;\">");
                    bodyBuilder.AppendLine("<div style=\"display:flex;gap:10px;align-items:center;\">");
                    if (!string.IsNullOrWhiteSpace(imageUrl))
                    {
                        bodyBuilder.AppendLine("<img src=\"" + imageUrl + "\" alt=\"\" style=\"width:48px;height:48px;border-radius:6px;object-fit:cover;\" />");
                    }
                    bodyBuilder.AppendLine("<div>");
                    bodyBuilder.AppendLine("<div style=\"font-weight:600;\">" + HttpUtility.HtmlEncode(item.ProductName) + "</div>");
                    if (!string.IsNullOrWhiteSpace(item.VariantName))
                    {
                        bodyBuilder.AppendLine("<div style=\"color:#666;font-size:12px;\">" + HttpUtility.HtmlEncode(item.VariantName) + "</div>");
                    }
                    bodyBuilder.AppendLine("</div></div>");
                    bodyBuilder.AppendLine("</td>");
                    bodyBuilder.AppendLine("<td style=\"text-align:center;padding:10px 8px;border-bottom:1px solid #f3f3f3;\">" + item.Quantity + "</td>");
                    bodyBuilder.AppendLine("<td style=\"text-align:right;padding:10px 8px;border-bottom:1px solid #f3f3f3;\">" + item.LineTotal.ToString("n0") + " đ</td>");
                    bodyBuilder.AppendLine("</tr>");
                }
            }

            bodyBuilder.AppendLine("</tbody></table>");
            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"border-top:1px solid #f0f0f0;padding-top:12px;display:flex;justify-content:flex-end;\">");
            bodyBuilder.AppendLine("<div style=\"min-width:240px;\">");
            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:4px 0;\"><span>Tạm tính:&nbsp;</span><strong>" + order.Subtotal.ToString("n0") + " đ</strong></div>");
            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:4px 0;\"><span>Phí vận chuyển:&nbsp;</span><strong>" + order.ShippingFee.ToString("n0") + " đ</strong></div>");
            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:6px 0;font-size:16px;\">");
            bodyBuilder.AppendLine("<span>Tổng cộng:&nbsp;</span><strong style=\"color:#f09a2f;\">" + order.Total.ToString("n0") + " đ</strong></div>");
            bodyBuilder.AppendLine("</div></div>");

            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"padding:18px 24px;border-top:1px solid #f0f0f0;background:#fafafa;color:#666;font-size:12px;\">");
            if (contactInfo != null)
            {
                bodyBuilder.AppendLine("<div style=\"font-weight:600;color:#333;margin-bottom:4px;\">" + HttpUtility.HtmlEncode(contactInfo.CompanyName ?? "LoveIs Store") + "</div>");
                if (!string.IsNullOrWhiteSpace(contactInfo.Address))
                {
                    bodyBuilder.AppendLine("<div>" + HttpUtility.HtmlEncode(contactInfo.Address) + "</div>");
                }
                if (!string.IsNullOrWhiteSpace(contactInfo.Email))
                {
                    bodyBuilder.AppendLine("<div>Email: " + HttpUtility.HtmlEncode(contactInfo.Email) + "</div>");
                }
                if (!string.IsNullOrWhiteSpace(contactInfo.Hotline))
                {
                    bodyBuilder.AppendLine("<div>Hotline: " + HttpUtility.HtmlEncode(contactInfo.Hotline) + "</div>");
                }
            }
            bodyBuilder.AppendLine("</div></div></div></body></html>");

            using (var mail = new MailMessage())
            {
                mail.From = fromAddress;
                AddRecipients(mail, account.OrderRecipientEmails);
                mail.Subject = subject;
                mail.Body = bodyBuilder.ToString();
                mail.IsBodyHtml = true;

                using (var client = new SmtpClient(smtpSection.Network.Host, smtpSection.Network.Port))
                {
                    client.EnableSsl = smtpSection.Network.EnableSsl;
                    client.Credentials = new NetworkCredential(account.Email, account.Password);
                    client.Timeout = 10000;
                    client.Send(mail);
                }
            }
        }
        catch
        {
        }
    }

    private static void AddRecipients(MailMessage mail, string recipients)
    {
        if (mail == null || string.IsNullOrWhiteSpace(recipients))
        {
            return;
        }

        var items = recipients.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
        foreach (var item in items)
        {
            var address = item.Trim();
            if (!string.IsNullOrWhiteSpace(address))
            {
                mail.To.Add(address);
            }
        }
    }

    private static string BuildAbsoluteUrl(string baseUrl, string url)
    {
        if (string.IsNullOrWhiteSpace(url))
        {
            return string.Empty;
        }

        if (url.StartsWith("http", StringComparison.OrdinalIgnoreCase))
        {
            return url;
        }

        if (string.IsNullOrWhiteSpace(baseUrl))
        {
            return url;
        }

        return baseUrl.TrimEnd('/') + "/" + url.TrimStart('/');
    }

    [System.Web.Services.WebMethod]
    public static List<WardOption> GetWards(int provinceId)
    {
        using (var db = new BeautyStoryContext())
        {
            return db.CfWards
                .Where(w => w.ProvinceId == provinceId)
                .OrderBy(w => w.WardName)
                .Select(w => new WardOption { Id = w.Id, Name = w.WardName })
                .ToList();
        }
    }

    [System.Web.Services.WebMethod]
    public static ShippingSummary GetShippingSummary(int provinceId, int shippingMethodId)
    {
        decimal subtotal = 0;
        decimal shippingFee = 0;

        using (var db = new BeautyStoryContext())
        {
            var cart = CartService.GetCart();
            if (cart.Count > 0)
            {
                var variantIds = cart.Select(c => c.VariantId).ToList();
                var variants = db.CfProductVariants
                    .Where(v => variantIds.Contains(v.Id))
                    .Select(v => new { v.Id, v.Price, v.SalePrice })
                    .ToList();
                var variantLookup = variants.ToDictionary(v => v.Id, v => v);

                foreach (var item in cart)
                {
                    if (!variantLookup.ContainsKey(item.VariantId))
                    {
                        continue;
                    }

                    var variant = variantLookup[item.VariantId];
                    var price = GetEffectivePrice(variant.Price, variant.SalePrice);
                    subtotal += price * item.Quantity;
                }
            }

            var method = db.CfShippingMethods.FirstOrDefault(m => m.Id == shippingMethodId);
            if (method != null)
            {
                var baseFee = method.BaseFee;
                var innerCityFee = method.InnerCityFee > 0 ? method.InnerCityFee : method.BaseFee;

                if (provinceId > 0)
                {
                    var province = db.CfProvinces.FirstOrDefault(p => p.Id == provinceId);
                    if (province != null)
                    {
                        var name = province.ProvinceName ?? string.Empty;
                        if (name.Contains("Hồ Chí Minh") || name.Contains("Hà Nội"))
                        {
                            shippingFee = innerCityFee;
                        }
                        else
                        {
                            shippingFee = baseFee;
                        }
                    }
                    else
                    {
                        shippingFee = baseFee;
                    }
                }
                else
                {
                    shippingFee = baseFee;
                }
            }
        }

        var total = subtotal + shippingFee;
        return new ShippingSummary
        {
            ShippingFeeText = shippingFee > 0 ? string.Format("{0:N0} đ", shippingFee) : "Miễn phí",
            TotalText = total > 0 ? string.Format("{0:N0} đ", total) : "Liên hệ"
        };
    }
}





