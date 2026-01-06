<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="BestSellingDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
    <asp:Literal ID="SchemaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 category-page best-selling-page">
        <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
            <ol class="breadcrumb mb-2">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Bán chạy</li>
            </ol>
        </nav>
        <div class="section-heading">
            <div>
                <h4>Bán chạy</h4>
                <p><asp:Literal ID="PageSummaryLiteral" runat="server" /></p>
            </div>
        </div>

        <asp:Panel ID="EmptyPanel" runat="server" Visible="false" CssClass="cart-empty">
            <p>Hiện chưa có sản phẩm bán chạy.</p>
            <a class="btn btn-outline-dark" href="/">Quay về trang chủ</a>
        </asp:Panel>

        <div class="row g-3">
            <asp:Repeater ID="ProductRepeater" runat="server">
                <ItemTemplate>
                    <div class="col-6 col-md-4 col-lg-2-4">
                        <div class="product-card">
                            <a class="product-thumb" href="/san-pham/<%# Eval("SeoSlug") %>">
                                <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                <%# Eval("SaleBadge") %>
                            </a>
                            <div class="product-body">
                                <a class="product-category" href="/danh-muc/<%# Eval("CategorySlug") %>"><%# Eval("CategoryName") %></a>
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
        <div class="mt-4">
            <asp:Literal ID="PaginationLiteral" runat="server" />
        </div>
    </main>
</asp:Content>
