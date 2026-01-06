using System;
using System.Linq;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.HtmlControls;

public partial class PublicHeader : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindContactInfo();
            BindCartCount();
            BindCategoryMenu();
        }
    }

    private void BindContactInfo()
    {
        using (var db = new BeautyStoryContext())
        {
            var info = PublicCache.GetOrCreate("contact_info", 10, () => db.CfContactInfos
                .Where(i => i.Status)
                .OrderBy(i => i.SortOrder)
                .ThenBy(i => i.Id)
                .FirstOrDefault());

            var address = info != null && !string.IsNullOrWhiteSpace(info.Address)
                ? info.Address
                : "143 \u0110\u01b0\u1eddng s\u1ed1 32-CL, Ph\u01b0\u1eddng C\u00e1t L\u00e1i, TP H\u1ed3 Ch\u00ed Minh, Vi\u1ec7t Nam";

            var hotline = info != null && !string.IsNullOrWhiteSpace(info.Hotline)
                ? info.Hotline
                : "0828 409 096";

            var email = info != null && !string.IsNullOrWhiteSpace(info.Email)
                ? info.Email
                : "beautystory0909@gmail.com";

            AddressLiteral.Text =  HttpUtility.HtmlEncode(address);
            HotlineLiteral.Text = Literal1.Text = HttpUtility.HtmlEncode(hotline);
            EmailLiteral.Text = HttpUtility.HtmlEncode(email);

            if (HotlineLink != null)
            {
                HotlineLink.HRef = "tel:" + hotline.Replace(" ", string.Empty);
            }

            if (EmailLink != null)
            {
                EmailLink.HRef = "mailto:" + email;
            }

            var logoUrl = info != null && !string.IsNullOrWhiteSpace(info.LogoHorizontalUrl)
                ? info.LogoHorizontalUrl
                : "/images/logo_ngang.png";

            if (LogoMainImage != null)
            {
                LogoMainImage.ImageUrl = ResolveUrl(logoUrl);
            }

            if (LogoStickyImage != null)
            {
                LogoStickyImage.ImageUrl = ResolveUrl(logoUrl);
            }
        }
    }

    private void BindCartCount()
    {
        var cart = CartService.GetCart();
        var count = cart.Sum(item => item.Quantity);
        CartCountLiteral.Text = count.ToString();
        CartCountTextLiteral.Text = count.ToString();
        CartCountTextLiteralMobile.Text = count.ToString();
    }

    private void BindCategoryMenu()
    {
        using (var db = new BeautyStoryContext())
        {
            var allCategories = PublicCache.GetOrCreate("categories_all", 5, () => db.CfCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList());

            var slugs = PublicCache.GetOrCreate("slugs_all", 5, () => db.CfSeoSlugs.ToList());
            var slugLookup = slugs
                .GroupBy(s => s.EntityType)
                .ToDictionary(
                    g => g.Key,
                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            var menuItems = allCategories
                .Where(c => !c.ParentId.HasValue)
                .Select(c => new CategoryMenuItem
                {
                    Id = c.Id,
                    CategoryName = c.CategoryName,
                    SeoSlug = GetSlug(slugLookup, "Category", c.Id),
                    Children = allCategories
                        .Where(child => child.ParentId == c.Id && child.Status)
                        .OrderBy(child => child.SortOrder)
                        .ThenBy(child => child.CategoryName)
                        .Select(child => new CategoryMenuItem
                        {
                            Id = child.Id,
                            CategoryName = child.CategoryName,
                            SeoSlug = GetSlug(slugLookup, "Category", child.Id),
                            Children = allCategories
                                .Where(grand => grand.ParentId == child.Id && grand.Status)
                                .OrderBy(grand => grand.SortOrder)
                                .ThenBy(grand => grand.CategoryName)
                                .Select(grand => new CategoryMenuItem
                                {
                                    Id = grand.Id,
                                    CategoryName = grand.CategoryName,
                                    SeoSlug = GetSlug(slugLookup, "Category", grand.Id)
                                })
                                .ToList()
                        })
                        .ToList()
                })
                .Where(item => !string.IsNullOrWhiteSpace(item.SeoSlug))
                .ToList();

            CategoryMenuRepeater.DataSource = menuItems;
            CategoryMenuRepeater.DataBind();

            CategoryPanelRepeater.DataSource = menuItems;
            CategoryPanelRepeater.DataBind();

            MobileCategoryRepeater.DataSource = menuItems;
            MobileCategoryRepeater.DataBind();
        }
    }

    private static string GetSlug(Dictionary<string, Dictionary<int, string>> lookup, string entityType, int entityId)
    {
        if (!lookup.ContainsKey(entityType))
        {
            return string.Empty;
        }

        var entityLookup = lookup[entityType];
        return entityLookup.ContainsKey(entityId) ? entityLookup[entityId] : string.Empty;
    }

    public string GetMenuItemActiveClass(int index)
    {
        return index == 0 ? "active" : string.Empty;
    }

    public string GetPanelActiveClass(int index)
    {
        return index == 0 ? "active" : string.Empty;
    }

    public class CategoryMenuItem
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public List<CategoryMenuItem> Children { get; set; }
    }
}
