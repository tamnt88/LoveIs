<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NewProductHomePage.ascx.cs" Inherits="public_controls_trang_chu_NewProductHomePage" %>
<section class="new-product-section">
    <div class="container">
        <div class="new-product-card">
            <div class="new-product-title">Gợi ý dành cho bạn</div>
            <div class="new-product-grid">
                <asp:Repeater ID="BestSellingRepeater" runat="server">
                    <ItemTemplate>
                        <div class="new-product-item">
                            <a class="new-product-photo" href="<%# Eval("Url") %>">
                                <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                <asp:Literal ID="DiscountBadgeLiteral" runat="server" Text='<%# Eval("DiscountBadge") %>' />
                            </a>
                            <div class="new-product-info">
                                <a class="new-product-name" href="<%# Eval("Url") %>"><%# Eval("ProductName") %></a>
                                <div class="new-product-price">
                                    <asp:Literal ID="PriceLiteral" runat="server" Text='<%# Eval("PriceHtml") %>' />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</section>
