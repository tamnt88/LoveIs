<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">
<head runat="server">
    <title>BeautyStory</title>
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

        <main class="container py-4">
            <section class="hero-slider mb-4">
                <div class="swiper">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide hero-slide hero-slide-1">
                            <div class="hero-content">
                                <span class="badge">BeautyStory</span>
                                <h2>Chăm sóc da chuẩn spa tại nhà</h2>
                                <p>Khám phá bộ sưu tập sản phẩm mới, ưu đãi tốt mỗi ngày.</p>
                                <a class="btn btn-light" href="#">Mua ngay</a>
                            </div>
                        </div>
                        <div class="swiper-slide hero-slide hero-slide-2">
                            <div class="hero-content">
                                <span class="badge">Ưu đãi</span>
                                <h2>Serum phục hồi da, giảm kích ứng</h2>
                                <p>Gợi ý theo tình trạng da và thành phần nổi bật.</p>
                                <a class="btn btn-light" href="#">Xem thêm</a>
                            </div>
                        </div>
                        <div class="swiper-slide hero-slide hero-slide-3">
                            <div class="hero-content">
                                <span class="badge">Hàng mới</span>
                                <h2>Trang điểm tự nhiên, bền màu</h2>
                                <p>Xu hướng make-up nhẹ nhàng cho mọi loại da.</p>
                                <a class="btn btn-light" href="#">Khám phá</a>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-pagination"></div>
                </div>
            </section>

            <section class="product-section">
                <div class="section-heading">
                    <div>
                        <h4>Sản phẩm mới nhất</h4>
                        <p>Hiển thị 30 sản phẩm mới</p>
                    </div>
                    <a class="btn btn-outline-dark" href="#">Xem tất cả</a>
                </div>
                <div class="row g-3">
                    <asp:Repeater ID="LatestProductRepeater" runat="server">
                        <ItemTemplate>
                            <div class="col-6 col-md-4 col-lg-3">
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
            </section>
        </main>
    </form>
    <script src="/public/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/public/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/public/assets/vendor/swiper/swiper-bundle.min.js"></script>
    <script src="/public/assets/js/public-search.js"></script>
    <script src="/public/assets/vendor/malihu/jquery.mCustomScrollbar.concat.min.js"></script>
    <script>
        (function () {
            new Swiper(".hero-slider .swiper", {
                loop: true,
                speed: 700,
                autoplay: {
                    delay: 4000,
                    disableOnInteraction: false
                },
                pagination: {
                    el: ".hero-slider .swiper-pagination",
                    clickable: true
                }
            });

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
        })();
    </script>
</body>
</html>
