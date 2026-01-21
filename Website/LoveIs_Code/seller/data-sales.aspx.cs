using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;

public partial class SellerDataSales : System.Web.UI.Page
{
    protected string WeeklyOrderDataJson { get; private set; }
    protected string CategoryDistributionJson { get; private set; }
    protected string WeeklyRevenueDataJson { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        WeeklyOrderDataJson = "[]";
        CategoryDistributionJson = "[]";
        WeeklyRevenueDataJson = "[]";
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        WeeklyOrderDataJson = new JavaScriptSerializer().Serialize(BuildWeeklyOrderData(sellerId.Value));
        CategoryDistributionJson = new JavaScriptSerializer().Serialize(BuildCategoryDistribution(sellerId.Value));
        WeeklyRevenueDataJson = new JavaScriptSerializer().Serialize(BuildWeeklyRevenueData(sellerId.Value));
    }

    private static List<WeeklyOrderPoint> BuildWeeklyOrderData(int sellerId)
    {
        DateTime today = DateTime.Today;
        int dayIndex = (int)today.DayOfWeek;
        int mondayOffset = dayIndex == 0 ? -6 : 1 - dayIndex;
        DateTime monday = today.AddDays(mondayOffset);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return BuildWeeklyPoints(monday, new Dictionary<DateTime, int>());
            }

            DateTime nextMonday = monday.AddDays(7);
            var dayCounts = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= monday && o.CreatedAt < nextMonday)
                .GroupBy(o => DbFunctions.TruncateTime(o.CreatedAt))
                .Select(g => new { Date = g.Key, Count = g.Count() })
                .ToList()
                .Where(x => x.Date.HasValue)
                .ToDictionary(x => x.Date.Value, x => x.Count);

            return BuildWeeklyPoints(monday, dayCounts);
        }
    }

    private static List<WeeklyOrderPoint> BuildWeeklyPoints(DateTime monday, IDictionary<DateTime, int> dayCounts)
    {
        var labels = new[] { "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ Nhật" };
        var points = new List<WeeklyOrderPoint>();

        for (int i = 0; i < labels.Length; i++)
        {
            DateTime date = monday.AddDays(i).Date;
            int count;
            if (!dayCounts.TryGetValue(date, out count))
            {
                count = 0;
            }

            points.Add(new WeeklyOrderPoint
            {
                Day = labels[i],
                DateText = date.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                Count = count
            });
        }

        return points;
    }

    private static List<CategorySlice> BuildCategoryDistribution(int sellerId)
    {
        DateTime today = DateTime.Today;
        int dayIndex = (int)today.DayOfWeek;
        int mondayOffset = dayIndex == 0 ? -6 : 1 - dayIndex;
        DateTime monday = today.AddDays(mondayOffset);
        DateTime nextMonday = monday.AddDays(7);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return new List<CategorySlice>();
            }

            var orderIds = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= monday && o.CreatedAt < nextMonday)
                .Select(o => o.OrderId)
                .Distinct()
                .ToList();

            if (orderIds.Count == 0)
            {
                return new List<CategorySlice>();
            }

            var categoryCounts = (from item in db.CfOrderItems
                                  join product in db.CfProducts on item.ProductId equals product.Id
                                  join category in db.CfCategories on product.CategoryId equals category.Id
                                  where orderIds.Contains(item.OrderId)
                                  group item by new { category.Id, category.CategoryName } into g
                                  select new
                                  {
                                      Name = g.Key.CategoryName,
                                      Count = g.Sum(x => x.Quantity)
                                  })
                .ToList();

            return categoryCounts
                .OrderByDescending(x => x.Count)
                .Select(x => new CategorySlice { Name = x.Name, Count = x.Count })
                .ToList();
        }
    }

    private sealed class WeeklyOrderPoint
    {
        public string Day { get; set; }
        public string DateText { get; set; }
        public int Count { get; set; }
    }

    private sealed class CategorySlice
    {
        public string Name { get; set; }
        public int Count { get; set; }
    }

    private static List<WeeklyRevenuePoint> BuildWeeklyRevenueData(int sellerId)
    {
        DateTime today = DateTime.Today;
        int dayIndex = (int)today.DayOfWeek;
        int mondayOffset = dayIndex == 0 ? -6 : 1 - dayIndex;
        DateTime monday = today.AddDays(mondayOffset);
        DateTime nextMonday = monday.AddDays(7);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return BuildWeeklyRevenuePoints(monday, new Dictionary<DateTime, decimal>());
            }

            var dayTotals = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= monday && o.CreatedAt < nextMonday)
                .GroupBy(o => DbFunctions.TruncateTime(o.CreatedAt))
                .Select(g => new { Date = g.Key, Total = g.Sum(x => x.Total) })
                .ToList()
                .Where(x => x.Date.HasValue)
                .ToDictionary(x => x.Date.Value, x => x.Total);

            return BuildWeeklyRevenuePoints(monday, dayTotals);
        }
    }

    private static List<WeeklyRevenuePoint> BuildWeeklyRevenuePoints(DateTime monday, IDictionary<DateTime, decimal> dayTotals)
    {
        var labels = new[] { "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ Nhật" };
        var points = new List<WeeklyRevenuePoint>();

        for (int i = 0; i < labels.Length; i++)
        {
            DateTime date = monday.AddDays(i).Date;
            decimal total;
            if (!dayTotals.TryGetValue(date, out total))
            {
                total = 0m;
            }

            points.Add(new WeeklyRevenuePoint
            {
                Day = labels[i],
                DateText = date.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                Total = total
            });
        }

        return points;
    }

    private sealed class WeeklyRevenuePoint
    {
        public string Day { get; set; }
        public string DateText { get; set; }
        public decimal Total { get; set; }
    }
}
