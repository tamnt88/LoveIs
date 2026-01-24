using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

public partial class SellerFinanceBalance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBalance();
        }
    }

    private void BindBalance()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        var rangeStart = DateTime.Today.AddDays(-30);
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                WalletBalanceLiteral.Text = "0 đ";
                WalletBalanceNoteLiteral.Text = "Chưa có dữ liệu";
                CashInLiteral.Text = "0 đ";
                CashOutLiteral.Text = "0 đ";
                WalletTxnRepeater.DataSource = new List<WalletTxnRow>();
                WalletTxnRepeater.DataBind();
                return;
            }

            var wallets = db.CfShopWallets
                .Where(w => shopIds.Contains(w.ShopId))
                .ToList();

            var totalBalance = wallets.Sum(w => w.Balance);
            WalletBalanceLiteral.Text = FormatMoney(totalBalance);
            WalletBalanceNoteLiteral.Text = "Số dư tổng của tất cả shop";

            var txns = db.CfShopWalletTxns
                .Where(t => shopIds.Contains(t.ShopId) && t.CreatedAt >= rangeStart)
                .OrderByDescending(t => t.CreatedAt)
                .Take(200)
                .ToList();

            var cashInTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "PENDING_IN",
                "AVAILABLE_IN",
                "ADJUST_IN"
            };
            var cashOutTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "PAYOUT_OUT",
                "PAYOUT_HOLD"
            };

            var cashIn = txns.Where(t => cashInTypes.Contains(t.Type ?? string.Empty)).Sum(t => t.Amount);
            var cashOut = txns.Where(t => cashOutTypes.Contains(t.Type ?? string.Empty)).Sum(t => t.Amount);

            CashInLiteral.Text = FormatMoney(cashIn);
            CashOutLiteral.Text = FormatMoney(cashOut);

            var rows = txns.Select(t => new WalletTxnRow
            {
                CreatedAtText = t.CreatedAt.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture),
                TypeLabel = ResolveTxnType(t.Type),
                AmountText = FormatMoney(t.Amount),
                Note = string.IsNullOrWhiteSpace(t.Note) ? "-" : t.Note
            }).ToList();

            WalletTxnRepeater.DataSource = rows;
            WalletTxnRepeater.DataBind();
        }
    }

    private static string ResolveTxnType(string type)
    {
        var code = (type ?? string.Empty).ToUpperInvariant();
        if (code == "PENDING_IN") return "Tiền vào (chờ)";
        if (code == "AVAILABLE_IN") return "Tiền vào (khả dụng)";
        if (code == "PAYOUT_HOLD") return "Giữ tiền rút";
        if (code == "PAYOUT_OUT") return "Chi trả rút";
        if (code == "ADJUST_IN") return "Điều chỉnh +";
        return string.IsNullOrWhiteSpace(type) ? "-" : type;
    }

    private static string FormatMoney(decimal amount)
    {
        return string.Format("{0:N0} đ", amount);
    }

    private class WalletTxnRow
    {
        public string CreatedAtText { get; set; }
        public string TypeLabel { get; set; }
        public string AmountText { get; set; }
        public string Note { get; set; }
    }
}
