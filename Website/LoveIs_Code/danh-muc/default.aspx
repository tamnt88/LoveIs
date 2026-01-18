<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CategoryDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.min.css") %>" rel="stylesheet" />
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
    <asp:Literal ID="SchemaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 category-page" data-wishlist-endpoint="/danh-muc/default.aspx/ToggleWishlist">
        <div class="category-hero mb-4" style="display:none;">
            <div class="category-hero-banner">
                <asp:Image ID="CategoryBannerImage" runat="server" CssClass="img-fluid w-100" AlternateText="Category Banner" />
                <div class="category-hero-overlay">
                    <h1 class="category-hero-title"><asp:Literal ID="CategoryTitleTop" runat="server" /></h1>
                </div>
            </div>
        </div>
        <div class="row g-4">
            <aside class="col-lg-2 order-2 order-lg-1">
                <div class="category-sidebar">
                    <h6 class="mb-3 sidebar-heading"><i class="fa-solid fa-list"></i><span>Tất cả danh mục</span></h6>
                    <asp:Repeater ID="SidebarRepeater" runat="server">
                        <ItemTemplate>
                            <div class="sidebar-group <%# GetSidebarOpenClass(Eval("IsOpen")) %>">
                                <div class="sidebar-row">
                                    <a class="sidebar-parent <%# GetSidebarActiveClass(Eval("Id")) %>" href="/danh-muc/<%# Eval("SeoSlug") %>">
                                        <%# Eval("CategoryName") %>
                                    </a>
                                    <button type="button" class="toggle-btn <%# GetToggleVisibleClass(Eval("HasChildren")) %>">
                                        <i class="fas fa-angle-down"></i>
                                    </button>
                                </div>
                                <div class="sidebar-children">
                                    <asp:Repeater ID="SidebarChildRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                        <ItemTemplate>
                                            <div class="sidebar-group level-2 <%# GetSidebarOpenClass(Eval("IsOpen")) %>">
                                                <div class="sidebar-row">
                                                    <a class="sidebar-child <%# GetSidebarActiveClass(Eval("Id")) %>" href="/danh-muc/<%# Eval("SeoSlug") %>">
                                                        <%# Eval("CategoryName") %>
                                                    </a>
                                                    <button type="button" class="toggle-btn <%# GetToggleVisibleClass(Eval("HasChildren")) %>">
                                                        <i class="fas fa-angle-down"></i>
                                                    </button>
                                                </div>
                                                <div class="sidebar-children">
                                                    <asp:Repeater ID="SidebarGrandChildRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                                        <ItemTemplate>
                                                            <a class="sidebar-child level-3 <%# GetSidebarActiveClass(Eval("Id")) %>" href="/danh-muc/<%# Eval("SeoSlug") %>">
                                                                <%# Eval("CategoryName") %>
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>                <div class="filter-sidebar">
                    <h6 class="mb-3 mt-4 sidebar-heading"><i class="fa-solid fa-tags"></i><span>Thuộc tính</span></h6>
                    <asp:Repeater ID="AttributeGroupRepeater" runat="server">
                        <ItemTemplate>
                            <div class="filter-group attribute-filter-group">
                                <button type="button" class="filter-title filter-toggle-btn">
                                    <span><%# Eval("AttributeName") %></span>
                                    <i class="fas fa-angle-down"></i>
                                </button>
                                <div class="filter-options">
                                    <asp:Repeater ID="AttributeValueRepeater" runat="server" DataSource='<%# Eval("Values") %>'>
                                        <ItemTemplate>
                                            <label class="filter-option">
                                                <input type="checkbox" class="js-filter-attr" value="<%# Eval("Id") %>" <%# Eval("Selected") %> />
                                                <span><%# Eval("ValueName") %></span>
                                            </label>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </aside>
                        <section class="col-lg-10 order-1 order-lg-2">
                
                <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
                    <ol class="breadcrumb mb-2">
                        <asp:Literal ID="CategoryBreadcrumb" runat="server" />
                    </ol>
                </nav>
                <div class="section-heading">
                    <div>
                        <h4><asp:Literal ID="CategoryTitle" runat="server" /></h4>
                        <p><asp:Literal ID="CategorySubTitle" runat="server" /></p>
                    </div>
                </div>
                            <div class="category-filter-bar">
                    <div class="filter-bar-left">
                        <div class="filter-field">
                            <label for="LocationSelect">Nơi bán</label>
                            <select id="LocationSelect" class="filter-select js-filter-select-location">
                                <option value="">Tất cả</option>
                                <asp:Repeater ID="LocationFilterRepeater" runat="server">
                                    <ItemTemplate>
                                        <option value="<%# Eval("Id") %>" <%# Eval("Selected") %>><%# Eval("Name") %></option>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </select>
                        </div>
                        <div class="filter-field">
                            <label for="BrandSelect">Thương hiệu</label>
                            <select id="BrandSelect" class="filter-select js-filter-select-brand">
                                <option value="">Tất cả</option>
                                <asp:Repeater ID="BrandFilterRepeater" runat="server">
                                    <ItemTemplate>
                                        <option value="<%# Eval("Id") %>" <%# Eval("Selected") %>><%# Eval("Name") %></option>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </select>
                        </div>
                        <div class="filter-field">
                            <label for="OriginSelect">Xuất xứ</label>
                            <select id="OriginSelect" class="filter-select js-filter-select-origin">
                                <option value="">Tất cả</option>
                                <asp:Repeater ID="OriginFilterRepeater" runat="server">
                                    <ItemTemplate>
                                        <option value="<%# Eval("Id") %>" <%# Eval("Selected") %>><%# Eval("Name") %></option>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </select>
                        </div>
                    </div>
                    <div class="filter-bar-right">
                        <div class="filter-field">
                            <label for="SortSelect">Sắp xếp theo</label>
                            <select id="SortSelect" class="filter-select js-filter-select-sort">
                                <option value="popular" <%= GetSortSelected("popular") %>>Phổ biến</option>
                                <option value="newest" <%= GetSortSelected("newest") %>>Mới nhất</option>
                                <option value="price_asc" <%= GetSortSelected("price_asc") %>>Giá tăng dần</option>
                                <option value="price_desc" <%= GetSortSelected("price_desc") %>>Giá giảm dần</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row g-3 category-product-grid">
                    <asp:Repeater ID="CategoryProductRepeater" runat="server">
                        <ItemTemplate>
                            <div class="col-6 col-md-4 col-lg-3 product-col">
                                <div class="product-card">
                                    <a class="product-thumb" href="/san-pham/<%# Eval("SeoSlug") %>">
                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                        <%# Eval("SaleBadge") %>
                                    </a>
                                    <button type="button" class="product-wishlist-btn <%# Eval("WishlistClass") %>" data-product-id="<%# Eval("Id") %>" aria-label="ThÃªm vÃ o yÃªu thÃ­ch">
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
                <div class="mt-4">
                    <asp:Literal ID="PaginationLiteral" runat="server" />
                </div>
            </section>
        </div>
    </main>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/js/public-search.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.concat.min.js") %>"></script>
<script src="<%= ResolveUrl("~/public/assets/js/category-filters.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/js/category-wishlist.js") %>"></script>
</asp:Content>



