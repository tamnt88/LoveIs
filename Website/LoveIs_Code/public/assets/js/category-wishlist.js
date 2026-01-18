(function () {
    var page = document.querySelector(".category-page");
    if (!page) {
        return;
    }

    var endpoint = page.getAttribute("data-wishlist-endpoint");
    if (!endpoint) {
        return;
    }

    function handleResult(btn, result) {
        if (!result || !result.success) {
            if (result && result.requiresLogin && result.loginUrl) {
                window.location.href = result.loginUrl;
            }
            return;
        }
        btn.classList.toggle("is-active", !!result.liked);
        var icon = btn.querySelector("i");
        if (icon) {
            icon.classList.toggle("fa-solid", !!result.liked);
            icon.classList.toggle("fa-regular", !result.liked);
        }
    }

    function postWishlist(productId, btn) {
        fetch(endpoint, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: JSON.stringify({ productId: productId })
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Request failed");
                }
                return response.json();
            })
            .then(function (payload) {
                var result = payload && payload.d ? payload.d : payload;
                handleResult(btn, result);
            })
            .catch(function () {
                btn.disabled = false;
            })
            .finally(function () {
                btn.disabled = false;
            });
    }

    document.querySelectorAll(".product-wishlist-btn").forEach(function (btn) {
        btn.addEventListener("click", function (event) {
            event.preventDefault();
            event.stopPropagation();
            var productId = parseInt(btn.getAttribute("data-product-id"), 10);
            if (!productId) {
                return;
            }
            btn.disabled = true;
            postWishlist(productId, btn);
        });
    });
})();
