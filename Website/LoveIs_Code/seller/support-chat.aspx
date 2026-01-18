<%@ Page Language="C#" AutoEventWireup="true" CodeFile="support-chat.aspx.cs" Inherits="SellerSupportChat" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Chat với LoveIs</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-support">
        <div class="support-header">
            <div>
                <h2>Chat với LoveIs</h2>
                <p>Kết nối trực tiếp với đội ngũ hỗ trợ LoveIs.</p>
            </div>
        </div>

        <div class="card support-chat-card">
            <div class="support-chat-placeholder">
                <i class="fa-regular fa-comments"></i>
                <div>Khung chat sẽ hiển thị tại đây.</div>
            </div>
        </div>
    </div>
</asp:Content>
