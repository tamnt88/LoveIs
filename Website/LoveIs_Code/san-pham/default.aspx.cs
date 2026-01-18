using System;

using System.Collections.Generic;

using System.Linq;

using System.Data.Entity;

using System.Text.RegularExpressions;

using System.Web;

using System.Web.Script.Serialization;

using System.Web.UI;

public partial class ProductDefault : System.Web.UI.Page

{

    public string MainImageUrl { get; set; }

    public string ProductName { get; set; }

    public string VariantPriceJson { get; set; }

    public string VariantIdJson { get; set; }

    public string VariantSkuJson { get; set; }

    public string VariantStockJson { get; set; }

    public string ProductSeoSlug { get; set; }

    public string BrandName { get; set; }

    public string OriginName { get; set; }

    public string ShopProvinceName { get; set; }

    public string ShopUrl { get; set; }

    public string ChatShopUrl { get; set; }

    public string ShopLogoUrl { get; set; }

    public string CartVariantQtyJson { get; set; }

    private int CurrentProductId

    {

        get { return ViewState["CurrentProductId"] != null ? (int)ViewState["CurrentProductId"] : 0; }

        set { ViewState["CurrentProductId"] = value; }

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

            BindProductPage();

        }

    }

    private void BindProductPage()

    {

        using (var db = new BeautyStoryContext())

        {

            var allCategories = db.CfCategories.AsNoTracking()

                .Where(c => c.Status)

                .OrderBy(c => c.SortOrder)

                .ThenBy(c => c.CategoryName)

                .ToList();

            var slugTypes = new[] { "Product", "Category", "Brand", "Origin" };

            var slugs = db.CfSeoSlugs.AsNoTracking()

                .Where(s => slugTypes.Contains(s.EntityType))

                .ToList();

            var slugLookup = slugs

                .GroupBy(s => s.EntityType)

                .ToDictionary(

                    g => g.Key,

                    g => g.ToDictionary(s => s.EntityId, s => s.SeoSlug));

            string slug = GetSlugFromRequest();

            int productId = ResolveProductId(slugLookup, slug);

            if (productId == 0)

            {

                ProductNameLiteral.Text = "Không tìm thấy sản phẩm";

                return;

            }

            var product = db.CfProducts.FirstOrDefault(p => p.Id == productId);

            if (product == null)

            {

                ProductNameLiteral.Text = "Không tìm thấy sản phẩm";

                return;

            }

            var viewedKey = "viewed_product_" + product.Id;

            if (Session[viewedKey] == null)

            {

                product.ViewCount += 1;

                Session[viewedKey] = true;

                db.SaveChanges();

            }

            CurrentProductId = product.Id;

            var productReviews = db.CfProductReviews.AsNoTracking()
                .Where(r => r.ProductId == product.Id && r.Status)
                .ToList();
            var verifiedReviews = productReviews.Where(r => r.IsVerified).ToList();
            var productReviewCount = verifiedReviews.Count;
            var productRatingAvg = productReviewCount > 0
                ? (decimal)verifiedReviews.Average(r => r.Rating)
                : 0m;
            if (ProductRatingWrap != null)
            {
                ProductRatingWrap.Visible = productReviewCount > 0;
            }
            if (ProductNoRatingWrap != null)
            {
                ProductNoRatingWrap.Visible = productReviewCount == 0;
            }
            if (ProductRatingLiteral != null)
            {
                ProductRatingLiteral.Text = productReviewCount > 0 ? productRatingAvg.ToString("0.0") : string.Empty;
            }
            if (ProductRatingCountLiteral != null)
            {
                ProductRatingCountLiteral.Text = productReviewCount > 0 ? productReviewCount + " đánh giá" : string.Empty;
            }
            if (ProductReviewEmpty != null)
            {
                ProductReviewEmpty.Visible = productReviewCount == 0;
            }
            if (ProductReviewRepeater != null)
            {
                var currentCustomerId = CustomerAuth.GetCustomerId();
                var customerIds = productReviews.Select(r => r.CustomerId).Distinct().ToList();
                var customerLookup = db.CfCustomers.AsNoTracking()
                    .Where(c => customerIds.Contains(c.Id))
                    .Select(c => new { c.Id, c.DisplayName, c.Username })
                    .ToDictionary(c => c.Id, c => string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName);
                var reviewItems = productReviews
                    .OrderByDescending(r => r.CreatedAt)
                    .Where(r => r.IsVerified || (currentCustomerId.HasValue && r.CustomerId == currentCustomerId.Value))
                    .Select(r => new ProductReviewItem
                    {
                        Id = r.Id,
                        CustomerName = HttpUtility.HtmlEncode(customerLookup.ContainsKey(r.CustomerId) ? customerLookup[r.CustomerId] : "Khách hàng"),
                        Rating = r.Rating,
                        Content = HttpUtility.HtmlEncode(r.Content ?? string.Empty),
                        CreatedAt = r.CreatedAt.ToString("dd/MM/yyyy"),
                        RatingStars = BuildRatingStars(r.Rating),
                        CanDelete = !r.IsVerified && currentCustomerId.HasValue && r.CustomerId == currentCustomerId.Value,
                        ShowStatus = !r.IsVerified && currentCustomerId.HasValue && r.CustomerId == currentCustomerId.Value,
                        StatusText = "Đánh giá đang chờ duyệt"
                    })
                    .ToList();
                ProductReviewRepeater.DataSource = reviewItems;
                ProductReviewRepeater.DataBind();
            }
            var cart = CartService.GetCart();

            var limit = CartService.GetOrderLimitForCustomer();

            if (CartLimitMaxItems != null && CartLimitMaxQty != null && CartLimitCartQty != null && CartLimitVariantQtyJson != null)

            {

                CartLimitMaxItems.Value = limit != null ? limit.MaxItemsPerOrder.ToString() : string.Empty;

                CartLimitMaxQty.Value = limit != null ? limit.MaxQtyPerItem.ToString() : string.Empty;

                CartLimitCartQty.Value = cart.Sum(c => c.Quantity).ToString();

                var map = cart.GroupBy(c => c.VariantId)
                    .ToDictionary(g => g.Key.ToString(), g => g.Sum(x => x.Quantity));

                CartLimitVariantQtyJson.Value = new JavaScriptSerializer().Serialize(map);

            }

            ProductName = product.ProductName;

            ProductNameLiteral.Text = product.ProductName;

            ProductSeoSlug = GetSlug(slugLookup, "Product", product.Id);

            var brandName = string.Empty;

            var brandSlug = string.Empty;

            if (product.BrandId > 0)

            {

                var brand = db.CfBrands.AsNoTracking().FirstOrDefault(b => b.Id == product.BrandId);

                if (brand != null)

                {

                    brandName = brand.BrandName;

                    brandSlug = GetSlug(slugLookup, "Brand", brand.Id);

                }

            }

            NhaCungCapLink.Text = string.IsNullOrWhiteSpace(brandName) ? "\u004eh\u00e0 cung c\u1ea5p" : brandName;

            NhaCungCapLink.NavigateUrl = string.IsNullOrWhiteSpace(brandSlug) ? "#" : "/thuong-hieu/" + brandSlug;

            BrandName = brandName;

            var originName = string.Empty;

            var originSlug = string.Empty;

            if (product.OriginId.HasValue && product.OriginId.Value > 0)

            {

                var origin = db.CfOrigins.AsNoTracking().FirstOrDefault(o => o.Id == product.OriginId.Value);

                if (origin != null)

                {

                    originName = origin.OriginName;

                    originSlug = GetSlug(slugLookup, "Origin", origin.Id);

                }

            }

            XuatXuLink.Text = string.IsNullOrWhiteSpace(originName) ? "\u0058u\u1ea5t x\u1ee9" : originName;

            XuatXuLink.NavigateUrl = string.IsNullOrWhiteSpace(originSlug) ? "#" : "/xuat-xu/" + originSlug;

            var shopName = string.Empty;

            var shopCode = string.Empty;
            var shopProvince = string.Empty;
            var shopRatingAvg = 0m;
            var shopRatingCount = 0;
            var shopCompletedOrders = 0;
            DateTime? shopCreatedAt = null;
            decimal? responseRate = null;
            int? responseTimeMinutes = null;
            var followerCount = 0;
            var productCount = 0;

            if (product.ShopId.HasValue && product.ShopId.Value > 0)

            {

                var shop = db.CfShops.FirstOrDefault(s => s.Id == product.ShopId.Value);

                if (shop != null)

                {

                    shopName = shop.ShopName;

                    shopCode = shop.ShopCode;
                    shopProvince = shop.ProvinceName ?? string.Empty;
                    var verifiedShopReviews = db.CfShopReviews.AsNoTracking()
                        .Where(r => r.ShopId == shop.Id && r.Status && r.IsVerified)
                        .ToList();
                    shopRatingCount = verifiedShopReviews.Count;
                    shopRatingAvg = shopRatingCount > 0
                        ? (decimal)verifiedShopReviews.Average(r => r.Rating)
                        : 0m;
                    shopCompletedOrders = shop.CompletedOrders;
                    ShopLogoUrl = string.IsNullOrWhiteSpace(shop.LogoUrl) ? "/images/fav.png" : shop.LogoUrl;

                    shopCreatedAt = shop.CreatedAt;
                    responseRate = shop.ResponseRate;
                    responseTimeMinutes = shop.ResponseTimeMinutes;
                    followerCount = shop.FollowerCount;

                    productCount = db.CfProducts.AsNoTracking()
                        .Count(p => p.ShopId == shop.Id && p.Status);

                    var since = DateTime.Now.AddDays(-30);
                    var inquiries = db.CfShopInquiries.AsNoTracking()
                        .Where(i => i.ShopId == shop.Id && i.Status && i.CreatedAt >= since)
                        .Select(i => new { i.CreatedAt, i.FirstReplyAt })
                        .ToList();

                    if (inquiries.Count > 0)
                    {
                        var responded = inquiries.Count(i => i.FirstReplyAt.HasValue);
                        responseRate = responded > 0
                            ? Math.Round((decimal)responded * 100m / inquiries.Count, 1)
                            : 0m;

                        if (responded > 0)
                        {
                            var avgMinutes = inquiries
                                .Where(i => i.FirstReplyAt.HasValue)
                                .Average(i => (i.FirstReplyAt.Value - i.CreatedAt).TotalMinutes);
                            responseTimeMinutes = (int)Math.Round(avgMinutes, 0);
                        }
                    }

                    var liveFollowerCount = db.CfShopFollows.AsNoTracking()
                        .Count(f => f.ShopId == shop.Id && f.Status);
                    followerCount = liveFollowerCount;

                    var shouldUpdate = false;
                    if (shop.FollowerCount != followerCount)
                    {
                        shop.FollowerCount = followerCount;
                        shouldUpdate = true;
                    }

                    if (responseRate.HasValue && shop.ResponseRate != responseRate)
                    {
                        shop.ResponseRate = responseRate;
                        shouldUpdate = true;
                    }

                    if (responseTimeMinutes.HasValue && shop.ResponseTimeMinutes != responseTimeMinutes)
                    {
                        shop.ResponseTimeMinutes = responseTimeMinutes;
                        shouldUpdate = true;
                    }

                    if (shouldUpdate)
                    {
                        db.SaveChanges();
                    }

                }

            }
            CurrentShopId = product.ShopId.HasValue ? product.ShopId.Value : 0;

            CuaHangLink.Text = string.IsNullOrWhiteSpace(shopName) ? "\u0043\u1eeda h\u00e0ng" : shopName;

            CuaHangLink.NavigateUrl = string.IsNullOrWhiteSpace(shopCode) ? "#" : "/cua-hang/" + shopCode;
            ShopUrl = CuaHangLink.NavigateUrl;
            var shopIdValue = product.ShopId.HasValue ? product.ShopId.Value : 0;
            ChatShopUrl = shopIdValue > 0
                ? "/chat-shop/default.aspx?shopId=" + shopIdValue
                : "#";
            if (string.IsNullOrWhiteSpace(ShopLogoUrl))
            {
                ShopLogoUrl = "/images/fav.png";
            }

            CuaHangViewLink.Text = "\u0058em c\u1eeda h\u00e0ng";

            CuaHangViewLink.NavigateUrl = CuaHangLink.NavigateUrl;

            BrandDetailLiteral.Text = string.IsNullOrWhiteSpace(brandName) ? "-" : brandName;
            OriginDetailLiteral.Text = string.IsNullOrWhiteSpace(originName) ? "-" : originName;
            ShipFromLiteral.Text = string.IsNullOrWhiteSpace(shopProvince) ? "-" : shopProvince;
            ShopNameLiteral.Text = string.IsNullOrWhiteSpace(shopName) ? "\u0043\u1eeda h\u00e0ng" : shopName;
            ShopProvinceLiteral.Text = string.IsNullOrWhiteSpace(shopProvince) ? "-" : shopProvince;
            if (ShopRatingWrap != null)
            {
                ShopRatingWrap.Visible = shopRatingAvg > 0;
            }
            ShopRatingLiteral.Text = shopRatingAvg > 0 ? shopRatingAvg.ToString("0.0") : string.Empty;
            ShopRatingCountLiteral.Text = FormatCompactNumber(shopRatingCount);
            ShopProductCountLiteral.Text = FormatCompactNumber(productCount);
            ShopResponseRateLiteral.Text = responseRate.HasValue ? string.Format("{0:0.#}%", responseRate.Value) : "-";
            ShopResponseTimeLiteral.Text = responseTimeMinutes.HasValue ? FormatResponseTime(responseTimeMinutes.Value) : "-";
            ShopJoinedLiteral.Text = shopCreatedAt.HasValue ? FormatJoined(shopCreatedAt.Value) : "-";
            ShopFollowerCountLiteral.Text = FormatCompactNumber(followerCount);

            NhaCungCapLink.Visible = false;
            XuatXuLink.Visible = false;

            MoTa.Text = string.IsNullOrWhiteSpace(product.Description) ? "\u0110ang c\u1eadp nh\u1eadt." : product.Description;

            Specification.Text = string.IsNullOrWhiteSpace(product.Specification) ? "\u0110ang c\u1eadp nh\u1eadt." : product.Specification;

            //Ingredients.Text = string.IsNullOrWhiteSpace(product.Ingredients) ? "\u0110ang c\u1eadp nh\u1eadt." : product.Ingredients;

            //Usage.Text = string.IsNullOrWhiteSpace(product.Usage) ? "\u0110ang c\u1eadp nh\u1eadt." : product.Usage;

            var variants = db.CfProductVariants.AsNoTracking()

                .Where(v => v.ProductId == product.Id && v.Status)

                .OrderBy(v => v.SortOrder)

                .ThenBy(v => v.Price)

                .ToList();

            BindVariantAttributes(db, variants);

            var images = db.CfProductImages.AsNoTracking()

                .Where(i => i.ProductId == product.Id && i.Status)

                .OrderByDescending(i => i.IsPrimary)

                .ThenBy(i => i.SortOrder)

                .ThenByDescending(i => i.Id)

                .ToList();

            MainImageUrl = images.FirstOrDefault() != null ? images.FirstOrDefault().ImageUrl : "/images/fav.png";

            var imageList = images.Select(i => new { i.ImageUrl, AltText = string.IsNullOrWhiteSpace(i.AltText) ? product.ProductName : i.AltText }).ToList();

            ImageRepeater.DataSource = imageList;

            ImageRepeater.DataBind();

            ThumbRepeater.DataSource = imageList;

            ThumbRepeater.DataBind();

            BindSeoMeta(product, slug, variants, BrandName);

            PriceLiteral.Text = variants.Any() ? GetDisplayPriceHtml(variants) : "\u004c\u0069\u00ean h\u1ec7";

            var defaultVariant = GetDefaultVariant(variants);

            SkuLiteral.Text = defaultVariant != null && !string.IsNullOrWhiteSpace(defaultVariant.Sku) ? defaultVariant.Sku : "-";

            if (defaultVariant != null)

            {

                SelectedVariantId.Value = defaultVariant.Id.ToString();

            }

            SetStockStatus(defaultVariant);

            CategoryPath.Text = BuildCategoryPath(allCategories, product.CategoryId, slugLookup);

            BindRelatedProducts(db, product, slugLookup);

            BindSuggestedProducts(db, product.Id, slugLookup);

            BindWishlistButton(db, product.Id);
            BindFollowButton(db);
            BindShopReviewForm(db);
            BindProductReviewForm(db);

        }

    }

    private void BindShopReviewForm(BeautyStoryContext db)
    {
        if (ShopReviewContentTextBox == null || ShopReviewRatingHidden == null || ShopReviewModalState == null)
        {
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue || CurrentShopId <= 0)
        {
            return;
        }

        var review = db.CfShopReviews.AsNoTracking()
            .FirstOrDefault(r => r.ShopId == CurrentShopId && r.CustomerId == customerId.Value && r.Status);
        if (review != null)
        {
            ShopReviewContentTextBox.Text = review.Content ?? string.Empty;
            ShopReviewRatingHidden.Value = review.Rating.ToString();
        }
    }

    private void BindProductReviewForm(BeautyStoryContext db)
    {
        if (ProductReviewContentTextBox == null || ProductReviewRatingHidden == null || ProductReviewModalState == null)
        {
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue || CurrentProductId <= 0)
        {
            return;
        }

        var review = db.CfProductReviews.AsNoTracking()
            .FirstOrDefault(r => r.ProductId == CurrentProductId && r.CustomerId == customerId.Value && r.Status);
        if (review != null)
        {
            ProductReviewContentTextBox.Text = review.Content ?? string.Empty;
            ProductReviewRatingHidden.Value = review.Rating.ToString();
        }
    }

    private void BindFollowButton(BeautyStoryContext db)
    {
        if (FollowShopButton == null)
        {
            return;
        }

        var shopId = CurrentShopId;
        if (shopId <= 0)
        {
            FollowShopButton.Visible = false;
            return;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            FollowShopTextLiteral.Text = "\u0054heo d\u00f5i";
            return;
        }

        var exists = db.CfShopFollows.Any(f => f.ShopId == shopId && f.CustomerId == customerId.Value && f.Status);
        FollowShopTextLiteral.Text = exists ? "\u0110\u00e3 theo d\u00f5i" : "\u0054heo d\u00f5i";
    }

    protected void FollowShopButton_Click(object sender, EventArgs e)
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        var shopId = CurrentShopId;
        if (shopId <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var existing = db.CfShopFollows.FirstOrDefault(f => f.ShopId == shopId && f.CustomerId == customerId.Value);
            if (existing != null)
            {
                existing.Status = !existing.Status;
                existing.UpdatedAt = DateTime.UtcNow;
            }
            else
            {
                db.CfShopFollows.Add(new CfShopFollow
                {
                    ShopId = shopId,
                    CustomerId = customerId.Value,
                    Status = true,
                    CreatedAt = DateTime.UtcNow
                });
            }

            var followerCount = db.CfShopFollows.Count(f => f.ShopId == shopId && f.Status);
            var shop = db.CfShops.FirstOrDefault(s => s.Id == shopId);
            if (shop != null)
            {
                shop.FollowerCount = followerCount;
            }

            db.SaveChanges();
        }

        Response.Redirect(Request.RawUrl);
    }

    protected void SubmitShopReviewButton_Click(object sender, EventArgs e)
    {
        if (ShopReviewErrorLiteral != null)
        {
            ShopReviewErrorLiteral.Text = string.Empty;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        var shopId = CurrentShopId;
        if (shopId <= 0)
        {
            return;
        }

        var ratingValue = 0;
        if (ShopReviewRatingHidden != null)
        {
            int.TryParse(ShopReviewRatingHidden.Value, out ratingValue);
        }

        if (ratingValue < 1 || ratingValue > 5)
        {
            ShowShopReviewError("\u0056ui l\u00f2ng ch\u1ecdn s\u1ed1 sao.");
            return;
        }

        var content = ShopReviewContentTextBox != null ? (ShopReviewContentTextBox.Text ?? string.Empty).Trim() : string.Empty;
        if (content.Length > 1000)
        {
            content = content.Substring(0, 1000);
        }

        using (var db = new BeautyStoryContext())
        {
            var review = db.CfShopReviews.FirstOrDefault(r => r.ShopId == shopId && r.CustomerId == customerId.Value);
            if (review == null)
            {
                review = new CfShopReview
                {
                    ShopId = shopId,
                    CustomerId = customerId.Value,
                    Rating = ratingValue,
                    Content = content,
                    IsVerified = false,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "customer:" + customerId.Value
                };
                db.CfShopReviews.Add(review);
            }
            else
            {
                review.Rating = ratingValue;
                review.Content = content;
                review.UpdatedAt = DateTime.Now;
                review.UpdatedBy = "customer:" + customerId.Value;
            }

            var reviews = db.CfShopReviews
                .Where(r => r.ShopId == shopId && r.Status)
                .ToList();

            var shop = db.CfShops.FirstOrDefault(s => s.Id == shopId);
            if (shop != null)
            {
                shop.RatingCount = reviews.Count;
                shop.RatingAvg = reviews.Count > 0 ? (decimal)reviews.Average(r => r.Rating) : 0m;
            }

            db.SaveChanges();
        }

        if (ShopReviewModalState != null)
        {
            ShopReviewModalState.Value = string.Empty;
        }

        Response.Redirect(Request.RawUrl);
    }

    protected void SubmitProductReviewButton_Click(object sender, EventArgs e)
    {
        if (ProductReviewErrorLiteral != null)
        {
            ProductReviewErrorLiteral.Text = string.Empty;
        }

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        var productId = CurrentProductId;
        if (productId <= 0)
        {
            return;
        }

        var ratingValue = 0;
        if (ProductReviewRatingHidden != null)
        {
            int.TryParse(ProductReviewRatingHidden.Value, out ratingValue);
        }

        if (ratingValue < 1 || ratingValue > 5)
        {
            ShowProductReviewError("Vui lòng chọn số sao.");
            return;
        }

        var content = ProductReviewContentTextBox != null ? (ProductReviewContentTextBox.Text ?? string.Empty).Trim() : string.Empty;
        if (string.IsNullOrWhiteSpace(content))
        {
            ShowProductReviewError("Vui lòng nhập nội dung đánh giá.");
            return;
        }
        if (content.Length > 1000)
        {
            content = content.Substring(0, 1000);
        }

        using (var db = new BeautyStoryContext())
        {
            var review = db.CfProductReviews.FirstOrDefault(r => r.ProductId == productId && r.CustomerId == customerId.Value);
            if (review == null)
            {
                review = new CfProductReview
                {
                    ProductId = productId,
                    CustomerId = customerId.Value,
                    Rating = ratingValue,
                    Content = content,
                    IsVerified = false,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "customer:" + customerId.Value
                };
                db.CfProductReviews.Add(review);
            }
            else
            {
                review.Rating = ratingValue;
                review.Content = content;
                review.UpdatedAt = DateTime.Now;
                review.UpdatedBy = "customer:" + customerId.Value;
            }

            db.SaveChanges();
        }

        if (ProductReviewModalState != null)
        {
            ProductReviewModalState.Value = string.Empty;
        }

        Response.Redirect(Request.RawUrl);
    }

    private void ShowShopReviewError(string message)
    {
        if (ShopReviewErrorLiteral != null)
        {
            ShopReviewErrorLiteral.Text = "<div class=\"alert alert-danger\">" + HttpUtility.HtmlEncode(message) + "</div>";
        }

        if (ShopReviewModalState != null)
        {
            ShopReviewModalState.Value = "open";
        }
    }

    private void ShowProductReviewError(string message)
    {
        if (ProductReviewErrorLiteral != null)
        {
            ProductReviewErrorLiteral.Text = "<div class=\"alert alert-danger\">" + HttpUtility.HtmlEncode(message) + "</div>";
        }

        if (ProductReviewModalState != null)
        {
            ProductReviewModalState.Value = "open";
        }
    }

    protected void DeleteProductReviewButton_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        int reviewId;
        if (!int.TryParse(e.CommandArgument.ToString(), out reviewId) || reviewId <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var review = db.CfProductReviews.FirstOrDefault(r => r.Id == reviewId && r.CustomerId == customerId.Value);
            if (review == null || review.IsVerified)
            {
                return;
            }

            review.Status = false;
            review.UpdatedAt = DateTime.Now;
            review.UpdatedBy = "customer:" + customerId.Value;
            db.SaveChanges();
        }

        Response.Redirect(Request.RawUrl);
    }

    private void BindWishlistButton(BeautyStoryContext db, int productId)

    {

        if (WishlistButton == null)

        {

            return;

        }

        var customerId = CustomerAuth.GetCustomerId();

        if (!customerId.HasValue)

        {

            WishlistButton.ToolTip = "Yêu thích";

            return;

        }

        var exists = db.CfWishlists.Any(w => w.CustomerId == customerId.Value && w.ProductId == productId);

        WishlistButton.ToolTip = exists ? "Bỏ yêu thích" : "Yêu thích";

    }

    private void BindRelatedProducts(BeautyStoryContext db, CfProduct product, Dictionary<string, Dictionary<int, string>> slugLookup)

    {

        var relatedCategory = db.CfProducts.AsNoTracking()

            .Where(p => p.Status
                && p.Id != product.Id
                && p.CategoryId == product.CategoryId
                && (!product.ShopId.HasValue || p.ShopId == product.ShopId.Value))

            .OrderBy(p => p.SortOrder)

            .ThenBy(p => p.Id)

            .Take(5)

            .ToList();

        var relatedBrand = new List<CfProduct>();

        if (product.BrandId.HasValue && product.BrandId.Value > 0)

        {

            relatedBrand = db.CfProducts.AsNoTracking()

                .Where(p => p.Status
                    && p.Id != product.Id
                    && p.BrandId == product.BrandId.Value
                    && (!product.ShopId.HasValue || p.ShopId == product.ShopId.Value))

                .OrderBy(p => p.SortOrder)

                .ThenBy(p => p.Id)

                .Take(5)

                .ToList();

        }

        RelatedRepeater.DataSource = BuildRelatedViewModels(db, relatedCategory, slugLookup);

        RelatedRepeater.DataBind();

        BrandRelatedRepeater.DataSource = BuildRelatedViewModels(db, relatedBrand, slugLookup);

        BrandRelatedRepeater.DataBind();

    }

    private List<RelatedProductItem> BuildRelatedViewModels(BeautyStoryContext db, List<CfProduct> products, Dictionary<string, Dictionary<int, string>> slugLookup)

    {

        if (products == null || products.Count == 0)

        {

            return new List<RelatedProductItem>();

        }

        var productIds = products.Select(p => p.Id).ToList();

        var images = db.CfProductImages.AsNoTracking()

            .Where(i => i.Status && productIds.Contains(i.ProductId))

            .OrderByDescending(i => i.IsPrimary)

            .ThenBy(i => i.SortOrder)

            .ThenByDescending(i => i.Id)

            .ToList();

        var imageLookup = new Dictionary<int, string>();

        foreach (var group in images.GroupBy(i => i.ProductId))

        {

            var first = group.FirstOrDefault();

            if (first != null && !string.IsNullOrWhiteSpace(first.ImageUrl))

            {

                imageLookup[group.Key] = first.ImageUrl;

            }

        }

        var variants = db.CfProductVariants.AsNoTracking()

            .Where(v => v.Status && productIds.Contains(v.ProductId))

            .OrderBy(v => v.SortOrder)

            .ThenBy(v => v.Price)

            .ToList();

        var variantLookup = new Dictionary<int, List<CfProductVariant>>();

        foreach (var group in variants.GroupBy(v => v.ProductId))

        {

            variantLookup[group.Key] = group.ToList();

        }

        var items = new List<RelatedProductItem>();

        foreach (var product in products)

        {

            var slug = GetSlug(slugLookup, "Product", product.Id);

            var url = string.IsNullOrWhiteSpace(slug) ? "#" : string.Format("/san-pham/{0}", slug);

            var imageUrl = imageLookup.ContainsKey(product.Id) ? imageLookup[product.Id] : "/images/fav.png";

            var variantList = variantLookup.ContainsKey(product.Id) ? variantLookup[product.Id] : new List<CfProductVariant>();

            var priceHtml = variantList.Any() ? GetDisplayPriceHtml(variantList) : "Liên hệ";

            var saleBadge = BuildSaleBadgeHtml(variantList);

            items.Add(new RelatedProductItem

            {

                ProductName = product.ProductName,

                Url = url,

                ImageUrl = imageUrl,

                PriceHtml = priceHtml,

                SaleBadge = saleBadge

            });

        }

        return items;

    }

    private void BindSuggestedProducts(BeautyStoryContext db, int productId, Dictionary<string, Dictionary<int, string>> slugLookup)

    {

        var shopId = CurrentShopId;

        var suggested = db.CfProducts.AsNoTracking()

            .Where(p => p.Status
                && p.Id != productId
                && (shopId <= 0 || p.ShopId == shopId))

            .OrderBy(p => p.SortOrder)

            .ThenBy(p => p.Id)

            .Take(15)

            .ToList();

        SuggestedRepeater.DataSource = BuildRelatedViewModels(db, suggested, slugLookup);

        SuggestedRepeater.DataBind();

    }

    private static string BuildSaleBadgeHtml(List<CfProductVariant> variants)

    {

        if (variants == null || variants.Count == 0)

        {

            return string.Empty;

        }

        var saleVariant = variants

            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)

            .OrderByDescending(v => (v.Price - v.SalePrice.Value) / v.Price)

            .FirstOrDefault();

        if (saleVariant == null)

        {

            return string.Empty;

        }

        var percent = (int)Math.Round((saleVariant.Price - saleVariant.SalePrice.Value) / saleVariant.Price * 100m, 0);

        if (percent <= 0)

        {

            return string.Empty;

        }

        return string.Format("<span class=\"sale-badge\">-{0}%</span>", percent);

    }

    public class RelatedProductItem

    {

        public string ProductName { get; set; }

        public string ImageUrl { get; set; }

        public string Url { get; set; }

        public string PriceHtml { get; set; }

        public string SaleBadge { get; set; }

    }

    private class ProductReviewItem
    {
        public int Id { get; set; }
        public string CustomerName { get; set; }
        public int Rating { get; set; }
        public string Content { get; set; }
        public string CreatedAt { get; set; }
        public string RatingStars { get; set; }
        public bool CanDelete { get; set; }
        public bool ShowStatus { get; set; }
        public string StatusText { get; set; }
    }

    private static string BuildRatingStars(int rating)
    {
        if (rating < 1)
        {
            return string.Empty;
        }
        if (rating > 5)
        {
            rating = 5;
        }
        return new string('★', rating);
    }

    private void BindSeoMeta(CfProduct product, string slug, List<CfProductVariant> variants, string brandName)

    {

        string title = !string.IsNullOrWhiteSpace(product.SeoTitle) ? product.SeoTitle : product.ProductName;

        string description = !string.IsNullOrWhiteSpace(product.SeoDescription)

            ? product.SeoDescription

            : BuildFallbackMoTa(product);

        string keywords = product.SeoKeywords ?? string.Empty;

        string canonical = !string.IsNullOrWhiteSpace(product.CanonicalUrl)

            ? product.CanonicalUrl

            : string.Format("/san-pham/{0}", string.IsNullOrWhiteSpace(ProductSeoSlug) ? slug : ProductSeoSlug);

        string robots = !string.IsNullOrWhiteSpace(product.Robots) ? product.Robots : "index,follow";

        string ogTitle = !string.IsNullOrWhiteSpace(product.OgTitle) ? product.OgTitle : title;

        string ogMoTa = !string.IsNullOrWhiteSpace(product.OgDescription) ? product.OgDescription : description;

        string ogImage = !string.IsNullOrWhiteSpace(product.OgImage) ? product.OgImage : MainImageUrl;

        string ogType = !string.IsNullOrWhiteSpace(product.OgType) ? product.OgType : "product";

        string twitterTitle = !string.IsNullOrWhiteSpace(product.TwitterTitle) ? product.TwitterTitle : title;

        string twitterMoTa = !string.IsNullOrWhiteSpace(product.TwitterDescription) ? product.TwitterDescription : description;

        string twitterImage = !string.IsNullOrWhiteSpace(product.TwitterImage) ? product.TwitterImage : ogImage;

        SeoTitleLiteral.Text = (title) + " | LoveIs Store";//HttpUtility.HtmlEncode(title) + " | LoveIs Store";

        SeoMetaLiteral.Text = string.Format(

            "<meta name=\"description\" content=\"{0}\" />\n<meta name=\"keywords\" content=\"{1}\" />\n<meta name=\"robots\" content=\"{2}\" />\n<link rel=\"canonical\" href=\"{3}\" />\n",

            HttpUtility.HtmlAttributeEncode(description),

            HttpUtility.HtmlAttributeEncode(keywords),

            HttpUtility.HtmlAttributeEncode(robots),

            HttpUtility.HtmlAttributeEncode(canonical));

        SocialMetaLiteral.Text = string.Format(

            "<meta property=\"og:title\" content=\"{0}\" />\n<meta property=\"og:description\" content=\"{1}\" />\n<meta property=\"og:image\" content=\"{2}\" />\n<meta property=\"og:type\" content=\"{3}\" />\n<meta property=\"og:url\" content=\"{4}\" />\n<meta name=\"twitter:card\" content=\"summary_large_image\" />\n<meta name=\"twitter:title\" content=\"{5}\" />\n<meta name=\"twitter:description\" content=\"{6}\" />\n<meta name=\"twitter:image\" content=\"{7}\" />\n",

            HttpUtility.HtmlAttributeEncode(ogTitle),

            HttpUtility.HtmlAttributeEncode(ogMoTa),

            HttpUtility.HtmlAttributeEncode(ogImage),

            HttpUtility.HtmlAttributeEncode(ogType),

            HttpUtility.HtmlAttributeEncode(canonical),

            HttpUtility.HtmlAttributeEncode(twitterTitle),

            HttpUtility.HtmlAttributeEncode(twitterMoTa),

            HttpUtility.HtmlAttributeEncode(twitterImage));

        SchemaLiteral.Text = BuildProductSchema(product, canonical, ogImage, variants, brandName);

    }

    private string BuildProductSchema(CfProduct product, string canonical, string imageUrl, List<CfProductVariant> variants, string brandName)

    {

        var offerVariant = GetDefaultVariant(variants) ?? variants.FirstOrDefault();

        decimal? price = null;

        if (offerVariant != null)

        {

            price = offerVariant.SalePrice.HasValue && offerVariant.SalePrice.Value > 0 && offerVariant.SalePrice.Value < offerVariant.Price

                ? offerVariant.SalePrice.Value

                : offerVariant.Price;

        }

        var schema = new

        {

            @context = "https://schema.org",

            @type = "Product",

            name = product.ProductName,

            image = string.IsNullOrWhiteSpace(imageUrl) ? null : imageUrl,

            description = BuildFallbackMoTa(product),

            sku = offerVariant != null ? offerVariant.Sku : string.Empty,

            brand = new

            {

                @type = "Brand",

                name = brandName ?? string.Empty

            },

            offers = new

            {

                @type = "Offer",

                url = canonical,

                priceCurrency = "VND",

                price = price.HasValue ? price.Value.ToString("0.##") : string.Empty,

                availability = price.HasValue ? "https://schema.org/InStock" : "https://schema.org/OutOfStock"

            }

        };

        var json = new JavaScriptSerializer().Serialize(schema);

        return "<script type=\"application/ld+json\">" + json + "</script>";

    }

    private static string BuildFallbackMoTa(CfProduct product)

    {

        string source = !string.IsNullOrWhiteSpace(product.ShortDescription)

            ? product.ShortDescription

            : product.Description;

        if (string.IsNullOrWhiteSpace(source))

        {

            return product.ProductName ?? string.Empty;

        }

        string plain = Regex.Replace(source, "<.*?>", string.Empty);

        plain = HttpUtility.HtmlDecode(plain);

        return plain.Length > 200 ? plain.Substring(0, 200) : plain;

    }

    public string GetMenuItemActiveClass(int index)

    {

        return index == 0 ? "active" : string.Empty;

    }

    public string GetPanelActiveClass(int index)

    {

        return index == 0 ? "active" : string.Empty;

    }

    private static string GetSlug(Dictionary<string, Dictionary<int, string>> lookup, string entityType, int entityId)

    {

        if (!lookup.ContainsKey(entityType))

        {

            return string.Empty;

        }

        var entityLookup = lookup[entityType];

        return entityLookup.ContainsKey(entityId) ? entityLookup[entityId] : string.Empty;

    }

    private static int ResolveProductId(Dictionary<string, Dictionary<int, string>> lookup, string slug)

    {

        if (!lookup.ContainsKey("Product"))

        {

            return 0;

        }

        var match = lookup["Product"].FirstOrDefault(kv => string.Equals(kv.Value, slug, StringComparison.OrdinalIgnoreCase));

        return match.Key;

    }

    private static string BuildCategoryPath(List<CfCategory> categories, int categoryId, Dictionary<string, Dictionary<int, string>> slugLookup)

    {

        var path = new List<CfCategory>();

        var lookup = categories.ToDictionary(c => c.Id, c => c);

        int currentId = categoryId;

        while (lookup.ContainsKey(currentId))

        {

            var current = lookup[currentId];

            path.Add(current);

            if (!current.ParentId.HasValue)

            {

                break;

            }

            currentId = current.ParentId.Value;

        }

        path.Reverse();

        var links = path.Select(c =>

        {

            string slug = GetSlug(slugLookup, "Category", c.Id);

            return string.Format("<a href=\"/danh-muc/{0}\">{1}</a>", slug, c.CategoryName);

        });

        var homeLink = "<a href=\"/\">Trang chủ</a>";

        return homeLink + " <span class=\"sep\">/</span> " + string.Join(" <span class=\"sep\">/</span> ", links);

    }

    private static string FormatPrice(CfProductVariant variant)

    {

        if (variant == null)

        {

            return "Liên hệ";

        }

        var price = variant.SalePrice.HasValue ? variant.SalePrice.Value : variant.Price;

        return string.Format("{0:N0} đ", price);

    }

    private static string FormatPriceHtml(CfProductVariant variant)

    {

        if (variant == null)

        {

            return "Liên hệ";

        }

        if (variant.SalePrice.HasValue && variant.SalePrice.Value > 0 && variant.SalePrice.Value < variant.Price)

        {

            return string.Format("<span class=\"price-old\">{0:N0} đ</span> <span class=\"price-current\">{1:N0} đ</span>", variant.Price, variant.SalePrice.Value);

        }

        return string.Format("<span class=\"price-current\">{0:N0} đ</span>", variant.Price);

    }

    private static string GetDisplayPrice(List<CfProductVariant> variants)

    {

        if (variants == null || variants.Count == 0)

        {

            return "Liên hệ";

        }

        var saleVariant = variants

            .Where(v => v.SalePrice.HasValue)

            .OrderBy(v => v.SalePrice.Value)

            .FirstOrDefault();

        var variant = saleVariant ?? variants.OrderBy(v => v.Price).First();

        return FormatPrice(variant);

    }

    private static string GetDisplayPriceHtml(List<CfProductVariant> variants)

    {

        if (variants == null || variants.Count == 0)

        {

            return "Liên hệ";

        }

        var saleVariant = variants

            .Where(v => v.SalePrice.HasValue)

            .OrderBy(v => v.SalePrice.Value)

            .FirstOrDefault();

        var variant = saleVariant ?? variants.OrderBy(v => v.Price).First();

        return FormatPriceHtml(variant);

    }

    private void BindVariantAttributes(BeautyStoryContext db, List<int> variantIds, Dictionary<int, int> defaultSelections)

    {

        var attrs = db.CfProductVariantAttributes

            .Where(pva => variantIds.Contains(pva.VariantId))

            .Select(pva => new

            {

                pva.VariantId,

                pva.AttributeId,

                pva.Attribute.AttributeName,

                pva.AttributeValueId,

                pva.AttributeValue.ValueName

            })

            .ToList();

        var groups = attrs

            .GroupBy(a => new { a.AttributeId, a.AttributeName })

            .Select(g => new

            {

                AttributeName = g.Key.AttributeName,

                Values = g

                    .GroupBy(x => new { x.AttributeValueId, x.ValueName })

                    .Select(x => new

                    {

                        AttributeId = g.Key.AttributeId,

                        ValueId = x.Key.AttributeValueId,

                        ValueName = x.Key.ValueName

                    })

                    .OrderBy(x => x.ValueName)

                    .Select((x, index) => new

                    {

                        x.AttributeId,

                        x.ValueId,

                        x.ValueName,

                        ActiveClass = defaultSelections != null && defaultSelections.ContainsKey(x.AttributeId)

                            ? (defaultSelections[x.AttributeId] == x.ValueId ? "active" : string.Empty)

                            : (index == 0 ? "active" : string.Empty)

                    })

                    .ToList()

            })

            .OrderBy(g => g.AttributeName)

            .ToList();

        VariantAttributeRepeater.DataSource = groups;

        VariantAttributeRepeater.DataBind();

        var variantPriceMap = new Dictionary<string, string>();

        var variantIdMap = new Dictionary<string, int>();

        var variantSkuMap = new Dictionary<string, string>();
        var variantStockMap = new Dictionary<string, int>();

        foreach (var variantId in attrs.Select(a => a.VariantId).Distinct())

        {

            var parts = attrs

                .Where(a => a.VariantId == variantId)

                .Select(a => new { a.AttributeId, a.AttributeValueId })

                .OrderBy(a => a.AttributeId)

                .Select(a => string.Format("{0}:{1}", a.AttributeId, a.AttributeValueId));

            var key = string.Join("|", parts);

            if (!variantPriceMap.ContainsKey(key))

            {

                var variant = db.CfProductVariants.AsNoTracking().FirstOrDefault(v => v.Id == variantId);

                if (variant != null)

                {

                    variantPriceMap[key] = FormatPriceHtml(variant);

                    variantIdMap[key] = variant.Id;

                    variantSkuMap[key] = string.IsNullOrWhiteSpace(variant.Sku) ? "-" : variant.Sku;
                    variantStockMap[key] = Math.Max(0, variant.StockQty);

                }

            }

        }

        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();

        VariantPriceJson = serializer.Serialize(variantPriceMap);

        VariantIdJson = serializer.Serialize(variantIdMap);

        VariantSkuJson = serializer.Serialize(variantSkuMap);

        VariantStockJson = serializer.Serialize(variantStockMap);

    }

    protected void AddToCartButton_Click(object sender, EventArgs e)

    {

        int variantId = 0;

        if (!string.IsNullOrWhiteSpace(SelectedVariantId.Value))

        {

            int.TryParse(SelectedVariantId.Value, out variantId);

        }

        int quantity = 1;

        if (!string.IsNullOrWhiteSpace(SelectedQuantity.Value))

        {

            int.TryParse(SelectedQuantity.Value, out quantity);

        }

        if (quantity < 1)

        {

            quantity = 1;

        }

        if (quantity > 99)

        {

            quantity = 99;

        }

        if (variantId > 0)

        {

            var added = CartService.AddVariantWithResult(variantId, quantity);

            if (added > 0)

            {

                Response.Redirect("/gio-hang");

                return;

            }

            SetAddToCartMessage(variantId, quantity);

        }

    }

    protected void WishlistButton_Click(object sender, EventArgs e)

    {

        var customerId = CustomerAuth.GetCustomerId();

        if (!customerId.HasValue)

        {

            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/";

            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));

            return;

        }

        if (CurrentProductId <= 0)

        {

            return;

        }

        using (var db = new BeautyStoryContext())

        {

            var existing = db.CfWishlists.FirstOrDefault(w => w.CustomerId == customerId.Value && w.ProductId == CurrentProductId);

            if (existing != null)

            {

                db.CfWishlists.Remove(existing);

            }

            else

            {

                db.CfWishlists.Add(new CfWishlist

                {

                    CustomerId = customerId.Value,

                    ProductId = CurrentProductId,

                    Status = true,

                    CreatedAt = DateTime.UtcNow

                });

            }

            db.SaveChanges();

        }

        Response.Redirect(Request.RawUrl);

    }

    private void BindVariantAttributes(BeautyStoryContext db, List<CfProductVariant> variants)

    {

        var ids = variants.Select(v => v.Id).ToList();

        var defaultSelections = new Dictionary<int, int>();

        var defaultVariant = GetDefaultVariant(variants);

        if (defaultVariant != null)

        {

            defaultSelections = db.CfProductVariantAttributes

                .Where(pva => pva.VariantId == defaultVariant.Id)

                .GroupBy(pva => pva.AttributeId)

                .Select(g => g.FirstOrDefault())

                .Where(pva => pva != null)

                .ToDictionary(pva => pva.AttributeId, pva => pva.AttributeValueId);

        }

        BindVariantAttributes(db, ids, defaultSelections);

    }

    private static CfProductVariant GetDefaultVariant(List<CfProductVariant> variants)

    {

        if (variants == null || variants.Count == 0)

        {

            return null;

        }

        var saleVariant = variants

            .Where(v => v.SalePrice.HasValue)

            .OrderBy(v => v.SalePrice.Value)

            .FirstOrDefault();

        return saleVariant ?? variants.OrderBy(v => v.Price).FirstOrDefault();

    }

    private void SetStockStatus(CfProductVariant variant)
    {
        if (StockStatusLiteral == null)
        {
            return;
        }

        if (variant == null)
        {
            StockStatusLiteral.Text = "Liên hệ";
            return;
        }

        var stockQty = Math.Max(0, variant.StockQty);
        StockStatusLiteral.Text = stockQty > 0
            ? string.Format("Còn {0} sản phẩm", stockQty)
            : "Hết hàng";
    }

    private void SetAddToCartMessage(int variantId, int quantity)
    {
        if (AddToCartMessageLiteral == null)
        {
            return;
        }

        string message = "Không thể thêm vào giỏ hàng.";
        using (var db = new BeautyStoryContext())
        {
            var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == variantId);
            if (variant == null || !variant.Status)
            {
                message = "Biến thể không khả dụng.";
            }
            else
            {
                var stockQty = Math.Max(0, variant.StockQty);
                if (stockQty <= 0)
                {
                    message = "Sản phẩm đã hết hàng.";
                }
                else if (quantity > stockQty)
                {
                    message = string.Format("Số lượng vượt tồn kho. Còn {0} sản phẩm.", stockQty);
                }
            }
        }

        AddToCartMessageLiteral.Text = message;
    }

    public class CategoryMenuItem

    {

        public int Id { get; set; }

        public string CategoryName { get; set; }

        public string SeoSlug { get; set; }

        public List<CategoryMenuItem> Children { get; set; }

    }

    private string GetSlugFromRequest()

    {

        var routeSlug = Page.RouteData.Values["slug"] as string;

        if (!string.IsNullOrWhiteSpace(routeSlug))

        {

            return routeSlug.Trim();

        }

        return (Request.QueryString["slug"] ?? string.Empty).Trim();

    }

    private static string FormatCompactNumber(int value)
    {
        if (value >= 1000000)
        {
            return string.Format("{0:0.#}tr", value / 1000000m);
        }

        if (value >= 1000)
        {
            return string.Format("{0:0.#}k", value / 1000m);
        }

        return value.ToString("0");
    }

    private static string FormatResponseTime(int minutes)
    {
        if (minutes <= 0)
        {
            return "-";
        }

        if (minutes < 60)
        {
            return string.Format("{0} \u0070h\u00fat", minutes);
        }

        if (minutes < 1440)
        {
            var hours = (int)Math.Round(minutes / 60m, 0);
            return string.Format("{0} \u0067i\u1edd", hours);
        }

        var days = (int)Math.Round(minutes / 1440m, 0);
        return string.Format("{0} \u006egn\u00e0y", days);
    }

    private static string FormatJoined(DateTime createdAt)
    {
        var span = DateTime.Now - createdAt;
        if (span.TotalDays >= 365)
        {
            var years = (int)Math.Floor(span.TotalDays / 365);
            return string.Format("{0} \u006e\u0103m \u0074\u0072\u01b0\u1edbc", years);
        }

        if (span.TotalDays >= 30)
        {
            var months = (int)Math.Floor(span.TotalDays / 30);
            return string.Format("{0} \u0074\u0068\u00e1\u006e\u0067 \u0074\u0072\u01b0\u1edbc", months);
        }

        var days = Math.Max(1, (int)Math.Floor(span.TotalDays));
        return string.Format("{0} \u006e\u0067\u00e0\u0079 \u0074\u0072\u01b0\u1edbc", days);
    }


}

