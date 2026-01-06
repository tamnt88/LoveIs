<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminSystemBannersEdit" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Cập nhật banner
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Cập nhật banner
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Thông tin banner trang chủ
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item"><a href="/admin/system/banners/default.aspx">Banner</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <asp:HiddenField ID="BannerId" runat="server" />
        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Dòng tiêu đề 1</label>
                <asp:TextBox ID="TitleLine1Input" runat="server" CssClass="form-control" placeholder="Deal upto 30%"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Dòng tiêu đề 2</label>
                <asp:TextBox ID="TitleLine2Input" runat="server" CssClass="form-control" placeholder="Beauty Care"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Dòng tiêu đề 3</label>
                <asp:TextBox ID="TitleLine3Input" runat="server" CssClass="form-control" placeholder="From $29.99"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Hình ảnh (URL)</label>
                <asp:TextBox ID="ImageUrlInput" runat="server" CssClass="form-control" placeholder="/upload/banners/..."></asp:TextBox>
                <div class="mt-2">
                    <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control" />
                </div>
                <div class="mt-2 d-flex align-items-center gap-3">
                    <asp:Image ID="ImagePreview" runat="server" CssClass="border rounded" Style="max-height:80px;" />
                    <div class="form-check">
                        <asp:CheckBox ID="ImageRemove" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="ImageRemove">Xóa ảnh</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label">Liên kết</label>
                <asp:TextBox ID="LinkUrlInput" runat="server" CssClass="form-control" placeholder="/san-pham/..."></asp:TextBox>
                <div class="mt-2">
                    <label class="form-label">Text liên kết</label>
                    <asp:TextBox ID="LinkTextInput" runat="server" CssClass="form-control" placeholder="Shop now"></asp:TextBox>
                </div>
                <div class="form-check mt-2">
                    <asp:CheckBox ID="ShowLinkInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="ShowLinkInput">Hiển thị liên kết</label>
                </div>
            </div>
            <div class="col-md-12">
                <div class="alert alert-light border mb-0">
                    <strong>Media cho banner vị trí 1</strong>
                    <div class="text-muted small">Nếu chọn Video, banner trang chủ sẽ hiển thị video thay vì ảnh.</div>
                </div>
            </div>
            <div class="col-md-3">
                <label class="form-label">Loại media</label>
                <asp:DropDownList ID="MediaTypeInput" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Hình ảnh" Value="Image" />
                    <asp:ListItem Text="Video" Value="Video" />
                </asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label">Media URL (ảnh/video)</label>
                <asp:TextBox ID="MediaUrlInput" runat="server" CssClass="form-control" placeholder="/upload/banners/..."></asp:TextBox>
                <div class="mt-2">
                    <asp:FileUpload ID="MediaUpload" runat="server" CssClass="form-control" />
                </div>
                <div class="mt-2 d-flex align-items-center gap-3">
                    <asp:Image ID="MediaPreview" runat="server" CssClass="border rounded" Style="max-height:80px;" />
                    <asp:HyperLink ID="MediaVideoLink" runat="server" Target="_blank" CssClass="small text-decoration-underline">Xem video</asp:HyperLink>
                    <div class="form-check">
                        <asp:CheckBox ID="MediaRemove" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="MediaRemove">Xóa media</label>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <label class="form-label">Poster (video)</label>
                <asp:TextBox ID="PosterUrlInput" runat="server" CssClass="form-control" placeholder="/upload/banners/..."></asp:TextBox>
                <div class="mt-2">
                    <asp:FileUpload ID="PosterUpload" runat="server" CssClass="form-control" />
                </div>
                <div class="mt-2 d-flex align-items-center gap-3">
                    <asp:Image ID="PosterPreview" runat="server" CssClass="border rounded" Style="max-height:80px;" />
                    <div class="form-check">
                        <asp:CheckBox ID="PosterRemove" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="PosterRemove">Xóa ảnh</label>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <label class="form-label">Vị trí</label>
                <asp:DropDownList ID="PositionInput" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Vị trí 1" Value="1" />
                    <asp:ListItem Text="Vị trí 2" Value="2" />
                    <asp:ListItem Text="Vị trí 3" Value="3" />
                    <asp:ListItem Text="Vị trí 4" Value="4" />
                    <asp:ListItem Text="Vị trí 5" Value="5" />
                    <asp:ListItem Text="Vị trí 6" Value="6" />
                </asp:DropDownList>
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
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu banner" OnClick="SaveButton_Click" />
            <a href="/admin/system/banners/default.aspx" class="btn btn-outline-secondary ms-2">Quay lại</a>
        </div>
    </div>
</asp:Content>
