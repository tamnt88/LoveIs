using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;

public static class CommunityHelper
{
    public const string ActionPost = "post";
    public const string ActionComment = "comment";

    public static bool IsRateLimited(int customerId, string actionType, int limit, int minutes)
    {
        var since = DateTime.UtcNow.AddMinutes(-minutes);
        using (var db = new BeautyStoryContext())
        {
            var count = db.CfCommunityActionLogs
                .Where(a => a.CustomerId == customerId && a.ActionType == actionType && a.CreatedAt >= since)
                .Count();
            return count >= limit;
        }
    }

    public static void LogAction(int customerId, string actionType, string meta)
    {
        using (var db = new BeautyStoryContext())
        {
            db.CfCommunityActionLogs.Add(new CfCommunityActionLog
            {
                CustomerId = customerId,
                ActionType = actionType,
                Meta = meta,
                CreatedAt = DateTime.UtcNow
            });
            db.SaveChanges();
        }
    }

    public static bool HasOnlyWhitelistedLinks(string content)
    {
        var urls = ExtractUrls(content);
        if (urls.Count == 0)
        {
            return true;
        }

        var whitelist = GetWhitelistDomains();
        if (whitelist.Count == 0)
        {
            return false;
        }

        foreach (var url in urls)
        {
            var host = GetHost(url);
            if (string.IsNullOrWhiteSpace(host))
            {
                return false;
            }

            var allowed = whitelist.Any(d => host.Equals(d, StringComparison.OrdinalIgnoreCase)
                || host.EndsWith("." + d, StringComparison.OrdinalIgnoreCase));
            if (!allowed)
            {
                return false;
            }
        }

        return true;
    }

    private static List<string> ExtractUrls(string content)
    {
        var results = new List<string>();
        if (string.IsNullOrWhiteSpace(content))
        {
            return results;
        }

        var matches = Regex.Matches(content, @"https?://[^\s]+", RegexOptions.IgnoreCase);
        foreach (Match match in matches)
        {
            results.Add(match.Value.Trim());
        }

        return results;
    }

    private static string GetHost(string url)
    {
        try
        {
            var uri = new Uri(url);
            return uri.Host;
        }
        catch
        {
            return null;
        }
    }

    private static List<string> GetWhitelistDomains()
    {
        var value = WebConfigurationManager.AppSettings["CommunityLinkWhitelist"] ?? string.Empty;
        return value.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(x => x.Trim().ToLowerInvariant())
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .ToList();
    }

    public static string NormalizeContent(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return string.Empty;
        }

        return HttpUtility.HtmlEncode(content.Trim());
    }
}
