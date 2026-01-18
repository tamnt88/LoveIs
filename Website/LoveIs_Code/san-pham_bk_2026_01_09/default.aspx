<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ProductDefault" MasterPageFile="~/public/Public.master" %>



<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">

    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>



<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <link href="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.css") %>" rel="stylesheet" />

    <link href="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.min.css") %>" rel="stylesheet" />

    <script src="<%= ResolveUrl("~/public/assets/js/product-detail.js") %>" defer></script>

    <asp:Literal ID="SeoMetaLiteral" runat="server" />

    <asp:Literal ID="SocialMetaLiteral" runat="server" />

    <asp:Literal ID="SchemaLiteral" runat="server" />

    <style>
        .btn-icon-only {
            background: transparent;
            border: none;
            box-shadow: none;
            color: #3a0517;
            padding: 0 12px;
            min-width: 44px;
            height: 44px;
        }

        .shop-summary-card {
        background: #fff;
        /* border: 1px solid #E8DCE1; */
        border-radius: 0;
        padding: 18px 20px;
        display: flex;
        align-items: flex-start;
        gap: 20px;
        box-shadow: 0 14px 30px rgba(34, 27, 20, 0.08);
    }

        .shop-summary-logo {
            width: 64px;
            height: 64px;
            border-radius: 0;
            background: #f7eef1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #3a0517;
            overflow: hidden;
        }

        .shop-summary-logo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .shop-summary-actions {
            display: flex;
            gap: 8px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .shop-summary-actions .btn {
            padding: 6px 12px;
            width: auto;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            font-size: 13px;
            line-height: 1;
            white-space: nowrap;
            border-radius: 0;
        }

        .shop-summary-meta {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            color: #7d5c66;
            font-size: 13px;
        }

        .shop-summary-location {
            color: #7d5c66;
            font-size: 13px;
        }

        .shop-summary-metrics {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 8px 16px;
            margin-left: auto;
            min-width: 300px;
        }

        .shop-metric {
            display: flex;
            justify-content: space-between;
            gap: 8px;
            font-size: 13px;
            padding: 6px 8px;
            background: #fcf7f9;
            border-radius: 0;
        }

        .shop-metric .label {
            color: #7d5c66;
        }

        .shop-metric .value {
            color: #1B1B1F;
            font-weight: 600;
        }

        .shop-summary-head {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .shop-rating-inline {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            color: #f4b400;
            font-size: 13px;
        }

        .shop-rating-inline span {
            color: #3a0517;
            font-weight: 600;
        }

        .shop-summary-actions {
            margin-top: 6px;
        }

        .shop-summary-title {
            font-size: 16px;
            font-weight: 600;
            margin: 0;
        }

        .shop-summary-location {
            margin-top: 2px;
        }

        .shop-review-modal .modal-header {
            border-bottom-color: #f1d6dc;
        }

        .shop-review-modal .modal-title {
            color: #3a0517;
            font-weight: 600;
        }

        .shop-review-modal .form-control {
            border: 1px solid #ead3d9;
            border-radius: 0;
        }

        .shop-review-stars button {
            border-color: #ead3d9;
            color: #f4b400;
            width: 40px;
            height: 40px;
            border-radius: 0;
            transition: background-color 120ms ease, border-color 120ms ease, color 120ms ease, transform 120ms ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
            line-height: 1;
            font-size: 18px;
        }

        .shop-review-stars button.btn-dark {
            background: #f4b400;
            border-color: #f4b400;
            color: #fff;
        }

        .shop-review-stars button:hover,
        .shop-review-stars button:focus {
            background: #fff6db;
            border-color: #f4b400;
            color: #f4b400;
            transform: translateY(-1px);
        }

        .variant-group {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px 12px;
        }

        .variant-label {
            min-width: 90px;
            margin-bottom: 0;
        }

        .variant-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .stock-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 0;
            background: #f7eef1;
            color: #7d5c66;
            font-size: 13px;
            font-weight: 600;
        }

        .stock-tag .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #c0392b;
        }
    </style>


</asp:Content>



