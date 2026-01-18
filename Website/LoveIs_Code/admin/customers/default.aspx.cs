using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Services;
using System.Web.Script.Services;

public partial class AdminCustomersDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<CustomerRow> GetCustomers(int draw, int start, int length, string search, int orderColumn, string orderDir,
        string keyword, string status, string isSeller, string emailVerified, string fromDate, string toDate)
    {
        using (var db = new BeautyStoryContext())
        {
            var baseQuery = db.CfCustomers.AsQueryable();
            int total = baseQuery.Count();

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string term = keyword.Trim();
                baseQuery = baseQuery.Where(c =>
                    c.Username.Contains(term) ||
                    (c.DisplayName != null && c.DisplayName.Contains(term)) ||
                    (c.Email != null && c.Email.Contains(term)) ||
                    (c.Phone != null && c.Phone.Contains(term)));
            }

            if (status == "1")
            {
                baseQuery = baseQuery.Where(c => c.Status);
            }
            else if (status == "0")
            {
                baseQuery = baseQuery.Where(c => !c.Status);
            }

            if (isSeller == "1")
            {
                baseQuery = baseQuery.Where(c => c.IsSeller);
            }
            else if (isSeller == "0")
            {
                baseQuery = baseQuery.Where(c => !c.IsSeller);
            }

            if (emailVerified == "1")
            {
                baseQuery = baseQuery.Where(c => c.EmailVerified);
            }
            else if (emailVerified == "0")
            {
                baseQuery = baseQuery.Where(c => !c.EmailVerified);
            }

            DateTime from;
            if (!string.IsNullOrWhiteSpace(fromDate) && DateTime.TryParse(fromDate, CultureInfo.InvariantCulture, DateTimeStyles.None, out from))
            {
                baseQuery = baseQuery.Where(c => c.CreatedAt >= from);
            }

            DateTime to;
            if (!string.IsNullOrWhiteSpace(toDate) && DateTime.TryParse(toDate, CultureInfo.InvariantCulture, DateTimeStyles.None, out to))
            {
                DateTime end = to.Date.AddDays(1);
                baseQuery = baseQuery.Where(c => c.CreatedAt < end);
            }

            int filtered = baseQuery.Count();

            switch (orderColumn)
            {
                case 0:
                    baseQuery = orderDir == "asc" ? baseQuery.OrderBy(c => c.Username) : baseQuery.OrderByDescending(c => c.Username);
                    break;
                case 1:
                    baseQuery = orderDir == "asc" ? baseQuery.OrderBy(c => c.DisplayName) : baseQuery.OrderByDescending(c => c.DisplayName);
                    break;
                case 2:
                    baseQuery = orderDir == "asc" ? baseQuery.OrderBy(c => c.Email) : baseQuery.OrderByDescending(c => c.Email);
                    break;
                case 3:
                    baseQuery = orderDir == "asc" ? baseQuery.OrderBy(c => c.Phone) : baseQuery.OrderByDescending(c => c.Phone);
                    break;
                case 7:
                    baseQuery = orderDir == "asc" ? baseQuery.OrderBy(c => c.CreatedAt) : baseQuery.OrderByDescending(c => c.CreatedAt);
                    break;
                default:
                    baseQuery = baseQuery.OrderByDescending(c => c.CreatedAt);
                    break;
            }

            var rows = baseQuery
                .Skip(start).Take(length)
                .Select(c => new
                {
                    c.Id,
                    c.Username,
                    c.DisplayName,
                    c.Email,
                    c.Phone,
                    c.IsSeller,
                    c.Status,
                    c.EmailVerified,
                    c.CreatedAt
                })
                .ToList()
                .Select(c => new CustomerRow
                {
                    Username = c.Username,
                    DisplayName = string.IsNullOrWhiteSpace(c.DisplayName) ? "-" : c.DisplayName,
                    Email = string.IsNullOrWhiteSpace(c.Email) ? "-" : c.Email,
                    Phone = string.IsNullOrWhiteSpace(c.Phone) ? "-" : c.Phone,
                    IsSellerText = c.IsSeller ? "Có" : "Không",
                    EmailVerifiedHtml = BuildTag(c.EmailVerified ? "Đã xác minh" : "Chưa xác minh", c.EmailVerified ? "status-on" : "status-off"),
                    StatusHtml = BuildTag(c.Status ? "Đang hoạt động" : "Tạm khóa", c.Status ? "status-on" : "status-off"),
                    CreatedAt = FormatDateTime(c.CreatedAt),
                    ActionsHtml = BuildActions(c.Id, c.Status)
                })
                .ToList();

            return new DataTableResult<CustomerRow>
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
    public static ActionResult ToggleCustomerStatus(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == id);
            if (customer == null)
            {
                return new ActionResult { Success = false, Message = "Không tìm thấy khách hàng." };
            }

            customer.Status = !customer.Status;
            customer.UpdatedAt = DateTime.UtcNow;
            customer.UpdatedBy = System.Web.HttpContext.Current.Session["AdminUsername"] != null
                ? System.Web.HttpContext.Current.Session["AdminUsername"].ToString()
                : null;
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "OK" };
    }

    private static string BuildTag(string label, string cssClass)
    {
        return string.Format("<span class=\"status-tag {0}\">{1}</span>", cssClass, label);
    }

    private static string BuildActions(int id, bool status)
    {
        string label = status ? "Khóa" : "Mở";
        return string.Format("<div class=\"menu-actions menu-actions-end\"><a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/customers/edit.aspx?id={0}\"><i class=\"fa-solid fa-eye\"></i> Xem</a>" +
            "<button type=\"button\" class=\"btn btn-sm btn-outline-secondary btn-with-icon js-toggle-customer\" data-id=\"{0}\" data-label=\"{1}\"><i class=\"fa-solid fa-user-lock\"></i> {1}</button></div>",
            id, label);
    }

    private static string FormatDateTime(DateTime value)
    {
        return value.ToString("dd/MM/yyyy HH:mm");
    }

    public class CustomerRow
    {
        public string Username { get; set; }
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string IsSellerText { get; set; }
        public string EmailVerifiedHtml { get; set; }
        public string StatusHtml { get; set; }
        public string CreatedAt { get; set; }
        public string ActionsHtml { get; set; }
    }
}
