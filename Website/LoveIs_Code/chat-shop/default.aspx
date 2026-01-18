<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ShopChatDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="TitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h1 class="h4 mb-0"><asp:Literal ID="ShopNameLiteral" runat="server" /></h1>
        </div>

        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger"></asp:Panel>

        <asp:Panel ID="ChatPanel" runat="server">
            <div class="border rounded p-3 mb-3" style="min-height: 240px; background:#fff;">
                <asp:Repeater ID="MessageRepeater" runat="server">
                    <ItemTemplate>
                        <div class="mb-2">
                            <div class="small text-muted"><%# Eval("SenderLabel") %> &#x2022; <%# Eval("CreatedText") %></div>
                            <div><%# Eval("Message") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:TextBox ID="MessageTextBox" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control mb-2" />
            <asp:Button ID="SendButton" runat="server" CssClass="btn btn-primary" Text="Gui tin nhan" OnClick="SendButton_Click" />
        </asp:Panel>
    </main>
</asp:Content>
