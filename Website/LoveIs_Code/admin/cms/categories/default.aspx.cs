using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class AdminCmsCategoriesList : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindParentCategories(null);
        }
    }

    private void BindParentCategories(int? selectedId)
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            ParentFilter.Items.Clear();
            ParentFilter.Items.Add(new ListItem("Tất cả danh mục", ""));
            AddCategoryOptions(ParentFilter, categories, null, 0);

            if (selectedId.HasValue)
            {
                var item = ParentFilter.Items.FindByValue(selectedId.Value.ToString());
                if (item != null)
                {
                    ParentFilter.ClearSelection();
                    item.Selected = true;
                }
            }
        }
    }

    private static void AddCategoryOptions(ListControl target, List<CfPostCategory> categories, int? parentId, int level)
    {
        var items = categories
            .Where(c => c.ParentId == parentId)
            .OrderBy(c => c.SortOrder)
            .ThenBy(c => c.CategoryName)
            .ToList();

        string prefix = string.Empty;
        for (int i = 0; i < level; i++)
        {
            prefix += "|-- ";
        }

        foreach (var item in items)
        {
            target.Items.Add(new ListItem(string.Concat(prefix, item.CategoryName), item.Id.ToString()));
            AddCategoryOptions(target, categories, item.Id, level + 1);
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<CmsCategoryRow> GetCategories(int draw, int start, int length, string search, int orderColumn, string orderDir, string keyword, string parentId, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories.ToList();
            var parentLookup = categories.ToDictionary(c => c.Id, c => c.CategoryName);
            var slugLookup = db.CfSeoSlugs
                .Where(s => s.EntityType == "PostCategory")
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var rows = categories.Select(c =>
            {
                var slug = slugLookup.ContainsKey(c.Id) ? slugLookup[c.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);
                var parentName = c.ParentId.HasValue && parentLookup.ContainsKey(c.ParentId.Value) ? parentLookup[c.ParentId.Value] : "-";

                return new CmsCategoryRow
                {
                    Id = c.Id,
                    CategoryName = string.Format("{0}<div class=\"slug-wrap\">{1}</div>", c.CategoryName, slugHtml),
                    ParentName = parentName,
                    ParentId = c.ParentId ?? 0,
                    ViewCount = c.ViewCount,
                    SortOrder = c.SortOrder,
                    StatusValue = c.Status ? 1 : 0,
                    StatusHtml = c.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/cms/categories/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteCmsCategory({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", c.Id)
                };
            });

            int total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                string keywordSearch = search.Trim().ToLowerInvariant();
                rows = rows.Where(r =>
                    (!string.IsNullOrWhiteSpace(r.CategoryName) && r.CategoryName.ToLowerInvariant().Contains(keywordSearch)) ||
                    (!string.IsNullOrWhiteSpace(r.ParentName) && r.ParentName.ToLowerInvariant().Contains(keywordSearch)));
            }

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string keywordFilter = keyword.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.CategoryName) && r.CategoryName.ToLowerInvariant().Contains(keywordFilter));
            }

            int parentFilterId;
            if (!string.IsNullOrWhiteSpace(parentId) && int.TryParse(parentId, out parentFilterId))
            {
                rows = rows.Where(r => r.ParentId == parentFilterId);
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            int filtered = rows.Count();
            rows = CmsCategorySorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<CmsCategoryRow>
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
    public static ActionResult DeleteCategory(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var category = db.CfPostCategories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return new ActionResult { Success = false, Message = "Danh mục không tồn tại." };
            }

            bool hasChildren = db.CfPostCategories.Any(c => c.ParentId == id);
            bool hasPosts = db.CfPosts.Any(p => p.CategoryId == id);
            if (hasChildren || hasPosts)
            {
                return new ActionResult { Success = false, Message = "Danh mục đang được sử dụng, không thể xóa." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "PostCategory" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfPostCategories.Remove(category);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class CmsCategoryRow
{
    public int Id { get; set; }
    public string CategoryName { get; set; }
    public string ParentName { get; set; }
    public int ParentId { get; set; }
    public int ViewCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class CmsCategorySorter
{
    public static IEnumerable<CmsCategoryRow> ApplyOrdering(IEnumerable<CmsCategoryRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.CategoryName) : rows.OrderBy(r => r.CategoryName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.ParentName) : rows.OrderBy(r => r.ParentName);
            case 2:
                return desc ? rows.OrderByDescending(r => r.ViewCount) : rows.OrderBy(r => r.ViewCount);
            case 3:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
