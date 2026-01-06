using System;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;

public partial class CustomerFacebookCallback : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var error = Request.QueryString["error"];
        var errorDescription = Request.QueryString["error_description"];
        if (!string.IsNullOrWhiteSpace(error))
        {
            StatusMessage.Text = string.IsNullOrWhiteSpace(errorDescription)
                ? "Đăng nhập Facebook thất bại. Vui lòng thử lại."
                : "Đăng nhập Facebook thất bại: " + errorDescription;
            return;
        }

        var code = Request.QueryString["code"];
        var state = Request.QueryString["state"];
        var sessionState = Session["OAuthState"] as string;
        if (string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(state) || state != sessionState)
        {
            StatusMessage.Text = "Phiên đăng nhập không hợp lệ. Vui lòng thử lại.";
            return;
        }

        var appId = WebConfigurationManager.AppSettings["FacebookAppId"];
        var appSecret = WebConfigurationManager.AppSettings["FacebookAppSecret"];
        if (string.IsNullOrWhiteSpace(appId) || string.IsNullOrWhiteSpace(appSecret))
        {
            StatusMessage.Text = "Thiếu cấu hình Facebook OAuth.";
            return;
        }

        var redirectUri = GetRedirectUri("/tai-khoan/dang-nhap-facebook.aspx");

        try
        {
            var tokenResponse = ExchangeCodeForToken(appId, appSecret, code, redirectUri);
            if (tokenResponse == null || string.IsNullOrWhiteSpace(tokenResponse.access_token))
            {
                StatusMessage.Text = "Không thể xác thực Facebook. Vui lòng thử lại.";
                return;
            }

            var profile = GetFacebookProfile(tokenResponse.access_token);
            if (profile == null || string.IsNullOrWhiteSpace(profile.email))
            {
                StatusMessage.Text = "Facebook không cung cấp email. Vui lòng thử lại.";
                return;
            }

            var customer = OAuthCustomerHelper.GetOrCreateCustomer(profile.email, profile.name, "facebook");
            if (customer == null)
            {
                StatusMessage.Text = "Không thể đăng nhập. Vui lòng thử lại.";
                return;
            }

            CustomerAuth.SignIn(customer);
            var returnUrl = Session["OAuthReturnUrl"] as string;
            Response.Redirect(string.IsNullOrWhiteSpace(returnUrl) ? "/" : returnUrl);
        }
        catch (Exception ex)
        {
            StatusMessage.Text = "Đăng nhập Facebook thất bại: " + ex.Message;
        }
    }

    private FacebookTokenResponse ExchangeCodeForToken(string appId, string appSecret, string code, string redirectUri)
    {
        var url = "https://graph.facebook.com/v18.0/oauth/access_token"
            + "?client_id=" + HttpUtility.UrlEncode(appId)
            + "&client_secret=" + HttpUtility.UrlEncode(appSecret)
            + "&redirect_uri=" + HttpUtility.UrlEncode(redirectUri)
            + "&code=" + HttpUtility.UrlEncode(code);

        using (var client = new WebClient())
        {
            try
            {
                var response = client.DownloadString(url);
                var serializer = new JavaScriptSerializer();
                return serializer.Deserialize<FacebookTokenResponse>(response);
            }
            catch (WebException ex)
            {
                throw new InvalidOperationException(ReadErrorResponse(ex), ex);
            }
        }
    }

    private FacebookProfile GetFacebookProfile(string accessToken)
    {
        var url = "https://graph.facebook.com/me"
            + "?fields=id,name,email"
            + "&access_token=" + HttpUtility.UrlEncode(accessToken);

        using (var client = new WebClient())
        {
            try
            {
                var response = client.DownloadString(url);
                var serializer = new JavaScriptSerializer();
                return serializer.Deserialize<FacebookProfile>(response);
            }
            catch (WebException ex)
            {
                throw new InvalidOperationException(ReadErrorResponse(ex), ex);
            }
        }
    }

    private string GetRedirectUri(string path)
    {
        var request = Request;
        var baseUrl = request.Url != null ? request.Url.GetLeftPart(UriPartial.Authority) : "http://localhost:59159";
        return baseUrl.TrimEnd('/') + path;
    }

    private static string ReadErrorResponse(WebException ex)
    {
        if (ex.Response == null)
        {
            return ex.Message;
        }

        try
        {
            using (var stream = ex.Response.GetResponseStream())
            using (var reader = new System.IO.StreamReader(stream))
            {
                var body = reader.ReadToEnd();
                return string.IsNullOrWhiteSpace(body) ? ex.Message : body;
            }
        }
        catch
        {
            return ex.Message;
        }
    }

    private class FacebookTokenResponse
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public int expires_in { get; set; }
    }

    private class FacebookProfile
    {
        public string id { get; set; }
        public string email { get; set; }
        public string name { get; set; }
    }
}
