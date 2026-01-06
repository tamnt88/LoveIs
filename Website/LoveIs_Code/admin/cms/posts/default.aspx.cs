using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class AdminCmsPostsDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategoryFilter(null);
        }
    }

    private void BindCategoryFilter(int? selectedId)
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            CategoryFilter.Items.Clear();
            CategoryFilter.Items.Add(new ListItem("Tất cả danh mục", ""));
            AddCategoryOptions(CategoryFilter, categories, null, 0);

            if (selectedId.HasValue)
            {
                var item = CategoryFilter.Items.FindByValue(selectedId.Value.ToString());
                if (item != null)
                {
                    CategoryFilter.ClearSelection();
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
    public static DataTableResult<CmsPostRow> GetPosts(int draw, int start, int length, string search, int orderColumn, string orderDir, string keyword, string categoryId, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var posts = db.CfPosts.ToList();
            var categories = db.CfPostCategories.ToDictionary(c => c.Id, c => c.CategoryName);
            var slugLookup = db.CfSeoSlugs
                .Where(s => s.EntityType == "Post")
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var rows = posts.Select(p =>
            {
                var slug = slugLookup.ContainsKey(p.Id) ? slugLookup[p.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);
                var titleHtml = string.Format("<div class=\"fw-semibold\">{0}</div><div class=\"text-muted small\">{1}</div>", p.Title, slugHtml);
                var categoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : "-";

                return new CmsPostRow
                {
                    Id = p.Id,
                    TitleHtml = titleHtml,
                    Title = p.Title,
                    CategoryId = p.CategoryId,
                    CategoryName = categoryName,
                    ViewCount = p.ViewCount,
                    SortOrder = p.SortOrder,
                    StatusValue = p.Status ? 1 : 0,
                    StatusHtml = p.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/cms/posts/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteCmsPost({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", p.Id)
                };
            });

            int total = rows.Count();

            if (!string.IsNullOrWhiteSpace(search))
            {
                string keywordSearch = search.Trim().ToLowerInvariant();
                rows = rows.Where(r =>
                    (!string.IsNullOrWhiteSpace(r.Title) && r.Title.ToLowerInvariant().Contains(keywordSearch)) ||
                    (!string.IsNullOrWhiteSpace(r.CategoryName) && r.CategoryName.ToLowerInvariant().Contains(keywordSearch)));
            }

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string keywordFilter = keyword.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.Title) && r.Title.ToLowerInvariant().Contains(keywordFilter));
            }

            int categoryFilterId;
            if (!string.IsNullOrWhiteSpace(categoryId) && int.TryParse(categoryId, out categoryFilterId))
            {
                rows = rows.Where(r => r.CategoryId == categoryFilterId);
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter);
            }

            int filtered = rows.Count();
            rows = CmsPostSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<CmsPostRow>
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
    public static ActionResult DeletePost(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var post = db.CfPosts.FirstOrDefault(p => p.Id == id);
            if (post == null)
            {
                return new ActionResult { Success = false, Message = "Bài viết không tồn tại." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Post" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            var tagMaps = db.CfPostTagMaps.Where(m => m.PostId == id).ToList();
            if (tagMaps.Any())
            {
                db.CfPostTagMaps.RemoveRange(tagMaps);
            }

            db.CfPosts.Remove(post);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class CmsPostRow
{
    public int Id { get; set; }
    public string TitleHtml { get; set; }
    public string Title { get; set; }
    public int CategoryId { get; set; }
    public string CategoryName { get; set; }
    public int ViewCount { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class CmsPostSorter
{
    public static IEnumerable<CmsPostRow> ApplyOrdering(IEnumerable<CmsPostRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.Title) : rows.OrderBy(r => r.Title);
            case 1:
                return desc ? rows.OrderByDescending(r => r.CategoryName) : rows.OrderBy(r => r.CategoryName);
            case 2:
                return desc ? rows.OrderByDescending(r => r.ViewCount) : rows.OrderBy(r => r.ViewCount);
            case 3:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}
