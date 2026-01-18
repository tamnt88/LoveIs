using System;
using System.Linq;
using System.Web;

public partial class SellerChatDefault : System.Web.UI.Page
{
    private int CurrentInquiryId
    {
        get { return ViewState["CurrentInquiryId"] != null ? (int)ViewState["CurrentInquiryId"] : 0; }
        set { ViewState["CurrentInquiryId"] = value; }
    }

    private int CurrentShopId
    {
        get { return ViewState["CurrentShopId"] != null ? (int)ViewState["CurrentShopId"] : 0; }
        set { ViewState["CurrentShopId"] = value; }
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
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops.AsNoTracking()
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                ShowError("Khong tim thay cua hang.");
                return;
            }

            var inquiryId = 0;
            int.TryParse(Request.QueryString["inquiryId"], out inquiryId);

            var inquiries = db.CfShopInquiries.AsNoTracking()
                .Where(i => i.Status && shopIds.Contains(i.ShopId))
                .OrderByDescending(i => i.LastReplyAt ?? i.CreatedAt)
                .Select(i => new
                {
                    i.Id,
                    i.ShopId,
                    i.CustomerId,
                    CreatedAt = i.CreatedAt,
                    LastReplyAt = i.LastReplyAt
                })
                .ToList();

            if (inquiries.Count == 0)
            {
                ShowError("Chua co cuoc chat nao.");
                return;
            }

            if (inquiryId <= 0 || !inquiries.Any(i => i.Id == inquiryId))
            {
                inquiryId = inquiries[0].Id;
            }

            CurrentInquiryId = inquiryId;
            CurrentShopId = inquiries.First(i => i.Id == inquiryId).ShopId;

            var customerIds = inquiries.Select(i => i.CustomerId).Distinct().ToList();
            var customerLookup = db.CfCustomers.AsNoTracking()
                .Where(c => customerIds.Contains(c.Id))
                .ToDictionary(c => c.Id, c => string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName);

            InquiryRepeater.DataSource = inquiries.Select(i => new
            {
                Url = "/seller/chat.aspx?inquiryId=" + i.Id,
                Title = customerLookup.ContainsKey(i.CustomerId) ? customerLookup[i.CustomerId] : ("Khach hang #" + i.CustomerId),
                SubTitle = (i.LastReplyAt ?? i.CreatedAt).ToString("dd/MM/yyyy HH:mm")
            }).ToList();
            InquiryRepeater.DataBind();

            BindMessages(db, inquiryId);
        }
    }

    private void BindMessages(BeautyStoryContext db, int inquiryId)
    {
        var messages = db.CfShopInquiryMessages.AsNoTracking()
            .Where(m => m.InquiryId == inquiryId)
            .OrderBy(m => m.CreatedAt)
            .Select(m => new
            {
                SenderLabel = m.SenderType == "shop" ? "Shop" : "Khach",
                CreatedText = m.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
                Message = HttpUtility.HtmlEncode(m.Message)
            })
            .ToList();

        MessageRepeater.DataSource = messages;
        MessageRepeater.DataBind();
    }

    protected void SendButton_Click(object sender, EventArgs e)
    {
        var message = (MessageTextBox.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(message))
        {
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var inquiry = db.CfShopInquiries.FirstOrDefault(i => i.Id == CurrentInquiryId && i.Status);
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
                SenderType = "shop",
                Message = message,
                CreatedAt = DateTime.Now
            });

            if (!inquiry.FirstReplyAt.HasValue)
            {
                inquiry.FirstReplyAt = DateTime.Now;
            }

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
