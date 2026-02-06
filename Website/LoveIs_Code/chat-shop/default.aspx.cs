using System;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

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

        SenderIdField.Value = customerId.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
        InquiryIdField.Value = "0";

        using (var db = new BeautyStoryContext())
        {
            var inquiryIdParam = 0;
            int.TryParse(Request.QueryString["inquiryId"], out inquiryIdParam);
            var shopId = 0;
            int.TryParse(Request.QueryString["shopId"], out shopId);
            var productId = 0;
            int.TryParse(Request.QueryString["productId"], out productId);

            CfShopInquiry currentInquiry = null;
            if (inquiryIdParam > 0)
            {
                currentInquiry = db.CfShopInquiries.FirstOrDefault(i => i.Id == inquiryIdParam && i.CustomerId == customerId.Value && i.Status);
            }
            else if (shopId > 0 && productId > 0)
            {
                ShopId = shopId;
                var product = db.CfProducts.FirstOrDefault(p => p.Id == productId && p.Status);
                if (product == null || !product.ShopId.HasValue || product.ShopId.Value != shopId)
                {
                    ShowError("Khong tim thay san pham.");
                    return;
                }

                var inquiry = db.CfShopInquiries.FirstOrDefault(i => i.ShopId == shopId
                    && i.CustomerId == customerId.Value
                    && i.ProductId == productId
                    && i.Status);
                if (inquiry == null)
                {
                    inquiry = new CfShopInquiry
                    {
                        ShopId = shopId,
                        CustomerId = customerId.Value,
                        ProductId = productId,
                        CreatedAt = DateTime.Now,
                        Status = true
                    };
                    db.CfShopInquiries.Add(inquiry);
                    db.SaveChanges();

                db.CfShopInquiryMessages.Add(new CfShopInquiryMessage
                {
                    InquiryId = inquiry.Id,
                    ShopId = inquiry.ShopId,
                    CustomerId = inquiry.CustomerId,
                    SenderType = "customer",
                    MessageType = "product_card",
                    Message = product.ProductName,
                    CreatedAt = DateTime.Now
                });
                inquiry.LastReplyAt = DateTime.Now;
                inquiry.LastMessageAt = inquiry.LastReplyAt;
                inquiry.LastMessageSender = "customer";
                db.SaveChanges();

                NotifyNewMessageAlert(inquiry, shopId, "product_card", product.ProductName);
            }

                currentInquiry = inquiry;
            }

            if (currentInquiry != null)
            {
                InquiryId = currentInquiry.Id;
                InquiryIdField.Value = currentInquiry.Id.ToString(System.Globalization.CultureInfo.InvariantCulture);
            }

            BindConversationList(db, customerId.Value, currentInquiry != null ? currentInquiry.Id : 0);

            if (ChatRoot != null)
            {
                ChatRoot.Attributes["data-sender-id"] = customerId.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
                ChatRoot.Attributes["data-sender-type"] = "customer";
                ChatRoot.Attributes["data-chat-id"] = currentInquiry != null ? currentInquiry.Id.ToString(System.Globalization.CultureInfo.InvariantCulture) : "0";
            }

            if (currentInquiry == null)
            {
                WelcomePanel.Visible = true;
                ChatPanel.Visible = false;
                return;
            }

            var currentShop = db.CfShops.FirstOrDefault(s => s.Id == currentInquiry.ShopId);
            if (currentShop == null)
            {
                ShowError("Khong tim thay cua hang.");
                return;
            }

            ShopId = currentInquiry.ShopId;
            TitleLiteral.Text = HttpUtility.HtmlEncode(currentShop.ShopName) + " | Chat";
            ShopNameLiteral.Text = HttpUtility.HtmlEncode(currentShop.ShopName);
            ShopAvatar.ImageUrl = string.IsNullOrWhiteSpace(currentShop.LogoUrl) ? "/images/fav.png" : currentShop.LogoUrl;
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == currentShop.SellerId);
            var sellerLastLoginAt = seller != null ? seller.LastLoginAt : (DateTime?)null;
            ShopStatusLiteral.Text = ChatPresenceHelper.BuildStatusText(sellerLastLoginAt);
            ShopStatusWrap.Attributes["class"] = ChatPresenceHelper.BuildStatusCssClass("shop-chat-status", sellerLastLoginAt);

            BindMessages(db, currentInquiry.Id, currentInquiry.ProductId);
        }
    }

    private static void NotifyNewMessageAlert(CfShopInquiry inquiry, int shopId, string messageType, string message)
    {
        if (inquiry == null || shopId <= 0)
        {
            return;
        }

        var sellerId = 0;
        using (var db = new BeautyStoryContext())
        {
            var shop = db.CfShops.AsNoTracking().FirstOrDefault(s => s.Id == shopId);
            if (shop != null)
            {
                sellerId = shop.SellerId;
            }
        }

        if (sellerId <= 0)
        {
            return;
        }

        var payload = new
        {
            InquiryId = inquiry.Id,
            ShopId = inquiry.ShopId,
            CustomerId = inquiry.CustomerId,
            SenderType = "customer",
            SenderId = inquiry.CustomerId,
            Message = message ?? string.Empty,
            MessageType = messageType ?? "text",
            CreatedAt = DateTime.Now.ToString("HH:mm"),
            CustomerName = string.Empty,
            ShopName = string.Empty
        };

        var context = GlobalHost.ConnectionManager.GetHubContext<ShopInquiryChatHub>();
        if (context != null)
        {
            context.Clients.Group("shop-inquiry-seller-" + sellerId.ToString(System.Globalization.CultureInfo.InvariantCulture))
                .newMessageAlert(payload);
        }
    }

    private void BindMessages(BeautyStoryContext db, int inquiryId, int? productId)
    {
        var unread = db.CfShopInquiryMessages
            .Where(m => m.InquiryId == inquiryId && m.SenderType == "shop" && m.ReadAt == null)
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
                SenderLabel = m.SenderType == "shop" ? "Shop" : "Ban",
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

        var view = messages
        .Where(m => !string.Equals(m.MessageType, "product_card", StringComparison.OrdinalIgnoreCase))
        .Select(m => new
        {
            SenderLabel = m.SenderLabel,
            CreatedText = m.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
            MessageHtml = string.Equals(m.MessageType, "image", StringComparison.OrdinalIgnoreCase)
                ? BuildImageGridHtml(fileLookup.ContainsKey(m.MessageId) ? fileLookup[m.MessageId] : null)
                : HttpUtility.HtmlEncode(m.Message),
            SenderClass = string.Equals(m.SenderLabel, "Ban", StringComparison.OrdinalIgnoreCase) ? "me" : ""
        }).ToList();

        MessageRepeater.DataSource = view;
        MessageRepeater.DataBind();
    }

    private void BindConversationList(BeautyStoryContext db, int customerId, int currentInquiryId)
    {
        var inquiries = db.CfShopInquiries.AsNoTracking()
            .Where(i => i.CustomerId == customerId && i.Status)
            .OrderByDescending(i => i.LastReplyAt ?? i.CreatedAt)
            .Select(i => new
            {
                i.Id,
                i.ShopId,
                i.ProductId,
                i.CreatedAt,
                i.LastReplyAt,
                i.LastMessageAt
            })
            .ToList();

        if (inquiries.Count == 0)
        {
            ChatUnreadLiteral.Text = "0";
            WelcomePanel.Visible = true;
            ChatPanel.Visible = false;
            return;
        }

        var inquiryIds = inquiries.Select(i => i.Id).ToList();
        if (ChatRoot != null)
        {
            ChatRoot.Attributes["data-inquiry-ids"] = string.Join(",", inquiryIds);
        }
        var lastMessages = db.CfShopInquiryMessages.AsNoTracking()
            .Where(m => inquiryIds.Contains(m.InquiryId))
            .OrderByDescending(m => m.CreatedAt)
            .ToList()
            .GroupBy(m => m.InquiryId)
            .ToDictionary(g => g.Key, g => g.First());

        var unreadCounts = db.CfShopInquiryMessages.AsNoTracking()
            .Where(m => inquiryIds.Contains(m.InquiryId) && m.SenderType == "shop" && m.ReadAt == null)
            .GroupBy(m => m.InquiryId)
            .ToDictionary(g => g.Key, g => g.Count());

        var shopIds = inquiries.Select(i => i.ShopId).Distinct().ToList();
        var shopLookup = db.CfShops.AsNoTracking()
            .Where(s => shopIds.Contains(s.Id))
            .Select(s => new { s.Id, s.ShopName, s.LogoUrl })
            .ToList()
            .ToDictionary(s => s.Id, s => s);

        var totalUnread = unreadCounts.Sum(x => x.Value);
        ChatUnreadLiteral.Text = totalUnread.ToString();

            var listView = inquiries.Select(i =>
            {
                var shopName = shopLookup.ContainsKey(i.ShopId) ? shopLookup[i.ShopId].ShopName : ("Shop #" + i.ShopId);
                var initial = string.IsNullOrWhiteSpace(shopName) ? "?" : shopName.Trim().Substring(0, 1).ToUpperInvariant();
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
                    Url = "/chat-shop/default.aspx?inquiryId=" + i.Id,
                    Title = HttpUtility.HtmlEncode(shopName),
                    TitlePlain = HttpUtility.HtmlAttributeEncode(shopName ?? string.Empty),
                    Initial = HttpUtility.HtmlEncode(initial),
                    Snippet = HttpUtility.HtmlEncode(snippet),
                    TimeText = lastTime.ToString("dd/MM"),
                    UnreadCount = unread,
                    ActiveClass = i.Id == currentInquiryId ? "active" : string.Empty,
                UnreadClass = unread > 0 ? "is-unread" : string.Empty,
                UnreadSort = unread > 0 ? 0 : 1,
                LastTime = lastTime
            };
        }).OrderBy(v => v.UnreadSort).ThenByDescending(v => v.LastTime).ToList();

        InquiryRepeater.DataSource = listView;
        InquiryRepeater.DataBind();
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
                MessageType = "text",
                Message = message,
                CreatedAt = DateTime.Now
            });

            inquiry.LastReplyAt = DateTime.Now;
            inquiry.LastMessageAt = inquiry.LastReplyAt;
            inquiry.LastMessageSender = "customer";

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

        var buyNowUrl = "/chat-shop/buy-now.aspx?productId=" + productId.ToString(System.Globalization.CultureInfo.InvariantCulture);
        return string.Format(
            "<div class=\"chat-product-card\">" +
            "<img class=\"chat-product-thumb\" src=\"{0}\" alt=\"{1}\" />" +
            "<div class=\"chat-product-info\">" +
            "<div class=\"chat-product-name\">{1}</div>" +
            "<div class=\"chat-product-price\">{2}</div>" +
            "</div>" +
            "<div class=\"chat-product-actions\">" +
            "<a class=\"chat-buy-btn\" href=\"{3}\">Mua ngay</a>" +
            "</div>" +
            "</div>",
            HttpUtility.HtmlEncode(imageUrl),
            HttpUtility.HtmlEncode(product.ProductName ?? string.Empty),
            HttpUtility.HtmlEncode(priceText),
            HttpUtility.HtmlEncode(buyNowUrl)
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
