using System;

public partial class CustomerSidebar : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UsernameLiteral.Text = CustomerAuth.GetCustomerDisplayName();
        }
    }

    public string IsActive(string path)
    {
        if (string.IsNullOrWhiteSpace(path))
        {
            return string.Empty;
        }

        var current = (Request != null && Request.Url != null)
            ? Request.Url.AbsolutePath.ToLowerInvariant()
            : string.Empty;

        return current == path.ToLowerInvariant() ? "active" : string.Empty;
    }
}
