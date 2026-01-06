using System;
using System.Linq;

public partial class AdminSystemSocial : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindList();
            LoadEditItem();
        }
    }

    private void BindList()
    {
        using (var db = new BeautyStoryContext())
        {
            var items = db.CfSocialLinks.OrderBy(s => s.SortOrder).ThenBy(s => s.Id).ToList();
            SocialRepeater.DataSource = items;
            SocialRepeater.DataBind();
        }
    }

    private void LoadEditItem()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var item = db.CfSocialLinks.FirstOrDefault(s => s.Id == id);
            if (item == null)
            {
                return;
            }

            SocialId.Value = item.Id.ToString();
            DisplayNameInput.Text = item.DisplayName;
            IconClassInput.Text = item.IconClass;
            UrlInput.Text = item.Url;
            SortOrderInput.Text = item.SortOrder.ToString();
            StatusInput.Checked = item.Status;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        int id;
        int sortOrder;
        int.TryParse(SocialId.Value, out id);
        int.TryParse(SortOrderInput.Text, out sortOrder);

        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            CfSocialLink item;
            if (id > 0)
            {
                item = db.CfSocialLinks.FirstOrDefault(s => s.Id == id);
                if (item == null)
                {
                    return;
                }
            }
            else
            {
                item = new CfSocialLink
                {
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    Status = true
                };
                db.CfSocialLinks.Add(item);
            }

            item.DisplayName = DisplayNameInput.Text.Trim();
            item.IconClass = IconClassInput.Text.Trim();
            item.Url = UrlInput.Text.Trim();
            item.SortOrder = sortOrder;
            item.Status = StatusInput.Checked;
            item.UpdatedAt = DateTime.Now;
            item.UpdatedBy = updatedBy;
            db.SaveChanges();
        }

        Response.Redirect("/admin/system/social.aspx");
    }

    protected void SocialRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "DeleteItem")
        {
            return;
        }

        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var item = db.CfSocialLinks.FirstOrDefault(s => s.Id == id);
            if (item == null)
            {
                return;
            }

            db.CfSocialLinks.Remove(item);
            db.SaveChanges();
        }

        BindList();
    }
}
