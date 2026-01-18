<%@ Control Language="C#" AutoEventWireup="true" CodeFile="banner.ascx.cs" Inherits="public_controls_trang_chu_new_banner" %>
<asp:Panel ID="BannerPanel" runat="server" CssClass="home-banner-section" Visible="false">
    <div class="container">
        <div class="swiper home-banner-swiper">
            <div class="swiper-wrapper">
                <asp:Repeater ID="BannerRepeater" runat="server">
                    <ItemTemplate>
                        <div class="swiper-slide">
                            <a class="home-banner-link" href="<%# Eval("LinkUrl") %>">
                                <img class="home-banner-image" src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>" />
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="swiper-pagination home-banner-pagination"></div>
        </div>
    </div>
</asp:Panel>
<script type="text/javascript">
    window.addEventListener('load', function () {
        if (typeof Swiper === 'undefined') {
            return;
        }
        function updateBulletWindow(swiper) {
            if (!swiper.pagination || !swiper.pagination.bullets) {
                return;
            }
            var bullets = swiper.pagination.bullets;
            var total = bullets.length;
            if (!total) {
                return;
            }
            var activeIndex = swiper.realIndex || 0;
            var windowSize = Math.min(5, total);
            var start = Math.max(0, activeIndex - Math.floor(windowSize / 2));
            var end = start + windowSize - 1;
            if (end >= total) {
                end = total - 1;
                start = Math.max(0, end - windowSize + 1);
            }
            for (var i = 0; i < total; i++) {
                if (i >= start && i <= end) {
                    bullets[i].classList.remove('is-hidden');
                } else {
                    bullets[i].classList.add('is-hidden');
                }
            }
        }

        var bannerSwiper = new Swiper('.home-banner-swiper', {
            slidesPerView: 4.5,
            spaceBetween: 24,
            loop: true,
            observer: true,
            observeParents: true,
            pagination: {
                el: '.home-banner-pagination',
                clickable: true,
                dynamicBullets: true,
                dynamicMainBullets: 5
            },
            breakpoints: {
                0: { slidesPerView: 1.2, spaceBetween: 12 },
                576: { slidesPerView: 2.2, spaceBetween: 16 },
                768: { slidesPerView: 3, spaceBetween: 18 },
                992: { slidesPerView: 3.5, spaceBetween: 20 },
                1200: { slidesPerView: 4.5, spaceBetween: 24 }
            },
            on: {
                init: function () {
                    updateBulletWindow(this);
                },
                transitionEnd: function () {
                    updateBulletWindow(this);
                }
            }
        });
        bannerSwiper.update();
    });
</script>
