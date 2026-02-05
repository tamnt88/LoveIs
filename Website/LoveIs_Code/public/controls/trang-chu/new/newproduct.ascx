<%@ Control Language="C#" AutoEventWireup="true" CodeFile="newproduct.ascx.cs" Inherits="public_controls_trang_chu_new_newproduct" %>
<section class="home-newproduct-section">
    <div class="container">
        <div class="home-newproduct-header">
            <div>
                <div class="home-newproduct-eyebrow">BEST SELLER</div>
                <div class="home-newproduct-title">Sản phẩm bán chạy</div>
            </div>
            <a class="home-newproduct-link" href="/ban-chay">Xem tất cả</a>
        </div>
        <div class="row g-3 category-product-grid">
            <asp:Repeater ID="NewProductRepeater" runat="server">
                <ItemTemplate>
                    <div class="col-6 col-md-4 col-lg-3 product-col">
                        <div class="product-card">
                            <a class="product-thumb" href="/san-pham/<%# Eval("SeoSlug") %>">
                                <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                <%# Eval("SaleBadge") %>
                            </a>
                            <button type="button" class="product-wishlist-btn <%# Eval("WishlistClass") %>" data-product-id="<%# Eval("Id") %>" aria-label="Them vao yeu thich">
                                <i class="<%# Eval("WishlistIconClass") %>"></i>
                            </button>
                            <div class="product-body">
                                <h6 class="product-title">
                                    <a href="/san-pham/<%# Eval("SeoSlug") %>"><%# Eval("ProductName") %></a>
                                </h6>
                                <div class="product-price"><%# Eval("PriceLabel") %></div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="home-newproduct-footer">
            <a class="home-newproduct-link" href="/ban-chay">Xem tất cả</a>
        </div>
    </div>
</section>
