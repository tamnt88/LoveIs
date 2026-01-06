using System;
using System.Web;

public static class SellerAuth
{
    private const string SellerIdKey = "SellerId";
    private const string SellerNameKey = "SellerDisplayName";
    private const string SellerUsernameKey = "SellerUsername";

    public static int? GetSellerId()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return null;
        }

        var value = context.Session[SellerIdKey];
        if (value == null)
        {
            return null;
        }

        int id;
        if (int.TryParse(value.ToString(), out id))
        {
            return id;
        }

        return null;
    }

    public static string GetSellerDisplayName()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return string.Empty;
        }

        return context.Session[SellerNameKey] != null ? context.Session[SellerNameKey].ToString() : string.Empty;
    }

    public static bool IsSignedIn()
    {
        return GetSellerId().HasValue;
    }

    public static void SignIn(CfSeller seller)
    {
        if (seller == null)
        {
            return;
        }

        var context = HttpContext.Current;
        if (context == null)
        {
            return;
        }

        context.Session[SellerIdKey] = seller.Id;
        context.Session[SellerNameKey] = string.IsNullOrWhiteSpace(seller.DisplayName) ? seller.Username : seller.DisplayName;
        context.Session[SellerUsernameKey] = seller.Username;
    }

    public static void SignOut()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return;
        }

        context.Session.Remove(SellerIdKey);
        context.Session.Remove(SellerNameKey);
        context.Session.Remove(SellerUsernameKey);
    }
}
