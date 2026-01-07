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
        AddVariantWithResult(variantId, quantity);
    }

    public static int AddVariantWithResult(int variantId, int quantity)
    {
        if (variantId <= 0 || quantity <= 0)
        {
            return 0;
        }

        var cart = GetCart();
        var limit = GetOrderLimit();
        var maxItemsPerOrder = limit != null ? limit.MaxItemsPerOrder : int.MaxValue;
        var maxQtyPerItem = limit != null ? limit.MaxQtyPerItem : int.MaxValue;
        var currentTotalQty = cart.Sum(x => x.Quantity);

        var existing = cart.FirstOrDefault(x => x.VariantId == variantId);
        if (existing != null)
        {
            var allowedPerItem = Math.Max(0, maxQtyPerItem - existing.Quantity);
            var allowedByTotal = Math.Max(0, maxItemsPerOrder - (currentTotalQty - existing.Quantity));
            var addQty = Math.Min(quantity, Math.Min(allowedPerItem, allowedByTotal));
            if (addQty <= 0)
            {
                return 0;
            }

            existing.Quantity += addQty;
            IncrementAddToCartCount(variantId, addQty);
            return addQty;
        }

        var allowedByTotalNew = Math.Max(0, maxItemsPerOrder - currentTotalQty);
        var addQuantity = Math.Min(quantity, Math.Min(maxQtyPerItem, allowedByTotalNew));
        if (addQuantity <= 0)
        {
            return 0;
        }

        cart.Add(new CartItem { VariantId = variantId, Quantity = addQuantity });
        IncrementAddToCartCount(variantId, addQuantity);
        return addQuantity;
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
        var limit = GetOrderLimit();
        var maxItemsPerOrder = limit != null ? limit.MaxItemsPerOrder : int.MaxValue;
        var maxQtyPerItem = limit != null ? limit.MaxQtyPerItem : int.MaxValue;
        var remaining = maxItemsPerOrder;

        foreach (var item in cart.ToList())
        {
            if (!quantities.ContainsKey(item.VariantId))
            {
                continue;
            }

            var desired = Math.Max(1, quantities[item.VariantId]);
            var allowed = Math.Min(desired, maxQtyPerItem);
            allowed = Math.Min(allowed, remaining);
            item.Quantity = allowed;
            remaining -= allowed;
        }

        cart.RemoveAll(x => x.Quantity <= 0);
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

    public static CfCustomerOrderLimit GetOrderLimitForCustomer()
    {
        return GetOrderLimit();
    }

    public class CartItem
    {
        public int VariantId { get; set; }
        public int Quantity { get; set; }
    }

    private static CfCustomerOrderLimit GetOrderLimit()
    {
        try
        {
            using (var db = new BeautyStoryContext())
            {
                var tiers = db.CfCustomerOrderLimits
                    .Where(l => l.Status)
                    .OrderBy(l => l.MinTotalSpent)
                    .ToList();
                if (tiers.Count == 0)
                {
                    return null;
                }

                var customerId = CustomerAuth.GetCustomerId();
                if (!customerId.HasValue)
                {
                    return tiers.First();
                }

                var completedStatusId = db.CfOrderStatuses
                    .Where(s => s.Code == "COMPLETED")
                    .Select(s => s.Id)
                    .FirstOrDefault();

                var totalSpent = db.CfOrders
                    .Where(o => o.CustomerId == customerId.Value && o.Status && o.OrderStatusId == completedStatusId)
                    .Select(o => (decimal?)o.Total)
                    .Sum() ?? 0m;

                var tier = tiers
                    .FirstOrDefault(t => totalSpent >= t.MinTotalSpent && (!t.MaxTotalSpent.HasValue || totalSpent < t.MaxTotalSpent.Value));

                return tier ?? tiers.Last();
            }
        }
        catch
        {
            return null;
        }
    }
}
