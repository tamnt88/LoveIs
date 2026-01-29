<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-import.aspx.cs" Inherits="SellerProductImport" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" ValidateRequest="false" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Nhập sản phẩm</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="import-master">
        <div class="import-list card">
            <div class="import-progress">
                <div class="import-progress-label">
                    <asp:Literal ID="ProgressLabelLiteral" runat="server" />
                </div>
                <div class="import-progress-bar">
                    <span class="import-progress-fill" style="width:<%= ProgressPercent %>%"></span>
                </div>
            </div>
            <div class="import-tabs">
                <a class="import-tab <%# GetFilterClass("all") %>" href="<%# BuildFilterUrl("all") %>">Tất cả (<asp:Literal ID="AllCountLiteral" runat="server" />)</a>
                <a class="import-tab <%# GetFilterClass("incomplete") %>" href="<%# BuildFilterUrl("incomplete") %>">Chưa hoàn thành (<asp:Literal ID="IncompleteCountLiteral" runat="server" />)</a>
                <a class="import-tab <%# GetFilterClass("complete") %>" href="<%# BuildFilterUrl("complete") %>">Đã hoàn thành (<asp:Literal ID="CompleteCountLiteral" runat="server" />)</a>
            </div>
            <asp:Repeater ID="ImportItemRepeater" runat="server">
                <ItemTemplate>
                    <div class="import-item <%# Eval("StatusClass") %>">
                        <%# Eval("ItemLink") %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="import-detail card">
            <div class="import-detail-header">
                <h3>Thông tin sản phẩm</h3>
                <span class="import-detail-subtitle">Điền đủ thông tin để hoàn tất nhập file.</span>
            </div>
            <asp:Literal ID="FormMessageLiteral" runat="server" />
            <asp:HiddenField ID="BatchIdInput" runat="server" />
            <asp:HiddenField ID="ItemIdInput" runat="server" />
            <asp:HiddenField ID="NextItemIdInput" runat="server" />
            <asp:HiddenField ID="VariantRowsInput" runat="server" />
            <asp:HiddenField ID="CategoryIdInput" runat="server" />
            <div class="product-section">
                <h4>Thông tin cơ bản</h4>
                <div class="form-group">
                    <label>Hình ảnh sản phẩm <span class="text-danger">*</span></label>
                    <div class="upload-box" id="imageUploadBox">
                        <div class="upload-preview" id="imagePreviewList">
                            <asp:Repeater ID="ImageRepeater" runat="server">
                                <ItemTemplate>
                                    <img src="<%# Eval("ImageUrl") %>" alt="Hình sản phẩm" />
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="upload-placeholder" id="imageUploadPlaceholder">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm hình</span>
                        </div>
                    </div>
                    <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control mt-2" Style="display:none;" AllowMultiple="true" accept="image/*" />
                    <div class="helper-text">Tải lên tối đa 9 ảnh. Định dạng: JPG, JPEG, PNG. Kích thước tối đa 5MB</div>
                </div>
                <div class="form-group">
                    <label>Video sản phẩm</label>
                    <div class="video-upload">
                        <button type="button" class="video-upload-btn" id="videoUploadBtn">
                            <i class="fa-solid fa-arrow-up-from-bracket"></i>
                            <span id="videoUploadLabel">Thêm video</span>
                        </button>
                        <asp:FileUpload ID="VideoUpload" runat="server" CssClass="form-control" Style="display:none;" />
                    </div>
                    <div class="helper-text">Kích thước tối đa 30Mb, độ phân giải không vượt quá 1280x1280px</div>
                </div>
                <div class="form-group">
                    <label>Tên sản phẩm <span class="text-danger">*</span></label>
                    <asp:TextBox ID="ProductNameInput" runat="server" CssClass="form-control" placeholder="Tên sản phẩm + Thương hiệu + Model + Thông số kỹ thuật" />
                    <div class="char-count">0/120</div>
                </div>
                <div class="form-grid three-col">
                    <div class="form-group">
                        <label>Ngành hàng <span class="text-danger">*</span></label>
                        <div class="category-select" id="CategorySelect">
                            <button type="button" class="category-select-btn" id="CategorySelectBtn" runat="server">
                                <span><asp:Literal ID="CategoryLabelLiteral" runat="server" /></span>
                                <i class="fa-solid fa-angle-down"></i>
                            </button>
                            <div class="category-select-menu" id="CategorySelectMenu">
                                <asp:Repeater ID="CategoryRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="category-select-item" data-category-id="<%# Eval("Id") %>" data-category-label="<%# Eval("Label") %>">
                                            <%# Eval("Label") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Thương hiệu</label>
                        <asp:DropDownList ID="BrandDropdown" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Xuất xứ</label>
                        <asp:DropDownList ID="OriginDropdown" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="product-section">
                <h4>Thông tin chi tiết</h4>
                <div class="form-group">
                    <label>Mô tả sản phẩm</label>
                    <asp:TextBox ID="DescriptionInput" runat="server" CssClass="editor-area" TextMode="MultiLine" />
                    <div class="helper-text">Tối đa 3000 ký tự</div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="product-section">
                <h4>Thông tin bán hàng</h4>
                <div class="form-group">
                    <label>Phân loại hàng</label>
                    <div class="variant-config" id="VariantConfig">
                        <div class="variant-config-row" id="VariantConfigRows"></div>
                        <div class="variant-config-actions">
                            <button type="button" class="btn-outline" id="AddVariantGroupBtn" runat="server"><i class="fa-solid fa-plus"></i> Thêm phân loại</button>
                            <button type="button" class="btn-outline" id="BuildVariantsBtn" runat="server"><i class="fa-solid fa-check"></i> Tạo biến thể</button>
                        </div>
                    </div>
                </div>
                <div class="variant-base-row four-col" id="VariantBaseRow">
                    <div class="form-group">
                        <label>SKU</label>
                        <asp:TextBox ID="SkuInput" runat="server" CssClass="form-control" placeholder="Nhập SKU" />
                    </div>
                    <div class="form-group">
                        <label>Giá <span class="text-danger">*</span></label>
                        <asp:TextBox ID="PriceInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                    </div>
                    <div class="form-group">
                        <label>Giá sau khuyến mãi</label>
                        <asp:TextBox ID="SalePriceInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                    </div>
                    <div class="form-group">
                        <label>Kho hàng <span class="text-danger">*</span></label>
                        <asp:TextBox ID="StockInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                    </div>
                </div>
                <div class="variant-rows" id="VariantRows"></div>
                <template id="VariantRowTemplate">
                    <div class="variant-row" data-variant-row="">
                        <div class="form-group">
                            <label>Tên biến thể</label>
                            <input type="text" class="form-control variant-name" readonly />
                        </div>
                        <div class="form-group">
                            <label>SKU</label>
                            <input type="text" class="form-control variant-sku" placeholder="Nhập SKU" />
                        </div>
                        <div class="form-group">
                            <label>Giá <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" placeholder="0" />
                        </div>
                        <div class="form-group">
                            <label>Giá sau khuyến mãi</label>
                            <input type="number" class="form-control" placeholder="0" />
                        </div>
                        <div class="form-group">
                            <label>Kho hàng <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" placeholder="0" />
                        </div>
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <label class="switch">
                                <input type="checkbox" class="variant-active" checked />
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                </template>
            </div>

            <div class="divider"></div>

            <div class="product-section">
                <h4>Vận chuyển</h4>
                <div class="alert-info">
                    <i class="fa-regular fa-circle-info"></i>
                    Để tính phí vận chuyển chính xác, vui lòng điền đầy đủ thông tin cân nặng và kích thước đóng gói sản phẩm
                </div>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>Cân nặng (Sau khi đóng gói) <span class="text-danger">*</span></label>
                        <div class="input-inline">
                            <asp:TextBox ID="WeightInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                            <span class="suffix">gr</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Kích thước đóng gói</label>
                        <div class="input-inline multi">
                            <asp:TextBox ID="LengthInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="R" />
                            <span class="suffix">x</span>
                            <asp:TextBox ID="WidthInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="D" />
                            <span class="suffix">x</span>
                            <asp:TextBox ID="HeightInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="C" />
                            <span class="suffix">cm</span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label>Phí vận chuyển</label>
                    <div class="radio-row">
                        <label><input type="radio" name="shipFee" checked /> Mặc định</label>
                        <label><input type="radio" name="shipFee" /> Tùy chỉnh</label>
                    </div>
                    <div class="helper-text">Vui lòng chọn đơn vị vận chuyển và thiết lập phí vận chuyển</div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="product-section">
                <h4>Thông tin khác</h4>
                <div class="form-group">
                    <label>Tình trạng</label>
                    <asp:DropDownList ID="ListingStatusDropdown" runat="server" CssClass="form-control" />
                </div>
            </div>

            <div class="form-actions right">
                <asp:Button ID="SaveNextButton" runat="server" CssClass="btn-outline" Text="Lưu & Tiếp tục" OnClick="SaveNextButton_Click" />
                <asp:Button ID="FinishButton" runat="server" CssClass="btn-primary" Text="Hoàn tất" OnClick="FinishButton_Click" Visible="false" />
            </div>
            <asp:Button ID="SaveSelectButton" runat="server" CssClass="d-none" Text="Chọn sản phẩm" OnClick="SaveSelectButton_Click" />
        </div>
    </div>

    <asp:Literal ID="VariantDataLiteral" runat="server" />

    <script src="/admin/assets/vendor/ckeditor/ckeditor.js"></script>
    <script>
        (function () {
            var input = document.getElementById('<%= ImageUpload.ClientID %>');
            var preview = document.getElementById('imagePreviewList');
            var box = document.getElementById('imageUploadBox');
            var placeholder = document.getElementById('imageUploadPlaceholder');
            var previewsData = [];

            if (input && preview) {
                if (box) {
                    box.addEventListener('click', function () {
                        input.click();
                    });
                }
                if (placeholder) {
                    placeholder.addEventListener('click', function (event) {
                        event.stopPropagation();
                        input.click();
                    });
                }

                function renderPreviews() {
                    preview.innerHTML = '';
                    previewsData.forEach(function (item) {
                        var img = document.createElement('img');
                        img.src = item.src;
                        img.alt = item.name;
                        preview.appendChild(img);
                    });
                }

                var existing = preview.querySelectorAll('img');
                if (existing.length > 0) {
                    existing.forEach(function (img) {
                        var src = img.getAttribute('src');
                        if (!src) return;
                        previewsData.push({ src: src, name: img.getAttribute('alt') || 'HĂ¬nh sáº£n pháº©m' });
                    });
                    renderPreviews();
                }

                input.addEventListener('change', function () {
                    var files = Array.prototype.slice.call(input.files || []);
                    if (files.length === 0) return;
                    files.forEach(function (file) {
                        if (previewsData.length >= 9) return;
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            previewsData.push({ src: e.target.result, name: file.name });
                            renderPreviews();
                        };
                        reader.readAsDataURL(file);
                    });
                });
            }

            var videoBtn = document.getElementById('videoUploadBtn');
            var videoInput = document.getElementById('<%= VideoUpload.ClientID %>');
            var videoLabel = document.getElementById('videoUploadLabel');
            if (videoBtn && videoInput) {
                videoBtn.addEventListener('click', function () {
                    videoInput.click();
                });
                videoInput.addEventListener('change', function () {
                    if (!videoLabel) return;
                    var file = videoInput.files && videoInput.files[0];
                    videoLabel.textContent = file ? file.name : 'Thêm video';
                });
            }

            if (window.CKEDITOR) {
                CKEDITOR.config.versionCheck = false;
                CKEDITOR.replace('<%= DescriptionInput.ClientID %>', {
                    height: 240,
                    removePlugins: 'uploadimage,uploadfile,filebrowser,flash',
                    removeButtons: 'Image,Upload,FileBrowser,Flash',
                    filebrowserBrowseUrl: '',
                    filebrowserImageBrowseUrl: '',
                    filebrowserUploadUrl: '',
                    filebrowserImageUploadUrl: ''
                });
            }

            var categorySelect = document.getElementById('CategorySelect');
            var categoryBtn = document.getElementById('<%= CategorySelectBtn.ClientID %>');
            var categoryMenu = document.getElementById('CategorySelectMenu');
            var categoryInput = document.getElementById('<%= CategoryIdInput.ClientID %>');
            var categoryLabel = categoryBtn ? categoryBtn.querySelector('span') : null;
            if (categoryBtn && categoryMenu && categoryInput) {
                categoryBtn.addEventListener('click', function (event) {
                    event.stopPropagation();
                    categoryMenu.classList.toggle('open');
                });
                categoryMenu.addEventListener('click', function (event) {
                    var target = event.target;
                    var item = target.closest('[data-category-id]');
                    if (!item) return;
                    var value = item.getAttribute('data-category-id');
                    var label = item.getAttribute('data-category-label') || item.textContent;
                    categoryInput.value = value;
                    if (categoryLabel) {
                        categoryLabel.textContent = label;
                    }
                    categoryMenu.classList.remove('open');
                });
                document.addEventListener('click', function (event) {
                    if (!categoryMenu.classList.contains('open')) return;
                    if (categorySelect && categorySelect.contains(event.target)) return;
                    categoryMenu.classList.remove('open');
                });
            }

            var variantRows = document.getElementById('VariantRows');
            var variantTemplate = document.getElementById('VariantRowTemplate');
            var variantRowsInput = document.getElementById('<%= VariantRowsInput.ClientID %>');
            var variantData = window.variantData || { attributes: [], values: [] };
            var presetRows = window.variantRows || [];
            var variantConfig = document.getElementById('VariantConfig');
            var variantConfigRows = document.getElementById('VariantConfigRows');
            var addVariantGroupBtn = document.getElementById('<%= AddVariantGroupBtn.ClientID %>');
            var buildVariantsBtn = document.getElementById('<%= BuildVariantsBtn.ClientID %>');
            var baseRow = document.getElementById('VariantBaseRow');
            var priceBase = document.getElementById('<%= PriceInput.ClientID %>');
            var salePriceBase = document.getElementById('<%= SalePriceInput.ClientID %>');
            var stockBase = document.getElementById('<%= StockInput.ClientID %>');

            function fillAttributes(selectEl) {
                if (!selectEl) return;
                selectEl.innerHTML = '<option value="">Chá»n thuá»™c tĂ­nh</option>';
                variantData.attributes.forEach(function (item) {
                    var option = document.createElement('option');
                    option.value = item.id;
                    option.textContent = item.name;
                    selectEl.appendChild(option);
                });
            }

            function renderValues(container, attributeId) {
                if (!container) return;
                container.innerHTML = '';
                if (!attributeId) {
                    return;
                }
                var values = variantData.values.filter(function (item) {
                    return item.attributeId === attributeId;
                });
                values.forEach(function (item) {
                    var option = document.createElement('option');
                    option.value = item.id;
                    option.textContent = item.name;
                    container.appendChild(option);
                });
            }

            function renderVariantGroups(groups) {
                if (!variantConfigRows) return;
                variantConfigRows.innerHTML = '';
                groups.forEach(function (group, index) {
                    var row = document.createElement('div');
                    row.className = 'variant-config-group';
                    row.innerHTML = '<div class="form-group"><label>Thuá»™c tĂ­nh</label><select class="form-control variant-attribute" data-index="' + index + '"></select></div>' +
                        '<div class="form-group"><label>GiĂ¡ trá»‹</label><select class="form-control variant-values" data-index="' + index + '" multiple></select></div>';
                    variantConfigRows.appendChild(row);
                    var attributeSelect = row.querySelector('.variant-attribute');
                    var valuesSelect = row.querySelector('.variant-values');
                    fillAttributes(attributeSelect);
                    if (group.attributeId) {
                        attributeSelect.value = group.attributeId;
                        renderValues(valuesSelect, group.attributeId);
                        if (group.values && group.values.length > 0) {
                            Array.prototype.slice.call(valuesSelect.options).forEach(function (opt) {
                                opt.selected = group.values.indexOf(parseInt(opt.value || '0', 10)) >= 0;
                            });
                        }
                    }
                    attributeSelect.addEventListener('change', function () {
                        var attributeId = parseInt(attributeSelect.value || '0', 10);
                        renderValues(valuesSelect, attributeId);
                    });
                });
            }

            function buildVariants() {
                if (!variantConfigRows || !variantTemplate || !variantRows) return;
                variantRows.innerHTML = '';
                var groups = [];
                var hasValid = false;
                Array.prototype.slice.call(variantConfigRows.querySelectorAll('.variant-config-group')).forEach(function (group) {
                    var attributeSelect = group.querySelector('.variant-attribute');
                    var valuesSelect = group.querySelector('.variant-values');
                    var attributeId = parseInt(attributeSelect.value || '0', 10);
                    if (!attributeId) return;
                    var values = Array.prototype.slice.call(valuesSelect.selectedOptions || []).map(function (opt) {
                        return parseInt(opt.value || '0', 10);
                    }).filter(function (v) { return v > 0; });
                    if (values.length === 0) return;
                    hasValid = true;
                    groups.push({ attributeId: attributeId, values: values });
                });

                if (!hasValid) {
                    variantRowsInput.value = '';
                    return;
                }

                var combinations = [[]];
                groups.forEach(function (group) {
                    var next = [];
                    combinations.forEach(function (combo) {
                        group.values.forEach(function (val) {
                            next.push(combo.concat([{ attributeId: group.attributeId, valueId: val }]));
                        });
                    });
                    combinations = next;
                });

                var rows = [];
                combinations.forEach(function (combo) {
                    var clone = document.importNode(variantTemplate.content, true);
                    var row = clone.querySelector('.variant-row');
                    row.dataset.variantRow = '1';
                    var nameBox = row.querySelector('.variant-name');
                    nameBox.value = combo.map(function (item) {
                        var value = variantData.values.find(function (v) { return v.id === item.valueId; });
                        return value ? value.name : '';
                    }).join(' - ');
                    row.querySelectorAll('input[type=number]')[0].value = priceBase ? priceBase.value : '';
                    row.querySelectorAll('input[type=number]')[1].value = salePriceBase ? salePriceBase.value : '';
                    row.querySelectorAll('input[type=number]')[2].value = stockBase ? stockBase.value : '';
                    row.dataset.variantMap = JSON.stringify(combo);
                    rows.push(row);
                    variantRows.appendChild(clone);
                });

                syncVariantRows();
            }

            function syncVariantRows() {
                if (!variantRowsInput || !variantRows) return;
                var rows = [];
                Array.prototype.slice.call(variantRows.querySelectorAll('.variant-row')).forEach(function (row) {
                    if (!row.dataset.variantMap) return;
                    var inputs = row.querySelectorAll('input');
                    rows.push({
                        name: inputs[0].value,
                        sku: inputs[1].value,
                        price: inputs[2].value,
                        salePrice: inputs[3].value,
                        stock: inputs[4].value,
                        active: inputs[5].checked,
                        mappings: JSON.parse(row.dataset.variantMap || '[]')
                    });
                });
                variantRowsInput.value = JSON.stringify(rows);
            }

            function bindVariantChange() {
                if (!variantRows) return;
                variantRows.addEventListener('input', function (event) {
                    var target = event.target;
                    if (!target) return;
                    if (target.closest('.variant-row')) {
                        syncVariantRows();
                    }
                });
                variantRows.addEventListener('change', function (event) {
                    var target = event.target;
                    if (!target) return;
                    if (target.closest('.variant-row')) {
                        syncVariantRows();
                    }
                });
            }

            if (variantConfigRows) {
                renderVariantGroups(presetRows || []);
            }
            if (addVariantGroupBtn) {
                addVariantGroupBtn.addEventListener('click', function () {
                    var groups = Array.prototype.slice.call(variantConfigRows.querySelectorAll('.variant-config-group')).map(function (group) {
                        return {
                            attributeId: parseInt(group.querySelector('.variant-attribute').value || '0', 10),
                            values: Array.prototype.slice.call(group.querySelector('.variant-values').selectedOptions || []).map(function (opt) {
                                return parseInt(opt.value || '0', 10);
                            })
                        };
                    });
                    groups.push({ attributeId: 0, values: [] });
                    renderVariantGroups(groups);
                });
            }
            if (buildVariantsBtn) {
                buildVariantsBtn.addEventListener('click', function () {
                    buildVariants();
                });
            }
            bindVariantChange();

            var selectButton = document.getElementById('<%= SaveSelectButton.ClientID %>');
            var nextInput = document.getElementById('<%= NextItemIdInput.ClientID %>');
            if (selectButton && nextInput) {
                document.addEventListener('click', function (event) {
                    var link = event.target.closest('.import-item-link');
                    if (!link || link.classList.contains('disabled')) return;
                    var itemId = link.getAttribute('data-item-id');
                    if (!itemId) return;
                    event.preventDefault();
                    nextInput.value = itemId;
                    selectButton.click();
                });
            }
        })();
    </script>
</asp:Content>







