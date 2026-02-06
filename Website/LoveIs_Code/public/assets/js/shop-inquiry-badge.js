(function () {
    var fab = document.getElementById("ShopChatFabLink");
    if (!fab) {
        return;
    }

    if (document.querySelector("[data-shop-inquiry-chat]")) {
        return;
    }

    var senderType = (fab.getAttribute("data-sender-type") || "").toLowerCase();
    var senderId = parseInt(fab.getAttribute("data-sender-id") || "0", 10);
    var inquiryIds = (fab.getAttribute("data-inquiry-ids") || "")
        .split(",")
        .map(function (id) { return parseInt(id, 10); })
        .filter(function (id) { return id > 0; });

    if (!senderType || !senderId || !inquiryIds.length) {
        return;
    }

    if (!window.jQuery || !jQuery.connection || !jQuery.connection.hub) {
        return;
    }

    var hub = jQuery.connection.shopInquiryChatHub || jQuery.connection.shopInquiryChat;
    if (!hub || !hub.server) {
        return;
    }

    function getBadge() {
        return fab.querySelector(".shop-chat-fab-badge");
    }

    function setBadge(count) {
        var badge = getBadge();
        if (!badge) {
            return;
        }
        if (count > 0) {
            badge.textContent = count.toString();
            badge.style.display = "inline-flex";
        } else {
            badge.textContent = "0";
            badge.style.display = "none";
        }
    }

    function incrementBadge() {
        var badge = getBadge();
        if (!badge) {
            return;
        }
        var current = parseInt(badge.textContent || "0", 10) || 0;
        setBadge(current + 1);
    }

    hub.client.newMessage = function (message) {
        if (!message || !message.InquiryId) {
            return;
        }
        if ((message.SenderType || "").toLowerCase() === "shop") {
            incrementBadge();
        }
    };

    jQuery.connection.hub.start().done(function () {
        inquiryIds.forEach(function (id) {
            hub.server.joinInquiry(id.toString(), senderType, senderId);
        });
    });
})();
