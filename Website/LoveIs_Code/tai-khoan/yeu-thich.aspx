<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yeu-thich.aspx.cs" Inherits="CustomerWishlistPage" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Wishlist
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 account-page">
        <div class="row g-4">
            <div class="col-lg-3">
                <uc:CustomerSidebar ID="CustomerSidebar" runat="server" />
            </div>
            <div class="col-lg-9">
                <div class="account-card">
                    <div class="account-card-header">
                        <h4>Wishlist</h4>
                        <asp:Literal ID="StatusLiteral" runat="server" />
                    </div>
                    <asp:Panel ID="EmptyPanel" runat="server" CssClass="account-empty" Visible="false">
                        No items in wishlist yet.
                    </asp:Panel>
                    <asp:Repeater ID="WishlistRepeater" runat="server" OnItemCommand="WishlistRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="account-list-item order-item">
                                <div class="d-flex align-items-center gap-3">
                                    <a class="cart-thumb" href="/san-pham/<%# Eval("SeoSlug") %>">
                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                    </a>
                                    <div>
                                        <div class="account-list-title"><%# Eval("ProductName") %></div>
                                        <div class="account-list-text"><%# Eval("PriceHtml") %></div>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <a class="btn btn-outline-dark" href="/san-pham/<%# Eval("SeoSlug") %>">View</a>
                                    <asp:LinkButton ID="RemoveButton" runat="server" CommandName="remove" CommandArgument='<%# Eval("ProductId") %>' CssClass="btn btn-link text-danger">
                                        Remove
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
