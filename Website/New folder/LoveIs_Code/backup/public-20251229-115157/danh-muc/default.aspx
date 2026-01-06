<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CategoryDefault" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">
<head runat="server">
    <title>Danh mục | BeautyStory</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="/public/assets/css/roboto.css" rel="stylesheet" />
    <link href="/public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/public/assets/vendor/fontawesome/css/all.min.css" rel="stylesheet" />
    <link href="/public/assets/vendor/flaticon/css/all.css" rel="stylesheet" />
    <link href="/public/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet" />
    <link href="/public/assets/vendor/malihu/jquery.mCustomScrollbar.min.css" rel="stylesheet" />
    <link href="/public/assets/css/public.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <header class="site-header">
            <div class="container header-top">
                <div class="brand">
                    <img src="/images/logo_ngang.png" alt="BeautyStory" />
                    <div class="brand-text">Mỹ phẩm &amp; làm đẹp chính hãng</div>
                </div>
                    <div class="header-actions">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" class="js-search-input" placeholder="Tìm sản phẩm..." autocomplete="off" />
                            <div class="search-suggest"></div>
                        </div>
                        <a class="btn btn-outline-dark" href="/gio-hang/default.aspx">
                            <i class="fa-solid fa-cart-shopping me-1"></i> Giỏ hàng
                        </a>
                        <a class="btn btn-outline-dark" href="/admin/login.aspx">
                            <i class="fa-solid fa-lock me-1"></i> Quản trị
                        </a>
                    </div>
                </div>
            <nav class="category-nav">
                <div class="container">
                    <div class="category-bar">
                        <div class="category-toggle">
                            <i class="fa-solid fa-bars"></i>
                            <span>Danh mục</span>
                        </div>
                        <div class="category-dropdown">
                            <div class="category-left">
                                <asp:Repeater ID="CategoryMenuRepeater" runat="server">
                                    <ItemTemplate>
                                        <a class="category-parent <%# GetMenuItemActiveClass(Container.ItemIndex) %>" data-target="cat-panel-<%# Container.ItemIndex %>" href="/danh-muc/default.aspx?slug=<%# Eval("SeoSlug") %>">
                                            <%# Eval("CategoryName") %>
                                            <span class="chevron"><i class="fa-solid fa-angle-right"></i></span>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="category-right">
                                <div class="category-scroll">
                                <asp:Repeater ID="CategoryPanelRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="category-panel <%# GetPanelActiveClass(Container.ItemIndex) %>" id="cat-panel-<%# Container.ItemIndex %>">
                                            <h6><%# Eval("CategoryName") %></h6>
                                            <ul class="panel-links">
                                                <asp:Repeater ID="ChildPanelRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                                    <ItemTemplate>
                                                        <li class="panel-group">
                                                            <a class="panel-title" href="/danh-muc/default.aspx?slug=<%# Eval("SeoSlug") %>"><%# Eval("CategoryName") %></a>
                                                            <ul class="panel-sub">
                                                                <asp:Repeater ID="GrandChildPanelRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                                                    <ItemTemplate>
                                                                        <li>
                                                                            <a href="/danh-muc/default.aspx?slug=<%# Eval("SeoSlug") %>"><%# Eval("CategoryName") %></a>
                                                                        </li>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </ul>
                                                        </li>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </ul>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </header>

        <main class="container py-4 category-page">
            <div class="row g-4">
                <aside class="col-lg-3">
                    <div class="category-sidebar">
                        <h6 class="mb-3">Danh mục</h6>
                        <asp:Repeater ID="SidebarRepeater" runat="server">
                            <ItemTemplate>
                                <div class="sidebar-group <%# GetSidebarOpenClass(Eval("IsOpen")) %>">
                                    <div class="sidebar-row">
                                        <a class="sidebar-parent <%# GetSidebarActiveClass(Eval("Id")) %>" href="/danh-muc/default.aspx?slug=<%# Eval("SeoSlug") %>">
                                            <%# Eval("CategoryName") %>
                                        </a>
                                        <button type="button" class="toggle-btn <%# GetToggleVisibleClass(Eval("HasChildren")) %>">
                                            <i class="fa-solid fa-angle-down"></i>
                                        </button>
                                    </div>
                                    <div class="sidebar-children">
                                        <asp:Repeater ID="SidebarChildRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                            <ItemTemplate>
                                                <div class="sidebar-group level-2 <%# GetSidebarOpenClass(Eval("IsOpen")) %>">
                                                    <div class="sidebar-row">
                                                        <a class="sidebar-child <%# GetSidebarActiveClass(Eval("Id")) %>" href="/danh-muc/default.aspx?slug=<%# Eval("SeoSlug") %>">
                                                            <%# Eval("CategoryName") %>
                                                        </a>
                                                        <button type="button" class="toggle-btn <%# GetToggleVisibleClass(Eval("HasChildren")) %>">
                                                            <i class="fa-solid fa-angle-down"></i>
                                                        </button>
                                                    </div>
                                                    <div class="sidebar-children">
                                                        <asp:Repeater ID="SidebarGrandChildRepeater" runat="server" DataSource='<%# Eval("Children") %>'>
                                                            <ItemTemplate>
                                                                <a class="sidebar-child level-3 <%# GetSidebarActiveClass(Eval("Id")) %>" href="/danh-muc/default.aspx?slug=<%# Eval("SeoSlug") %>">
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
                        <h6 class="mb-3">Bộ lọc</h6>
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
                        <h6 class="mb-3 mt-4">Thuộc tính</h6>
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
                <section class="col-lg-9">
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
                                <div class="col-6 col-md-4">
                                    <div class="product-card">
                                        <div class="product-thumb">
                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                        </div>
                                        <div class="product-body">
                                            <div class="product-category"><%# Eval("CategoryName") %></div>
                                            <h6 class="product-title"><%# Eval("ProductName") %></h6>
                                            <div class="product-price"><%# Eval("PriceLabel") %></div>
                                        </div>
                                        <div class="product-footer">
                                        <a class="btn btn-sm btn-dark w-100" href="/san-pham/default.aspx?slug=<%# Eval("SeoSlug") %>">
                                                Xem chi tiết
                                            </a>
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
    </form>
    <script src="/public/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/public/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/public/assets/vendor/swiper/swiper-bundle.min.js"></script>
    <script src="/public/assets/js/public-search.js"></script>
    <script src="/public/assets/vendor/malihu/jquery.mCustomScrollbar.concat.min.js"></script>
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

            function syncMenuHeight() {
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
            }

            var categoryBar = document.querySelector(".category-bar");
            if (categoryBar) {
                categoryBar.addEventListener("mouseenter", syncMenuHeight);
                window.addEventListener("resize", syncMenuHeight);
            }

            document.querySelectorAll(".category-sidebar .toggle-btn").forEach(function (btn) {
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
</body>
</html>
