<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ShopChatDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="TitleLiteral" runat="server" />
</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/public/assets/css/shop-chat.css") %>" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 shop-chat-page" data-shop-inquiry-chat="true" data-chat-filter="all">
        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger"></asp:Panel>

        <asp:Panel ID="ChatPanel" runat="server">
            <div class="shop-chat-card">
                <div class="shop-chat-header">
                    <div class="shop-chat-avatar">
                        <asp:Image ID="ShopAvatar" runat="server" CssClass="shop-chat-avatar-img" AlternateText="Shop" />
                    </div>
                    <div class="shop-chat-meta">
                        <div class="shop-chat-name"><asp:Literal ID="ShopNameLiteral" runat="server" /></div>
                        <div class="shop-chat-status">
                            <span class="dot"></span>
                            Đang hoạt động
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
                    <div class="chat-attachment">
                        <i class="fa-solid fa-paperclip"></i>
                    </div>
                    <asp:TextBox ID="MessageTextBox" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="1" CssClass="chat-textbox" placeholder="Nhập tin nhắn..." data-chat-input="true" />
                    <button type="button" class="chat-send" data-chat-send="true">&#x27A4;</button>
                </div>
            </div>
        </asp:Panel>
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
            root.setAttribute("data-inquiry-id", inquiryField.value || "0");
            root.setAttribute("data-sender-type", senderTypeField.value || "customer");
            root.setAttribute("data-sender-id", senderIdField.value || "0");
        })();
    </script>
</asp:Content>
