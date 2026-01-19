using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class SellerFinanceCashflow : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult CreatePayoutRequest(int shopId, int bankAccountId, decimal amount, string note)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var ownsShop = db.CfShops.Any(s => s.Id == shopId && s.SellerId == sellerId.Value);
            if (!ownsShop)
            {
                return new ActionResult { Success = false, Message = "Shop khong hop le." };
            }

            var request = ShopWalletService.CreatePayoutRequest(db, shopId, bankAccountId, amount, sellerId.Value.ToString(), note);
            if (request == null)
            {
                return new ActionResult { Success = false, Message = "Khong du so du kha dung hoac thong tin khong hop le." };
            }

            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da tao lenh rut tien." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static PayoutFormData GetPayoutFormData()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return new PayoutFormData();
        }

        using (var db = new BeautyStoryContext())
        {
            var shops = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .OrderBy(s => s.ShopName)
                .Select(s => new PayoutOption
                {
                    Id = s.Id,
                    Name = s.ShopName
                })
                .ToList();

            var shopIds = shops.Select(s => s.Id).ToList();
            var banks = db.CfShopBanks
                .Where(b => shopIds.Contains(b.ShopId))
                .OrderByDescending(b => b.IsDefault)
                .ThenBy(b => b.BankName)
                .Select(b => new PayoutOption
                {
                    Id = b.Id,
                    Name = (b.BankName ?? string.Empty) + " - " + (b.AccountNumber ?? string.Empty)
                })
                .ToList();

            return new PayoutFormData
            {
                Shops = shops,
                Banks = banks
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<PayoutRequestRow> GetPayoutRequests()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return new List<PayoutRequestRow>();
        }

        using (var db = new BeautyStoryContext())
        {
            var rows = (from r in db.CfShopPayoutRequests
                        join s in db.CfShops on r.ShopId equals s.Id
                        join b in db.CfShopBanks on r.BankAccountId equals b.Id
                        where s.SellerId == sellerId.Value
                        orderby r.RequestedAt descending, r.Id descending
                        select new PayoutRequestRow
                        {
                            ShopName = s.ShopName,
                            Amount = r.Amount,
                            BankName = b.BankName,
                            Status = r.Status,
                            RequestedAt = r.RequestedAt
                        }).ToList();

            foreach (var row in rows)
            {
                row.AmountText = FormatMoney(row.Amount);
                row.RequestedAtText = FormatDateTime(row.RequestedAt);
            }

            return rows;
        }
    }

    private static string FormatMoney(decimal amount)
    {
        return amount.ToString("#,0") + " d";
    }

    private static string FormatDateTime(DateTime value)
    {
        return value.ToString("dd/MM/yyyy HH:mm");
    }

    public class PayoutFormData
    {
        public List<PayoutOption> Shops { get; set; }
        public List<PayoutOption> Banks { get; set; }

        public PayoutFormData()
        {
            Shops = new List<PayoutOption>();
            Banks = new List<PayoutOption>();
        }
    }

    public class PayoutOption
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public class PayoutRequestRow
    {
        public string ShopName { get; set; }
        public decimal Amount { get; set; }
        public string AmountText { get; set; }
        public string BankName { get; set; }
        public string Status { get; set; }
        public DateTime RequestedAt { get; set; }
        public string RequestedAtText { get; set; }
    }
}
