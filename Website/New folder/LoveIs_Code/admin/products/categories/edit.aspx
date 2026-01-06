<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminProductCategoriesEdit" MasterPageFile="~/admin/admin.master" ValidateRequest="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Thêm / Sửa danh mục
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Thêm / Sửa danh mục
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật danh mục sản phẩm
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
    <li class="breadcrumb-item"><a href="/admin/products/categories/default.aspx">Danh mục</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/admin/assets/vendor/select2/select2.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-12">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thông tin danh mục</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="CategoryId" runat="server" />

                <ul class="nav nav-tabs" id="categoryTab" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="tab-basic" data-bs-toggle="tab" data-bs-target="#tab-basic-pane" type="button" role="tab"><i class="fa-solid fa-circle-info"></i> C&#417; b&#7843;n</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-media" data-bs-toggle="tab" data-bs-target="#tab-media-pane" type="button" role="tab"><i class="fa-regular fa-image"></i> H&#236;nh &#7843;nh</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-seo" data-bs-toggle="tab" data-bs-target="#tab-seo-pane" type="button" role="tab"><i class="fa-solid fa-magnifying-glass"></i> SEO</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-filters" data-bs-toggle="tab" data-bs-target="#tab-filters-pane" type="button" role="tab"><i class="fa-solid fa-filter"></i> Bộ lọc</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-social" data-bs-toggle="tab" data-bs-target="#tab-social-pane" type="button" role="tab"><i class="fa-solid fa-share-nodes"></i> Social</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-setting" data-bs-toggle="tab" data-bs-target="#tab-setting-pane" type="button" role="tab"><i class="fa-solid fa-gear"></i> Thi&#7871;t l&#7853;p</button>
    </li>
