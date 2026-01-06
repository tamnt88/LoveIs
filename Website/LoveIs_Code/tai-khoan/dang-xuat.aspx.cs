using System;

public partial class CustomerLogout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CustomerAuth.SignOut();
        Response.Redirect("/");
    }
}
