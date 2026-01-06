using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public static class CartService
{
    private const string CartSessionKey = "PUBLIC_CART";

    public static List<CartItem> GetCart()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return new List<CartItem>();
        }

        var cart = context.Session[CartSessionKey] as List<CartItem>;
        if (cart == null)
        {
            cart = new List<CartItem>();
            context.Session[CartSessionKey] = cart;
        }

        return cart;
    }

    public static void AddVariant(int variantId, int quantity)
    {
        if (variantId <= 0 || quantity <= 0)
        {
            return;
        }

        var cart = GetCart();
        var existing = cart.FirstOrDefault(x => x.VariantId == variantId);
        if (existing != null)
        {
            existing.Quantity += quantity;
            IncrementAddToCartCount(variantId, quantity);
            return;
        }

        cart.Add(new CartItem { VariantId = variantId, Quantity = quantity });
        IncrementAddToCartCount(variantId, quantity);
    }

    private static void IncrementAddToCartCount(int variantId, int quantity)
    {
        try
        {
            using (var db = new BeautyStoryContext())
            {
                var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == variantId);
                if (variant == null)
                {
                    return;
                }

                var product = db.CfProducts.FirstOrDefault(p => p.Id == variant.ProductId);
                if (product == null)
                {
                    return;
                }

                product.AddToCartCount += quantity;
                db.SaveChanges();
            }
        }
        catch
        {
        }
    }

    public static void UpdateQuantities(Dictionary<int, int> quantities)
    {
        var cart = GetCart();
        foreach (var item in cart)
        {
            if (quantities.ContainsKey(item.VariantId))
            {
                item.Quantity = Math.Max(1, quantities[item.VariantId]);
            }
        }
    }

    public static void RemoveVariant(int variantId)
    {
        var cart = GetCart();
        cart.RemoveAll(x => x.VariantId == variantId);
    }

    public static void ClearCart()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return;
        }

        context.Session[CartSessionKey] = new List<CartItem>();
    }

    public class CartItem
    {
        public int VariantId { get; set; }
        public int Quantity { get; set; }
    }
}
