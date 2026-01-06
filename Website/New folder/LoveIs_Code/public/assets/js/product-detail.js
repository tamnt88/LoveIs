document.addEventListener("DOMContentLoaded", function () {
    function setupBody(body) {
        var toggle = body.querySelector(".tab-toggle");
        var content = body.querySelector(".tab-body-content");
        if (!toggle || !content) {
            return;
        }

        toggle.style.display = "";
        body.classList.remove("expanded");
        toggle.textContent = "Xem thêm";

        var collapsedHeight = body.getBoundingClientRect().height;
        var contentHeight = content.scrollHeight;
        if (contentHeight <= collapsedHeight + 16) {
            toggle.style.display = "none";
            body.classList.add("expanded");
            return;
        }

        if (!toggle.dataset.bound) {
            toggle.addEventListener("click", function () {
                var expanded = body.classList.toggle("expanded");
                toggle.textContent = expanded ? "Thu gọn" : "Xem thêm";
            });
            toggle.dataset.bound = "1";
        }
    }

    var bodies = document.querySelectorAll(".js-tab-body");
    bodies.forEach(setupBody);

    document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(function (tab) {
        tab.addEventListener("shown.bs.tab", function (event) {
            var target = document.querySelector(event.target.getAttribute("data-bs-target"));
            if (!target) {
                return;
            }
            var body = target.querySelector(".js-tab-body");
            if (body) {
                setupBody(body);
            }
        });
    });
});
