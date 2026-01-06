using System;
using System.Linq;

public partial class PublicMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindTrackingCode();
        }
    }

    private void BindTrackingCode()
    {
        using (var db = new BeautyStoryContext())
        {
            var item = db.CfTrackingCodes
                .Where(t => t.Status)
                .OrderBy(t => t.SortOrder)
                .ThenBy(t => t.Id)
                .FirstOrDefault();

            HeaderTrackingLiteral.Text = item != null ? (item.HeaderCode ?? string.Empty) : string.Empty;
            BodyTrackingLiteral.Text = item != null ? (item.BodyCode ?? string.Empty) : string.Empty;
        }
    }
}
