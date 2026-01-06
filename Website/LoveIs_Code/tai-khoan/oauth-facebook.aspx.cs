using System;
using System.Web;
using System.Web.Configuration;

public partial class CustomerOauthFacebook : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var appId = WebConfigurationManager.AppSettings["FacebookAppId"];
        if (string.IsNullOrWhiteSpace(appId))
        {
            Response.Redirect("/tai-khoan/dang-nhap.aspx?oauth=missing");
            return;
        }

        var state = Guid.NewGuid().ToString("N");
        Session["OAuthState"] = state;
        Session["OAuthReturnUrl"] = Request.QueryString["returnUrl"] ?? "/";

        var redirectUri = GetRedirectUri("/tai-khoan/dang-nhap-facebook.aspx");
        var authUrl = "https://www.facebook.com/v18.0/dialog/oauth"
            + "?client_id=" + HttpUtility.UrlEncode(appId)
            + "&redirect_uri=" + HttpUtility.UrlEncode(redirectUri)
            + "&response_type=code"
            + "&scope=" + HttpUtility.UrlEncode("email public_profile")
            + "&state=" + HttpUtility.UrlEncode(state);

        Response.Redirect(authUrl);
    }

    private string GetRedirectUri(string path)
    {
        var request = Request;
        var baseUrl = request.Url != null ? request.Url.GetLeftPart(UriPartial.Authority) : "http://localhost:59159";
        return baseUrl.TrimEnd('/') + path;
    }
}
