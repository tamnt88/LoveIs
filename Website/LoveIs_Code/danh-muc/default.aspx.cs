using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web;

public partial class CategoryDefault : System.Web.UI.Page
{
    private int _activeCategoryId;
    private List<int> _activeCategoryIds = new List<int>();
    private HashSet<int> _selectedFilterOptionIds = new HashSet<int>();
    private HashSet<int> _selectedAttributeValueIds = new HashSet<int>();
    private int _currentPage = 1;
    private const int PageSize = 28;

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
            var allCategories = db.CfCategories.AsNoTracking()
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => s.EntityType == "Category" || s.EntityType == "Product")
                .ToList();
            var slugLookup = slugs
                .GroupBy(s => s.EntityType)
                .ToDictionary(
                    g => g.Key,
                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            string slug = GetSlugFromRequest();
            if (string.IsNullOrWhiteSpace(slug))
            {
                var firstSlug = slugs.FirstOrDefault(s => s.EntityType == "Category");
                slug = firstSlug != null ? firstSlug.SeoSlug : string.Empty;
            }

            _activeCategoryId = ResolveCategoryId(slugLookup, slug);

            var menuItems = allCategories
                .Where(c => !c.ParentId.HasValue)
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

            var categoryLookup = allCategories.ToDictionary(c => c.Id, c => c);
            var activePath = GetActiveCategoryPath(categoryLookup, _activeCategoryId);
            MarkActive(menuItems, activePath);

            SidebarRepeater.DataSource = menuItems;
            SidebarRepeater.DataBind();

            if (_activeCategoryId == 0)
            {
                CategoryTitle.Text = "Danh mục";
                CategorySubTitle.Text = "Không tìm thấy danh mục.";
                CategoryProductRepeater.DataSource = new List<object>();
                CategoryProductRepeater.DataBind();
                return;
            }

            var activeCategory = db.CfCategories.AsNoTracking().FirstOrDefault(c => c.Id == _activeCategoryId);
            CategoryTitle.Text = activeCategory != null ? activeCategory.CategoryName : "Danh mục";
            CategorySubTitle.Text = string.Empty;
            CategoryBreadcrumb.Text = BuildCategoryBreadcrumb(allCategories, _activeCategoryId, slugLookup);
            CategoryTitleTop.Text = activeCategory != null ? activeCategory.CategoryName : "Danh mục";
            string bannerUrl = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.BannerUrl)
                ? activeCategory.BannerUrl
                : "/public/theme/assets/images/slider/22.png";
            CategoryBannerImage.ImageUrl = bannerUrl;

            string slugUrl = !string.IsNullOrWhiteSpace(slug) ? "/danh-muc/" + slug : "/danh-muc";
            string title = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.SeoTitle)
                ? activeCategory.SeoTitle
                : (activeCategory != null ? activeCategory.CategoryName : "Danh mục");
            string description = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.SeoDescription)
                ? activeCategory.SeoDescription
                : title;
            string keywords = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.SeoKeywords)
                ? activeCategory.SeoKeywords
                : title;
            string siteUrl = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Authority) : string.Empty;
            string canonical = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.CanonicalUrl)
                ? activeCategory.CanonicalUrl
                : (siteUrl + slugUrl);
            string robots = activeCategory != null ? activeCategory.Robots : string.Empty;
            string ogTitle = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.OgTitle) ? activeCategory.OgTitle : title;
            string ogDescription = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.OgDescription) ? activeCategory.OgDescription : description;
            string ogImage = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.OgImage) ? activeCategory.OgImage : bannerUrl;
            string ogType = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.OgType) ? activeCategory.OgType : "website";
            string twitterTitle = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.TwitterTitle) ? activeCategory.TwitterTitle : title;
            string twitterDescription = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.TwitterDescription) ? activeCategory.TwitterDescription : description;
            string twitterImage = activeCategory != null && !string.IsNullOrWhiteSpace(activeCategory.TwitterImage) ? activeCategory.TwitterImage : bannerUrl;

            SeoTitleLiteral.Text = title + " | LoveIs Store";// HttpUtility.HtmlEncode(title + " | LoveIs Store");
            SeoMetaLiteral.Text = string.Join(Environment.NewLine, BuildSeoMeta(canonical, description, keywords, robots, ogTitle, ogDescription, ogImage, ogType, twitterTitle, twitterDescription, twitterImage));

            var categoryIds = new List<int> { _activeCategoryId };
            var childIds = allCategories.Where(c => c.ParentId == _activeCategoryId).Select(c => c.Id).ToList();
            var grandChildIds = allCategories.Where(c => c.ParentId.HasValue && childIds.Contains(c.ParentId.Value)).Select(c => c.Id).ToList();
            categoryIds.AddRange(childIds);
            categoryIds.AddRange(grandChildIds);
            _activeCategoryIds = categoryIds;

            _selectedFilterOptionIds = ParseIds(Request.QueryString["filters"]);
            _selectedAttributeValueIds = ParseIds(Request.QueryString["attrs"]);
            _currentPage = ParsePage(Request.QueryString["page"]);

            var productQuery = db.CfProducts.AsNoTracking()
                .Where(p => p.Status && categoryIds.Contains(p.CategoryId));

            if (_selectedFilterOptionIds.Count > 0)
            {
                var productIdsByFilter = db.CfProductFilters
                    .Where(pf => _selectedFilterOptionIds.Contains(pf.OptionId))
                    .Select(pf => pf.ProductId)
                    .Distinct();
                productQuery = productQuery.Where(p => productIdsByFilter.Contains(p.Id));
            }

            if (_selectedAttributeValueIds.Count > 0)
            {
                var productIdsByAttr = db.CfProductVariantAttributes.AsNoTracking()
                    .Where(pva => _selectedAttributeValueIds.Contains(pva.AttributeValueId))
                    .Select(pva => pva.Variant.ProductId)
                    .Distinct();
                productQuery = productQuery.Where(p => productIdsByAttr.Contains(p.Id));
            }

            var totalProducts = productQuery.Count();
            int totalPages = (int)Math.Ceiling(totalProducts / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var pagedProductIds = ProductRanking.Apply(productQuery)
                .Select(p => p.Id)
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var products = db.CfProducts.AsNoTracking()
                .Where(p => pagedProductIds.Contains(p.Id))
                .Select(p => new ProductLite
                {
                    Id = p.Id,
                    ProductName = p.ProductName,
                    CategoryId = p.CategoryId
                })
                .ToList();
            var productIds = products.Select(p => p.Id).ToList();
            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .Select(i => new ProductImageLite
                {
                    ProductId = i.ProductId,
                    ImageUrl = i.ImageUrl,
                    IsPrimary = i.IsPrimary
                })
                .ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .Select(v => new VariantLite
                {
                    ProductId = v.ProductId,
                    Price = v.Price,
                    SalePrice = v.SalePrice
                })
                .ToList();

            var categoryNameLookup = allCategories.ToDictionary(c => c.Id, c => c.CategoryName);
            var variantsByProduct = variants.ToLookup(v => v.ProductId);
            var variantSummaryLookup = new Dictionary<int, VariantSummary>();
            foreach (var group in variantsByProduct)
            {
                var list = group.ToList();
                variantSummaryLookup[group.Key] = new VariantSummary
                {
                    PriceLabel = FormatPriceHtml(list),
                    SaleBadge = BuildSaleBadgeHtml(list)
                };
            }

            var primaryImageLookup = new Dictionary<int, string>();
            foreach (var group in images.GroupBy(i => i.ProductId))
            {
                var primary = group.FirstOrDefault(i => i.IsPrimary);
                if (primary != null)
                {
                    primaryImageLookup[group.Key] = primary.ImageUrl;
                    continue;
                }

                var fallback = group.FirstOrDefault();
                if (fallback != null)
                {
                    primaryImageLookup[group.Key] = fallback.ImageUrl;
                }
            }

            var orderLookup = pagedProductIds
                .Select((id, index) => new { id, index })
                .ToDictionary(x => x.id, x => x.index);
            CategoryProductRepeater.DataSource = products
                .OrderBy(p => orderLookup[p.Id])
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categoryNameLookup.ContainsKey(p.CategoryId) ? categoryNameLookup[p.CategoryId] : "-",
                    CategorySlug = GetSlug(slugLookup, "Category", p.CategoryId),
                    SeoSlug = GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) && !string.IsNullOrWhiteSpace(primaryImageLookup[p.Id]) ? primaryImageLookup[p.Id] : "/images/fav.png",
                    PriceLabel = variantSummaryLookup.ContainsKey(p.Id) ? variantSummaryLookup[p.Id].PriceLabel : "Liên hệ",
                    SaleBadge = variantSummaryLookup.ContainsKey(p.Id) ? variantSummaryLookup[p.Id].SaleBadge : string.Empty
                })
                .ToList();
            CategoryProductRepeater.DataBind();

            BindFilters(db);
            BindAttributes(db);
            RenderPagination(totalPages);

            SchemaLiteral.Text = BuildItemListSchema(
                products.Select(p => new SchemaItem
                {
                    Name = p.ProductName,
                    Url = "/san-pham/" + GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = primaryImageLookup.ContainsKey(p.Id) ? primaryImageLookup[p.Id] : "/images/fav.png"
                }).ToList());
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

    private class ProductLite
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
        public int CategoryId { get; set; }
    }

    private class ProductImageLite
    {
        public int ProductId { get; set; }
        public string ImageUrl { get; set; }
        public bool IsPrimary { get; set; }
    }

    private class VariantLite
    {
        public int ProductId { get; set; }
        public decimal Price { get; set; }
        public decimal? SalePrice { get; set; }
    }

    private class VariantSummary
    {
        public string PriceLabel { get; set; }
        public string SaleBadge { get; set; }
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
        var groupIds = db.CfCategoryFilterGroups.AsNoTracking()
            .Where(x => _activeCategoryIds.Contains(x.CategoryId))
            .Select(x => x.GroupId)
            .Distinct()
            .ToList();

        var groupKey = groupIds.Count > 0 ? string.Join("_", groupIds.OrderBy(id => id)) : "none";
        var groups = db.CfFilterGroups.AsNoTracking()
            .Where(g => groupIds.Contains(g.Id) && g.Status)
            .OrderBy(g => g.SortOrder)
            .ThenBy(g => g.GroupName)
            .ToList();

        var options = db.CfFilterOptions.AsNoTracking()
            .Where(o => groupIds.Contains(o.GroupId) && o.Status)
            .OrderBy(o => o.SortOrder)
            .ThenBy(o => o.OptionName)
            .ToList();

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
        var productIds = db.CfProducts.AsNoTracking()
            .Where(p => p.Status && _activeCategoryIds.Contains(p.CategoryId))
            .Select(p => p.Id)
            .ToList();

        var attributeIds = db.CfProductVariantAttributes.AsNoTracking()
            .Where(pva => productIds.Contains(pva.Variant.ProductId))
            .Select(pva => pva.AttributeId)
            .Distinct()
            .ToList();

        var attrKey = attributeIds.Count > 0 ? string.Join("_", attributeIds.OrderBy(id => id)) : "none";
        var attributes = db.CfVariantAttributes.AsNoTracking()
            .Where(a => attributeIds.Contains(a.Id) && a.Status)
            .OrderBy(a => a.SortOrder)
            .ThenBy(a => a.AttributeName)
            .ToList();

        var values = db.CfVariantAttributeValues.AsNoTracking()
            .Where(v => attributeIds.Contains(v.AttributeId) && v.Status)
            .OrderBy(v => v.SortOrder)
            .ThenBy(v => v.ValueName)
            .ToList();

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

        int groupSize = 5;
        int currentGroup = (int)Math.Ceiling(_currentPage / (double)groupSize);
        int groupStart = (currentGroup - 1) * groupSize + 1;
        int groupEnd = Math.Min(groupStart + groupSize - 1, totalPages);

        links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&laquo;</a></li>", BuildPageUrl(baseUrl, 1)));
        if (_currentPage > 1)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&lsaquo;</a></li>", BuildPageUrl(baseUrl, _currentPage - 1)));
        }

        for (int i = groupStart; i <= groupEnd; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<li class=\"page-item active\"><span class=\"page-link\">{0}</span></li>", i));
            }
            else
            {
                links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">{1}</a></li>", BuildPageUrl(baseUrl, i), i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&rsaquo;</a></li>", BuildPageUrl(baseUrl, _currentPage + 1)));
        }
        links.Add(string.Format("<li class=\"page-item\"><a class=\"page-link\" href=\"{0}\">&raquo;</a></li>", BuildPageUrl(baseUrl, totalPages)));

        PaginationLiteral.Text = string.Format("<nav><ul class=\"pagination justify-content-center\">{0}</ul></nav>", string.Join("", links));
    }

    private string BuildBaseUrl()
    {
        string slug = GetSlugFromRequest();
        string filters = Request.QueryString["filters"];
        string attrs = Request.QueryString["attrs"];

        var query = new List<string>();
        if (!string.IsNullOrWhiteSpace(filters))
        {
            query.Add("filters=" + Server.UrlEncode(filters));
        }
        if (!string.IsNullOrWhiteSpace(attrs))
        {
            query.Add("attrs=" + Server.UrlEncode(attrs));
        }

        var basePath = string.IsNullOrWhiteSpace(slug) ? "/danh-muc" : "/danh-muc/" + Server.UrlEncode(slug);
        if (query.Count == 0)
        {
            return basePath;
        }
        return basePath + "?" + string.Join("&", query);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    private static string FormatPriceHtml(List<VariantLite> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return "Liên hệ";
        }

        var sale = variants.Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();
        var variant = sale ?? variants.OrderBy(v => v.Price).FirstOrDefault();
        if (variant == null)
        {
            return "Liên hệ";
        }

        if (variant.SalePrice.HasValue && variant.SalePrice.Value > 0 && variant.SalePrice.Value < variant.Price)
        {
            return string.Format("<span class=\"price-old\">{0:N0} đ</span> <span class=\"price-current\">{1:N0} đ</span>", variant.Price, variant.SalePrice.Value);
        }

        return string.Format("<span class=\"price-current\">{0:N0} đ</span>", variant.Price);
    }

    private static string BuildSaleBadgeHtml(List<VariantLite> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return string.Empty;
        }

        var saleVariant = variants
            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderByDescending(v => (v.Price - v.SalePrice.Value) / v.Price)
            .FirstOrDefault();
        if (saleVariant == null)
        {
            return string.Empty;
        }

        var percent = (int)Math.Round((saleVariant.Price - saleVariant.SalePrice.Value) / saleVariant.Price * 100m, 0);
        if (percent <= 0)
        {
            return string.Empty;
        }

        return string.Format("<span class=\"sale-badge\">-{0}%</span>", percent);
    }

    private class SchemaItem
    {
        public string Name { get; set; }
        public string Url { get; set; }
        public string ImageUrl { get; set; }
    }

    private string BuildItemListSchema(List<SchemaItem> items)
    {
        if (items == null || items.Count == 0)
        {
            return string.Empty;
        }

        var list = items.Select((item, index) => new
        {
            @type = "ListItem",
            position = index + 1,
            url = item.Url,
            name = item.Name,
            image = item.ImageUrl
        }).ToList();

        var schema = new
        {
            @context = "https://schema.org",
            @type = "ItemList",
            itemListElement = list
        };

        var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(schema);
        return "<script type=\"application/ld+json\">" + json + "</script>";
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

        for (int i = 0; i < path.Count; i++)
        {
            var item = path[i];
            var name = item.CategoryName ?? string.Empty;
            if (IsLikelyUrl(name))
            {
                continue;
            }

            bool isLast = i == path.Count - 1;
            var slug = GetSlug(slugLookup, "Category", item.Id);
            if (isLast || string.IsNullOrWhiteSpace(slug))
            {
                links.Add(string.Format("<li class=\"breadcrumb-item active\" aria-current=\"page\">{0}</li>", name));
                continue;
            }

            links.Add(string.Format("<li class=\"breadcrumb-item\"><a href=\"/danh-muc/{0}\">{1}</a></li>", slug, name));
        }

        return string.Join("", links);
    }

    private static bool IsLikelyUrl(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return false;
        }

        return value.StartsWith("http://", StringComparison.OrdinalIgnoreCase)
            || value.StartsWith("https://", StringComparison.OrdinalIgnoreCase)
            || value.Contains("unicoderbd.com");
    }

    private string GetSlugFromRequest()
    {
        var routeSlug = Page.RouteData.Values["slug"] as string;
        if (!string.IsNullOrWhiteSpace(routeSlug))
        {
            return routeSlug.Trim();
        }
        return (Request.QueryString["slug"] ?? string.Empty).Trim();
    }

    private static IEnumerable<string> BuildSeoMeta(
        string canonical,
        string description,
        string keywords,
        string robots,
        string ogTitle,
        string ogDescription,
        string ogImage,
        string ogType,
        string twitterTitle,
        string twitterDescription,
        string twitterImage)
    {
        var tags = new List<string>();
        tags.Add("<meta name=\"description\" content=\"" + Encode(description) + "\" />");
        tags.Add("<meta name=\"keywords\" content=\"" + Encode(keywords) + "\" />");
        if (!string.IsNullOrWhiteSpace(robots))
        {
            tags.Add("<meta name=\"robots\" content=\"" + Encode(robots) + "\" />");
        }
        if (!string.IsNullOrWhiteSpace(canonical))
        {
            tags.Add("<link rel=\"canonical\" href=\"" + Encode(canonical) + "\" />");
            tags.Add("<meta property=\"og:url\" content=\"" + Encode(canonical) + "\" />");
        }

        if (!string.IsNullOrWhiteSpace(ogTitle))
        {
            tags.Add("<meta property=\"og:title\" content=\"" + Encode(ogTitle) + "\" />");
        }
        if (!string.IsNullOrWhiteSpace(ogDescription))
        {
            tags.Add("<meta property=\"og:description\" content=\"" + Encode(ogDescription) + "\" />");
        }
        if (!string.IsNullOrWhiteSpace(ogImage))
        {
            tags.Add("<meta property=\"og:image\" content=\"" + Encode(ogImage) + "\" />");
        }
        if (!string.IsNullOrWhiteSpace(ogType))
        {
            tags.Add("<meta property=\"og:type\" content=\"" + Encode(ogType) + "\" />");
        }

        tags.Add("<meta name=\"twitter:card\" content=\"summary_large_image\" />");
        if (!string.IsNullOrWhiteSpace(twitterTitle))
        {
            tags.Add("<meta name=\"twitter:title\" content=\"" + Encode(twitterTitle) + "\" />");
        }
        if (!string.IsNullOrWhiteSpace(twitterDescription))
        {
            tags.Add("<meta name=\"twitter:description\" content=\"" + Encode(twitterDescription) + "\" />");
        }
        if (!string.IsNullOrWhiteSpace(twitterImage))
        {
            tags.Add("<meta name=\"twitter:image\" content=\"" + Encode(twitterImage) + "\" />");
        }

        return tags;
    }

    private static string Encode(string value)
    {
        return HttpUtility.HtmlAttributeEncode(value ?? string.Empty);
    }
}



