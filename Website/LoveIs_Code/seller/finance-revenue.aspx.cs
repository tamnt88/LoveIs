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

public partial class SellerFinanceRevenue : System.Web.UI.Page
{
    protected string MonthlyRevenueDataJson { get; private set; }
    protected int RangeMonths { get; private set; }
    protected string SearchQuery { get; private set; }
    protected int TotalRows { get; private set; }
    protected int PageStart { get; private set; }
    protected int PageEnd { get; private set; }
    protected string PagerHtml { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        MonthlyRevenueDataJson = "[]";
        RangeMonths = ParseRange(Request.QueryString["range"]);
        SearchQuery = (Request.QueryString["search"] ?? string.Empty).Trim();
        TotalRows = 0;
        PageStart = 0;
        PageEnd = 0;
        PagerHtml = string.Empty;

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        if (IsExportRequest())
        {
            ExportRevenue(sellerId.Value, RangeMonths);
            return;
        }

        if (!IsPostBack)
        {
            BindRevenue(sellerId.Value);
            BindRevenueHistory(sellerId.Value);
        }

        MonthlyRevenueDataJson = new JavaScriptSerializer().Serialize(BuildMonthlyRevenueData(sellerId.Value, RangeMonths));
    }

    private void BindRevenue(int sellerId)
    {
        var today = DateTime.Today;
        var monthStart = new DateTime(today.Year, today.Month, 1);
        var nextMonth = monthStart.AddMonths(1);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                MonthRevenueLiteral.Text = "0 đ";
                PaidRevenueLiteral.Text = "0 đ";
                PendingRevenueLiteral.Text = "0 đ";
                EstimatedProfitLiteral.Text = "0 đ";
                return;
            }

