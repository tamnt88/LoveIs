<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminPermissionsDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Phân quyền
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Phân quyền
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Gán quyền cho role và người dùng
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item active" aria-current="page">Phân quyền</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Gán quyền cho role</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <div class="mb-3">
                    <label class="form-label">Chọn role</label>
                    <asp:DropDownList ID="RoleSelect" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="RoleSelect_SelectedIndexChanged"></asp:DropDownList>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu quyền
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Danh sách quyền</h6>
                <asp:Repeater ID="PermissionRepeater" runat="server">
                    <HeaderTemplate>
                        <div class="menu-table">
                            <div class="menu-row menu-header">
                                <div>Chọn</div>
                                <div>Nhóm</div>
                                <div>Action</div>
                                <div>Tên quyền</div>
                            </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="menu-row">
                            <div>
                                <asp:CheckBox ID="PermissionCheck" runat="server" CssClass="form-check-input" Checked='<%# Eval("IsGranted") %>' />
                                <asp:HiddenField ID="PermissionId" runat="server" Value='<%# Eval("Id") %>' />
                            </div>
                            <div><%# Eval("MenuGroup") %></div>
                            <div><%# Eval("ActionName") %></div>
                            <div><%# Eval("PermissionName") %></div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
    <div class="row g-3 mt-2">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thêm / Sửa quyền</h6>
                <asp:Label ID="PermissionFormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="PermissionEditId" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Nhóm</label>
                    <asp:TextBox ID="MenuGroupInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Action</label>
                    <asp:TextBox ID="ActionNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tên quyền</label>
                    <asp:TextBox ID="PermissionNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thứ tự</label>
                    <asp:TextBox ID="PermissionSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="PermissionStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="<%= PermissionStatusInput.ClientID %>">Hiển thị</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="PermissionSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="PermissionSaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="PermissionResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="PermissionResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Danh sách quyền (quản lý)</h6>
                <asp:Repeater ID="PermissionCatalogRepeater" runat="server" OnItemCommand="PermissionCatalogRepeater_ItemCommand">
                    <HeaderTemplate>
                        <div class="menu-table">
                            <div class="menu-row menu-header">
                                <div>Nhóm</div>
                                <div>Action</div>
                                <div>Tên quyền</div>
                                <div>Thứ tự</div>
                                <div>Trạng thái</div>
                                <div>Thao tác</div>
                            </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="menu-row">
                            <div><%# Eval("MenuGroup") %></div>
                            <div><%# Eval("ActionName") %></div>
                            <div><%# Eval("PermissionName") %></div>
                            <div><%# Eval("SortOrder") %></div>
                            <div>
                                <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                    <%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %>
                                </span>
                            </div>
                            <div class="menu-actions">
                                <asp:LinkButton ID="EditButton" runat="server" CommandName="EditPermission" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </asp:LinkButton>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeletePermission" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('Xóa quyền này?');">
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
