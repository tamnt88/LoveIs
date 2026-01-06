<%@ Page Language="C#" AutoEventWireup="true" CodeFile="doi-mat-khau.aspx.cs" Inherits="CustomerChangePassword" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Đổi mật khẩu
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 account-page">
        <div class="row g-4">
            <div class="col-lg-3">
                <uc:CustomerSidebar ID="CustomerSidebar" runat="server" />
            </div>
            <div class="col-lg-9">
                <div class="account-card">
                    <div class="account-card-header">
                        <h4>Đổi mật khẩu</h4>
                        <p>Thiết lập mật khẩu mới để bảo vệ tài khoản</p>
                    </div>
                    <asp:Label ID="StatusMessage" runat="server" CssClass="account-message" />
                    <div class="account-form">
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label class="form-label">Mật khẩu hiện tại</label>
                                <asp:TextBox ID="CurrentPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Mật khẩu mới</label>
                                <asp:TextBox ID="NewPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Xác nhận mật khẩu mới</label>
                                <asp:TextBox ID="ConfirmPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                            </div>
                        </div>
                        <asp:Button ID="ChangePasswordButton" runat="server" CssClass="btn btn-dark account-save" Text="Cập nhật mật khẩu" OnClick="ChangePasswordButton_Click" />
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
