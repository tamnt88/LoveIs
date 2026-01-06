using System;
using System.Linq;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindHomePage();
        }
    }

    private void BindHomePage()
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

            var categoryLookup = allCategories
                .ToDictionary(c => c.Id, c => c);

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

            var products = db.CfProducts
                .Where(p => p.Status)
                .OrderByDescending(p => p.CreatedAt)
                .ThenByDescending(p => p.Id)
                .Take(30)
                .ToList();

            var productIds = products.Select(p => p.Id).ToList();
            var images = db.CfProductImages
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            LatestProductRepeater.DataSource = products
                .Select(p => new
                {
                    p.Id,
                    p.ProductName,
                    CategoryName = categoryLookup.ContainsKey(p.CategoryId)
                        ? categoryLookup[p.CategoryId].CategoryName
                        : "-",
                    SeoSlug = GetSlug(slugLookup, "Product", p.Id),
                    ImageUrl = GetPrimaryImage(images, p.Id),
                    PriceLabel = GetPriceLabel(variants, p.Id)
                })
                .ToList();
            LatestProductRepeater.DataBind();
        }
    }

    private static string GetSlug(System.Collections.Generic.Dictionary<string, System.Collections.Generic.Dictionary<int, string>> lookup, string entityType, int entityId)
    {
        if (!lookup.ContainsKey(entityType))
        {
            return string.Empty;
        }

        var entityLookup = lookup[entityType];
        return entityLookup.ContainsKey(entityId) ? entityLookup[entityId] : string.Empty;
    }

    public class CategoryMenuItem
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public System.Collections.Generic.List<CategoryMenuItem> Children { get; set; }
        public int ChildCount
        {
            get { return Children != null ? Children.Count : 0; }
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

    private static string GetPrimaryImage(System.Collections.Generic.List<CfProductImage> images, int productId)
    {
        var primary = images.FirstOrDefault(i => i.ProductId == productId && i.IsPrimary);
        if (primary != null)
        {
            return primary.ImageUrl;
        }

        var fallback = images.FirstOrDefault(i => i.ProductId == productId);
        return fallback != null ? fallback.ImageUrl : "/images/fav.png";
    }

    public string GetMenuItemClass(object childCount)
    {
        int count = 0;
        if (childCount != null)
        {
            int.TryParse(childCount.ToString(), out count);
        }
        return count > 0 ? "has-children" : string.Empty;
    }

    private static string GetPriceLabel(System.Collections.Generic.List<CfProductVariant> variants, int productId)
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
}

