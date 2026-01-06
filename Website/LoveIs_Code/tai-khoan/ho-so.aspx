<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ho-so.aspx.cs" Inherits="CustomerProfile" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Hồ sơ của tôi
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
                        <div>
                            <h4>Hồ sơ của tôi</h4>
                            <p>Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                        </div>
                    </div>
                    <asp:Label ID="StatusMessage" runat="server" CssClass="account-message" />
                    <div class="account-form">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên đăng nhập</label>
                                <div class="account-readonly"><asp:Literal ID="UsernameValueLiteral" runat="server" /></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên hiển thị</label>
                                <asp:TextBox ID="DisplayNameInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <div class="account-readonly">
                                    <asp:Literal ID="EmailLiteral" runat="server" />
                                    <a class="account-change-link" href="#">Thay đổi</a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <div class="account-readonly">
                                    <asp:Literal ID="PhoneLiteral" runat="server" />
                                    <a class="account-change-link" href="#">Thay đổi</a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Giới tính</label>
                                <div class="account-radio">
                                    <label><asp:RadioButton ID="GenderMale" runat="server" GroupName="gender" /> Nam</label>
                                    <label><asp:RadioButton ID="GenderFemale" runat="server" GroupName="gender" /> Nữ</label>
                                    <label><asp:RadioButton ID="GenderOther" runat="server" GroupName="gender" /> Khác</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngày sinh</label>
                                <asp:TextBox ID="BirthDateInput" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                        </div>
                        <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-dark account-save" Text="Lưu" OnClick="SaveButton_Click" />
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
