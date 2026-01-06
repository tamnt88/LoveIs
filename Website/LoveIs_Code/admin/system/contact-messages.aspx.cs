using System;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;

public partial class AdminSystemContactMessages : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ContactMessageRow> GetMessages(int draw, int start, int length, string search, int orderColumn, string orderDir)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = db.CfContactMessages.AsQueryable();

            int total = query.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim();
                query = query.Where(m =>
                    (m.FullName != null && m.FullName.Contains(keyword)) ||
                    (m.Email != null && m.Email.Contains(keyword)) ||
                    (m.Phone != null && m.Phone.Contains(keyword)) ||
                    (m.Subject != null && m.Subject.Contains(keyword)) ||
                    (m.Message != null && m.Message.Contains(keyword))
                );
            }

            int filtered = query.Count();

            query = ApplyOrdering(query, orderColumn, orderDir);

            var data = query
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(m => new ContactMessageRow
                {
                    Id = m.Id,
                    CustomerHtml = BuildCustomerHtml(m.FullName, m.Email, m.Phone),
                    Subject = HttpUtility.HtmlEncode(m.Subject ?? string.Empty),
                    MessageHtml = BuildMessageHtml(m.Message),
                    CreatedAt = m.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
                    ActionsHtml = string.Format("<button class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteContactMessage({0})\"><i class=\\\"fa-solid fa-trash\\\"></i> Xóa</button>", m.Id)
                })
                .ToList();

            return new DataTableResult<ContactMessageRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = filtered,
                data = data
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult DeleteMessage(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var message = db.CfContactMessages.FirstOrDefault(m => m.Id == id);
            if (message == null)
            {
                return new ActionResult { Success = false, Message = "Tin nhắn không tồn tại." };
            }

            db.CfContactMessages.Remove(message);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Đã xóa tin nhắn." };
    }

    private static IQueryable<CfContactMessage> ApplyOrdering(IQueryable<CfContactMessage> query, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 1:
                query = desc ? query.OrderByDescending(m => m.Subject).ThenByDescending(m => m.Id) : query.OrderBy(m => m.Subject).ThenByDescending(m => m.Id);
                break;
            case 2:
                query = desc ? query.OrderByDescending(m => m.Message).ThenByDescending(m => m.Id) : query.OrderBy(m => m.Message).ThenByDescending(m => m.Id);
                break;
            case 3:
                query = desc ? query.OrderByDescending(m => m.CreatedAt).ThenByDescending(m => m.Id) : query.OrderBy(m => m.CreatedAt).ThenByDescending(m => m.Id);
                break;
            default:
                query = desc ? query.OrderByDescending(m => m.Id) : query.OrderBy(m => m.Id);
                break;
        }
        return query;
    }

    private static string BuildCustomerHtml(string fullName, string email, string phone)
    {
        var name = HttpUtility.HtmlEncode(fullName ?? string.Empty);
        var emailValue = HttpUtility.HtmlEncode(email ?? string.Empty);
        var phoneValue = HttpUtility.HtmlEncode(phone ?? string.Empty);

        return string.Format(
            "<div class=\"fw-semibold\">{0}</div><div class=\"text-muted small\">{1}</div><div class=\"text-muted small\">{2}</div>",
            name,
            emailValue,
            phoneValue);
    }

    private static string BuildMessageHtml(string message)
    {
        var safe = HttpUtility.HtmlEncode(message ?? string.Empty);
        return string.Format("<div class=\"text-muted small\" style=\"max-width:360px; white-space:normal;\">{0}</div>", safe);
    }

    public class ContactMessageRow
    {
        public int Id { get; set; }
        public string CustomerHtml { get; set; }
        public string Subject { get; set; }
        public string MessageHtml { get; set; }
        public string CreatedAt { get; set; }
        public string ActionsHtml { get; set; }
    }
}
