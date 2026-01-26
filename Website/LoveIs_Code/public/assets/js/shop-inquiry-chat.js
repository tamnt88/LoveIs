document.addEventListener("DOMContentLoaded", function () {
    var root = document.querySelector("[data-shop-inquiry-chat]");
    if (!root) {
        return;
    }

    var inquiryId = parseInt(root.getAttribute("data-inquiry-id") || "0", 10);
    var senderType = (root.getAttribute("data-sender-type") || "").toLowerCase();
    var senderId = parseInt(root.getAttribute("data-sender-id") || "0", 10);
    var input = root.querySelector("[data-chat-input]");
    var sendBtn = root.querySelector("[data-chat-send]");
    var chatBody = root.querySelector("[data-chat-body]");
    var convoList = root.querySelector("[data-chat-list]");
    var filterTabs = root.querySelectorAll("[data-chat-filter]");
    var joined = false;

    if (!inquiryId || !senderType || !senderId || !input || !sendBtn || !chatBody) {
        return;
    }

    function scrollToBottom() {
        chatBody.scrollTop = chatBody.scrollHeight;
    }

    function autoResize() {
        input.style.height = "auto";
        input.style.height = Math.min(input.scrollHeight, 140) + "px";
    }

    input.addEventListener("input", autoResize);
    autoResize();

    if (!window.jQuery || !jQuery.connection || !jQuery.connection.hub) {
        console.warn("SignalR chua san sang.");
        return;
    }

    var hub = jQuery.connection.shopInquiryChatHub || jQuery.connection.shopInquiryChat;
    if (!hub) {
        console.warn("Khong tim thay hub chat.");
        return;
    }

    function buildMessageNode(message) {
        var wrapper = document.createElement("div");
        var isMine = (message.SenderType || "").toLowerCase() === senderType;
        wrapper.className = "seller-chat-message" + (isMine ? " me" : "");

        if (root.classList.contains("shop-chat-page")) {
            wrapper.className = "shop-chat-message" + (isMine ? " me" : "");
        }

        var bubble = document.createElement("div");
        bubble.className = "bubble";
        bubble.textContent = message.Message || "";

        var time = document.createElement("div");
        time.className = "chat-time";
        time.textContent = message.CreatedAt || "";

        wrapper.appendChild(bubble);
        wrapper.appendChild(time);
        return wrapper;
    }

    function updateConversationItem(message) {
        if (!convoList) {
            return;
        }

        var item = convoList.querySelector("[data-inquiry-id='" + message.InquiryId + "']");
        if (!item) {
            return;
        }

        var snippet = item.querySelector(".seller-chat-snippet");
        var time = item.querySelector(".seller-chat-time");
        if (snippet) {
            snippet.textContent = (message.Message || "").trim() || "Tin nhan moi";
        }
        if (time) {
            time.textContent = message.CreatedAt || "";
        }

        if (String(message.InquiryId) !== String(inquiryId) && (message.SenderType || "").toLowerCase() !== senderType) {
            var unread = parseInt(item.getAttribute("data-unread") || "0", 10) + 1;
            item.setAttribute("data-unread", unread.toString());
            item.classList.add("is-unread");
            var badge = item.querySelector(".seller-chat-badge");
            if (badge) {
                badge.textContent = unread.toString();
                badge.style.display = "inline-flex";
            }
        } else {
            item.setAttribute("data-unread", "0");
            item.classList.remove("is-unread");
            var badgeClear = item.querySelector(".seller-chat-badge");
            if (badgeClear) {
                badgeClear.textContent = "";
                badgeClear.style.display = "none";
            }
        }

        convoList.insertBefore(item, convoList.firstChild);
        applyFilter();
    }

    function appendMessage(message) {
        if (String(message.InquiryId) !== String(inquiryId)) {
            updateConversationItem(message);
            return;
        }

        if ((message.MessageType || "").toLowerCase() === "product_card") {
            return;
        }

        var node = buildMessageNode(message);
        chatBody.appendChild(node);
        scrollToBottom();
        updateConversationItem(message);

        if ((message.SenderType || "").toLowerCase() !== senderType && hub.server && hub.server.markRead) {
            hub.server.markRead(inquiryId, senderType, senderId);
        }
    }

    hub.client.joinedInquiry = function () {
        joined = true;
        if (hub.server && hub.server.markRead) {
            hub.server.markRead(inquiryId, senderType, senderId);
        }
    };

    hub.client.newMessage = function (message) {
        if (!message || !message.InquiryId) {
            return;
        }
        appendMessage(message);
    };

    hub.client.chatError = function (text) {
        alert(text || "Khong the gui tin nhan.");
    };

    jQuery.connection.hub.start().done(function () {
        hub.server.joinInquiry(inquiryId.toString(), senderType, senderId);
        scrollToBottom();
    }).fail(function (error) {
        console.error("SignalR start failed", error);
    });

    function sendMessage() {
        var text = input.value || "";
        if (!text.trim()) {
            return;
        }
        if (!joined || !hub.server || !hub.server.sendMessage) {
            alert("Chat chua san sang. Vui long thu lai.");
            return;
        }
        hub.server.sendMessage(inquiryId, text);
        input.value = "";
        autoResize();
    }

    sendBtn.addEventListener("click", function (event) {
        event.preventDefault();
        sendMessage();
    });

    input.addEventListener("keydown", function (event) {
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        }
    });

    function applyFilter() {
        if (!convoList) {
            return;
        }
        var activeFilter = root.getAttribute("data-chat-filter") || "all";
        var items = convoList.querySelectorAll(".seller-chat-item");
        items.forEach(function (item) {
            if (activeFilter === "unread") {
                var unread = parseInt(item.getAttribute("data-unread") || "0", 10);
                item.style.display = unread > 0 ? "" : "none";
            } else {
                item.style.display = "";
            }
        });
    }

    filterTabs.forEach(function (tab) {
        tab.addEventListener("click", function (event) {
            event.preventDefault();
            filterTabs.forEach(function (btn) { btn.classList.remove("is-active"); });
            tab.classList.add("is-active");
            root.setAttribute("data-chat-filter", tab.getAttribute("data-chat-filter") || "all");
            applyFilter();
        });
    });

    scrollToBottom();
});
