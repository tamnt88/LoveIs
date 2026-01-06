<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ProductDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.min.css") %>" rel="stylesheet" />
    <script src="<%= ResolveUrl("~/public/assets/js/product-detail.js") %>" defer></script>
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
    <asp:Literal ID="SocialMetaLiteral" runat="server" />
    <asp:Literal ID="SchemaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 product-detail">
        <div class="product-breadcrumb">
            <asp:Literal ID="CategoryPath" runat="server" />
        </div>
        <div class="row g-4">
            <div class="col-lg-9">
                <div class="product-main-card">
                    <div class="row g-4">
                        <div class="col-lg-6">
                            <div class="product-gallery">
                                <div class="product-gallery-wrap">
                                    <div class="swiper product-gallery-thumbs">
                                        <div class="swiper-wrapper">
                                            <asp:Repeater ID="ThumbRepeater" runat="server">
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
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="product-info">
                                <div class="supplier-tags">
                                    <asp:HyperLink ID="SupplierLink" runat="server" CssClass="supplier-pill" />
                                    <asp:HyperLink ID="OriginLink" runat="server" CssClass="supplier-pill origin-pill" />
                                    <asp:HyperLink ID="ShopLink" runat="server" CssClass="supplier-pill shop-pill" />
                                </div>
                                <asp:HyperLink ID="ShopViewLink" Visible="false" runat="server" CssClass="shop-view-link" />
                                <h1 class="product-name"><asp:Literal ID="ProductNameLiteral" runat="server" /></h1>
                                <div class="product-meta">
                                    <span class="rating-badge">4.9★</span>
                                    <span>28 đánh giá</span>
                                    <span class="meta-sep">|</span>
                                    <span>SKU: <span id="SkuValue"><asp:Literal ID="SkuLiteral" runat="server" /></span></span>
                                </div>
                                <div class="product-price-detail">
                                    <span id="PriceValue"><asp:Literal ID="PriceLiteral" runat="server" /></span>
                                </div>
                                <div class="product-variants">
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
                                    <div class="qty-control">
                                        <span class="qty-label">Số lượng:</span>
                                        <button type="button" class="qty-btn" data-action="minus">−</button>
                                        <input type="text" class="qty-input" value="1" />
                                        <button type="button" class="qty-btn" data-action="plus">+</button>
                                    </div>
                                    <asp:HiddenField ID="SelectedVariantId" runat="server" />
                                    <asp:HiddenField ID="SelectedQuantity" runat="server" Value="1" />
                                    <asp:LinkButton ID="AddToCartButton" runat="server" CssClass="btn btn-cart" OnClick="AddToCartButton_Click">
                                        <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                                    </asp:LinkButton>
                                    <%--<button type="button" class="btn btn-favorite">
                                        <i class="fa-regular fa-heart"></i> Yêu thích
                                    </button>--%>
                                </div>
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
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-spec" type="button" role="tab">Đánh giá</button>
                        </li>
                        <%--<li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-ing" type="button" role="tab">Thành phần</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-use" type="button" role="tab">HDSD</button>
                        </li>--%>
                    </ul>
                    <div class="tab-content p-3 bg-white border border-top-0">
                        <div class="tab-pane fade show active" id="tab-desc" role="tabpanel">
                            <div class="tab-body js-tab-body">
                                <div class="tab-body-content">
                                    <asp:Literal ID="Description" runat="server" />
                                </div>
                                <button type="button" class="tab-toggle">Xem thêm</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tab-spec" role="tabpanel">
                            <div class="tab-body js-tab-body">
                                <div class="tab-body-content">
                                    <asp:Literal ID="Specification" runat="server" />
                                </div>
                                <button type="button" class="tab-toggle">Xem thêm</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tab-ing" role="tabpanel" style="display:none;">
                            <div class="tab-body js-tab-body">
                                <div class="tab-body-content">
                                    <asp:Literal ID="Ingredients" runat="server" />
                                </div>
                                <button type="button" class="tab-toggle">Xem thêm</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tab-use" role="tabpanel" style="display:none;">
                            <div class="tab-body js-tab-body">
                                <div class="tab-body-content">
                                    <asp:Literal ID="Usage" runat="server" />
                                </div>
                                <button type="button" class="tab-toggle">Xem thêm</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <aside class="col-lg-3">
                <div class="product-sidecard" style="display:none;">
                    <div class="shipping-card">
                        <div class="shipping-title">Miễn phí vận chuyển</div>
                        <div class="shipping-list">
                            <div class="shipping-item">
                                <img src="/public/assets/icon/1.png" alt="Giao nhanh 2H" />
                                <div>
                                    <div class="shipping-main">Giao nhanh miễn phí 2H.</div>
                                    <div class="shipping-sub">Trễ tặng 100K</div>
                                </div>
                            </div>
                            <div class="shipping-item">
                                <img src="/public/assets/icon/2.png" alt="Hàng chính hãng" />
                                <div>
                                    <div class="shipping-main">Cam kết 100% hàng chính hãng</div>
                                    <div class="shipping-sub">Đền bù 100% nếu phát hiện hàng giả</div>
                                </div>
                            </div>
                            <div class="shipping-item">
                                <img src="/public/assets/icon/3.png" alt="Giao hàng miễn phí" />
                                <div>
                                    <div class="shipping-main">Giao hàng miễn phí</div>
                                    <div class="shipping-sub">Từ 690K tại 34 tỉnh thành</div>
                                </div>
                            </div>
                            <div class="shipping-item">
                                <img src="/public/assets/icon/4.png" alt="Đổi trả 30 ngày" />
                                <div>
                                    <div class="shipping-main">Đổi trả trong 30 ngày</div>
                                    <div class="shipping-sub">Dễ dàng, nhanh chóng</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%--<div class="product-sidecard">
                    <div class="sidecard-brand">
                        <img src="/images/logo_doc.png" alt="Brand Logo" />
                        <div class="sidecard-brand-actions">
                            <button type="button" class="btn btn-outline-dark btn-sm">Theo dõi</button>
                            <span class="brand-badge">25K</span>
                        </div>
                    </div>
                </div>--%>
                <div class="product-sidecard">
                    <div class="sidecard-title">Sản phẩm xem cùng</div>
                    <div class="sidecard-related">
                        <asp:Repeater ID="RelatedRepeater" runat="server">
                            <ItemTemplate>
                                <a class="related-item" href="<%# Eval("Url") %>">
                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                    <div>
                                        <div class="related-name"><%# Eval("ProductName") %></div>
                                        <div class="related-price"><%# Eval("PriceHtml") %></div>
                                    </div>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                <div class="product-sidecard">
                    <div class="sidecard-title">Sản phẩm cùng thương hiệu</div>
                    <div class="sidecard-related">
                        <asp:Repeater ID="BrandRelatedRepeater" runat="server">
                            <ItemTemplate>
                                <a class="related-item" href="<%# Eval("Url") %>">
                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                    <div>
                                        <div class="related-name"><%# Eval("ProductName") %></div>
                                        <div class="related-price"><%# Eval("PriceHtml") %></div>
                                    </div>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
        <section class="suggested-products container">
            <div class="suggested-card">
                <div class="suggested-title">Có thể bạn thích</div>
                <div class="swiper suggested-swiper">
                    <div class="swiper-wrapper">
                        <asp:Repeater ID="SuggestedRepeater" runat="server">
                            <ItemTemplate>
                                <div class="swiper-slide">
                                    <a class="suggested-item" href="<%# Eval("Url") %>">
                                        <div class="suggested-image">
                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                            <%# Eval("SaleBadge") %>
                                        </div>
                                        <div class="suggested-name"><%# Eval("ProductName") %></div>
                                        <div class="suggested-price"><%# Eval("PriceHtml") %></div>
                                    </a>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="swiper-button-prev suggested-prev"></div>
                    <div class="swiper-button-next suggested-next"></div>
                </div>
            </div>
        </section>
    </main>
