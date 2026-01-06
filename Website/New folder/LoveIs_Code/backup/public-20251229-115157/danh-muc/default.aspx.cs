using System;
using System.Collections.Generic;
using System.Linq;

public partial class CategoryDefault : System.Web.UI.Page
{
    private int _activeCategoryId;
    private List<int> _activeCategoryIds = new List<int>();
    private HashSet<int> _selectedFilterOptionIds = new HashSet<int>();
    private HashSet<int> _selectedAttributeValueIds = new HashSet<int>();
    private int _currentPage = 1;
    private const int PageSize = 9;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategoryPage();
        }
    }

    private void BindCategoryPage()
    {
        using (var db = new BeautyStoryContext())
        {
            var allCategories = PublicCache.GetOrCreate("categories_all", 5, () => db.CfCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList());

            var menuCategories = allCategories
                .Where(c => !c.ParentId.HasValue)
                .ToList();

            var slugs = PublicCache.GetOrCreate("slugs_all", 5, () => db.CfSeoSlugs.ToList());
            var slugLookup = slugs
                .GroupBy(s => s.EntityType)
                .ToDictionary(
                    g => g.Key,
                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            var menuItems = menuCategories
                .Select(c => new CategoryMenuItem
                {
                    Id = c.Id,
                    CategoryName = c.CategoryName,
                    SeoSlug = GetSlug(slugLookup, "Category", c.Id),
                    Children = allCategories
                        .Where(child => child.ParentId == c.Id && child.Status)
                        .OrderBy(child => child.SortOrder)
                        .ThenBy(child => child.CategoryName)
                        .Select(child => new CategoryMenuItem
                        {
                            Id = child.Id,
                            CategoryName = child.CategoryName,
                            SeoSlug = GetSlug(slugLookup, "Category", child.Id),
                            Children = allCategories
                                .Where(grand => grand.ParentId == child.Id && grand.Status)
                                .OrderBy(grand => grand.SortOrder)
                                .ThenBy(grand => grand.CategoryName)
                                .Select(grand => new CategoryMenuItem
                                {
                                    Id = grand.Id,
                                    CategoryName = grand.CategoryName,
                                    SeoSlug = GetSlug(slugLookup, "Category", grand.Id)
                                })
                                .ToList()
                        })
                        .ToList()
                })
                .Where(item => !string.IsNullOrWhiteSpace(item.SeoSlug))
                .ToList();

            CategoryMenuRepeater.DataSource = menuItems;
            CategoryMenuRepeater.DataBind();

            CategoryPanelRepeater.DataSource = menuItems;
            CategoryPanelRepeater.DataBind();

            var categoryLookup = allCategories.ToDictionary(c => c.Id, c => c);
            var activePath = GetActiveCategoryPath(categoryLookup, _activeCategoryId);
            MarkActive(menuItems, activePath);

            SidebarRepeater.DataSource = menuItems;
            SidebarRepeater.DataBind();

            string slug = (Request.QueryString["slug"] ?? string.Empty).Trim();
            if (string.IsNullOrWhiteSpace(slug))
            {
                var first = menuItems.FirstOrDefault();
                slug = first != null ? first.SeoSlug : string.Empty;
            }

            _activeCategoryId = ResolveCategoryId(slugLookup, slug);

            if (_activeCategoryId == 0)
            {
                CategoryTitle.Text = "Danh mục";
                CategorySubTitle.Text = "Không tìm thấy danh mục.";
                CategoryProductRepeater.DataSource = new List<object>();
                CategoryProductRepeater.DataBind();
                return;
            }

            var activeCategory = allCategories.FirstOrDefault(c => c.Id == _activeCategoryId);
            CategoryTitle.Text = activeCategory != null ? activeCategory.CategoryName : "Danh mục";
            CategorySubTitle.Text = "Sản phẩm theo danh mục";
            CategoryBreadcrumb.Text = BuildCategoryBreadcrumb(allCategories, _activeCategoryId, slugLookup);

            var categoryIds = new List<int> { _activeCategoryId };
            var childIds = allCategories.Where(c => c.ParentId == _activeCategoryId).Select(c => c.Id).ToList();
            var grandChildIds = allCategories.Where(c => c.ParentId.HasValue && childIds.Contains(c.ParentId.Value)).Select(c => c.Id).ToList();
            categoryIds.AddRange(childIds);
            categoryIds.AddRange(grandChildIds);
            _activeCategoryIds = categoryIds;

            _selectedFilterOptionIds = ParseIds(Request.QueryString["filters"]);
            _selectedAttributeValueIds = ParseIds(Request.QueryString["attrs"]);
            _currentPage = ParsePage(Request.QueryString["page"]);

            var productQuery = db.CfProducts
                .Where(p => p.Status && categoryIds.Contains(p.CategoryId))
                .Select(p => p.Id);

            if (_selectedFilterOptionIds.Count > 0)
            {
                var productIdsByFilter = db.CfProductFilters
                    .Where(pf => _selectedFilterOptionIds.Contains(pf.OptionId))
                    .Select(pf => pf.ProductId)
                    .Distinct();
                productQuery = productQuery.Where(id => productIdsByFilter.Contains(id));
            }

            if (_selectedAttributeValueIds.Count > 0)
            {
                var productIdsByAttr = db.CfProductVariantAttributes
                    .Where(pva => _selectedAttributeValueIds.Contains(pva.AttributeValueId))
                    .Select(pva => pva.Variant.ProductId)
                    .Distinct();
                productQuery = productQuery.Where(id => productIdsByAttr.Contains(id));
            }

            var totalProducts = productQuery.Count();
            int totalPages = (int)Math.Ceiling(totalProducts / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var pagedProductIds = productQuery
                .OrderByDescending(id => id)
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var products = db.CfProducts
                .Where(p => pagedProductIds.Contains(p.Id))
                .ToList();
            var productIds = products.Select(p => p.Id).ToList();
            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            var categoryNameLookup = allCategories.ToDictionary(c => c.Id, c => c.CategoryName);
            var priceLookup = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g =>
                    {
                        var sale = g.Where(v => v.SalePrice.HasValue).OrderBy(v => v.SalePrice.Value).FirstOrDefault();
                        var variant = sale ?? g.OrderBy(v => v.Price).FirstOrDefault();
                        if (variant == null)
                        {
                            return "Liên hệ";
                        }
                        var price = variant.SalePrice.HasValue ? variant.SalePrice.Value : variant.Price;
                        return string.Format("{0:N0} đ", price);
                    });
            var primaryImageLookup = images
                .GroupBy(i => i.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g =>
                    {
                        var primary = g.FirstOrDefault(i => i.IsPrimary);
                        if (primary != null)
                        {
                            return primary.ImageUrl;
                        }
                        var fallback = g.FirstOrDefault();
                        return fallback != null ? fallback.ImageUrl : null;
                    });

            CategoryProductRepeater.DataSource = products
                .OrderByDescending(p => p.CreatedAt)
                .ThenByDescending(p => p.Id)
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categoryNameLookup.ContainsKey(p.CategoryId) ? categoryNameLookup[p.CategoryId] : "-",
                    SeoSlug = GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) && !string.IsNullOrWhiteSpace(primaryImageLookup[p.Id]) ? primaryImageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = priceLookup.ContainsKey(p.Id) ? priceLookup[p.Id] : "Liên hệ"
                })
                .ToList();
            CategoryProductRepeater.DataBind();

            BindFilters(db);
            BindAttributes(db);
            RenderPagination(totalPages);
        }
    }

    public string GetMenuItemActiveClass(int index)
    {
        return index == 0 ? "active" : string.Empty;
    }

    public string GetPanelActiveClass(int index)
    {
        return index == 0 ? "active" : string.Empty;
    }

    public string GetSidebarActiveClass(object categoryId)
    {
        int id = 0;
        if (categoryId != null)
        {
            int.TryParse(categoryId.ToString(), out id);
        }
        return id == _activeCategoryId ? "active" : string.Empty;
    }

    public string GetSidebarOpenClass(object isOpen)
    {
        bool open = false;
        if (isOpen != null)
        {
            bool.TryParse(isOpen.ToString(), out open);
        }
        return open ? "open" : string.Empty;
    }

    public string GetToggleVisibleClass(object hasChildren)
    {
        bool visible = false;
        if (hasChildren != null)
        {
            bool.TryParse(hasChildren.ToString(), out visible);
        }
        return visible ? string.Empty : "d-none";
    }

    private static string GetSlug(Dictionary<string, Dictionary<int, string>> lookup, string entityType, int entityId)
    {
        if (!lookup.ContainsKey(entityType))
        {
            return string.Empty;
        }

        var entityLookup = lookup[entityType];
        return entityLookup.ContainsKey(entityId) ? entityLookup[entityId] : string.Empty;
    }

    private static int ResolveCategoryId(Dictionary<string, Dictionary<int, string>> lookup, string slug)
    {
        if (!lookup.ContainsKey("Category"))
        {
            return 0;
        }

        var match = lookup["Category"].FirstOrDefault(kv => string.Equals(kv.Value, slug, StringComparison.OrdinalIgnoreCase));
        return match.Key;
    }

    private static string GetPrimaryImage(List<CfProductImage> images, int productId)
    {
        var primary = images.FirstOrDefault(i => i.ProductId == productId && i.IsPrimary);
        if (primary != null)
        {
            return primary.ImageUrl;
        }

        var fallback = images.FirstOrDefault(i => i.ProductId == productId);
        return fallback != null ? fallback.ImageUrl : "/images/fav.png";
    }

    private static string GetPriceLabel(List<CfProductVariant> variants, int productId)
    {
        var productVariants = variants.Where(v => v.ProductId == productId).ToList();
        if (productVariants.Count == 0)
        {
            return "Liên hệ";
        }

        var saleVariant = productVariants
            .Where(v => v.SalePrice.HasValue)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();

        var variant = saleVariant ?? productVariants.OrderBy(v => v.Price).First();
        var price = variant.SalePrice.HasValue ? variant.SalePrice.Value : variant.Price;
        return string.Format("{0:N0} đ", price);
    }

    public class CategoryMenuItem
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public List<CategoryMenuItem> Children { get; set; }
        public bool IsOpen { get; set; }
        public int ChildCount
        {
            get { return Children != null ? Children.Count : 0; }
        }
        public bool HasChildren
        {
            get { return ChildCount > 0; }
        }
    }

    private static List<int> GetActiveCategoryPath(Dictionary<int, CfCategory> lookup, int categoryId)
    {
        var path = new List<int>();
        int currentId = categoryId;
        while (currentId > 0 && lookup.ContainsKey(currentId))
        {
            path.Add(currentId);
            var parentId = lookup[currentId].ParentId;
            if (!parentId.HasValue)
            {
                break;
            }
            currentId = parentId.Value;
        }
        return path;
    }

    private static void MarkActive(List<CategoryMenuItem> items, List<int> activePath)
    {
        foreach (var item in items)
        {
            item.IsOpen = activePath.Contains(item.Id);
            if (item.Children != null && item.Children.Count > 0)
            {
                MarkActive(item.Children, activePath);
            }
        }
    }

    private void BindFilters(BeautyStoryContext db)
    {
        var categoryKey = _activeCategoryIds != null && _activeCategoryIds.Count > 0
            ? string.Join("_", _activeCategoryIds.OrderBy(id => id))
            : "none";
        var groupIds = PublicCache.GetOrCreate("filter_group_ids_" + categoryKey, 2, () => db.CfCategoryFilterGroups
            .Where(x => _activeCategoryIds.Contains(x.CategoryId))
            .Select(x => x.GroupId)
            .Distinct()
            .ToList());

        var groupKey = groupIds.Count > 0 ? string.Join("_", groupIds.OrderBy(id => id)) : "none";
        var groups = PublicCache.GetOrCreate("filter_groups_" + groupKey, 2, () => db.CfFilterGroups
            .Where(g => groupIds.Contains(g.Id) && g.Status)
            .OrderBy(g => g.SortOrder)
            .ThenBy(g => g.GroupName)
            .ToList());

        var options = PublicCache.GetOrCreate("filter_options_" + groupKey, 2, () => db.CfFilterOptions
            .Where(o => groupIds.Contains(o.GroupId) && o.Status)
            .OrderBy(o => o.SortOrder)
            .ThenBy(o => o.OptionName)
            .ToList());

        var grouped = groups.Select(g => new FilterGroupItem
        {
            Id = g.Id,
            GroupName = g.GroupName,
            Options = options
                .Where(o => o.GroupId == g.Id)
                .Select(o => new FilterOptionItem
                {
                    Id = o.Id,
                    OptionName = o.OptionName,
                    Checked = _selectedFilterOptionIds.Contains(o.Id) ? "checked=\"checked\"" : string.Empty
                })
                .ToList()
        }).ToList();

        FilterGroupRepeater.DataSource = grouped;
        FilterGroupRepeater.DataBind();
    }

    public class FilterGroupItem
    {
        public int Id { get; set; }
        public string GroupName { get; set; }
        public List<FilterOptionItem> Options { get; set; }
    }

    public class FilterOptionItem
    {
        public int Id { get; set; }
        public string OptionName { get; set; }
        public string Checked { get; set; }
    }

    private void BindAttributes(BeautyStoryContext db)
    {
        var categoryKey = _activeCategoryIds != null && _activeCategoryIds.Count > 0
            ? string.Join("_", _activeCategoryIds.OrderBy(id => id))
            : "none";
        var productIds = PublicCache.GetOrCreate("attr_product_ids_" + categoryKey, 2, () => db.CfProducts
            .Where(p => p.Status && _activeCategoryIds.Contains(p.CategoryId))
            .Select(p => p.Id)
            .ToList());

        var attributeIds = PublicCache.GetOrCreate("attr_ids_" + categoryKey, 2, () => db.CfProductVariantAttributes
            .Where(pva => productIds.Contains(pva.Variant.ProductId))
            .Select(pva => pva.AttributeId)
            .Distinct()
            .ToList());

        var attrKey = attributeIds.Count > 0 ? string.Join("_", attributeIds.OrderBy(id => id)) : "none";
        var attributes = PublicCache.GetOrCreate("attr_groups_" + attrKey, 2, () => db.CfVariantAttributes
            .Where(a => attributeIds.Contains(a.Id) && a.Status)
            .OrderBy(a => a.SortOrder)
            .ThenBy(a => a.AttributeName)
            .ToList());

        var values = PublicCache.GetOrCreate("attr_values_" + attrKey, 2, () => db.CfVariantAttributeValues
            .Where(v => attributeIds.Contains(v.AttributeId) && v.Status)
            .OrderBy(v => v.SortOrder)
            .ThenBy(v => v.ValueName)
            .ToList());

        var grouped = attributes.Select(a => new AttributeGroupItem
        {
            Id = a.Id,
            AttributeName = a.AttributeName,
            Values = values
                .Where(v => v.AttributeId == a.Id)
                .Select(v => new AttributeValueItem
                {
                    Id = v.Id,
                    ValueName = v.ValueName,
                    Checked = _selectedAttributeValueIds.Contains(v.Id) ? "checked=\"checked\"" : string.Empty
                })
                .ToList()
        }).ToList();

        AttributeGroupRepeater.DataSource = grouped;
        AttributeGroupRepeater.DataBind();
    }

    public class AttributeGroupItem
    {
        public int Id { get; set; }
        public string AttributeName { get; set; }
        public List<AttributeValueItem> Values { get; set; }
    }

    public class AttributeValueItem
    {
        public int Id { get; set; }
        public string ValueName { get; set; }
        public string Checked { get; set; }
    }

    private static HashSet<int> ParseIds(string raw)
    {
        var result = new HashSet<int>();
        if (string.IsNullOrWhiteSpace(raw))
        {
            return result;
        }

        var parts = raw.Split(',');
        foreach (var part in parts)
        {
            int id;
            if (int.TryParse(part.Trim(), out id) && id > 0)
            {
                result.Add(id);
            }
        }

        return result;
    }

    private static int ParsePage(string raw)
    {
        int page = 1;
        if (int.TryParse(raw, out page) && page > 0)
        {
            return page;
        }
        return 1;
    }

    private void RenderPagination(int totalPages)
    {
        if (totalPages <= 1)
        {
            PaginationLiteral.Text = string.Empty;
            return;
        }

        var links = new List<string>();
        string baseUrl = BuildBaseUrl();

        int start = Math.Max(1, _currentPage - 2);
        int end = Math.Min(totalPages, _currentPage + 2);

        if (_currentPage > 1)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">Trước</a></li>", baseUrl, _currentPage - 1));
        }

        for (int i = start; i <= end; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<li class=\"page-item active\"><span class=\"page-link\">{0}</span></li>", i));
            }
            else
            {
                links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">{1}</a></li>", baseUrl, i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}&page={1}\">Sau</a></li>", baseUrl, _currentPage + 1));
        }

        PaginationLiteral.Text = string.Format("<nav><ul class=\"pagination\">{0}</ul></nav>", string.Join("", links));
    }

    private string BuildBaseUrl()
    {
        string slug = (Request.QueryString["slug"] ?? string.Empty).Trim();
        string filters = Request.QueryString["filters"];
        string attrs = Request.QueryString["attrs"];

        var query = new List<string>();
        if (!string.IsNullOrWhiteSpace(slug))
        {
            query.Add("slug=" + Server.UrlEncode(slug));
        }
        if (!string.IsNullOrWhiteSpace(filters))
        {
            query.Add("filters=" + Server.UrlEncode(filters));
        }
        if (!string.IsNullOrWhiteSpace(attrs))
        {
            query.Add("attrs=" + Server.UrlEncode(attrs));
        }

        return "/danh-muc/default.aspx?" + string.Join("&", query);
    }

    private static string BuildCategoryBreadcrumb(List<CfCategory> categories, int categoryId, Dictionary<string, Dictionary<int, string>> slugLookup)
    {
        var path = new List<CfCategory>();
        var lookup = categories.ToDictionary(c => c.Id, c => c);
        int currentId = categoryId;
        while (lookup.ContainsKey(currentId))
        {
            var current = lookup[currentId];
            path.Add(current);
            if (!current.ParentId.HasValue)
            {
                break;
            }
            currentId = current.ParentId.Value;
        }
        path.Reverse();

        var links = new List<string>
        {
            "<li class=\"breadcrumb-item\"><a href=\"/\">Trang chủ</a></li>"
        };

        foreach (var item in path)
        {
            var slug = GetSlug(slugLookup, "Category", item.Id);
            if (!string.IsNullOrWhiteSpace(slug))
            {
                links.Add(string.Format("<li class=\"breadcrumb-item\"><a href=\"/danh-muc/default.aspx?slug={0}\">{1}</a></li>", slug, item.CategoryName));
            }
            else
            {
                links.Add(string.Format("<li class=\"breadcrumb-item active\" aria-current=\"page\">{0}</li>", item.CategoryName));
            }
        }

        return string.Join("", links);
    }
}

