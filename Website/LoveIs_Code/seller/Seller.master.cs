using System;
using System.Collections.Generic;
using System.Linq;

public partial class SellerMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        SellerNameLiteral.Text = SellerAuth.GetSellerDisplayName();
        BindLogo();
        BindMenu();
    }

    private void BindLogo()
    {
        if (LogoImage == null)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var info = db.CfContactInfos
                .Where(i => i.Status)
                .OrderBy(i => i.SortOrder)
                .ThenBy(i => i.Id)
                .FirstOrDefault();

            var logoUrl = info != null && !string.IsNullOrWhiteSpace(info.LogoHorizontalUrl)
                ? info.LogoHorizontalUrl
                : (info != null && !string.IsNullOrWhiteSpace(info.LogoVerticalUrl) ? info.LogoVerticalUrl : "/images/logo_ngang.png");

            LogoImage.ImageUrl = ResolveUrl(logoUrl);
        }
    }

    private void BindMenu()
    {
        using (var db = new BeautyStoryContext())
        {
            var currentPath = Request != null && Request.Url != null
                ? Request.Url.AbsolutePath
                : string.Empty;
            var currentPathAndQuery = Request != null && Request.Url != null
                ? Request.Url.PathAndQuery
                : string.Empty;
            var menus = db.CfMenus
                .Where(m => m.Status && m.MenuGroup == "SellerSidebar")
                .ToList();

            var items = menus
                .Where(m => !m.ParentId.HasValue)
                .OrderBy(m => m.SortOrder)
                .ThenBy(m => m.MenuName)
                .Select(m => new SellerMenuItem
                {
                    Id = m.Id,
                    MenuName = m.MenuName,
                    Url = string.IsNullOrWhiteSpace(m.Url) ? string.Empty : m.Url,
                    Icon = m.Icon,
                    Children = menus
                        .Where(c => c.ParentId == m.Id)
                        .OrderBy(c => c.SortOrder)
                        .ThenBy(c => c.MenuName)
                        .Select(c => new SellerMenuItem
                        {
                            Id = c.Id,
                            MenuName = c.MenuName,
                            Url = string.IsNullOrWhiteSpace(c.Url) ? string.Empty : c.Url,
                            Icon = c.Icon,
                            IsActive = IsActiveUrl(currentPath, currentPathAndQuery, c.Url)
                        })
                        .ToList()
                })
                .ToList();

            foreach (var item in items)
            {
                item.IsActive = IsActiveUrl(currentPath, currentPathAndQuery, item.Url) || item.Children.Any(c => c.IsActive);
                item.IsOpen = item.Children.Any(c => c.IsActive) || item.Children.Any(c => IsSamePath(currentPath, c.Url));
            }

            SellerMenuRepeater.DataSource = items;
            SellerMenuRepeater.DataBind();
        }
    }

    public class SellerMenuItem
    {
        public int Id { get; set; }
        public string MenuName { get; set; }
        public string Url { get; set; }
        public string Icon { get; set; }
        public List<SellerMenuItem> Children { get; set; }
        public bool IsActive { get; set; }
        public bool IsOpen { get; set; }
    }

    private static bool IsActiveUrl(string currentPath, string currentPathAndQuery, string targetUrl)
    {
        if ((string.IsNullOrWhiteSpace(currentPath) && string.IsNullOrWhiteSpace(currentPathAndQuery))
            || string.IsNullOrWhiteSpace(targetUrl))
        {
            return false;
        }

        var normalizedPath = (currentPath ?? string.Empty).TrimEnd('/').ToLowerInvariant();
        var normalizedPathAndQuery = (currentPathAndQuery ?? string.Empty).TrimEnd('/').ToLowerInvariant();
        var targetNormalized = targetUrl.TrimEnd('/').ToLowerInvariant();
        var targetPath = targetUrl.Split('?')[0].TrimEnd('/').ToLowerInvariant();

        if (targetNormalized.Contains("status=all"))
        {
            return !string.IsNullOrWhiteSpace(targetPath) && normalizedPath == targetPath;
        }

        if (targetNormalized.Contains("?"))
        {
            return normalizedPathAndQuery == targetNormalized;
        }

        return !string.IsNullOrWhiteSpace(targetPath) && normalizedPath == targetPath;
    }

    private static bool IsSamePath(string currentPath, string targetUrl)
    {
        if (string.IsNullOrWhiteSpace(currentPath) || string.IsNullOrWhiteSpace(targetUrl))
        {
            return false;
        }

        var normalizedPath = currentPath.TrimEnd('/').ToLowerInvariant();
        var targetPath = targetUrl.Split('?')[0].TrimEnd('/').ToLowerInvariant();
        return !string.IsNullOrWhiteSpace(targetPath) && normalizedPath == targetPath;
    }
}
