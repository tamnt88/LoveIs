using System;
using System.Collections.Specialized;
using System.Linq;

public partial class OnePayIpn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var secureHash = OnePayHelper.GetSetting("OnePay:HashCode", "6D0870CDE5F24F34F3915FB0045120D6");
        NameValueCollection parameters = Request.HttpMethod == "POST" ? Request.Form : Request.QueryString;
        var isValid = OnePayHelper.ValidateSecureHash(parameters, secureHash);
        var responseCode = parameters["vpc_TxnResponseCode"] ?? string.Empty;
        var orderCode = parameters["vpc_MerchTxnRef"] ?? string.Empty;
        var providerRef = parameters["vpc_TransactionNo"] ?? string.Empty;
        var bankCode = parameters["vpc_Card"] ?? string.Empty;
        var cardType = parameters["vpc_CardList"] ?? string.Empty;
        var cardNumber = parameters["vpc_CardNum"] ?? string.Empty;

        if (!string.IsNullOrWhiteSpace(orderCode))
        {
            using (var db = new BeautyStoryContext())
            {
                var order = db.CfOrders.FirstOrDefault(o => o.OrderCode == orderCode);
                if (order != null)
                {
                    var isSuccess = isValid && responseCode == "0";
                    var paymentStatus = GetPaymentStatus(db, isSuccess);
                    if (paymentStatus != null)
                    {
                        order.PaymentStatusId = paymentStatus.Id;
                        order.PaymentStatus = paymentStatus.Name;
                    }
                    order.UpdatedAt = DateTime.Now;
                    order.UpdatedBy = "onepay-ipn";
                    var shopOrders = db.CfShopOrders.Where(so => so.OrderId == order.Id).ToList();
                    if (paymentStatus != null)
                    {
                        foreach (var shopOrder in shopOrders)
                        {
                            shopOrder.PaymentStatus = paymentStatus.Name;
                            shopOrder.UpdatedAt = DateTime.Now;
                            shopOrder.UpdatedBy = "onepay-ipn";
                        }
                    }
                    db.SaveChanges();

                    var transaction = db.CfPaymentTransactions.FirstOrDefault(t => t.OrderId == order.Id && t.Provider == "ONEPAY");
                    if (transaction == null)
                    {
                        transaction = new CfPaymentTransaction
                        {
                            OrderId = order.Id,
                            Provider = "ONEPAY",
                            CreatedAt = DateTime.Now,
                            CreatedBy = "onepay-ipn",
                            SortOrder = 0
                        };
                        db.CfPaymentTransactions.Add(transaction);
                    }

                    transaction.ProviderRef = string.IsNullOrWhiteSpace(providerRef) ? orderCode : providerRef;
                    transaction.Status = paymentStatus != null ? paymentStatus.Name : transaction.Status;
                    transaction.ResponseCode = responseCode;
                    transaction.Amount = order.Total;
                    transaction.BankCode = bankCode;
                    transaction.CardType = cardType;
                    transaction.CardNumber = cardNumber;
                    transaction.MetaJson = BuildMetaString(parameters);
                    transaction.UpdatedAt = DateTime.Now;
                    transaction.UpdatedBy = "onepay-ipn";
                    db.SaveChanges();

                    if (isSuccess)
                    {
                        ShopWalletService.AddPendingForPaidOrder(db, order, shopOrders, "onepay-ipn");
                        db.SaveChanges();
                    }
                }
            }
        }

        Response.StatusCode = 200;
        Response.ContentType = "text/plain";
        Response.Write("responsecode=1&desc=confirm-success");
    }

    private static CfPaymentStatus GetPaymentStatus(BeautyStoryContext db, bool success)
    {
        if (db == null)
        {
            return null;
        }

        if (success)
        {
            return GetPaymentStatusByCode(db, "PAID")
                ?? GetPaymentStatusByCode(db, "SUCCESS")
                ?? GetPaymentStatusByCode(db, "PENDING");
        }

        return GetPaymentStatusByCode(db, "FAILED")
            ?? GetPaymentStatusByCode(db, "CANCELLED")
            ?? GetPaymentStatusByCode(db, "PENDING");
    }

    private static CfPaymentStatus GetPaymentStatusByCode(BeautyStoryContext db, string code)
    {
        if (db == null || string.IsNullOrWhiteSpace(code))
        {
            return null;
        }

        var key = code.Trim().ToUpperInvariant();
        return db.CfPaymentStatuses.FirstOrDefault(s => s.Status && (s.Code ?? string.Empty).Trim().ToUpper() == key);
    }

    private static string BuildMetaString(NameValueCollection query)
    {
        if (query == null)
        {
            return string.Empty;
        }

        return string.Join("&", query.AllKeys
            .Where(k => !string.IsNullOrWhiteSpace(k))
            .Select(k => k + "=" + (query[k] ?? string.Empty)));
    }
}
