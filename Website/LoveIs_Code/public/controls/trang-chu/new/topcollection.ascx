<%@ Control Language="C#" AutoEventWireup="true" CodeFile="topcollection.ascx.cs" Inherits="public_controls_trang_chu_new_topcollection" %>
<section class="top-collection-section">
    <div class="container">
        <div class="top-collection-header">
            <div>
                <div class="top-collection-eyebrow">BEST SELLER</div>
                <div class="top-collection-title">New collection 2026</div>
            </div>
            <a class="top-collection-link" href="/san-pham">Xem tất cả</a>
        </div>
        <div class="swiper top-collection-swiper">
            <div class="swiper-wrapper">
                <asp:Repeater ID="TopCollectionRepeater" runat="server">
                    <ItemTemplate>
                        <div class="swiper-slide">
                            <div class="top-collection-card">
                                <%# Eval("SaleBadge") %>
                                <button type="button" class="product-wishlist-btn <%# Eval("WishlistClass") %>" data-product-id="<%# Eval("ProductId") %>">
                                    <i class="<%# Eval("WishlistIconClass") %>"></i>
                                </button>
                                <a class="top-collection-photo" href="<%# Eval("Url") %>">
                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                    <span class="top-collection-tag">New collection 2026</span>
                                </a>
                                <div class="top-collection-body">
                                    <a class="top-collection-name" href="<%# Eval("Url") %>"><%# Eval("ProductName") %></a>
                                    <div class="top-collection-price">
                                        <span class="price-main"><%# Eval("PriceText") %></span>
                                        <span class="price-discount"><%# Eval("DiscountText") %></span>
                                    </div>
                                    <div class="top-collection-meta">
                                        <span><i class="fa-solid fa-truck"></i> 1 - 3 ngày</span>
                                        <span><i class="fa-solid fa-location-dot"></i> <%# Eval("ProvinceName") %></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="top-collection-nav top-collection-prev swiper-button-prev"></div>
            <div class="top-collection-nav top-collection-next swiper-button-next"></div>
        </div>
    </div>
</section>
