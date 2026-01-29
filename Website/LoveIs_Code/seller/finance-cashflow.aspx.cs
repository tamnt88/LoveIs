using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

public partial class SellerFinanceCashflow : System.Web.UI.Page
{
    protected string MonthlyCashflowDataJson { get; private set; }
    protected string FeeDistributionJson { get; private set; }
    protected int RangeMonths { get; private set; }
    protected string SearchQuery { get; private set; }
    protected int TotalRows { get; private set; }
    protected int PageStart { get; private set; }
    protected int PageEnd { get; private set; }
    protected string PagerHtml { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        MonthlyCashflowDataJson = "[]";
        FeeDistributionJson = "[]";
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

        if (!IsPostBack)
        {
            BindStats(sellerId.Value, RangeMonths);
            MonthlyCashflowDataJson = new JavaScriptSerializer().Serialize(BuildMonthlyCashflowData(sellerId.Value, RangeMonths));
            FeeDistributionJson = new JavaScriptSerializer().Serialize(BuildFeeDistribution(sellerId.Value, RangeMonths));
            BindRecentTransactions(sellerId.Value, RangeMonths);
        }
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

    private void BindStats(int sellerId, int rangeMonths)
    {
        var now = DateTime.Today;
        var startMonth = new DateTime(now.Year, now.Month, 1).AddMonths(-(rangeMonths - 1));
        var endMonth = new DateTime(now.Year, now.Month, 1).AddMonths(1);
        var prevStart = startMonth.AddMonths(-rangeMonths);
        var prevEnd = startMonth;

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                TotalIncomeLiteral.Text = "0 đ";
                TotalExpenseLiteral.Text = "0 đ";
                ProfitLiteral.Text = "0 đ";
                ProfitTrendLiteral.Text = "";
                ProfitRateLiteral.Text = "0%";
                ProfitRateNoteLiteral.Text = "Chưa có dữ liệu";
                return;
            }

            var orders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startMonth && o.CreatedAt < endMonth)
                .ToList();

            var income = orders.Sum(o => o.Total);
            var expense = orders.Sum(o => (o.PlatformFeeAmount ?? 0m) + (o.InfrastructureFee ?? 0m) + (o.PaymentFeeAmount ?? 0m) + (o.ShippingFeeAmount ?? 0m));
            var profit = income - expense;

