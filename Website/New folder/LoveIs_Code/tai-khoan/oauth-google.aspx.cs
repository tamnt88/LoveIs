using System;
using System.Web;
using System.Web.Configuration;

public partial class CustomerOauthGoogle : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var clientId = WebConfigurationManager.AppSettings["GoogleClientId"];
        if (string.IsNullOrWhiteSpace(clientId))
        {
            Response.Redirect("/tai-khoan/dang-nhap.aspx?oauth=missing");
            return;
        }

        var state = Guid.NewGuid().ToString("N");
        Session["OAuthState"] = state;
        Session["OAuthReturnUrl"] = Request.QueryString["returnUrl"] ?? "/";

        var redirectUri = GetRedirectUri("/tai-khoan/dang-nhap-google.aspx");
        var authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
            + "?client_id=" + HttpUtility.UrlEncode(clientId)
            + "&redirect_uri=" + HttpUtility.UrlEncode(redirectUri)
            + "&response_type=code"
            + "&scope=" + HttpUtility.UrlEncode("openid email profile")
            + "&state=" + HttpUtility.UrlEncode(state)
            + "&access_type=online"
            + "&prompt=select_account";

        Response.Redirect(authUrl);
    }

    private string GetRedirectUri(string path)
    {
        var request = Request;
        var baseUrl = request.Url != null ? request.Url.GetLeftPart(UriPartial.Authority) : "http://localhost:59159";
        return baseUrl.TrimEnd('/') + path;
    }
}
