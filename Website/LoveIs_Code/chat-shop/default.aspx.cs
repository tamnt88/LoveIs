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
        int productId = 0;
        int.TryParse(Request.QueryString["productId"], out productId);
        if (shopId <= 0)
        {
            ShowError("Khong tim thay cua hang.");
            return;
        }
        if (productId <= 0)
        {
            ShowError("Khong tim thay san pham.");
            return;
        }

        ShopId = shopId;

        using (var db = new BeautyStoryContext())
        {
            var product = db.CfProducts.FirstOrDefault(p => p.Id == productId && p.Status);
            if (product == null || !product.ShopId.HasValue || product.ShopId.Value != shopId)
            {
                ShowError("Khong tim thay san pham.");
                return;
            }

            var shop = db.CfShops.FirstOrDefault(s => s.Id == shopId);
            if (shop == null)
            {
                ShowError("Khong tim thay cua hang.");
                return;
            }

            TitleLiteral.Text = HttpUtility.HtmlEncode(shop.ShopName) + " | Chat";
            ShopNameLiteral.Text = HttpUtility.HtmlEncode(shop.ShopName);
            ShopAvatar.ImageUrl = string.IsNullOrWhiteSpace(shop.LogoUrl) ? "/images/fav.png" : shop.LogoUrl;

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
            }

            InquiryId = inquiry.Id;
            InquiryIdField.Value = inquiry.Id.ToString(System.Globalization.CultureInfo.InvariantCulture);
            SenderIdField.Value = customerId.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);

            BindMessages(db, inquiry.Id, productId);
        }
    }

    private void BindMessages(BeautyStoryContext db, int inquiryId, int productId)
    {
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

        var productCardHtml = BuildProductCardHtml(db, productId);
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
