using System;
using System.Linq;
using System.Web;

public partial class SellerSupportChat : System.Web.UI.Page
{
    private int CurrentChatId
    {
        get { return ViewState["CurrentChatId"] != null ? (int)ViewState["CurrentChatId"] : 0; }
        set { ViewState["CurrentChatId"] = value; }
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
            var chat = db.CfSupportChats.FirstOrDefault(c => c.SellerId == sellerId.Value && c.Status);
            if (chat == null)
            {
                chat = new CfSupportChat
                {
                    SellerId = sellerId.Value,
                    CreatedAt = DateTime.Now,
                    Status = true
                };
                db.CfSupportChats.Add(chat);
                db.SaveChanges();
            }

            CurrentChatId = chat.Id;
            ChatIdField.Value = chat.Id.ToString(System.Globalization.CultureInfo.InvariantCulture);
            SenderIdField.Value = sellerId.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
            DateTime? adminLastLoginAt = null;
            if (chat.AdminId.HasValue)
            {
                adminLastLoginAt = db.CfUsers.AsNoTracking()
                    .Where(u => u.Id == chat.AdminId.Value)
                    .Select(u => (DateTime?)u.LastLoginAt)
                    .FirstOrDefault();
            }
            AdminStatusLiteral.Text = ChatPresenceHelper.BuildStatusText(adminLastLoginAt);
            AdminStatusWrap.Attributes["class"] = ChatPresenceHelper.BuildStatusCssClass("seller-chat-status", adminLastLoginAt);

            BindMessages(db, chat.Id);
        }
    }

    private void BindMessages(BeautyStoryContext db, int chatId)
    {
        var unread = db.CfSupportChatMessages
            .Where(m => m.ChatId == chatId && m.SenderType == "admin" && m.ReadAt == null)
            .ToList();

        if (unread.Count > 0)
        {
            var now = DateTime.Now;
            foreach (var msg in unread)
            {
                msg.ReadAt = now;
            }
            db.SaveChanges();
        }

        var messages = db.CfSupportChatMessages.AsNoTracking()
            .Where(m => m.ChatId == chatId)
            .OrderBy(m => m.CreatedAt)
            .Select(m => new
            {
                SenderType = m.SenderType,
                CreatedAt = m.CreatedAt,
                Message = m.Message,
                MessageType = m.MessageType,
                MessageId = m.Id
            })
            .ToList();

        var messageIds = messages.Select(m => m.MessageId).ToList();
        var fileLookup = db.CfSupportChatMessageFiles.AsNoTracking()
            .Where(f => messageIds.Contains(f.MessageId) && f.Status)
            .ToList()
            .GroupBy(f => f.MessageId)
            .ToDictionary(g => g.Key, g => g.ToList());

        var view = messages.Select(m => new
        {
            SenderClass = string.Equals(m.SenderType, "seller", StringComparison.OrdinalIgnoreCase) ? "me" : string.Empty,
            CreatedText = m.CreatedAt.ToString("HH:mm"),
            MessageHtml = string.Equals(m.MessageType, "image", StringComparison.OrdinalIgnoreCase)
                ? BuildImageGridHtml(fileLookup.ContainsKey(m.MessageId) ? fileLookup[m.MessageId] : null)
                : HttpUtility.HtmlEncode(m.Message),
            MessageType = m.MessageType
        }).ToList();

        MessageRepeater.DataSource = view;
        MessageRepeater.DataBind();
    }

    private static string BuildImageGridHtml(System.Collections.Generic.List<CfSupportChatMessageFile> files)
    {
        if (files == null || files.Count == 0)
        {
            return string.Empty;
        }

        var html = new System.Text.StringBuilder();
        html.Append("<div class=\"chat-image-grid\">");
        foreach (var file in files)
        {
            var url = HttpUtility.HtmlEncode(file.FileUrl ?? string.Empty);
            html.AppendFormat("<img class=\"chat-image-thumb\" src=\"{0}\" alt=\"image\" data-full=\"{0}\" />", url);
        }
        html.Append("</div>");
        return html.ToString();
    }
}
