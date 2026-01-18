<%@ Page Language="C#" AutoEventWireup="true" CodeFile="chat.aspx.cs" Inherits="SellerChatDefault" MasterPageFile="~/seller/Seller.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Chat shop
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card p-3">
        <h2 class="h5 mb-3">Chat với khách hàng</h2>

        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger"></asp:Panel>

        <div class="row g-3">
            <div class="col-lg-4">
                <div class="border rounded p-2 bg-white" style="max-height: 520px; overflow:auto;">
                    <asp:Repeater ID="InquiryRepeater" runat="server">
                        <ItemTemplate>
                            <div class="border-bottom py-2">
                                <div class="fw-semibold">
                                    <a href="<%# Eval("Url") %>"><%# Eval("Title") %></a>
                                </div>
                                <div class="small text-muted"><%# Eval("SubTitle") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="col-lg-8">
                <asp:Panel ID="ChatPanel" runat="server">
                    <div class="border rounded p-3 mb-2 bg-white" style="min-height: 300px; max-height: 420px; overflow:auto;">
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
                    <asp:Button ID="SendButton" runat="server" CssClass="btn btn-primary" Text="Gửi tin nhắn" OnClick="SendButton_Click" />
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
