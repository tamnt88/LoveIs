using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Configuration;
using System.Web.UI.WebControls;

public partial class AdminOrdersCreate : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindStatuses();
            BindPaymentMethods();
            BindShippingMethods();
            BindProvinces();
            BindVariants();
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
                OrderStatusInput.Items.Add(new ListItem(item.Name, item.Id.ToString()));
            }

            var paymentStatuses = db.CfPaymentStatuses.Where(s => s.Status)
                .OrderBy(s => s.SortOrder).ThenBy(s => s.Name).ToList();
            PaymentStatusInput.Items.Clear();
            foreach (var item in paymentStatuses)
            {
                PaymentStatusInput.Items.Add(new ListItem(item.Name, item.Id.ToString()));
            }

            var defaultOrder = orderStatuses.FirstOrDefault(s => s.IsDefault) ?? orderStatuses.FirstOrDefault();
            if (defaultOrder != null)
            {
                OrderStatusInput.SelectedValue = defaultOrder.Id.ToString();
            }

            var defaultPayment = paymentStatuses.FirstOrDefault(s => s.IsDefault) ?? paymentStatuses.FirstOrDefault();
            if (defaultPayment != null)
            {
                PaymentStatusInput.SelectedValue = defaultPayment.Id.ToString();
            }
        }
    }

    private void BindPaymentMethods()
    {
        using (var db = new BeautyStoryContext())
        {
            var methods = db.CfPaymentMethods
                .Where(m => m.Status)
                .OrderBy(m => m.SortOrder)
                .ToList();

            PaymentMethodInput.Items.Clear();
            foreach (var method in methods)
            {
                PaymentMethodInput.Items.Add(new ListItem(method.Name, method.Id.ToString()));
            }

            var selected = methods.FirstOrDefault(m => m.IsDefault) ?? methods.FirstOrDefault();
            if (selected != null)
            {
                PaymentMethodInput.SelectedValue = selected.Id.ToString();
            }
        }
    }

    private void BindShippingMethods()
    {
        using (var db = new BeautyStoryContext())
        {
            var methods = db.CfShippingMethods
                .Where(m => m.Status)
                .OrderBy(m => m.SortOrder)
                .ToList();

            ShippingMethodInput.Items.Clear();
            ShippingMethodInput.Items.Add(new ListItem("-- Tu chon --", ""));
            foreach (var method in methods)
            {
                ShippingMethodInput.Items.Add(new ListItem(method.Name, method.Id.ToString()));
            }

            var selected = methods.FirstOrDefault(m => m.IsDefault);
            if (selected != null)
            {
                ShippingMethodInput.SelectedValue = selected.Id.ToString();
            }
        }
    }

    private void BindProvinces()
    {
        using (var db = new BeautyStoryContext())
        {
            var provinces = db.CfProvinces
                .OrderBy(p => p.SortOrder)
                .Select(p => new { p.Id, p.ProvinceName })
                .ToList();

            ProvinceInput.Items.Clear();
            ProvinceInput.Items.Add(new ListItem("-- Chọn tỉnh/thành phố --", ""));
            foreach (var item in provinces)
            {
                ProvinceInput.Items.Add(new ListItem(item.ProvinceName, item.Id.ToString()));
            }
        }

        WardInput.Items.Clear();
        WardInput.Items.Add(new ListItem("-- Chọn phường --", ""));
    }

    protected void ProvinceInput_SelectedIndexChanged(object sender, EventArgs e)
    {
        int provinceId;
        if (!int.TryParse(ProvinceInput.SelectedValue, out provinceId))
        {
            WardInput.Items.Clear();
            WardInput.Items.Add(new ListItem("-- Chọn phường --", ""));
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var wards = db.CfWards
                .Where(w => w.ProvinceId == provinceId)
                .OrderBy(w => w.WardName)
                .Select(w => new { w.Id, w.WardName })
                .ToList();

            WardInput.Items.Clear();
            WardInput.Items.Add(new ListItem("-- Chọn phường --", ""));
            foreach (var ward in wards)
            {
                WardInput.Items.Add(new ListItem(ward.WardName, ward.Id.ToString()));
            }
        }
    }

    private void BindVariants()
    {
        using (var db = new BeautyStoryContext())
        {
            var variants = db.CfProductVariants
                .Where(v => v.Status)
                .OrderByDescending(v => v.CreatedAt)
                .Take(500)
                .ToList();

            var productIds = variants.Select(v => v.ProductId).Distinct().ToList();
            var products = db.CfProducts.Where(p => productIds.Contains(p.Id)).ToList();
            var productLookup = products.ToDictionary(p => p.Id, p => p.ProductName);

            var variantIds = variants.Select(v => v.Id).ToList();
            var attributes = db.CfProductVariantAttributes
                .Where(pva => variantIds.Contains(pva.VariantId))
                .ToList();
            var attributeLookup = db.CfVariantAttributes.ToDictionary(a => a.Id, a => a.AttributeName);
            var valueLookup = db.CfVariantAttributeValues.ToDictionary(v => v.Id, v => v.ValueName);

            var items = variants.Select(v =>
            {
                var attrs = attributes
                    .Where(a => a.VariantId == v.Id)
                    .Select(a =>
                    {
                        var attrName = attributeLookup.ContainsKey(a.AttributeId) ? attributeLookup[a.AttributeId] : "";
                        var valueName = valueLookup.ContainsKey(a.AttributeValueId) ? valueLookup[a.AttributeValueId] : "";
                        return string.Format("{0}: {1}", attrName, valueName);
                    })
                    .Where(s => !string.IsNullOrWhiteSpace(s))
                    .ToList();

                var variantText = attrs.Count > 0 ? string.Join(", ", attrs) : "M?c ??nh";
                var productName = productLookup.ContainsKey(v.ProductId) ? productLookup[v.ProductId] : "-";
                var sku = string.IsNullOrWhiteSpace(v.Sku) ? null : v.Sku.Trim();
                var price = GetEffectivePrice(v);
                return new VariantOption
                {
                    Id = v.Id,
                    Label = sku == null
                        ? string.Format("{0} - {1}", productName, variantText)
                        : string.Format("{0} - {1} - {2}", sku, productName, variantText),
                    PriceText = price.ToString(CultureInfo.InvariantCulture)
                };
            }).ToList();

            VariantRepeater.DataSource = items;
            VariantRepeater.DataBind();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        int orderId = 0;

        var customerName = (CustomerNameInput.Text ?? string.Empty).Trim();
        var phone = (PhoneInput.Text ?? string.Empty).Trim();
        var address = (AddressInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(customerName) || string.IsNullOrWhiteSpace(phone) || string.IsNullOrWhiteSpace(address))
        {
            FormMessage.Text = "Vui lòng nhập đầy đủ thông tin khách hàng.";
            return;
        }

        var variantIds = Request.Form.GetValues("variantId") ?? new string[0];
        var quantities = Request.Form.GetValues("quantity") ?? new string[0];
        if (variantIds.Length == 0 || quantities.Length == 0)
        {
            FormMessage.Text = "Vui lòng chọn sản phẩm.";
            return;
        }

        var itemsMap = new Dictionary<int, int>();
        for (int i = 0; i < variantIds.Length; i++)
        {
            int variantId;
            int qty;
            if (!int.TryParse(variantIds[i], out variantId) || variantId <= 0)
            {
                continue;
            }
            if (!int.TryParse(quantities.Length > i ? quantities[i] : "0", out qty) || qty <= 0)
            {
                continue;
            }

            if (itemsMap.ContainsKey(variantId))
            {
                itemsMap[variantId] += qty;
            }
            else
            {
                itemsMap[variantId] = qty;
            }
        }

        if (itemsMap.Count == 0)
        {
            FormMessage.Text = "Vui lòng chọn sản phẩm & số lượng.";
            return;
        }

        int provinceId;
        int wardId;
        int? provinceValue = int.TryParse(ProvinceInput.SelectedValue, out provinceId) ? (int?)provinceId : null;
        int? wardValue = int.TryParse(WardInput.SelectedValue, out wardId) ? (int?)wardId : null;

        decimal shippingFee;
        if (!decimal.TryParse(ShippingFeeInput.Text.Replace(".", "").Replace(",", ""), out shippingFee))
        {
            shippingFee = 0;
        }

        int orderStatusId;
        int paymentStatusId;
        int paymentMethodId;
        int shippingMethodId;
        int.TryParse(OrderStatusInput.SelectedValue, out orderStatusId);
        int.TryParse(PaymentStatusInput.SelectedValue, out paymentStatusId);
        int.TryParse(PaymentMethodInput.SelectedValue, out paymentMethodId);
        int.TryParse(ShippingMethodInput.SelectedValue, out shippingMethodId);

        var orderCode = GenerateOrderCode();

        using (var db = new BeautyStoryContext())
        {
            var variantIdList = itemsMap.Keys.ToList();
            var variants = db.CfProductVariants.Where(v => variantIdList.Contains(v.Id)).ToList();
            var productIds = variants.Select(v => v.ProductId).Distinct().ToList();
            var products = db.CfProducts.Where(p => productIds.Contains(p.Id)).ToList();
            var productLookup = products.ToDictionary(p => p.Id, p => p.ProductName);

            var attributes = db.CfProductVariantAttributes
                .Where(pva => variantIdList.Contains(pva.VariantId))
                .ToList();
            var attributeLookup = db.CfVariantAttributes.ToDictionary(a => a.Id, a => a.AttributeName);
            var valueLookup = db.CfVariantAttributeValues.ToDictionary(v => v.Id, v => v.ValueName);

            var provinceName = provinceValue.HasValue
                ? db.CfProvinces.Where(p => p.Id == provinceValue.Value).Select(p => p.ProvinceName).FirstOrDefault()
                : null;
            var wardName = wardValue.HasValue
                ? db.CfWards.Where(w => w.Id == wardValue.Value).Select(w => w.WardName).FirstOrDefault()
                : null;

            var orderItems = new List<CfOrderItem>();
            decimal subtotal = 0;

            foreach (var pair in itemsMap)
            {
                var variant = variants.FirstOrDefault(v => v.Id == pair.Key);
                if (variant == null)
                {
                    continue;
                }
                if (variant.StockQty < pair.Value)
                {
                    FormMessage.Text = "Số lượng tồn không đủ cho: " + variant.Id;
                    return;
                }

                var price = GetEffectivePrice(variant);
                var lineTotal = price * pair.Value;
                subtotal += lineTotal;

                var attrs = attributes
                    .Where(a => a.VariantId == variant.Id)
                    .Select(a =>
                    {
                        var attrName = attributeLookup.ContainsKey(a.AttributeId) ? attributeLookup[a.AttributeId] : "";
                        var valueName = valueLookup.ContainsKey(a.AttributeValueId) ? valueLookup[a.AttributeValueId] : "";
                        return string.Format("{0}: {1}", attrName, valueName);
                    })
                    .Where(s => !string.IsNullOrWhiteSpace(s))
                    .ToList();

                var variantText = attrs.Count > 0 ? string.Join(", ", attrs) : "Mặc định";
                var productName = productLookup.ContainsKey(variant.ProductId) ? productLookup[variant.ProductId] : "-";

                orderItems.Add(new CfOrderItem
                {
                    ProductId = variant.ProductId,
                    VariantId = variant.Id,
                    ProductName = productName,
                    VariantName = variantText,
                    Quantity = pair.Value,
                    Price = variant.Price,
                    SalePrice = variant.SalePrice,
                    LineTotal = lineTotal,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    SortOrder = 0
                });
            }

            if (orderItems.Count == 0)
            {
                FormMessage.Text = "Khong tao duoc san pham cho don hang.";
                return;
            }

            var shippingMethod = shippingMethodId > 0
                ? db.CfShippingMethods.FirstOrDefault(m => m.Id == shippingMethodId)
                : null;
            var paymentMethod = paymentMethodId > 0
                ? db.CfPaymentMethods.FirstOrDefault(m => m.Id == paymentMethodId)
                : null;

            var orderStatusName = orderStatusId > 0
                ? db.CfOrderStatuses.Where(s => s.Id == orderStatusId).Select(s => s.Name).FirstOrDefault()
                : null;
            var paymentStatusName = paymentStatusId > 0
                ? db.CfPaymentStatuses.Where(s => s.Id == paymentStatusId).Select(s => s.Name).FirstOrDefault()
                : null;

            var order = new CfOrder
            {
                OrderCode = orderCode,
                CustomerName = customerName,
                Phone = phone,
                AddressLine = address,
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
                PaymentStatusId = paymentStatusId > 0 ? (int?)paymentStatusId : null,
                PaymentStatus = paymentStatusName ?? string.Empty,
                OrderStatusId = orderStatusId > 0 ? (int?)orderStatusId : null,
                OrderStatus = orderStatusName ?? string.Empty,
                Subtotal = subtotal,
                Discount = 0,
                Total = subtotal + shippingFee,
                Status = true,
                CreatedAt = DateTime.Now,
                CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null,
                SortOrder = 0,
                Items = new List<CfOrderItem>()
            };

            db.CfOrders.Add(order);
            db.SaveChanges();
            orderId = order.Id;

            foreach (var item in orderItems)
            {
                item.OrderId = order.Id;
                db.CfOrderItems.Add(item);
            }

            foreach (var pair in itemsMap)
            {
                var variant = variants.FirstOrDefault(v => v.Id == pair.Key);
                if (variant != null)
                {
                    variant.StockQty -= pair.Value;
                }
            }

            db.CfOrderHistories.Add(new CfOrderHistory
            {
                OrderId = order.Id,
                Action = "Create",
                Note = "Tao don hang tai admin",
                Status = true,
                CreatedAt = DateTime.Now,
                CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin",
                SortOrder = 0
            });

            db.SaveChanges();

            SendOrderNotification(order, orderItems);
        }

        if (orderId > 0)
        {
            Response.Redirect("/admin/orders/edit.aspx?id=" + orderId);
        }
    }

    private static string GenerateOrderCode()
    {
        var random = new Random();
        return "BS" + DateTime.Now.ToString("yyyyMMddHHmmss") + random.Next(100, 999).ToString();
    }

    private static decimal GetEffectivePrice(CfProductVariant variant)
    {
        if (variant == null)
        {
            return 0;
        }

        var sale = variant.SalePrice.HasValue ? variant.SalePrice.Value : 0;
        if (sale > 0 && sale < variant.Price)
        {
            return sale;
        }

        return variant.Price > 0 ? variant.Price : 0;
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

            var fromAddress = new MailAddress(account.Email, string.IsNullOrWhiteSpace(account.DisplayName) ? "Beauty Story" : account.DisplayName);
            var subject = string.Format("Don hang moi: {0}", order.OrderCode);

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
                    var images = db.CfProductImages
                        .Where(i => productIds.Contains(i.ProductId) && i.Status)
                        .ToList();

                    imageLookup = images
                        .GroupBy(i => i.ProductId)
                        .ToDictionary(
                            g => g.Key,
                            g =>
                            {
                                var primary = g.FirstOrDefault(i => i.IsPrimary);
                                var imageUrl = primary != null ? primary.ImageUrl : g.FirstOrDefault() != null ? g.First().ImageUrl : string.Empty;
                                return BuildAbsoluteUrl(baseUrl, imageUrl);
                            });
                }
            }

            var bodyBuilder = new StringBuilder();
            bodyBuilder.AppendLine("<!DOCTYPE html>");
            bodyBuilder.AppendLine("<html><head><meta charset=\"UTF-8\"></head><body style=\"margin:0;padding:0;background:#f6f6f6;font-family:roboto,sans-serif;color:#1f1f1f;\">");
            bodyBuilder.AppendLine("<div style=\"max-width:720px;margin:0 auto;padding:24px;\">");
            bodyBuilder.AppendLine("<div style=\"background:#ffffff;border-radius:12px;overflow:hidden;border:1px solid #eee;\">");
            bodyBuilder.AppendLine("<div style=\"padding:20px 24px;border-bottom:1px solid #f0f0f0;display:flex;align-items:center;gap:16px;\">");
            if (!string.IsNullOrWhiteSpace(logoUrl))
            {
                bodyBuilder.AppendLine("<img src=\"" + logoUrl + "\" alt=\"Beauty Story\" style=\"height:48px;\" />");
            }
            bodyBuilder.AppendLine("<div>");
            bodyBuilder.AppendLine("<div style=\"font-size:18px;font-weight:bold;\">Đơn hàng mới</div>");
            bodyBuilder.AppendLine("<div style=\"color:#666;\">Mã đơn: <strong>" + HttpUtility.HtmlEncode(order.OrderCode) + "</strong></div>");
            bodyBuilder.AppendLine("</div></div>");

            bodyBuilder.AppendLine("<div style=\"padding:24px;\">");
            bodyBuilder.AppendLine("<div style=\"margin-bottom:16px;\">");
            bodyBuilder.AppendLine("<div style=\"font-weight:bold;margin-bottom:6px;\">Thông tin khách hàng</div>");
            bodyBuilder.AppendLine("<div>Họ tên: " + HttpUtility.HtmlEncode(order.CustomerName) + "</div>");
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
                    bodyBuilder.AppendLine("<td style=\"text-align:right;padding:10px 8px;border-bottom:1px solid #f3f3f3;\">" + item.LineTotal.ToString("n0") + " d</td>");
                    bodyBuilder.AppendLine("</tr>");
                }
            }

            bodyBuilder.AppendLine("</tbody></table>");
            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"border-top:1px solid #f0f0f0;padding-top:12px;display:flex;justify-content:flex-end;\">");
            bodyBuilder.AppendLine("<div style=\"min-width:240px;\">");
            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:4px 0;\"><span>Tạm tính:&nbsp;</span><strong>" + order.Subtotal.ToString("n0") + " d</strong></div>");
            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:4px 0;\"><span>Phí vận chuyển:&nbsp;</span><strong>" + order.ShippingFee.ToString("n0") + " d</strong></div>");
            bodyBuilder.AppendLine("<div style=\"display:flex;justify-content:space-between;padding:6px 0;font-size:16px;\">");
            bodyBuilder.AppendLine("<span>Tổng cộng:&nbsp;</span><strong style=\"color:#f09a2f;\">" + order.Total.ToString("n0") + " d</strong></div>");
            bodyBuilder.AppendLine("</div></div>");

            bodyBuilder.AppendLine("</div>");

            bodyBuilder.AppendLine("<div style=\"padding:18px 24px;border-top:1px solid #f0f0f0;background:#fafafa;color:#666;font-size:12px;\">");
            if (contactInfo != null)
            {
                bodyBuilder.AppendLine("<div style=\"font-weight:600;color:#333;margin-bottom:4px;\">" + HttpUtility.HtmlEncode(contactInfo.CompanyName ?? "Beauty Story") + "</div>");
                if (!string.IsNullOrWhiteSpace(contactInfo.Address))
                {
                    bodyBuilder.AppendLine("<div>Địa chỉ: " + HttpUtility.HtmlEncode(contactInfo.Address) + "</div>");
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

    private class VariantOption
    {
        public int Id { get; set; }
        public string Label { get; set; }
        public string PriceText { get; set; }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<WardOption> GetWards(int provinceId)
    {
        if (provinceId <= 0)
        {
            return new List<WardOption>();
        }

        using (var db = new BeautyStoryContext())
        {
            return db.CfWards
                .Where(w => w.ProvinceId == provinceId)
                .OrderBy(w => w.WardName)
                .Select(w => new WardOption { Id = w.Id, Name = w.WardName })
                .ToList();
        }
    }

    public class WardOption
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

}
