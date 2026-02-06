<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ShopChatDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="TitleLiteral" runat="server" />
</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/public/assets/css/shop-chat.css") %>" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 shop-chat-page" runat="server" id="ChatRoot" data-shop-inquiry-chat="true" data-chat-filter="all" data-chat-id-key="inquiryId" data-chat-hub="shopInquiryChatHub" data-upload-url="/chat-upload.aspx">
        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger"></asp:Panel>

        <div class="shop-chat-layout">
            <aside class="shop-chat-sidebar">
                <div class="shop-chat-sidebar-head">
                    <div class="shop-chat-title">Chat (<asp:Literal ID="ChatUnreadLiteral" runat="server" />)</div>
                </div>
                <div class="shop-chat-toolbar">
                    <div class="shop-chat-search">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" placeholder="Tìm theo tên shop..." data-chat-search="true" />
                    </div>
                    <div class="shop-chat-filter">
                        <button type="button" class="shop-chat-filter-btn is-active" data-chat-filter="all">Tất cả</button>
                        <button type="button" class="shop-chat-filter-btn" data-chat-filter="unread">Chưa đọc</button>
                    </div>
                    
                </div>
                <div class="shop-chat-list" data-chat-list="true">
                    <asp:Repeater ID="InquiryRepeater" runat="server">
                        <ItemTemplate>
                            <a class="seller-chat-item <%# Eval("ActiveClass") %> <%# Eval("UnreadClass") %>" href="<%# Eval("Url") %>" data-inquiry-id="<%# Eval("InquiryId") %>" data-unread="<%# Eval("UnreadCount") %>" data-title="<%# Eval("TitlePlain") %>">
                                <span class="seller-chat-avatar"><%# Eval("Initial") %></span>
                                <span class="seller-chat-info">
                                    <span class="seller-chat-top">
                                        <span class="seller-chat-name"><%# Eval("Title") %></span>
                                        <span class="seller-chat-time"><%# Eval("TimeText") %></span>
                                    </span>
                                    <span class="seller-chat-snippet"><%# Eval("Snippet") %></span>
                                </span>
                                <span class="seller-chat-badge" style="<%# (int)Eval("UnreadCount") > 0 ? "display:inline-flex" : "display:none" %>"><%# Eval("UnreadCount") %></span>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </aside>

            <section class="shop-chat-main">
                <asp:Panel ID="WelcomePanel" runat="server" Visible="false" CssClass="shop-chat-welcome">
                    <div class="welcome-graphic">
                        <i class="fa-regular fa-comments"></i>
                    </div>
                    <div class="welcome-title">Chào mừng bạn đến với LoveIs Chat</div>
                    <div class="welcome-subtitle">Bắt đầu trò chuyện với người bán ngay bây giờ.</div>
                </asp:Panel>

                <asp:Panel ID="ChatPanel" runat="server">
                    <div class="shop-chat-card">
                        <div class="shop-chat-header">
                            <div class="shop-chat-avatar">
                                <asp:Image ID="ShopAvatar" runat="server" CssClass="shop-chat-avatar-img" AlternateText="Shop" />
                            </div>
                            <div class="shop-chat-meta">
                                <div class="shop-chat-name"><asp:Literal ID="ShopNameLiteral" runat="server" /></div>
                                <div class="shop-chat-status" id="ShopStatusWrap" runat="server">
                                    <span class="dot"></span>
                                    <asp:Literal ID='ShopStatusLiteral' runat='server' />
                                </div>
                            </div>
                        </div>

                        <div class="shop-chat-body" id="ShopChatBody" data-chat-body="true">
                            <div class="chat-product-sticky">
                                <asp:Literal ID="ProductCardLiteral" runat="server" />
                            </div>
                            <asp:Repeater ID="MessageRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="shop-chat-message <%# Eval("SenderClass") %>">
                                        <div class="bubble">
                                            <%# Eval("MessageHtml") %>
                                        </div>
                                        <div class="chat-time"><%# Eval("CreatedText") %></div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <div class="shop-chat-input">
                            <div class="chat-attachment" data-chat-attach="true">
                                <i class="fa-solid fa-paperclip"></i>
                            </div>
                            <asp:TextBox ID="MessageTextBox" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="1" CssClass="chat-textbox" placeholder="Nhập tin nhắn..." data-chat-input="true" />
                            <button type="button" class="chat-send" data-chat-send="true">&#x27A4;</button>
                        </div>
                        <input type="file" class="chat-file-input" data-chat-file="true" accept="image/*" multiple="multiple" />
                    </div>
                </asp:Panel>
            </section>
        </div>
    </main>
    <asp:HiddenField ID="InquiryIdField" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="SenderTypeField" runat="server" ClientIDMode="Static" Value="customer" />
    <asp:HiddenField ID="SenderIdField" runat="server" ClientIDMode="Static" />
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/public/assets/js/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script src="/public/assets/js/shop-inquiry-chat.js"></script>
    <script>
        (function () {
            var root = document.querySelector("[data-shop-inquiry-chat]");
            var inquiryField = document.getElementById("InquiryIdField");
            var senderTypeField = document.getElementById("SenderTypeField");
            var senderIdField = document.getElementById("SenderIdField");
            if (!root || !inquiryField || !senderTypeField || !senderIdField) {
                return;
            }
            root.setAttribute("data-chat-id", inquiryField.value || "0");
            root.setAttribute("data-sender-type", senderTypeField.value || "customer");
            root.setAttribute("data-sender-id", senderIdField.value || "0");
        })();
    </script>
</asp:Content>
