using System;
using System.Globalization;
using System.Linq;

public partial class SellerFinanceRevenue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRevenue();
        }
    }

    private void BindRevenue()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        var today = DateTime.Today;
        var monthStart = new DateTime(today.Year, today.Month, 1);
        var nextMonth = monthStart.AddMonths(1);

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
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

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }
}
