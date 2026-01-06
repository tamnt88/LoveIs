<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminCmsTagsEdit" MasterPageFile="~/admin/admin.master" ResponseEncoding="utf-8" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Thêm / Sửa tag bài viết
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Thêm / Sửa tag bài viết
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật tag từ khóa cho bài viết
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Bài viết</a></li>
    <li class="breadcrumb-item"><a href="/admin/cms/tags/default.aspx">Tag bài viết</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="small d-block mb-2"></asp:Label>
        <asp:HiddenField ID="TagId" runat="server" />
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Tên tag</label>
                <asp:TextBox ID="TagNameInput" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-6">
                <label class="form-label">Slug</label>
                <asp:TextBox ID="SeoSlugInput" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-6">
                <label class="form-label">Hình đại diện</label>
                <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control" />
                <asp:HiddenField ID="ImageUrlValue" runat="server" />
                <div class="d-flex align-items-center gap-2 mt-2">
                    <span class="text-muted small">Hiện tại</span>
                    <asp:LinkButton ID="ImageRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="ImageRemoveButton_Click">
                        <i class="fa-solid fa-trash"></i> Xóa
                    </asp:LinkButton>
                </div>
                <asp:Image ID="ImagePreview" runat="server" CssClass="img-thumbnail mt-2 tag-preview" Visible="false" />
            </div>
            <div class="col-md-4">
                <label class="form-label">Thứ tự</label>
                <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0" />
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <div class="form-check">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label">Hiển thị</label>
                </div>
            </div>
        </div>

        <ul class="nav nav-tabs mt-4" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="tab-seo" data-bs-toggle="tab" data-bs-target="#seo" type="button" role="tab">SEO</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-social" data-bs-toggle="tab" data-bs-target="#social" type="button" role="tab">Social</button>
            </li>
        </ul>
        <div class="tab-content border border-top-0 p-3">
            <div class="tab-pane fade show active" id="seo" role="tabpanel">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">SEO Title</label>
                        <asp:TextBox ID="SeoTitleInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">SEO Keywords</label>
                        <asp:TextBox ID="SeoKeywordsInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-12">
                        <label class="form-label">SEO Description</label>
                        <asp:TextBox ID="SeoDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Canonical URL</label>
                        <asp:TextBox ID="CanonicalUrlInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Robots</label>
                        <asp:TextBox ID="RobotsInput" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="social" role="tabpanel">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">OG Title</label>
                        <asp:TextBox ID="OgTitleInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">OG Type</label>
                        <asp:TextBox ID="OgTypeInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-12">
                        <label class="form-label">OG Description</label>
                        <asp:TextBox ID="OgDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">OG Image</label>
                        <asp:FileUpload ID="OgImageUpload" runat="server" CssClass="form-control" />
                        <asp:HiddenField ID="OgImageValue" runat="server" />
                        <div class="d-flex align-items-center gap-2 mt-2">
                            <span class="text-muted small">Hiện tại</span>
                            <asp:LinkButton ID="OgRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="OgRemoveButton_Click">
                                <i class="fa-solid fa-trash"></i> Xóa
                            </asp:LinkButton>
                        </div>
                        <asp:Image ID="OgImagePreview" runat="server" CssClass="img-thumbnail mt-2 tag-preview" Visible="false" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Twitter Title</label>
                        <asp:TextBox ID="TwitterTitleInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-12">
                        <label class="form-label">Twitter Description</label>
                        <asp:TextBox ID="TwitterDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Twitter Image</label>
                        <asp:FileUpload ID="TwitterImageUpload" runat="server" CssClass="form-control" />
                        <asp:HiddenField ID="TwitterImageValue" runat="server" />
                        <div class="d-flex align-items-center gap-2 mt-2">
                            <span class="text-muted small">Hiện tại</span>
                            <asp:LinkButton ID="TwitterRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="TwitterRemoveButton_Click">
                                <i class="fa-solid fa-trash"></i> Xóa
                            </asp:LinkButton>
                        </div>
                        <asp:Image ID="TwitterImagePreview" runat="server" CssClass="img-thumbnail mt-2 tag-preview" Visible="false" />
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu tag" OnClick="SaveButton_Click" />
            <a class="btn btn-outline-secondary ms-2" href="/admin/cms/tags/edit.aspx">Làm mới</a>
            <a class="btn btn-outline-secondary ms-2" href="/admin/cms/tags/default.aspx">Quay lại</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        (function () {
            var nameInput = document.getElementById("<%= TagNameInput.ClientID %>");
            var slugInput = document.getElementById("<%= SeoSlugInput.ClientID %>");
            if (!nameInput || !slugInput) {
                return;
            }
            nameInput.addEventListener("input", function () {
                if (slugInput.value.trim() !== "") {
                    return;
                }
                var text = nameInput.value || "";
                var slug = text.toLowerCase()
                    .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
                    .replace(/[^a-z0-9\s-]/g, "")
                    .trim()
                    .replace(/\s+/g, "-")
                    .replace(/-+/g, "-");
                slugInput.value = slug;
            });
        })();
    </script>
</asp:Content>
