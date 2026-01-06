using System;
using System.Linq;
using System.Web;

public partial class StaticPageDefault : System.Web.UI.Page
{
    private string _activeSlug;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            return;
        }

        _activeSlug = RouteData.Values["slug"] != null ? RouteData.Values["slug"].ToString() : string.Empty;
        if (string.IsNullOrWhiteSpace(_activeSlug))
        {
            Response.StatusCode = 404;
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var slugEntry = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "StaticPage" && s.SeoSlug == _activeSlug);
            if (slugEntry == null)
            {
                Response.StatusCode = 404;
                return;
            }

            var page = db.CfStaticPages.FirstOrDefault(p => p.Id == slugEntry.EntityId && p.Status);
            if (page == null)
            {
                Response.StatusCode = 404;
                return;
            }

            string pageTitle = !string.IsNullOrWhiteSpace(page.SeoTitle) ? page.SeoTitle : page.PageName;
            SeoTitleLiteral.Text = HttpUtility.HtmlEncode(pageTitle);
            PageTitleLiteral.Text = HttpUtility.HtmlEncode(page.PageName);
            ContentLiteral.Text = page.Content ?? string.Empty;

            string canonical = !string.IsNullOrWhiteSpace(page.CanonicalUrl)
                ? page.CanonicalUrl
                : string.Format("{0}/trang/{1}", Request.Url.GetLeftPart(UriPartial.Authority), _activeSlug);

            string metaHtml = SeoMetaHelper.BuildSeoMetaHtml(
                canonical,
                page.SeoDescription,
                page.SeoKeywords,
                page.Robots,
                string.IsNullOrWhiteSpace(page.OgTitle) ? pageTitle : page.OgTitle,
                page.OgDescription,
                page.OgImage,
                page.OgType,
                string.IsNullOrWhiteSpace(page.TwitterTitle) ? pageTitle : page.TwitterTitle,
                page.TwitterDescription,
                page.TwitterImage);

            SeoMetaLiteral.Text = metaHtml;

            BindMenu(db);
        }
    }

    protected void MenuGroupRepeater_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != System.Web.UI.WebControls.ListItemType.Item &&
            e.Item.ItemType != System.Web.UI.WebControls.ListItemType.AlternatingItem)
        {
            return;
        }

        var group = e.Item.DataItem as MenuGroupView;
        if (group == null)
        {
            return;
        }

        var repeater = e.Item.FindControl("MenuItemRepeater") as System.Web.UI.WebControls.Repeater;
        if (repeater == null)
        {
            return;
        }

        repeater.DataSource = group.Items;
        repeater.DataBind();
    }

    private void BindMenu(BeautyStoryContext db)
    {
        var currentPath = Request.Url != null ? Request.Url.AbsolutePath : string.Empty;

        var items = db.CfFooterMenus
            .Where(m => m.Status)
            .OrderBy(m => m.GroupSortOrder)
            .ThenBy(m => m.SortOrder)
            .ToList();

        var groups = items
            .GroupBy(m => m.GroupName)
            .Select(g => new MenuGroupView
            {
                GroupName = g.Key,
                Items = g.Select(item => new MenuItemView
                {
                    Title = item.Title,
                    Url = NormalizeMenuUrl(item.Url),
                    IsActive = IsActiveUrl(currentPath, item.Url) ? "active" : string.Empty
                }).ToList()
            })
            .ToList();

        MenuGroupRepeater.DataSource = groups;
        MenuGroupRepeater.DataBind();
    }

    private static string NormalizeMenuUrl(string url)
    {
        if (string.IsNullOrWhiteSpace(url))
        {
            return "#";
        }

        return url.Trim();
    }

    private static bool IsActiveUrl(string currentPath, string menuUrl)
    {
        if (string.IsNullOrWhiteSpace(currentPath) || string.IsNullOrWhiteSpace(menuUrl))
        {
            return false;
        }

        var normalizedPath = currentPath.Trim().TrimEnd('/').ToLowerInvariant();
        var normalizedUrl = menuUrl.Trim().TrimEnd('/').ToLowerInvariant();
        return normalizedPath == normalizedUrl;
    }

    private class MenuGroupView
    {
        public string GroupName { get; set; }
        public System.Collections.Generic.List<MenuItemView> Items { get; set; }
    }

    private class MenuItemView
    {
        public string Title { get; set; }
        public string Url { get; set; }
        public string IsActive { get; set; }
    }
}
