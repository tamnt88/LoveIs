using System;
using System.Linq;

public partial class AdminSystemIntegrations : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            using (var db = new BeautyStoryContext())
            {
                var item = db.CfTrackingCodes.FirstOrDefault();
                if (item != null)
                {
                    HeaderCodeInput.Text = item.HeaderCode;
                    BodyCodeInput.Text = item.BodyCode;
                }
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            var item = db.CfTrackingCodes.FirstOrDefault();
            if (item == null)
            {
                item = new CfTrackingCode
                {
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    SortOrder = 0
                };
                db.CfTrackingCodes.Add(item);
            }

            item.HeaderCode = HeaderCodeInput.Text.Trim();
            item.BodyCode = BodyCodeInput.Text.Trim();
            item.UpdatedAt = DateTime.Now;
            item.UpdatedBy = updatedBy;
            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }
}
