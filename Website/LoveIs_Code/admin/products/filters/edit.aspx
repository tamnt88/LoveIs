<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminProductFiltersEdit" MasterPageFile="~/admin/admin.master" ValidateRequest="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Thêm / Sửa bộ lọc
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Thêm / Sửa bộ lọc
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật nhóm bộ lọc sản phẩm
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
    <li class="breadcrumb-item"><a href="/admin/products/filters/default.aspx">Bộ lọc</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-12">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thông tin nhóm lọc</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="GroupId" runat="server" />

                <ul class="nav nav-tabs" id="filterTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="tab-basic" data-bs-toggle="tab" data-bs-target="#tab-basic-pane" type="button" role="tab">Cơ bản</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-seo" data-bs-toggle="tab" data-bs-target="#tab-seo-pane" type="button" role="tab">SEO</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-social" data-bs-toggle="tab" data-bs-target="#tab-social-pane" type="button" role="tab">Social</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-setting" data-bs-toggle="tab" data-bs-target="#tab-setting-pane" type="button" role="tab">Thiết lập</button>
                    </li>
                </ul>

                <div class="tab-content border border-top-0 rounded-bottom p-3">
                    <div class="tab-pane fade show active" id="tab-basic-pane" role="tabpanel">
                        <div class="mb-3">
                            <label class="form-label">Tên nhóm lọc</label>
                            <asp:TextBox ID="GroupNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <asp:TextBox ID="DescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-seo-pane" role="tabpanel">
                        <div class="mb-3">
                            <label class="form-label">SEO Title</label>
                            <asp:TextBox ID="SeoTitleInput" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">SEO Slug</label>
                            <asp:TextBox ID="SeoSlugInput" runat="server" CssClass="form-control" placeholder="vi-du-bo-loc"></asp:TextBox>
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
                    <a href="/admin/products/filters/default.aspx" class="btn btn-outline-dark btn-with-icon">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3 mt-2">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thêm / Sửa tuỳ chọn</h6>
                <asp:Label ID="OptionMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="OptionEditId" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Tên tuỳ chọn</label>
                    <asp:TextBox ID="OptionNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <asp:TextBox ID="OptionDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thứ tự</label>
                    <asp:TextBox ID="OptionSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="OptionStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="<%= OptionStatusInput.ClientID %>">Hiển thị</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="OptionSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="OptionSaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="OptionResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="OptionResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Danh sách tuỳ chọn</h6>
                <asp:Repeater ID="OptionRepeater" runat="server" OnItemCommand="OptionRepeater_ItemCommand">
                    <HeaderTemplate>
                        <div class="menu-table">
                            <div class="menu-row menu-header">
                                <div>Tên tuỳ chọn</div>
                                <div>Thứ tự</div>
                                <div>Trạng thái</div>
                                <div>Thao tác</div>
                            </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="menu-row">
                            <div><%# Eval("OptionName") %></div>
                            <div><%# Eval("SortOrder") %></div>
                            <div>
                                <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                    <%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %>
                                </span>
                            </div>
                            <div class="menu-actions">
                                <asp:LinkButton ID="EditButton" runat="server" CommandName="EditOption" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </asp:LinkButton>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteOption" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('Xóa tuỳ chọn này?');">
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
