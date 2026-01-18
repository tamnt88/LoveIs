<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nhom.aspx.cs" Inherits="CommunityGroup" MasterPageFile="~/public/Public.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/public/assets/css/community.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="community-page">
        <div class="container">
            <div class="community-layout">
                <aside class="community-sidebar">
                    <div class="community-card community-group-list">
                        <div class="fw-bold mb-2">Nhóm chat của bạn</div>
                        <asp:Repeater ID="GroupRepeater" runat="server">
                            <ItemTemplate>
                                <a href="/cong-dong/chat.aspx?roomId=<%# Eval("RoomId") %>"><%# Eval("RoomName") %></a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </aside>
                <main>
                    <div class="community-card">
                        <h4 class="mb-3">Tạo nhóm chat</h4>
                        <asp:Label ID="GroupMessage" runat="server" CssClass="account-message d-block mb-2" />
                        <div class="mb-3">
                            <label>Tên nhóm</label>
                            <asp:TextBox ID="GroupNameInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="mb-3">
                            <label>Thành viên (username, cách nhau bằng dấu phẩy)</label>
                            <asp:TextBox ID="MemberInput" runat="server" CssClass="form-control" TextMode="MultiLine" />
                        </div>
                        <asp:Button ID="CreateGroupButton" runat="server" CssClass="community-btn" Text="Tạo nhóm" OnClick="CreateGroupButton_Click" />
                    </div>
                </main>
            </div>
        </div>
    </div>
</asp:Content>
