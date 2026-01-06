<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BestSellingHomePage.ascx.cs" Inherits="public_controls_trang_chu_BestSellingHomePage" %>
<!--==================== Best Selling Products Section Start ====================-->
<div class="full-row pb-10">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <div class="section-head d-flex justify-content-between align-items-center pb-20">
                    <h3 class="font-700 text-secondary mb-0 down-line">Sản phẩm bán chạy nhất</h3>
                </div>
            </div>
        </div>
        <div class="row g-3 row-cols-xl-4 row-cols-lg-3 row-cols-md-2 row-cols-1 product-list e-hover-image-zoom e-btn-set-two">
            <asp:Repeater ID="BestSellingRepeater" runat="server">
                <ItemTemplate>
                    <div class="col">
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
    </div>
</div>
