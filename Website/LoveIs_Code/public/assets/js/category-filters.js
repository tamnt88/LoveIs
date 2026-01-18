(function () {
    function onReady(callback) {
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", callback);
        } else {
            callback();
        }
    }

    onReady(function () {
        document.querySelectorAll(".filter-toggle-btn").forEach(function (header) {
            header.addEventListener("click", function (event) {
                event.preventDefault();
                var group = header.closest(".filter-group");
                if (group) {
                    group.classList.toggle("is-collapsed");
                }
            });
        });

        document.querySelectorAll(".filter-group").forEach(function (group, index) {
            if (index > 0 && !group.classList.contains("is-collapsed")) {
                group.classList.add("is-collapsed");
            }
        });

        document.querySelectorAll(".sidebar-group .toggle-btn").forEach(function (button) {
            button.addEventListener("click", function (event) {
                event.preventDefault();
                var group = button.closest(".sidebar-group");
                if (group) {
                    group.classList.toggle("open");
                }
            });
        });

        function collectCheckedValues(selector) {
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
            var attrValues = collectCheckedValues(".js-filter-attr");
            var locationSelect = document.querySelector(".js-filter-select-location");
            var brandSelect = document.querySelector(".js-filter-select-brand");
            var originSelect = document.querySelector(".js-filter-select-origin");
            var sortSelect = document.querySelector(".js-filter-select-sort");

            if (attrValues) {
                url.searchParams.set("attrs", attrValues);
            } else {
                url.searchParams.delete("attrs");
            }

            if (locationSelect && locationSelect.value) {
                url.searchParams.set("province", locationSelect.value);
            } else {
                url.searchParams.delete("province");
            }

            if (brandSelect && brandSelect.value) {
                url.searchParams.set("brand", brandSelect.value);
            } else {
                url.searchParams.delete("brand");
            }

            if (originSelect && originSelect.value) {
                url.searchParams.set("origin", originSelect.value);
            } else {
                url.searchParams.delete("origin");
            }

            if (sortSelect && sortSelect.value) {
                url.searchParams.set("sort", sortSelect.value);
            } else {
                url.searchParams.delete("sort");
            }

            window.location.href = url.toString();
        }

        document.querySelectorAll(".js-filter-attr").forEach(function (input) {
            input.addEventListener("change", applyFilters);
        });

        document.querySelectorAll(".js-filter-select-location, .js-filter-select-brand, .js-filter-select-origin, .js-filter-select-sort").forEach(function (input) {
            input.addEventListener("change", applyFilters);
        });
    });
})();
