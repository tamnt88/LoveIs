<%@ Page Language="C#" AutoEventWireup="true" CodeFile="integrations.aspx.cs" Inherits="AdminSystemIntegrations" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Mã theo dõi
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Mã theo dõi
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Chèn mã theo dõi vào header và body
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Mã theo dõi</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="row g-3">
            <div class="col-12">
                <label class="form-label">Mã trong thẻ &lt;head&gt;</label>
                <asp:TextBox ID="HeaderCodeInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
            </div>
            <div class="col-12">
                <label class="form-label">Mã trước thẻ &lt;/body&gt;</label>
                <asp:TextBox ID="BodyCodeInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
            </div>
        </div>
        <div class="mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu cấu hình" OnClick="SaveButton_Click" />
        </div>
    </div>
</asp:Content>
