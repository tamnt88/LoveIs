using System;
using System.Globalization;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminSellersDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<SellerRow> GetSellers(int draw, int start, int length, string search, int orderColumn, string orderDir,
        string keyword, string status, string hasShop, string shopStatus, string fromDate, string toDate)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = db.CfSellers.Select(s => new
            {
                s.Id,
                s.Username,
                s.Email,
                s.Phone,
                s.Status,
                s.CreatedAt,
                ShopName = db.CfShops.Where(sh => sh.SellerId == s.Id).OrderBy(sh => sh.Id).Select(sh => sh.ShopName).FirstOrDefault(),
                ShopStatus = db.CfShops.Where(sh => sh.SellerId == s.Id).OrderBy(sh => sh.Id).Select(sh => sh.Status).FirstOrDefault(),
                ShopCount = db.CfShops.Count(sh => sh.SellerId == s.Id),
                RatingCount = db.CfShops.Where(sh => sh.SellerId == s.Id).Sum(sh => (int?)sh.RatingCount) ?? 0,
                RatingSum = db.CfShops.Where(sh => sh.SellerId == s.Id).Sum(sh => (decimal?)(sh.RatingAvg * sh.RatingCount)) ?? 0m,
                TotalOrders = db.CfShopOrders.Count(so =>
                    db.CfShops.Where(sh => sh.SellerId == s.Id).Select(sh => sh.Id).Contains(so.ShopId)),
                TotalRevenue = db.CfShopOrders
                    .Where(so => db.CfShops.Where(sh => sh.SellerId == s.Id).Select(sh => sh.Id).Contains(so.ShopId))
                    .Sum(so => (decimal?)so.Total) ?? 0m
            });

            int total = query.Count();

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string term = keyword.Trim();
                query = query.Where(s =>
                    s.Username.Contains(term) ||
                    (s.Email != null && s.Email.Contains(term)) ||
                    (s.Phone != null && s.Phone.Contains(term)) ||
                    (s.ShopName != null && s.ShopName.Contains(term)));
            }

            if (status == "1")
            {
                query = query.Where(s => s.Status);
            }
            else if (status == "0")
            {
                query = query.Where(s => !s.Status);
            }

            if (hasShop == "1")
            {
                query = query.Where(s => s.ShopCount > 0);
            }
            else if (hasShop == "0")
            {
                query = query.Where(s => s.ShopCount == 0);
            }

            if (!string.IsNullOrWhiteSpace(shopStatus))
            {
                query = query.Where(s => s.ShopStatus != null && s.ShopStatus == shopStatus);
            }

            DateTime from;
            if (!string.IsNullOrWhiteSpace(fromDate) && DateTime.TryParse(fromDate, CultureInfo.InvariantCulture, DateTimeStyles.None, out from))
            {
                query = query.Where(s => s.CreatedAt >= from);
            }

            DateTime to;
            if (!string.IsNullOrWhiteSpace(toDate) && DateTime.TryParse(toDate, CultureInfo.InvariantCulture, DateTimeStyles.None, out to))
            {
                DateTime end = to.Date.AddDays(1);
                query = query.Where(s => s.CreatedAt < end);
            }

            int filtered = query.Count();

            switch (orderColumn)
            {
                case 0:
                    query = orderDir == "asc" ? query.OrderBy(s => s.Username) : query.OrderByDescending(s => s.Username);
                    break;
                case 1:
                    query = orderDir == "asc" ? query.OrderBy(s => s.ShopName) : query.OrderByDescending(s => s.ShopName);
                    break;
                case 2:
                    query = orderDir == "asc" ? query.OrderBy(s => s.Phone) : query.OrderByDescending(s => s.Phone);
                    break;
                case 3:
                    query = orderDir == "asc" ? query.OrderBy(s => s.RatingSum) : query.OrderByDescending(s => s.RatingSum);
                    break;
                case 4:
                    query = orderDir == "asc" ? query.OrderBy(s => s.TotalOrders) : query.OrderByDescending(s => s.TotalOrders);
                    break;
                case 5:
                    query = orderDir == "asc" ? query.OrderBy(s => s.TotalRevenue) : query.OrderByDescending(s => s.TotalRevenue);
                    break;
                case 8:
                    query = orderDir == "asc" ? query.OrderBy(s => s.CreatedAt) : query.OrderByDescending(s => s.CreatedAt);
                    break;
                default:
                    query = query.OrderByDescending(s => s.CreatedAt);
                    break;
            }

            var rows = query
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(s => new SellerRow
                {
                    Username = s.Username,
                    Phone = string.IsNullOrWhiteSpace(s.Phone) ? "-" : s.Phone,
                    ShopLabel = BuildShopLabel(s.ShopName, s.ShopCount),
                    RatingText = BuildRatingText(s.RatingSum, s.RatingCount),
                    TotalOrdersText = s.TotalOrders.ToString("N0"),
                    TotalRevenueText = FormatMoney(s.TotalRevenue),
                    ShopStatusHtml = BuildStatusTag(BuildShopStatusLabel(s.ShopStatus), "status-shop"),
                    StatusHtml = BuildStatusTag(s.Status ? "Đang hoạt động" : "Tạm khóa", s.Status ? "status-seller-active" : "status-seller-inactive"),
                    CreatedAt = s.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
                    ActionsHtml = BuildActions(s.Id, s.Status)
                })
                .ToList();

            return new DataTableResult<SellerRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = filtered,
                data = rows
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult ToggleSellerStatus(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == id);
            if (seller == null)
            {
                return new ActionResult { Success = false, Message = "Không tìm thấy nhà bán hàng." };
            }

            bool newStatus = !seller.Status;
            seller.Status = newStatus;
            seller.UpdatedAt = DateTime.UtcNow;
            seller.UpdatedBy = System.Web.HttpContext.Current.Session["AdminUsername"] != null
                ? System.Web.HttpContext.Current.Session["AdminUsername"].ToString()
                : null;

            var shops = db.CfShops.Where(sh => sh.SellerId == id).ToList();
            string shopStatus = newStatus ? "Active" : "Inactive";
            foreach (var shop in shops)
            {
                shop.Status = shopStatus;
                shop.UpdatedAt = DateTime.UtcNow;
                shop.UpdatedBy = seller.UpdatedBy;
            }
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "OK" };
    }

    private static string BuildActions(int id, bool status)
    {
        string label = status ? "Khóa" : "Mở";
        return string.Format("<div class=\"menu-actions menu-actions-end\"><a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/sellers/edit.aspx?id={0}\"><i class=\"fa-solid fa-eye\"></i> Xem</a>" +
            "<button type=\"button\" class=\"btn btn-sm btn-outline-secondary btn-with-icon js-toggle-seller\" data-id=\"{0}\" data-label=\"{1}\"><i class=\"fa-solid fa-user-lock\"></i> {1}</button></div>",
            id, label);
    }

    private static string BuildShopLabel(string shopName, int shopCount)
    {
        if (string.IsNullOrWhiteSpace(shopName))
        {
            return "-";
        }

        if (shopCount > 1)
        {
            return string.Format("{0} (+{1})", shopName, shopCount - 1);
        }

        return shopName;
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

    private static string BuildRatingText(decimal ratingSum, int ratingCount)
    {
        if (ratingCount <= 0)
        {
            return "-";
        }

        decimal avg = ratingSum / ratingCount;
        return string.Format("{0:0.0} ({1:N0})", avg, ratingCount);
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
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

        if (key.Contains("hoat dong") || key.Contains("active"))
        {
            return "status-success";
        }

        if (key.Contains("cho") || key.Contains("pending"))
        {
            return "status-warning";
        }

        if (key.Contains("tam") || key.Contains("khoa") || key.Contains("inactive") || key.Contains("block"))
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

    public class SellerRow
    {
        public string Username { get; set; }
        public string ShopLabel { get; set; }
        public string Phone { get; set; }
        public string RatingText { get; set; }
        public string TotalOrdersText { get; set; }
        public string TotalRevenueText { get; set; }
        public string ShopStatusHtml { get; set; }
        public string StatusHtml { get; set; }
        public string CreatedAt { get; set; }
        public string ActionsHtml { get; set; }
    }
}
