using System;
using System.Linq;

public partial class CustomerEmailVerify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            return;
        }

        var token = (Request.QueryString["token"] ?? string.Empty).Trim();
        var sent = Request.QueryString["sent"];

        if (!string.IsNullOrWhiteSpace(sent))
        {
            StatusMessage.Text = "Chúng tôi đã gửi email xác nhận. Vui lòng kiểm tra hộp thư của bạn.";
            return;
        }

        if (string.IsNullOrWhiteSpace(token))
        {
            StatusMessage.Text = "Liên kết xác nhận không hợp lệ.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.EmailVerifyToken == token);
            if (customer == null)
            {
                StatusMessage.Text = "Liên kết xác nhận không hợp lệ hoặc đã được sử dụng.";
                return;
            }

            if (customer.EmailVerifyExpiresAt.HasValue && customer.EmailVerifyExpiresAt.Value < DateTime.UtcNow)
            {
                StatusMessage.Text = "Liên kết xác nhận đã hết hạn. Vui lòng đăng ký lại.";
                return;
            }

            customer.EmailVerified = true;
            customer.EmailVerifyToken = null;
            customer.EmailVerifyExpiresAt = null;
            db.SaveChanges();

            StatusMessage.Text = "Xác nhận email thành công. Bạn có thể đăng nhập ngay.";
        }
    }
}