</ul>

                <div class="tab-content border border-top-0 rounded-bottom p-3">
                    <div class="tab-pane fade show active" id="tab-basic-pane" role="tabpanel">
                        <div class="mb-3">
                            <label class="form-label">Danh mục cha</label>
                            <asp:DropDownList ID="ParentIdInput" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tên danh mục</label>
                            <asp:TextBox ID="CategoryNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <asp:TextBox ID="DescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6"></asp:TextBox>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-media-pane" role="tabpanel">
                        <div class="row g-2">
                            <div class="col-md-4">
                                <label class="form-label">Icon</label>
                                <asp:FileUpload ID="IconUpload" runat="server" CssClass="form-control" />
                                <asp:HiddenField ID="IconUrlValue" runat="server" />
                                <div class="d-flex align-items-center gap-2 mt-2">
                                    <span class="text-muted small">Hiện tại</span>
                                    <asp:LinkButton ID="IconRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="IconRemoveButton_Click">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </asp:LinkButton>
                                </div>
                                <asp:Image ID="IconPreview" runat="server" CssClass="img-thumbnail mt-2 category-preview" Visible="false" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Logo</label>
                                <asp:FileUpload ID="LogoUpload" runat="server" CssClass="form-control" />
                                <asp:HiddenField ID="LogoUrlValue" runat="server" />
                                <div class="d-flex align-items-center gap-2 mt-2">
                                    <span class="text-muted small">Hiện tại</span>
                                    <asp:LinkButton ID="LogoRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="LogoRemoveButton_Click">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </asp:LinkButton>
                                </div>
                                <asp:Image ID="LogoPreview" runat="server" CssClass="img-thumbnail mt-2 category-preview" Visible="false" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Banner</label>
                                <asp:FileUpload ID="BannerUpload" runat="server" CssClass="form-control" />
                                <asp:HiddenField ID="BannerUrlValue" runat="server" />
                                <div class="d-flex align-items-center gap-2 mt-2">
                                    <span class="text-muted small">Hiện tại</span>
                                    <asp:LinkButton ID="BannerRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="BannerRemoveButton_Click">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </asp:LinkButton>
                                </div>
                                <asp:Image ID="BannerPreview" runat="server" CssClass="img-thumbnail mt-2 category-preview" Visible="false" />
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-seo-pane" role="tabpanel">
                        <div class="mb-3">
                            <label class="form-label">SEO Title</label>
                            <asp:TextBox ID="SeoTitleInput" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">SEO Slug</label>
                            <asp:TextBox ID="SeoSlugInput" runat="server" CssClass="form-control" placeholder="vi-du-danh-muc"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">SEO Description</label>
                            <asp:TextBox ID="SeoDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">SEO Keywords</label>
                            <asp:TextBox ID="SeoKeywordsInput" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <label class="form-label">Canonical URL</label>
                                <asp:TextBox ID="CanonicalUrlInput" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Robots</label>
                                <asp:TextBox ID="RobotsInput" runat="server" CssClass="form-control" placeholder="index,follow"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-filters-pane" role="tabpanel">
                        <asp:Label ID="FilterMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                        <label class="form-label">Nhóm bộ lọc</label>
                        <asp:ListBox ID="FilterGroupInput" runat="server" CssClass="form-select" SelectionMode="Multiple" Rows="6"></asp:ListBox>
                        <div class="form-text">Chọn các nhóm bộ lọc áp dụng cho danh mục.</div>
                    </div>

                    <div class="tab-pane fade" id="tab-social-pane" role="tabpanel">
                        <div class="row g-2">
                            <div class="col-md-6">
                                <label class="form-label">OG Title</label>
                                <asp:TextBox ID="OgTitleInput" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">OG Type</label>
                                <asp:TextBox ID="OgTypeInput" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">OG Description</label>
                            <asp:TextBox ID="OgDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">OG Image</label>
                            <asp:FileUpload ID="OgImageUpload" runat="server" CssClass="form-control" />
                            <asp:HiddenField ID="OgImageValue" runat="server" />
                            <div class="d-flex align-items-center gap-2 mt-2">
                                <span class="text-muted small">Hiện tại</span>
                                <asp:LinkButton ID="OgRemoveButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClick="OgRemoveButton_Click">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </asp:LinkButton>
                            </div>
                            <asp:Image ID="OgImagePreview" runat="server" CssClass="img-thumbnail mt-2 category-preview" Visible="false" />
                        </div>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <label class="form-label">Twitter Title</label>
                                <asp:TextBox ID="TwitterTitleInput" runat="server" CssClass="form-control"></asp:TextBox>
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
                                <asp:Image ID="TwitterImagePreview" runat="server" CssClass="img-thumbnail mt-2 category-preview" Visible="false" />
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Twitter Description</label>
                            <asp:TextBox ID="TwitterDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-setting-pane" role="tabpanel">
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
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                    <a href="/admin/products/categories/default.aspx" class="btn btn-outline-dark btn-with-icon">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/admin/assets/vendor/ckeditor/ckeditor.js"></script>
    <script src="/admin/assets/vendor/select2/select2.min.js"></script>
    <script>
        (function () {
            if (!window.CKEDITOR) {
                return;
            }

            CKEDITOR.plugins.addExternal("moxiemanager", "/admin/moxiemanager/", "plugin.js");
            CKEDITOR.replace("<%= DescriptionInput.ClientID %>", {
                extraPlugins: "moxiemanager,justify,colorbutton,font,embed,embedbase,embedsemantic,iframe",
                height: 220,
                toolbar: "Full",
                font_names: "Arial/Arial, Helvetica, sans-serif;Courier New/Courier New, Courier, monospace;Georgia/Georgia, serif;Roboto/Roboto, Arial, sans-serif;Tahoma/Tahoma, Geneva, sans-serif;Times New Roman/Times New Roman, Times, serif;Verdana/Verdana, Geneva, sans-serif",
                fontSize_sizes: "8/8px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;24/24px;28/28px;32/32px;36/36px;48/48px",
                versionCheck: false,
                filebrowserBrowseUrl: "/admin/moxiemanager/api.ashx",
                filebrowserImageBrowseUrl: "/admin/moxiemanager/api.ashx?type=image",
                filebrowserUploadUrl: "/admin/moxiemanager/api.ashx"
            });
        })();
    </script>
    <script>
        (function ($) {
            if (!$.fn.select2) {
                return;
            }

            $("#<%= ParentIdInput.ClientID %>").select2({ width: "100%" });
            $("#<%= FilterGroupInput.ClientID %>").select2({ width: "100%", placeholder: "Chọn nhóm bộ lọc" });
        })(jQuery);
    </script>
</asp:Content>


