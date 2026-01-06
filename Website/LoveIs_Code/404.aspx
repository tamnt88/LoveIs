<%@ Page Language="C#" AutoEventWireup="true" CodeFile="404.aspx.cs" Inherits="NotFoundPage" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    404 - Không tìm thấy | Beauty Story
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-5 not-found">
        <div class="not-found-card">
            <div class="not-found-code">404</div>
            <h1 class="not-found-title">Không tìm thấy trang</h1>
            <p class="not-found-text">Đường dẫn bạn truy cập hiện không tồn tại hoặc đã bị thay đổi</p>
            <div class="not-found-actions">
                <a class="btn btn-brand" href="/">Về trang chủ</a>
                <a class="btn btn-outline-brand" href="/tin-tuc">Xem tin tức</a>
            </div>
        </div>
    </main>
</asp:Content>
