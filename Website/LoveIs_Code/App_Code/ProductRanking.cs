using System;
using System.Data.Entity;
using System.Linq;

public static class ProductRanking
{
    public static IOrderedQueryable<CfProduct> Apply(IQueryable<CfProduct> query)
    {
        var now = DateTime.UtcNow;

        return query.OrderByDescending(p =>
                ((p.StockTotal > 0) ? 5 : -200)
                + (p.MaxDiscountPercent * 40)
                + (((p.ViewCount30d > 0 ? (decimal)p.Sold30d / (p.ViewCount30d + 1m) : 0m)) * 30)
                + (p.ReturnRate30d * -50)
                + (p.CancelRate30d * -30)
                + (p.IsViolation ? -500 : 0)
                + (p.Status ? 0 : -500)
                + (p.Sold30d * 5)
                + (p.AddToCartCount * 2)
                + (p.ViewCount * 0.1m)
                + (p.RatingAvg * 20)
                + (p.RatingCount * 0.5m)
                + ((p.Shop != null ? p.Shop.RatingAvg : 0m) * 5)
                + ((p.Shop != null ? p.Shop.RatingCount : 0) * 0.2m)
                + (p.ContentScore * 1)
                + (p.IsBestSelling ? 30 : 0)
                + (p.IsTrending ? 20 : 0)
                + (p.IsNewArrival ? 15 : 0)
                + ((DbFunctions.DiffDays(p.CreatedAt, now) ?? 999) <= 7 ? 15
                    : ((DbFunctions.DiffDays(p.CreatedAt, now) ?? 999) <= 30 ? 5 : 0))
            )
            .ThenByDescending(p => p.CreatedAt)
            .ThenByDescending(p => p.Id);
    }
}
