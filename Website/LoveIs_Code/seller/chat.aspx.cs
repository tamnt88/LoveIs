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
                    i.ProductId,
                    CreatedAt = i.CreatedAt,
                    LastReplyAt = i.LastReplyAt,
                    LastMessageAt = i.LastMessageAt
                })
                .ToList();

            if (inquiries.Count == 0)
            {
                ShowEmpty();
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
                .Select(c => new
                {
                    c.Id,
                    Name = (c.DisplayName == null || c.DisplayName == "") ? c.Username : c.DisplayName,
                    c.LastLoginAt
                })
                .ToList()
                .ToDictionary(c => c.Id, c => c);

            var inquiryIds = inquiries.Select(i => i.Id).ToList();
            var lastMessages = db.CfShopInquiryMessages.AsNoTracking()
                .Where(m => inquiryIds.Contains(m.InquiryId))
                .OrderByDescending(m => m.CreatedAt)
                .ToList()
                .GroupBy(m => m.InquiryId)
                .ToDictionary(g => g.Key, g => g.First());

            var unreadCounts = db.CfShopInquiryMessages.AsNoTracking()
                .Where(m => inquiryIds.Contains(m.InquiryId) && m.SenderType == "customer" && m.ReadAt == null)
                .GroupBy(m => m.InquiryId)
                .ToDictionary(g => g.Key, g => g.Count());

            var listView = inquiries.Select(i =>
            {
                var customerName = customerLookup.ContainsKey(i.CustomerId) ? customerLookup[i.CustomerId].Name : ("Khach hang #" + i.CustomerId);
                var initial = string.IsNullOrWhiteSpace(customerName) ? "?" : customerName.Trim().Substring(0, 1).ToUpperInvariant();
                var lastMessage = lastMessages.ContainsKey(i.Id) ? lastMessages[i.Id] : null;
                var lastTime = lastMessage != null ? lastMessage.CreatedAt : (i.LastReplyAt ?? i.CreatedAt);
                var snippet = lastMessage == null ? "Chua co tin nhan."
                    : (string.Equals(lastMessage.MessageType, "product_card", StringComparison.OrdinalIgnoreCase) ? "Da gui the san pham." : lastMessage.Message);
                if (!string.IsNullOrWhiteSpace(snippet) && snippet.Length > 80)
                {
                    snippet = snippet.Substring(0, 80) + "...";
                }

                var unread = unreadCounts.ContainsKey(i.Id) ? unreadCounts[i.Id] : 0;
                return new
                {
                    InquiryId = i.Id,
                    Url = "/seller/chat.aspx?inquiryId=" + i.Id,
                    Title = HttpUtility.HtmlEncode(customerName),
                    Initial = HttpUtility.HtmlEncode(initial),
                    Snippet = HttpUtility.HtmlEncode(snippet),
                    TimeText = lastTime.ToString("HH:mm"),
                    UnreadCount = unread,
                    ActiveClass = i.Id == inquiryId ? "active" : string.Empty,
                    UnreadClass = unread > 0 ? "is-unread" : string.Empty,
                    UnreadSort = unread > 0 ? 0 : 1,
                    LastTime = lastTime
                };
            }).OrderBy(v => v.UnreadSort).ThenByDescending(v => v.LastTime).ToList();

            InquiryRepeater.DataSource = listView;
            InquiryRepeater.DataBind();

            var current = inquiries.First(i => i.Id == inquiryId);
            var currentCustomerName = customerLookup.ContainsKey(current.CustomerId)
                ? customerLookup[current.CustomerId].Name
                : ("Khach hang #" + current.CustomerId);
            CustomerNameLiteral.Text = HttpUtility.HtmlEncode(currentCustomerName);
            CustomerInitialLiteral.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(currentCustomerName) ? "?" : currentCustomerName.Trim().Substring(0, 1).ToUpperInvariant());
            var customerLastLoginAt = customerLookup.ContainsKey(current.CustomerId) ? customerLookup[current.CustomerId].LastLoginAt : (DateTime?)null;
            CustomerStatusLiteral.Text = ChatPresenceHelper.BuildStatusText(customerLastLoginAt);
            CustomerStatusWrap.Attributes["class"] = ChatPresenceHelper.BuildStatusCssClass("seller-chat-status", customerLastLoginAt);

            InquiryIdField.Value = inquiryId.ToString(System.Globalization.CultureInfo.InvariantCulture);
            SenderIdField.Value = sellerId.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);

            BindMessages(db, inquiryId, current.ProductId);
        }
    }

    private void BindMessages(BeautyStoryContext db, int inquiryId, int? productId)
    {
        var unread = db.CfShopInquiryMessages
            .Where(m => m.InquiryId == inquiryId && m.SenderType == "customer" && m.ReadAt == null)
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

        var messages = db.CfShopInquiryMessages.AsNoTracking()
            .Where(m => m.InquiryId == inquiryId)
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
        var fileLookup = db.CfShopInquiryMessageFiles.AsNoTracking()
            .Where(f => messageIds.Contains(f.MessageId) && f.Status)
            .ToList()
            .GroupBy(f => f.MessageId)
            .ToDictionary(g => g.Key, g => g.ToList());

        var productCardHtml = productId.HasValue ? BuildProductCardHtml(db, productId.Value) : string.Empty;
        ProductCardLiteral.Text = productCardHtml;
        var view = messages.Select(m => new
        {
            SenderClass = string.Equals(m.SenderType, "shop", StringComparison.OrdinalIgnoreCase) ? "me" : string.Empty,
            CreatedText = m.CreatedAt.ToString("HH:mm"),
            MessageHtml = string.Equals(m.MessageType, "image", StringComparison.OrdinalIgnoreCase)
                ? BuildImageGridHtml(fileLookup.ContainsKey(m.MessageId) ? fileLookup[m.MessageId] : null)
                : HttpUtility.HtmlEncode(m.Message),
            MessageType = m.MessageType
        }).ToList();

        MessageRepeater.DataSource = view
            .Where(m => !string.Equals(m.MessageType, "product_card", StringComparison.OrdinalIgnoreCase))
            .ToList();
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
                MessageType = "text",
                Message = message,
                CreatedAt = DateTime.Now
            });

            if (!inquiry.FirstReplyAt.HasValue)
            {
                inquiry.FirstReplyAt = DateTime.Now;
            }

            inquiry.LastReplyAt = DateTime.Now;
            inquiry.LastMessageAt = inquiry.LastReplyAt;
            inquiry.LastMessageSender = "shop";

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
        EmptyPanel.Visible = false;
    }

    private void ShowEmpty()
    {
        ErrorPanel.Visible = false;
        ErrorPanel.Controls.Clear();
        ChatPanel.Visible = false;
        EmptyPanel.Visible = true;
    }

    private static string BuildProductCardHtml(BeautyStoryContext db, int productId)
    {
        var product = db.CfProducts.FirstOrDefault(p => p.Id == productId);
        if (product == null)
        {
            return "<div>Khong tim thay san pham.</div>";
        }

        var imageUrl = db.CfProductImages
            .Where(i => i.ProductId == productId && i.Status)
            .OrderByDescending(i => i.IsPrimary)
            .ThenBy(i => i.SortOrder)
            .Select(i => i.ImageUrl)
            .FirstOrDefault() ?? "/images/fav.png";

        var slug = db.CfSeoSlugs
            .Where(s => s.Status && s.EntityType == "Product" && s.EntityId == productId)
            .Select(s => s.SeoSlug)
            .FirstOrDefault();

        var url = string.IsNullOrWhiteSpace(slug) ? ("/san-pham/san-pham-" + productId) : ("/san-pham/" + slug);

        var price = db.CfProductVariants
            .Where(v => v.ProductId == productId && v.Status)
            .OrderBy(v => v.Price)
            .Select(v => new { v.Price, v.SalePrice })
            .FirstOrDefault();

        var priceText = price != null
            ? string.Format("{0:N0} đ", (price.SalePrice.HasValue && price.SalePrice.Value > 0 && price.SalePrice.Value < price.Price) ? price.SalePrice.Value : price.Price)
            : "Liên hệ";

        return string.Format(
            "<div class=\"chat-product-card\">" +
            "<img class=\"chat-product-thumb\" src=\"{0}\" alt=\"{1}\" />" +
            "<div class=\"chat-product-info\">" +
            "<div class=\"chat-product-name\">{1}</div>" +
            "<div class=\"chat-product-price\">{2}</div>" +
            "</div>" +
            "<div class=\"chat-product-actions\">" +
            "<a class=\"chat-buy-btn\" href=\"{3}\">Xem sản phẩm</a>" +
            "</div>" +
            "</div>",
            HttpUtility.HtmlEncode(imageUrl),
            HttpUtility.HtmlEncode(product.ProductName ?? string.Empty),
            HttpUtility.HtmlEncode(priceText),
            HttpUtility.HtmlEncode(url)
        );
    }

    private static string BuildImageGridHtml(System.Collections.Generic.List<CfShopInquiryMessageFile> files)
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
