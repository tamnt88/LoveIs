<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dang-nhap.aspx.cs" Inherits="CustomerLogin" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Đăng nhập
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-5 buyer-login">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <div class="buyer-login-content">
                    <h1>Mua sắm an tâm mỗi ngày</h1>
                    <p>Đăng nhập để lưu giỏ hàng, theo dõi đơn và nhận ưu đãi dành riêng cho bạn trên LoveIs</p>
                </div>
                <div class="buyer-login-banner">
                    <img src="/upload/banner_net_quyen_ru.png" alt="LoveIs" />
                </div>
            </div>
            <div class="col-lg-6">
                <div class="buyer-login-card">
                    <div class="buyer-login-tabs">
                        <button type="button" class="active">Đăng nhập</button>
                    </div>
                    <asp:Label ID="ErrorMessage" runat="server" CssClass="text-danger small d-block mb-3" />
                    <div class="form-group">
                        <label class="form-label">Email/Số điện thoại/Tên đăng nhập</label>
                        <asp:TextBox ID="UsernameInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mật khẩu</label>
                        <div class="password-field">
                            <asp:TextBox ID="PasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                            <span class="toggle-eye"><i class="fa-regular fa-eye"></i></span>
                        </div>
                        <a class="buyer-login-link" href="#">Quên mật khẩu</a>
                    </div>
                    <asp:Button ID="LoginButton" runat="server" CssClass="btn btn-dark w-100 buyer-login-submit" Text="Đăng nhập" OnClick="LoginButton_Click" />
                    <div class="buyer-login-divider">
                        <span>Hoặc đăng nhập bằng</span>
                    </div>
                    <div class="buyer-login-social">
                        <a href="/tai-khoan/oauth-facebook.aspx"><i class="fa-brands fa-facebook-f"></i> Facebook</a>
                        <a href="/tai-khoan/oauth-google.aspx"><i class="fa-regular fa-envelope"></i> Google</a>
                    </div>
                    <div class="buyer-login-register">
                        Bạn mới bắt đầu LoveIs? <a href="/tai-khoan/dang-ky.aspx">Đăng ký</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
