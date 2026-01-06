<%@ Page Language="C#" AutoEventWireup="true" CodeFile="hoan-tat.aspx.cs" Inherits="CheckoutComplete" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Đặt hàng thành công | Beauty Story
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-5 checkout-complete">
        <div class="complete-wrap">
            <div class="complete-icon" aria-hidden="true">
                <i class="fa-solid fa-check"></i>
            </div>
            <h1 class="complete-title">Đặt hàng thành công</h1>
            <p class="complete-lead">Cảm ơn bạn đã mua sắm tại LoveIs Store.</p>
            <div class="complete-code">
                Mã đơn hàng: <strong><asp:Literal ID="OrderCodeLiteral" runat="server" /></strong>
            </div>
            <div class="complete-actions">
                <a class="btn btn-brand btn-with-icon" href="/">
                    <i class="fa-solid fa-house"></i>Tiếp tục mua sắm
                </a>
                <asp:HyperLink ID="OrderLink" runat="server" CssClass="btn btn-outline-brand btn-with-icon">
                    <i class="fa-solid fa-receipt"></i>Xem đơn hàng
                </asp:HyperLink>
            </div>
            <div class="complete-tip">
                Chúng tôi sẽ liên hệ để xác nhận đơn hàng và giao hàng trong thời gian sớm nhất.
            </div>
        </div>
    </main>
</asp:Content>
