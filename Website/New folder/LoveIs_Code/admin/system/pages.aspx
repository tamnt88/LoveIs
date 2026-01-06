<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pages.aspx.cs" Inherits="AdminSystemPages" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Trang hệ thống
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Trang hệ thống
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Gán trang tĩnh để cấu hình nội dung và SEO/Social cho trang hệ thống
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Trang hệ thống</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="small d-block mb-2"></asp:Label>

        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Trang</th>
                        <th>Trang tĩnh được gán</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="SystemPageRepeater" runat="server" OnItemDataBound="SystemPageRepeater_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <td class="fw-semibold"><%# Eval("PageName") %></td>
                                <td>
                                    <asp:HiddenField ID="SystemPageId" runat="server" Value='<%# Eval("Id") %>' />
                                    <asp:DropDownList ID="StaticPageSelect" runat="server" CssClass="form-select"></asp:DropDownList>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <div class="mt-3">
            <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                <i class="fa-solid fa-floppy-disk"></i> Lưu cấu hình
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>
