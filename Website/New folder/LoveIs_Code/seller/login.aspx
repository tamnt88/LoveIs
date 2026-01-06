<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="SellerLogin" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="vi" dir="ltr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>LOVEis | Kênh Người Bán</title>
    <link rel="stylesheet" href="<%= ResolveUrl("~/public/theme/assets/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/public/assets/css/public.css") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/public/assets/vendor/fontawesome/css/all.min.css") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/seller/seller.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <header class="seller-topbar">
            <div class="container d-flex align-items-center justify-content-between py-3">
                <div class="brand">
                    <asp:Image ID="LogoImage" runat="server" AlternateText="LOVEis" />
                    <span>Kênh Người Bán</span>
                </div>
                <div>Bạn cần giúp đỡ?</div>
            </div>
        </header>

        <main class="seller-main">
            <div class="container">
                <div class="seller-grid">
                    <div>
                        <div class="seller-hero-title">Bán hàng chuyên nghiệp</div>
                        <div class="seller-hero-sub">
                            Quản lý shop của bạn một cách hiệu quả hơn<br />
                            trên LoveIs với LoveIs - Kênh Người bán
                        </div>
                        <div class="seller-banner">
                            <img src="<%= ResolveUrl("~/upload/seller.jpg") %>" alt="Seller" />
                        </div>
                    </div>
                    <div>
                        <div class="login-card">
                            <div class="login-tabs">
                                <span class="active">Đăng nhập</span>
                            </div>
                            <asp:Label ID="ErrorMessage" runat="server" CssClass="text-danger small d-block mb-3" />
                            <div class="mb-3">
                                <label class="form-label">Email/Số điện thoại/Tên đăng nhập</label>
                                <asp:TextBox ID="UsernameInput" runat="server" CssClass="form-control" placeholder="Email/Số điện thoại/Tên đăng nhập" />
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Mật khẩu</label>
                                <div class="password-wrap">
                                    <asp:TextBox ID="PasswordInput" runat="server" CssClass="form-control" TextMode="Password" placeholder="Mật khẩu" />
                                    <i class="fa-regular fa-eye"></i>
                                </div>
                            </div>
                            <div class="text-end mb-3">
                                <a href="#" class="text-decoration-none" style="color: var(--seller-primary);">Quên mật khẩu</a>
                            </div>
                            <asp:Button ID="LoginButton" runat="server" CssClass="btn btn-seller w-100" Text="ĐĂNG NHẬP" OnClick="LoginButton_Click" />
                            
                            <div class="text-center mt-3">
                                <span class="text-muted">Bạn mới bắt đầu LoveIs?</span>
                                <a href="#" class="text-decoration-none" style="color: var(--seller-primary);"> Đăng ký</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer class="seller-footer">
           © 2025 LoveIs. Tất cả các quyền được bảo lưu.
        </footer>
    </form>
</body>
</html>
