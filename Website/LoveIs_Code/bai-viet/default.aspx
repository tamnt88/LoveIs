<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="PostDetail" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 post-detail">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="/tin-tuc">Tin tức</a></li>
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
                <article class="post-card p-4 border rounded">
                    <h1 class="mb-2"><asp:Literal ID="TitleLiteral" runat="server" /></h1>
                    <div class="text-muted small mb-3"><asp:Literal ID="DateLiteral" runat="server" /></div>
                    <asp:Image ID="FeaturedImage" runat="server" CssClass="img-fluid rounded mb-3" Visible="false" />
                    <asp:Panel ID="TocPanel" runat="server" Visible="false" CssClass="post-toc">
                        <asp:Literal ID="TocLiteral" runat="server" />
                    </asp:Panel>
                    <div class="post-content"><asp:Literal ID="ContentLiteral" runat="server" /></div>
                    <asp:Panel ID="TagPanel" runat="server" Visible="false" CssClass="post-tags">
                        <div class="post-tags-title">Từ khóa</div>
                        <div class="post-tags-list">
                            <asp:Repeater ID="TagRepeater" runat="server">
                                <ItemTemplate>
                                    <a class="post-tag-link" href="<%# Eval("Url") %>">#<%# Eval("TagName") %></a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:Panel>
                </article>

                <asp:Panel ID="RelatedPanel" runat="server" Visible="false" CssClass="post-related">
                    <div class="section-heading">
                        <h4>Bài viết liên quan</h4>
                    </div>
                    <div class="owl-carousel post-related-carousel">
                        <asp:Repeater ID="RelatedRepeater" runat="server">
                            <ItemTemplate>
                                <article class="post-related-card">
                                    <a class="post-related-thumb" href="/bai-viet/<%# Eval("SeoSlug") %>">
                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("PostTitle") %>" />
                                    </a>
                                    <div class="post-related-body">
                                        <div class="text-muted small mb-2"><%# Eval("CreatedAt") %></div>
                                        <h6 class="post-related-title">
                                            <a href="/bai-viet/<%# Eval("SeoSlug") %>"><%# Eval("PostTitle") %></a>
                                        </h6>
                                    </div>
                                </article>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>
            </section>
        </div>
    </main>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        $(function () {
            var $carousel = $('.post-related-carousel');
            if ($carousel.length) {
                $carousel.owlCarousel({
                    items: 3,
                    margin: 20,
                    nav: true,
                    dots: false,
                    autoplay: false,
                    responsive: {
                        0: { items: 1 },
                        576: { items: 2 },
                        992: { items: 3 }
                    }
                });
            }
        });
    </script>
</asp:Content>
