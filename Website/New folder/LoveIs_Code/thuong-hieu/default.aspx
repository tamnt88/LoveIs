<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="BrandDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
    <asp:Literal ID="SchemaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 category-page brand-page">
        <div class="category-hero mb-4">
            <div class="category-hero-banner">
                <asp:Image ID="BrandBannerImage" runat="server" CssClass="img-fluid w-100" AlternateText="Brand Banner" />
                <div class="category-hero-overlay">
                    <h1 class="category-hero-title"><asp:Literal ID="BrandTitleTop" runat="server" /></h1>
                </div>
            </div>
        </div>
        <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
            <ol class="breadcrumb mb-2">
                <asp:Literal ID="BrandBreadcrumb" runat="server" />
            </ol>
        </nav>
        <div class="section-heading">
            <div>
                <h4><asp:Literal ID="BrandTitle" runat="server" /></h4>
                <p><asp:Literal ID="BrandSubTitle" runat="server" /></p>
            </div>
        </div>
        <div class="row g-3">
            <asp:Repeater ID="BrandProductRepeater" runat="server">
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
