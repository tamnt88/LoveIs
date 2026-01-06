using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminProductBrandsDefault : AdminBasePage
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<BrandRow> GetBrands(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var brands = db.CfBrands.ToList();
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Brand")
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var rows = brands.Select(b =>
            {
                var slug = slugLookup.ContainsKey(b.Id) ? slugLookup[b.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);

                return new BrandRow
                {
                    Id = b.Id,
                    BrandName = string.Format("{0}<div class=\"slug-wrap\">{1}</div>", b.BrandName, slugHtml),
                    ViewCount = b.ViewCount,
                    SortOrder = b.SortOrder,
                    StatusValue = b.Status ? 1 : 0,
                    StatusHtml = b.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/brands/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteBrand({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", b.Id)
                };
            });

            var total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.BrandName) && r.BrandName.ToLowerInvariant().Contains(keyword));
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.BrandName) && r.BrandName.ToLowerInvariant().Contains(keyword));
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            var filtered = rows.Count();

            rows = BrandTableSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<BrandRow>
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
    public static ActionResult DeleteBrand(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var brand = db.CfBrands.FirstOrDefault(b => b.Id == id);
            if (brand == null)
            {
                return new ActionResult { Success = false, Message = "Thương hiệu không tồn tại." };
            }

            bool hasProducts = db.CfProducts.Any(p => p.BrandId == id);
            if (hasProducts)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa thương hiệu đang được sử dụng." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Brand" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfBrands.Remove(brand);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class BrandRow
{
    public int Id { get; set; }
    public string BrandName { get; set; }
    public int ViewCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class BrandTableSorter
{
    public static IEnumerable<BrandRow> ApplyOrdering(IEnumerable<BrandRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.BrandName) : rows.OrderBy(r => r.BrandName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.ViewCount) : rows.OrderBy(r => r.ViewCount);
            case 2:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
