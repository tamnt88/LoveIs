using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminSystemPages : AdminBasePage
{
    private List<CfStaticPage> _staticPages;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSystemPages();
        }
    }

    private void BindSystemPages()
    {
        using (var db = new BeautyStoryContext())
        {
            _staticPages = db.CfStaticPages
                .Where(p => p.Status)
                .OrderBy(p => p.SortOrder)
                .ThenBy(p => p.PageName)
                .ToList();

            var systemPages = db.CfSystemPages
                .OrderBy(p => p.SortOrder)
                .ThenBy(p => p.PageName)
                .ToList();

            SystemPageRepeater.DataSource = systemPages;
            SystemPageRepeater.DataBind();
        }
    }

    protected void SystemPageRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item == null || (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem))
        {
            return;
        }

        var page = e.Item.DataItem as CfSystemPage;
        var dropdown = e.Item.FindControl("StaticPageSelect") as DropDownList;
        if (dropdown == null)
        {
            return;
        }

        if (_staticPages == null)
        {
            using (var db = new BeautyStoryContext())
            {
                _staticPages = db.CfStaticPages
                    .Where(p => p.Status)
                    .OrderBy(p => p.SortOrder)
                    .ThenBy(p => p.PageName)
                    .ToList();
            }
        }

        dropdown.Items.Clear();
        dropdown.Items.Add(new ListItem("-- Không chọn --", string.Empty));
        foreach (var item in _staticPages)
        {
            dropdown.Items.Add(new ListItem(item.PageName, item.Id.ToString()));
        }

        if (page != null && page.StaticPageId.HasValue)
        {
            var selected = dropdown.Items.FindByValue(page.StaticPageId.Value.ToString());
            if (selected != null)
            {
                dropdown.ClearSelection();
                selected.Selected = true;
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";

        using (var db = new BeautyStoryContext())
        {
            foreach (RepeaterItem item in SystemPageRepeater.Items)
            {
                var idField = item.FindControl("SystemPageId") as HiddenField;
                var dropdown = item.FindControl("StaticPageSelect") as DropDownList;
                int id;
                if (idField == null || dropdown == null || !int.TryParse(idField.Value, out id))
                {
                    continue;
                }

                var systemPage = db.CfSystemPages.FirstOrDefault(p => p.Id == id);
                if (systemPage == null)
                {
                    continue;
                }

                int pageId;
                if (int.TryParse(dropdown.SelectedValue, out pageId))
                {
                    systemPage.StaticPageId = pageId;
                }
                else
                {
                    systemPage.StaticPageId = null;
                }

                systemPage.UpdatedAt = DateTime.UtcNow;
                systemPage.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            }

            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu cấu hình thành công.";
        BindSystemPages();
    }
}
