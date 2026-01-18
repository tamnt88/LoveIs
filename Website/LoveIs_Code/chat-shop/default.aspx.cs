using System;
using System.Linq;
using System.Web;

public partial class ShopChatDefault : System.Web.UI.Page
{
    private int ShopId
    {
        get { return ViewState["ShopId"] != null ? (int)ViewState["ShopId"] : 0; }
        set { ViewState["ShopId"] = value; }
    }

    private int InquiryId
    {
        get { return ViewState["InquiryId"] != null ? (int)ViewState["InquiryId"] : 0; }
        set { ViewState["InquiryId"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPage();
        }
    }

    private void BindPage()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        int shopId = 0;
        int.TryParse(Request.QueryString["shopId"], out shopId);
        if (shopId <= 0)
        {
            ShowError("Khong tim thay cua hang.");
            return;
        }

        ShopId = shopId;

        using (var db = new BeautyStoryContext())
        {
            var shop = db.CfShops.FirstOrDefault(s => s.Id == shopId);
            if (shop == null)
            {
                ShowError("Khong tim thay cua hang.");
                return;
            }

            TitleLiteral.Text = HttpUtility.HtmlEncode(shop.ShopName) + " | Chat";
            ShopNameLiteral.Text = HttpUtility.HtmlEncode(shop.ShopName);

            var inquiry = db.CfShopInquiries.FirstOrDefault(i => i.ShopId == shopId && i.CustomerId == customerId.Value && i.Status);
            if (inquiry == null)
            {
                inquiry = new CfShopInquiry
                {
                    ShopId = shopId,
                    CustomerId = customerId.Value,
                    CreatedAt = DateTime.Now,
                    Status = true
                };
                db.CfShopInquiries.Add(inquiry);
                db.SaveChanges();
            }

            InquiryId = inquiry.Id;

            BindMessages(db, inquiry.Id);
        }
    }

    private void BindMessages(BeautyStoryContext db, int inquiryId)
    {
        var messages = db.CfShopInquiryMessages.AsNoTracking()
            .Where(m => m.InquiryId == inquiryId)
            .OrderBy(m => m.CreatedAt)
            .Select(m => new
            {
                SenderLabel = m.SenderType == "shop" ? "Shop" : "Ban",
                CreatedText = m.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
                Message = HttpUtility.HtmlEncode(m.Message)
            })
            .ToList();

        MessageRepeater.DataSource = messages;
        MessageRepeater.DataBind();
    }

    protected void SendButton_Click(object sender, EventArgs e)
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        var message = (MessageTextBox.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(message))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var inquiry = db.CfShopInquiries.FirstOrDefault(i => i.Id == InquiryId && i.ShopId == ShopId && i.CustomerId == customerId.Value);
            if (inquiry == null)
            {
                ShowError("Khong tim thay cuoc chat.");
                return;
            }

            db.CfShopInquiryMessages.Add(new CfShopInquiryMessage
            {
                InquiryId = inquiry.Id,
                ShopId = inquiry.ShopId,
                CustomerId = inquiry.CustomerId,
                SenderType = "customer",
                Message = message,
                CreatedAt = DateTime.Now
            });

            inquiry.LastReplyAt = DateTime.Now;

            db.SaveChanges();
        }

        MessageTextBox.Text = string.Empty;
        Response.Redirect(Request.RawUrl);
    }

    private void ShowError(string message)
    {
        ErrorPanel.Visible = true;
        ErrorPanel.Controls.Clear();
        ErrorPanel.Controls.Add(new System.Web.UI.LiteralControl(HttpUtility.HtmlEncode(message)));
        ChatPanel.Visible = false;
    }
}
