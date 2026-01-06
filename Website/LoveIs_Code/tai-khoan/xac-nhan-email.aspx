<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xac-nhan-email.aspx.cs" Inherits="CustomerEmailVerify" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Xác nhận email
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-5 buyer-login">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="buyer-login-card text-center email-verify-card">
                    <div class="email-verify-icon">
                        <i class="fa-regular fa-circle-check"></i>
                    </div>
                    <h4 class="mb-2">Xác nhận email</h4>
                    <asp:Label ID="StatusMessage" runat="server" CssClass="email-verify-message" />
                    <div class="email-verify-actions">
                        <a class="btn btn-dark" href="/tai-khoan/dang-nhap.aspx">Đăng nhập</a>
                        <a class="btn btn-outline-dark" href="/">Về trang chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
