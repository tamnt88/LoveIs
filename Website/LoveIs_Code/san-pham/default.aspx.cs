using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;

public partial class ProductDefault : System.Web.UI.Page
{
    public string MainImageUrl { get; set; }
    public string ProductName { get; set; }
    public string VariantPriceJson { get; set; }
    public string VariantIdJson { get; set; }
    public string VariantSkuJson { get; set; }
    public string ProductSeoSlug { get; set; }
    public string BrandName { get; set; }

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
            var allCategories = db.CfCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            var slugs = db.CfSeoSlugs.ToList();
            var slugLookup = slugs
                .GroupBy(s => s.EntityType)
                .ToDictionary(
                    g => g.Key,
                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            string slug = GetSlugFromRequest();
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
            var viewedKey = "viewed_product_" + product.Id;
            if (Session[viewedKey] == null)
            {
                product.ViewCount += 1;
                Session[viewedKey] = true;
                db.SaveChanges();
            }
            }

            ProductName = product.ProductName;
            ProductNameLiteral.Text = product.ProductName;
            ProductSeoSlug = GetSlug(slugLookup, "Product", product.Id);

            var brandName = string.Empty;
            var brandSlug = string.Empty;
            if (product.BrandId > 0)
            {
                var brand = db.CfBrands.FirstOrDefault(b => b.Id == product.BrandId);
                if (brand != null)
                {
                    brandName = brand.BrandName;
                    brandSlug = GetSlug(slugLookup, "Brand", brand.Id);
                }
            }

            SupplierLink.Text = string.IsNullOrWhiteSpace(brandName) ? "Nhà cung cấp" : brandName;
            SupplierLink.NavigateUrl = string.IsNullOrWhiteSpace(brandSlug) ? "#" : "/thuong-hieu/" + brandSlug;
            BrandName = brandName;

            var originName = string.Empty;
            var originSlug = string.Empty;
            if (product.OriginId > 0)
            {
                var origin = db.CfOrigins.FirstOrDefault(o => o.Id == product.OriginId);
                if (origin != null)
                {
                    originName = origin.OriginName;
                    originSlug = GetSlug(slugLookup, "Origin", origin.Id);
                }
            }

            OriginLink.Text = string.IsNullOrWhiteSpace(originName) ? "Xuất xứ" : originName;
            OriginLink.NavigateUrl = string.IsNullOrWhiteSpace(originSlug) ? "#" : "/xuat-xu/" + originSlug;

            var shopName = string.Empty;
            var shopCode = string.Empty;
            if (product.ShopId.HasValue && product.ShopId.Value > 0)
            {
                var shop = db.CfShops.FirstOrDefault(s => s.Id == product.ShopId.Value);
                if (shop != null)
                {
                    shopName = shop.ShopName;
                    shopCode = shop.ShopCode;
                }
            }

            ShopLink.Text = string.IsNullOrWhiteSpace(shopName) ? "Cua hang" : shopName;
            ShopLink.NavigateUrl = string.IsNullOrWhiteSpace(shopCode) ? "#" : "/cua-hang/" + shopCode;
            ShopViewLink.Text = "Xem cua hang";
            ShopViewLink.NavigateUrl = ShopLink.NavigateUrl;

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

            BindSeoMeta(product, slug, variants, BrandName);

            PriceLiteral.Text = variants.Any() ? GetDisplayPriceHtml(variants) : "Liên hệ";

            var defaultVariant = GetDefaultVariant(variants);
            SkuLiteral.Text = defaultVariant != null && !string.IsNullOrWhiteSpace(defaultVariant.Sku) ? defaultVariant.Sku : "-";
            if (defaultVariant != null)
            {
                SelectedVariantId.Value = defaultVariant.Id.ToString();
            }

            CategoryPath.Text = BuildCategoryPath(allCategories, product.CategoryId, slugLookup);

