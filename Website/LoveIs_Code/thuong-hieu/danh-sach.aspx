<%@ Page Language="C#" AutoEventWireup="true" CodeFile="danh-sach.aspx.cs" Inherits="BrandList" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 brand-list-page">
        <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
            <ol class="breadcrumb mb-2">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Thương hiệu</li>
            </ol>
        </nav>
        <div class="brand-list-header">
            <h1>Thương hiệu</h1>
            <p><asp:Literal ID="BrandCountLiteral" runat="server" /></p>
        </div>
        <div class="brand-index">
            <asp:Repeater ID="IndexRepeater" runat="server">
                <ItemTemplate>
                    <a class="brand-index-link" href="#brand-group-<%# Eval("Key") %>"><%# Eval("Label") %></a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:Repeater ID="GroupRepeater" runat="server">
            <ItemTemplate>
                <div class="brand-group">
                    <h3 id="brand-group-<%# Eval("Key") %>" class="brand-group-title"><%# Eval("Label") %></h3>
                    <div class="row g-3 brand-group-grid">
                        <asp:Repeater ID="BrandRepeater" runat="server" DataSource='<%# Eval("Items") %>'>
                            <ItemTemplate>
                                <div class="col-6 col-md-4 col-lg-2">
                                    <a class="brand-card" href="<%# Eval("Url") %>">
                                        <div class="brand-card-thumb">
                                            <img src="<%# Eval("LogoUrl") %>" alt="<%# Eval("BrandName") %>" />
                                        </div>
                                        <div class="brand-card-name"><%# Eval("BrandName") %></div>
                                    </a>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </main>
</asp:Content>
