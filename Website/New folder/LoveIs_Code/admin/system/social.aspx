<%@ Page Language="C#" AutoEventWireup="true" CodeFile="social.aspx.cs" Inherits="AdminSystemSocial" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Mạng xã hội
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Mạng xã hội
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý danh sách liên kết mạng xã hội
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Mạng xã hội</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white mb-3">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <asp:HiddenField ID="SocialId" runat="server" />
        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Tên hiển thị</label>
                <asp:TextBox ID="DisplayNameInput" runat="server" CssClass="form-control" placeholder="Facebook"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Icon (class)</label>
                <asp:TextBox ID="IconClassInput" runat="server" CssClass="form-control" placeholder="fa-brands fa-facebook-f"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Link</label>
                <asp:TextBox ID="UrlInput" runat="server" CssClass="form-control" placeholder="https://facebook.com/beautystory"></asp:TextBox>
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
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu liên kết" OnClick="SaveButton_Click" />
            <a class="btn btn-outline-secondary ms-2" href="/admin/system/social.aspx">Làm mới</a>
        </div>
    </div>

    <div class="card-kpi p-3 bg-white">
        <h6 class="mb-3">Danh sách mạng xã hội</h6>
        <asp:Repeater ID="SocialRepeater" runat="server" OnItemCommand="SocialRepeater_ItemCommand">
            <HeaderTemplate>
                <div class="table-responsive">
                    <table class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Tên</th>
                                <th>Icon</th>
                                <th>Link</th>
                                <th>Thứ tự</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("DisplayName") %></td>
                    <td><%# Eval("IconClass") %></td>
                    <td><%# Eval("Url") %></td>
                    <td><%# Eval("SortOrder") %></td>
                    <td><%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %></td>
                    <td class="text-end">
                        <a class="btn btn-sm btn-outline-primary" href='/admin/system/social.aspx?id=<%# Eval("Id") %>'>Sửa</a>
                        <asp:LinkButton ID="DeleteButton" runat="server" CssClass="btn btn-sm btn-outline-danger ms-1"
                            CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Xóa liên kết này?');">
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
