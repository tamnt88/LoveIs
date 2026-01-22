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

        public class CheckoutSummary

    {

        public string ShippingFeeText { get; set; }

        public string DiscountText { get; set; }

        public string TotalText { get; set; }

        public List<ShopShippingFeeDto> ShopFees { get; set; }

    }
    public class ShopShippingFeeDto
    {
        public int ShopId { get; set; }
        public string ShopName { get; set; }
        public string ShippingFeeText { get; set; }
    }
    public class ShippingSummary

    {

        public decimal ShippingFee { get; set; }

        public string ShippingFeeText { get; set; }

        public decimal Total { get; set; }

        public string TotalText { get; set; }

        public List<ShopShippingFeeDto> ShopFees { get; set; }

    }

    private class ShopFeeSummary

    {

        public decimal Subtotal { get; set; }

        public decimal PlatformFeeAmount { get; set; }

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
            BindOnePayChannels();

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


            var onlineMethod = methods.FirstOrDefault(m => IsOnlinePaymentMethod(m));
            OnlinePaymentMethodId.Value = onlineMethod != null ? onlineMethod.Id.ToString() : "0";
        }

    }


    private void BindOnePayChannels()
    {
        OnePayChannelList.Items.Clear();
        OnePayChannelList.Items.Add(new ListItem("Thẻ nội địa", "DOMESTIC"));
        OnePayChannelList.Items.Add(new ListItem("Thẻ quốc tế", "INTERNATIONAL"));
        OnePayChannelList.Items.Add(new ListItem("Ví điện tử/QR", "EWALLET"));
        OnePayChannelList.Items.Add(new ListItem("Apple Pay", "APPLEPAY"));
        OnePayChannelList.Items.Add(new ListItem("Samsung Pay", "SAMSUNGPAY"));
        OnePayChannelList.Items.Add(new ListItem("Google Pay", "GOOGLEPAY"));
        OnePayChannelList.SelectedValue = "DOMESTIC";
    }

    private static bool IsOnlinePaymentMethod(CfPaymentMethod method)
    {
        if (method == null)
        {
            return false;
        }
        var code = (method.Code ?? string.Empty).Trim().ToUpperInvariant();
        var name = (method.Name ?? string.Empty).Trim().ToUpperInvariant();
        return code == "ONLINE" || code == "ONEPAY" || name.Contains("ONLINE") || name.Contains("ONEPAY");
    }

    private static string GetOnePayCardList(string channel)
    {
        var key = (channel ?? string.Empty).Trim().ToUpperInvariant();
        if (key == "DOMESTIC")
        {
            return "DOMESTIC";
        }
        if (key == "INTERNATIONAL")
        {
            return "INTERNATIONAL";
        }
        if (key == "EWALLET")
        {
            return "EWALLET,QR,VIETQR";
        }
        if (key == "APPLEPAY")
        {
            return "APPLEPAY";
        }
        if (key == "SAMSUNGPAY")
        {
            return "SAMSUNGPAY";
        }
        if (key == "GOOGLEPAY")
        {
            return "GOOGLEPAY";
        }
        return string.Empty;
    }

    private static string GetOnePayChannelLabel(string channel)
    {
        var key = (channel ?? string.Empty).Trim().ToUpperInvariant();
        if (key == "DOMESTIC")
        {
            return "Thẻ nội địa";
        }
        if (key == "INTERNATIONAL")
        {
            return "The quoc te";
        }
        if (key == "EWALLET")
        {
            return "Vi dien tu/QR";
        }
        if (key == "APPLEPAY")
        {
            return "Apple Pay";
        }
        if (key == "SAMSUNGPAY")
        {
            return "Samsung Pay";
        }
        if (key == "GOOGLEPAY")
        {
            return "Google Pay";
        }
        return string.Empty;
    }

    private string BuildOnePayPaymentUrl(CfOrder order, string cardList)
    {
        var baseUrl = Request != null && Request.Url != null
            ? Request.Url.GetLeftPart(UriPartial.Authority)
            : string.Empty;
        var request = new OnePayRequest
        {
            MerchantId = OnePayHelper.GetSetting("OnePay:MerchantId", "TESTONEPAY32"),
            AccessCode = OnePayHelper.GetSetting("OnePay:AccessCode", "6BEB2566"),
            SecureHash = OnePayHelper.GetSetting("OnePay:HashCode", "6D0870CDE5F24F34F3915FB0045120D6"),
            BaseUrl = OnePayHelper.GetSetting("OnePay:BaseUrl", "https://mtf.onepay.vn"),
            UrlPrefix = OnePayHelper.GetSetting("OnePay:UrlPrefix", "/paygate/vpcpay.op?"),
            ReturnUrl = BuildAbsoluteUrl(baseUrl, "/thanh-toan/onepay-return.aspx"),
            CallbackUrl = BuildAbsoluteUrl(baseUrl, "/thanh-toan/onepay-ipn.aspx"),
            MerchantTxnRef = order != null ? order.OrderCode : string.Empty,
            OrderInfo = order != null ? order.OrderCode : string.Empty,
            Amount = order != null ? OnePayHelper.ToOnePayAmount(order.Total) : 0,
            CustomerId = order != null && order.CustomerId.HasValue ? order.CustomerId.Value.ToString() : string.Empty,
            CustomerEmail = order != null ? order.InvoiceEmail : string.Empty,
            CustomerPhone = order != null ? order.Phone : string.Empty,
            TicketNo = Request != null ? Request.UserHostAddress : string.Empty,
            CardList = cardList ?? string.Empty
        };

        return OnePayHelper.BuildPaymentUrl(request);
    }

    private void BindSummary()

    {

        var cart = GetCheckoutCart();

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
                    ShopId = product != null && product.ShopId.HasValue ? product.ShopId.Value : 0,

                    ProductName = product != null ? product.ProductName : "-",

                    VariantText = attrs.Count > 0 ? string.Join(", ", attrs) : "Mặc định",

                    Quantity = item.Quantity,

                    PriceValue = price,

                    LineTotalValue = lineTotal,

                    LineTotal = price > 0 ? string.Format("{0:N0} đ", lineTotal) : "Liên hệ"

                };

            }).ToList();

            var shopIds = products.Where(p => p.ShopId.HasValue).Select(p => p.ShopId.Value).Distinct().ToList();
            var shopNameLookup = db.CfShops.AsNoTracking()
                .Where(s => shopIds.Contains(s.Id))
                .Select(s => new { s.Id, s.ShopName })
                .ToDictionary(s => s.Id, s => s.ShopName);

            var grouped = lines.GroupBy(x => x.ShopId)
                .Select(g => new
                {
                    ShopId = g.Key,
                    ShopName = shopNameLookup.ContainsKey(g.Key) ? shopNameLookup[g.Key] : "Shop",
                    Items = g.ToList()
                })
                .ToList();

            SummaryGroupRepeater.DataSource = grouped;
            SummaryGroupRepeater.DataBind();

            var subtotal = lines.Sum(x => x.LineTotalValue);

                        int provinceId;
            int? provinceValue = int.TryParse(ProvinceDropDown.SelectedValue, out provinceId) ? (int?)provinceId : null;
            int wardId;
            int? wardValue = int.TryParse(WardDropDown.SelectedValue, out wardId) ? (int?)wardId : null;

            int shippingMethodId;

            int? shippingMethodValue = int.TryParse(ShippingMethodList.SelectedValue, out shippingMethodId) ? (int?)shippingMethodId : null;

            var shopLookup = CheckoutShippingHelper.BuildShopShippingLookup(provinceValue, wardValue, shippingMethodValue, cart);

            var customerId = CustomerAuth.GetCustomerId();

            BindCoupons(db, shopLookup, customerId);

            var selectedCouponIds = GetSelectedCouponIds();

            var couponResult = CalculateCouponDiscounts(db, shopLookup, customerId, selectedCouponIds);

            var discount = couponResult.TotalDiscount;

            var breakdown = shopLookup.Values.Select(s => new ShopShippingFeeDto
            {
                ShopId = s.ShopId,
                ShopName = shopNameLookup.ContainsKey(s.ShopId) ? shopNameLookup[s.ShopId] : "Shop",
                ShippingFeeText = s.ShippingFee > 0 ? string.Format("{0:N0} đ", s.ShippingFee) : "Miễn phí"
            }).ToList();

            ShippingFeeRepeater.DataSource = breakdown;
            ShippingFeeRepeater.DataBind();

            var shippingFee = shopLookup.Values.Sum(x => x.ShippingFee);

            var total = subtotal - discount + shippingFee;

            SubtotalLiteral.Text = subtotal > 0 ? string.Format("{0:N0} đ", subtotal) : "Liên hệ";

            ShippingFeeLiteral.Text = shippingFee > 0 ? string.Format("{0:N0} đ", shippingFee) : "Miễn phí";

            DiscountLiteral.Text = discount > 0 ? string.Format("{0:N0} đ", discount) : "0 đ";

            TotalLiteral.Text = total > 0 ? string.Format("{0:N0} đ", total) : "Liên hệ";

        }

    }

        private List<CartService.CartItem> GetCheckoutCart()
    {
        var cart = CartService.GetCart();
        var selected = GetSelectedVariantIds(Request != null ? Request.QueryString["items"] : null);
        if (selected.Count == 0)
        {
            return cart;
        }
        return cart.Where(item => selected.Contains(item.VariantId)).ToList();
    }

    private static List<int> GetSelectedVariantIds(string raw)
    {
        var result = new List<int>();
        if (string.IsNullOrWhiteSpace(raw))
        {
            return result;
        }
        var parts = raw.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
        foreach (var part in parts)
        {
            int id;
            if (int.TryParse(part.Trim(), out id) && id > 0 && !result.Contains(id))
            {
                result.Add(id);
            }
        }
        return result;
    }

    private void RemoveCheckedItemsFromCart()
    {
        var selected = GetSelectedVariantIds(Request != null ? Request.QueryString["items"] : null);
        if (selected.Count == 0)
        {
            CartService.ClearCart();
            return;
        }
        CartService.RemoveVariants(selected);
    }

    private int? GetSelectedShippingMethodId()
    {
        int id;
        return int.TryParse(ShippingMethodList.SelectedValue, out id) ? (int?)id : null;
    }

    private decimal CalculateShippingFee()
    {
        int provinceId;
        int wardId;

        int? provinceValue = int.TryParse(ProvinceDropDown.SelectedValue, out provinceId) ? (int?)provinceId : null;
        int? wardValue = int.TryParse(WardDropDown.SelectedValue, out wardId) ? (int?)wardId : null;

        var cart = GetCheckoutCart();

        int shippingMethodId;

            int? shippingMethodValue = int.TryParse(ShippingMethodList.SelectedValue, out shippingMethodId) ? (int?)shippingMethodId : null;

        var shopLookup = CheckoutShippingHelper.BuildShopShippingLookup(provinceValue, wardValue, shippingMethodValue, cart);

        return shopLookup.Values.Sum(x => x.ShippingFee);
    }

    private class CouponDiscountResult

    {

        public decimal TotalDiscount { get; set; }

        public Dictionary<int, decimal> ShopDiscountLookup { get; set; }

        public Dictionary<int, decimal> CouponDiscountLookup { get; set; }

        public List<CfCoupon> AppliedCoupons { get; set; }

    }

    private class CouponDisplay

    {

        public int Id { get; set; }

        public string Code { get; set; }

        public string BadgeValue { get; set; }

        public string BadgeSub { get; set; }

        public string ShopLabel { get; set; }

        public string MetaText { get; set; }

        public bool IsSelected { get; set; }

    }

    private void BindCoupons(BeautyStoryContext db, Dictionary<int, ShopShippingFeeSummary> shopLookup, int? customerId)

    {

        if (db == null || shopLookup == null)

        {

            return;

        }

        var coupons = GetAvailableCoupons(db, shopLookup, customerId);

        var shopIds = coupons.Where(c => c.ShopId.HasValue).Select(c => c.ShopId.Value).Distinct().ToList();

        var shopNameLookup = db.CfShops.AsNoTracking()

            .Where(s => shopIds.Contains(s.Id))

            .Select(s => new { s.Id, s.ShopName })

            .ToDictionary(s => s.Id, s => s.ShopName);

        var selectedIds = ParseSelectedCouponIds(SelectedCouponIds.Value);

        var display = coupons.Select(coupon =>

        {

            string shopName = null;

            if (coupon.ShopId.HasValue && shopNameLookup.ContainsKey(coupon.ShopId.Value))

            {

                shopName = shopNameLookup[coupon.ShopId.Value];

            }

            return new CouponDisplay

            {

                Id = coupon.Id,

                Code = coupon.Code,

                BadgeValue = FormatCouponBadgeValue(coupon),

                BadgeSub = FormatCouponBadgeSub(coupon),

                ShopLabel = IsShopScope(coupon) ? ("Áp theo shop: " + (string.IsNullOrWhiteSpace(shopName) ? "Shop" : shopName)) : "Hệ thống",

                MetaText = BuildCouponMetaText(coupon),

                IsSelected = selectedIds.Contains(coupon.Id)

            };

        }).ToList();

        CouponRepeater.DataSource = display;

        CouponRepeater.DataBind();

    }

    private List<int> GetSelectedCouponIds()

    {

        return ParseSelectedCouponIds(SelectedCouponIds.Value);

    }

    private List<int> ParseSelectedCouponIds(string raw)

    {

        var result = new List<int>();

        if (string.IsNullOrWhiteSpace(raw))

        {

            return result;

        }

        var parts = raw.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

        foreach (var part in parts)

        {

            int id;

            if (int.TryParse(part.Trim(), out id))

            {

                if (!result.Contains(id))

                {

                    result.Add(id);

                }

            }

        }

        return result;

    }

    private static string FormatCouponBadgeValue(CfCoupon coupon)

    {

        if (coupon == null)

        {

            return string.Empty;

        }

        var type = (coupon.DiscountType ?? string.Empty).Trim().ToUpperInvariant();

        if (type == "PERCENT" || type == "PERCENTAGE")

        {

            return string.Format("{0}%", coupon.DiscountValue);

        }

        if (coupon.DiscountValue >= 1000)

        {

            var value = Math.Round(coupon.DiscountValue / 1000m, 0);

            return string.Format("{0}k", value);

        }

        return string.Format("{0}", coupon.DiscountValue);

    }

    private static string FormatCouponBadgeSub(CfCoupon coupon)

    {

        if (coupon == null)

        {

            return string.Empty;

        }

        if (coupon.MinOrder > 0)

        {

            return string.Format("Min {0:N0} d", coupon.MinOrder);

        }

        return "Moi";

    }

    private static string BuildCouponMetaText(CfCoupon coupon)

    {

        if (coupon == null)

        {

            return string.Empty;

        }

        if (coupon.EndAt.HasValue)

        {

            return string.Format("HSD: {0:dd/MM/yyyy}", coupon.EndAt.Value);

        }

        return "Khong gioi han";

    }

    private static List<CfCoupon> GetAvailableCoupons(BeautyStoryContext db, Dictionary<int, ShopShippingFeeSummary> shopLookup, int? customerId)

    {

        var now = DateTime.Now;

        var orderSubtotal = shopLookup.Values.Sum(x => x.Subtotal);

        var shopIds = shopLookup.Keys.ToList();

        var coupons = db.CfCoupons.AsNoTracking()

            .Where(c => c.Status)

            .Where(c => c.StartAt == null || c.StartAt <= now)

            .Where(c => c.EndAt == null || c.EndAt >= now)

            .Where(c => c.Scope == "System" || (c.Scope == "Shop" && c.ShopId.HasValue && shopIds.Contains(c.ShopId.Value)))

            .ToList();

        var result = new List<CfCoupon>();

        foreach (var coupon in coupons)

        {

            if (!IsCouponUsageAvailable(db, coupon, customerId))

            {

                continue;

            }

            if (!IsCouponMinOrderValid(coupon, shopLookup, orderSubtotal))

            {

                continue;

            }

            result.Add(coupon);

        }

        return result;

    }

    private static bool IsCouponUsageAvailable(BeautyStoryContext db, CfCoupon coupon, int? customerId)

    {

        if (coupon == null)

        {

            return false;

        }

        if (coupon.UsageLimit.HasValue)

        {

            var totalUsed = db.CfCouponUsages.Count(u => u.CouponId == coupon.Id);

            if (totalUsed >= coupon.UsageLimit.Value)

            {

                return false;

            }

        }

        if (coupon.UsagePerUser.HasValue && customerId.HasValue)

        {

            var usedByCustomer = db.CfCouponUsages.Count(u => u.CouponId == coupon.Id && u.CustomerId == customerId.Value);

            if (usedByCustomer >= coupon.UsagePerUser.Value)

            {

                return false;

            }

        }

        return true;

    }

    private static bool IsCouponMinOrderValid(CfCoupon coupon, Dictionary<int, ShopShippingFeeSummary> shopLookup, decimal orderSubtotal)

    {

        if (coupon == null)

        {

            return false;

        }

        var minOrder = coupon.MinOrder;

        if (minOrder <= 0)

        {

            return true;

        }

        if (IsShopScope(coupon))

        {

            if (!coupon.ShopId.HasValue || !shopLookup.ContainsKey(coupon.ShopId.Value))

            {

                return false;

            }

            return shopLookup[coupon.ShopId.Value].Subtotal >= minOrder;

        }

        return orderSubtotal >= minOrder;

    }

    private static string BuildCouponLabel(CfCoupon coupon, string shopName)

    {

        if (coupon == null)

        {

            return string.Empty;

        }

        var scope = IsShopScope(coupon) ? "Shop" : "Hệ thống";

        var type = (coupon.DiscountType ?? string.Empty).Trim().ToUpperInvariant();

        var valueText = type == "PERCENT" ? string.Format("{0}%", coupon.DiscountValue) : string.Format("{0:N0} đ", coupon.DiscountValue);
        if (IsShopScope(coupon))

        {

            var name = !string.IsNullOrWhiteSpace(shopName) ? shopName : "Shop";

            return string.Format("{0} - {1} ({2}: {3})", coupon.Code, valueText, scope, name);

        }

        return string.Format("{0} - {1} ({2})", coupon.Code, valueText, scope);

    }

    private static bool IsShopScope(CfCoupon coupon)

    {

        if (coupon == null)

        {

            return false;

        }

        var scope = (coupon.Scope ?? string.Empty).Trim().ToUpperInvariant();

        return scope == "SHOP";

    }

    private static decimal CalculateCouponValue(CfCoupon coupon, decimal baseAmount)

    {

        if (coupon == null || baseAmount <= 0)

        {

            return 0m;

        }

        var type = (coupon.DiscountType ?? string.Empty).Trim().ToUpperInvariant();

        decimal value;

        if (type == "PERCENT" || type == "PERCENTAGE")

        {

            value = baseAmount * coupon.DiscountValue / 100m;

        }

        else

        {

            value = coupon.DiscountValue;

        }

        if (coupon.MaxDiscount.HasValue && coupon.MaxDiscount.Value > 0)

        {

            value = Math.Min(value, coupon.MaxDiscount.Value);

        }

        return Math.Max(0m, Math.Min(value, baseAmount));

    }

    private static CouponDiscountResult CalculateCouponDiscounts(BeautyStoryContext db, Dictionary<int, ShopShippingFeeSummary> shopLookup, int? customerId, List<int> couponIds)

    {

        var result = new CouponDiscountResult

        {

            TotalDiscount = 0m,

            ShopDiscountLookup = new Dictionary<int, decimal>(),

            CouponDiscountLookup = new Dictionary<int, decimal>(),

            AppliedCoupons = new List<CfCoupon>()

        };

        if (db == null || shopLookup == null || couponIds == null || couponIds.Count == 0)

        {

            return result;

        }

        var orderSubtotal = shopLookup.Values.Sum(x => x.Subtotal);

        var coupons = db.CfCoupons.AsNoTracking()

            .Where(c => couponIds.Contains(c.Id))

            .OrderBy(c => c.Id)

            .ToList();

        foreach (var coupon in coupons)

        {

            if (!coupon.Status)

            {

                continue;

            }

            var now = DateTime.Now;

            if (coupon.StartAt.HasValue && coupon.StartAt.Value > now)

            {

                continue;

            }

            if (coupon.EndAt.HasValue && coupon.EndAt.Value < now)

            {

                continue;

            }

            if (!IsCouponUsageAvailable(db, coupon, customerId))

            {

                continue;

            }

            if (!IsCouponMinOrderValid(coupon, shopLookup, orderSubtotal))

            {

                continue;

            }

            decimal discount;

            if (IsShopScope(coupon))

            {

                if (!coupon.ShopId.HasValue || !shopLookup.ContainsKey(coupon.ShopId.Value))

                {

                    continue;

                }

                var shopId = coupon.ShopId.Value;

                var shopSubtotal = shopLookup[shopId].Subtotal;

                var currentShopDiscount = result.ShopDiscountLookup.ContainsKey(shopId) ? result.ShopDiscountLookup[shopId] : 0m;

                var remaining = Math.Max(0m, shopSubtotal - currentShopDiscount);

                discount = CalculateCouponValue(coupon, shopSubtotal);

                discount = Math.Min(discount, remaining);

                if (discount <= 0)

                {

                    continue;

                }

                result.ShopDiscountLookup[shopId] = currentShopDiscount + discount;

            }

            else

            {

                var remaining = Math.Max(0m, orderSubtotal - result.TotalDiscount);

                discount = CalculateCouponValue(coupon, orderSubtotal);

                discount = Math.Min(discount, remaining);

                if (discount <= 0)

                {

                    continue;

                }

            }

            result.TotalDiscount += discount;

            result.CouponDiscountLookup[coupon.Id] = discount;

            result.AppliedCoupons.Add(coupon);

        }

        result.TotalDiscount = Math.Min(result.TotalDiscount, orderSubtotal);

        return result;

    }

    private static void SaveCouponUsage(BeautyStoryContext db, int orderId, int customerId, CouponDiscountResult result)

    {

        if (db == null || result == null || result.CouponDiscountLookup == null || result.CouponDiscountLookup.Count == 0)

        {

            return;

        }

        foreach (var kv in result.CouponDiscountLookup)

        {

            var usage = new CfCouponUsage

            {

                CouponId = kv.Key,

                OrderId = orderId,

                CustomerId = customerId,

                DiscountAmount = kv.Value,

                CreatedAt = DateTime.Now

            };

            db.CfCouponUsages.Add(usage);

        }

        db.SaveChanges();

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

            AddressSelect.Items.Add(new ListItem("-- Chọn địa chỉ --", ""));

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
    var submitKey = "CHECKOUT_SUBMIT_LOCK";
    if (Session[submitKey] != null)
    {
        CheckoutMessage.Text = "Đơn hàng đang được xử lý. Vui lòng chờ.";
        return;
    }

    Session[submitKey] = true;
    try
    {
        CheckoutMessage.Text = string.Empty;

                                if (!EnsureCustomerSignedIn())
                                {
                                    return;
                                }

                                var cart = GetCheckoutCart();

                                                        if (cart.Count == 0)

                                                        {

                                                            CheckoutMessage.Text = "Giỏ hàng đang trống.";

                                                            return;

                                                        }

                                                        var limit = CartService.GetOrderLimitForCustomer();

                                                        if (limit != null)

                                                        {

                                                            var totalQty = cart.Sum(i => i.Quantity);

                                                            var overItemLimit = totalQty > limit.MaxItemsPerOrder;

                                                            var overQtyLimit = cart.Any(i => i.Quantity > limit.MaxQtyPerItem);

                                                            if (overItemLimit || overQtyLimit)

                                                            {

                                                                CheckoutMessage.Text = string.Format("Giới hạn đơn hàng: Tối đa {0} sản phẩm/đơn; mỗi sản phẩm tối đa {1}.", limit.MaxItemsPerOrder, limit.MaxQtyPerItem);

                                                                return;

                                                            }

                                                        }

                                                        var customerName = (CustomerNameInput.Text ?? string.Empty).Trim();

                                                        var phone = (PhoneInput.Text ?? string.Empty).Trim();

                                                        var addressLine = (AddressInput.Text ?? string.Empty).Trim();

                                                        if (string.IsNullOrWhiteSpace(customerName) || string.IsNullOrWhiteSpace(phone) || string.IsNullOrWhiteSpace(addressLine))

                                                        {

                                                            CheckoutMessage.Text = "Vui lòng nhập họ tên, số điện thoại và địa chỉ.";

                                                            return;

                                                        }

                                                        if (!IsValidPhone(phone))

                                                        {

                                                            CheckoutMessage.Text = "Số điện thoại không hợp lệ.";

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


                                                            var stockVariants = db.CfProductVariants
                                                                .Where(v => variantIds.Contains(v.Id))
                                                                .ToList();

                                                            var stockLookup = stockVariants.ToDictionary(v => v.Id, v => v);



                                                            var attributesByVariant = attributes

                                                                .GroupBy(a => a.VariantId)

                                                                .ToDictionary(g => g.Key, g => g.ToList());

                                                            var provinceName = provinceValue.HasValue

                                                                ? db.CfProvinces.Where(p => p.Id == provinceValue.Value).Select(p => p.ProvinceName).FirstOrDefault()

                                                                : null;

                                                            var wardName = wardValue.HasValue

                                                                ? db.CfWards.Where(w => w.Id == wardValue.Value).Select(w => w.WardName).FirstOrDefault()

                                                                : null;

                                                            foreach (var item in cart)
                                                            {
                                                                if (!stockLookup.ContainsKey(item.VariantId))
                                                                {
                                                                    CheckoutMessage.Text = "Sản phẩm không còn tồn tại.";
                                                                    return;
                                                                }

                                                                var stockVariant = stockLookup[item.VariantId];
                                                                if (!stockVariant.Status)
                                                                {
                                                                    CheckoutMessage.Text = "Sản phẩm đang tạm ngừng bán.";
                                                                    return;
                                                                }


                                                                var effectivePrice = GetEffectivePrice(stockVariant);
                                                                if (effectivePrice <= 0)
                                                                {
                                                                    CheckoutMessage.Text = "Sản phẩm không có giá hợp lệ.";
                                                                    return;
                                                                }

                                                var stockQty = Math.Max(0, stockVariant.StockQty);
                                                                if (stockQty < item.Quantity)
                                                                {
                                                                    var productName = productLookup.ContainsKey(stockVariant.ProductId)
                                                                        ? productLookup[stockVariant.ProductId].ProductName
                                                                        : "Sản phẩm";
                                                                    CheckoutMessage.Text = string.Format("{0} chỉ còn {1} Sản phẩm.", productName, stockQty);
                                                                    return;
                                                                }
                                                            }

                                                            var orderItems = new List<CfOrderItem>();


                                                            decimal subtotal = 0;

                                                            var categoryParentLookup = db.CfCategories.AsNoTracking()

                                                                .Select(c => new { c.Id, c.ParentId })

                                                                .ToDictionary(c => c.Id, c => c.ParentId);

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


                                                                if (stockLookup.ContainsKey(item.VariantId))
                                                                {
                                                                    stockLookup[item.VariantId].StockQty = Math.Max(0, stockLookup[item.VariantId].StockQty - item.Quantity);
                                                                }



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

                CreatedBy = customerIdValue > 0 ? "customer:" + customerIdValue : "customer",

                SortOrder = 0

                                                                });

                                                            }

                                                            int shippingMethodId;

            int? shippingMethodValue = int.TryParse(ShippingMethodList.SelectedValue, out shippingMethodId) ? (int?)shippingMethodId : null;

                                                            var shopShippingLookup = CheckoutShippingHelper.BuildShopShippingLookup(provinceValue, wardValue, shippingMethodValue, cart);

                                                            var selectedCouponIds = GetSelectedCouponIds();

                                                            var couponResult = CalculateCouponDiscounts(db, shopShippingLookup, customerIdValue > 0 ? (int?)customerIdValue : null, selectedCouponIds);

                                                            var discount = couponResult.TotalDiscount;

                                                            var shippingFee = shopShippingLookup.Values.Sum(x => x.ShippingFee);

                                                            var total = subtotal - discount + shippingFee;

                                                            int paymentMethodId;

                                                            int? paymentMethodValue = int.TryParse(PaymentMethodList.SelectedValue, out paymentMethodId) ? (int?)paymentMethodId : null;

                                                            var shippingMethod = shippingMethodValue.HasValue
                                                                ? db.CfShippingMethods.FirstOrDefault(m => m.Id == shippingMethodValue.Value)
                                                                : CheckoutShippingHelper.GetDefaultShippingMethod(db);

                                                            var paymentMethod = paymentMethodValue.HasValue

                                                                ? db.CfPaymentMethods.FirstOrDefault(m => m.Id == paymentMethodValue.Value)

                                                                : null;

                                                            var isOnlinePayment = IsOnlinePaymentMethod(paymentMethod);
                                                            var onePayChannel = OnePayChannelList.SelectedValue;
                                                            var onePayCardList = GetOnePayCardList(onePayChannel);

                                                            var config = GetPlatformFeeConfig(db);

                                                            var shippingFeePercent = config != null ? config.ShippingFeePercent : 0m;

                                                            var paymentFeePercent = config != null ? config.PaymentFeePercent : 0m;

                                                            var infrastructureFee = config != null ? config.InfrastructureFee : 0m;

                                                            var feeBase = subtotal - discount + shippingFee;

                                                            var shippingFeeAmount = feeBase * shippingFeePercent / 100m;

                                                            var paymentFeeAmount = feeBase * paymentFeePercent / 100m;

                                                            var feeCategoryLookup = GetPlatformFeeCategoryLookup(db, categoryParentLookup, products);

                                                            var platformFeeAmount = CalculatePlatformFee(orderItems, productLookup, categoryParentLookup, feeCategoryLookup);

                                                            var platformFeePercent = subtotal > 0 ? Math.Round(platformFeeAmount / subtotal * 100m, 2) : 0m;

                                                            var orderStatus = GetOrderStatusByCode(db, "NEW")
                ?? db.CfOrderStatuses.FirstOrDefault(s => s.IsDefault)
                ?? db.CfOrderStatuses.FirstOrDefault();

                                                            var paymentStatus = GetPaymentStatusByCode(db, "PENDING")
                ?? db.CfPaymentStatuses.FirstOrDefault(s => s.IsDefault)
                ?? db.CfPaymentStatuses.FirstOrDefault();

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

                                                                PaymentMethod = paymentMethod != null ? (isOnlinePayment && !string.IsNullOrWhiteSpace(onePayChannel) ? string.Format("{0} - {1}", paymentMethod.Name, GetOnePayChannelLabel(onePayChannel)) : paymentMethod.Name) : string.Empty,

                                                                PaymentStatusId = paymentStatus != null ? (int?)paymentStatus.Id : null,

                                                                PaymentStatus = paymentStatus != null ? paymentStatus.Name : string.Empty,

                                                                OrderStatusId = orderStatus != null ? (int?)orderStatus.Id : null,

                                                                OrderStatus = orderStatus != null ? orderStatus.Name : string.Empty,

                                                                Subtotal = subtotal,

                                                                Discount = discount,

                                                                ShippingFeePercent = shippingFeePercent,

                                                                ShippingFeeAmount = shippingFeeAmount,

                                                                PaymentFeePercent = paymentFeePercent,

                                                                PaymentFeeAmount = paymentFeeAmount,

                                                                PlatformFeePercent = platformFeePercent,

                                                                PlatformFeeAmount = platformFeeAmount,

                                                                InfrastructureFee = infrastructureFee,

                                                                Total = total,

                                                                Status = true,

                                                                CreatedAt = DateTime.Now,

                CreatedBy = customerIdValue > 0 ? "customer:" + customerIdValue : "customer",

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

                                                            var shopFeeLookup = BuildShopFeeLookup(orderItems, productLookup, categoryParentLookup, feeCategoryLookup);

                                                            CreateShopOrders(db, order, orderItems, productLookup, shopFeeLookup, shopShippingLookup, couponResult.ShopDiscountLookup);

                                                            if (customerIdValue > 0)

                                                            {

                                                                SaveCouponUsage(db, order.Id, customerIdValue, couponResult);

                                                            }

                                                            var actor = customerIdValue > 0 ? "customer:" + customerIdValue : "customer";

                                                            db.CfOrderHistories.Add(new CfOrderHistory
                                                            {
                                                                OrderId = order.Id,
                                                                Action = "Create",
                                                                Note = "Khởi tạo đơn hàng",
                                                                Status = true,
                                                                CreatedAt = DateTime.Now,
                                                                CreatedBy = actor,
                                                                SortOrder = 0
                                                            });

                                                            db.SaveChanges();

                                                            SendOrderNotification(order, orderItems);

                                                        if (isOnlinePayment)
                                                        {
                                                            var paymentUrl = BuildOnePayPaymentUrl(order, onePayCardList);
                                                            RemoveCheckedItemsFromCart();
                                                            Response.Redirect(paymentUrl);
                                                            return;
                                                        }

                                                        }

                                                        RemoveCheckedItemsFromCart();

                                                        Response.Redirect("/thanh-toan/hoan-tat.aspx?code=" + Server.UrlEncode(orderCode));
    }
    finally
    {
        Session.Remove(submitKey);
    }
}


        
    private static CfOrderStatus GetOrderStatusByCode(BeautyStoryContext db, string code)
    {
        if (db == null || string.IsNullOrWhiteSpace(code))
        {
            return null;
        }

        var key = code.Trim().ToUpperInvariant();
        return db.CfOrderStatuses.FirstOrDefault(s => s.Status && (s.Code ?? string.Empty).Trim().ToUpper() == key);
    }

    private static CfPaymentStatus GetPaymentStatusByCode(BeautyStoryContext db, string code)
    {
        if (db == null || string.IsNullOrWhiteSpace(code))
        {
            return null;
        }

        var key = code.Trim().ToUpperInvariant();
        return db.CfPaymentStatuses.FirstOrDefault(s => s.Status && (s.Code ?? string.Empty).Trim().ToUpper() == key);
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

    private static void CreateShopOrders(BeautyStoryContext db, CfOrder order, List<CfOrderItem> orderItems, Dictionary<int, CfProduct> productLookup, Dictionary<int, ShopFeeSummary> shopFeeLookup, Dictionary<int, ShopShippingFeeSummary> shopShippingLookup, Dictionary<int, decimal> shopDiscountLookup)

    {

        if (db == null || order == null || orderItems == null || orderItems.Count == 0 || productLookup == null)

        {

            return;

        }

        var productShopMap = productLookup

            .Where(kv => kv.Value != null)

            .ToDictionary(kv => kv.Key, kv => kv.Value.ShopId ?? 0);

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

            var share = order.Subtotal > 0 ? subtotal / order.Subtotal : 0m;

            ShopShippingFeeSummary shippingSummary = null;

            if (shopShippingLookup != null)
            {

                shopShippingLookup.TryGetValue(group.Key, out shippingSummary);

            }

            var shippingFee = shippingSummary != null ? shippingSummary.ShippingFee : order.ShippingFee * share;

            var shopDiscount = 0m;

            if (shopDiscountLookup != null && shopDiscountLookup.ContainsKey(group.Key))

            {

                shopDiscount = shopDiscountLookup[group.Key];

            }

            var shippingFeeAmount = (order.ShippingFeeAmount ?? 0m) * share;

            var paymentFeeAmount = (order.PaymentFeeAmount ?? 0m) * share;

            var infrastructureFee = (order.InfrastructureFee ?? 0m) * share;

            var platformFeeAmount = 0m;

            if (shopFeeLookup != null && shopFeeLookup.ContainsKey(group.Key))

            {

                platformFeeAmount = shopFeeLookup[group.Key].PlatformFeeAmount;

            }

            var platformFeePercent = subtotal > 0 ? Math.Round(platformFeeAmount / subtotal * 100m, 2) : 0m;

            var shopOrder = new CfShopOrder

            {

                OrderId = order.Id,

                ShopId = group.Key,

                ShippingMethod = shippingSummary != null ? shippingSummary.ShippingMethodName : order.ShippingMethod,

                ShippingFee = shippingFee,

                ShippingFeePercent = order.ShippingFeePercent,

                ShippingFeeAmount = shippingFeeAmount,

                ShippingEta = shippingSummary != null ? shippingSummary.ShippingEta : order.ShippingEta,

                ShippingCarrierId = shippingSummary != null ? shippingSummary.CarrierId : null,

                PaymentStatus = order.PaymentStatus,

                PaymentFeePercent = order.PaymentFeePercent,

                PaymentFeeAmount = paymentFeeAmount,

                OrderStatus = order.OrderStatus,

                Subtotal = subtotal,

                Discount = shopDiscount,

                PlatformFeePercent = platformFeePercent,

                PlatformFeeAmount = platformFeeAmount,

                InfrastructureFee = infrastructureFee,

                Total = subtotal - shopDiscount + shippingFee,

                Status = true,

                CreatedAt = DateTime.Now,

                CreatedBy = order.CreatedBy,

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
                CreatedBy = order.CreatedBy,
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

    private static CfPlatformFeeConfig GetPlatformFeeConfig(BeautyStoryContext db)

    {

        if (db == null)

        {

            return null;

        }

        return db.CfPlatformFeeConfigs

            .Where(c => c.Status)

            .OrderBy(c => c.SortOrder)

            .ThenBy(c => c.Id)

            .FirstOrDefault();

    }

    private static Dictionary<int, decimal> GetPlatformFeeCategoryLookup(

        BeautyStoryContext db,

        Dictionary<int, int?> parentLookup,

        List<CfProduct> products)

    {

        if (db == null || parentLookup == null || products == null || products.Count == 0)

        {

            return new Dictionary<int, decimal>();

        }

        var rootIds = products

            .Select(p => GetRootCategoryId(p.CategoryId, parentLookup))

            .Distinct()

            .ToList();

        return db.CfPlatformFeeCategories.AsNoTracking()

            .Where(f => f.Status && rootIds.Contains(f.CategoryId))

            .ToDictionary(f => f.CategoryId, f => f.PlatformFeePercent);

    }

    private static decimal CalculatePlatformFee(

        List<CfOrderItem> orderItems,

        Dictionary<int, CfProduct> productLookup,

        Dictionary<int, int?> parentLookup,

        Dictionary<int, decimal> feeLookup)

    {

        if (orderItems == null || productLookup == null || parentLookup == null || feeLookup == null)

        {

            return 0m;

        }

        decimal total = 0m;

        foreach (var item in orderItems)

        {

            if (!productLookup.ContainsKey(item.ProductId))

            {

                continue;

            }

            var product = productLookup[item.ProductId];

            var rootId = GetRootCategoryId(product.CategoryId, parentLookup);

            var percent = feeLookup.ContainsKey(rootId) ? feeLookup[rootId] : 0m;

            if (percent <= 0)

            {

                continue;

            }

            total += item.LineTotal * percent / 100m;

        }

        return total;

    }

    private static Dictionary<int, ShopFeeSummary> BuildShopFeeLookup(

        List<CfOrderItem> orderItems,

        Dictionary<int, CfProduct> productLookup,

        Dictionary<int, int?> parentLookup,

        Dictionary<int, decimal> feeLookup)

    {

        var result = new Dictionary<int, ShopFeeSummary>();

        if (orderItems == null || productLookup == null || parentLookup == null || feeLookup == null)

        {

            return result;

        }

        foreach (var item in orderItems)

        {

            if (!productLookup.ContainsKey(item.ProductId))

            {

                continue;

            }

            var product = productLookup[item.ProductId];

            var shopId = product.ShopId.HasValue ? product.ShopId.Value : 0;

            if (shopId <= 0)

            {

                continue;

            }

            if (!result.ContainsKey(shopId))

            {

                result[shopId] = new ShopFeeSummary();

            }

            var summary = result[shopId];

            summary.Subtotal += item.LineTotal;

            var rootId = GetRootCategoryId(product.CategoryId, parentLookup);

            var percent = feeLookup.ContainsKey(rootId) ? feeLookup[rootId] : 0m;

            if (percent > 0)

            {

                summary.PlatformFeeAmount += item.LineTotal * percent / 100m;

            }

        }

        return result;

    }

    private static int GetRootCategoryId(int categoryId, Dictionary<int, int?> parentLookup)

    {

        if (parentLookup == null || categoryId <= 0)

        {

            return categoryId;

        }

        var current = categoryId;

        var guard = 0;

        while (parentLookup.ContainsKey(current) && parentLookup[current].HasValue)

        {

            current = parentLookup[current].Value;

            guard++;

            if (guard > 10)

            {

                break;

            }

        }

        return current;

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

            var subject = string.Format("Đơn hàng mới: {0}", order.OrderCode);

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

            bodyBuilder.AppendLine("<div style=\"font-size:18px;font-weight:bold;\">Đơn hàng mới</div>");

            bodyBuilder.AppendLine("<div style=\"color:#666;\">Mã đơn hàng: <strong>" + HttpUtility.HtmlEncode(order.OrderCode) + "</strong></div>");

            bodyBuilder.AppendLine("</div></div>");

            bodyBuilder.AppendLine("<div style=\"padding:24px;\">");

            bodyBuilder.AppendLine("<div style=\"margin-bottom:16px;\">");

            bodyBuilder.AppendLine("<div style=\"font-weight:bold;margin-bottom:6px;\">Thông tin khách hàng</div>");

            bodyBuilder.AppendLine("<div>Họ và tên: " + HttpUtility.HtmlEncode(order.CustomerName) + "</div>");

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

            bodyBuilder.AppendLine("<th style=\"text-align:left;padding:8px;border-bottom:1px solid #eee;\">Đơn giá</th>");

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

                    bodyBuilder.AppendLine("<td style=\"text-align:right;padding:10px 8px;border-bottom:1px solid #f3f3f3;\">" + item.LineTotal.ToString("n0") + " </td>");

                    bodyBuilder.AppendLine("</tr>");

                }

            }

            bodyBuilder.AppendLine("</tbody></table>");

            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"border-top:1px solid #f0f0f0;padding-top:12px;display:flex;justify-content:flex-end;\">");

            bodyBuilder.AppendLine("<div style=\"min-width:240px;\">");

            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:4px 0;\"><span>Tạm tính:&nbsp;</span><strong>" + order.Subtotal.ToString("n0") + " </strong></div>");

            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:4px 0;\"><span>Phí vận chuyển:&nbsp;</span><strong>" + order.ShippingFee.ToString("n0") + " </strong></div>");

            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:6px 0;font-size:16px;\">");

            bodyBuilder.AppendLine("<span>Tổng cộng:&nbsp;</span><strong style=\"color:#f09a2f;\">" + order.Total.ToString("n0") + " </strong></div>");

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

    public static CheckoutSummary GetCheckoutSummary(int provinceId, int wardId, int shippingMethodId, int[] couponIds)
{
        var cart = CartService.GetCart();
        var selected = GetSelectedVariantIds(System.Web.HttpContext.Current != null ? System.Web.HttpContext.Current.Request.QueryString["items"] : null);
        if (selected.Count > 0)
        {
            cart = cart.Where(item => selected.Contains(item.VariantId)).ToList();
        }

        int? provinceValue = provinceId > 0 ? (int?)provinceId : null;
        int? wardValue = wardId > 0 ? (int?)wardId : null;

        int? shippingMethodValue = shippingMethodId > 0 ? (int?)shippingMethodId : null;

            var shopLookup = CheckoutShippingHelper.BuildShopShippingLookup(provinceValue, wardValue, shippingMethodValue, cart);

        var subtotal = shopLookup.Values.Sum(x => x.Subtotal);

        var shippingFee = shopLookup.Values.Sum(x => x.ShippingFee);

        decimal discount = 0m;

        using (var db = new BeautyStoryContext())

        {

            var customerId = CustomerAuth.GetCustomerId();

            var ids = couponIds != null ? couponIds.ToList() : new List<int>();

            var couponResult = CalculateCouponDiscounts(db, shopLookup, customerId, ids);

            discount = couponResult.TotalDiscount;

        }

        var total = subtotal - discount + shippingFee;

        List<ShopShippingFeeDto> breakdown = null;
        using (var db = new BeautyStoryContext())
        {
            var shopIds = shopLookup.Keys.ToList();
            var shopNameLookup = db.CfShops.AsNoTracking()
                .Where(s => shopIds.Contains(s.Id))
                .Select(s => new { s.Id, s.ShopName })
                .ToDictionary(s => s.Id, s => s.ShopName);

            breakdown = shopLookup.Values.Select(s => new ShopShippingFeeDto
            {
                ShopId = s.ShopId,
                ShopName = shopNameLookup.ContainsKey(s.ShopId) ? shopNameLookup[s.ShopId] : "Shop",
                ShippingFeeText = s.ShippingFee > 0 ? string.Format("{0:N0} đ", s.ShippingFee) : "Miễn phí"
            }).ToList();
        }
        return new CheckoutSummary

        {

            ShippingFeeText = shippingFee > 0 ? string.Format("{0:N0} đ", shippingFee) : "Miễn phí",

            DiscountText = discount > 0 ? string.Format("{0:N0} đ", discount) : "0 đ",
            TotalText = total > 0 ? string.Format("{0:N0} đ", total) : "Liên hệ",
            ShopFees = breakdown

        };

    }

}






































































