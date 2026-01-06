using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminProductOriginsDefault : AdminBasePage
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<OriginRow> GetOrigins(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var origins = db.CfOrigins.ToList();
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Origin")
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var rows = origins.Select(o =>
            {
                var slug = slugLookup.ContainsKey(o.Id) ? slugLookup[o.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);

                return new OriginRow
                {
                    Id = o.Id,
                    OriginName = string.Format("{0}<div class=\"slug-wrap\">{1}</div>", o.OriginName, slugHtml),
                    ViewCount = o.ViewCount,
                    SortOrder = o.SortOrder,
                    StatusValue = o.Status ? 1 : 0,
                    StatusHtml = o.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/origins/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteOrigin({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", o.Id)
                };
            });

            var total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.OriginName) && r.OriginName.ToLowerInvariant().Contains(keyword));
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.OriginName) && r.OriginName.ToLowerInvariant().Contains(keyword));
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            var filtered = rows.Count();

            rows = OriginTableSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<OriginRow>
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
    public static ActionResult DeleteOrigin(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var origin = db.CfOrigins.FirstOrDefault(o => o.Id == id);
            if (origin == null)
            {
                return new ActionResult { Success = false, Message = "Xuất xứ không tồn tại." };
            }

            bool hasProducts = db.CfProducts.Any(p => p.OriginId == id);
            if (hasProducts)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa xuất xứ đang được sử dụng." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Origin" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfOrigins.Remove(origin);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class OriginRow
{
    public int Id { get; set; }
    public string OriginName { get; set; }
    public int ViewCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class OriginTableSorter
{
    public static IEnumerable<OriginRow> ApplyOrdering(IEnumerable<OriginRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.OriginName) : rows.OrderBy(r => r.OriginName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.ViewCount) : rows.OrderBy(r => r.ViewCount);
            case 2:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
