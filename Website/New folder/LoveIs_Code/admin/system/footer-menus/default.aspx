<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminSystemFooterMenus" MasterPageFile="~/admin/admin.master" ContentType="text/html; charset=utf-8" CodePage="65001" Culture="vi-VN" UICulture="vi-VN" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Menu footer
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Menu footer
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý liên kết menu hiển thị ở footer public
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Menu footer</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white mb-3">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <asp:HiddenField ID="FooterMenuId" runat="server" />
        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Nhóm</label>
                <asp:TextBox ID="GroupNameInput" runat="server" CssClass="form-control" placeholder="Dịch vụ"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <label class="form-label">Thứ tự nhóm</label>
                <asp:TextBox ID="GroupSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Tiêu đề</label>
                <asp:TextBox ID="TitleInput" runat="server" CssClass="form-control" placeholder="Hướng dẫn lắp ráp"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Liên kết</label>
                <asp:TextBox ID="UrlInput" runat="server" CssClass="form-control" placeholder="/huong-dan-lap-rap"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <label class="form-label">Thứ tự</label>
                <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <div class="form-check">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="StatusInput">Hiển thị</label>
                </div>
            </div>
        </div>
        <div class="mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu menu" OnClick="SaveButton_Click" />
            <a class="btn btn-outline-secondary ms-2" href="/admin/system/footer-menus/default.aspx">Làm mới</a>
        </div>
    </div>

    <div class="card-kpi p-3 bg-white">
        <h6 class="mb-3">Danh sách menu footer</h6>
        <asp:Repeater ID="FooterRepeater" runat="server" OnItemCommand="FooterRepeater_ItemCommand">
            <HeaderTemplate>
                <div class="table-responsive">
                    <table class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Nhóm</th>
                                <th>Tiêu đề</th>
                                <th>Liên kết</th>
                                <th>Thứ tự nhóm</th>
                                <th>Thứ tự</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("GroupName") %></td>
                    <td><%# Eval("Title") %></td>
                    <td><%# Eval("Url") %></td>
                    <td><%# Eval("GroupSortOrder") %></td>
                    <td><%# Eval("SortOrder") %></td>
                    <td><%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %></td>
                    <td class="text-end">
                        <a class="btn btn-sm btn-outline-primary" href='/admin/system/footer-menus/default.aspx?id=<%# Eval("Id") %>'>Sửa</a>
                        <asp:LinkButton ID="DeleteButton" runat="server" CssClass="btn btn-sm btn-outline-danger ms-1"
                            CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Xóa menu này?');">
                            Xóa
                        </asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                        </tbody>
                    </table>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