            var prevOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= prevStart && o.CreatedAt < prevEnd)
                .ToList();

            var prevIncome = prevOrders.Sum(o => o.Total);
            var prevExpense = prevOrders.Sum(o => (o.PlatformFeeAmount ?? 0m) + (o.InfrastructureFee ?? 0m) + (o.PaymentFeeAmount ?? 0m) + (o.ShippingFeeAmount ?? 0m));
            var prevProfit = prevIncome - prevExpense;

            TotalIncomeLiteral.Text = FormatMoney(income);
            TotalExpenseLiteral.Text = FormatMoney(expense);
            ProfitLiteral.Text = FormatMoney(profit);

            if (prevProfit > 0)
            {
                var growth = (profit - prevProfit) / prevProfit * 100m;
                ProfitTrendLiteral.Text = (growth >= 0 ? "+" : string.Empty) + growth.ToString("0.#", CultureInfo.InvariantCulture) + "% so với kỳ trước";
            }
            else
            {
                ProfitTrendLiteral.Text = "";
            }

            var rate = income > 0 ? (profit / income) * 100m : 0m;
            ProfitRateLiteral.Text = rate.ToString("0.#", CultureInfo.InvariantCulture) + "%";
            ProfitRateNoteLiteral.Text = rate >= 40m ? "Rất tốt" : (rate >= 20m ? "Khá" : "Cần cải thiện");
        }
    }

    private static List<CashflowPoint> BuildMonthlyCashflowData(int sellerId, int rangeMonths)
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
                return BuildMonthPoints(startMonth, rangeMonths, new Dictionary<DateTime, CashflowTotals>());
            }

            var monthTotals = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startMonth && o.CreatedAt < endMonth)
                .GroupBy(o => new { o.CreatedAt.Year, o.CreatedAt.Month })
                .Select(g => new
                {
                    Year = g.Key.Year,
                    Month = g.Key.Month,
                    Income = g.Sum(x => x.Total),
                    Expense = g.Sum(x => (x.PlatformFeeAmount ?? 0m) + (x.InfrastructureFee ?? 0m) + (x.PaymentFeeAmount ?? 0m) + (x.ShippingFeeAmount ?? 0m))
                })
                .ToList()
                .ToDictionary(x => new DateTime(x.Year, x.Month, 1), x => new CashflowTotals { Income = x.Income, Expense = x.Expense });

            return BuildMonthPoints(startMonth, rangeMonths, monthTotals);
        }
    }

    private static List<CashflowPoint> BuildMonthPoints(DateTime startMonth, int rangeMonths, IDictionary<DateTime, CashflowTotals> monthTotals)
    {
        var points = new List<CashflowPoint>();
        for (int i = 0; i < rangeMonths; i++)
        {
            var month = startMonth.AddMonths(i);
            CashflowTotals totals;
            if (!monthTotals.TryGetValue(month, out totals))
            {
                totals = new CashflowTotals();
            }

            points.Add(new CashflowPoint
            {
                Label = "Tháng " + month.Month.ToString(CultureInfo.InvariantCulture),
                ShortLabel = "Tháng " + month.Month.ToString(CultureInfo.InvariantCulture),
                Income = totals.Income,
                Expense = totals.Expense
            });
        }

        return points;
    }

    private static List<FeeSlice> BuildFeeDistribution(int sellerId, int rangeMonths)
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
                return new List<FeeSlice>();
            }

            var orders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startMonth && o.CreatedAt < endMonth)
                .ToList();

            var platformFee = orders.Sum(o => o.PlatformFeeAmount ?? 0m);
            var infrastructureFee = orders.Sum(o => o.InfrastructureFee ?? 0m);
            var paymentFee = orders.Sum(o => o.PaymentFeeAmount ?? 0m);
            var shippingFee = orders.Sum(o => o.ShippingFeeAmount ?? 0m);

            return new List<FeeSlice>
            {
                new FeeSlice { Name = "Phí nền tảng", Count = platformFee },
                new FeeSlice { Name = "Phí hạ tầng", Count = infrastructureFee },
                new FeeSlice { Name = "Phí thanh toán", Count = paymentFee },
                new FeeSlice { Name = "Phí vận chuyển", Count = shippingFee }
            };
        }
    }

    private void BindRecentTransactions(int sellerId, int rangeMonths)
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
                RecentTxnRepeater.DataSource = new List<RecentTxnRow>();
                RecentTxnRepeater.DataBind();
                return;
            }

            var orders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= startMonth && o.CreatedAt < endMonth)
                .ToList();

            var dailyGroups = orders.GroupBy(o => o.CreatedAt.Date).ToList();
            var rows = new List<RecentTxnRow>();

            foreach (var group in dailyGroups)
            {
                var date = group.Key;
                var income = group.Sum(o => o.Total);
                if (income > 0)
                {
                    rows.Add(new RecentTxnRow
                    {
                        TxnCode = BuildTxnCode(date, "IN"),
                        DateText = date.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                        Category = "Doanh thu",
                        Description = "Thu nhập từ đơn hàng",
                        TypeLabel = "Thu",
                        TypeBadgeClass = "txn-badge txn-badge-in",
                        AmountText = "+" + FormatMoney(income),
                        AmountClass = "text-success",
                        SortDate = date
                    });
                }

                var platformFee = group.Sum(o => o.PlatformFeeAmount ?? 0m);
                if (platformFee > 0)
                {
                    rows.Add(BuildExpenseRow(date, "Phí nền tảng", "Phí nền tảng", platformFee));
                }

                var infrastructureFee = group.Sum(o => o.InfrastructureFee ?? 0m);
                if (infrastructureFee > 0)
                {
                    rows.Add(BuildExpenseRow(date, "Phí hạ tầng", "Phí hạ tầng", infrastructureFee));
                }

                var paymentFee = group.Sum(o => o.PaymentFeeAmount ?? 0m);
                if (paymentFee > 0)
                {
                    rows.Add(BuildExpenseRow(date, "Phí thanh toán", "Phí thanh toán", paymentFee));
                }

                var shippingFee = group.Sum(o => o.ShippingFeeAmount ?? 0m);
                if (shippingFee > 0)
                {
                    rows.Add(BuildExpenseRow(date, "Phí vận chuyển", "Phí vận chuyển", shippingFee));
                }
            }

            rows = rows.OrderByDescending(r => r.SortDate).ThenBy(r => r.TypeLabel).ToList();

            if (!string.IsNullOrWhiteSpace(SearchQuery))
            {
                var keyword = SearchQuery.Trim();
                rows = rows.Where(r => (r.TxnCode ?? string.Empty).IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0)
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

            RecentTxnRepeater.DataSource = paged;
            RecentTxnRepeater.DataBind();
        }
    }

    private static RecentTxnRow BuildExpenseRow(DateTime date, string category, string description, decimal amount)
    {
        return new RecentTxnRow
        {
            TxnCode = BuildTxnCode(date, "OUT"),
            DateText = date.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
            Category = category,
            Description = description,
            TypeLabel = "Chi",
            TypeBadgeClass = "txn-badge txn-badge-out",
            AmountText = "-" + FormatMoney(amount),
            AmountClass = "text-danger",
            SortDate = date
        };
    }

    private static string BuildTxnCode(DateTime date, string suffix)
    {
        return "TXN" + date.ToString("yyyyMMdd", CultureInfo.InvariantCulture) + suffix;
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

        var baseUrl = "/seller/finance-cashflow.aspx?range=" + rangeMonths.ToString(CultureInfo.InvariantCulture);
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

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private sealed class CashflowTotals
    {
        public decimal Income { get; set; }
        public decimal Expense { get; set; }
    }

    private sealed class CashflowPoint
    {
        public string Label { get; set; }
        public string ShortLabel { get; set; }
        public decimal Income { get; set; }
        public decimal Expense { get; set; }
    }

    private sealed class FeeSlice
    {
        public string Name { get; set; }
        public decimal Count { get; set; }
    }

    private sealed class RecentTxnRow
    {
        public string TxnCode { get; set; }
        public string DateText { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string TypeLabel { get; set; }
        public string TypeBadgeClass { get; set; }
        public string AmountText { get; set; }
        public string AmountClass { get; set; }
        public DateTime SortDate { get; set; }
    }
}
