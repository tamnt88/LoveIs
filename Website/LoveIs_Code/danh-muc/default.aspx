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
    <main class="container py-4 category-page">
        <div class="category-hero mb-4">
            <div class="category-hero-banner">
                <asp:Image ID="CategoryBannerImage" runat="server" CssClass="img-fluid w-100" AlternateText="Category Banner" />
                <div class="category-hero-overlay">
                    <h1 class="category-hero-title"><asp:Literal ID="CategoryTitleTop" runat="server" /></h1>
                </div>
            </div>
        </div>
        <div class="row g-4">
            <aside class="col-lg-3 order-2 order-lg-1">
                <div class="category-sidebar">
                    <h6 class="mb-3 sidebar-heading"><i class="fa-solid fa-list"></i><span>Tất cả Danh mục</span></h6>
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
                </div>
                <div class="filter-sidebar">
                    <h6 class="mb-3 sidebar-heading"><i class="fa-solid fa-filter"></i><span>Bộ lọc</span></h6>
                    <asp:Repeater ID="FilterGroupRepeater" runat="server">
                        <ItemTemplate>
                            <div class="filter-group">
                                <div class="filter-title"><%# Eval("GroupName") %></div>
                                <div class="filter-options">
                                    <asp:Repeater ID="FilterOptionRepeater" runat="server" DataSource='<%# Eval("Options") %>'>
                                        <ItemTemplate>
                                            <label class="filter-option">
                                                <input type="checkbox" class="js-filter-option" value="<%# Eval("Id") %>" <%# Eval("Checked") %> />
                                                <span><%# Eval("OptionName") %></span>
                                            </label>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <h6 class="mb-3 mt-4 sidebar-heading"><i class="fa-solid fa-tags"></i><span>Thuộc tính</span></h6>
                    <asp:Repeater ID="AttributeGroupRepeater" runat="server">
                        <ItemTemplate>
                            <div class="filter-group">
                                <div class="filter-title"><%# Eval("AttributeName") %></div>
                                <div class="filter-options">
                                    <asp:Repeater ID="AttributeValueRepeater" runat="server" DataSource='<%# Eval("Values") %>'>
                                        <ItemTemplate>
                                            <label class="filter-option">
                                                <input type="checkbox" class="js-filter-attr" value="<%# Eval("Id") %>" <%# Eval("Checked") %> />
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
            <section class="col-lg-9 order-1 order-lg-2">
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
                <div class="row g-3">
                    <asp:Repeater ID="CategoryProductRepeater" runat="server">
                        <ItemTemplate>
                            <div class="col-6 col-md-4 col-lg-3">
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
            </section>
        </div>
    </main>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/js/public-search.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.concat.min.js") %>"></script>
    <script>
        (function () {
            var categoryParents = document.querySelectorAll(".category-parent");
            var categoryPanels = document.querySelectorAll(".category-panel");

            function activatePanel(targetId) {
                categoryParents.forEach(function (item) {
                    item.classList.toggle("active", item.getAttribute("data-target") === targetId);
                });
                categoryPanels.forEach(function (panel) {
                    panel.classList.toggle("active", panel.id === targetId);
                });
            }

            categoryParents.forEach(function (item) {
                item.addEventListener("mouseenter", function () {
                    var targetId = item.getAttribute("data-target");
                    activatePanel(targetId);
                });
            });

            var categoryBar = document.querySelector(".category-bar");
            if (categoryBar) {
                categoryBar.addEventListener("mouseenter", function () {
                    var left = document.querySelector(".category-left");
                    var right = document.querySelector(".category-right");
                    if (!left || !right) {
                        return;
                    }
                    right.style.height = left.offsetHeight + "px";
                    $(".category-scroll").mCustomScrollbar("destroy");
                    $(".category-scroll").mCustomScrollbar({
                        theme: "minimal-dark",
                        scrollInertia: 120,
                        mouseWheel: { preventDefault: true }
                    });
                });
            }

            document.querySelectorAll(".toggle-btn").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var group = btn.closest(".sidebar-group");
                    if (group) {
                        group.classList.toggle("open");
                    }
                });
            });

            function collectValues(selector) {
                var values = [];
                document.querySelectorAll(selector).forEach(function (input) {
                    if (input.checked) {
                        values.push(input.value);
                    }
                });
                return values.join(",");
            }

            function applyFilters() {
                var url = new URL(window.location.href);
                var filterValues = collectValues(".js-filter-option");
                var attrValues = collectValues(".js-filter-attr");
                if (filterValues) {
                    url.searchParams.set("filters", filterValues);
                } else {
                    url.searchParams.delete("filters");
                }
                if (attrValues) {
                    url.searchParams.set("attrs", attrValues);
                } else {
                    url.searchParams.delete("attrs");
                }
                window.location.href = url.toString();
            }

            document.querySelectorAll(".js-filter-option, .js-filter-attr").forEach(function (input) {
                input.addEventListener("change", applyFilters);
            });
        })();
    </script>
</asp:Content>
