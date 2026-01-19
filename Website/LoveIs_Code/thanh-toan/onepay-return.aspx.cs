using System;
using System.Collections.Specialized;
using System.Linq;

public partial class OnePayReturn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var secureHash = OnePayHelper.GetSetting("OnePay:HashCode", "6D0870CDE5F24F34F3915FB0045120D6");
        var query = Request.QueryString;
        var isValid = OnePayHelper.ValidateSecureHash(query, secureHash);
        var responseCode = query["vpc_TxnResponseCode"] ?? string.Empty;
        var orderCode = query["vpc_MerchTxnRef"] ?? string.Empty;

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
                    order.UpdatedBy = "onepay-return";
                    if (paymentStatus != null)
                    {
                        var shopOrders = db.CfShopOrders.Where(so => so.OrderId == order.Id).ToList();
                        foreach (var shopOrder in shopOrders)
                        {
                            shopOrder.PaymentStatus = paymentStatus.Name;
                            shopOrder.UpdatedAt = DateTime.Now;
                            shopOrder.UpdatedBy = "onepay-return";
                        }
                    }
                    db.SaveChanges();
                }
            }
        }

        if (!string.IsNullOrWhiteSpace(orderCode))
        {
            Response.Redirect("/thanh-toan/hoan-tat.aspx?code=" + Server.UrlEncode(orderCode));
            return;
        }

        MessageLiteral.Text = "Khong tim thay don hang.";
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
}
