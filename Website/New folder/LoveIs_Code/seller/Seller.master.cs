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
                            Icon = c.Icon
                        })
                        .ToList()
                })
                .ToList();

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
    }
}
