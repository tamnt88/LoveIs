(function () {
    function initLayerSlider() {
        if (!window.jQuery || !jQuery('#slider').length) {
            return;
        }
        jQuery('#slider').layerSlider({
            sliderVersion: '6.0.0',
            type: 'fullwidth',
            responsiveUnder: 0,
            layersContainer: 1200,
            hideUnder: 0,
            hideOver: 100000,
            skin: 'v6',
            globalBGColor: '#ffffff',
            navStartStop: false,
            skinsPath: '/public/theme/assets/skins/',
            height: 650
        });
    }

    function initNewArrival() {
        var el = document.querySelector('.new-arrival-swiper');
        if (!el || typeof Swiper === 'undefined') {
            return;
        }
        new Swiper(el, {
            slidesPerView: 5.5,
            spaceBetween: 16,
            navigation: {
                nextEl: '.new-arrival-next',
                prevEl: '.new-arrival-prev'
            },
            breakpoints: {
                0: { slidesPerView: 1.2, spaceBetween: 12 },
                576: { slidesPerView: 2.2, spaceBetween: 14 },
                768: { slidesPerView: 3.2, spaceBetween: 16 },
                992: { slidesPerView: 4.2, spaceBetween: 16 },
                1200: { slidesPerView: 5.5, spaceBetween: 16 }
            }
        });
    }

    function initCategorySwiper() {
        var el = document.querySelector('.category-swiper');
        if (!el || typeof Swiper === 'undefined') {
            return;
        }
        new Swiper(el, {
            slidesPerView: 3,
            spaceBetween: 18,
            navigation: {
                nextEl: '.category-swiper-next',
                prevEl: '.category-swiper-prev'
            },
            breakpoints: {
                640: { slidesPerView: 2 },
                992: { slidesPerView: 3 },
                1200: { slidesPerView: 6 }
            }
        });
    }

    function initBannerTwo() {
        var el = document.querySelector('.banner-two-swiper');
        if (!el || typeof Swiper === 'undefined') {
            return;
        }
        new Swiper(el, {
            slidesPerView: 1,
            spaceBetween: 0,
            navigation: {
                nextEl: '.banner-two-next',
                prevEl: '.banner-two-prev'
            },
            loop: true
        });
    }

    function initBestSelling() {
        var el = document.querySelector('.best-selling-swiper');
        if (!el || typeof Swiper === 'undefined') {
            return;
        }
        new Swiper(el, {
            slidesPerView: 4.5,
            spaceBetween: 20,
            navigation: {
                nextEl: '.best-selling-next',
                prevEl: '.best-selling-prev'
            },
            breakpoints: {
                0: { slidesPerView: 1.1, spaceBetween: 12 },
                576: { slidesPerView: 2.1, spaceBetween: 14 },
                768: { slidesPerView: 3.1, spaceBetween: 16 },
                992: { slidesPerView: 4.1, spaceBetween: 18 },
                1200: { slidesPerView: 4.5, spaceBetween: 20 }
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        initLayerSlider();
        initNewArrival();
        initCategorySwiper();
        initBannerTwo();
        initBestSelling();
    });
})();