<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <main class="container py-4 product-detail">

        <div class="product-breadcrumb">

            <asp:Literal ID="CategoryPath" runat="server" />

        </div>

        <div class="row g-4">

            <div class="col-lg-9">

                <div class="product-main-card">

                    <div class="row g-4">

                        <div class="col-lg-6">

                            <div class="product-gallery">

                                <div class="product-gallery-wrap">

                                    <div class="swiper product-gallery-thumbs">

                                        <div class="swiper-wrapper">

                                            <asp:Repeater ID="ThumbRepeater" runat="server">

                                                <ItemTemplate>

                                                    <div class="swiper-slide">

                                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>" />

                                                    </div>

                                                </ItemTemplate>

                                            </asp:Repeater>

                                        </div>

                                        <div class="swiper-button-prev"></div>

                                        <div class="swiper-button-next"></div>

                                    </div>

                                    <div class="swiper product-gallery-main">

                                        <div class="swiper-wrapper">

                                            <div class="swiper-slide">

                                                <img src="<%= MainImageUrl %>" alt="<%= ProductName %>" />

                                            </div>

                                            <asp:Repeater ID="ImageRepeater" runat="server">

                                                <ItemTemplate>

                                                    <div class="swiper-slide">

                                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>" />

                                                    </div>

                                                </ItemTemplate>

                                            </asp:Repeater>

                                        </div>

                                        <div class="swiper-button-prev"></div>

                                        <div class="swiper-button-next"></div>

                                    </div>

                                </div>

                            </div>

                        </div>

                        <div class="col-lg-6">

                            <div class="product-info">

                                <div class="supplier-tags" style="display:none;">
                                    <asp:HyperLink ID="CuaHangLink" runat="server" CssClass="supplier-pill shop-pill" />
                                    <asp:HyperLink ID="NhaCungCapLink" runat="server" Visible="false" />
                                    <asp:HyperLink ID="XuatXuLink" runat="server" Visible="false" />
                                </div>

                                <asp:HyperLink ID="CuaHangViewLink" Visible="false" runat="server" CssClass="shop-view-link" />

                                <h1 class="product-name"><asp:Literal ID="ProductNameLiteral" runat="server" /></h1>

                                <div class="product-meta">

                                    <span class="rating-badge">4.9&#9733;</span>

                                    <span>28 đánh giá</span>

                                    <span class="meta-sep">|</span>

                                    <span>SKU: <span id="SkuValue"><asp:Literal ID="SkuLiteral" runat="server" /></span></span>

                                </div>

                                <div class="product-price-detail">

                                    <span id="PriceValue"><asp:Literal ID="PriceLiteral" runat="server" /></span>

                                </div>

                                <div class="product-variants">

                                    <asp:Repeater ID="VariantAttributeRepeater" runat="server">

                                        <ItemTemplate>

                                            <div class="variant-group">

                                                <div class="variant-label"><%# Eval("AttributeName") %></div>

                                                <div class="variant-list">

                                                    <asp:Repeater ID="VariantValueRepeater" runat="server" DataSource='<%# Eval("Values") %>'>

                                                        <ItemTemplate>

                                                            <button type="button" class="variant-pill js-variant-value <%# Eval("ActiveClass") %>" data-attrid="<%# Eval("AttributeId") %>" data-valid="<%# Eval("ValueId") %>">

                                                                <%# Eval("ValueName") %>

                                                            </button>

                                                        </ItemTemplate>

                                                    </asp:Repeater>

                                                </div>

                                            </div>

                                        </ItemTemplate>

                                    </asp:Repeater>

                                </div>

                                <div class="product-actions">

                                    <div id="CartLimitWarning" class="small text-danger mb-2" style="display:none;"></div>
                                    <div class="small text-danger mb-2">
                                        <asp:Literal ID="AddToCartMessageLiteral" runat="server" />
                                    </div>

                                    <asp:HiddenField ID="CartLimitMaxItems" runat="server" />

                                    <asp:HiddenField ID="CartLimitMaxQty" runat="server" />

                                    <asp:HiddenField ID="CartLimitCartQty" runat="server" />

                                    <asp:HiddenField ID="CartLimitVariantQtyJson" runat="server" />



                                    <div class="qty-control">

                                        <span class="qty-label">S&#7889; l&#432;&#7907;ng:</span>

                                        <button type="button" class="qty-btn" data-action="minus">-</button>

                                        <input type="text" class="qty-input" value="1" />

                                        <button type="button" class="qty-btn" data-action="plus">+</button>

                                    </div>

                                    <asp:HiddenField ID="SelectedVariantId" runat="server" />

                                    <asp:HiddenField ID="SelectedQuantity" runat="server" Value="1" />

                                    <asp:LinkButton ID="AddToCartButton" runat="server" CssClass="btn btn-cart" OnClick="AddToCartButton_Click">
                                        <i class="fa-solid fa-cart-shopping"></i> Mua ngay
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="WishlistButton" runat="server" CssClass="btn btn-favorite btn-icon-only" OnClick="WishlistButton_Click">

                                        <i class="fa-regular fa-heart"></i>


                                    </asp:LinkButton>

                                    <%--<button type="button" class="btn btn-favorite">

                                        <i class="fa-regular fa-heart"></i> Yu thch

                                    </button>--%>

                                </div>

                                <div class="product-stock mt-3">
                                    <span id="StockStatus" class="stock-tag">
                                        <span class="dot"></span>
                                        <asp:Literal ID="StockStatusLiteral" runat="server" />
                                    </span>
                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="shop-summary-card mt-4">
                    <div class="shop-summary-logo">
                        <img src="<%= ResolveUrl(ShopLogoUrl) %>" alt="Shop logo" />
                    </div>
                    <div class="flex-grow-1">
                        <div class="shop-summary-head">
                            <div class="shop-summary-title"><asp:Literal ID="ShopNameLiteral" runat="server" /></div>
                            <asp:PlaceHolder ID="ShopRatingWrap" runat="server">
                                <div class="shop-rating-inline">
                                    <i class="fa-solid fa-star"></i>
                                    <span><asp:Literal ID="ShopRatingLiteral" runat="server" /></span>
                                </div>
                            </asp:PlaceHolder>
                        </div>
                        <div class="shop-summary-location"><asp:Literal ID="ShopProvinceLiteral" runat="server" /></div>
                        <div class="shop-summary-actions">
                            <a class="btn btn-outline-dark btn-sm" href="<%= ShopUrl %>" title="Xem shop" aria-label="Xem shop"><i class="fa-solid fa-store"></i><span>Xem shop</span></a>
                            <a class="btn btn-outline-dark btn-sm" href="<%= ChatShopUrl %>" title="Chat ngay" aria-label="Chat ngay"><i class="fa-regular fa-comments"></i><span>Chat ngay</span></a>
                            <asp:LinkButton ID="FollowShopButton" runat="server" CssClass="btn btn-outline-dark btn-sm" OnClick="FollowShopButton_Click" ToolTip="Theo d&#245;i" aria-label="Theo d&#245;i">
                                <i class="fa-regular fa-heart"></i>
                                <span><asp:Literal ID="FollowShopTextLiteral" runat="server" /></span>
                            </asp:LinkButton>
                            <button type="button" class="btn btn-outline-dark btn-sm" data-bs-toggle="modal" data-bs-target="#shopReviewModal" title="&#272;&#225;nh gi&#225;" aria-label="&#272;&#225;nh gi&#225;"><i class="fa-solid fa-star"></i><span>&#272;&#225;nh gi&#225;</span></button>
                        </div>
                    </div>
                    <div class="shop-summary-metrics">
                        <div class="shop-metric">
                            <span class="label">&#272;&#225;nh gi&#225;</span>
                            <span class="value"><asp:Literal ID="ShopRatingCountLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-metric">
                            <span class="label">T&#7881; l&#7879; ph&#7843;n h&#7891;i</span>
                            <span class="value"><asp:Literal ID="ShopResponseRateLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-metric">
                            <span class="label">Tham gia</span>
                            <span class="value"><asp:Literal ID="ShopJoinedLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-metric">
                            <span class="label">S&#7843;n ph&#7849;m</span>
                            <span class="value"><asp:Literal ID="ShopProductCountLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-metric">
                            <span class="label">Th&#7901;i gian ph&#7843;n h&#7891;i</span>
                            <span class="value"><asp:Literal ID="ShopResponseTimeLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-metric">
                            <span class="label">Ng&#432;&#7901;i theo d&#245;i</span>
                            <span class="value"><asp:Literal ID="ShopFollowerCountLiteral" runat="server" /></span>
                        </div>
                    </div>
                </div>


                <div class="modal fade shop-review-modal" id="shopReviewModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">&#272;&#225;nh gi&#225; shop</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <div class="fw-semibold mb-2">M&#7913;c &#273;&#7897; h&#224;i l&#242;ng</div>
                                    <div class="d-flex gap-2 shop-review-stars" id="shopReviewStars">
                                        <button type="button" class="btn btn-outline-dark btn-sm" data-rating="1">&#9733;</button>
                                        <button type="button" class="btn btn-outline-dark btn-sm" data-rating="2">&#9733;</button>
                                        <button type="button" class="btn btn-outline-dark btn-sm" data-rating="3">&#9733;</button>
                                        <button type="button" class="btn btn-outline-dark btn-sm" data-rating="4">&#9733;</button>
                                        <button type="button" class="btn btn-outline-dark btn-sm" data-rating="5">&#9733;</button>
                                    </div>
                                    <asp:HiddenField ID="ShopReviewRatingHidden" runat="server" />
                                </div>
                                <div class="mb-3">
                                    <label for="<%= ShopReviewContentTextBox.ClientID %>" class="form-label">N&#7897;i dung</label>
                                    <asp:TextBox ID="ShopReviewContentTextBox" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" />
                                </div>
                                <asp:Literal ID="ShopReviewErrorLiteral" runat="server" />
                                <asp:HiddenField ID="ShopReviewModalState" runat="server" />
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">&#272;&#243;ng</button>
                                <asp:LinkButton ID="SubmitShopReviewButton" runat="server" CssClass="btn btn-primary" OnClick="SubmitShopReviewButton_Click">G&#7917;i &#273;&#225;nh gi&#225;</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="product-tabs mt-4">

                    <ul class="nav nav-tabs" role="tablist">

                        <li class="nav-item" role="presentation">

                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-desc" type="button" role="tab">Chi ti&#7871;t s&#7843;n ph&#7849;m</button>

                        </li>

                        <li class="nav-item" role="presentation">

                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-spec" type="button" role="tab">&#272;&#225;nh gi&#225;</button>

                        </li>

                    </ul>

                    <div class="tab-content p-3 bg-white border border-top-0">

                        <div class="tab-pane fade show active" id="tab-desc" role="tabpanel">

                            <div class="tab-body js-tab-body">

                                <div class="tab-body-content">

                                    
                                    <div class="mb-3">
                                        <div><strong>Thương hiệu:</strong> <asp:Literal ID="BrandDetailLiteral" runat="server" /></div>
                                        <div><strong>Xuất xứ:</strong> <asp:Literal ID="OriginDetailLiteral" runat="server" /></div>
                                        <div><strong>Nơi gửi hàng:</strong> <asp:Literal ID="ShipFromLiteral" runat="server" /></div>
                                    </div>
                                    <asp:Literal ID="MoTa" runat="server" />
                                </div>

                                <button type="button" class="tab-toggle">Xem th&#234;m</button>

                            </div>

                        </div>

                        <div class="tab-pane fade" id="tab-spec" role="tabpanel">

                            <div class="tab-body js-tab-body">

                                <div class="tab-body-content">

                                    <asp:Literal ID="Specification" runat="server" />

                                </div>

                                <button type="button" class="tab-toggle">Xem th&#234;m</button>

                            </div>

                        </div>

                        <div class="tab-pane fade" id="tab-ing" role="tabpanel" style="display:none;">

                            <div class="tab-body js-tab-body">

                                <div class="tab-body-content">

                                    <asp:Literal ID="Ingredients" runat="server" />

                                </div>

                                <button type="button" class="tab-toggle">Xem th&#234;m</button>

                            </div>

                        </div>

                        <div class="tab-pane fade" id="tab-use" role="tabpanel" style="display:none;">

                            <div class="tab-body js-tab-body">

                                <div class="tab-body-content">

                                    <asp:Literal ID="Usage" runat="server" />

                                </div>

                                <button type="button" class="tab-toggle">Xem th&#234;m</button>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

            <aside class="col-lg-3">

                <div class="product-sidecard" style="display:none;">

                    <div class="shipping-card">

                        <div class="shipping-title">Miễn phí vận chuyển</div>

                        <div class="shipping-list">

                            <div class="shipping-item">

                                <img src="/public/assets/icon/1.png" alt="Giao nhanh 2H" />

                                <div>

                                    <div class="shipping-main">Giao nhanh miễn phí 2H.</div>

                                    <div class="shipping-sub">Trễ tặng 100K</div>

                                </div>

                            </div>

                            <div class="shipping-item">

                                <img src="/public/assets/icon/2.png" alt="Hng chnh hng" />

                                <div>

                                    <div class="shipping-main">Cam kết 100% hàng chính hãng</div>

                                    <div class="shipping-sub">Đền bù 100% nếu phát hiện hàng giả</div>

                                </div>

                            </div>

                            <div class="shipping-item">

                                <img src="/public/assets/icon/3.png" alt="Giao hàng miễn phí" />

                                <div>

                                    <div class="shipping-main">Giao hàng miễn phí</div>

                                    <div class="shipping-sub">Từ 690K tại 34 tỉnh thành</div>

                                </div>

                            </div>

                            <div class="shipping-item">

                                <img src="/public/assets/icon/4.png" alt="Đổi trả 30 ngày" />

                                <div>

                                    <div class="shipping-main">Đổi trả trong 30 ngày</div>

                                    <div class="shipping-sub">Dễ dàng, nhanh chóng</div>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

                <%--<div class="product-sidecard">

                    <div class="sidecard-brand">

                        <img src="/images/logo_doc.png" alt="Brand Logo" />

                        <div class="sidecard-brand-actions">

                            <button type="button" class="btn btn-outline-dark btn-sm">Theo di</button>

                            <span class="brand-badge">25K</span>

                        </div>

                    </div>

                </div>--%>

                <div class="product-sidecard">

                    <div class="sidecard-title">Sản phẩm tương tự</div>

                    <div class="sidecard-related">

                        <asp:Repeater ID="RelatedRepeater" runat="server">

                            <ItemTemplate>

                                <a class="related-item" href="<%# Eval("Url") %>">

                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />

                                    <div>

                                        <div class="related-name"><%# Eval("ProductName") %></div>

                                        <div class="related-price"><%# Eval("PriceHtml") %></div>

                                    </div>

                                </a>

                            </ItemTemplate>

                        </asp:Repeater>

                    </div>

                </div>

                <div class="product-sidecard">

                    <div class="sidecard-title">Sản phẩm cùng thương hiệu</div>

                    <div class="sidecard-related">

                        <asp:Repeater ID="BrandRelatedRepeater" runat="server">

                            <ItemTemplate>

                                <a class="related-item" href="<%# Eval("Url") %>">

                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />

                                    <div>

                                        <div class="related-name"><%# Eval("ProductName") %></div>

                                        <div class="related-price"><%# Eval("PriceHtml") %></div>

                                    </div>

                                </a>

                            </ItemTemplate>

                        </asp:Repeater>

                    </div>

                </div>

            </aside>

        </div>

        <section class="suggested-products container">

            <div class="suggested-card">

                <div class="suggested-title">Có thể bạn thích</div>

                <div class="swiper suggested-swiper">

                    <div class="swiper-wrapper">

                        <asp:Repeater ID="SuggestedRepeater" runat="server">

                            <ItemTemplate>

                                <div class="swiper-slide">

                                    <a class="suggested-item" href="<%# Eval("Url") %>">

                                        <div class="suggested-image">

                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />

                                            <%# Eval("SaleBadge") %>

                                        </div>

                                        <div class="suggested-name"><%# Eval("ProductName") %></div>

                                        <div class="suggested-price"><%# Eval("PriceHtml") %></div>

                                    </a>

                                </div>

                            </ItemTemplate>

                        </asp:Repeater>

                    </div>

                    <div class="swiper-button-prev suggested-prev"></div>

                    <div class="swiper-button-next suggested-next"></div>

                </div>

            </div>

        </section>

    </main>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">

    <script src="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.js") %>"></script>

    <script src="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.concat.min.js") %>"></script>

    <script>

        (function () {

            var thumbSwiper = new Swiper(".product-gallery-thumbs", {

                direction: "vertical",

                slidesPerView: 4,

                spaceBetween: 10,

                watchSlidesProgress: true,

                navigation: {

                    nextEl: ".product-gallery-thumbs .swiper-button-next",

                    prevEl: ".product-gallery-thumbs .swiper-button-prev"

                }

            });

            var mainSwiper = new Swiper(".product-gallery-main", {

                slidesPerView: 1,

                spaceBetween: 10,

                navigation: {

                    nextEl: ".product-gallery-main .swiper-button-next",

                    prevEl: ".product-gallery-main .swiper-button-prev"

                },

                thumbs: {

                    swiper: thumbSwiper

                }

            });

            var suggestedSwiper = new Swiper(".suggested-swiper", {

                slidesPerView: 5.5,

                spaceBetween: 16,

                grabCursor: true,

                navigation: {

                    nextEl: ".suggested-next",

                    prevEl: ".suggested-prev"

                },

                breakpoints: {

                    0: { slidesPerView: 1.3, spaceBetween: 12 },

                    576: { slidesPerView: 2.2, spaceBetween: 14 },

                    768: { slidesPerView: 3.2, spaceBetween: 14 },

                    992: { slidesPerView: 4.2, spaceBetween: 16 },

                    1200: { slidesPerView: 5.5, spaceBetween: 16 }

                }

            });

        })();

    </script>

    <script>

        (function () {

            var priceMap = <%= string.IsNullOrWhiteSpace(VariantPriceJson) ? "{}" : VariantPriceJson %>;

            var skuMap = <%= string.IsNullOrWhiteSpace(VariantSkuJson) ? "{}" : VariantSkuJson %>;

            var idMap = <%= string.IsNullOrWhiteSpace(VariantIdJson) ? "{}" : VariantIdJson %>;

            var stockMap = <%= string.IsNullOrWhiteSpace(VariantStockJson) ? "{}" : VariantStockJson %>;

            var priceEl = document.getElementById("PriceValue");

            var skuEl = document.getElementById("SkuValue");

            var addBtn = document.getElementById("<%= AddToCartButton.ClientID %>");

            var hidden = document.getElementById("<%= SelectedVariantId.ClientID %>");
            var stockEl = document.getElementById("StockStatus");
            var stockById = {};

            Object.keys(idMap || {}).forEach(function (key) {
                if (stockMap && Object.prototype.hasOwnProperty.call(stockMap, key)) {
                    stockById[idMap[key]] = stockMap[key];
                }
            });

            window.variantStockById = stockById;



            

            function updateStock(stockQty) {
                if (!stockEl) {
                    return;
                }

                var qty = parseInt(stockQty || "0", 10);
                stockEl.textContent = qty > 0 ? ("C\u00f2n " + qty + " s\u1ea3n ph\u1ea9m") : "H\u1ebft h\u00e0ng";
            }

            function setButtonEnabled(enabled) {

                if (!addBtn) {

                    return;

                }

                if (enabled) {

                    addBtn.classList.remove("disabled");

                    addBtn.removeAttribute("aria-disabled");

                    addBtn.removeAttribute("tabindex");

                } else {

                    addBtn.classList.add("disabled");

                    addBtn.setAttribute("aria-disabled", "true");

                    addBtn.setAttribute("tabindex", "-1");

                }

            }



            function ensureDefaults() {

                document.querySelectorAll(".variant-group").forEach(function (group) {

                    var active = group.querySelector(".variant-pill.active");

                    if (!active) {

                        var first = group.querySelector(".variant-pill");

                        if (first) {

                            first.classList.add("active");

                        }

                    }

                });

            }



            function buildKey() {

                var parts = [];

                var valid = true;

                document.querySelectorAll(".variant-group").forEach(function (group) {

                    var active = group.querySelector(".variant-pill.active");

                    if (!active) {

                        valid = false;

                        return;

                    }

                    var attrId = active.getAttribute("data-attrid");

                    var valId = active.getAttribute("data-valid");

                    parts.push(attrId + ":" + valId);

                });

                if (!valid) {

                    return null;

                }

                parts.sort(function (a, b) {

                    return parseInt(a.split(":")[0], 10) - parseInt(b.split(":")[0], 10);

                });

                return parts.join("|");

            }



            function updateSelection() {

                ensureDefaults();

                var key = buildKey();

                if (key && priceMap[key]) {

                    if (priceEl) {

                        priceEl.innerHTML = priceMap[key];

                    }

                    if (skuEl) {

                        skuEl.textContent = skuMap[key] || "-";

                    }

                    if (hidden) {

                        hidden.value = idMap[key] || "";

                    }

                    var stockQty = stockMap && Object.prototype.hasOwnProperty.call(stockMap, key) ? stockMap[key] : 0;
                    updateStock(stockQty);
                    setButtonEnabled(parseInt(stockQty || "0", 10) > 0);

                    return;

                }



                if (priceEl) {

                    priceEl.textContent = "Li\u00ean h\u1ec7";

                }

                if (skuEl) {

                    skuEl.textContent = "-";

                }

                
                if (hidden) {

                    hidden.value = "";

                }

                if (stockEl) {
                    stockEl.textContent = "";
                }

                setButtonEnabled(false);


            }



            document.querySelectorAll(".js-variant-value").forEach(function (btn) {

                btn.addEventListener("click", function () {

                    var group = btn.closest(".variant-group");

                    if (!group) {

                        return;

                    }

                    group.querySelectorAll(".variant-pill").forEach(function (pill) {

                        pill.classList.remove("active");

                    });

                    btn.classList.add("active");

                    updateSelection();

                });

            });



            if (addBtn) {

                addBtn.addEventListener("click", function (event) {

                    if (addBtn.classList.contains("disabled")) {

                        event.preventDefault();

                        event.stopPropagation();

                    }

                });

            }



            updateSelection();

        })();

    </script>



    <script>

        (function () {

            var maxItems = parseInt(document.getElementById("<%= CartLimitMaxItems.ClientID %>").value || "0", 10);

            var maxQty = parseInt(document.getElementById("<%= CartLimitMaxQty.ClientID %>").value || "0", 10);

            var cartQty = parseInt(document.getElementById("<%= CartLimitCartQty.ClientID %>").value || "0", 10);

            var mapValue = document.getElementById("<%= CartLimitVariantQtyJson.ClientID %>").value || "{}";

            var variantQty = {};
            var stockById = window.variantStockById || {};

            try { variantQty = JSON.parse(mapValue); } catch (e) { variantQty = {}; }



            var warning = document.getElementById("CartLimitWarning");

            var qtyInput = document.querySelector(".qty-input");

            var addBtn = document.getElementById("<%= AddToCartButton.ClientID %>");

            var variantHidden = document.getElementById("<%= SelectedVariantId.ClientID %>");



            function showWarning(message) {

                if (!warning) {

                    return;

                }

                warning.textContent = message;

                warning.style.display = "block";

            }



            function clearWarning() {

                if (!warning) {

                    return;

                }

                warning.textContent = "";

                warning.style.display = "none";

            }



            function getSelectedQty() {

                var val = qtyInput ? parseInt(qtyInput.value || "1", 10) : 1;

                return isNaN(val) || val < 1 ? 1 : val;

            }



            function getSelectedVariantQty() {

                if (!variantHidden) {

                    return 0;

                }

                var id = parseInt(variantHidden.value || "0", 10);

                if (!id || !variantQty[id]) {

                    return 0;

                }

                return variantQty[id];

            }

            function getSelectedStockQty() {

                if (!variantHidden) {

                    return 0;

                }

                var id = parseInt(variantHidden.value || "0", 10);

                if (!id || !stockById[id]) {

                    return 0;

                }

                return parseInt(stockById[id], 10) || 0;

            }



            function checkLimits() {

                if (!maxItems && !maxQty) {

                    clearWarning();

                    return true;

                }

                var addQty = getSelectedQty();

                var currentVariantQty = getSelectedVariantQty();

                if (maxQty && (currentVariantQty + addQty) > maxQty) {

                    showWarning("Gi\u1edbi h\u1ea1n m\u1ed7i s\u1ea3n ph\u1ea9m: t\u1ed1i \u0111a " + maxQty + " s\u1ea3n ph\u1ea9m.");

                    return false;

                }

                var stockQty = getSelectedStockQty();

                if (stockQty && (currentVariantQty + addQty) > stockQty) {

                    showWarning("S\u1ed1 l\u01b0\u1ee3ng v\u1ee3t t\u1ed3n kho. C\u00f2n " + stockQty + " s\u1ea3n ph\u1ea9m.");

                    return false;

                }


                if (maxItems && (cartQty + addQty) > maxItems) {

                    showWarning("Gi\u1edbi h\u1ea1n \u0111\u01a1n h\u00e0ng: t\u1ed1i \u0111a " + maxItems + " s\u1ea3n ph\u1ea9m.");

                    return false;

                }

                clearWarning();

                return true;

            }



            if (qtyInput) {

                qtyInput.addEventListener("input", checkLimits);

                qtyInput.addEventListener("blur", checkLimits);

            }



            if (addBtn) {

                addBtn.addEventListener("click", function (event) {

                    if (!checkLimits()) {

                        event.preventDefault();

                        event.stopPropagation();

                    }

                });

            }



            document.querySelectorAll(".js-variant-value").forEach(function (btn) {

                btn.addEventListener("click", function () {

                    setTimeout(checkLimits, 0);

                });

            });

        })();

    </script>

    <script>

        (function () {

            var qtyInput = document.querySelector(".qty-input");

            var qtyHidden = document.getElementById("<%= SelectedQuantity.ClientID %>");

            if (!qtyInput) {

                return;

            }



            function clamp(value) {

                var num = parseInt(value, 10);

                if (isNaN(num) || num < 1) {

                    return 1;

                }

                if (num > 99) {

                    return 99;

                }

                return num;

            }



            document.querySelectorAll(".qty-btn").forEach(function (btn) {

                btn.addEventListener("click", function () {

                    var current = clamp(qtyInput.value);

                    var action = btn.getAttribute("data-action");

                    qtyInput.value = action === "plus" ? current + 1 : Math.max(1, current - 1);

                    if (qtyHidden) {

                        qtyHidden.value = qtyInput.value;

                    }

                });

            });



            qtyInput.addEventListener("input", function () {

                qtyInput.value = qtyInput.value.replace(/[^0-9]/g, "");

            });



            qtyInput.addEventListener("blur", function () {

                qtyInput.value = clamp(qtyInput.value);

                if (qtyHidden) {

                    qtyHidden.value = qtyInput.value;

                }

            });

        })();

    </script>

    <script>
        (function () {
            var starWrap = document.getElementById("shopReviewStars");
            var ratingHidden = document.getElementById("<%= ShopReviewRatingHidden.ClientID %>");
            if (starWrap && ratingHidden) {
                var currentRating = parseInt(ratingHidden.value || "0", 10) || 0;
                starWrap.querySelectorAll("button[data-rating]").forEach(function (btn) {
                    var initValue = parseInt(btn.getAttribute("data-rating"), 10) || 0;
                    if (initValue <= currentRating && currentRating > 0) {
                        btn.classList.remove("btn-outline-dark");
                        btn.classList.add("btn-dark");
                    }
                    btn.addEventListener("click", function () {
                        var rating = parseInt(btn.getAttribute("data-rating"), 10) || 0;
                        ratingHidden.value = rating.toString();
                        starWrap.querySelectorAll("button[data-rating]").forEach(function (b) {
                            var value = parseInt(b.getAttribute("data-rating"), 10) || 0;
                            if (value <= rating) {
                                b.classList.remove("btn-outline-dark");
                                b.classList.add("btn-dark");
                            } else {
                                b.classList.remove("btn-dark");
                                b.classList.add("btn-outline-dark");
                            }
                        });
                    });
                });
            }

            var modalState = document.getElementById("<%= ShopReviewModalState.ClientID %>");
            if (modalState && modalState.value === "open") {
                var modalEl = document.getElementById("shopReviewModal");
                if (modalEl && window.bootstrap && window.bootstrap.Modal) {
                    new window.bootstrap.Modal(modalEl).show();
                }
            }
        })();
    </script>

</asp:Content>
