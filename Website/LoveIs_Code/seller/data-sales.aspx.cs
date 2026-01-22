using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

public partial class SellerDataSales : System.Web.UI.Page
{
    protected string WeeklyOrderDataJson { get; private set; }
    protected string CategoryDistributionJson { get; private set; }
    protected string WeeklyRevenueDataJson { get; private set; }
    protected int RangeDays { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        WeeklyOrderDataJson = "[]";
        CategoryDistributionJson = "[]";
        WeeklyRevenueDataJson = "[]";
        RangeDays = ParseRange(Request.QueryString["range"]);
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        if (IsExportRequest())
        {
            ExportSales(sellerId.Value, RangeDays);
            return;
        }

        BindStatGrid(sellerId.Value, RangeDays);
        WeeklyOrderDataJson = new JavaScriptSerializer().Serialize(BuildWeeklyOrderData(sellerId.Value, RangeDays));
        CategoryDistributionJson = new JavaScriptSerializer().Serialize(BuildCategoryDistribution(sellerId.Value, RangeDays));
        WeeklyRevenueDataJson = new JavaScriptSerializer().Serialize(BuildWeeklyRevenueData(sellerId.Value, RangeDays));
    }

    protected string GetRangeClass(int days)
    {
        return RangeDays == days ? "active" : string.Empty;
    }

    private void BindStatGrid(int sellerId, int rangeDays)
    {
        var rangeStart = DateTime.Today.AddDays(-rangeDays + 1);
        var rangeEnd = DateTime.Today.AddDays(1);
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                TotalOrdersLiteral.Text = "0";
                AverageOrderValueLiteral.Text = "0 đ";
                ConversionRateLiteral.Text = "0%";
                ReturningCustomerLiteral.Text = "0%";
                return;
            }

