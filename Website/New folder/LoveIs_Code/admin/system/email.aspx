<%@ Page Language="C#" AutoEventWireup="true" CodeFile="email.aspx.cs" Inherits="AdminSystemEmail" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Tài khoản gửi email
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Tài khoản gửi email
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cấu hình email gửi thông báo
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Email</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Email gửi</label>
                <asp:TextBox ID="SenderEmailInput" runat="server" CssClass="form-control" placeholder="no-reply@beautystory.vn"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Mật khẩu</label>
                <asp:TextBox ID="SenderPasswordInput" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-12">
                <label class="form-label">Tên hiển thị</label>
                <asp:TextBox ID="SenderNameInput" runat="server" CssClass="form-control" placeholder="Beauty Story"></asp:TextBox>
            </div>
            <div class="col-12">
                <label class="form-label">Email nhận liên hệ</label>
                <asp:TextBox ID="ContactRecipientInput" runat="server" CssClass="form-control" placeholder="email1@gmail.com, email2@gmail.com"></asp:TextBox>
                <div class="form-text">Nhập nhiều email, ngăn cách bằng dấu phẩy.</div>
            </div>
            <div class="col-12">
                <label class="form-label">Email nhận đơn hàng</label>
                <asp:TextBox ID="OrderRecipientInput" runat="server" CssClass="form-control" placeholder="email1@gmail.com, email2@gmail.com"></asp:TextBox>
                <div class="form-text">Nhập nhiều email, ngăn cách bằng dấu phẩy.</div>
            </div>
        </div>
        <div class="mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu cấu hình" OnClick="SaveButton_Click" />
        </div>
    </div>
</asp:Content>
