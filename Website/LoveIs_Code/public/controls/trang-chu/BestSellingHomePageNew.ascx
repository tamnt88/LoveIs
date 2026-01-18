<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BestSellingHomePageNew.ascx.cs" Inherits="public_controls_trang_chu_BestSellingHomePageNew" %>
<section class="best-selling-section">
    <div class="container">
        <div class="best-selling-frame">
            <div class="best-selling-header">
                <span class="best-selling-line line-top"></span>
                <span class="best-selling-line line-mid"></span>
                <span class="best-selling-line line-bottom"></span>
                <div class="best-selling-title">
                    <span>SẢN PHẨM BÁN CHẠY</span>
                </div>
            </div>
            <div class="swiper best-selling-swiper">
                <div class="swiper-wrapper">
                    <asp:Repeater ID="TrendingRepeater" runat="server">
                        <ItemTemplate>
                            <div class="swiper-slide">
                                <div class="best-selling-card">
                                    <a class="best-selling-photo" href="<%# Eval("Url") %>">
                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                        <asp:Literal ID="DiscountBadgeLiteral" runat="server" Text='<%# Eval("DiscountBadge") %>' />
                                    </a>
                                    <div class="best-selling-info">
                                        <a class="best-selling-name" href="<%# Eval("Url") %>"><%# Eval("ProductName") %></a>
                                        <div class="best-selling-price">
                                            <asp:Literal ID="PriceLiteral" runat="server" Text='<%# Eval("PriceHtml") %>' />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="best-selling-nav best-selling-prev swiper-button-prev"></div>
                <div class="best-selling-nav best-selling-next swiper-button-next"></div>
            </div>
        </div>
    </div>
</section>
