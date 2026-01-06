using System;
using System.Web;

public static class CustomerAuth
{
    private const string CustomerIdKey = "CustomerId";
    private const string CustomerNameKey = "CustomerDisplayName";
    private const string CustomerUsernameKey = "CustomerUsername";

    public static int? GetCustomerId()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return null;
        }

        var value = context.Session[CustomerIdKey];
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

    public static string GetCustomerDisplayName()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return string.Empty;
        }

        return context.Session[CustomerNameKey] != null ? context.Session[CustomerNameKey].ToString() : string.Empty;
    }

    public static bool IsSignedIn()
    {
        return GetCustomerId().HasValue;
    }

    public static void SignIn(CfCustomer customer)
    {
        if (customer == null)
        {
            return;
        }

        var context = HttpContext.Current;
        if (context == null)
        {
            return;
        }

        context.Session[CustomerIdKey] = customer.Id;
        context.Session[CustomerNameKey] = string.IsNullOrWhiteSpace(customer.DisplayName) ? customer.Username : customer.DisplayName;
        context.Session[CustomerUsernameKey] = customer.Username;
    }

    public static void SignOut()
    {
        var context = HttpContext.Current;
        if (context == null)
        {
            return;
        }

        context.Session.Remove(CustomerIdKey);
        context.Session.Remove(CustomerNameKey);
        context.Session.Remove(CustomerUsernameKey);
    }
}