            BindRelatedProducts(db, product, slugLookup);
            BindSuggestedProducts(db, product.Id, slugLookup);
        }
    }

    private void BindRelatedProducts(BeautyStoryContext db, CfProduct product, Dictionary<string, Dictionary<int, string>> slugLookup)
    {
        var relatedCategory = db.CfProducts
            .Where(p => p.Status && p.Id != product.Id && p.CategoryId == product.CategoryId)
            .OrderBy(p => Guid.NewGuid())
            .Take(5)
            .ToList();

        var relatedBrand = new List<CfProduct>();
        if (product.BrandId.HasValue && product.BrandId.Value > 0)
        {
            relatedBrand = db.CfProducts
                .Where(p => p.Status && p.Id != product.Id && p.BrandId == product.BrandId.Value)
                .OrderBy(p => Guid.NewGuid())
                .Take(5)
                .ToList();
        }

        RelatedRepeater.DataSource = BuildRelatedViewModels(db, relatedCategory, slugLookup);
        RelatedRepeater.DataBind();

        BrandRelatedRepeater.DataSource = BuildRelatedViewModels(db, relatedBrand, slugLookup);
        BrandRelatedRepeater.DataBind();
    }

    private List<RelatedProductItem> BuildRelatedViewModels(BeautyStoryContext db, List<CfProduct> products, Dictionary<string, Dictionary<int, string>> slugLookup)
    {
        if (products == null || products.Count == 0)
        {
            return new List<RelatedProductItem>();
        }

        var productIds = products.Select(p => p.Id).ToList();

        var images = db.CfProductImages
            .Where(i => i.Status && productIds.Contains(i.ProductId))
            .OrderByDescending(i => i.IsPrimary)
            .ThenBy(i => i.SortOrder)
            .ThenByDescending(i => i.Id)
            .ToList()
            .GroupBy(i => i.ProductId)
            .ToDictionary(g => g.Key, g => g.First().ImageUrl);

        var variants = db.CfProductVariants
            .Where(v => v.Status && productIds.Contains(v.ProductId))
            .OrderBy(v => v.SortOrder)
            .ThenBy(v => v.Price)
            .ToList()
            .GroupBy(v => v.ProductId)
            .ToDictionary(g => g.Key, g => g.ToList());

        var items = new List<RelatedProductItem>();
        foreach (var product in products)
        {
            var slug = GetSlug(slugLookup, "Product", product.Id);
            var url = string.IsNullOrWhiteSpace(slug) ? "#" : string.Format("/san-pham/{0}", slug);
            var imageUrl = images.ContainsKey(product.Id) ? images[product.Id] : "/images/fav.png";
            var variantList = variants.ContainsKey(product.Id) ? variants[product.Id] : new List<CfProductVariant>();
            var priceHtml = variantList.Any() ? GetDisplayPriceHtml(variantList) : "Liên hệ";
            var saleBadge = BuildSaleBadgeHtml(variantList);

            items.Add(new RelatedProductItem
            {
                ProductName = product.ProductName,
                Url = url,
                ImageUrl = imageUrl,
                PriceHtml = priceHtml,
                SaleBadge = saleBadge
            });
        }

        return items;
    }

    private void BindSuggestedProducts(BeautyStoryContext db, int productId, Dictionary<string, Dictionary<int, string>> slugLookup)
    {
        var suggested = db.CfProducts
            .Where(p => p.Status && p.Id != productId)
            .OrderBy(p => Guid.NewGuid())
            .Take(15)
            .ToList();

        SuggestedRepeater.DataSource = BuildRelatedViewModels(db, suggested, slugLookup);
        SuggestedRepeater.DataBind();
    }

    private static string BuildSaleBadgeHtml(List<CfProductVariant> variants)
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

    private class RelatedProductItem
    {
        public string ProductName { get; set; }
        public string ImageUrl { get; set; }
        public string Url { get; set; }
        public string PriceHtml { get; set; }
        public string SaleBadge { get; set; }
    }

    private void BindSeoMeta(CfProduct product, string slug, List<CfProductVariant> variants, string brandName)
    {
        string title = !string.IsNullOrWhiteSpace(product.SeoTitle) ? product.SeoTitle : product.ProductName;
        string description = !string.IsNullOrWhiteSpace(product.SeoDescription)
            ? product.SeoDescription
            : BuildFallbackDescription(product);
        string keywords = product.SeoKeywords ?? string.Empty;
        string canonical = !string.IsNullOrWhiteSpace(product.CanonicalUrl)
            ? product.CanonicalUrl
            : string.Format("/san-pham/{0}", string.IsNullOrWhiteSpace(ProductSeoSlug) ? slug : ProductSeoSlug);
        string robots = !string.IsNullOrWhiteSpace(product.Robots) ? product.Robots : "index,follow";

        string ogTitle = !string.IsNullOrWhiteSpace(product.OgTitle) ? product.OgTitle : title;
        string ogDescription = !string.IsNullOrWhiteSpace(product.OgDescription) ? product.OgDescription : description;
        string ogImage = !string.IsNullOrWhiteSpace(product.OgImage) ? product.OgImage : MainImageUrl;
        string ogType = !string.IsNullOrWhiteSpace(product.OgType) ? product.OgType : "product";

        string twitterTitle = !string.IsNullOrWhiteSpace(product.TwitterTitle) ? product.TwitterTitle : title;
        string twitterDescription = !string.IsNullOrWhiteSpace(product.TwitterDescription) ? product.TwitterDescription : description;
        string twitterImage = !string.IsNullOrWhiteSpace(product.TwitterImage) ? product.TwitterImage : ogImage;

        SeoTitleLiteral.Text = (title) + " | LoveIs Store";//HttpUtility.HtmlEncode(title) + " | LoveIs Store";

        SeoMetaLiteral.Text = string.Format(
            "<meta name=\"description\" content=\"{0}\" />\n<meta name=\"keywords\" content=\"{1}\" />\n<meta name=\"robots\" content=\"{2}\" />\n<link rel=\"canonical\" href=\"{3}\" />\n",
            HttpUtility.HtmlAttributeEncode(description),
            HttpUtility.HtmlAttributeEncode(keywords),
            HttpUtility.HtmlAttributeEncode(robots),
            HttpUtility.HtmlAttributeEncode(canonical));

        SocialMetaLiteral.Text = string.Format(
            "<meta property=\"og:title\" content=\"{0}\" />\n<meta property=\"og:description\" content=\"{1}\" />\n<meta property=\"og:image\" content=\"{2}\" />\n<meta property=\"og:type\" content=\"{3}\" />\n<meta property=\"og:url\" content=\"{4}\" />\n<meta name=\"twitter:card\" content=\"summary_large_image\" />\n<meta name=\"twitter:title\" content=\"{5}\" />\n<meta name=\"twitter:description\" content=\"{6}\" />\n<meta name=\"twitter:image\" content=\"{7}\" />\n",
            HttpUtility.HtmlAttributeEncode(ogTitle),
            HttpUtility.HtmlAttributeEncode(ogDescription),
            HttpUtility.HtmlAttributeEncode(ogImage),
            HttpUtility.HtmlAttributeEncode(ogType),
            HttpUtility.HtmlAttributeEncode(canonical),
            HttpUtility.HtmlAttributeEncode(twitterTitle),
            HttpUtility.HtmlAttributeEncode(twitterDescription),
            HttpUtility.HtmlAttributeEncode(twitterImage));

        SchemaLiteral.Text = BuildProductSchema(product, canonical, ogImage, variants, brandName);
    }

    private string BuildProductSchema(CfProduct product, string canonical, string imageUrl, List<CfProductVariant> variants, string brandName)
    {
        var offerVariant = GetDefaultVariant(variants) ?? variants.FirstOrDefault();
        decimal? price = null;
        if (offerVariant != null)
        {
            price = offerVariant.SalePrice.HasValue && offerVariant.SalePrice.Value > 0 && offerVariant.SalePrice.Value < offerVariant.Price
                ? offerVariant.SalePrice.Value
                : offerVariant.Price;
        }

        var schema = new
        {
            @context = "https://schema.org",
            @type = "Product",
            name = product.ProductName,
            image = string.IsNullOrWhiteSpace(imageUrl) ? null : imageUrl,
            description = BuildFallbackDescription(product),
            sku = offerVariant != null ? offerVariant.Sku : string.Empty,
            brand = new
            {
                @type = "Brand",
                name = brandName ?? string.Empty
            },
            offers = new
            {
                @type = "Offer",
                url = canonical,
                priceCurrency = "VND",
                price = price.HasValue ? price.Value.ToString("0.##") : string.Empty,
                availability = price.HasValue ? "https://schema.org/InStock" : "https://schema.org/OutOfStock"
            }
        };

        var json = new JavaScriptSerializer().Serialize(schema);
        return "<script type=\"application/ld+json\">" + json + "</script>";
    }

    private static string BuildFallbackDescription(CfProduct product)
    {
        string source = !string.IsNullOrWhiteSpace(product.ShortDescription)
            ? product.ShortDescription
            : product.Description;
        if (string.IsNullOrWhiteSpace(source))
        {
            return product.ProductName ?? string.Empty;
        }

        string plain = Regex.Replace(source, "<.*?>", string.Empty);
        plain = HttpUtility.HtmlDecode(plain);
        return plain.Length > 200 ? plain.Substring(0, 200) : plain;
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
            return string.Format("<a href=\"/danh-muc/{0}\">{1}</a>", slug, c.CategoryName);
        });

        var homeLink = "<a href=\"/\">Trang chủ</a>";
        return homeLink + " <span class=\"sep\">/</span> " + string.Join(" <span class=\"sep\">/</span> ", links);
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

    private static string FormatPriceHtml(CfProductVariant variant)
    {
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

    private static string GetDisplayPriceHtml(List<CfProductVariant> variants)
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
        return FormatPriceHtml(variant);
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
        var variantSkuMap = new Dictionary<string, string>();
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
                    variantPriceMap[key] = FormatPriceHtml(variant);
                    variantIdMap[key] = variant.Id;
                    variantSkuMap[key] = string.IsNullOrWhiteSpace(variant.Sku) ? "-" : variant.Sku;
                }
            }
        }

        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        VariantPriceJson = serializer.Serialize(variantPriceMap);
        VariantIdJson = serializer.Serialize(variantIdMap);
        VariantSkuJson = serializer.Serialize(variantSkuMap);
    }

    protected void AddToCartButton_Click(object sender, EventArgs e)
    {
        int variantId = 0;
        if (!string.IsNullOrWhiteSpace(SelectedVariantId.Value))
        {
            int.TryParse(SelectedVariantId.Value, out variantId);
        }

        int quantity = 1;
        if (!string.IsNullOrWhiteSpace(SelectedQuantity.Value))
        {
            int.TryParse(SelectedQuantity.Value, out quantity);
        }
        if (quantity < 1)
        {
            quantity = 1;
        }
        if (quantity > 99)
        {
            quantity = 99;
        }

        if (variantId > 0)
        {
            CartService.AddVariant(variantId, quantity);
            using (var db = new BeautyStoryContext())
            {
                var productId = db.CfProductVariants
                    .Where(v => v.Id == variantId)
                    .Select(v => v.ProductId)
                    .FirstOrDefault();
                if (productId > 0)
                {
                    var product = db.CfProducts.FirstOrDefault(p => p.Id == productId);
                    if (product != null)
                    {
                        product.AddToCartCount += quantity;
                        db.SaveChanges();
                    }
                }
            }
            Response.Redirect("/gio-hang");
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

    private string GetSlugFromRequest()
    {
        var routeSlug = Page.RouteData.Values["slug"] as string;
        if (!string.IsNullOrWhiteSpace(routeSlug))
        {
            return routeSlug.Trim();
        }
        return (Request.QueryString["slug"] ?? string.Empty).Trim();
    }
}