</asp:Content>
<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ResolveUrl("~/public/assets/vendor/swiper/swiper-bundle.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/vendor/malihu/jquery.mCustomScrollbar.concat.min.js") %>"></script>
    <script>
        (function () {
            var thumbSwiper = new Swiper(".product-gallery-thumbs", {
                direction: "vertical",
                slidesPerView: 4,
                spaceBetween: 10,
                watchSlidesProgress: true,
                navigation: {
                    nextEl: ".product-gallery-thumbs .swiper-button-next",
                    prevEl: ".product-gallery-thumbs .swiper-button-prev"
                }
            });
            var mainSwiper = new Swiper(".product-gallery-main", {
                slidesPerView: 1,
                spaceBetween: 10,
                navigation: {
                    nextEl: ".product-gallery-main .swiper-button-next",
                    prevEl: ".product-gallery-main .swiper-button-prev"
                },
                thumbs: {
                    swiper: thumbSwiper
                }
            });
            var suggestedSwiper = new Swiper(".suggested-swiper", {
                slidesPerView: 5.5,
                spaceBetween: 16,
                grabCursor: true,
                navigation: {
                    nextEl: ".suggested-next",
                    prevEl: ".suggested-prev"
                },
                breakpoints: {
                    0: { slidesPerView: 1.3, spaceBetween: 12 },
                    576: { slidesPerView: 2.2, spaceBetween: 14 },
                    768: { slidesPerView: 3.2, spaceBetween: 14 },
                    992: { slidesPerView: 4.2, spaceBetween: 16 },
                    1200: { slidesPerView: 5.5, spaceBetween: 16 }
                }
            });
        })();
    </script>
    <script>
        (function () {
            var priceMap = <%= string.IsNullOrWhiteSpace(VariantPriceJson) ? "{}" : VariantPriceJson %>;
            var skuMap = <%= string.IsNullOrWhiteSpace(VariantSkuJson) ? "{}" : VariantSkuJson %>;
            var idMap = <%= string.IsNullOrWhiteSpace(VariantIdJson) ? "{}" : VariantIdJson %>;
            var priceEl = document.getElementById("PriceValue");
            var skuEl = document.getElementById("SkuValue");
            var addBtn = document.getElementById("<%= AddToCartButton.ClientID %>");
            var hidden = document.getElementById("<%= SelectedVariantId.ClientID %>");

            function setButtonEnabled(enabled) {
                if (!addBtn) {
                    return;
                }
                if (enabled) {
                    addBtn.classList.remove("disabled");
                    addBtn.removeAttribute("aria-disabled");
                    addBtn.removeAttribute("tabindex");
                } else {
                    addBtn.classList.add("disabled");
                    addBtn.setAttribute("aria-disabled", "true");
                    addBtn.setAttribute("tabindex", "-1");
                }
            }

            function ensureDefaults() {
                document.querySelectorAll(".variant-group").forEach(function (group) {
                    var active = group.querySelector(".variant-pill.active");
                    if (!active) {
                        var first = group.querySelector(".variant-pill");
                        if (first) {
                            first.classList.add("active");
                        }
                    }
                });
            }

            function buildKey() {
                var parts = [];
                var valid = true;
                document.querySelectorAll(".variant-group").forEach(function (group) {
                    var active = group.querySelector(".variant-pill.active");
                    if (!active) {
                        valid = false;
                        return;
                    }
                    var attrId = active.getAttribute("data-attrid");
                    var valId = active.getAttribute("data-valid");
                    parts.push(attrId + ":" + valId);
                });
                if (!valid) {
                    return null;
                }
                parts.sort(function (a, b) {
                    return parseInt(a.split(":")[0], 10) - parseInt(b.split(":")[0], 10);
                });
                return parts.join("|");
            }

            function updateSelection() {
                ensureDefaults();
                var key = buildKey();
                if (key && priceMap[key]) {
                    if (priceEl) {
                        priceEl.innerHTML = priceMap[key];
                    }
                    if (skuEl) {
                        skuEl.textContent = skuMap[key] || "-";
                    }
                    if (hidden) {
                        hidden.value = idMap[key] || "";
                    }
                    setButtonEnabled(true);
                    return;
                }

                if (priceEl) {
                    priceEl.textContent = "Liên hệ";
                }
                if (skuEl) {
                    skuEl.textContent = "-";
                }
                if (hidden) {
                    hidden.value = "";
                }
                setButtonEnabled(false);
            }

            document.querySelectorAll(".js-variant-value").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var group = btn.closest(".variant-group");
                    if (!group) {
                        return;
                    }
                    group.querySelectorAll(".variant-pill").forEach(function (pill) {
                        pill.classList.remove("active");
                    });
                    btn.classList.add("active");
                    updateSelection();
                });
            });

            if (addBtn) {
                addBtn.addEventListener("click", function (event) {
                    if (addBtn.classList.contains("disabled")) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                });
            }

            updateSelection();
        })();
    </script>
    <script>
        (function () {
            var qtyInput = document.querySelector(".qty-input");
            var qtyHidden = document.getElementById("<%= SelectedQuantity.ClientID %>");
            if (!qtyInput) {
                return;
            }

            function clamp(value) {
                var num = parseInt(value, 10);
                if (isNaN(num) || num < 1) {
                    return 1;
                }
                if (num > 99) {
                    return 99;
                }
                return num;
            }

            document.querySelectorAll(".qty-btn").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var current = clamp(qtyInput.value);
                    var action = btn.getAttribute("data-action");
                    qtyInput.value = action === "plus" ? current + 1 : Math.max(1, current - 1);
                    if (qtyHidden) {
                        qtyHidden.value = qtyInput.value;
                    }
                });
            });

            qtyInput.addEventListener("input", function () {
                qtyInput.value = qtyInput.value.replace(/[^0-9]/g, "");
            });

            qtyInput.addEventListener("blur", function () {
                qtyInput.value = clamp(qtyInput.value);
                if (qtyHidden) {
                    qtyHidden.value = qtyInput.value;
                }
            });
        })();
    </script>
</asp:Content>
