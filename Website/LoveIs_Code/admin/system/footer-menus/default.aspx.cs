using System;
using System.Linq;

public partial class AdminSystemFooterMenus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadItem();
            BindList();
        }
    }

    private void LoadItem()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var item = db.CfFooterMenus.FirstOrDefault(m => m.Id == id);
            if (item == null)
            {
                return;
            }

            FooterMenuId.Value = item.Id.ToString();
            GroupNameInput.Text = item.GroupName;
            GroupSortOrderInput.Text = item.GroupSortOrder.ToString();
            TitleInput.Text = item.Title;
            UrlInput.Text = item.Url;
            SortOrderInput.Text = item.SortOrder.ToString();
            StatusInput.Checked = item.Status;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        var groupName = (GroupNameInput.Text ?? string.Empty).Trim();
        var title = (TitleInput.Text ?? string.Empty).Trim();
        var url = (UrlInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(groupName))
        {
            FormMessage.Text = "Vui lòng nhập nhóm.";
            return;
        }

        if (string.IsNullOrWhiteSpace(title))
        {
            FormMessage.Text = "Vui lòng nhập tiêu đề.";
            return;
        }

        var groupSortOrder = ParseInt(GroupSortOrderInput.Text);
        var sortOrder = ParseInt(SortOrderInput.Text);
        var status = StatusInput.Checked;
        var adminUser = GetAdminUsername();

        using (var db = new BeautyStoryContext())
        {
            CfFooterMenu item;
            int id;
            if (int.TryParse(FooterMenuId.Value, out id) && id > 0)
            {
                item = db.CfFooterMenus.FirstOrDefault(m => m.Id == id);
                if (item == null)
                {
                    FormMessage.Text = "Không tìm thấy menu để cập nhật.";
                    return;
                }

                item.UpdatedAt = DateTime.Now;
                item.UpdatedBy = adminUser;
            }
            else
            {
                item = new CfFooterMenu
                {
                    CreatedAt = DateTime.Now,
                    CreatedBy = adminUser
                };
                db.CfFooterMenus.Add(item);
            }

            item.GroupName = groupName;
            item.GroupSortOrder = groupSortOrder;
            item.Title = title;
            item.Url = url;
            item.SortOrder = sortOrder;
            item.Status = status;

            db.SaveChanges();
        }

        Response.Redirect("/admin/system/footer-menus/default.aspx");
    }

    protected void FooterRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "DeleteItem")
        {
            return;
        }

        int id;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var item = db.CfFooterMenus.FirstOrDefault(m => m.Id == id);
            if (item == null)
            {
                return;
            }

            db.CfFooterMenus.Remove(item);
            db.SaveChanges();
        }

        Response.Redirect("/admin/system/footer-menus/default.aspx");
    }

    private void BindList()
    {
        using (var db = new BeautyStoryContext())
        {
            var items = db.CfFooterMenus
                .OrderBy(m => m.GroupSortOrder)
                .ThenBy(m => m.SortOrder)
                .ToList();
            FooterRepeater.DataSource = items;
            FooterRepeater.DataBind();
        }
    }

    private static int ParseInt(string input)
    {
        int value;
        return int.TryParse(input, out value) ? value : 0;
    }

    private string GetAdminUsername()
    {
        return Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
    }
}
