<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminProductAttributesEdit" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Thêm / Sửa thuộc tính
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Thêm / Sửa thuộc tính
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật thuộc tính biến thể sản phẩm
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
    <li class="breadcrumb-item"><a href="/admin/products/attributes/default.aspx">Thuộc tính</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-12">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thông tin thuộc tính</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="AttributeId" runat="server" />

                <div class="mb-3">
                    <label class="form-label">Tên thuộc tính</label>
                    <asp:TextBox ID="AttributeNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <asp:TextBox ID="DescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                </div>
                <div class="row g-2 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">Thứ tự</label>
                        <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                    </div>
                    <div class="col-md-8">
                        <div class="form-check mb-2">
                            <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label" for="<%= StatusInput.ClientID %>">Hiển thị</label>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                    <a href="/admin/products/attributes/default.aspx" class="btn btn-outline-dark btn-with-icon">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3 mt-2">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thêm / Sửa giá trị</h6>
                <asp:Label ID="ValueMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="ValueEditId" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Tên giá trị</label>
                    <asp:TextBox ID="ValueNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thứ tự</label>
                    <asp:TextBox ID="ValueSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="ValueStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="<%= ValueStatusInput.ClientID %>">Hiển thị</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="ValueSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="ValueSaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="ValueResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ValueResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Danh sách giá trị</h6>
                <asp:Repeater ID="ValueRepeater" runat="server" OnItemCommand="ValueRepeater_ItemCommand">
                    <HeaderTemplate>
                        <div class="menu-table">
                            <div class="menu-row menu-header">
                                <div>Tên giá trị</div>
                                <div>Thứ tự</div>
                                <div>Trạng thái</div>
                                <div>Thao tác</div>
                            </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="menu-row">
                            <div><%# Eval("ValueName") %></div>
                            <div><%# Eval("SortOrder") %></div>
                            <div>
                                <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                    <%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %>
                                </span>
                            </div>
                            <div class="menu-actions">
                                <asp:LinkButton ID="EditButton" runat="server" CommandName="EditValue" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </asp:LinkButton>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteValue" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('Xóa giá trị này?');">
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
