using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

public partial class AdminCustomersEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int customerId;
            if (!int.TryParse(Request.QueryString["id"], out customerId))
            {
                Response.Redirect("/admin/customers/default.aspx");
                return;
            }

            CustomerId.Value = customerId.ToString();
            LoadCustomer(customerId);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        int customerId;
        if (!int.TryParse(CustomerId.Value, out customerId))
        {
            FormMessage.Text = "Không tìm thấy khách hàng.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId);
            if (customer == null)
            {
                FormMessage.Text = "Không tìm thấy khách hàng.";
                return;
            }

            customer.DisplayName = string.IsNullOrWhiteSpace(DisplayNameInput.Text) ? null : DisplayNameInput.Text.Trim();
            customer.Email = string.IsNullOrWhiteSpace(EmailInput.Text) ? null : EmailInput.Text.Trim();
            customer.Phone = string.IsNullOrWhiteSpace(PhoneInput.Text) ? null : PhoneInput.Text.Trim();

            int gender;
            if (int.TryParse(GenderInput.SelectedValue, out gender))
            {
                customer.Gender = gender;
            }
            else
            {
                customer.Gender = null;
            }

            DateTime birthDate;
            if (!string.IsNullOrWhiteSpace(BirthDateInput.Text) && DateTime.TryParse(BirthDateInput.Text, out birthDate))
            {
                customer.BirthDate = birthDate;
            }
            else
            {
                customer.BirthDate = null;
            }

            customer.Status = StatusInput.Checked;
            customer.EmailVerified = EmailVerifiedInput.Checked;
            customer.IsSeller = IsSellerInput.Checked;
            customer.UpdatedAt = DateTime.UtcNow;
            customer.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            db.SaveChanges();
        }

        LoadCustomer(customerId);
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Cập nhật thành công.";
    }

    protected void ChangePasswordButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        int customerId;
        if (!int.TryParse(CustomerId.Value, out customerId))
        {
            FormMessage.Text = "Không tìm thấy khách hàng.";
            return;
        }

        string newPassword = NewPasswordInput.Text ?? string.Empty;
        string confirmPassword = ConfirmPasswordInput.Text ?? string.Empty;

        if (string.IsNullOrWhiteSpace(newPassword))
        {
            FormMessage.Text = "Vui lòng nhập mật khẩu mới.";
            return;
        }

        if (newPassword.Length < 6)
        {
            FormMessage.Text = "Mật khẩu phải có ít nhất 6 ký tự.";
            return;
        }

        if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
        {
            FormMessage.Text = "Xác nhận mật khẩu không khớp.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId);
            if (customer == null)
            {
                FormMessage.Text = "Không tìm thấy khách hàng.";
                return;
            }

            byte[] salt;
            byte[] hash;
            int iterations = 100000;
            Pbkdf2Hasher.Create(newPassword, iterations, out salt, out hash);
            customer.PasswordSalt = salt;
            customer.PasswordHash = hash;
            customer.PasswordIterations = iterations;
            customer.UpdatedAt = DateTime.UtcNow;
            customer.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        NewPasswordInput.Text = string.Empty;
        ConfirmPasswordInput.Text = string.Empty;
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Đổi mật khẩu thành công.";
    }

    private void LoadCustomer(int customerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId);
            if (customer == null)
            {
                Response.Redirect("/admin/customers/default.aspx");
                return;
            }

            CustomerIdInput.Text = customer.Id.ToString();
            SellerIdInput.Text = customer.SellerId.HasValue ? customer.SellerId.Value.ToString() : "-";
            UsernameInput.Text = customer.Username;
            DisplayNameInput.Text = customer.DisplayName ?? string.Empty;
            EmailInput.Text = customer.Email ?? string.Empty;
            PhoneInput.Text = customer.Phone ?? string.Empty;
            EmailVerifyTokenInput.Text = string.IsNullOrWhiteSpace(customer.EmailVerifyToken) ? "-" : customer.EmailVerifyToken;
            EmailVerifyExpiresInput.Text = customer.EmailVerifyExpiresAt.HasValue ? FormatDateTime(customer.EmailVerifyExpiresAt.Value) : "-";

            string genderValue = customer.Gender.HasValue ? customer.Gender.Value.ToString() : string.Empty;
            var genderItem = GenderInput.Items.FindByValue(genderValue);
            GenderInput.ClearSelection();
            if (genderItem != null)
            {
                genderItem.Selected = true;
            }

            BirthDateInput.Text = customer.BirthDate.HasValue ? customer.BirthDate.Value.ToString("yyyy-MM-dd") : string.Empty;
            StatusInput.Checked = customer.Status;
            EmailVerifiedInput.Checked = customer.EmailVerified;
            IsSellerInput.Checked = customer.IsSeller;
            CreatedAtInput.Text = FormatDateTime(customer.CreatedAt);
            LastLoginInput.Text = customer.LastLoginAt.HasValue ? FormatDateTime(customer.LastLoginAt.Value) : "-";
            LockedUntilInput.Text = customer.LockedUntil.HasValue ? FormatDateTime(customer.LockedUntil.Value) : "-";
        }
    }

    [System.Web.Services.WebMethod]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public static DataTableResult<AddressRow> GetCustomerAddresses(int draw, int start, int length, int customerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = db.CfCustomerAddresses.Where(a => a.CustomerId == customerId);
            int total = query.Count();

            var rows = query
                .OrderByDescending(a => a.IsDefault)
                .ThenByDescending(a => a.CreatedAt)
                .Skip(start).Take(length)
                .Select(a => new
                {
                    a.FullName,
                    a.Phone,
                    a.AddressLine,
                    a.WardName,
                    a.ProvinceName,
                    a.IsDefault
                })
                .ToList()
                .Select(a => new AddressRow
                {
                    FullName = string.IsNullOrWhiteSpace(a.FullName) ? "-" : a.FullName,
                    Phone = string.IsNullOrWhiteSpace(a.Phone) ? "-" : a.Phone,
                    AddressText = BuildAddress(a.AddressLine, a.WardName, a.ProvinceName),
                    IsDefaultText = a.IsDefault ? "Có" : "Không"
                })
                .ToList();

            return new DataTableResult<AddressRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    [System.Web.Services.WebMethod]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public static DataTableResult<BankRow> GetCustomerBanks(int draw, int start, int length, int customerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = db.CfCustomerBanks.Where(b => b.CustomerId == customerId);
            int total = query.Count();

            var rows = query
                .OrderByDescending(b => b.IsDefault)
                .ThenByDescending(b => b.CreatedAt)
                .Skip(start).Take(length)
                .Select(b => new
                {
                    b.BankName,
                    b.AccountName,
                    b.AccountNumber,
                    b.Branch,
                    b.IsDefault
                })
                .ToList()
                .Select(b => new BankRow
                {
                    BankName = string.IsNullOrWhiteSpace(b.BankName) ? "-" : b.BankName,
                    AccountName = string.IsNullOrWhiteSpace(b.AccountName) ? "-" : b.AccountName,
                    AccountNumber = string.IsNullOrWhiteSpace(b.AccountNumber) ? "-" : b.AccountNumber,
                    Branch = string.IsNullOrWhiteSpace(b.Branch) ? "-" : b.Branch,
                    IsDefaultText = b.IsDefault ? "Có" : "Không"
                })
                .ToList();

            return new DataTableResult<BankRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    [System.Web.Services.WebMethod]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public static DataTableResult<WishlistRow> GetCustomerWishlist(int draw, int start, int length, int customerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = from w in db.CfWishlists
                        join p in db.CfProducts on w.ProductId equals p.Id
                        join c in db.CfCategories on p.CategoryId equals c.Id
                        join b in db.CfBrands on p.BrandId equals b.Id into bjoin
                        from b in bjoin.DefaultIfEmpty()
                        join o in db.CfOrigins on p.OriginId equals o.Id into ojoin
                        from o in ojoin.DefaultIfEmpty()
                        join s in db.CfShops on p.ShopId equals s.Id into sjoin
                        from s in sjoin.DefaultIfEmpty()
                        where w.CustomerId == customerId && w.Status
                        select new
                        {
                            Wishlist = w,
                            Product = p,
                            CategoryName = c.CategoryName,
                            BrandName = b != null ? b.BrandName : null,
                            OriginName = o != null ? o.OriginName : null,
                            ShopName = s != null ? s.ShopName : null
                        };

            int total = query.Count();

            var pageItems = query
                .OrderByDescending(x => x.Wishlist.CreatedAt)
                .Skip(start)
                .Take(length)
                .ToList();

            var productIds = pageItems.Select(x => x.Product.Id).Distinct().ToList();

            var variantPrices = db.CfProductVariants
                .Where(v => v.Status && productIds.Contains(v.ProductId) && (v.Price > 0 || (v.SalePrice.HasValue && v.SalePrice.Value > 0)))
                .GroupBy(v => v.ProductId)
                .Select(g => new
                {
                    ProductId = g.Key,
                    MinPrice = g.Min(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 ? v.SalePrice.Value : v.Price),
                    StockQty = g.Sum(v => v.StockQty)
                })
                .ToList();
            var priceLookup = variantPrices.ToDictionary(v => v.ProductId, v => v.MinPrice);
            var stockLookup = variantPrices.ToDictionary(v => v.ProductId, v => v.StockQty);

            var skuLookup = db.CfProductVariants
                .Where(v => v.Status && productIds.Contains(v.ProductId))
                .GroupBy(v => v.ProductId)
                .Select(g => new
                {
                    ProductId = g.Key,
                    Sku = g.OrderBy(v => v.Id).Select(v => v.Sku).FirstOrDefault()
                })
                .ToList()
                .ToDictionary(v => v.ProductId, v => v.Sku);

            var imageLookup = db.CfProductImages
                .Where(i => i.Status && productIds.Contains(i.ProductId))
                .GroupBy(i => i.ProductId)
                .Select(g => new
                {
                    ProductId = g.Key,
                    ImageUrl = g.OrderByDescending(i => i.IsPrimary).ThenBy(i => i.SortOrder).Select(i => i.ImageUrl).FirstOrDefault()
                })
                .ToDictionary(i => i.ProductId, i => i.ImageUrl);

            var rows = pageItems.Select(item =>
            {
                var product = item.Product;
                string imageUrl = imageLookup.ContainsKey(product.Id) ? imageLookup[product.Id] : "/images/logo_doc.png";
                var sku = skuLookup.ContainsKey(product.Id) ? skuLookup[product.Id] : "-";
                decimal price = priceLookup.ContainsKey(product.Id) ? priceLookup[product.Id] : 0;
                int stock = stockLookup.ContainsKey(product.Id) ? stockLookup[product.Id] : 0;

                return new WishlistRow
                {
                    ProductId = product.Id,
                    ImageHtml = string.Format("<img src=\"{0}\" alt=\"{1}\" class=\"table-thumb\" />", imageUrl, product.ProductName),
                    ProductName = product.ProductName,
                    Sku = sku,
                    CategoryName = FormatTag(item.CategoryName ?? "-", "info-tag-blue"),
                    ShopName = FormatTag(item.ShopName ?? "-", "info-tag-rose"),
                    BrandName = FormatTag(item.BrandName ?? "-", "info-tag-olive"),
                    OriginName = FormatTag(item.OriginName ?? "-", "info-tag-sand"),
                    MinPrice = price > 0 ? string.Format(new CultureInfo("vi-VN"), "{0:C0}", price) : "-",
                    StockQty = stock,
                    CreatedAt = FormatDateTime(item.Wishlist.CreatedAt),
                    ActionsHtml = BuildProductAction(product.Id)
                };
            }).ToList();

            return new DataTableResult<WishlistRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    [System.Web.Services.WebMethod]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public static DataTableResult<OrderRow> GetCustomerOrders(int draw, int start, int length, int customerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = db.CfOrders.Where(o => o.CustomerId == customerId);
            int total = query.Count();

            var rows = query
                .OrderByDescending(o => o.CreatedAt)
                .Skip(start).Take(length)
                .Select(o => new
                {
                    o.Id,
                    o.OrderCode,
                    o.CreatedAt,
                    o.PaymentStatus,
                    o.OrderStatus,
                    o.ShippingMethod,
                    o.ShippingEta,
                    o.Total
                })
                .ToList()
                .Select(o => new OrderRow
                {
                    OrderId = o.Id,
                    OrderCode = o.OrderCode,
                    CreatedAt = FormatDateTime(o.CreatedAt),
                    PaymentStatusHtml = BuildStatusTag(string.IsNullOrWhiteSpace(o.PaymentStatus) ? "Chưa thanh toán" : o.PaymentStatus),
                    ShippingStatusHtml = BuildStatusTag(BuildShippingStatusLabel(o.ShippingMethod, o.ShippingEta)),
                    OrderStatusHtml = BuildStatusTag(string.IsNullOrWhiteSpace(o.OrderStatus) ? "-" : o.OrderStatus),
                    TotalText = FormatMoney(o.Total),
                    ActionsHtml = BuildOrderAction(o.Id)
                })
                .ToList();

            return new DataTableResult<OrderRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    private static string BuildAddress(string line, string ward, string province)
    {
        var parts = new List<string>();
        if (!string.IsNullOrWhiteSpace(line))
            parts.Add(line);
        if (!string.IsNullOrWhiteSpace(ward))
            parts.Add(ward);
        if (!string.IsNullOrWhiteSpace(province))
            parts.Add(province);
        return parts.Count == 0 ? "-" : string.Join(", ", parts);
    }

    private static string FormatDateTime(DateTime value)
    {
        return value.ToString("dd/MM/yyyy HH:mm");
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    public class AddressRow
    {
        public string FullName { get; set; }
        public string Phone { get; set; }
        public string AddressText { get; set; }
        public string IsDefaultText { get; set; }
    }

    public class BankRow
    {
        public string BankName { get; set; }
        public string AccountName { get; set; }
        public string AccountNumber { get; set; }
        public string Branch { get; set; }
        public string IsDefaultText { get; set; }
    }

    public class WishlistRow
    {
        public int ProductId { get; set; }
        public string ImageHtml { get; set; }
        public string ProductName { get; set; }
        public string Sku { get; set; }
        public string CategoryName { get; set; }
        public string ShopName { get; set; }
        public string BrandName { get; set; }
        public string OriginName { get; set; }
        public string MinPrice { get; set; }
        public int StockQty { get; set; }
        public string CreatedAt { get; set; }
        public string ActionsHtml { get; set; }
    }

    public class OrderRow
    {
        public int OrderId { get; set; }
        public string OrderCode { get; set; }
        public string CreatedAt { get; set; }
        public string PaymentStatusHtml { get; set; }
        public string ShippingStatusHtml { get; set; }
        public string OrderStatusHtml { get; set; }
        public string TotalText { get; set; }
        public string ActionsHtml { get; set; }
    }

    private static string BuildStatusTag(string label)
    {
        string cssClass = GetStatusCssClass(label);
        return string.Format("<span class=\"status-tag {0}\">{1}</span>", cssClass, label);
    }

    private static string GetStatusCssClass(string label)
    {
        if (string.IsNullOrWhiteSpace(label))
        {
            return "status-neutral";
        }

        string key = RemoveDiacritics(label).ToLowerInvariant();

        if (key.Contains("da thanh toan") || key.Contains("hoan tat") || key.Contains("thanh cong") || key.Contains("hoan thanh"))
        {
            return "status-success";
        }

        if (key.Contains("chua thanh toan") || key.Contains("cho") || key.Contains("dang xu ly") || key.Contains("dang"))
        {
            return "status-warning";
        }

        if (key.Contains("huy") || key.Contains("tu choi") || key.Contains("that bai") || key.Contains("hoan tien"))
        {
            return "status-danger";
        }

        if (key.Contains("xac nhan") || key.Contains("dat hang") || key.Contains("moi"))
        {
            return "status-info";
        }

        return "status-neutral";
    }

    private static string RemoveDiacritics(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        var normalized = value.Normalize(System.Text.NormalizationForm.FormD);
        var builder = new System.Text.StringBuilder();
        foreach (var ch in normalized)
        {
            var category = CharUnicodeInfo.GetUnicodeCategory(ch);
            if (category != UnicodeCategory.NonSpacingMark)
            {
                builder.Append(ch);
            }
        }

        return builder.ToString().Normalize(System.Text.NormalizationForm.FormC);
    }

    private static string BuildProductAction(int productId)
    {
        return string.Format("<div class=\"menu-actions\"><a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/edit.aspx?id={0}\"><i class=\"fa-solid fa-eye\"></i> Xem</a></div>", productId);
    }

    private static string BuildOrderAction(int orderId)
    {
        return string.Format("<div class=\"menu-actions\"><a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/orders/edit.aspx?id={0}\"><i class=\"fa-solid fa-eye\"></i> Xem</a></div>", orderId);
    }

    private static string BuildShippingStatusLabel(string method, string eta)
    {
        if (!string.IsNullOrWhiteSpace(eta))
        {
            return eta;
        }

        if (!string.IsNullOrWhiteSpace(method))
        {
            return method;
        }

        return "Chưa giao";
    }

    private static string FormatTag(string value, string className)
    {
        if (string.IsNullOrWhiteSpace(value) || value == "-")
        {
            return "-";
        }

        return string.Format("<span class=\"info-tag {0}\">{1}</span>", className, value);
    }
}
