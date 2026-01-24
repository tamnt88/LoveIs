using System;
using System.Globalization;
using System.Linq;

public partial class SellerFinanceReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReport();
        }
    }

    private void BindReport()
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
                ReportRevenueLiteral.Text = "0 đ";
                ReportCogsLiteral.Text = "0 đ";
                ReportFeeLiteral.Text = "0 đ";
                ReportProfitLiteral.Text = "0 đ";
                return;
            }

            var orders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && o.CreatedAt >= monthStart && o.CreatedAt < nextMonth)
                .ToList();

            var revenue = orders.Sum(o => o.Total);
            var fees = orders.Sum(o =>
                (o.PlatformFeeAmount ?? 0m) +
                (o.InfrastructureFee ?? 0m) +
                (o.PaymentFeeAmount ?? 0m) +
                (o.ShippingFeeAmount ?? 0m));
            var profit = revenue - fees;

            ReportRevenueLiteral.Text = FormatMoney(revenue);
            ReportCogsLiteral.Text = "0 đ";
            ReportFeeLiteral.Text = FormatMoney(fees);
            ReportProfitLiteral.Text = FormatMoney(profit);
        }
    }

    private static string FormatMoney(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }
}
