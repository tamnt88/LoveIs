<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminSystemBrandShowcasesEdit" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Cập nhật thương hiệu tiêu biểu
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Cập nhật thương hiệu tiêu biểu
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Thông tin video và banner hiển thị ở trang chủ
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item"><a href="/admin/system/brand-showcases/default.aspx">Thương hiệu tiêu biểu</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <h6 class="section-title mb-3">Thông tin thương hiệu</h6>
        <asp:HiddenField ID="ShowcaseId" runat="server" />
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Thương hiệu</label>
                <asp:DropDownList ID="BrandInput" runat="server" CssClass="form-select"></asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label">Tiêu đề hiển thị</label>
                <asp:TextBox ID="TitleInput" runat="server" CssClass="form-control" placeholder="Nhập tiêu đề (tuỳ chọn)"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Video (tải lên)</label>
                <asp:FileUpload ID="VideoUpload" runat="server" CssClass="form-control" />
                <div class="form-check mt-2">
                    <asp:CheckBox ID="VideoRemove" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="VideoRemove">Xóa video</label>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label">Thứ tự</label>
                <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                <div class="form-check mt-2">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="StatusInput">Hiển thị</label>
                </div>
            </div>
        </div>

        <asp:Panel ID="VideoPreviewPanel" runat="server" CssClass="mt-3" Visible="false">
            <label class="form-label">Video hiện tại</label>
            <div class="brand-video-preview">
                <video id="VideoPreview" runat="server" class="brand-video-preview__video" controls></video>
            </div>
        </asp:Panel>

        <div class="d-flex gap-2 mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-success btn-with-icon" Text="Lưu" OnClick="SaveButton_Click" />
            <a href="/admin/system/brand-showcases/default.aspx" class="btn btn-outline-secondary btn-with-icon">Quay lại</a>
        </div>
    </div>

    <asp:Panel ID="BannerPanel" runat="server" CssClass="card-kpi p-3 bg-white mt-4" Visible="false">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="section-title mb-0">Banner theo thương hiệu</h6>
            <span class="text-muted small">Hiển thị 4 banner đầu theo thứ tự</span>
        </div>
        <asp:Label ID="BannerMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>

        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Dòng tiêu đề 1</label>
                <asp:TextBox ID="BannerLine1Input" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Dòng tiêu đề 2</label>
                <asp:TextBox ID="BannerLine2Input" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Dòng tiêu đề 3</label>
                <asp:TextBox ID="BannerLine3Input" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Hình ảnh</label>
                <asp:TextBox ID="BannerImageUrlInput" runat="server" CssClass="form-control" placeholder="/upload/..." ></asp:TextBox>
                <asp:FileUpload ID="BannerImageUpload" runat="server" CssClass="form-control mt-2" />
                <div class="form-check mt-2">
                    <asp:CheckBox ID="BannerImageRemove" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="BannerImageRemove">Xóa ảnh</label>
                </div>
                <asp:Image ID="BannerImagePreview" runat="server" CssClass="img-thumbnail mt-2" Width="200" Visible="false" />
            </div>
            <div class="col-md-6">
                <label class="form-label">Liên kết</label>
                <asp:TextBox ID="BannerLinkUrlInput" runat="server" CssClass="form-control" placeholder="/san-pham/..." ></asp:TextBox>
                <label class="form-label mt-2">Text liên kết</label>
                <asp:TextBox ID="BannerLinkTextInput" runat="server" CssClass="form-control" placeholder="Xem thêm"></asp:TextBox>
                <div class="form-check mt-2">
                    <asp:CheckBox ID="BannerShowLinkInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="BannerShowLinkInput">Hiển thị liên kết</label>
                </div>
            </div>
            <div class="col-md-3">
                <label class="form-label">Thứ tự</label>
                <asp:TextBox ID="BannerSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <div class="form-check">
                    <asp:CheckBox ID="BannerStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="BannerStatusInput">Hiển thị</label>
                </div>
            </div>
        </div>

        <asp:HiddenField ID="BannerId" runat="server" />
        <div class="d-flex gap-2 mt-3">
            <asp:Button ID="SaveBannerButton" runat="server" CssClass="btn btn-success btn-with-icon" Text="Lưu banner" OnClick="SaveBannerButton_Click" />
            <asp:Button ID="ResetBannerButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" Text="Làm mới" OnClick="ResetBannerButton_Click" CausesValidation="false" />
        </div>

        <div class="table-responsive mt-3">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Ảnh</th>
                        <th>Tiêu đề</th>
                        <th>Thứ tự</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="BannerRepeater" runat="server" OnItemCommand="BannerRepeater_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td><img src='<%# Eval("ImageUrl") %>' alt="" class="img-thumbnail" style="width: 80px; height: 60px; object-fit: cover;" /></td>
                                <td><%# Eval("TitleLine2") %></td>
                                <td><%# Eval("SortOrder") %></td>
                                <td><%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %></td>
                                <td class="text-end">
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary btn-with-icon" CommandName="edit" CommandArgument='<%# Eval("Id") %>'>
                                        <i class="fa-solid fa-pen"></i> Sửa
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" CommandName="delete" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Xóa banner này?');">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </asp:Panel>
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .brand-video-preview {
            background: #f4efe7;
            border-radius: 12px;
            padding: 12px;
            max-width: 360px;
        }

        .brand-video-preview__video {
            width: 100%;
            border-radius: 10px;
        }
    </style>
</asp:Content>
