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
        var stockQty = GetAvailableStock(variantId);
        if (stockQty <= 0)
        {
            return 0;
        }

        var existing = cart.FirstOrDefault(x => x.VariantId == variantId);
        if (existing != null)
        {
            var allowedPerItem = Math.Max(0, maxQtyPerItem - existing.Quantity);
            var allowedByTotal = Math.Max(0, maxItemsPerOrder - (currentTotalQty - existing.Quantity));
            var allowedByStock = Math.Max(0, stockQty - existing.Quantity);
            var addQty = Math.Min(quantity, Math.Min(allowedPerItem, Math.Min(allowedByTotal, allowedByStock)));
            if (addQty <= 0)
            {
                return 0;
            }

            existing.Quantity += addQty;
            IncrementAddToCartCount(variantId, addQty);
            return addQty;
        }

        var allowedByTotalNew = Math.Max(0, maxItemsPerOrder - currentTotalQty);
        var addQuantity = Math.Min(quantity, Math.Min(maxQtyPerItem, Math.Min(allowedByTotalNew, stockQty)));
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
        var stockLookup = GetStockLookup(cart.Select(x => x.VariantId));

        foreach (var item in cart.ToList())
        {
            if (!quantities.ContainsKey(item.VariantId))
            {
                continue;
            }

            var desired = Math.Max(1, quantities[item.VariantId]);
            var allowed = Math.Min(desired, maxQtyPerItem);
            allowed = Math.Min(allowed, remaining);
            if (stockLookup.ContainsKey(item.VariantId))
            {
                allowed = Math.Min(allowed, stockLookup[item.VariantId]);
            }
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

    public static void RemoveVariants(IEnumerable<int> variantIds)
    {
        if (variantIds == null)
        {
            return;
        }

        var ids = variantIds.Where(id => id > 0).Distinct().ToList();
        if (ids.Count == 0)
        {
            return;
        }

        var cart = GetCart();
        cart.RemoveAll(item => ids.Contains(item.VariantId));
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

    private static int GetAvailableStock(int variantId)
    {
        if (variantId <= 0)
        {
            return 0;
        }

        try
        {
            using (var db = new BeautyStoryContext())
            {
                var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == variantId);
                if (variant == null || !variant.Status)
                {
                    return 0;
                }

                var effectivePrice = GetEffectivePrice(variant.Price, variant.SalePrice);
                if (effectivePrice <= 0)
                {
                    return 0;
                }

                return Math.Max(0, variant.StockQty);
            }
        }
        catch
        {
            return 0;
        }
    }

    private static Dictionary<int, int> GetStockLookup(IEnumerable<int> variantIds)
    {
        var result = new Dictionary<int, int>();
        var ids = variantIds != null ? variantIds.Distinct().ToList() : new List<int>();
        if (ids.Count == 0)
        {
            return result;
        }

        try
        {
            using (var db = new BeautyStoryContext())
            {
                var variants = db.CfProductVariants
                    .Where(v => ids.Contains(v.Id))
                    .Select(v => new { v.Id, v.StockQty, v.Status, v.Price, v.SalePrice })
                    .ToList();

                foreach (var variant in variants)
                {
                    var effectivePrice = GetEffectivePrice(variant.Price, variant.SalePrice);
                    result[variant.Id] = variant.Status && effectivePrice > 0
                        ? Math.Max(0, variant.StockQty)
                        : 0;
                }
            }
        }
        catch
        {
        }

        return result;
    }

    private static decimal GetEffectivePrice(decimal price, decimal? salePrice)
    {
        if (salePrice.HasValue && salePrice.Value > 0 && salePrice.Value < price)
        {
            return salePrice.Value;
        }

        return price > 0 ? price : 0;
    }
}
