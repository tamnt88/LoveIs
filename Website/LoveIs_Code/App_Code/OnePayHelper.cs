using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Configuration;

public class OnePayRequest
{
    public string MerchantId { get; set; }
    public string AccessCode { get; set; }
    public string SecureHash { get; set; }
    public string BaseUrl { get; set; }
    public string UrlPrefix { get; set; }
    public string ReturnUrl { get; set; }
    public string CallbackUrl { get; set; }
    public string MerchantTxnRef { get; set; }
    public string OrderInfo { get; set; }
    public string Currency { get; set; }
    public string Locale { get; set; }
    public string TicketNo { get; set; }
    public string CustomerId { get; set; }
    public string CustomerEmail { get; set; }
    public string CustomerPhone { get; set; }
    public string CardList { get; set; }
    public long Amount { get; set; }
}

public static class OnePayHelper
{
    public static string BuildPaymentUrl(OnePayRequest request)
    {
        if (request == null)
        {
            throw new ArgumentNullException("request");
        }

        var parameters = new Dictionary<string, string>
        {
            { "vpc_Version", "2" },
            { "vpc_Command", "pay" },
            { "vpc_AccessCode", request.AccessCode ?? string.Empty },
            { "vpc_Merchant", request.MerchantId ?? string.Empty },
            { "vpc_Locale", string.IsNullOrWhiteSpace(request.Locale) ? "vn" : request.Locale },
            { "vpc_Currency", string.IsNullOrWhiteSpace(request.Currency) ? "VND" : request.Currency },
            { "vpc_ReturnURL", request.ReturnUrl ?? string.Empty },
            { "vpc_MerchTxnRef", request.MerchantTxnRef ?? string.Empty },
            { "vpc_OrderInfo", request.OrderInfo ?? string.Empty },
            { "vpc_Amount", request.Amount.ToString() }
        };

        if (!string.IsNullOrWhiteSpace(request.CallbackUrl))
        {
            parameters["vpc_CallbackURL"] = request.CallbackUrl;
        }

        if (!string.IsNullOrWhiteSpace(request.TicketNo))
        {
            parameters["vpc_TicketNo"] = request.TicketNo;
        }

        if (!string.IsNullOrWhiteSpace(request.CustomerId))
        {
            parameters["vpc_Customer_Id"] = request.CustomerId;
        }

        if (!string.IsNullOrWhiteSpace(request.CustomerEmail))
        {
            parameters["vpc_Customer_Email"] = request.CustomerEmail;
        }

        if (!string.IsNullOrWhiteSpace(request.CustomerPhone))
        {
            parameters["vpc_Customer_Phone"] = request.CustomerPhone;
        }

        if (!string.IsNullOrWhiteSpace(request.CardList))
        {
            parameters["vpc_CardList"] = request.CardList;
        }

        var sorted = parameters.OrderBy(k => k.Key, StringComparer.Ordinal)
            .ToDictionary(x => x.Key, x => x.Value);
        var stringToHash = BuildStringToHash(sorted);
        var signature = CreateSecureHash(stringToHash, request.SecureHash ?? string.Empty);
        parameters["vpc_SecureHash"] = signature;

        var query = BuildQueryString(parameters);
        var baseUrl = string.IsNullOrWhiteSpace(request.BaseUrl) ? "https://mtf.onepay.vn" : request.BaseUrl;
        var prefix = string.IsNullOrWhiteSpace(request.UrlPrefix) ? "/paygate/vpcpay.op?" : request.UrlPrefix;
        return baseUrl.TrimEnd('/') + prefix + query;
    }

    public static bool ValidateSecureHash(NameValueCollection parameters, string secureHash)
    {
        if (parameters == null || string.IsNullOrWhiteSpace(secureHash))
        {
            return false;
        }

        var data = new Dictionary<string, string>();
        foreach (string key in parameters.Keys)
        {
            if (string.IsNullOrWhiteSpace(key))
            {
                continue;
            }
            if (key.StartsWith("vpc_", StringComparison.OrdinalIgnoreCase) ||
                key.StartsWith("user_", StringComparison.OrdinalIgnoreCase))
            {
                if (key.Equals("vpc_SecureHash", StringComparison.OrdinalIgnoreCase) ||
                    key.Equals("vpc_SecureHashType", StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }
                data[key] = parameters[key];
            }
        }

        var sorted = data.OrderBy(k => k.Key, StringComparer.Ordinal)
            .ToDictionary(x => x.Key, x => x.Value);
        var stringToHash = BuildStringToHash(sorted);
        var expected = CreateSecureHash(stringToHash, secureHash);
        var actual = parameters["vpc_SecureHash"];
        return !string.IsNullOrWhiteSpace(actual) &&
               expected.Equals(actual, StringComparison.OrdinalIgnoreCase);
    }

    public static long ToOnePayAmount(decimal amount)
    {
        return (long)Math.Round(amount * 100m, 0, MidpointRounding.AwayFromZero);
    }

    public static string GetSetting(string key, string fallback)
    {
        var value = WebConfigurationManager.AppSettings[key];
        return string.IsNullOrWhiteSpace(value) ? fallback : value.Trim();
    }

    private static string BuildStringToHash(Dictionary<string, string> sorted)
    {
        var builder = new StringBuilder();
        foreach (var item in sorted)
        {
            if (string.IsNullOrWhiteSpace(item.Value))
            {
                continue;
            }
            if (builder.Length > 0)
            {
                builder.Append("&");
            }
            builder.Append(item.Key).Append("=").Append(item.Value);
        }
        return builder.ToString();
    }

    private static string BuildQueryString(Dictionary<string, string> parameters)
    {
        var builder = new StringBuilder();
        foreach (var item in parameters)
        {
            builder.Append(item.Key)
                .Append("=")
                .Append(HttpUtility.UrlEncode(item.Value ?? string.Empty))
                .Append("&");
        }
        return builder.ToString();
    }

    private static string CreateSecureHash(string data, string secureHash)
    {
        var key = HexToBytes(secureHash);
        using (var hmac = new HMACSHA256(key))
        {
            var inputBytes = Encoding.UTF8.GetBytes(data ?? string.Empty);
            var hashBytes = hmac.ComputeHash(inputBytes);
            return BitConverter.ToString(hashBytes).Replace("-", "").ToUpperInvariant();
        }
    }

    private static byte[] HexToBytes(string hex)
    {
        if (string.IsNullOrWhiteSpace(hex))
        {
            return new byte[0];
        }
        var bytes = new byte[hex.Length / 2];
        for (var i = 0; i < bytes.Length; i++)
        {
            bytes[i] = Convert.ToByte(hex.Substring(i * 2, 2), 16);
        }
        return bytes;
    }
}
