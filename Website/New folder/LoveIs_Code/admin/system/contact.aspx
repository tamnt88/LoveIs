<%@ Page Language="C#" AutoEventWireup="true" CodeFile="contact.aspx.cs" Inherits="AdminSystemContact" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Thông tin liên hệ
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Thông tin liên hệ
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật thông tin liên hệ của website
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Liên hệ</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Tên doanh nghiệp</label>
                <asp:TextBox ID="CompanyNameInput" runat="server" CssClass="form-control" placeholder="Nhập tên doanh nghiệp"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Hotline</label>
                <asp:TextBox ID="HotlineInput" runat="server" CssClass="form-control" placeholder="Nhập hotline"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Email</label>
                <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" placeholder="Nhập email liên hệ"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Địa chỉ</label>
                <asp:TextBox ID="AddressInput" runat="server" CssClass="form-control" placeholder="Nhập địa chỉ"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Link Google Map</label>
                <asp:TextBox ID="GoogleMapUrlInput" runat="server" CssClass="form-control" placeholder="https://maps.google.com/..."></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Logo ngang (URL)</label>
                <asp:TextBox ID="LogoHorizontalInput" runat="server" CssClass="form-control" placeholder="/images/logo_ngang.png"></asp:TextBox>
                <div class="mt-2">
                    <asp:FileUpload ID="LogoHorizontalUpload" runat="server" CssClass="form-control" />
                </div>
                <div class="mt-2 d-flex align-items-center gap-3">
                    <asp:Image ID="LogoHorizontalPreview" runat="server" CssClass="border rounded" Style="max-height:60px;" />
                    <div class="form-check">
                        <asp:CheckBox ID="LogoHorizontalRemove" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="LogoHorizontalRemove">Xóa ảnh</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label">Logo dọc (URL)</label>
                <asp:TextBox ID="LogoVerticalInput" runat="server" CssClass="form-control" placeholder="/images/logo_doc.png"></asp:TextBox>
                <div class="mt-2">
                    <asp:FileUpload ID="LogoVerticalUpload" runat="server" CssClass="form-control" />
                </div>
                <div class="mt-2 d-flex align-items-center gap-3">
                    <asp:Image ID="LogoVerticalPreview" runat="server" CssClass="border rounded" Style="max-height:60px;" />
                    <div class="form-check">
                        <asp:CheckBox ID="LogoVerticalRemove" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="LogoVerticalRemove">Xóa ảnh</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label">Fav icon (URL)</label>
                <asp:TextBox ID="FaviconInput" runat="server" CssClass="form-control" placeholder="/images/fav.png"></asp:TextBox>
                <div class="mt-2">
                    <asp:FileUpload ID="FaviconUpload" runat="server" CssClass="form-control" />
                </div>
                <div class="mt-2 d-flex align-items-center gap-3">
                    <asp:Image ID="FaviconPreview" runat="server" CssClass="border rounded" Style="max-height:40px;" />
                    <div class="form-check">
                        <asp:CheckBox ID="FaviconRemove" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="FaviconRemove">Xóa ảnh</label>
                    </div>
                </div>
            </div>
            <div class="col-12">
                <label class="form-label">Mã nhúng Google Map</label>
                <asp:TextBox ID="GoogleMapEmbedInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
            </div>
        </div>
        <div class="mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu thông tin" OnClick="SaveButton_Click" />
        </div>
    </div>
</asp:Content>
