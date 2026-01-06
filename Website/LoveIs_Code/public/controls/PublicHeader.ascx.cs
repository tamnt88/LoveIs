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
            BindPostCategoryMenu();
            BindCustomerLinks();
            BindNotifications();
            BindMessageBadge();
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

    private void BindPostCategoryMenu()
    {
        using (var db = new BeautyStoryContext())
        {
            var allCategories = PublicCache.GetOrCreate("post_categories_all", 5, () => db.CfPostCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList());

            var slugs = PublicCache.GetOrCreate("post_slugs_all", 5, () => db.CfSeoSlugs
                .Where(s => s.EntityType == "PostCategory")
                .ToList());

            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var menuItems = allCategories
                .Where(c => !c.ParentId.HasValue)
                .Select(c => new PostCategoryMenuItem
                {
                    Id = c.Id,
                    CategoryName = c.CategoryName,
                    SeoSlug = slugLookup.ContainsKey(c.Id) ? slugLookup[c.Id] : string.Empty,
                    Children = allCategories
                        .Where(child => child.ParentId == c.Id && child.Status)
                        .OrderBy(child => child.SortOrder)
                        .ThenBy(child => child.CategoryName)
                        .Select(child => new PostCategoryMenuItem
                        {
                            Id = child.Id,
                            CategoryName = child.CategoryName,
                            SeoSlug = slugLookup.ContainsKey(child.Id) ? slugLookup[child.Id] : string.Empty
                        })
                        .Where(item => !string.IsNullOrWhiteSpace(item.SeoSlug))
                        .ToList()
                })
                .Where(item => !string.IsNullOrWhiteSpace(item.SeoSlug))
                .ToList();

            PostCategoryMenuRepeater.DataSource = menuItems;
            PostCategoryMenuRepeater.DataBind();

            PostCategoryMobileRepeater.DataSource = menuItems;
            PostCategoryMobileRepeater.DataBind();
        }
    }

    private void BindCustomerLinks()
    {
        bool signedIn = CustomerAuth.IsSignedIn();
        if (!signedIn)
        {
            var path = HttpContext.Current != null && HttpContext.Current.Request != null
                ? (HttpContext.Current.Request.Path ?? string.Empty).ToLowerInvariant()
                : string.Empty;
            if (path.StartsWith("/cong-dong") && SellerAuth.IsSignedIn())
            {
                CommunityUserHelper.EnsureCommunityCustomerId();
                signedIn = CustomerAuth.IsSignedIn();
            }
        }
        if (GuestLinks != null)
        {
            GuestLinks.Visible = !signedIn;
        }

        if (CustomerLinks != null)
        {
            CustomerLinks.Visible = signedIn;
        }

        if (CustomerNameLiteral != null && signedIn)
        {
            CustomerNameLiteral.Text = HttpUtility.HtmlEncode(CustomerAuth.GetCustomerDisplayName());
        }
    }

    private void BindNotifications()
    {
        if (NotificationCountLiteral == null || NotificationRepeater == null || EmptyNotificationPlaceholder == null)
        {
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            NotificationCountLiteral.Text = "0";
            NotificationRepeater.DataSource = null;
            NotificationRepeater.DataBind();
            EmptyNotificationPlaceholder.Visible = true;
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfCommunityNotifications
                .Where(n => n.CustomerId == customerId.Value)
                .OrderByDescending(n => n.CreatedAt)
                .Take(5)
                .ToList()
                .Select(n => new
                {
                    Message = HttpUtility.HtmlEncode(n.Message),
                    CreatedAt = n.CreatedAt.ToString("dd/MM HH:mm")
                })
                .ToList();

            var unreadCount = db.CfCommunityNotifications
                .Where(n => n.CustomerId == customerId.Value && !n.IsRead)
                .Count();

            NotificationCountLiteral.Text = unreadCount.ToString();
            NotificationRepeater.DataSource = items;
            NotificationRepeater.DataBind();
            EmptyNotificationPlaceholder.Visible = items.Count == 0;
        }
    }

    private void BindMessageBadge()
    {
        if (MessageCountLiteral == null)
        {
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            MessageCountLiteral.Text = "0";
            return;
        }

        var lastSeenKey = "CommunityLastSeenAt_" + customerId.Value;
        var now = DateTime.UtcNow;

        if (ShouldResetMessageCount())
        {
            HttpContext.Current.Session[lastSeenKey] = now;
            MessageCountLiteral.Text = "0";
            return;
        }

        DateTime lastSeen;
        var sessionValue = HttpContext.Current.Session[lastSeenKey];
        if (sessionValue == null || !(sessionValue is DateTime))
        {
            lastSeen = now;
            HttpContext.Current.Session[lastSeenKey] = lastSeen;
            MessageCountLiteral.Text = "0";
            return;
        }
        lastSeen = (DateTime)sessionValue;

        using (var db = new BeautyStoryContext())
        {
            var roomIds = db.CfCommunityRoomMembers
                .Where(m => m.CustomerId == customerId.Value && m.Status)
                .Select(m => m.RoomId);

            var unreadCount = db.CfCommunityMessages
                .Where(m => roomIds.Contains(m.RoomId)
                            && m.Status
                            && m.SenderId != customerId.Value
                            && m.CreatedAt > lastSeen)
                .Count();

            MessageCountLiteral.Text = unreadCount.ToString();
        }
    }

    private bool ShouldResetMessageCount()
    {
        var request = HttpContext.Current != null ? HttpContext.Current.Request : null;
        if (request == null)
        {
            return false;
        }

        var path = request.Path ?? string.Empty;
        if (path.StartsWith("/cong-dong/chat.aspx", StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        return string.Equals(request.QueryString["msgSeen"], "1", StringComparison.OrdinalIgnoreCase);
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

    public class PostCategoryMenuItem
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public List<PostCategoryMenuItem> Children { get; set; }
    }
}
