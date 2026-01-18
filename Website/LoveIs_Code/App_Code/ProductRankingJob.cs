
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

public static class ProductRankingJob
{
    public static void RebuildAll()
    {
        var since = DateTime.Now.AddDays(-30);

        using (var db = new BeautyStoryContext())
        {
            var variants = db.CfProductVariants
                .Where(v => v.Status)
                .Select(v => new
                {
                    v.ProductId,
                    v.StockQty,
                    v.Price,
                    v.SalePrice
                })
                .ToList();

            var variantGroups = variants
                .GroupBy(v => v.ProductId)
                .ToDictionary(g => g.Key, g => g.ToList());

            var orderItems = db.CfOrderItems
                .Where(i => i.Status)
                .Select(i => new { i.Id, i.ProductId, i.Quantity, i.OrderId })
                .ToList();

            var orders = db.CfOrders
                .Where(o => o.Status && o.CreatedAt >= since)
                .Select(o => new { o.Id, o.CreatedAt, o.OrderStatus })
                .ToList();

            var orderLookup = orders.ToDictionary(o => o.Id, o => o);

            var soldQty30d = new Dictionary<int, int>();
            var cancelQty30d = new Dictionary<int, int>();

            foreach (var item in orderItems)
            {
                if (!orderLookup.ContainsKey(item.OrderId))
                {
                    continue;
                }

                var order = orderLookup[item.OrderId];
                var isCancelled = IsCancelledStatus(order.OrderStatus);

                if (isCancelled)
                {
                    cancelQty30d[item.ProductId] = (cancelQty30d.ContainsKey(item.ProductId) ? cancelQty30d[item.ProductId] : 0) + item.Quantity;
                }
                else
                {
                    soldQty30d[item.ProductId] = (soldQty30d.ContainsKey(item.ProductId) ? soldQty30d[item.ProductId] : 0) + item.Quantity;
                }
            }

            var returnItems = db.CfReturnItems
                .Where(r => r.Status)
                .Select(r => new { r.ReturnRequestId, r.OrderItemId, r.Quantity })
                .ToList();

            var returnRequests = db.CfReturnRequests
                .Where(r => !string.IsNullOrWhiteSpace(r.Status) && r.CreatedAt >= since)
                .Select(r => new { r.Id })
                .ToList();

            var returnRequestIds = new HashSet<int>(returnRequests.Select(r => r.Id));
            var orderItemLookup = orderItems.ToDictionary(i => i.Id, i => i);
            var returnQty30d = new Dictionary<int, int>();

            foreach (var ret in returnItems)
            {
                if (!returnRequestIds.Contains(ret.ReturnRequestId))
                {
                    continue;
                }

                if (!orderItemLookup.ContainsKey(ret.OrderItemId))
                {
                    continue;
                }

                var productId = orderItemLookup[ret.OrderItemId].ProductId;
                returnQty30d[productId] = (returnQty30d.ContainsKey(productId) ? returnQty30d[productId] : 0) + ret.Quantity;
            }

            var products = db.CfProducts.ToList();
            var images = db.CfProductImages
                .Where(i => i.Status)
                .Select(i => new { i.ProductId, i.Id })
                .ToList();
            var imageCountLookup = images
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.Count());

            foreach (var product in products)
            {
                var hasVariants = variantGroups.ContainsKey(product.Id);
                var productVariants = hasVariants ? variantGroups[product.Id] : null;

                if (productVariants != null)
                {
                    product.StockTotal = productVariants.Sum(v => v.StockQty);

                    var maxDiscount = productVariants
                        .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
                        .Select(v => (v.Price - v.SalePrice.Value) / v.Price)
                        .DefaultIfEmpty(0m)
                        .Max();
                    product.MaxDiscountPercent = maxDiscount;
                }
                else
                {
                    product.StockTotal = 0;
                    product.MaxDiscountPercent = 0m;
                }

                var sold = soldQty30d.ContainsKey(product.Id) ? soldQty30d[product.Id] : 0;
                var cancelled = cancelQty30d.ContainsKey(product.Id) ? cancelQty30d[product.Id] : 0;
                var returned = returnQty30d.ContainsKey(product.Id) ? returnQty30d[product.Id] : 0;

                product.CancelRate30d = (sold + cancelled) > 0 ? (decimal)cancelled / (sold + cancelled) : 0m;
                product.ReturnRate30d = sold > 0 ? (decimal)returned / sold : 0m;

                // ViewCount30d requires view logs; fall back to total views for now.
                product.ViewCount30d = product.ViewCount;

                var imageCount = imageCountLookup.ContainsKey(product.Id) ? imageCountLookup[product.Id] : 0;
                var variantCount = productVariants != null ? productVariants.Count : 0;
                product.ContentScore = CalculateContentScore(product, imageCount, variantCount);
            }

            db.SaveChanges();
        }
    }

    private static bool IsCancelledStatus(string status)
    {
        if (string.IsNullOrWhiteSpace(status))
        {
            return false;
        }

        var value = status.Trim().ToLowerInvariant();
        return value.Contains("cancel") || value.Contains("huy");
    }

    private static int CalculateContentScore(CfProduct product, int imageCount, int variantCount)
    {
        if (product == null)
        {
            return 0;
        }

        var score = 0;
        var shortDesc = StripHtml(product.ShortDescription);
        var desc = StripHtml(product.Description);
        var spec = StripHtml(product.Specification);

        if (shortDesc.Length >= 50) score += 5;
        if (shortDesc.Length >= 120) score += 5;
        if (desc.Length >= 200) score += 10;
        if (desc.Length >= 500) score += 10;
        if (spec.Length >= 100) score += 8;

        if (!string.IsNullOrWhiteSpace(product.Ingredients)) score += 4;
        if (!string.IsNullOrWhiteSpace(product.Usage)) score += 4;

        if (!string.IsNullOrWhiteSpace(product.SeoTitle)) score += 5;
        if (!string.IsNullOrWhiteSpace(product.SeoDescription)) score += 5;
        if (!string.IsNullOrWhiteSpace(product.SeoKeywords)) score += 5;

        if (!string.IsNullOrWhiteSpace(product.OgImage)) score += 4;
        if (!string.IsNullOrWhiteSpace(product.TwitterImage)) score += 4;

        if (imageCount >= 3) score += 8;
        if (imageCount >= 6) score += 4;

        if (variantCount >= 2) score += 4;
        if (variantCount >= 4) score += 4;

        return Math.Min(score, 100);
    }

    private static string StripHtml(string input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return string.Empty;
        }

        var plain = Regex.Replace(input, "<.*?>", string.Empty);
        return plain.Trim();
    }
}
