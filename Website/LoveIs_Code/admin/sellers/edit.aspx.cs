using System;
using System.Globalization;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminSellersEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int sellerId;
            if (!int.TryParse(Request.QueryString["id"], out sellerId))
            {
                Response.Redirect("/admin/sellers/default.aspx");
                return;
            }

            SellerId.Value = sellerId.ToString();
            LoadSeller(sellerId);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";

        int sellerId;
        if (!int.TryParse(SellerId.Value, out sellerId))
        {
            FormMessage.Text = "Không tìm thấy nhà bán hàng.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId);
            if (seller == null)
            {
                FormMessage.Text = "Không tìm thấy nhà bán hàng.";
                return;
            }

            seller.DisplayName = string.IsNullOrWhiteSpace(DisplayNameInput.Text) ? null : DisplayNameInput.Text.Trim();
            seller.Email = string.IsNullOrWhiteSpace(EmailInput.Text) ? null : EmailInput.Text.Trim();
            seller.Phone = string.IsNullOrWhiteSpace(PhoneInput.Text) ? null : PhoneInput.Text.Trim();
            seller.Status = StatusInput.Checked;
            seller.UpdatedAt = DateTime.UtcNow;
            seller.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            db.SaveChanges();
        }

        LoadSeller(sellerId);
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Cập nhật thành công.";
    }

    protected void ChangePasswordButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";

        int sellerId;
        if (!int.TryParse(SellerId.Value, out sellerId))
        {
            FormMessage.Text = "Không tìm thấy nhà bán hàng.";
            return;
        }

        string newPassword = NewPasswordInput.Text;
        string confirmPassword = ConfirmPasswordInput.Text;

        if (string.IsNullOrWhiteSpace(newPassword) || string.IsNullOrWhiteSpace(confirmPassword))
        {
            FormMessage.Text = "Vui lòng nhập đầy đủ mật khẩu mới.";
            return;
        }

        if (newPassword != confirmPassword)
        {
            FormMessage.Text = "Xác nhận mật khẩu không khớp.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId);
            if (seller == null)
            {
                FormMessage.Text = "Không tìm thấy nhà bán hàng.";
                return;
            }

            int iterations = 10000;
            byte[] salt;
            byte[] hash;
            Pbkdf2Hasher.Create(newPassword, iterations, out salt, out hash);

            seller.PasswordSalt = salt;
            seller.PasswordHash = hash;
            seller.PasswordIterations = iterations;
            seller.PasswordChangedAt = DateTime.UtcNow;
            seller.UpdatedAt = DateTime.UtcNow;
            seller.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            db.SaveChanges();
        }

        NewPasswordInput.Text = string.Empty;
        ConfirmPasswordInput.Text = string.Empty;
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Đổi mật khẩu thành công.";
    }

    private void LoadSeller(int sellerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId);
            if (seller == null)
            {
                Response.Redirect("/admin/sellers/default.aspx");
                return;
            }

            SellerIdInput.Text = seller.Id.ToString();
            UsernameInput.Text = seller.Username;
            DisplayNameInput.Text = seller.DisplayName ?? string.Empty;
            EmailInput.Text = seller.Email ?? string.Empty;
            PhoneInput.Text = seller.Phone ?? string.Empty;
            StatusInput.Checked = seller.Status;
            CreatedAtInput.Text = FormatDateTime(seller.CreatedAt);
            LastLoginInput.Text = seller.LastLoginAt.HasValue ? FormatDateTime(seller.LastLoginAt.Value) : "-";
            LockedUntilInput.Text = seller.LockedUntil.HasValue ? FormatDateTime(seller.LockedUntil.Value) : "-";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ShopRow> GetSellerShops(int draw, int start, int length, int sellerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = db.CfShops.Where(s => s.SellerId == sellerId);
            int total = query.Count();

            var rows = query
                .OrderByDescending(s => s.CreatedAt)
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(s => new ShopRow
                {
                    ShopName = s.ShopName,
                    StatusHtml = BuildStatusTag(BuildShopStatusLabel(s.Status), "status-shop"),
                    RatingText = BuildRatingText(s.RatingAvg, s.RatingCount),
                    CompletedOrders = s.CompletedOrders.ToString("N0"),
                    FollowerCount = s.FollowerCount.ToString("N0"),
                    CreatedAt = FormatDateTime(s.CreatedAt)
                })
                .ToList();

            return new DataTableResult<ShopRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ProductRow> GetSellerProducts(int draw, int start, int length, int sellerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops.Where(sh => sh.SellerId == sellerId).Select(sh => sh.Id).ToList();
            if (shopIds.Count == 0)
            {
                return new DataTableResult<ProductRow>
                {
                    draw = draw,
                    recordsTotal = 0,
                    recordsFiltered = 0,
                    data = new System.Collections.Generic.List<ProductRow>()
                };
            }

            var query = from p in db.CfProducts
                        join sh in db.CfShops on p.ShopId equals sh.Id
                        where p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value)
                        select new
                        {
                            p.Id,
                            p.ProductName,
                            ShopName = sh.ShopName,
                            p.RatingAvg,
                            p.RatingCount,
                            p.StockTotal,
                            p.Status,
                            p.CreatedAt
                        };

            int total = query.Count();

            var rows = query
                .OrderByDescending(p => p.CreatedAt)
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(p => new ProductRow
                {
                    ProductName = p.ProductName,
                    ShopName = p.ShopName,
                    RatingText = BuildRatingText(p.RatingAvg, p.RatingCount),
                    StockText = p.StockTotal.ToString("N0"),
                    StatusHtml = BuildStatusTag(p.Status ? "Đang bán" : "Tạm ẩn", p.Status ? "status-success" : "status-danger"),
                    CreatedAt = FormatDateTime(p.CreatedAt),
                    ActionsHtml = string.Format("<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/edit.aspx?id={0}\"><i class=\"fa-solid fa-eye\"></i> Xem</a>", p.Id)
                })
                .ToList();

            return new DataTableResult<ProductRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<OrderRow> GetSellerOrders(int draw, int start, int length, int sellerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = from so in db.CfShopOrders
                        join sh in db.CfShops on so.ShopId equals sh.Id
                        join o in db.CfOrders on so.OrderId equals o.Id
                        where sh.SellerId == sellerId
                        select new
                        {
                            so.OrderId,
                            o.OrderCode,
                            ShopName = sh.ShopName,
                            so.OrderStatus,
                            so.PaymentStatus,
                            so.Total,
                            so.CreatedAt
                        };

            int total = query.Count();

            var rows = query
                .OrderByDescending(o => o.CreatedAt)
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(o => new OrderRow
                {
                    OrderCode = o.OrderCode,
                    ShopName = o.ShopName,
                    OrderStatusHtml = BuildStatusTag(string.IsNullOrWhiteSpace(o.OrderStatus) ? "Đang xử lý" : o.OrderStatus, string.Empty),
                    PaymentStatusHtml = BuildStatusTag(string.IsNullOrWhiteSpace(o.PaymentStatus) ? "Chưa thanh toán" : o.PaymentStatus, string.Empty),
                    TotalText = FormatMoney(o.Total),
                    CreatedAt = FormatDateTime(o.CreatedAt),
                    ActionsHtml = string.Format("<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/orders/edit.aspx?id={0}\"><i class=\"fa-solid fa-eye\"></i> Xem</a>", o.OrderId)
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

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ReviewRow> GetSellerReviews(int draw, int start, int length, int sellerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = from r in db.CfShopReviews
                        join sh in db.CfShops on r.ShopId equals sh.Id
                        join c in db.CfCustomers on r.CustomerId equals c.Id into customers
                        from c in customers.DefaultIfEmpty()
                        where sh.SellerId == sellerId
                        select new
                        {
                            ShopName = sh.ShopName,
                            r.Rating,
                            r.Content,
                            CustomerName = c != null ? (c.DisplayName ?? c.Username) : null,
                            r.CreatedAt
                        };

            int total = query.Count();

            var rows = query
                .OrderByDescending(r => r.CreatedAt)
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(r => new ReviewRow
                {
                    ShopName = r.ShopName,
                    RatingText = r.Rating.ToString("0"),
                    Content = string.IsNullOrWhiteSpace(r.Content) ? "-" : r.Content,
                    CustomerName = string.IsNullOrWhiteSpace(r.CustomerName) ? "-" : r.CustomerName,
                    CreatedAt = FormatDateTime(r.CreatedAt)
                })
                .ToList();

            return new DataTableResult<ReviewRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = total,
                data = rows
            };
        }
    }

    private static string BuildRatingText(decimal ratingAvg, int ratingCount)
    {
        if (ratingCount <= 0)
        {
            return "-";
        }

        return string.Format("{0:0.0} ({1:N0})", ratingAvg, ratingCount);
    }

    private static string BuildShopStatusLabel(string status)
    {
        if (string.IsNullOrWhiteSpace(status))
        {
            return "-";
        }

        var key = status.Trim().ToLowerInvariant();
        if (key == "active")
        {
            return "Hoạt động";
        }

        if (key == "pending")
        {
            return "Chờ duyệt";
        }

        if (key == "inactive")
        {
            return "Tạm dừng";
        }

        return status;
    }

    private static string BuildStatusTag(string label, string extraClass)
    {
        string cssClass = GetStatusCssClass(label);
        string combined = string.IsNullOrWhiteSpace(extraClass) ? cssClass : string.Format("{0} {1}", cssClass, extraClass);
        return string.Format("<span class=\"status-tag {0}\">{1}</span>", combined, label);
    }

    private static string GetStatusCssClass(string label)
    {
        if (string.IsNullOrWhiteSpace(label) || label == "-")
        {
            return "status-neutral";
        }

        string key = RemoveDiacritics(label).ToLowerInvariant();

        if (key.Contains("hoat dong") || key.Contains("active") || key.Contains("thanh cong"))
        {
            return "status-success";
        }

        if (key.Contains("cho") || key.Contains("pending") || key.Contains("dang") || key.Contains("moi"))
        {
            return "status-warning";
        }

        if (key.Contains("tam") || key.Contains("khoa") || key.Contains("inactive") || key.Contains("huy"))
        {
            return "status-danger";
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

    private static string FormatDateTime(DateTime value)
    {
        return value.ToString("dd/MM/yyyy HH:mm");
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    public class ShopRow
    {
        public string ShopName { get; set; }
        public string StatusHtml { get; set; }
        public string RatingText { get; set; }
        public string CompletedOrders { get; set; }
        public string FollowerCount { get; set; }
        public string CreatedAt { get; set; }
    }

    public class ProductRow
    {
        public string ProductName { get; set; }
        public string ShopName { get; set; }
        public string RatingText { get; set; }
        public string StockText { get; set; }
        public string StatusHtml { get; set; }
        public string CreatedAt { get; set; }
        public string ActionsHtml { get; set; }
    }

    public class OrderRow
    {
        public string OrderCode { get; set; }
        public string ShopName { get; set; }
        public string OrderStatusHtml { get; set; }
        public string PaymentStatusHtml { get; set; }
        public string TotalText { get; set; }
        public string CreatedAt { get; set; }
        public string ActionsHtml { get; set; }
    }

    public class ReviewRow
    {
        public string ShopName { get; set; }
        public string RatingText { get; set; }
        public string Content { get; set; }
        public string CustomerName { get; set; }
        public string CreatedAt { get; set; }
    }
}
