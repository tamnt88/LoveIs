<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminCmsPostsEdit" MasterPageFile="~/admin/admin.master" ResponseEncoding="utf-8" ValidateRequest="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Thêm / Sửa bài viết
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Thêm / Sửa bài viết
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật nội dung bài viết
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="/admin/cms/posts/default.aspx">Bài viết</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="small d-block mb-2"></asp:Label>
        <asp:HiddenField ID="PostId" runat="server" />

        <div class="row g-3">
            <div class="col-12">
                <label class="form-label">Tiêu đề</label>
                <asp:TextBox ID="TitleInput" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-6">
                <label class="form-label">Danh mục</label>
                <asp:DropDownList ID="CategoryInput" runat="server" CssClass="form-select" />
            </div>
            <div class="col-md-6">
                <label class="form-label">Slug</label>
                <asp:TextBox ID="SeoSlugInput" runat="server" CssClass="form-control" />
            </div>
            <div class="col-12">
                <label class="form-label">Tóm tắt</label>
                <asp:TextBox ID="SummaryInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>
            <div class="col-12">
                <label class="form-label">Nội dung</label>
                <asp:TextBox ID="ContentInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="8" />
            </div>
            <div class="col-md-6">
                <label class="form-label">Ảnh đại diện</label>
                <asp:FileUpload ID="FeaturedImageUpload" runat="server" CssClass="form-control" />
                <asp:HiddenField ID="FeaturedImageValue" runat="server" />
                <div class="d-flex align-items-center gap-2 mt-2">
                    <span class="text-muted small">Hiện tại</span>
                    <asp:LinkButton ID="FeaturedImageRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="FeaturedImageRemoveButton_Click">
                        <i class="fa-solid fa-trash"></i> Xóa
                    </asp:LinkButton>
                </div>
                <asp:Image ID="FeaturedImagePreview" runat="server" CssClass="img-thumbnail mt-2 tag-preview" Visible="false" />
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
                <button class="nav-link active" id="tab-seo" data-bs-toggle="tab" data-bs-target="#seo" type="button" role="tab">
                    <i class="fa-solid fa-magnifying-glass"></i> SEO
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-social" data-bs-toggle="tab" data-bs-target="#social" type="button" role="tab">
                    <i class="fa-solid fa-share-nodes"></i> Social
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-tags" data-bs-toggle="tab" data-bs-target="#tags" type="button" role="tab">
                    <i class="fa-solid fa-tags"></i> Tag
                </button>
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
            <div class="tab-pane fade" id="tags" role="tabpanel">
                <label class="form-label">Chọn tag</label>
                <asp:ListBox ID="TagListInput" runat="server" CssClass="form-select" SelectionMode="Multiple" Rows="6" />
            </div>
        </div>

        <div class="mt-3">
            <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu bài viết" OnClick="SaveButton_Click" />
            <a href="/admin/cms/posts/default.aspx" class="btn btn-outline-secondary ms-2"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/admin/assets/vendor/select2/select2.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/admin/assets/vendor/select2/select2.min.js"></script>
    <script src="/admin/assets/vendor/ckeditor/ckeditor.js"></script>
    <script>
        (function () {
            var nameInput = document.getElementById("<%= TitleInput.ClientID %>");
            var slugInput = document.getElementById("<%= SeoSlugInput.ClientID %>");
            if (nameInput && slugInput) {
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
            }

            if (!window.CKEDITOR) {
                return;
            }
            CKEDITOR.plugins.addExternal("moxiemanager", "/admin/moxiemanager/", "plugin.js");
            CKEDITOR.replace("<%= ContentInput.ClientID %>", {
                extraPlugins: "moxiemanager,justify,colorbutton,font,embed,embedbase,embedsemantic,iframe",
                height: 320,
                toolbar: "Full",
                font_names: "Arial/Arial, Helvetica, sans-serif;Courier New/Courier New, Courier, monospace;Georgia/Georgia, serif;Roboto/Roboto, Arial, sans-serif;Tahoma/Tahoma, Geneva, sans-serif;Times New Roman/Times New Roman, Times, serif;Verdana/Verdana, Geneva, sans-serif",
                fontSize_sizes: "8/8px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;24/24px;28/28px;32/32px;36/36px;48/48px",
                versionCheck: false,
                filebrowserBrowseUrl: "/admin/moxiemanager/api.ashx",
                filebrowserImageBrowseUrl: "/admin/moxiemanager/api.ashx?type=image",
                filebrowserUploadUrl: "/admin/moxiemanager/api.ashx"
            });

            if (window.jQuery && $.fn.select2) {
                $("#<%= TagListInput.ClientID %>").select2({
                    width: "100%",
                    placeholder: "Chọn tag"
                });
            }
        })();
    </script>
</asp:Content>
