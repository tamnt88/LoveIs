using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
public partial class CustomerWishlistPage : CustomerPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindWishlist();
        }
    }
    private void BindWishlist()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }
        using (var db = new BeautyStoryContext())
        {
            var wishlist = db.CfWishlists.AsNoTracking()
                .Where(w => w.CustomerId == customerId.Value && w.Status)
                .OrderByDescending(w => w.CreatedAt)
                .ToList();
            if (wishlist.Count == 0)
            {
                EmptyPanel.Visible = true;
                WishlistRepeater.DataSource = null;
                WishlistRepeater.DataBind();
                return;
            }
            var productIds = wishlist.Select(w => w.ProductId).Distinct().ToList();
            var products = db.CfProducts.AsNoTracking()
                .Where(p => productIds.Contains(p.Id))
                .ToList();
            var images = db.CfProductImages.AsNoTracking()
                .Where(i => productIds.Contains(i.ProductId) && i.Status)
                .ToList();
            var slugs = db.CfSeoSlugs.AsNoTracking()
                .Where(s => s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();
            var imageLookup = images
                .GroupBy(i => i.ProductId)
                .ToDictionary(
                    g => g.Key,
                    g => g.OrderByDescending(i => i.IsPrimary).ThenBy(i => i.SortOrder).Select(i => i.ImageUrl).FirstOrDefault());
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);
            var variantLookup = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(g => g.Key, g => g.ToList());
            var items = products.Select(p =>
            {
                var list = variantLookup.ContainsKey(p.Id) ? variantLookup[p.Id] : new List<CfProductVariant>();
                var priceHtml = list.Count > 0 ? BuildPriceHtml(list) : "Contact";
                return new
                {
                    ProductId = p.Id,
                    ProductName = p.ProductName,
                    SeoSlug = slugLookup.ContainsKey(p.Id) ? slugLookup[p.Id] : string.Empty,
                    ImageUrl = imageLookup.ContainsKey(p.Id) ? imageLookup[p.Id] : "/images/fav.png",
                    PriceHtml = priceHtml
                };
            }).ToList();
            EmptyPanel.Visible = false;
            WishlistRepeater.DataSource = items;
            WishlistRepeater.DataBind();
        }
    }
    protected void WishlistRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "remove")
        {
            return;
        }
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }
        int productId;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out productId))
        {
            return;
        }
        using (var db = new BeautyStoryContext())
        {
            var item = db.CfWishlists.FirstOrDefault(w => w.CustomerId == customerId.Value && w.ProductId == productId);
            if (item != null)
            {
                db.CfWishlists.Remove(item);
                db.SaveChanges();
            }
        }
        BindWishlist();
    }
    private static string BuildPriceHtml(List<CfProductVariant> variants)
    {
        var saleVariant = variants
            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();
        var variant = saleVariant ?? variants.OrderBy(v => v.Price).FirstOrDefault();
        if (variant == null)
        {
            return "Contact";
        }
        if (variant.SalePrice.HasValue && variant.SalePrice.Value > 0 && variant.SalePrice.Value < variant.Price)
        {
            return string.Format("<span class=\"price-original\">{0:N0} d</span> <span class=\"price-sale\">{1:N0} d</span>", variant.Price, variant.SalePrice.Value);
        }
        return string.Format("{0:N0} d", variant.Price);
    }
}
