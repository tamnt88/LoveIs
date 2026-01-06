using System;
using System.Linq;
using System.Web;
using System.Web.UI;

public class AdminBasePage : Page
{
    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        if (IsLoginPage())
        {
            return;
        }

        if (HttpContext.Current.Session["AdminUserId"] == null)
        {
            if (!TrySignInFromCookie())
            {
                Response.Redirect("~/admin/login.aspx");
            }
        }
    }

    private static bool IsLoginPage()
    {
        string path = HttpContext.Current.Request.Path;
        return path.EndsWith("/admin/login.aspx", StringComparison.OrdinalIgnoreCase);
    }

    private static bool TrySignInFromCookie()
    {
        var cookie = HttpContext.Current.Request.Cookies["AdminRemember"];
        if (cookie == null)
        {
            return false;
        }

        string uidValue = cookie.Values["uid"];
        string username = cookie.Values["un"];
        string token = cookie.Values["tk"];

        int userId;
        if (!int.TryParse(uidValue, out userId) || string.IsNullOrWhiteSpace(username))
        {
            return false;
        }

        using (var db = new BeautyStoryContext())
        {
            var user = db.CfUsers.FirstOrDefault(u => u.Id == userId && u.Username == username);
            if (user == null || !user.Status)
            {
                return false;
            }

            if (!RememberMeHelper.IsTokenValid(user.Id, user.Username, user.PasswordHash, token))
            {
                return false;
            }

            HttpContext.Current.Session["AdminUserId"] = user.Id;
            HttpContext.Current.Session["AdminUsername"] = user.Username;
            HttpContext.Current.Session["IsAdminSuper"] = string.Equals(user.Username, "admin", StringComparison.OrdinalIgnoreCase);
            return true;
        }
    }
}
