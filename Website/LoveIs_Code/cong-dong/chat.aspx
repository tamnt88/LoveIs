<%@ Page Language="C#" AutoEventWireup="true" CodeFile="chat.aspx.cs" Inherits="CommunityChat" MasterPageFile="~/public/Public.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/public/assets/css/community.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="community-page">
        <div class="container">
            <div class="community-chat">
                <aside class="community-card chat-list">
                    <div class="fw-bold mb-2">Tin nhắn</div>
                    <asp:Repeater ID="RoomRepeater" runat="server">
                        <ItemTemplate>
                            <a href="/cong-dong/chat.aspx?roomId=<%# Eval("RoomId") %>" class="<%# Eval("ActiveClass") %>">
                                <span class="chat-avatar"><%# Eval("RoomInitial") %></span>
                                <span class="chat-room-name"><%# Eval("RoomName") %></span>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </aside>
                <main class="community-card">
                    <asp:Label ID="ChatStatus" runat="server" CssClass="account-message d-block mb-2" />
                    <div class="chat-messages" id="chatMessages">
                        <asp:Repeater ID="MessageRepeater" runat="server">
                            <ItemTemplate>
                                <div class="chat-message <%# Eval("CssClass") %>">
                                    <span class="chat-avatar"><%# Eval("SenderInitial") %></span>
                                    <div class="bubble">
                                        <div class="small text-muted"><%# Eval("SenderName") %> · <%# Eval("CreatedAt") %></div>
                                        <div><%# Eval("Content") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="chat-input">
                        <asp:TextBox ID="MessageInput" runat="server" ClientIDMode="Static" placeholder="Nhập tin nhắn..." />
                        <div class="chat-emoji">
                            <button type="button" class="community-btn" id="chatEmojiBtn" title="Emoji" aria-label="Emoji">
                                <i class="fa-regular fa-face-smile" aria-hidden="true"></i>
                            </button>
                            <div class="emoji-panel" id="chatEmojiPanel" aria-hidden="true"></div>
                        </div>
                        <button type="button" class="community-btn" id="sendMessageBtn">Gửi</button>
                    </div>
                    <asp:HiddenField ID="RoomIdField" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="CurrentUserIdField" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="LastMessageIdField" runat="server" ClientIDMode="Static" />
                </main>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/public/assets/js/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script src="/public/assets/js/community-chat.js"></script>

    <script>
        (function () {
            var input = document.getElementById("MessageInput");
            var emojiBtn = document.getElementById("chatEmojiBtn");
            var panel = document.getElementById("chatEmojiPanel");
            if (!input || !emojiBtn || !panel) {
                return;
            }
           var emojis = ["\uD83D\uDE00", "\uD83D\uDE01", "\uD83D\uDE02", "\uD83E\uDD23", "\uD83D\uDE0A", "\uD83D\uDE0D", "\uD83D\uDE18", "\uD83D\uDE0E", "\uD83E\uDD29", "\uD83D\uDE22", "\uD83D\uDE21", "\uD83D\uDC4D", "\uD83D\uDC4E", "\uD83D\uDC4F", "\uD83D\uDE4F", "\u2764\uFE0F", "\uD83D\uDD25", "\uD83C\uDF89", "\uD83D\uDCAF"];
            panel.innerHTML = "";
            emojis.forEach(function (emoji) {
                var btn = document.createElement("button");
                btn.type = "button";
                btn.className = "emoji-item";
                btn.textContent = emoji;
                btn.addEventListener("click", function () {
                    var start = input.selectionStart || 0;
                    var end = input.selectionEnd || 0;
                    var value = input.value || "";
                    input.value = value.slice(0, start) + emoji + value.slice(end);
                    input.focus();
                    input.selectionStart = input.selectionEnd = start + emoji.length;
                    panel.setAttribute("aria-hidden", "true");
                    panel.classList.remove("is-open");
                });
                panel.appendChild(btn);
            });
            emojiBtn.addEventListener("click", function (event) {
                event.preventDefault();
                var isOpen = panel.classList.toggle("is-open");
                panel.setAttribute("aria-hidden", isOpen ? "false" : "true");
            });
            document.addEventListener("click", function (event) {
                if (!panel.classList.contains("is-open")) {
                    return;
                }
                if (panel.contains(event.target) || emojiBtn.contains(event.target)) {
                    return;
                }
                panel.classList.remove("is-open");
                panel.setAttribute("aria-hidden", "true");
            });
        })();
    </script>
</asp:Content>
