/* global $, window, document */
(function () {
    var $inputs = $(".js-search-input");
    if ($inputs.length === 0) {
        return;
    }

    var pendingRequest = null;
    var debounceTimer = null;

    function renderItems($box, items) {
        if (!items || items.length === 0) {
            $box.html("<div class=\"search-empty\">Không tìm thấy sản phẩm</div>").addClass("show");
            return;
        }

        var html = items.map(function (item) {
            return [
                "<a class=\"search-item\" href=\"/san-pham/",
                item.Slug,
                "\">",
                "<img src=\"",
                item.ImageUrl,
                "\" alt=\"\" />",
                "<div class=\"search-info\">",
                "<div class=\"search-name\">",
                item.Name,
                "</div>",
                "<div class=\"search-price\">",
                item.Price,
                "</div>",
                "</div>",
                "</a>"
            ].join("");
        }).join("");

        $box.html(html).addClass("show");
    }

    function fetchSuggestions(query, $box) {
        if (pendingRequest) {
            pendingRequest.abort();
        }

        pendingRequest = $.ajax({
            url: "/tim-kiem/suggest.aspx",
            data: { q: query },
            cache: true,
            dataType: "json"
        }).done(function (data) {
            renderItems($box, data);
        }).fail(function () {
            $box.removeClass("show");
        });
    }

    function goToSearch(query) {
        if (query.length > 0) {
            window.location.href = "/tim-kiem/default.aspx?q=" + encodeURIComponent(query);
        }
    }

    $inputs.each(function () {
        var $input = $(this);
        var $box = $input.siblings(".search-suggest");

        $input.on("input", function () {
            var query = $input.val().trim();
            clearTimeout(debounceTimer);

            if (query.length < 2) {
                $box.removeClass("show");
                return;
            }

            debounceTimer = setTimeout(function () {
                fetchSuggestions(query, $box);
            }, 200);
        });

        $input.on("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault();
                goToSearch($input.val().trim());
            }
        });

        $input.siblings(".search-submit").on("click", function (event) {
            event.preventDefault();
            goToSearch($input.val().trim());
        });

        $(document).on("click", function (event) {
            if (!$(event.target).closest(".search-box").length) {
                $box.removeClass("show");
            }
        });
    });
})();
