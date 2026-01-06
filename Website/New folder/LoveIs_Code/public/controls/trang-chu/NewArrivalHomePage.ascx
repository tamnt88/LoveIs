<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NewArrivalHomePage.ascx.cs" Inherits="public_controls_trang_chu_NewArrivalHomePage" %>
<!--==================== Exclusive Product Section Start ====================-->
<div class="full-row">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <span class="text-primary text-center pb-2 d-table mx-auto tagline text-uppercase font-small">Sản phẩm dành cho bạn</span>
                <h3 class="mb-4 w-50 text-center mx-auto w-sm-100 font-700 text-dark">Hàng mới về</h3>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <div class="products product-style-3 new-arrival-wrap e-image-bg-light e-hover-image-zoom e-btn-set-hover-primary">
                    <div class="swiper new-arrival-swiper">
                        <div class="swiper-wrapper">
                        <asp:Repeater ID="NewArrivalRepeater" runat="server">
                            <ItemTemplate>
                                <div class="swiper-slide">
                                    <div class="product type-product">
                                    <div class="product-wrapper">
                                        <div class="product-image">
                                            <a href="<%# Eval("Url") %>" class="woocommerce-LoopProduct-link">
                                                <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>">
                                            </a>
                                            <%# Eval("DiscountBadge") %>
                                        </div>
                                        <div class="product-info">
                                            <h3 class="product-title"><a href="<%# Eval("Url") %>"><%# Eval("ProductName") %></a></h3>
                                            <div class="product-price">
                                                <div class="price"><%# Eval("PriceHtml") %></div>
                                            </div>
                                        </div>
                                    </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        </div>
                        <div class="swiper-button-prev new-arrival-prev"></div>
                        <div class="swiper-button-next new-arrival-next"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
