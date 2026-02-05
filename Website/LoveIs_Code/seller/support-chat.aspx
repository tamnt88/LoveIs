<%@ Page Language="C#" AutoEventWireup="true" CodeFile="support-chat.aspx.cs" Inherits="SellerSupportChat" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Chat với LoveIs</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-chat-page support-chat-page" data-shop-inquiry-chat="true" data-chat-filter="all" data-chat-id-key="chatId" data-chat-hub="supportChatHub" data-upload-url="/support-chat-upload.aspx">
        <div class="seller-chat-header">
            <h2>Chat với LoveIs</h2>
        </div>

        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger"></asp:Panel>

        <asp:Panel ID="ChatPanel" runat="server">
            <div class="seller-chat-card">
                <div class="seller-chat-head">
                    <span class="seller-chat-avatar large">L</span>
                    <div>
                        <div class="seller-chat-name">LoveIs Support</div>
                        <div class="seller-chat-status" id="AdminStatusWrap" runat="server">
                            <span class="dot"></span>
                            <asp:Literal ID='AdminStatusLiteral' runat='server' />
                        </div>
                    </div>
                </div>

                <div class="seller-chat-body" id="SupportChatBody" data-chat-body="true">
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
            </div>
        </asp:Panel>

        <asp:HiddenField ID="ChatIdField" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="SenderTypeField" runat="server" ClientIDMode="Static" Value="seller" />
        <asp:HiddenField ID="SenderIdField" runat="server" ClientIDMode="Static" />
    </div>

    <script src="/public/theme/assets/js/jquery.min.js"></script>
    <script src="/public/assets/js/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script src="/public/assets/js/shop-inquiry-chat.js"></script>
    <script>
        (function () {
            var root = document.querySelector("[data-shop-inquiry-chat]");
            var chatField = document.getElementById("ChatIdField");
            var senderTypeField = document.getElementById("SenderTypeField");
            var senderIdField = document.getElementById("SenderIdField");
            if (!root || !chatField || !senderTypeField || !senderIdField) {
                return;
            }
            root.setAttribute("data-chat-id", chatField.value || "0");
            root.setAttribute("data-sender-type", senderTypeField.value || "seller");
            root.setAttribute("data-sender-id", senderIdField.value || "0");
        })();
    </script>
</asp:Content>

