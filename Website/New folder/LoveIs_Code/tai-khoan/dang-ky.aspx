<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dang-ky.aspx.cs" Inherits="CustomerRegister" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Đăng ký
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-5 buyer-login buyer-register">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <div class="buyer-login-content">
                    <h1>Đăng ký để mua sắm nhanh hơn</h1>
                    <p>Tạo tài khoản LoveIs để lưu danh sách yêu thích, theo dõi đơn hàng và nhận ưu đãi dành riêng cho bạn.</p>
                </div>
                <div class="buyer-login-banner">
                    <img src="/upload/banner_net_quyen_ru.png" alt="LoveIs" />
                </div>
            </div>
            <div class="col-lg-6">
                <div class="buyer-login-card">
                    <div class="buyer-login-tabs">
                        <button type="button" class="active">Đăng ký</button>
                    </div>
                    <asp:Label ID="ErrorMessage" runat="server" CssClass="text-danger small d-block mb-3" />
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Tên đăng nhập</label>
                            <asp:TextBox ID="UsernameInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên hiển thị</label>
                            <asp:TextBox ID="DisplayNameInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu</label>
                            <asp:TextBox ID="PasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Xác nhận mật khẩu</label>
                            <asp:TextBox ID="ConfirmPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                        </div>
                    </div>
                    <asp:Button ID="RegisterButton" runat="server" CssClass="btn btn-dark w-100 buyer-login-submit mt-3" Text="Tạo tài khoản" OnClick="RegisterButton_Click" />
                    <div class="buyer-login-divider">
                        <span>Hoặc đăng ký bằng</span>
                    </div>
                    <div class="buyer-login-social">
                        <a href="/tai-khoan/oauth-facebook.aspx"><i class="fa-brands fa-facebook-f"></i> Facebook</a>
                        <a href="/tai-khoan/oauth-google.aspx"><i class="fa-regular fa-envelope"></i> Google</a>
                    </div>
                    <div class="buyer-login-register">
                        Đã có tài khoản? <a href="/tai-khoan/dang-nhap.aspx">Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
