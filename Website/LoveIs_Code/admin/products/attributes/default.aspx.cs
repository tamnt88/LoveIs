using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminProductAttributesDefault : AdminBasePage
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<AttributeRow> GetAttributes(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var attributes = db.CfVariantAttributes.ToList();
            var values = db.CfVariantAttributeValues
                .GroupBy(v => v.AttributeId)
                .Select(g => new { AttributeId = g.Key, Count = g.Count() })
                .ToList();
            var valueLookup = values.ToDictionary(v => v.AttributeId, v => v.Count);

            var rows = attributes.Select(a =>
            {
                int count = valueLookup.ContainsKey(a.Id) ? valueLookup[a.Id] : 0;
                return new AttributeRow
                {
                    Id = a.Id,
                    AttributeName = a.AttributeName,
                    ValueCount = count,
                    SortOrder = a.SortOrder,
                    StatusValue = a.Status ? 1 : 0,
                    StatusHtml = a.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/attributes/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteAttribute({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", a.Id)
                };
            });

            var total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.AttributeName) && r.AttributeName.ToLowerInvariant().Contains(keyword));
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.AttributeName) && r.AttributeName.ToLowerInvariant().Contains(keyword));
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            var filtered = rows.Count();

            rows = AttributeTableSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<AttributeRow>
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
    public static ActionResult DeleteAttribute(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var attribute = db.CfVariantAttributes.FirstOrDefault(a => a.Id == id);
            if (attribute == null)
            {
                return new ActionResult { Success = false, Message = "Thuộc tính không tồn tại." };
            }

            bool hasValues = db.CfVariantAttributeValues.Any(v => v.AttributeId == id);
            bool hasProductLinks = db.CfProductVariantAttributes.Any(p => p.AttributeId == id);
            if (hasValues || hasProductLinks)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa thuộc tính đang được sử dụng." };
            }

            db.CfVariantAttributes.Remove(attribute);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class AttributeRow
{
    public int Id { get; set; }
    public string AttributeName { get; set; }
    public int ValueCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class AttributeTableSorter
{
    public static IEnumerable<AttributeRow> ApplyOrdering(IEnumerable<AttributeRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.AttributeName) : rows.OrderBy(r => r.AttributeName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.ValueCount) : rows.OrderBy(r => r.ValueCount);
            case 2:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
