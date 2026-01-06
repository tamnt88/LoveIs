using System;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;

public partial class AdminCmsPagesDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<StaticPageRow> GetPages(int draw, int start, int length, string search, int orderColumn, string orderDir, string keyword, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            int total = db.CfStaticPages.Count();
            var slugQuery = db.CfSeoSlugs.Where(s => s.EntityType == "StaticPage");
            var query = from page in db.CfStaticPages
                        join slug in slugQuery on page.Id equals slug.EntityId into slugGroup
                        from slug in slugGroup.DefaultIfEmpty()
                        select new StaticPageQuery
                        {
                            Page = page,
                            SeoSlug = slug.SeoSlug
                        };

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                var term = keyword.Trim();
                query = query.Where(p =>
                    (p.Page.PageName != null && p.Page.PageName.Contains(term)) ||
                    (p.SeoSlug != null && p.SeoSlug.Contains(term)));
            }

            int statusValue;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusValue))
            {
                bool isActive = statusValue == 1;
                query = query.Where(p => p.Page.Status == isActive);
            }

            int filtered = query.Count();

            query = ApplyOrdering(query, orderColumn, orderDir);

            var data = query
                .Skip(start)
                .Take(length)
                .ToList()
                .Select(p => new StaticPageRow
                {
                    Id = p.Page.Id,
                    PageName = HttpUtility.HtmlEncode(p.Page.PageName),
                    SeoSlug = BuildSlugDisplay(p.SeoSlug),
                    SortOrder = p.Page.SortOrder,
                    StatusHtml = string.Format(
                        "<span class=\"status-tag {0}\">{1}</span>",
                        p.Page.Status ? "status-on" : "status-off",
                        p.Page.Status ? "Hiển thị" : "Ẩn"),
                    ActionsHtml = string.Format(
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/cms/pages/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a> " +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteStaticPage({0})\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>",
                        p.Page.Id)
                })
                .ToList();

            return new DataTableResult<StaticPageRow>
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
    public static ActionResult DeletePage(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var page = db.CfStaticPages.FirstOrDefault(p => p.Id == id);
            if (page == null)
            {
                return new ActionResult { Success = false, Message = "Trang không tồn tại." };
            }

            bool usedBySystemPage = db.CfSystemPages.Any(p => p.StaticPageId == id);
            if (usedBySystemPage)
            {
                return new ActionResult { Success = false, Message = "Trang đang được gán cho trang hệ thống." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "StaticPage" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfStaticPages.Remove(page);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Đã xóa trang." };
    }

    private static IOrderedQueryable<StaticPageQuery> ApplyOrdering(IQueryable<StaticPageQuery> query, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 1:
                return desc ? query.OrderByDescending(p => p.SeoSlug) : query.OrderBy(p => p.SeoSlug);
            case 2:
                return desc ? query.OrderByDescending(p => p.Page.SortOrder) : query.OrderBy(p => p.Page.SortOrder);
            default:
                return desc ? query.OrderByDescending(p => p.Page.PageName) : query.OrderBy(p => p.Page.PageName);
        }
    }

    private class StaticPageQuery
    {
        public CfStaticPage Page { get; set; }
        public string SeoSlug { get; set; }
    }

    public class StaticPageRow
    {
        public int Id { get; set; }
        public string PageName { get; set; }
        public string SeoSlug { get; set; }
        public int SortOrder { get; set; }
        public string StatusHtml { get; set; }
        public string ActionsHtml { get; set; }
    }

    private static string BuildSlugDisplay(string slug)
    {
        if (string.IsNullOrWhiteSpace(slug))
        {
            return string.Empty;
        }

        return "/trang/" + HttpUtility.HtmlEncode(slug.Trim());
    }
}
