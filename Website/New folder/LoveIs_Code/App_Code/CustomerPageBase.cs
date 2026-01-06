using System;

public class CustomerPageBase : System.Web.UI.Page
{
    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        if (!CustomerAuth.IsSignedIn())
        {
            var returnUrl = Server.UrlEncode(Request.Url.AbsolutePath);
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + returnUrl);
        }
    }
}
