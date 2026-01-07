using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;

public partial class CartDefault : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ApplySeo();
            BindCart();
        }
    }

    private void ApplySeo()
    {
        string canonical = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Path) : string.Empty;
        SystemPageSeoApplier.Apply("cart", SeoTitleLiteral, SeoMetaLiteral, "Giỏ hàng | LoveIs", canonical);
    }

    private void BindCart()
    {
        var cart = CartService.GetCart();
        var hasItems = cart.Count > 0;

        EmptyCartPanel.Visible = !hasItems;
        CartPanel.Visible = hasItems;
        if (CartSubtitle != null)
        {
            CartSubtitle.Visible = hasItems;
        }

        if (!hasItems)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var variantIds = cart.Select(c => c.VariantId).ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => variantIds.Contains(v.Id))
                .ToList();
            var productIds = variants.Select(v => v.ProductId).Distinct().ToList();
            var products = db.CfProducts.AsNoTracking()
                .Where(p => productIds.Contains(p.Id))
                .ToList();
            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var slugs = db.CfSeoSlugs.AsNoTracking()
               .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
               .ToList();
            var attributes = db.CfProductVariantAttributes.AsNoTracking()
                .Where(pva => variantIds.Contains(pva.VariantId))
                .ToList();
            var attributeIds = attributes.Select(a => a.AttributeId).Distinct().ToList();
            var valueIds = attributes.Select(a => a.AttributeValueId).Distinct().ToList();
            var attributeLookup = db.CfVariantAttributes.AsNoTracking()
                .Where(a => attributeIds.Contains(a.Id))
                .ToDictionary(a => a.Id, a => a.AttributeName);
            var valueLookup = db.CfVariantAttributeValues.AsNoTracking()
                .Where(v => valueIds.Contains(v.Id))
                .ToDictionary(v => v.Id, v => v.ValueName);
            var productSlugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);
            var productLookup = products.ToDictionary(p => p.Id, p => p);
            var variantLookup = variants.ToDictionary(v => v.Id, v => v);

            var imageLookup = new Dictionary<int, string>();
            foreach (var group in images.GroupBy(i => i.ProductId))
            {
                var primary = group.FirstOrDefault(i => i.IsPrimary);
                if (primary != null)
                {
                    imageLookup[group.Key] = primary.ImageUrl;
                    continue;
                }
                var fallback = group.FirstOrDefault();
                if (fallback != null)
                {
                    imageLookup[group.Key] = fallback.ImageUrl;
                }
            }

            var attributesByVariant = attributes
                .GroupBy(a => a.VariantId)
                .ToDictionary(g => g.Key, g => g.ToList());

            var shopIds = products
                .Where(p => p.ShopId.HasValue)
                .Select(p => p.ShopId.Value)
                .Distinct()
                .ToList();

            var shopLookup = db.CfShops.AsNoTracking()
                .Where(s => shopIds.Contains(s.Id))
                .ToList()
                .ToDictionary(s => s.Id, s => s);

            var lines = cart.Select(item =>
            {
                var variant = variantLookup.ContainsKey(item.VariantId) ? variantLookup[item.VariantId] : null;
                var product = variant != null && productLookup.ContainsKey(variant.ProductId) ? productLookup[variant.ProductId] : null;
                var price = GetEffectivePrice(variant);
                var lineTotal = price * item.Quantity;

                var attrs = new List<string>();
                if (attributesByVariant.ContainsKey(item.VariantId))
                {
                    foreach (var attr in attributesByVariant[item.VariantId])
                    {
                        var attrName = attributeLookup.ContainsKey(attr.AttributeId) ? attributeLookup[attr.AttributeId] : string.Empty;
                        var valueName = valueLookup.ContainsKey(attr.AttributeValueId) ? valueLookup[attr.AttributeValueId] : string.Empty;
                        attrs.Add(string.Format("{0}: {1}", attrName, valueName));
                    }
                }

                var shopId = product != null && product.ShopId.HasValue ? product.ShopId.Value : 0;
                var shop = shopLookup.ContainsKey(shopId) ? shopLookup[shopId] : null;

                return new CartLine
                {
                    VariantId = item.VariantId,
                    ProductName = product != null ? product.ProductName : "-",
                    SeoSlug = product != null && productSlugLookup.ContainsKey(product.Id) ? productSlugLookup[product.Id] : "",
                    ImageUrl = product != null && imageLookup.ContainsKey(product.Id) ? imageLookup[product.Id] : "/images/fav.png",
                    VariantText = attrs.Count > 0 ? string.Join(", ", attrs) : "Mặc định",
                    PriceHtml = BuildPriceHtml(variant),
                    Quantity = item.Quantity,
                    LineTotal = price > 0 ? FormatMoney(lineTotal) : "Liên hệ",
                    LineTotalValue = lineTotal,
                    ShopId = shopId,
                    ShopName = shop != null ? shop.ShopName : "Cửa hàng",
                    ShopUrl = shop != null && !string.IsNullOrWhiteSpace(shop.ShopCode) ? "/cua-hang/" + shop.ShopCode : "#"
                };
            }).ToList();

            var groups = lines
                .GroupBy(x => x.ShopId)
                .Select(g => new CartGroup
                {
                    ShopId = g.Key,
                    ShopName = g.FirstOrDefault() != null ? g.First().ShopName : "Cửa hàng",
                    ShopUrl = g.FirstOrDefault() != null ? g.First().ShopUrl : "#",
                    Items = g.ToList(),
                    Total = g.Sum(x => x.LineTotalValue)
                })
                .ToList();

            CartGroupRepeater.DataSource = groups;
            CartGroupRepeater.DataBind();

            var total = lines.Sum(x => x.LineTotalValue);
            CartTotalLiteral.Text = total > 0 ? FormatMoney(total) : "Liên hệ";
        }
    }

    protected void UpdateCartButton_Click(object sender, EventArgs e)
    {
        var quantities = new Dictionary<int, int>();
        foreach (RepeaterItem groupItem in CartGroupRepeater.Items)
        {
            var inner = groupItem.FindControl("CartItemRepeater") as Repeater;
            if (inner == null)
            {
                continue;
            }

            foreach (RepeaterItem item in inner.Items)
            {
                var variantField = item.FindControl("VariantIdField") as HiddenField;
                var qtyBox = item.FindControl("QtyTextBox") as TextBox;
                if (variantField == null || qtyBox == null)
                {
                    continue;
                }

                int variantId;
                int qty;
                if (int.TryParse(variantField.Value, out variantId) && int.TryParse(qtyBox.Text, out qty))
                {
                    quantities[variantId] = qty;
                }
            }
        }

        CartService.UpdateQuantities(quantities);
        BindCart();
    }

    protected void DeleteSelectedButton_Click(object sender, EventArgs e)
    {
        var selectedIds = new List<int>();
        foreach (RepeaterItem groupItem in CartGroupRepeater.Items)
        {
            var inner = groupItem.FindControl("CartItemRepeater") as Repeater;
            if (inner == null)
            {
                continue;
            }

            foreach (RepeaterItem item in inner.Items)
            {
                var checkbox = item.FindControl("SelectItemCheckBox") as CheckBox;
                var variantField = item.FindControl("VariantIdField") as HiddenField;
                if (checkbox == null || variantField == null)
                {
                    continue;
                }

                if (checkbox.Checked)
                {
                    int variantId;
                    if (int.TryParse(variantField.Value, out variantId))
                    {
                        selectedIds.Add(variantId);
                    }
                }
            }
        }

        foreach (var variantId in selectedIds.Distinct())
        {
            CartService.RemoveVariant(variantId);
        }

        BindCart();
    }

    protected void CartItemRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "remove")
        {
            int variantId;
            if (int.TryParse(Convert.ToString(e.CommandArgument), out variantId))
            {
                CartService.RemoveVariant(variantId);
                BindCart();
            }
        }
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private static string BuildPriceHtml(CfProductVariant variant)
    {
        if (variant == null)
        {
            return "Liên hệ";
        }

        var price = variant.Price;
        var sale = variant.SalePrice.HasValue ? variant.SalePrice.Value : 0;
        if (sale > 0 && sale < price)
        {
            return string.Format("<span class=\"price-original\">{0}</span><span class=\"price-sale\">{1}</span>", FormatMoney(price), FormatMoney(sale));
        }

        if (price > 0)
        {
            return FormatMoney(price);
        }

        return "Liên hệ";
    }

    private static decimal GetEffectivePrice(CfProductVariant variant)
    {
        if (variant == null)
        {
            return 0;
        }

        var price = variant.Price;
        var sale = variant.SalePrice.HasValue ? variant.SalePrice.Value : 0;
        if (sale > 0 && sale < price)
        {
            return sale;
        }

        return price > 0 ? price : 0;
    }

    private class CartLine
    {
        public int VariantId { get; set; }
        public string ProductName { get; set; }
        public string SeoSlug { get; set; }
        public string ImageUrl { get; set; }
        public string VariantText { get; set; }
        public string PriceHtml { get; set; }
        public int Quantity { get; set; }
        public string LineTotal { get; set; }
        public decimal LineTotalValue { get; set; }
        public int ShopId { get; set; }
        public string ShopName { get; set; }
        public string ShopUrl { get; set; }
    }

    private class CartGroup
    {
        public int ShopId { get; set; }
        public string ShopName { get; set; }
        public string ShopUrl { get; set; }
        public List<CartLine> Items { get; set; }
        public decimal Total { get; set; }
    }
}