            var orders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= monthStart && o.CreatedAt < nextMonth)
                .ToList();

            var total = orders.Sum(o => o.Total);
            var paid = orders
                .Where(o => string.Equals(o.OrderStatus, "COMPLETED", StringComparison.OrdinalIgnoreCase)
                         || string.Equals(o.OrderStatus, "DELIVERED", StringComparison.OrdinalIgnoreCase))
                .Sum(o => o.Total);

            var feeTotal = orders.Sum(o =>
                (o.PlatformFeeAmount ?? 0m) +
                (o.InfrastructureFee ?? 0m) +
                (o.PaymentFeeAmount ?? 0m) +
                (o.ShippingFeeAmount ?? 0m));
            var estimatedProfit = total - feeTotal;

            MonthRevenueLiteral.Text = FormatMoney(total);
            PaidRevenueLiteral.Text = FormatMoney(paid);
            PendingRevenueLiteral.Text = FormatMoney(Math.Max(0m, total - paid));
            EstimatedProfitLiteral.Text = FormatMoney(estimatedProfit);
        }
    }

    private static List<MonthlyRevenuePoint> BuildMonthlyRevenueData(int sellerId, int rangeMonths)
    {
        var now = DateTime.Today;
        var startMonth = new DateTime(now.Year, now.Month, 1).AddMonths(-(rangeMonths - 1));
        var endMonth = new DateTime(now.Year, now.Month, 1).AddMonths(1);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return BuildMonthPoints(startMonth, rangeMonths, new Dictionary<DateTime, decimal>());
            }

            var monthTotals = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startMonth && o.CreatedAt < endMonth)
                .GroupBy(o => new { o.CreatedAt.Year, o.CreatedAt.Month })
                .Select(g => new
                {
                    Year = g.Key.Year,
                    Month = g.Key.Month,
                    Total = g.Sum(x => x.Total)
                })
                .ToList()
                .ToDictionary(x => new DateTime(x.Year, x.Month, 1), x => x.Total);

            return BuildMonthPoints(startMonth, rangeMonths, monthTotals);
        }
    }

    private static List<MonthlyRevenuePoint> BuildMonthPoints(DateTime startMonth, int rangeMonths, IDictionary<DateTime, decimal> monthTotals)
    {
        var points = new List<MonthlyRevenuePoint>();
        for (int i = 0; i < rangeMonths; i++)
        {
            var month = startMonth.AddMonths(i);
            decimal total;
            if (!monthTotals.TryGetValue(month, out total))
            {
                total = 0m;
            }

            points.Add(new MonthlyRevenuePoint
            {
                Label = "Tháng " + month.Month.ToString(CultureInfo.InvariantCulture),
                ShortLabel = "Tháng " + month.Month.ToString(CultureInfo.InvariantCulture),
                Total = total
            });
        }

        return points;
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private void BindRevenueHistory(int sellerId)
    {
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                RevenueHistoryRepeater.DataSource = new List<RevenueHistoryRow>();
                RevenueHistoryRepeater.DataBind();
                return;
            }

            var rows = (from so in db.CfShopOrders
                        join o in db.CfOrders on so.OrderId equals o.Id
                        where so.Status && shopIds.Contains(so.ShopId)
                        orderby o.CreatedAt descending, o.Id descending
                        select new
                        {
                            o.OrderCode,
                            o.CreatedAt,
                            o.OrderStatus,
                            o.PaymentStatus,
                            Amount = so.Total
                        })
                .Take(50)
                .ToList()
                .Select(x => new RevenueHistoryRow
                {
                    OrderCode = string.IsNullOrWhiteSpace(x.OrderCode) ? "-" : x.OrderCode,
                    CreatedAtText = x.CreatedAt.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                    TypeLabel = "Thanh toán đơn hàng",
                    AmountText = "+" + FormatMoney(x.Amount),
                    StatusLabel = ResolveOrderStatus(x.OrderStatus, x.PaymentStatus)
                })
                .ToList();

            if (!string.IsNullOrWhiteSpace(SearchQuery))
            {
                var keyword = SearchQuery.Trim();
                rows = rows.Where(r => (r.OrderCode ?? string.Empty).IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0)
                    .ToList();
            }

            TotalRows = rows.Count;
            var pageIndex = ParsePage(Request.QueryString["page"]);
            var pageSize = 8;
            var startIndex = pageIndex * pageSize;
            if (startIndex < 0) startIndex = 0;
            if (startIndex > Math.Max(0, TotalRows - 1)) startIndex = Math.Max(0, TotalRows - 1);
            var paged = rows.Skip(startIndex).Take(pageSize).ToList();
            PageStart = TotalRows == 0 ? 0 : startIndex + 1;
            PageEnd = TotalRows == 0 ? 0 : Math.Min(startIndex + pageSize, TotalRows);
            PagerHtml = BuildPagerHtml(pageIndex, pageSize, TotalRows, RangeMonths, SearchQuery);

            RevenueHistoryRepeater.DataSource = paged;
            RevenueHistoryRepeater.DataBind();
        }
    }

    private static string ResolveOrderStatus(string orderStatus, string paymentStatus)
    {
        if (!string.IsNullOrWhiteSpace(orderStatus))
        {
            return orderStatus;
        }
        if (!string.IsNullOrWhiteSpace(paymentStatus))
        {
            return paymentStatus;
        }
        return "Đang xử lý";
    }

    private static int ParseRange(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && (value == 6 || value == 12))
        {
            return value;
        }
        return 6;
    }

    private static int ParsePage(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && value > 0)
        {
            return value;
        }
        return 0;
    }

    private static string BuildPagerHtml(int pageIndex, int pageSize, int totalRows, int rangeMonths, string keyword)
    {
        if (totalRows <= pageSize)
        {
            return string.Empty;
        }

        var totalPages = (int)Math.Ceiling(totalRows / (double)pageSize);
        var current = Math.Max(0, Math.Min(pageIndex, totalPages - 1));
        var parts = new List<string>();

        var baseUrl = "/seller/finance-revenue.aspx?range=" + rangeMonths.ToString(CultureInfo.InvariantCulture);
        if (!string.IsNullOrWhiteSpace(keyword))
        {
            baseUrl += "&search=" + HttpUtility.UrlEncode(keyword);
        }

        var prevPage = current - 1;
        parts.Add(BuildPagerLink(baseUrl, "Trước", prevPage, prevPage < 0));

        var start = Math.Max(0, current - 2);
        var end = Math.Min(totalPages - 1, current + 2);
        for (var i = start; i <= end; i++)
        {
            var label = (i + 1).ToString(CultureInfo.InvariantCulture);
            parts.Add(BuildPagerLink(baseUrl, label, i, false, i == current));
        }

        var nextPage = current + 1;
        parts.Add(BuildPagerLink(baseUrl, "Sau", nextPage, nextPage >= totalPages));

        return string.Join("", parts);
    }

    private static string BuildPagerLink(string baseUrl, string label, int page, bool disabled, bool active = false)
    {
        var className = "pager-btn";
        if (active)
        {
            className += " active";
        }
        if (disabled)
        {
            className += " disabled";
            return "<span class='" + className + "'>" + HttpUtility.HtmlEncode(label) + "</span>";
        }
        var url = baseUrl + "&page=" + page.ToString(CultureInfo.InvariantCulture);
        return "<a class='" + className + "' href='" + url + "'>" + HttpUtility.HtmlEncode(label) + "</a>";
    }

    private bool IsExportRequest()
    {
        return string.Equals(Request.QueryString["export"], "1", StringComparison.OrdinalIgnoreCase);
    }

    private void ExportRevenue(int sellerId, int rangeMonths)
    {
        var data = BuildMonthlyRevenueData(sellerId, rangeMonths);
        var fileName = "finance-revenue-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx";

        var rows = new List<string[]>
        {
            new[] { "Tháng", "Doanh thu" }
        };

        foreach (var item in data)
        {
            rows.Add(new[] { item.Label, FormatMoney(item.Total) });
        }

        WriteXlsxResponse(rows, fileName);
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
            + "<sheets><sheet name=\"Revenue\" sheetId=\"1\" r:id=\"rId1\"/></sheets>"
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

    private sealed class MonthlyRevenuePoint
    {
        public string Label { get; set; }
        public string ShortLabel { get; set; }
        public decimal Total { get; set; }
    }

    private sealed class RevenueHistoryRow
    {
        public string OrderCode { get; set; }
        public string CreatedAtText { get; set; }
        public string TypeLabel { get; set; }
        public string AmountText { get; set; }
        public string StatusLabel { get; set; }
    }
}
