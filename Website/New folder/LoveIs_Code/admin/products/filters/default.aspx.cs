using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminProductFiltersDefault : AdminBasePage
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<FilterGroupRow> GetFilterGroups(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var groups = db.CfFilterGroups.ToList();
            var options = db.CfFilterOptions
                .GroupBy(o => o.GroupId)
                .Select(g => new { GroupId = g.Key, Count = g.Count() })
                .ToList();
            var optionLookup = options.ToDictionary(o => o.GroupId, o => o.Count);
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "FilterGroup")
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var rows = groups.Select(g =>
            {
                int count = optionLookup.ContainsKey(g.Id) ? optionLookup[g.Id] : 0;
                var slug = slugLookup.ContainsKey(g.Id) ? slugLookup[g.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);

                return new FilterGroupRow
                {
                    Id = g.Id,
                    GroupName = string.Format("{0}<div class=\"slug-wrap\">{1}</div>", g.GroupName, slugHtml),
                    OptionCount = count,
                    SortOrder = g.SortOrder,
                    StatusValue = g.Status ? 1 : 0,
                    StatusHtml = g.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/filters/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteFilterGroup({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", g.Id)
                };
            });

            var total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.GroupName) && r.GroupName.ToLowerInvariant().Contains(keyword));
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.GroupName) && r.GroupName.ToLowerInvariant().Contains(keyword));
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            var filtered = rows.Count();

            rows = FilterGroupTableSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<FilterGroupRow>
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
    public static ActionResult DeleteFilterGroup(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var group = db.CfFilterGroups.FirstOrDefault(g => g.Id == id);
            if (group == null)
            {
                return new ActionResult { Success = false, Message = "Nhóm lọc không tồn tại." };
            }

            bool hasOptions = db.CfFilterOptions.Any(o => o.GroupId == id);
            bool hasCategoryLinks = db.CfCategoryFilterGroups.Any(c => c.GroupId == id);
            bool hasProductLinks = db.CfProductFilters.Any(p => p.GroupId == id);
            if (hasOptions || hasCategoryLinks || hasProductLinks)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa nhóm lọc đang được sử dụng." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "FilterGroup" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfFilterGroups.Remove(group);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class FilterGroupRow
{
    public int Id { get; set; }
    public string GroupName { get; set; }
    public int OptionCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class FilterGroupTableSorter
{
    public static IEnumerable<FilterGroupRow> ApplyOrdering(IEnumerable<FilterGroupRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.GroupName) : rows.OrderBy(r => r.GroupName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.OptionCount) : rows.OrderBy(r => r.OptionCount);
            case 2:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
