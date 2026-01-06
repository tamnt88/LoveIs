<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BannerHomePage.ascx.cs" Inherits="public_controls_trang_chu_BannerHomePage" %>
<!--==================== Slider Section End ====================-->
<div class="full-row p-0 bg-light">
    <asp:Panel ID="VideoOnlyPanel" runat="server" Visible="false">
        <div class="banner-video-only">
            <video class="banner-video-only__media" autoplay muted loop playsinline controls poster="<%= VideoPosterUrl %>">
                <source src="<%= VideoUrl %>" type="video/mp4" />
            </video>
        </div>
    </asp:Panel>
    <asp:Panel ID="SliderPanel" runat="server" Visible="true">
        <div id="slider" style="width:1200px; height:650px; margin:0 auto; margin-bottom:0px;">
            <asp:Repeater ID="BannerRepeater" runat="server">
                <ItemTemplate>
                    <div class="ls-slide" data-ls="duration:8000; transition2d:4; kenburnsscale:1.2;">
                        <img width="1920" height="750" src='<%# Eval("ImageUrl") %>' class="ls-bg" alt="" style="top:50%; left:50%; text-align:initial; font-weight:400; font-style:normal; text-decoration:none; mix-blend-mode:normal; width:100%;" data-ls="showinfo:1; durationin:2000; easingin:easeOutExpo; scalexin:1.5; scaleyin:1.5; position:fixed;">

                        <%--<p style="width:450px; font-size:80px; line-height:60px; top:40%; left:100px; white-space:normal;" class="ls-l higlight-font font-700 ls-hide-phone text-dark" data-ls="offsetyin:150; durationin:700; delayin:500; easingin:easeOutQuint; rotatexin:20; scalexin:1.4; offsetyout:600; durationout:400; parallaxlevel:0;">
                            <%# Eval("TitleLine2") %>
                        </p>
                        <p style="font-size:14px; letter-spacing: 2px; line-height:20px; top:28%; left:100px;" class="ls-l ordenery-font text-dark text-uppercase font-700 ls-hide-phone" data-ls="offsetyin:150; durationin:700; easingin:easeOutQuint; rotatexin:20; scalexin:1.4; offsetyout:600; durationout:400; parallaxlevel:0;"><%# Eval("TitleLine1") %></p>

                        <p style="width:580px; font-weight:600; font-size:15px; line-height:30px; top:58%; left:120px; white-space:normal;" class="ls-l ls-hide-phone text-dark ordenery-font text-uppercase" data-ls="offsetxin:150; durationin:700; easingin:easeOutBack; rotatexin:20; scalexin:1; offsetyout:600; durationout:400; parallaxlevel:0; delayin:900;"><%# Eval("TitleLine3") %></p>

                        <div style="width:3px; height:60px; border-radius:0; top:58%; left:100px;" class="ls-l ls-hide-phone bg-primary" data-ls="offsetxin:100; easingin:easeOutBack; delayin:700; durationout:400; offsetxout:-20; parallax:false; parallaxlevel:1;"></div>

                        <asp:PlaceHolder ID="LinkWrap" runat="server" Visible='<%# (bool)Eval("ShowLink") %>'>
                            <a class="ls-l ls-hide-phone" href='<%# Eval("LinkUrl") %>' target="_self" data-ls="offsetyin:150; durationin:700; delayin:1200; easingin:easeOutQuint; rotatexin:20; scalexin:1.4; offsetyout:600; durationout:400; hover:true; hoveropacity:1; hoverbgcolor:#e74c3c ; parallaxlevel:0;">
                                <p style="cursor:pointer;padding-top:8px; padding-bottom:8px; font-weight: 500; font-size:14px; top:72%; left:100px; padding-right:25px; padding-left:25px; line-height:28px;" class="bg-dark text-white"><%# Eval("LinkText") %></p>
                            </a>
                        </asp:PlaceHolder>--%>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
    <div class="category-strip">
        <div class="container">
            <div class="category-strip__frame">
                <div class="category-strip__header">
                    <span class="category-strip__title">DANH MỤC</span>
                </div>
                <div class="swiper category-swiper">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <a class="category-card" href="/danh-muc/quan-lot">
                                <img src="/images/danhmuc/1.jpg" alt="Quần lót" />
                                <span class="category-card__label">PANTIES</span>
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a class="category-card" href="/danh-muc/ao-nguc">
                                <img src="/images/danhmuc/2.jpg" alt="Áo ngực" />
                                <span class="category-card__label">BRA</span>
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a class="category-card" href="/danh-muc/do-ngu">
                                <img src="/images/danhmuc/3.jpg" alt="Đồ ngủ" />
                                <span class="category-card__label">SLEEPWEAR</span>
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a class="category-card" href="/danh-muc/bikini">
                                <img src="/images/danhmuc/4.jpg" alt="Bikini" />
                                <span class="category-card__label">BIKINI</span>
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a class="category-card" href="/danh-muc/bo-set">
                                <img src="/images/danhmuc/5.jpg" alt="Bộ sưu tập" />
                                <span class="category-card__label">COLLECTION</span>
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a class="category-card" href="/khuyen-mai">
                                <img src="/images/danhmuc/6.jpg" alt="Khuyến mãi" />
                                <span class="category-card__label">SALE</span>
                            </a>
                        </div>
                    </div>
                    <div class="swiper-button-prev category-swiper-prev"></div>
                    <div class="swiper-button-next category-swiper-next"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--==================== Slider Section End ====================-->
<link rel="stylesheet" href="/public/assets/vendor/swiper/swiper-bundle.min.css" />
<script src="/public/assets/vendor/swiper/swiper-bundle.min.js"></script>
<script>
    (function () {
        var el = document.querySelector(".category-swiper");
        if (!el || typeof Swiper === "undefined") {
            return;
        }
        new Swiper(el, {
            slidesPerView: 3,
            spaceBetween: 18,
            navigation: {
                nextEl: ".category-swiper-next",
                prevEl: ".category-swiper-prev"
            },
            breakpoints: {
                640: { slidesPerView: 2 },
                992: { slidesPerView: 3 },
                1200: { slidesPerView: 6 }
            }
        });
    })();
</script>
