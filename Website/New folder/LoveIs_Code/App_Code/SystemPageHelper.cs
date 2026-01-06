using System.Linq;

public static class SystemPageHelper
{
    public static CfStaticPage GetStaticPageForSystemPage(BeautyStoryContext db, string pageKey)
    {
        if (db == null || string.IsNullOrWhiteSpace(pageKey))
        {
            return null;
        }

        var systemPage = db.CfSystemPages.FirstOrDefault(p => p.PageKey == pageKey && p.Status);
        if (systemPage == null || !systemPage.StaticPageId.HasValue)
        {
            return null;
        }

        return db.CfStaticPages.FirstOrDefault(p => p.Id == systemPage.StaticPageId.Value && p.Status);
    }
}
