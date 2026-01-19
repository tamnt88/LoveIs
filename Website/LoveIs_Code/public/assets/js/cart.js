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

    function parseMoney(text) {
        if (!text) {
            return 0;
        }
        var digits = text.toString().replace(/[^0-9]/g, '');
        return digits ? parseInt(digits, 10) : 0;
    }

    function formatMoney(value) {
        if (!value || value <= 0) {
            return '0 đ';
        }
        return value.toLocaleString('vi-VN') + ' đ';
    }

    function updateSelectedTotal() {
        var total = 0;
        document.querySelectorAll('.cart-item-checkbox input:checked').forEach(function (checkbox) {
            var row = checkbox.closest('.cart-row');
            if (!row) {
                return;
            }
            var totalCell = row.querySelector('.cart-total');
            if (totalCell) {
                total += parseMoney(totalCell.textContent);
            }
        });
        var summary = document.querySelector('.cart-summary-total');
        if (summary) {
            summary.textContent = formatMoney(total);
        }
    }

    function getSelectedVariantIds() {
        var ids = [];
        document.querySelectorAll('.cart-item-checkbox input:checked').forEach(function (checkbox) {
            var row = checkbox.closest('.cart-row');
            if (!row) {
                return;
            }
            var hidden = row.querySelector('input[type="hidden"][id*="VariantIdField"]');
            if (hidden && hidden.value) {
                ids.push(hidden.value);
            }
        });
        return ids.filter(function (value, index, self) {
            return self.indexOf(value) === index;
        });
    }

    function showCartModal(message) {
        var modal = document.getElementById('CartWarningModal');
        if (!modal) {
            return false;
        }
        var body = document.getElementById('CartWarningMessage');
        if (body) {
            body.textContent = message || 'Vui lòng chọn sản phẩm để thanh toán.';
        }
        modal.classList.add('is-open');
        modal.setAttribute('aria-hidden', 'false');
        return true;
    }

    function closeCartModal() {
        var modal = document.getElementById('CartWarningModal');
        if (!modal) {
            return;
        }
        modal.classList.remove('is-open');
        modal.setAttribute('aria-hidden', 'true');
    }

    document.addEventListener('click', function (event) {
        var target = event.target;
        if (target.classList.contains('qty-btn')) {
            var action = target.getAttribute('data-action');
            updateQty(target, action === 'plus' ? 1 : -1);
        }

        var checkoutLink = target.closest('a[href="/thanh-toan"]');
        if (checkoutLink) {
            var selectedIds = getSelectedVariantIds();
            if (selectedIds.length === 0) {
                event.preventDefault();
                showCartModal('Vui lòng chọn sản phẩm để thanh toán.');
                return;
            }
            var baseUrl = checkoutLink.getAttribute('href').split('?')[0];
            var url = baseUrl + '?items=' + encodeURIComponent(selectedIds.join(','));
            event.preventDefault();
            window.location.href = url;
        }

        if (target.closest('[data-cart-modal-close="true"]')) {
            closeCartModal();
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
            updateSelectedTotal();
            return;
        }

        if (target.closest('.cart-item-checkbox')) {
            var all = document.querySelectorAll('.cart-item-checkbox input');
            var selected = document.querySelectorAll('.cart-item-checkbox input:checked');
            var selectAll = document.querySelector('.cart-select-all input');
            if (selectAll) {
                selectAll.checked = all.length > 0 && selected.length === all.length;
            }
            updateSelectedTotal();
        }
    });

    document.addEventListener('DOMContentLoaded', function () {
        updateSelectedTotal();
    });
})();
