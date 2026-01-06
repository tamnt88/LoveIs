<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="NewsDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 news-page">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page"><asp:Literal ID="BreadcrumbTitleLiteral" runat="server" /></li>
            </ol>
        </nav>
        <div class="row g-4">
            <aside class="col-lg-3 order-2 order-lg-1">
                <div class="news-sidebar">
                    <h6 class="mb-3 sidebar-heading"><i class="fa-solid fa-newspaper"></i><span>Danh mục tin tức</span></h6>
                    <asp:Repeater ID="PostCategoryRepeater" runat="server">
                        <ItemTemplate>
                            <div class="news-cat-group <%# Eval("IsOpen") %>">
                                <a class="news-cat-link <%# Eval("IsActive") %>" href="/tin-tuc/<%# Eval("SeoSlug") %>"><%# Eval("CategoryName") %></a>
                                <asp:Repeater ID="PostCategoryChildRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                    <ItemTemplate>
                                        <div class="news-cat-child">
                                            <a class="news-cat-link <%# Eval("IsActive") %>" href="/tin-tuc/<%# Eval("SeoSlug") %>"><%# Eval("CategoryName") %></a>
                                            <asp:Repeater ID="PostCategoryGrandRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                                <ItemTemplate>
                                                    <a class="news-cat-grand <%# Eval("IsActive") %>" href="/tin-tuc/<%# Eval("SeoSlug") %>"><%# Eval("CategoryName") %></a>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </aside>
            <section class="col-lg-9 order-1 order-lg-2">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h1 class="mb-0"><asp:Literal ID="PageTitleLiteral" runat="server" /></h1>
                </div>
                <asp:Panel ID="EmptyPanel" runat="server" Visible="false" CssClass="text-muted">
                    Chưa có bài viết phù hợp.
                </asp:Panel>
                <div class="row g-4">
                    <asp:Repeater ID="PostRepeater" runat="server">
                        <ItemTemplate>
                            <div class="col-lg-4 col-md-6">
                                <article class="news-card h-100">
                                    <a class="news-thumb" href="/bai-viet/<%# Eval("SeoSlug") %>">
                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("PostTitle") %>" />
                                    </a>
                                    <div class="news-card-body">
                                        <div class="text-muted small mb-2"><%# Eval("CreatedAt") %></div>
                                        <h5 class="news-title mb-2">
                                            <a href="/bai-viet/<%# Eval("SeoSlug") %>"><%# Eval("PostTitle") %></a>
                                        </h5>
                                        <div class="news-excerpt"><%# Eval("Excerpt") %></div>
                                    </div>
                                </article>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </section>
        </div>
    </main>
</asp:Content>
