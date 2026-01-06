using System.Collections.Generic;
using System.Linq;
using System.Web;

public static class SeoMetaHelper
{
    public static string BuildSeoMetaHtml(
        string canonical,
        string description,
        string keywords,
        string robots,
        string ogTitle,
        string ogDescription,
        string ogImage,
        string ogType,
        string twitterTitle,
        string twitterDescription,
        string twitterImage)
    {
        var tags = BuildSeoMeta(
            canonical,
            description,
            keywords,
            robots,
            ogTitle,
            ogDescription,
            ogImage,
            ogType,
            twitterTitle,
            twitterDescription,
            twitterImage);

        return string.Join("\n", tags);
    }

    public static IEnumerable<string> BuildSeoMeta(
        string canonical,
        string description,
        string keywords,
        string robots,
        string ogTitle,
        string ogDescription,
        string ogImage,
        string ogType,
        string twitterTitle,
        string twitterDescription,
        string twitterImage)
    {
        var tags = new List<string>();

        if (!string.IsNullOrWhiteSpace(description))
        {
            tags.Add(string.Format("<meta name=\"description\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(description)));
        }

        if (!string.IsNullOrWhiteSpace(keywords))
        {
            tags.Add(string.Format("<meta name=\"keywords\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(keywords)));
        }

        if (!string.IsNullOrWhiteSpace(robots))
        {
            tags.Add(string.Format("<meta name=\"robots\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(robots)));
        }

        if (!string.IsNullOrWhiteSpace(canonical))
        {
            var canonicalValue = HttpUtility.HtmlAttributeEncode(canonical);
            tags.Add(string.Format("<link rel=\"canonical\" href=\"{0}\" />", canonicalValue));
            tags.Add(string.Format("<meta property=\"og:url\" content=\"{0}\" />", canonicalValue));
        }

        if (!string.IsNullOrWhiteSpace(ogTitle))
        {
            tags.Add(string.Format("<meta property=\"og:title\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogTitle)));
        }

        if (!string.IsNullOrWhiteSpace(ogDescription))
        {
            tags.Add(string.Format("<meta property=\"og:description\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogDescription)));
        }

        if (!string.IsNullOrWhiteSpace(ogImage))
        {
            tags.Add(string.Format("<meta property=\"og:image\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogImage)));
        }

        if (!string.IsNullOrWhiteSpace(ogType))
        {
            tags.Add(string.Format("<meta property=\"og:type\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(ogType)));
        }

        if (!string.IsNullOrWhiteSpace(twitterTitle))
        {
            tags.Add(string.Format("<meta name=\"twitter:title\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(twitterTitle)));
        }

        if (!string.IsNullOrWhiteSpace(twitterDescription))
        {
            tags.Add(string.Format("<meta name=\"twitter:description\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(twitterDescription)));
        }

        if (!string.IsNullOrWhiteSpace(twitterImage))
        {
            tags.Add(string.Format("<meta name=\"twitter:image\" content=\"{0}\" />", HttpUtility.HtmlAttributeEncode(twitterImage)));
        }

        return tags.Where(t => !string.IsNullOrWhiteSpace(t));
    }
}
