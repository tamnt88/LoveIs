using System;

public partial class CheckoutComplete : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var code = Request.QueryString["code"] ?? string.Empty;
        OrderCodeLiteral.Text = code;
        OrderLink.NavigateUrl = "/don-hang/default.aspx?code=" + Server.UrlEncode(code);
    }
}
