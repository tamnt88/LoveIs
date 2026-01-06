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
                                <%# Eval("RoomName") %>
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
</asp:Content>
