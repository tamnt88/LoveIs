<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminProductsEdit" MasterPageFile="~/admin/admin.master" ValidateRequest="false" ContentType="text/html; charset=utf-8" Culture="vi-VN" UICulture="vi-VN" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">

    Thêm / Sửa sản phẩm

</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">

    Thêm / Sửa sản phẩm

</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">

    Cập nhật thông tin sản phẩm

</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">

    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>

    <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>

    <li class="breadcrumb-item"><a href="/admin/products/default.aspx">Danh sách sản phẩm</a></li>

    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>

</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/admin/assets/vendor/select2/select2.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-12">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thông tin sản phẩm</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="ProductId" runat="server" />

                <ul class="nav nav-tabs" id="productTab" role="tablist">
    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="tab-basic" data-bs-toggle="tab" data-bs-target="#tab-basic-pane" type="button" role="tab"><i class="fa-solid fa-circle-info"></i> Cơ bản</button>
    </li>
    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-content" data-bs-toggle="tab" data-bs-target="#tab-content-pane" type="button" role="tab"><i class="fa-solid fa-align-left"></i> Nội dung</button>
    </li>
    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-images" data-bs-toggle="tab" data-bs-target="#tab-images-pane" type="button" role="tab"><i class="fa-regular fa-image"></i> Hình ảnh</button>
    </li>
    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-variants" data-bs-toggle="tab" data-bs-target="#tab-variants-pane" type="button" role="tab"><i class="fa-solid fa-layer-group"></i> Biến thể</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-filters" data-bs-toggle="tab" data-bs-target="#tab-filters-pane" type="button" role="tab"><i class="fa-solid fa-filter"></i> Bộ lọc</button>
    </li>
    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-seo" data-bs-toggle="tab" data-bs-target="#tab-seo-pane" type="button" role="tab"><i class="fa-solid fa-magnifying-glass"></i> SEO</button>
    </li>
    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-social" data-bs-toggle="tab" data-bs-target="#tab-social-pane" type="button" role="tab"><i class="fa-solid fa-share-nodes"></i> Social</button>
    </li>
    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-setting" data-bs-toggle="tab" data-bs-target="#tab-setting-pane" type="button" role="tab"><i class="fa-solid fa-gear"></i> Thiết lập</button>
    </li>
