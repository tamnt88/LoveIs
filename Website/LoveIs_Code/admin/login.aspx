<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="AdminLogin" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">
<head runat="server">
    <title>Đăng nhập quản trị | LoveIs Store</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/png" href="/images/fav.png" />
    <link href="/admin/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/admin/assets/vendor/fontawesome/css/all.min.css" rel="stylesheet" />
    <link href="/admin/assets/vendor/flaticon/css/all.css" rel="stylesheet" />
    <link href="/admin/assets/css/admin.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server" class="container">
        <div class="login-card bg-white p-4 p-md-5">
            <div class="brand mb-4 justify-content-center">
                <img src="/images/logo_doc.png" alt="BeautyStory" />
            </div>
            <asp:Label ID="ErrorMessage" runat="server" CssClass="text-danger small d-block mb-3"></asp:Label>
            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <asp:TextBox ID="Username" runat="server" CssClass="form-control" placeholder="Nhập tên đăng nhập"></asp:TextBox>
            </div>
            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu"></asp:TextBox>
            </div>
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div class="form-check">
                    <asp:CheckBox ID="RememberMe" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="<%= RememberMe.ClientID %>">Nhớ đăng nhập</label>
                </div>
            </div>
            <div class="d-grid">
                <asp:Button ID="LoginButton" runat="server" Text="Đăng nhập" CssClass="btn btn-primary" OnClick="LoginButton_Click" />
            </div>
            <div class="mt-4 small text-center footer-note">
                Hệ thống quản trị LoveIs Store. Version 1.0
            </div>
        </div>
    </form>
    <script src="/admin/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/admin/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
