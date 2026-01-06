<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ProductDefault" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">
<head runat="server">
    <title>Chi tiết sản phẩm | BeautyStory</title>
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

        <main class="container py-4 product-detail">
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="product-gallery">
                        <div class="swiper product-gallery-main">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="<%= MainImageUrl %>" alt="<%= ProductName %>" />
                                </div>
                                <asp:Repeater ID="ImageRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="swiper-slide">
                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>" />
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="swiper-button-prev"></div>
                            <div class="swiper-button-next"></div>
                        </div>
                        <div class="swiper product-gallery-thumbs">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="<%= MainImageUrl %>" alt="<%= ProductName %>" />
                                </div>
                                <asp:Repeater ID="ThumbRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="swiper-slide">
                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>" />
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="product-info">
                        <div class="product-breadcrumb">
                            <asp:Literal ID="CategoryPath" runat="server" />
                        </div>
                        <h2 class="product-name"><asp:Literal ID="ProductNameLiteral" runat="server" /></h2>
                        <div class="product-meta">
                            <span><i class="fa-regular fa-circle-check"></i> Hàng chính hãng</span>
                            <span><i class="fa-regular fa-star"></i> Đánh giá tốt</span>
                        </div>
                        <div class="product-price-detail">
                            <asp:Literal ID="PriceLiteral" runat="server" />
                        </div>
                        <div class="product-variants">
                            <h6>Biến thể</h6>
                            <asp:Repeater ID="VariantAttributeRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="variant-group">
                                        <div class="variant-label"><%# Eval("AttributeName") %></div>
                                        <div class="variant-list">
                                            <asp:Repeater ID="VariantValueRepeater" runat="server" DataSource='<%# Eval("Values") %>'>
                                                <ItemTemplate>
                                                    <button type="button" class="variant-pill js-variant-value <%# Eval("ActiveClass") %>" data-attrid="<%# Eval("AttributeId") %>" data-valid="<%# Eval("ValueId") %>">
                                                        <%# Eval("ValueName") %>
                                                    </button>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="product-actions">
                            <asp:HiddenField ID="SelectedVariantId" runat="server" />
                            <asp:Button ID="AddToCartButton" runat="server" CssClass="btn btn-dark" Text="Thêm vào giỏ" OnClick="AddToCartButton_Click" />
                            <button type="button" class="btn btn-outline-dark">Yêu thích</button>
                        </div>
                        <div class="product-summary">
                            <h6>Mô tả ngắn</h6>
                            <asp:Literal ID="ShortDescription" runat="server" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="product-tabs mt-4">
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-desc" type="button" role="tab">Mô tả</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-spec" type="button" role="tab">Thông số</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-ing" type="button" role="tab">Thành phần</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-use" type="button" role="tab">HDSD</button>
                    </li>
                </ul>
                <div class="tab-content p-3 bg-white border border-top-0">
                    <div class="tab-pane fade show active" id="tab-desc" role="tabpanel">
                        <asp:Literal ID="Description" runat="server" />
                    </div>
                    <div class="tab-pane fade" id="tab-spec" role="tabpanel">
                        <asp:Literal ID="Specification" runat="server" />
                    </div>
                    <div class="tab-pane fade" id="tab-ing" role="tabpanel">
                        <asp:Literal ID="Ingredients" runat="server" />
                    </div>
                    <div class="tab-pane fade" id="tab-use" role="tabpanel">
                        <asp:Literal ID="Usage" runat="server" />
                    </div>
                </div>
            </div>
        </main>
    </form>
    <script src="/public/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/public/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/public/assets/js/public-search.js"></script>
    <script src="/public/assets/vendor/swiper/swiper-bundle.min.js"></script>
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

            var priceEl = document.querySelector(".product-price-detail");
            var addToCartBtn = document.getElementById("<%= AddToCartButton.ClientID %>");
            var priceMap = JSON.parse('<%= System.Web.HttpUtility.JavaScriptStringEncode(string.IsNullOrWhiteSpace(VariantPriceJson) ? "{}" : VariantPriceJson) %>');
            var variantMap = JSON.parse('<%= System.Web.HttpUtility.JavaScriptStringEncode(string.IsNullOrWhiteSpace(VariantIdJson) ? "{}" : VariantIdJson) %>');
            var selectedVariantInput = document.getElementById("<%= SelectedVariantId.ClientID %>");

            function updatePriceBySelection() {
                var groups = {};
                document.querySelectorAll(".js-variant-value.active").forEach(function (btn) {
                    groups[btn.dataset.attrid] = btn.dataset.valid;
                });

                var keys = Object.keys(groups).sort(function (a, b) {
                    return parseInt(a, 10) - parseInt(b, 10);
                });
                var parts = keys.map(function (k) { return k + ":" + groups[k]; });
                var key = parts.join("|");
                if (priceEl) {
                    priceEl.textContent = priceMap[key] || "Liên hệ";
                }
                if (addToCartBtn) {
                    addToCartBtn.disabled = !priceMap[key];
                    addToCartBtn.classList.toggle("disabled", !priceMap[key]);
                }
                if (selectedVariantInput) {
                    selectedVariantInput.value = variantMap[key] || "";
                }
            }

            document.querySelectorAll(".js-variant-value").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var attrId = btn.dataset.attrid;
                    document.querySelectorAll(".js-variant-value[data-attrid=\"" + attrId + "\"]").forEach(function (item) {
                        item.classList.remove("active");
                    });
                    btn.classList.add("active");
                    updatePriceBySelection();
                });
            });

            updatePriceBySelection();

            var thumbSwiper = new Swiper(".product-gallery-thumbs", {
                slidesPerView: 4,
                spaceBetween: 12,
                watchSlidesProgress: true,
                breakpoints: {
                    0: { slidesPerView: 3 },
                    576: { slidesPerView: 4 }
                }
            });

            new Swiper(".product-gallery-main", {
                spaceBetween: 10,
                loop: true,
                thumbs: { swiper: thumbSwiper },
                navigation: {
                    nextEl: ".product-gallery-main .swiper-button-next",
                    prevEl: ".product-gallery-main .swiper-button-prev"
                }
            });
        })();
    </script>
</body>
</html>
