using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminCmsTagsList : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<CmsTagRow> GetTags(int draw, int start, int length, string search, int orderColumn, string orderDir, string keyword, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var tags = db.CfPostTags.ToList();
            var slugLookup = db.CfSeoSlugs
                .Where(s => s.EntityType == "PostTag")
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var rows = tags.Select(t =>
            {
                var slug = slugLookup.ContainsKey(t.Id) ? slugLookup[t.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);

                return new CmsTagRow
                {
                    Id = t.Id,
                    TagName = t.TagName,
                    SlugHtml = slugHtml,
                    ViewCount = t.ViewCount,
                    SortOrder = t.SortOrder,
                    StatusValue = t.Status ? 1 : 0,
                    StatusHtml = t.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/cms/tags/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteCmsTag({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", t.Id)
                };
            });

            int total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                string keywordSearch = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.TagName) && r.TagName.ToLowerInvariant().Contains(keywordSearch));
            }

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string keywordFilter = keyword.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.TagName) && r.TagName.ToLowerInvariant().Contains(keywordFilter));
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            int filtered = rows.Count();
            rows = CmsTagSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<CmsTagRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = filtered,
                data = rows.ToList()
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult DeleteTag(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var tag = db.CfPostTags.FirstOrDefault(t => t.Id == id);
            if (tag == null)
            {
                return new ActionResult { Success = false, Message = "Tag không tồn tại." };
            }

            bool used = db.CfPostTagMaps.Any(m => m.TagId == id);
            if (used)
            {
                return new ActionResult { Success = false, Message = "Tag đang được sử dụng, không thể xóa." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "PostTag" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfPostTags.Remove(tag);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class CmsTagRow
{
    public int Id { get; set; }
    public string TagName { get; set; }
    public string SlugHtml { get; set; }
    public int ViewCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class CmsTagSorter
{
    public static IEnumerable<CmsTagRow> ApplyOrdering(IEnumerable<CmsTagRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.TagName) : rows.OrderBy(r => r.TagName);
            case 2:
                return desc ? rows.OrderByDescending(r => r.ViewCount) : rows.OrderBy(r => r.ViewCount);
            case 3:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
