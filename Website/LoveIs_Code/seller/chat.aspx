<%@ Page Language="C#" AutoEventWireup="true" CodeFile="chat.aspx.cs" Inherits="SellerChatDefault" MasterPageFile="~/seller/Seller.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Chat shop
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-chat-page" runat="server" id="ChatRoot" data-shop-inquiry-chat="true" data-chat-filter="all" data-chat-id-key="inquiryId" data-chat-hub="shopInquiryChatHub" data-upload-url="/chat-upload.aspx">
        <div class="seller-chat-header">
            <h2>Chat với khách hàng</h2>
        </div>

        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger"></asp:Panel>

        <div class="seller-chat-layout">
            <aside class="seller-chat-sidebar">
                <div class="seller-chat-filters">
                    <button type="button" class="seller-chat-filter is-active" data-chat-filter="all">Tất cả</button>
                    <button type="button" class="seller-chat-filter" data-chat-filter="unread">Chưa đọc</button>
                </div>
                <div class="seller-chat-list" id="SellerConversationList" data-chat-list="true">
                    <asp:Repeater ID="InquiryRepeater" runat="server">
                        <ItemTemplate>
                            <a class="seller-chat-item <%# Eval("ActiveClass") %> <%# Eval("UnreadClass") %>" href="<%# Eval("Url") %>" data-inquiry-id="<%# Eval("InquiryId") %>" data-unread="<%# Eval("UnreadCount") %>">
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

            <section class="seller-chat-main">
                <asp:Panel ID="WelcomePanel" runat="server" Visible="false" CssClass="seller-chat-welcome">
                    <div class="welcome-graphic">
                        <i class="fa-regular fa-comments"></i>
                    </div>
                    <div class="welcome-title"><asp:Literal ID="WelcomeTitleLiteral" runat="server" /></div>
                    <div class="welcome-subtitle"><asp:Literal ID="WelcomeSubtitleLiteral" runat="server" /></div>
                </asp:Panel>
                <asp:Panel ID="ChatPanel" runat="server" CssClass="seller-chat-card">
                    <div class="seller-chat-head">
                        <span class="seller-chat-avatar large">
                            <asp:Literal ID="CustomerInitialLiteral" runat="server" />
                        </span>
                        <div>
                            <div class="seller-chat-name">
                                <asp:Literal ID="CustomerNameLiteral" runat="server" />
                            </div>
                            <div class="seller-chat-status" id="CustomerStatusWrap" runat="server">
                                <span class="dot"></span>
                                <asp:Literal ID='CustomerStatusLiteral' runat='server' />
                            </div>
                        </div>
                    </div>

                    <div class="seller-chat-body" id="SellerChatBody" data-chat-body="true">
                        <div class="chat-product-sticky">
                            <asp:Literal ID="ProductCardLiteral" runat="server" />
                        </div>
                        <asp:Repeater ID="MessageRepeater" runat="server">
                            <ItemTemplate>
                                <div class="seller-chat-message <%# Eval("SenderClass") %>">
                                    <div class="bubble"><%# Eval("MessageHtml") %></div>
                                    <div class="chat-time"><%# Eval("CreatedText") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="seller-chat-input">
                        <div class="chat-attachment" data-chat-attach="true">
                            <i class="fa-solid fa-paperclip"></i>
                        </div>
                        <asp:TextBox ID="MessageTextBox" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="1" CssClass="chat-textbox" placeholder="Nhập tin nhắn..." data-chat-input="true" />
                        <button type="button" class="chat-send" data-chat-send="true">&#x27A4;</button>
                    </div>
                    <input type="file" class="chat-file-input" data-chat-file="true" accept="image/*" multiple="multiple" />
                </asp:Panel>
            </section>
        </div>

        <asp:HiddenField ID="InquiryIdField" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="SenderTypeField" runat="server" ClientIDMode="Static" Value="shop" />
        <asp:HiddenField ID="SenderIdField" runat="server" ClientIDMode="Static" />
    </div>

    <script src="/public/theme/assets/js/jquery.min.js"></script>
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
            root.setAttribute("data-sender-type", senderTypeField.value || "shop");
            root.setAttribute("data-sender-id", senderIdField.value || "0");
        })();
    </script>
</asp:Content>
