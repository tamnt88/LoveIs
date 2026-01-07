using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;

public partial class PublicFooter : System.Web.UI.UserControl
{
    protected string ContactHotlineText { get; private set; }
    protected string ContactHotlineTelText { get; private set; }
    protected string ContactEmailText { get; private set; }
    protected string ContactAddressText { get; private set; }
    protected string ContactLogoUrl { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindContactInfo();
            BindFooterMenus();
            BindSocialLinks();
        }
    }

    protected void FooterGroupRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        var group = e.Item.DataItem as FooterMenuGroup;
        if (group == null)
        {
            return;
        }

        var repeater = e.Item.FindControl("FooterItemRepeater") as Repeater;
        if (repeater == null)
        {
            return;
        }

        repeater.DataSource = group.Items;
        repeater.DataBind();
    }

    protected string GetFooterUrl(object urlObj)
    {
        var url = urlObj as string;
        return string.IsNullOrWhiteSpace(url) ? "#" : url.Trim();
    }

    private void BindFooterMenus()
    {
        using (var db = new BeautyStoryContext())
        {
            var items = db.CfFooterMenus.AsNoTracking()
                .Where(m => m.Status)
                .OrderBy(m => m.GroupSortOrder)
                .ThenBy(m => m.SortOrder)
                .ToList();

            var groups = items
                .GroupBy(m => m.GroupName)
                .Select(g => new FooterMenuGroup
                {
                    GroupName = g.Key,
                    Items = g.ToList()
                })
                .ToList();

            FooterGroupRepeater.DataSource = groups;
            FooterGroupRepeater.DataBind();
        }
    }

    private void BindContactInfo()
    {
        using (var db = new BeautyStoryContext())
        {
            var info = db.CfContactInfos.AsNoTracking()
                .Where(i => i.Status)
                .OrderBy(i => i.SortOrder)
                .ThenBy(i => i.Id)
                .FirstOrDefault();

            ContactHotlineText = info == null || string.IsNullOrWhiteSpace(info.Hotline) ? "0909 221 558" : info.Hotline.Trim();
            ContactHotlineTelText = ContactHotlineText.Replace(" ", string.Empty);
            ContactEmailText = info == null || string.IsNullOrWhiteSpace(info.Email) ? "beautystory0909@gmail.com" : info.Email.Trim();
            ContactAddressText = info == null || string.IsNullOrWhiteSpace(info.Address)
                ? "143 Ä‘Æ°á»ng sá»‘ 32-CL, PhÆ°á»ng CÃ¡t LÃ¡i, TP Há»“ ChÃ­ Minh, Viá»‡t Nam"
                : info.Address.Trim();
            ContactLogoUrl = info == null || string.IsNullOrWhiteSpace(info.LogoVerticalUrl) ? "/images/logo_doc.png" : info.LogoVerticalUrl.Trim();
        }
    }

    private void BindSocialLinks()
    {
        using (var db = new BeautyStoryContext())
        {
            var links = db.CfSocialLinks.AsNoTracking()
                .Where(l => l.Status)
                .OrderBy(l => l.SortOrder)
                .ThenBy(l => l.Id)
                .ToList();

            FooterSocialRepeater.DataSource = links;
            FooterSocialRepeater.DataBind();
        }
    }

    protected string GetContactLogoUrl()
    {
        var url = ContactLogoUrl;
        if (string.IsNullOrWhiteSpace(url))
        {
            url = "/images/logo_doc.png";
        }

        return url.StartsWith("http", StringComparison.OrdinalIgnoreCase) ? url : ResolveUrl(url);
    }

    private sealed class FooterMenuGroup
    {
        public string GroupName { get; set; }
        public List<CfFooterMenu> Items { get; set; }
    }
}


