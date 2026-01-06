using System;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;

public partial class CustomerGoogleCallback : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var error = Request.QueryString["error"];
        var errorDescription = Request.QueryString["error_description"];
        if (!string.IsNullOrWhiteSpace(error))
        {
            StatusMessage.Text = string.IsNullOrWhiteSpace(errorDescription)
                ? "Đăng nhập Google thất bại. Vui lòng thử lại."
                : "Đăng nhập Google thất bại: " + errorDescription;
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

        var clientId = WebConfigurationManager.AppSettings["GoogleClientId"];
        var clientSecret = WebConfigurationManager.AppSettings["GoogleClientSecret"];
        if (string.IsNullOrWhiteSpace(clientId) || string.IsNullOrWhiteSpace(clientSecret))
        {
            StatusMessage.Text = "Thiếu cấu hình Google OAuth.";
            return;
        }

        var redirectUri = GetRedirectUri("/tai-khoan/dang-nhap-google.aspx");

        try
        {
            var tokenResponse = ExchangeCodeForToken(clientId, clientSecret, code, redirectUri);
            if (tokenResponse == null || string.IsNullOrWhiteSpace(tokenResponse.access_token))
            {
                StatusMessage.Text = "Không thể xác thực Google. Vui lòng thử lại.";
                return;
            }

            var profile = GetGoogleProfile(tokenResponse.access_token);
            if (profile == null || string.IsNullOrWhiteSpace(profile.email))
            {
                StatusMessage.Text = "Google không cung cấp email. Vui lòng thử lại.";
                return;
            }

            var customer = OAuthCustomerHelper.GetOrCreateCustomer(profile.email, profile.name, "google");
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
            StatusMessage.Text = "Đăng nhập Google thất bại: " + ex.Message;
        }
    }

    private GoogleTokenResponse ExchangeCodeForToken(string clientId, string clientSecret, string code, string redirectUri)
    {
        var postData = "code=" + HttpUtility.UrlEncode(code)
            + "&client_id=" + HttpUtility.UrlEncode(clientId)
            + "&client_secret=" + HttpUtility.UrlEncode(clientSecret)
            + "&redirect_uri=" + HttpUtility.UrlEncode(redirectUri)
            + "&grant_type=authorization_code";

        using (var client = new WebClient())
        {
            client.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
            try
            {
                var response = client.UploadString("https://oauth2.googleapis.com/token", postData);
                var serializer = new JavaScriptSerializer();
                return serializer.Deserialize<GoogleTokenResponse>(response);
            }
            catch (WebException ex)
            {
                throw new InvalidOperationException(ReadErrorResponse(ex), ex);
            }
        }
    }

    private GoogleProfile GetGoogleProfile(string accessToken)
    {
        using (var client = new WebClient())
        {
            try
            {
                var response = client.DownloadString("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + HttpUtility.UrlEncode(accessToken));
                var serializer = new JavaScriptSerializer();
                return serializer.Deserialize<GoogleProfile>(response);
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

    private class GoogleTokenResponse
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public int expires_in { get; set; }
        public string id_token { get; set; }
    }

    private class GoogleProfile
    {
        public string id { get; set; }
        public string email { get; set; }
        public string name { get; set; }
    }
}
