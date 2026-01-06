using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminProductCategoriesDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindParentFilter();
        }
    }

    private void BindParentFilter()
    {
        using (var db = new BeautyStoryContext())
        {
            var parents = db.CfCategories
                .Where(c => c.ParentId == null)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .Select(c => new { c.Id, c.CategoryName })
                .ToList();

            FilterParent.Items.Clear();
            FilterParent.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả danh mục cha", ""));
            foreach (var parent in parents)
            {
                FilterParent.Items.Add(new System.Web.UI.WebControls.ListItem(parent.CategoryName, parent.Id.ToString()));
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<CategoryRow> GetCategories(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string parentId, string level, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfCategories.ToList();
            var parentsLookup = categories.ToDictionary(c => c.Id, c => c.CategoryName);
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Category")
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);
            var rows = categories
                .Select(c =>
                {
                    int levelValue = GetLevel(c, categories);
                    var parentName = c.ParentId.HasValue && parentsLookup.ContainsKey(c.ParentId.Value)
                        ? parentsLookup[c.ParentId.Value]
                        : "-";
                    var slug = slugLookup.ContainsKey(c.Id) ? slugLookup[c.Id] : string.Empty;
                    var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);

                    return new CategoryRow
                    {
                        Id = c.Id,
                        CategoryName = string.Format("{0}<div class=\"slug-wrap\">{1}</div>", c.CategoryName, slugHtml),
                        ParentName = parentName,
                        ParentId = c.ParentId.HasValue ? c.ParentId.Value : 0,
                        LevelLabel = levelValue == 1 ? "Danh mục cha" : levelValue == 2 ? "Danh mục con" : "Danh mục cháu",
                        LevelValue = levelValue,
                        SortOrder = c.SortOrder,
                        StatusHtml = c.Status
                            ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                            : "<span class=\"status-tag status-off\">Ẩn</span>",
                        StatusValue = c.Status ? 1 : 0,
                        ActionsHtml = string.Format(
                            "<div class=\"menu-actions justify-content-end\">" +
                            "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/categories/edit.aspx?id={0}\">" +
                            "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                            "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteCategory({0});\">" +
                            "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                            "</div>", c.Id)
                    };
                });

            var total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r =>
                    (!string.IsNullOrWhiteSpace(r.CategoryName) && r.CategoryName.ToLowerInvariant().Contains(keyword)) ||
                    (!string.IsNullOrWhiteSpace(r.ParentName) && r.ParentName.ToLowerInvariant().Contains(keyword)) ||
                    (!string.IsNullOrWhiteSpace(r.LevelLabel) && r.LevelLabel.ToLowerInvariant().Contains(keyword)));
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.CategoryName) && r.CategoryName.ToLowerInvariant().Contains(keyword));
            }

            int parentFilterId;
            if (!string.IsNullOrWhiteSpace(parentId) && int.TryParse(parentId, out parentFilterId))
            {
                rows = rows.Where(r => r.ParentId == parentFilterId);
            }

            int levelFilter;
            if (!string.IsNullOrWhiteSpace(level) && int.TryParse(level, out levelFilter))
            {
                rows = rows.Where(r => r.LevelValue == levelFilter);
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            var filtered = rows.Count();

            rows = DataTableSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<CategoryRow>
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
            var category = db.CfCategories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return new ActionResult { Success = false, Message = "Danh mục không tồn tại." };
            }

            bool hasChildren = db.CfCategories.Any(c => c.ParentId == id);
            int productCount = db.Database.SqlQuery<int>("SELECT COUNT(1) FROM dbo.cf_product WHERE CategoryId = @p0", id).FirstOrDefault();

            if (hasChildren || productCount > 0)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa danh mục đang được sử dụng." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Category" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfCategories.Remove(category);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }

    private static int GetLevel(CfCategory category, List<CfCategory> categories)
    {
        if (category == null)
        {
            return 1;
        }

        if (!category.ParentId.HasValue)
        {
            return 1;
        }

        var parent = categories.FirstOrDefault(c => c.Id == category.ParentId.Value);
        if (parent == null || !parent.ParentId.HasValue)
        {
            return 2;
        }

        return 3;
    }
}

public class CategoryRow
{
    public int Id { get; set; }
    public string CategoryName { get; set; }
    public string ParentName { get; set; }
    public int ParentId { get; set; }
    public string LevelLabel { get; set; }
    public int LevelValue { get; set; }
    public int SortOrder { get; set; }
    public string StatusHtml { get; set; }
    public int StatusValue { get; set; }
    public string ActionsHtml { get; set; }
}

public static class DataTableSorter
{
    public static IEnumerable<CategoryRow> ApplyOrdering(IEnumerable<CategoryRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.CategoryName) : rows.OrderBy(r => r.CategoryName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.ParentName) : rows.OrderBy(r => r.ParentName);
            case 2:
                return desc ? rows.OrderByDescending(r => r.LevelLabel) : rows.OrderBy(r => r.LevelLabel);
            case 3:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}


