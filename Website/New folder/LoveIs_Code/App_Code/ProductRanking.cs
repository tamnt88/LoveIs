using System;
using System.Data.Entity;
using System.Linq;

public static class ProductRanking
{
    public static IOrderedQueryable<CfProduct> Apply(IQueryable<CfProduct> query)
    {
        var now = DateTime.UtcNow;

        return query.OrderByDescending(p =>
                (p.Sold30d * 5)
                + (p.AddToCartCount * 2)
                + (p.ViewCount * 0.1m)
                + (p.RatingAvg * 20)
                + (p.RatingCount * 0.5m)
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
