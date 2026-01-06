using System;
using System.Web;
using System.Web.UI.WebControls;

public static class SystemPageSeoApplier
{
    public static void Apply(string pageKey, Literal titleLiteral, Literal metaLiteral, string fallbackTitle, string canonicalUrl)
    {
        using (var db = new BeautyStoryContext())
        {
            var page = SystemPageHelper.GetStaticPageForSystemPage(db, pageKey);
            if (page == null)
            {
                if (titleLiteral != null && !string.IsNullOrWhiteSpace(fallbackTitle))
                {
                    titleLiteral.Text = HttpUtility.HtmlEncode(fallbackTitle);
                }
                return;
            }

            string title = !string.IsNullOrWhiteSpace(page.SeoTitle) ? page.SeoTitle : page.PageName;
            if (titleLiteral != null)
            {
                titleLiteral.Text = HttpUtility.HtmlEncode(title);
            }

            string canonical = !string.IsNullOrWhiteSpace(page.CanonicalUrl)
                ? page.CanonicalUrl
                : canonicalUrl;

            if (metaLiteral != null)
            {
                metaLiteral.Text = SeoMetaHelper.BuildSeoMetaHtml(
                    canonical,
                    page.SeoDescription,
                    page.SeoKeywords,
                    page.Robots,
                    string.IsNullOrWhiteSpace(page.OgTitle) ? title : page.OgTitle,
                    page.OgDescription,
                    page.OgImage,
                    page.OgType,
                    string.IsNullOrWhiteSpace(page.TwitterTitle) ? title : page.TwitterTitle,
                    page.TwitterDescription,
                    page.TwitterImage);
            }
        }
    }
}
