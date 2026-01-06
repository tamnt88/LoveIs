document.addEventListener("DOMContentLoaded", function () {
    var roomIdField = document.getElementById("RoomIdField");
    var currentUserIdField = document.getElementById("CurrentUserIdField");
    var sendBtn = document.getElementById("sendMessageBtn");
    var input = document.getElementById("MessageInput");
    var chatBox = document.getElementById("chatMessages");
    var lastMessageField = document.getElementById("LastMessageIdField");

    if (!roomIdField || !input || !sendBtn || !chatBox) {
        return;
    }

    var roomId = parseInt(roomIdField.value || "0", 10);
    if (roomId <= 0) {
        return;
    }

    var lastMessageId = parseInt(lastMessageField ? lastMessageField.value || "0" : "0", 10);

    var hasSignalR = window.jQuery && jQuery.connection && jQuery.connection.hub;
    if (!hasSignalR) {
        console.warn("SignalR chưa sẵn sàng. Kiểm tra /signalr/hubs.");
    }

    var hub = hasSignalR ? (jQuery.connection.communityChatHub || jQuery.connection.communityChat) : null;
    var joined = false;

    if (hub) {
        hub.client.joinedRoom = function (rid) {
            joined = true;
            console.log("Joined room", rid);
        };

        hub.client.newMessage = function (message) {
            if (!message) {
                return;
            }
            var msgRoomId = parseInt(message.RoomId || "0", 10);
            if (msgRoomId !== roomId) {
                return;
            }

        var wrapper = document.createElement("div");
        wrapper.className = "chat-message" + (message.SenderId.toString() === currentUserIdField.value ? " me" : "");

        var bubble = document.createElement("div");
        bubble.className = "bubble";

        var meta = document.createElement("div");
        meta.className = "small text-muted";
        meta.textContent = message.SenderName + " · " + message.CreatedAt;

        var body = document.createElement("div");
        body.textContent = message.Content;

        bubble.appendChild(meta);
        bubble.appendChild(body);
        wrapper.appendChild(bubble);
        chatBox.appendChild(wrapper);
        chatBox.scrollTop = chatBox.scrollHeight;
        };

        hub.client.chatError = function (text) {
            alert(text || "Không thể gửi tin nhắn.");
        };

        jQuery.connection.hub.logging = true;
        jQuery.connection.hub.error(function (err) {
            console.error("SignalR error", err);
        });
        jQuery.connection.hub.stateChanged(function (change) {
            console.log("SignalR state", change.oldState, "->", change.newState);
        });

        jQuery.connection.hub.start().done(function () {
            var senderId = parseInt(currentUserIdField.value || "0", 10);
            console.log("SignalR connected", jQuery.connection.hub.id, "room", roomId);
            hub.server.joinRoom(roomId.toString(), senderId);
        }).fail(function (error) {
            console.error("SignalR start failed", error);
        });
    }

    sendBtn.addEventListener("click", function () {
        var text = input.value || "";
        if (!text.trim()) {
            return;
        }
        if (!hub || !hub.server) {
            alert("Chat chưa sẵn sàng. Vui lòng tải lại trang.");
            return;
        }
        if (!joined) {
            alert("Đang kết nối phòng chat. Vui lòng thử lại sau vài giây.");
            return;
        }
        console.log("Send message", roomId, text);
        hub.server.sendMessage(roomId, text);
        input.value = "";
    });

    function appendMessage(message) {
        var wrapper = document.createElement("div");
        wrapper.className = "chat-message" + (message.SenderId.toString() === currentUserIdField.value ? " me" : "");

        var bubble = document.createElement("div");
        bubble.className = "bubble";

        var meta = document.createElement("div");
        meta.className = "small text-muted";
        meta.textContent = message.SenderName + " · " + message.CreatedAt;

        var body = document.createElement("div");
        body.textContent = message.Content;

        bubble.appendChild(meta);
        bubble.appendChild(body);
        wrapper.appendChild(bubble);
        chatBox.appendChild(wrapper);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function pollMessages() {
        if (!window.PageMethods || !roomId) {
            return;
        }

        window.PageMethods.GetMessages(roomId, lastMessageId, function (messages) {
            if (!messages || !messages.length) {
                return;
            }
            messages.forEach(function (msg) {
                lastMessageId = Math.max(lastMessageId, msg.Id);
                appendMessage(msg);
            });
            if (lastMessageField) {
                lastMessageField.value = lastMessageId.toString();
            }
        });
    }

    setInterval(pollMessages, 2000);
});
