using System;
using System.Linq;
using System.Web;

public partial class OrderLookup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ApplySeo();
            var code = Request.QueryString["code"];
            var phone = Request.QueryString["phone"];
            if (!string.IsNullOrWhiteSpace(code))
            {
                OrderCodeInput.Text = code.Trim();
            }
            if (!string.IsNullOrWhiteSpace(phone))
            {
                PhoneInput.Text = phone.Trim();
            }
        }
    }

    private void ApplySeo()
    {
        string canonical = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Path) : string.Empty;
        SystemPageSeoApplier.Apply("order-tracking", SeoTitleLiteral, SeoMetaLiteral, "Tra cứu đơn hàng | LoveIs Store", canonical);
    }

    protected void LookupButton_Click(object sender, EventArgs e)
    {
        MessageLiteral.Text = string.Empty;

        var code = (OrderCodeInput.Text ?? string.Empty).Trim();
        var phone = (PhoneInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(phone))
        {
            MessageLiteral.Text = "<div class=\"alert alert-warning\">Vui lòng nhập đầy đủ mã đơn hàng và số điện thoại.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var order = db.CfOrders.FirstOrDefault(o => o.OrderCode == code && o.Phone == phone);
            if (order == null)
            {
                MessageLiteral.Text = "<div class=\"alert alert-danger\">Không tìm thấy đơn hàng phù hợp. Vui lòng kiểm tra lại thông tin.</div>";
                return;
            }
        }

        Response.Redirect("/don-hang/default.aspx?code=" + HttpUtility.UrlEncode(code), true);
    }
}
