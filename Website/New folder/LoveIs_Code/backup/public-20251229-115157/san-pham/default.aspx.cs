using System;
using System.Collections.Generic;
using System.Linq;

public partial class ProductDefault : System.Web.UI.Page
{
    public string MainImageUrl { get; set; }
    public string ProductName { get; set; }
    public string VariantPriceJson { get; set; }
    public string VariantIdJson { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProductPage();
        }
    }

    private void BindProductPage()
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

            string slug = (Request.QueryString["slug"] ?? string.Empty).Trim();
            int productId = ResolveProductId(slugLookup, slug);
            if (productId == 0)
            {
                ProductNameLiteral.Text = "Không tìm thấy sản phẩm";
                return;
            }

            var product = db.CfProducts.FirstOrDefault(p => p.Id == productId);
            if (product == null)
            {
                ProductNameLiteral.Text = "Không tìm thấy sản phẩm";
                return;
            }

            ProductName = product.ProductName;
            ProductNameLiteral.Text = product.ProductName;
            ShortDescription.Text = string.IsNullOrWhiteSpace(product.ShortDescription) ? "Đang cập nhật." : product.ShortDescription;
            Description.Text = string.IsNullOrWhiteSpace(product.Description) ? "Đang cập nhật." : product.Description;
            Specification.Text = string.IsNullOrWhiteSpace(product.Specification) ? "Đang cập nhật." : product.Specification;
            Ingredients.Text = string.IsNullOrWhiteSpace(product.Ingredients) ? "Đang cập nhật." : product.Ingredients;
            Usage.Text = string.IsNullOrWhiteSpace(product.Usage) ? "Đang cập nhật." : product.Usage;

            var variants = db.CfProductVariants
                .Where(v => v.ProductId == product.Id && v.Status)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.Price)
                .ToList();

            BindVariantAttributes(db, variants);

            var images = db.CfProductImages
                .Where(i => i.ProductId == product.Id && i.Status)
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .ThenByDescending(i => i.Id)
                .ToList();

            MainImageUrl = images.FirstOrDefault() != null ? images.FirstOrDefault().ImageUrl : "/images/fav.png";
            var imageList = images.Select(i => new { i.ImageUrl, AltText = string.IsNullOrWhiteSpace(i.AltText) ? product.ProductName : i.AltText }).ToList();
            ImageRepeater.DataSource = imageList;
            ImageRepeater.DataBind();
            ThumbRepeater.DataSource = imageList;
            ThumbRepeater.DataBind();

            PriceLiteral.Text = variants.Any() ? GetDisplayPrice(variants) : "Liên hệ";

            CategoryPath.Text = BuildCategoryPath(allCategories, product.CategoryId, slugLookup);
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

    private static string GetSlug(Dictionary<string, Dictionary<int, string>> lookup, string entityType, int entityId)
    {
        if (!lookup.ContainsKey(entityType))
        {
            return string.Empty;
        }

        var entityLookup = lookup[entityType];
        return entityLookup.ContainsKey(entityId) ? entityLookup[entityId] : string.Empty;
    }

    private static int ResolveProductId(Dictionary<string, Dictionary<int, string>> lookup, string slug)
    {
        if (!lookup.ContainsKey("Product"))
        {
            return 0;
        }

        var match = lookup["Product"].FirstOrDefault(kv => string.Equals(kv.Value, slug, StringComparison.OrdinalIgnoreCase));
        return match.Key;
    }

    private static string BuildCategoryPath(List<CfCategory> categories, int categoryId, Dictionary<string, Dictionary<int, string>> slugLookup)
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

        var links = path.Select(c =>
        {
            string slug = GetSlug(slugLookup, "Category", c.Id);
            return string.Format("<a href=\"/danh-muc/default.aspx?slug={0}\">{1}</a>", slug, c.CategoryName);
        });

        return string.Join(" <span class=\"sep\">/</span> ", links);
    }

    private static string FormatPrice(CfProductVariant variant)
    {
        if (variant == null)
        {
            return "Liên hệ";
        }
        var price = variant.SalePrice.HasValue ? variant.SalePrice.Value : variant.Price;
        return string.Format("{0:N0} đ", price);
    }

    private static string GetDisplayPrice(List<CfProductVariant> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return "Liên hệ";
        }

        var saleVariant = variants
            .Where(v => v.SalePrice.HasValue)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();

        var variant = saleVariant ?? variants.OrderBy(v => v.Price).First();
        return FormatPrice(variant);
    }

    private void BindVariantAttributes(BeautyStoryContext db, List<int> variantIds, Dictionary<int, int> defaultSelections)
    {
        var attrs = db.CfProductVariantAttributes
            .Where(pva => variantIds.Contains(pva.VariantId))
            .Select(pva => new
            {
                pva.VariantId,
                pva.AttributeId,
                pva.Attribute.AttributeName,
                pva.AttributeValueId,
                pva.AttributeValue.ValueName
            })
            .ToList();

        var groups = attrs
            .GroupBy(a => new { a.AttributeId, a.AttributeName })
            .Select(g => new
            {
                AttributeName = g.Key.AttributeName,
                Values = g
                    .GroupBy(x => new { x.AttributeValueId, x.ValueName })
                    .Select(x => new
                    {
                        AttributeId = g.Key.AttributeId,
                        ValueId = x.Key.AttributeValueId,
                        ValueName = x.Key.ValueName
                    })
                    .OrderBy(x => x.ValueName)
                    .Select((x, index) => new
                    {
                        x.AttributeId,
                        x.ValueId,
                        x.ValueName,
                        ActiveClass = defaultSelections != null && defaultSelections.ContainsKey(x.AttributeId)
                            ? (defaultSelections[x.AttributeId] == x.ValueId ? "active" : string.Empty)
                            : (index == 0 ? "active" : string.Empty)
                    })
                    .ToList()
            })
            .OrderBy(g => g.AttributeName)
            .ToList();

        VariantAttributeRepeater.DataSource = groups;
        VariantAttributeRepeater.DataBind();

        var variantPriceMap = new Dictionary<string, string>();
        var variantIdMap = new Dictionary<string, int>();
        foreach (var variantId in attrs.Select(a => a.VariantId).Distinct())
        {
            var parts = attrs
                .Where(a => a.VariantId == variantId)
                .Select(a => new { a.AttributeId, a.AttributeValueId })
                .OrderBy(a => a.AttributeId)
                .Select(a => string.Format("{0}:{1}", a.AttributeId, a.AttributeValueId));

            var key = string.Join("|", parts);
            if (!variantPriceMap.ContainsKey(key))
            {
                var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == variantId);
                if (variant != null)
                {
                    variantPriceMap[key] = FormatPrice(variant);
                    variantIdMap[key] = variant.Id;
                }
            }
        }

        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        VariantPriceJson = serializer.Serialize(variantPriceMap);
        VariantIdJson = serializer.Serialize(variantIdMap);
    }

    protected void AddToCartButton_Click(object sender, EventArgs e)
    {
        int variantId = 0;
        if (!string.IsNullOrWhiteSpace(SelectedVariantId.Value))
        {
            int.TryParse(SelectedVariantId.Value, out variantId);
        }

        if (variantId > 0)
        {
            CartService.AddVariant(variantId, 1);
            Response.Redirect("/gio-hang/default.aspx");
        }
    }

    private void BindVariantAttributes(BeautyStoryContext db, List<CfProductVariant> variants)
    {
        var ids = variants.Select(v => v.Id).ToList();
        var defaultSelections = new Dictionary<int, int>();
        var defaultVariant = GetDefaultVariant(variants);
        if (defaultVariant != null)
        {
            defaultSelections = db.CfProductVariantAttributes
                .Where(pva => pva.VariantId == defaultVariant.Id)
                .GroupBy(pva => pva.AttributeId)
                .Select(g => g.FirstOrDefault())
                .Where(pva => pva != null)
                .ToDictionary(pva => pva.AttributeId, pva => pva.AttributeValueId);
        }

        BindVariantAttributes(db, ids, defaultSelections);
    }

    private static CfProductVariant GetDefaultVariant(List<CfProductVariant> variants)
    {
        if (variants == null || variants.Count == 0)
        {
            return null;
        }

        var saleVariant = variants
            .Where(v => v.SalePrice.HasValue)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();

        return saleVariant ?? variants.OrderBy(v => v.Price).FirstOrDefault();
    }

    public class CategoryMenuItem
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public List<CategoryMenuItem> Children { get; set; }
    }
}
