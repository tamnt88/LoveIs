<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminRolesDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Quản lý role
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Quản lý role
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý nhóm quyền (role)
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item active" aria-current="page">Quản lý role</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thêm / Sửa role</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="RoleId" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Tên role</label>
                    <asp:TextBox ID="RoleNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <asp:TextBox ID="RoleDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thứ tự</label>
                    <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="<%= StatusInput.ClientID %>">Hiển thị</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Danh sách role</h6>
                <asp:Repeater ID="RoleRepeater" runat="server" OnItemCommand="RoleRepeater_ItemCommand">
                    <HeaderTemplate>
                        <div class="menu-table">
                            <div class="menu-row menu-header">
                                <div>Tên role</div>
                                <div>Mô tả</div>
                                <div>Thứ tự</div>
                                <div>Trạng thái</div>
                                <div>Thao tác</div>
                            </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="menu-row">
                            <div><strong><%# Eval("RoleName") %></strong></div>
                            <div><%# Eval("RoleDescription") %></div>
                            <div><%# Eval("SortOrder") %></div>
                            <div>
                                <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                    <%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %>
                                </span>
                            </div>
                            <div class="menu-actions">
                                <asp:LinkButton ID="EditButton" runat="server" CommandName="EditRole" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </asp:LinkButton>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteRole" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('Xóa role này?');">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>
