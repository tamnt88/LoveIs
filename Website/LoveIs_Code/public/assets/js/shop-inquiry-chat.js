document.addEventListener("DOMContentLoaded", function () {
    var root = document.querySelector("[data-shop-inquiry-chat]");
    if (!root) {
        return;
    }

    var chatId = parseInt(root.getAttribute("data-chat-id") || root.getAttribute("data-inquiry-id") || "0", 10);
    var idKey = root.getAttribute("data-chat-id-key") || "inquiryId";
    var senderType = (root.getAttribute("data-sender-type") || "").toLowerCase();
    var senderId = parseInt(root.getAttribute("data-sender-id") || "0", 10);
    var input = root.querySelector("[data-chat-input]");
    var sendBtn = root.querySelector("[data-chat-send]");
    var chatBody = root.querySelector("[data-chat-body]");
    var attachBtn = root.querySelector("[data-chat-attach]");
    var fileInput = root.querySelector("[data-chat-file]");
    var convoList = root.querySelector("[data-chat-list]");
    var filterTabs = root.querySelectorAll("[data-chat-filter]");
    var uploadUrl = root.getAttribute("data-upload-url") || "/chat-upload.aspx";
    var hubName = root.getAttribute("data-chat-hub") || "shopInquiryChatHub";
    var joined = false;

    if (!chatId || !senderType || !senderId || !input || !sendBtn || !chatBody) {
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

    var hub = jQuery.connection[hubName] || jQuery.connection[hubName.replace("Hub", "")];
    if (!hub) {
        console.warn("Khong tim thay hub chat.");
        return;
    }

    function buildImageGrid(files) {
        var grid = document.createElement("div");
        grid.className = "chat-image-grid";
        (files || []).forEach(function (file) {
            if (!file || !file.Url) {
                return;
            }
            var img = document.createElement("img");
            img.src = file.Url;
            img.alt = "image";
            img.className = "chat-image-thumb";
            img.setAttribute("data-full", file.Url);
            grid.appendChild(img);
        });
        return grid;
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
        if ((message.MessageType || "").toLowerCase() === "image") {
            bubble.appendChild(buildImageGrid(message.Files || []));
        } else {
            bubble.textContent = message.Message || "";
        }

        var time = document.createElement("div");
        time.className = "chat-time";
        time.textContent = message.CreatedAt || "";

        wrapper.appendChild(bubble);
        wrapper.appendChild(time);
        return wrapper;
    }

    function getThreadId(message) {
        return message.InquiryId || message.ChatId || 0;
    }

    function updateConversationItem(message) {
        if (!convoList) {
            return;
        }

        var threadId = getThreadId(message);
        var item = convoList.querySelector("[data-inquiry-id='" + threadId + "']");
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

        if (String(threadId) !== String(chatId) && (message.SenderType || "").toLowerCase() !== senderType) {
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
        var threadId = getThreadId(message);
        if (String(threadId) !== String(chatId)) {
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
            hub.server.markRead(chatId, senderType, senderId);
        }
    }

    hub.client.joinedInquiry = function () {
        joined = true;
        if (hub.server && hub.server.markRead) {
            hub.server.markRead(chatId, senderType, senderId);
        }
    };

    hub.client.joinedChat = function () {
        joined = true;
        if (hub.server && hub.server.markRead) {
            hub.server.markRead(chatId, senderType, senderId);
        }
    };

    hub.client.newMessage = function (message) {
        if (!message || (!message.InquiryId && !message.ChatId)) {
            return;
        }
        appendMessage(message);
    };

    hub.client.chatError = function (text) {
        alert(text || "Khong the gui tin nhan.");
    };

    jQuery.connection.hub.start().done(function () {
        if (hub.server.joinInquiry) {
            hub.server.joinInquiry(chatId.toString(), senderType, senderId);
        } else if (hub.server.joinChat) {
            hub.server.joinChat(chatId.toString(), senderType, senderId);
        }
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
        hub.server.sendMessage(chatId, text);
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

    if (attachBtn && fileInput) {
        attachBtn.addEventListener("click", function () {
            fileInput.click();
        });

        fileInput.addEventListener("change", function () {
            if (!fileInput.files || fileInput.files.length === 0) {
                return;
            }

            var formData = new FormData();
            formData.append(idKey, chatId.toString());
            formData.append("senderType", senderType);
            for (var i = 0; i < fileInput.files.length; i++) {
                formData.append("file" + i, fileInput.files[i]);
            }

            fetch(uploadUrl, {
                method: "POST",
                body: formData
            }).then(function (response) {
                if (!response.ok) {
                    throw new Error("Upload failed");
                }
                return response.json();
            }).then(function (data) {
                if (!data || !data.ok) {
                    alert((data && data.message) ? data.message : "Upload failed");
                }
                fileInput.value = "";
            }).catch(function () {
                alert("Upload failed");
                fileInput.value = "";
            });
        });
    }

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

    function ensureLightbox() {
        var overlay = document.querySelector(".chat-lightbox");
        if (overlay) {
            return overlay;
        }
        overlay = document.createElement("div");
        overlay.className = "chat-lightbox";
        overlay.innerHTML = "<div class=\"chat-lightbox-inner\">" +
            "<button type=\"button\" class=\"chat-lightbox-nav prev\" aria-label=\"Previous\">&#10094;</button>" +
            "<img alt=\"preview\" />" +
            "<button type=\"button\" class=\"chat-lightbox-nav next\" aria-label=\"Next\">&#10095;</button>" +
            "</div>";
        overlay.addEventListener("click", function () {
            overlay.classList.remove("open");
        });
        document.body.appendChild(overlay);
        return overlay;
    }

    var activeImages = [];
    var activeIndex = 0;

    function showLightbox(index) {
        if (!activeImages.length) {
            return;
        }
        activeIndex = Math.max(0, Math.min(index, activeImages.length - 1));
        var overlay = ensureLightbox();
        var img = overlay.querySelector("img");
        if (img) {
            img.src = activeImages[activeIndex];
        }
        overlay.classList.add("open");
    }

    document.addEventListener("click", function (event) {
        var target = event.target;
        if (!target) {
            return;
        }

        if (target.classList && target.classList.contains("chat-lightbox-nav")) {
            event.stopPropagation();
            if (target.classList.contains("prev")) {
                showLightbox(activeIndex - 1);
            } else {
                showLightbox(activeIndex + 1);
            }
            return;
        }

        if (!target.classList || !target.classList.contains("chat-image-thumb")) {
            return;
        }

        var src = target.getAttribute("data-full") || target.src;
        if (!src) {
            return;
        }

        var grid = target.closest(".chat-image-grid");
        if (grid) {
            activeImages = Array.prototype.map.call(grid.querySelectorAll(".chat-image-thumb"), function (img) {
                return img.getAttribute("data-full") || img.src;
            });
            activeIndex = activeImages.indexOf(src);
            if (activeIndex < 0) {
                activeIndex = 0;
            }
        } else {
            activeImages = [src];
            activeIndex = 0;
        }

        showLightbox(activeIndex);
    });

    scrollToBottom();
});
