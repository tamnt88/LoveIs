using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class AdminMaster : AdminBaseMaster
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["AdminUserId"] != null)
        {
            int userId = (int)Session["AdminUserId"];
            using (var db = new BeautyStoryContext())
            {
                var user = db.CfUsers.FirstOrDefault(u => u.Id == userId);
                if (user != null)
                {
                    DisplayNameInput.Text = user.DisplayName ?? string.Empty;
                    EmailInput.Text = user.Email ?? string.Empty;
                    Session["AdminDisplayName"] = user.DisplayName ?? string.Empty;
                }
            }
        }

        if (Session["AdminDisplayName"] != null)
        {
            CurrentUserName.Text = Session["AdminDisplayName"].ToString();
        }
        else
        {
            CurrentUserName.Text = string.Empty;
        }

        BindMenu();
    }

    protected void LogoutButton_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();

        if (Request.Cookies["AdminRemember"] != null)
        {
            var cookie = new HttpCookie("AdminRemember");
            cookie.Expires = DateTime.UtcNow.AddDays(-1);
            Response.Cookies.Add(cookie);
        }

        Response.Redirect("~/admin/login.aspx");
    }

    protected void SaveProfileButton_Click(object sender, EventArgs e)
    {
        ProfileMessage.Text = string.Empty;
        ProfileModalOpen.Value = "1";

        if (Session["AdminUserId"] == null)
        {
            ProfileMessage.Text = "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.";
            return;
        }

        string displayName = (DisplayNameInput.Text ?? string.Empty).Trim();
        string email = (EmailInput.Text ?? string.Empty).Trim();
        string newPassword = NewPasswordInput.Text ?? string.Empty;
        string confirmPassword = ConfirmPasswordInput.Text ?? string.Empty;

        if (!string.IsNullOrEmpty(newPassword))
        {
            if (string.IsNullOrWhiteSpace(CurrentPasswordInput.Text))
            {
                ProfileMessage.Text = "Vui lòng nhập mật khẩu hiện tại.";
                return;
            }

            if (newPassword.Length < 6)
            {
                ProfileMessage.Text = "Mật khẩu mới phải có ít nhất 6 ký tự.";
                return;
            }

            if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
            {
                ProfileMessage.Text = "Xác nhận mật khẩu không khớp.";
                return;
            }
        }

        int userId = (int)Session["AdminUserId"];
        using (var db = new BeautyStoryContext())
        {
            var user = db.CfUsers.FirstOrDefault(u => u.Id == userId);
            if (user == null)
            {
                ProfileMessage.Text = "Không tìm thấy tài khoản.";
                return;
            }

            if (!string.IsNullOrWhiteSpace(displayName))
            {
                user.DisplayName = displayName;
            }

            if (!string.IsNullOrWhiteSpace(email))
            {
                user.Email = email;
            }

            if (!string.IsNullOrEmpty(newPassword))
            {
                bool currentOk = Pbkdf2Hasher.Verify(
                    CurrentPasswordInput.Text,
                    user.PasswordSalt,
                    user.PasswordHash,
                    user.PasswordIterations);
                if (!currentOk)
                {
                    ProfileMessage.Text = "Mật khẩu hiện tại không đúng.";
                    return;
                }

                byte[] salt;
                byte[] hash;
                int iterations = 100000;
                Pbkdf2Hasher.Create(newPassword, iterations, out salt, out hash);
                user.PasswordSalt = salt;
                user.PasswordHash = hash;
                user.PasswordIterations = iterations;
            }

            user.UpdatedAt = DateTime.UtcNow;
            user.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();

            Session["AdminDisplayName"] = string.IsNullOrWhiteSpace(user.DisplayName) ? user.Username : user.DisplayName;
            CurrentUserName.Text = Session["AdminDisplayName"].ToString();
        }

        ProfileMessage.CssClass = "text-success small d-block mb-3";
        ProfileMessage.Text = "Cập nhật thành công.";
    }

    protected void TopMenuRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        var item = (AdminMenuItem)e.Item.DataItem;
        var container = (HtmlGenericControl)e.Item.FindControl("MenuItemContainer");
        var link = (HtmlAnchor)e.Item.FindControl("MenuLink");
        var button = (HtmlButton)e.Item.FindControl("MenuButton");
        var dropdown = (HtmlGenericControl)e.Item.FindControl("MenuDropdown");
        var childRepeater = (Repeater)e.Item.FindControl("ChildRepeater");

        string icon = string.IsNullOrWhiteSpace(item.Icon) ? "fa-solid fa-circle" : item.Icon;
        string labelHtml = string.Format("<i class=\"{0}\"></i><span>{1}</span>", icon, item.MenuName);
        string currentPath = HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath;
        bool isActive = IsMenuActive(item, currentPath);

        if (item.Children.Count > 0)
        {
            link.Visible = false;
            button.Visible = true;
            dropdown.Visible = true;
            button.InnerHtml = labelHtml;

            childRepeater.DataSource = item.Children;
            childRepeater.DataBind();
        }
        else
        {
            button.Visible = false;
            dropdown.Visible = false;
            link.Visible = true;
            link.HRef = string.IsNullOrWhiteSpace(item.Url) ? "#" : item.Url;
            link.InnerHtml = labelHtml;
        }

        if (isActive)
        {
            string existing = container.Attributes["class"];
            container.Attributes["class"] = string.IsNullOrWhiteSpace(existing)
                ? "admin-nav-item active"
                : existing + " active";
        }
    }

    private void BindMenu()
    {
        bool isAdminSuper = Session["IsAdminSuper"] != null && (bool)Session["IsAdminSuper"];
        int userId = Session["AdminUserId"] != null ? (int)Session["AdminUserId"] : 0;

        using (var db = new BeautyStoryContext())
        {
            List<CfMenu> menus;
            if (isAdminSuper)
            {
                menus = db.CfMenus.Where(m => m.Status).ToList();
            }
            else
            {
                var allowedMenuIds = (from ur in db.CfUserRoles
                                      join rp in db.CfRolePermissions on ur.RoleId equals rp.RoleId
                                      join mp in db.CfMenuPermissions on rp.PermissionId equals mp.PermissionId
                                      where ur.UserId == userId && ur.Status && rp.Status && mp.Status
                                      select mp.MenuId).Distinct().ToList();

                var parentIds = db.CfMenus.Where(m => m.ParentId.HasValue && allowedMenuIds.Contains(m.Id))
                    .Select(m => m.ParentId.Value).Distinct().ToList();

                var allIds = new HashSet<int>(allowedMenuIds);
                foreach (var id in parentIds)
                {
                    allIds.Add(id);
                }

                menus = db.CfMenus.Where(m => m.Status && allIds.Contains(m.Id)).ToList();
            }

            var menuItems = menus
                .Where(m => !m.ParentId.HasValue)
                .OrderBy(m => m.SortOrder)
                .ThenBy(m => m.MenuName)
                .Select(m => new AdminMenuItem
                {
                    Id = m.Id,
                    MenuName = m.MenuName,
                    Url = m.Url,
                    Icon = m.Icon,
                    Children = menus
                        .Where(c => c.ParentId == m.Id)
                        .OrderBy(c => c.SortOrder)
                        .ThenBy(c => c.MenuName)
                        .Select(c => new AdminMenuItem
                        {
                            Id = c.Id,
                            MenuName = c.MenuName,
                            Url = c.Url,
                            Icon = c.Icon
                        }).ToList()
                }).ToList();

            TopMenuRepeater.DataSource = menuItems;
            TopMenuRepeater.DataBind();
        }
    }

    private static bool IsMenuActive(AdminMenuItem item, string currentPath)
    {
        if (!string.IsNullOrWhiteSpace(item.Url) && IsSamePathOrChild(item.Url, currentPath))
        {
            return true;
        }

        foreach (var child in item.Children)
        {
            if (!string.IsNullOrWhiteSpace(child.Url) && IsSamePathOrChild(child.Url, currentPath))
            {
                return true;
            }
        }

        return false;
    }

    private static bool IsSamePathOrChild(string url, string currentPath)
    {
        if (string.IsNullOrWhiteSpace(url))
        {
            return false;
        }

        if (url.Trim() == "#")
        {
            return false;
        }

        string normalized = VirtualPathUtility.ToAbsolute(url.Split('?')[0].Trim());
        string current = VirtualPathUtility.ToAbsolute(currentPath.Split('?')[0].Trim());

        if (string.Equals(normalized, current, StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        // Treat any page under the same folder as active (e.g. edit.aspx under /admin/products/).
        string normalizedDir = VirtualPathUtility.GetDirectory(normalized);
        string currentDir = VirtualPathUtility.GetDirectory(current);
        if (!string.IsNullOrWhiteSpace(normalizedDir) && !string.IsNullOrWhiteSpace(currentDir))
        {
            return string.Equals(normalizedDir, currentDir, StringComparison.OrdinalIgnoreCase);
        }

        return false;
    }
}