            var shopOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= rangeStart && o.CreatedAt < rangeEnd)
                .ToList();

            var totalOrders = shopOrders.Count;
            var totalRevenue = shopOrders.Sum(o => o.Total);
            var avgOrder = totalOrders > 0 ? totalRevenue / totalOrders : 0m;

            var shopProductIds = db.CfProducts
                .Where(p => p.Status && p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => p.Id)
                .ToList();

            var addToCartCount = db.CfProducts
                .Where(p => p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => (int?)p.AddToCartCount)
                .DefaultIfEmpty(0)
                .Sum() ?? 0;

            var completedStatusIds = db.CfOrderStatuses
                .Where(s => s.Status && s.Code == "COMPLETED")
                .Select(s => s.Id)
                .ToList();

            var completedOrderIds = (from so in db.CfShopOrders
                                     join o in db.CfOrders on so.OrderId equals o.Id
                                     where so.Status
                                           && shopIds.Contains(so.ShopId)
                                           && o.CreatedAt >= rangeStart && o.CreatedAt < rangeEnd
                                           && (o.OrderStatus == "COMPLETED" || (o.OrderStatusId.HasValue && completedStatusIds.Contains(o.OrderStatusId.Value)))
                                     select o.Id)
                .Distinct()
                .ToList();

            var purchasedQty = db.CfOrderItems
                .Where(i => completedOrderIds.Contains(i.OrderId) && shopProductIds.Contains(i.ProductId))
                .Select(i => (int?)i.Quantity)
                .DefaultIfEmpty(0)
                .Sum() ?? 0;

            var conversionRate = addToCartCount > 0
                ? (decimal)purchasedQty / addToCartCount * 100m
                : 0m;

            var orderIds = shopOrders.Select(o => o.OrderId).Distinct().ToList();
            var customerOrderDates = db.CfOrders
                .Where(o => orderIds.Contains(o.Id) && o.CustomerId.HasValue && o.CreatedAt >= rangeStart && o.CreatedAt < rangeEnd)
                .Select(o => new { o.CustomerId, OrderDate = DbFunctions.TruncateTime(o.CreatedAt) })
                .ToList()
                .Where(x => x.CustomerId.HasValue && x.OrderDate.HasValue)
                .GroupBy(x => x.CustomerId.Value)
                .Select(g => new { CustomerId = g.Key, Dates = g.Select(x => x.OrderDate.Value).Distinct().Count() })
                .ToList();

            var returningCustomers = customerOrderDates.Count(x => x.Dates > 1);
            var uniqueCustomers = customerOrderDates.Count;
            var returningRate = uniqueCustomers > 0 ? (decimal)returningCustomers / uniqueCustomers * 100m : 0m;

            TotalOrdersLiteral.Text = totalOrders.ToString(CultureInfo.InvariantCulture);
            AverageOrderValueLiteral.Text = FormatCurrency(avgOrder);
            ConversionRateLiteral.Text = conversionRate.ToString("0.0", CultureInfo.InvariantCulture) + "%";
            ReturningCustomerLiteral.Text = returningRate.ToString("0.0", CultureInfo.InvariantCulture) + "%";
        }
    }

    private static string FormatCurrency(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private static List<WeeklyOrderPoint> BuildWeeklyOrderData(int sellerId, int rangeDays)
    {
        var startDate = DateTime.Today.AddDays(-rangeDays + 1);
        var endDate = DateTime.Today.AddDays(1);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return BuildDailyPoints(startDate, rangeDays, new Dictionary<DateTime, int>());
            }

            var dayCounts = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startDate && o.CreatedAt < endDate)
                .GroupBy(o => DbFunctions.TruncateTime(o.CreatedAt))
                .Select(g => new { Date = g.Key, Count = g.Count() })
                .ToList()
                .Where(x => x.Date.HasValue)
                .ToDictionary(x => x.Date.Value, x => x.Count);

            return BuildDailyPoints(startDate, rangeDays, dayCounts);
        }
    }

    private static List<WeeklyOrderPoint> BuildDailyPoints(DateTime startDate, int rangeDays, IDictionary<DateTime, int> dayCounts)
    {
        var points = new List<WeeklyOrderPoint>();

        for (int i = 0; i < rangeDays; i++)
        {
            DateTime date = startDate.AddDays(i).Date;
            int count;
            if (!dayCounts.TryGetValue(date, out count))
            {
                count = 0;
            }

            points.Add(new WeeklyOrderPoint
            {
                Day = date.ToString("dd/MM", CultureInfo.InvariantCulture),
                DateText = date.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                Count = count
            });
        }

        return points;
    }

    private static List<CategorySlice> BuildCategoryDistribution(int sellerId, int rangeDays)
    {
        var startDate = DateTime.Today.AddDays(-rangeDays + 1);
        var endDate = DateTime.Today.AddDays(1);

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
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startDate && o.CreatedAt < endDate)
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

    private static List<WeeklyRevenuePoint> BuildWeeklyRevenueData(int sellerId, int rangeDays)
    {
        var startDate = DateTime.Today.AddDays(-rangeDays + 1);
        var endDate = DateTime.Today.AddDays(1);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return BuildWeeklyRevenuePoints(startDate, rangeDays, new Dictionary<DateTime, decimal>());
            }

            var dayTotals = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startDate && o.CreatedAt < endDate)
                .GroupBy(o => DbFunctions.TruncateTime(o.CreatedAt))
                .Select(g => new { Date = g.Key, Total = g.Sum(x => x.Total) })
                .ToList()
                .Where(x => x.Date.HasValue)
                .ToDictionary(x => x.Date.Value, x => x.Total);

            return BuildWeeklyRevenuePoints(startDate, rangeDays, dayTotals);
        }
    }

    private static List<WeeklyRevenuePoint> BuildWeeklyRevenuePoints(DateTime startDate, int rangeDays, IDictionary<DateTime, decimal> dayTotals)
    {
        var points = new List<WeeklyRevenuePoint>();

        for (int i = 0; i < rangeDays; i++)
        {
            DateTime date = startDate.AddDays(i).Date;
            decimal total;
            if (!dayTotals.TryGetValue(date, out total))
            {
                total = 0m;
            }

            points.Add(new WeeklyRevenuePoint
            {
                Day = date.ToString("dd/MM", CultureInfo.InvariantCulture),
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

    private static int ParseRange(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && (value == 7 || value == 30))
        {
            return value;
        }
        return 7;
    }

    private bool IsExportRequest()
    {
        return string.Equals(Request.QueryString["export"], "1", StringComparison.OrdinalIgnoreCase);
    }

    private void ExportSales(int sellerId, int rangeDays)
    {
        var stats = BuildSalesExportStats(sellerId, rangeDays);
        var fileName = "sales-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx";
        var rows = new List<string[]>
        {
            new[] { "Pham vi", "Gia tri" },
            new[] { "Khoang ngay", rangeDays.ToString(CultureInfo.InvariantCulture) },
            new[] { "Tong don hang", stats.TotalOrders.ToString(CultureInfo.InvariantCulture) },
            new[] { "Gia tri don TB", FormatCurrency(stats.AverageOrderValue) },
            new[] { "Ty le chuyen doi", stats.ConversionRate.ToString("0.0", CultureInfo.InvariantCulture) + "%" },
            new[] { "Khach quay lai", stats.ReturningRate.ToString("0.0", CultureInfo.InvariantCulture) + "%" }
        };

        WriteXlsxResponse(rows, fileName);
    }

    private SalesStats BuildSalesExportStats(int sellerId, int rangeDays)
    {
        var rangeStart = DateTime.Today.AddDays(-rangeDays + 1);
        var rangeEnd = DateTime.Today.AddDays(1);
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return new SalesStats();
            }

            var shopOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= rangeStart && o.CreatedAt < rangeEnd)
                .ToList();

            var totalOrders = shopOrders.Count;
            var totalRevenue = shopOrders.Sum(o => o.Total);
            var avgOrder = totalOrders > 0 ? totalRevenue / totalOrders : 0m;

            var addToCartCount = db.CfProducts
                .Where(p => p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => (int?)p.AddToCartCount)
                .DefaultIfEmpty(0)
                .Sum() ?? 0;

            var completedStatusIds = db.CfOrderStatuses
                .Where(s => s.Status && s.Code == "COMPLETED")
                .Select(s => s.Id)
                .ToList();

            var completedOrderIds = (from so in db.CfShopOrders
                                     join o in db.CfOrders on so.OrderId equals o.Id
                                     where so.Status
                                           && shopIds.Contains(so.ShopId)
                                           && o.CreatedAt >= rangeStart && o.CreatedAt < rangeEnd
                                           && (o.OrderStatus == "COMPLETED" || (o.OrderStatusId.HasValue && completedStatusIds.Contains(o.OrderStatusId.Value)))
                                     select o.Id)
                .Distinct()
                .ToList();

            var shopProductIds = db.CfProducts
                .Where(p => p.Status && p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value))
                .Select(p => p.Id)
                .ToList();

            var purchasedQty = db.CfOrderItems
                .Where(i => completedOrderIds.Contains(i.OrderId) && shopProductIds.Contains(i.ProductId))
                .Select(i => (int?)i.Quantity)
                .DefaultIfEmpty(0)
                .Sum() ?? 0;

            var conversionRate = addToCartCount > 0
                ? (decimal)purchasedQty / addToCartCount * 100m
                : 0m;

            var orderIds = shopOrders.Select(o => o.OrderId).Distinct().ToList();
            var customerOrderDates = db.CfOrders
                .Where(o => orderIds.Contains(o.Id) && o.CustomerId.HasValue && o.CreatedAt >= rangeStart && o.CreatedAt < rangeEnd)
                .Select(o => new { o.CustomerId, OrderDate = DbFunctions.TruncateTime(o.CreatedAt) })
                .ToList()
                .Where(x => x.CustomerId.HasValue && x.OrderDate.HasValue)
                .GroupBy(x => x.CustomerId.Value)
                .Select(g => new { CustomerId = g.Key, Dates = g.Select(x => x.OrderDate.Value).Distinct().Count() })
                .ToList();

            var returningCustomers = customerOrderDates.Count(x => x.Dates > 1);
            var uniqueCustomers = customerOrderDates.Count;
            var returningRate = uniqueCustomers > 0 ? (decimal)returningCustomers / uniqueCustomers * 100m : 0m;

            return new SalesStats
            {
                TotalOrders = totalOrders,
                AverageOrderValue = avgOrder,
                ConversionRate = conversionRate,
                ReturningRate = returningRate
            };
        }
    }

    private static void WriteXlsxResponse(List<string[]> rows, string fileName)
    {
        var bytes = BuildXlsx(rows);
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        HttpContext.Current.Response.BinaryWrite(bytes);
        HttpContext.Current.Response.End();
    }

    private static byte[] BuildXlsx(List<string[]> rows)
    {
        using (var stream = new MemoryStream())
        {
            using (var archive = new ZipArchive(stream, ZipArchiveMode.Create, true))
            {
                AddZipEntry(archive, "[Content_Types].xml", BuildContentTypesXml());
                AddZipEntry(archive, "_rels/.rels", BuildRootRelsXml());
                AddZipEntry(archive, "xl/workbook.xml", BuildWorkbookXml());
                AddZipEntry(archive, "xl/_rels/workbook.xml.rels", BuildWorkbookRelsXml());
                AddZipEntry(archive, "xl/worksheets/sheet1.xml", BuildWorksheetXml(rows));
            }

            return stream.ToArray();
        }
    }

    private static void AddZipEntry(ZipArchive archive, string path, string content)
    {
        var entry = archive.CreateEntry(path, CompressionLevel.Fastest);
        using (var writer = new StreamWriter(entry.Open(), Encoding.UTF8))
        {
            writer.Write(content);
        }
    }

    private static string BuildContentTypesXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">"
            + "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>"
            + "<Default Extension=\"xml\" ContentType=\"application/xml\"/>"
            + "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>"
            + "<Override PartName=\"/xl/worksheets/sheet1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>"
            + "</Types>";
    }

    private static string BuildRootRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorkbookXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" "
            + "xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">"
            + "<sheets><sheet name=\"Sales\" sheetId=\"1\" r:id=\"rId1\"/></sheets>"
            + "</workbook>";
    }

    private static string BuildWorkbookRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/package/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorksheetXml(List<string[]> rows)
    {
        var builder = new StringBuilder();
        builder.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        builder.Append("<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
        builder.Append("<sheetData>");

        for (var i = 0; i < rows.Count; i++)
        {
            var rowIndex = i + 1;
            builder.Append("<row r=\"").Append(rowIndex).Append("\">");
            var cols = rows[i];
            for (var c = 0; c < cols.Length; c++)
            {
                var cellRef = ColumnName(c) + rowIndex.ToString(CultureInfo.InvariantCulture);
                builder.Append("<c r=\"").Append(cellRef).Append("\" t=\"inlineStr\"><is><t xml:space=\"preserve\">");
                builder.Append(EscapeXml(cols[c] ?? string.Empty));
                builder.Append("</t></is></c>");
            }
            builder.Append("</row>");
        }

        builder.Append("</sheetData>");
        builder.Append("</worksheet>");
        return builder.ToString();
    }

    private static string ColumnName(int index)
    {
        var dividend = index + 1;
        var name = string.Empty;
        while (dividend > 0)
        {
            var modulo = (dividend - 1) % 26;
            name = Convert.ToChar(65 + modulo) + name;
            dividend = (dividend - modulo) / 26;
        }
        return name;
    }

    private static string EscapeXml(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return string.Empty;
        }

        return value
            .Replace("&", "&amp;")
            .Replace("<", "&lt;")
            .Replace(">", "&gt;")
            .Replace("\"", "&quot;")
            .Replace("'", "&apos;");
    }

    private sealed class SalesStats
    {
        public int TotalOrders { get; set; }
        public decimal AverageOrderValue { get; set; }
        public decimal ConversionRate { get; set; }
        public decimal ReturningRate { get; set; }
    }
}
