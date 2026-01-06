using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

public partial class AdminMenusDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindParentMenus();
            BindMenus();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (MenuNameInput.Text ?? string.Empty).Trim();
        string group = (MenuGroupInput.Value ?? string.Empty).Trim();
        string url = (UrlInput.Text ?? string.Empty).Trim();
        string icon = (IconInput.Text ?? string.Empty).Trim();
        string sortOrderText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên menu.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortOrderText))
        {
            int.TryParse(sortOrderText, out sortOrder);
        }

        int parentId;
        int.TryParse(ParentMenuId.SelectedValue, out parentId);

        using (var db = new BeautyStoryContext())
        {
            CfMenu menu;
            int id;
            if (int.TryParse(MenuId.Value, out id) && id > 0)
            {
                menu = db.CfMenus.FirstOrDefault(m => m.Id == id);
                if (menu == null)
                {
                    FormMessage.Text = "Menu không tồn tại.";
                    return;
                }
            }
            else
            {
                menu = new CfMenu();
                menu.CreatedAt = DateTime.UtcNow;
                menu.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfMenus.Add(menu);
            }

            menu.MenuName = name;
            menu.MenuGroup = string.IsNullOrWhiteSpace(group) ? "Admin" : group;
            menu.Url = string.IsNullOrWhiteSpace(url) ? null : url;
            menu.Icon = string.IsNullOrWhiteSpace(icon) ? null : icon;
            menu.ParentId = parentId > 0 ? (int?)parentId : null;
            menu.SortOrder = sortOrder;
            menu.Status = status;
            menu.UpdatedAt = DateTime.UtcNow;
            menu.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            bool duplicate = db.CfMenus.Any(m =>
                m.Id != menu.Id &&
                m.MenuGroup == menu.MenuGroup &&
                m.MenuName == menu.MenuName);
            if (duplicate)
            {
                FormMessage.Text = "Menu đã tồn tại trong nhóm này. Vui lòng chọn tên khác.";
                return;
            }

            db.SaveChanges();
        }

        ResetForm();
        BindParentMenus();
        BindMenus();
        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void MenuRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditMenu")
        {
            LoadMenuToForm(id);
        }
        else if (e.CommandName == "DeleteMenu")
        {
            DeleteMenu(id);
            BindParentMenus();
            BindMenus();
        }
    }

    protected void ChildRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        MenuRepeater_ItemCommand(source, e);
    }

    protected void SaveSortButton_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(SortPayload.Value))
        {
            return;
        }

        List<SortItem> items = null;
        try
        {
            var serializer = new JavaScriptSerializer();
            items = serializer.Deserialize<List<SortItem>>(SortPayload.Value);
        }
        catch
        {
            FormMessage.Text = "Dữ liệu sắp xếp không hợp lệ.";
            return;
        }

        if (items == null || items.Count == 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            foreach (var item in items)
            {
                var menu = db.CfMenus.FirstOrDefault(m => m.Id == item.Id);
                if (menu != null)
                {
                    menu.SortOrder = item.SortOrder;
                }
            }
            db.SaveChanges();
        }

        BindMenus();
    }

    protected void MenuRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        var item = (AdminMenuItem)e.Item.DataItem;
        var childRepeater = (Repeater)e.Item.FindControl("ChildRepeater");
        if (childRepeater != null)
        {
            childRepeater.DataSource = item.Children;
            childRepeater.DataBind();
        }
    }

    private void BindMenus()
    {
        using (var db = new BeautyStoryContext())
        {
            var menus = db.CfMenus.ToList();
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
                    SortOrder = m.SortOrder,
                    Status = m.Status,
                    Children = menus
                        .Where(c => c.ParentId == m.Id)
                        .OrderBy(c => c.SortOrder)
                        .ThenBy(c => c.MenuName)
                        .Select(c => new AdminMenuItem
                        {
                            Id = c.Id,
                            MenuName = c.MenuName,
                            Url = c.Url,
                            Icon = c.Icon,
                            SortOrder = c.SortOrder,
                            Status = c.Status,
                            ParentId = c.ParentId,
                            Children = new List<AdminMenuItem>()
                        }).ToList()
                }).ToList();

            MenuRepeater.DataSource = menuItems;
            MenuRepeater.DataBind();
        }
    }

    private void BindParentMenus()
    {
        ParentMenuId.Items.Clear();
        ParentMenuId.Items.Add(new ListItem("-- Không có --", "0"));
        using (var db = new BeautyStoryContext())
        {
            var parents = db.CfMenus.Where(m => !m.ParentId.HasValue)
                .OrderBy(m => m.SortOrder)
                .ThenBy(m => m.MenuName)
                .ToList();
            foreach (var parent in parents)
            {
                ParentMenuId.Items.Add(new ListItem(parent.MenuName, parent.Id.ToString()));
            }
        }
    }

    private void LoadMenuToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var menu = db.CfMenus.FirstOrDefault(m => m.Id == id);
            if (menu == null)
            {
                return;
            }

            MenuId.Value = menu.Id.ToString();
            MenuNameInput.Text = menu.MenuName;
            MenuGroupInput.Value = menu.MenuGroup;
            UrlInput.Text = menu.Url;
            IconInput.Text = menu.Icon;
            SortOrderInput.Text = menu.SortOrder.ToString();
            StatusInput.Checked = menu.Status;

            ParentMenuId.SelectedValue = menu.ParentId.HasValue ? menu.ParentId.Value.ToString() : "0";
        }
    }

    private void DeleteMenu(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var menu = db.CfMenus.FirstOrDefault(m => m.Id == id);
            if (menu == null)
            {
                return;
            }

            bool hasChildren = db.CfMenus.Any(m => m.ParentId == id);
            if (hasChildren)
            {
                FormMessage.Text = "Vui lòng xóa menu con trước.";
                return;
            }

            db.CfMenus.Remove(menu);
            db.SaveChanges();
        }
    }

    private void ResetForm()
    {
        MenuId.Value = string.Empty;
        MenuNameInput.Text = string.Empty;
        MenuGroupInput.Value = "Admin";
        UrlInput.Text = string.Empty;
        IconInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        StatusInput.Checked = true;
        ParentMenuId.SelectedValue = "0";
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
    }

    private class SortItem
    {
        public int Id { get; set; }
        public int SortOrder { get; set; }
    }
}
