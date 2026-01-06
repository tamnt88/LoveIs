using System;
using System.Linq;

public partial class CustomerOrders : CustomerPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindOrders();
        }
    }

    private void BindOrders()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfOrders
                .Where(o => o.CustomerId == customerId.Value)
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            OrderRepeater.DataSource = items;
            OrderRepeater.DataBind();
            EmptyPanel.Visible = items.Count == 0;
        }
    }
}
