(function () {
    var updateTimer = null;

    function getPostbackTarget() {
        var trigger = document.querySelector('[data-cart-postback]');
        return trigger ? trigger.getAttribute('data-cart-postback') : null;
    }

    function submitCartUpdate() {
        var target = getPostbackTarget();
        if (!target || typeof __doPostBack !== 'function') {
            return;
        }
        __doPostBack(target, '');
    }

    function queueCartUpdate() {
        if (updateTimer) {
            clearTimeout(updateTimer);
        }
        updateTimer = setTimeout(submitCartUpdate, 400);
    }

    function updateQty(button, delta) {
        var wrap = button.closest('.cart-qty');
        if (!wrap) {
            return;
        }
        var input = wrap.querySelector('.qty-input');
        if (!input) {
            return;
        }
        var current = parseInt(input.value, 10);
        if (isNaN(current) || current < 1) {
            current = 1;
        }
        var next = current + delta;
        if (next < 1) {
            next = 1;
        }
        input.value = next;
        queueCartUpdate();
    }

    document.addEventListener('click', function (event) {
        var target = event.target;
        if (target.classList.contains('qty-btn')) {
            var action = target.getAttribute('data-action');
            updateQty(target, action === 'plus' ? 1 : -1);
        }
    });

    document.addEventListener('input', function (event) {
        var target = event.target;
        if (target.classList.contains('qty-input')) {
            queueCartUpdate();
        }
    });

    document.addEventListener('change', function (event) {
        var target = event.target;
        if (target.closest('.cart-select-all')) {
            var checked = target.checked;
            document.querySelectorAll('.cart-item-checkbox input').forEach(function (item) {
                item.checked = checked;
            });
            return;
        }

        if (target.closest('.cart-item-checkbox')) {
            var all = document.querySelectorAll('.cart-item-checkbox input');
            var selected = document.querySelectorAll('.cart-item-checkbox input:checked');
            var selectAll = document.querySelector('.cart-select-all input');
            if (selectAll) {
                selectAll.checked = all.length > 0 && selected.length === all.length;
            }
        }
    });
})();