</ul>

                <div class="tab-content border border-top-0 rounded-bottom p-3">
                    <div class="tab-pane fade show active" id="tab-basic-pane" role="tabpanel">
                        <div class="mb-3">
                            <label class="form-label">Tên sản phẩm</label>
                            <asp:TextBox ID="ProductNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="row g-2">
                            <div class="col-md-4">
                                <label class="form-label">Danh mục</label>
                                <asp:DropDownList ID="CategoryInput" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="CategoryInput_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Thương hiệu</label>
                                <asp:DropDownList ID="BrandInput" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Xuất xứ</label>
                                <asp:DropDownList ID="OriginInput" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="mt-3">
                            <label class="form-label">Mô tả ngắn</label>
                            <asp:TextBox ID="ShortDescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-content-pane" role="tabpanel">
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <asp:TextBox ID="DescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Thông số</label>
                            <asp:TextBox ID="SpecificationInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Thành phần</label>
                            <asp:TextBox ID="IngredientsInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">H&#432;&#7899;ng d&#7851;n s&#7917; d&#7909;ng</label>
                            <asp:TextBox ID="UsageInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-images-pane" role="tabpanel">
                        <div class="row g-3">
                            <div class="col-lg-6">
                                <div class="card-kpi p-3 bg-white h-100">
                                    <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                                    <asp:Label ID="ImageMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                                    <div class="row g-2">
                                        <div class="col-12">
                                            <label class="form-label">&#7842;nh</label>
                                            <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control" />
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label">Alt text</label>
                                            <asp:TextBox ID="ImageAltInput" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row g-2 mt-2 align-items-end">
                                        <div class="col-md-4">
                                            <label class="form-label">Th&#7913; t&#7921;</label>
                                            <asp:TextBox ID="ImageSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-check mt-4">
                                                <asp:CheckBox ID="ImagePrimaryInput" runat="server" CssClass="form-check-input" />
                                                <label class="form-check-label" for="<%= ImagePrimaryInput.ClientID %>">&#7842;nh ch&#237;nh</label>
                                            </div>
                                        </div>
                                        <div class="col-md-4 d-flex gap-2 justify-content-md-end">
                                            <asp:LinkButton ID="ImageSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="ImageSaveButton_Click">
                                                <i class="fa-solid fa-floppy-disk"></i> L&#432;u &#7843;nh
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="ImageResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ImageResetButton_Click">
                                                <i class="fa-solid fa-rotate-right"></i> L&#224;m m&#7899;i
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="card-kpi p-3 bg-white h-100">
                                    <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                                    <div class="table-responsive">
                                        <asp:Repeater ID="ImageRepeater" runat="server" OnItemCommand="ImageRepeater_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table table-striped align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th>&#7842;nh</th>
                                                            <th>Alt text</th>
                                                            <th>Th&#7913; t&#7921;</th>
                                                            <th>Tr&#7841;ng th&#225;i</th>
                                                            <th class="text-end">H&#224;nh &#273;&#7897;ng</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><img src="<%# Eval("ImageUrl") %>" class="table-thumb" alt="<%# Eval("AltText") %>"></td>
                                                    <td><%# Eval("AltText") %></td>
                                                    <td><%# Eval("SortOrder") %></td>
                                                    <td><%# Eval("IsPrimaryTag") %></td>
                                                    <td class="text-end">
                                                        <asp:LinkButton ID="ImageSetPrimaryButton" runat="server" CssClass="btn btn-sm btn-outline-success btn-with-icon" CommandName="SetPrimary" CommandArgument='<%# Eval("Id") %>'>
                                                            <i class="fa-solid fa-star"></i> Ch&#237;nh
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="ImageDeleteButton" runat="server" CssClass="btn btn-sm btn-outline-danger btn-with-icon" CommandName="DeleteImage" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('X&#243;a &#7843;nh n&#224;y?');">
                                                            <i class="fa-solid fa-trash"></i> X&#243;a
                                                        </asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                    </tbody>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="tab-variants-pane" role="tabpanel">
                        <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                        <asp:Label ID="MatrixMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                        <asp:HiddenField ID="ActiveTabInput" runat="server" />
                        <div class="row g-3 align-items-stretch">
                            <div class="col-lg-6 d-flex">
                                <fieldset class="matrix-fieldset matrix-fieldset-left p-3 w-100">
                                    <legend class="matrix-legend">Ch&#7885;n thu&#7897;c t&#237;nh</legend>
                                    <div class="row g-2 align-items-end">
                                        <div class="col-lg-4">
                                            <label class="form-label">Thu&#7897;c t&#237;nh</label>
                                            <asp:DropDownList ID="MatrixAttributeSelect" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="MatrixAttributeSelect_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="col-lg-4">
                                            <label class="form-label">Gi&#225; tr&#7883;</label>
                                            <asp:ListBox ID="MatrixAttributeValueSelect" runat="server" CssClass="form-select matrix-value-select" SelectionMode="Multiple"></asp:ListBox>
                                        </div>
                                        <div class="col-lg-4 d-flex align-items-end">
                                            <asp:LinkButton ID="MatrixAddAttributeButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="MatrixAddAttributeButton_Click">
                                                <i class="fa-solid fa-plus"></i> Th&#234;m
                                            </asp:LinkButton>
                                            <asp:HiddenField ID="MatrixSelectedAttributeIds" runat="server" />
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <div class="col-lg-6 d-flex">
                                <div class="row g-2 w-100">
                                    <div class="col-12 d-flex">
                                        <fieldset class="matrix-fieldset matrix-fieldset-right p-3 w-100">
                                            <legend class="matrix-legend">Ch&#7885;n gi&#225; tr&#7883; cho t&#7915;ng thu&#7897;c t&#237;nh</legend>
                                            <asp:Repeater ID="MatrixValueRepeater" runat="server" OnItemDataBound="MatrixValueRepeater_ItemDataBound" OnItemCommand="MatrixValueRepeater_ItemCommand">
                                                <ItemTemplate>
                                                    <div class="row g-2 align-items-center mb-2">
                                                        <div class="col-lg-3">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="fw-semibold"><%# Eval("AttributeName") %></span>
                                                                <asp:LinkButton ID="MatrixRemoveAttributeButton" runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="remove" CommandArgument='<%# Eval("AttributeId") %>'>
                                                                    <i class="fa-solid fa-xmark"></i> X&#243;a
                                                                </asp:LinkButton>
                                                            </div>
                                                            <asp:HiddenField ID="MatrixAttrId" runat="server" Value='<%# Eval("AttributeId") %>' />
                                                        </div>
                                                        <div class="col-lg-9">
                                                            <asp:ListBox ID="MatrixValueList" runat="server" CssClass="form-select matrix-value-select" SelectionMode="Multiple"></asp:ListBox>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <div class="d-flex justify-content-end mt-3">
                                                <asp:LinkButton ID="MatrixGenerateButton" runat="server" CssClass="btn btn-outline-dark btn-with-icon" OnClick="MatrixGenerateButton_Click">
                                                    <i class="fa-solid fa-table-cells-large"></i> T&#7841;o matrix
                                                </asp:LinkButton>
                                            </div>
                                        </fieldset>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive mt-3">
                            <asp:Repeater ID="MatrixRepeater" runat="server">
                                <HeaderTemplate>
                                    <table class="table table-striped align-middle">
                                        <thead>
                                            <tr>
                                                <th>T&#7893; h&#7907;p thu&#7897;c t&#237;nh</th>
                                                <th>SKU</th>
                                                <th>Gi&#225;</th>
                                                <th>Gi&#225; KM</th>
                                                <th>T&#7891;n kho</th>
                                                <th>Tr&#7841;ng th&#225;i</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%# Eval("CombinationLabel") %>
                                            <asp:HiddenField ID="RowVariantId" runat="server" Value='<%# Eval("VariantId") %>' />
                                            <asp:HiddenField ID="RowValueIds" runat="server" Value='<%# Eval("ValueIds") %>' />
                                        </td>
                                        <td><asp:TextBox ID="RowSku" runat="server" CssClass="form-control" Text='<%# Eval("Sku") %>'></asp:TextBox></td>
                                        <td><asp:TextBox ID="RowPrice" runat="server" CssClass="form-control price-input" Text='<%# Eval("Price") %>'></asp:TextBox></td>
                                        <td><asp:TextBox ID="RowSalePrice" runat="server" CssClass="form-control price-input" Text='<%# Eval("SalePrice") %>'></asp:TextBox></td>
                                        <td><asp:TextBox ID="RowStock" runat="server" CssClass="form-control" Text='<%# Eval("StockQty") %>'></asp:TextBox></td>
                                        <td>
                                            <asp:CheckBox ID="RowStatus" runat="server" CssClass="form-check-input" Checked='<%# (bool)Eval("Status") %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="d-flex justify-content-end mt-3">
                            <asp:LinkButton ID="MatrixSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="MatrixSaveButton_Click">
                                <i class="fa-solid fa-floppy-disk"></i> L&#432;u bi&#7871;n th&#7875;
                            </asp:LinkButton>
                        </div>
                        <div class="d-none">
                            <div class="row g-3">
                                <div class="col-lg-4">
                                    <div class="card-kpi p-3 bg-white h-100">
                                        <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                                        <asp:Label ID="VariantMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                                        <asp:HiddenField ID="VariantEditId" runat="server" />
                                        <div class="mb-3">
                                            <label class="form-label">T&#234;n bi&#7871;n th&#7875;</label>
                                            <asp:TextBox ID="VariantNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">SKU</label>
                                            <asp:TextBox ID="VariantSkuInput" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="row g-2">
                                            <div class="col-md-6">
                                                <label class="form-label">Gi&#225;</label>
                                                <asp:TextBox ID="VariantPriceInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Gi&#225; khuy&#7871;n m&#227;i</label>
                                                <asp:TextBox ID="VariantSalePriceInput" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="row g-2 mt-2">
                                            <div class="col-md-6">
                                                <label class="form-label">T&#7891;n kho</label>
                                                <asp:TextBox ID="VariantStockInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Th&#7913; t&#7921;</label>
                                                <asp:TextBox ID="VariantSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-check mt-3">
                                            <asp:CheckBox ID="VariantStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                                            <label class="form-check-label" for="<%= VariantStatusInput.ClientID %>">Hi&#7875;n th&#7883;</label>
                                        </div>
                                        <div class="d-flex gap-2 mt-3">
                                            <asp:LinkButton ID="VariantSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="VariantSaveButton_Click">
                                                <i class="fa-solid fa-floppy-disk"></i> L&#432;u
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="VariantResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="VariantResetButton_Click">
                                                <i class="fa-solid fa-rotate-right"></i> L&#224;m m&#7899;i
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="card-kpi p-3 bg-white h-100">
                                        <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                                        <asp:Repeater ID="VariantRepeater" runat="server" OnItemCommand="VariantRepeater_ItemCommand">
                                            <HeaderTemplate>
                                                <div class="menu-table">
                                                    <div class="menu-row menu-header">
                                                        <div>Bi&#7871;n th&#7875;</div>
                                                        <div>SKU</div>
                                                        <div>Gi&#225;</div>
                                                        <div>T&#7891;n kho</div>
                                                        <div>Tr&#7841;ng th&#225;i</div>
                                                        <div>Thao t&#225;c</div>
                                                    </div>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="menu-row">
                                                    <div><%# Eval("VariantName") %></div>
                                                    <div><%# Eval("Sku") %></div>
                                                    <div><%# Eval("PriceLabel") %></div>
                                                    <div><%# Eval("StockQty") %></div>
                                                    <div>
                                                        <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                                            <%# (bool)Eval("Status") ? "Hi&#7875;n th&#7883;" : "&#7848;n" %>
                                                        </span>
                                                    </div>
                                                    <div class="menu-actions">
                                                        <asp:LinkButton ID="EditButton" runat="server" CommandName="EditVariant" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                                            <i class="fa-solid fa-pen"></i> S&#7917;a
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="AssignButton" runat="server" CommandName="SelectVariant" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark btn-with-icon">
                                                            <i class="fa-solid fa-link"></i> G&#225;n thu&#7897;c t&#237;nh
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteVariant" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('X&#243;a bi&#7871;n th&#7875; n&#224;y?');">
                                                            <i class="fa-solid fa-trash"></i> X&#243;a
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
                            <div class="row g-3 mt-3">
                                <div class="col-lg-4">
                                    <div class="card-kpi p-3 bg-white h-100">
                                        <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                                        <asp:Label ID="VariantAttrMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                                        <asp:HiddenField ID="VariantAttrEditId" runat="server" />
                                        <div class="mb-3">
                                            <label class="form-label">Ch&#7885;n bi&#7871;n th&#7875;</label>
                                            <asp:DropDownList ID="VariantSelectInput" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="VariantSelectInput_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Thu&#7897;c t&#237;nh</label>
                                            <asp:DropDownList ID="AttributeSelectInput" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="AttributeSelectInput_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Gi&#225; tr&#7883;</label>
                                            <asp:DropDownList ID="ValueSelectInput" runat="server" CssClass="form-select"></asp:DropDownList>
                                        </div>
                                        <div class="row g-2">
                                            <div class="col-md-6">
                                                <label class="form-label">Th&#7913; t&#7921;</label>
                                                <asp:TextBox ID="VariantAttrSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-check mt-4">
                                                    <asp:CheckBox ID="VariantAttrStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                                                    <label class="form-check-label" for="<%= VariantAttrStatusInput.ClientID %>">Hi&#7875;n th&#7883;</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex gap-2 mt-3">
                                            <asp:LinkButton ID="VariantAttrSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="VariantAttrSaveButton_Click">
                                                <i class="fa-solid fa-floppy-disk"></i> L&#432;u
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="VariantAttrResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="VariantAttrResetButton_Click">
                                                <i class="fa-solid fa-rotate-right"></i> L&#224;m m&#7899;i
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="card-kpi p-3 bg-white h-100">
                                        <h6 class="mb-3 section-title">Th&#244;ng tin s&#7843;n ph&#7849;m</h6>
                                        <asp:Repeater ID="VariantAttrRepeater" runat="server" OnItemCommand="VariantAttrRepeater_ItemCommand">
                                            <HeaderTemplate>
                                                <div class="menu-table">
                                                    <div class="menu-row menu-header">
                                                        <div>Bi&#7871;n th&#7875;</div>
                                                        <div>Thu&#7897;c t&#237;nh</div>
                                                        <div>Gi&#225; tr&#7883;</div>
                                                        <div>Th&#7913; t&#7921;</div>
                                                        <div>Tr&#7841;ng th&#225;i</div>
                                                        <div>Thao t&#225;c</div>
                                                    </div>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="menu-row">
                                                    <div><%# Eval("VariantName") %></div>
                                                    <div><%# Eval("AttributeName") %></div>
                                                    <div><%# Eval("ValueName") %></div>
                                                    <div><%# Eval("SortOrder") %></div>
                                                    <div>
                                                        <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                                            <%# (bool)Eval("Status") ? "Hi&#7875;n th&#7883;" : "&#7848;n" %>
                                                        </span>
                                                    </div>
                                                    <div class="menu-actions">
                                                        <asp:LinkButton ID="EditButton" runat="server" CommandName="EditVariantAttr" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                                            <i class="fa-solid fa-pen"></i> S&#7917;a
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteVariantAttr" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('X&#243;a thu&#7897;c t&#237;nh n&#224;y?');">
                                                            <i class="fa-solid fa-trash"></i> X&#243;a
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
                        </div>
                    </div>
                    <div class="tab-pane fade" id="tab-filters-pane" role="tabpanel">
                        <div class="card-kpi p-3 bg-white">
                            <h6 class="mb-2 section-title">B&#7897; l&#7885;c s&#7843;n ph&#7849;m</h6>
                            <p class="text-muted small mb-3">Ch&#7885;n b&#7897; l&#7885;c theo danh m&#7909;c &#273;&#227; ch&#7885;n &#7903; ph&#7847;n c&#417; b&#7843;n.</p>
                            <asp:Label ID="FilterMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                            <asp:Repeater ID="FilterGroupRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="filter-group">
                                        <div class="filter-group-title"><%# Eval("GroupName") %></div>
                                        <div class="filter-option-grid">
                                            <asp:Repeater ID="FilterOptionRepeater" runat="server" DataSource='<%# Eval("Options") %>'>
                                                <ItemTemplate>
                                                    <label class="filter-option">
                                                        <input type="checkbox" name="filterOption" value="<%# Eval("OptionId") %>" data-group-id="<%# Eval("GroupId") %>" <%# (bool)Eval("IsSelected") ? "checked=\"checked\"" : "" %> />
                                                        <span><%# Eval("OptionName") %></span>
                                                    </label>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="d-flex justify-content-end mt-3">
                                <asp:LinkButton ID="FilterSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="FilterSaveButton_Click">
                                    <i class="fa-solid fa-floppy-disk"></i> L&#432;u b&#7897; l&#7885;c
                                </asp:LinkButton>
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
                            <asp:TextBox ID="SeoSlugInput" runat="server" CssClass="form-control" placeholder="vi-du-san-pham"></asp:TextBox>
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
                                <span class="text-muted small">Hi&#7879;n t&#7841;i</span>
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
                                    <span class="text-muted small">Hi&#7879;n t&#7841;i</span>
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
                        <div class="row g-2 mb-3">
                            <div class="col-md-3">
                                <label class="form-label">C&#226;n n&#7863;ng (gram)</label>
                                <asp:TextBox ID="PackageWeightInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">D&#224;i (cm)</label>
                                <asp:TextBox ID="PackageLengthInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">R&#7897;ng (cm)</label>
                                <asp:TextBox ID="PackageWidthInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Cao (cm)</label>
                                <asp:TextBox ID="PackageHeightInput" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                        <div class="row g-2 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label">Th&#7913; t&#7921;</label>
                                <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                            </div>
                                                        <div class="col-md-8">
                                <div class="d-flex flex-wrap gap-3 mb-2">
                                    <div class="form-check">
                                        <asp:CheckBox ID="NewArrivalInput" runat="server" CssClass="form-check-input" />
                                        <label class="form-check-label" for="<%= NewArrivalInput.ClientID %>">New Arrival</label>
                                    </div>
                                    <div class="form-check">
                                        <asp:CheckBox ID="TrendingInput" runat="server" CssClass="form-check-input" />
                                        <label class="form-check-label" for="<%= TrendingInput.ClientID %>">Trending</label>
                                    </div>
                                    <div class="form-check">
                                        <asp:CheckBox ID="BestSellingInput" runat="server" CssClass="form-check-input" />
                                        <label class="form-check-label" for="<%= BestSellingInput.ClientID %>">Best Selling</label>
                                    </div>
                                </div>
                                <div class="form-check mb-2">
                                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                                    <label class="form-check-label" for="<%= StatusInput.ClientID %>">Hi&#7875;n th&#7883;</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu lại
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                    <a href="/admin/products/default.aspx" class="btn btn-outline-dark btn-with-icon">
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
            var editorIds = [
                "<%= DescriptionInput.ClientID %>",
                "<%= SpecificationInput.ClientID %>",
                "<%= IngredientsInput.ClientID %>",
                "<%= UsageInput.ClientID %>"
            ];

            editorIds.forEach(function (id) {
                CKEDITOR.replace(id, {
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
            });
        })();
    </script>
    <script>
        (function ($) {
            if (!$.fn.select2) {
                return;
            }

            $("#<%= VariantSelectInput.ClientID %>").select2({ width: "100%" });
            $("#<%= AttributeSelectInput.ClientID %>").select2({ width: "100%" });
            $("#<%= ValueSelectInput.ClientID %>").select2({ width: "100%" });
            $("#<%= MatrixAttributeSelect.ClientID %>").select2({ width: "100%" });
            $("#<%= MatrixAttributeValueSelect.ClientID %>").select2({ width: "100%" });
            $("#<%= CategoryInput.ClientID %>").select2({ width: "100%" });
            $("#<%= BrandInput.ClientID %>").select2({ width: "100%" });
            $("#<%= OriginInput.ClientID %>").select2({ width: "100%" });
            $(".matrix-value-select").select2({ width: "100%" });
            function formatVnNumber(value) {
                if (!value) {
                    return "";
                }
                var raw = value.toString().replace(/\D/g, "");
                if (!raw) {
                    return "";
                }
                return parseInt(raw, 10).toLocaleString("vi-VN");
            }

            $(document).on("focus", ".price-input", function () {
                $(this).val($(this).val().toString().replace(/\D/g, ""));
            });

            $(document).on("blur", ".price-input", function () {
                $(this).val(formatVnNumber($(this).val()));
            });

            $(".price-input").each(function () {
                $(this).val(formatVnNumber($(this).val()));
            });

            var activeTabInput = $("#<%= ActiveTabInput.ClientID %>");
            var savedTab = activeTabInput.val();
            if (savedTab) {
                var target = document.querySelector('[data-bs-toggle="tab"][data-bs-target="' + savedTab + '"]');
                if (target) {
                    bootstrap.Tab.getOrCreateInstance(target).show();
                }
            }

            document.querySelectorAll('[data-bs-toggle="tab"]').forEach(function (tab) {
                tab.addEventListener("shown.bs.tab", function (event) {
                    if (activeTabInput.length) {
                        activeTabInput.val(event.target.getAttribute("data-bs-target"));
                    }
                });
            });
        })(jQuery);
    </script>
</asp:Content>




















