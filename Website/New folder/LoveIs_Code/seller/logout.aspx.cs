using System;

public partial class SellerLogout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SellerAuth.SignOut();
        Response.Redirect("/seller/login.aspx");
    }
}
