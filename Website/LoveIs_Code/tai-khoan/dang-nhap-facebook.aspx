<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dang-nhap-facebook.aspx.cs" Inherits="CustomerFacebookCallback" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Đăng nhập Facebook</title>
    <link rel="stylesheet" href="/public/assets/css/public.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="oauth-message">
            <asp:Label ID="StatusMessage" runat="server" Text="Đang xử lý đăng nhập..." />
        </div>
    </form>
</body>
</html>
