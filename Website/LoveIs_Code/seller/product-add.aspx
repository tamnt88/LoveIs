<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-add.aspx.cs" Inherits="SellerProductAdd" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thêm Sản Phẩm</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-product-add">
            <div class="product-add-card card">
            <div class="product-add-header">
                <h2><asp:Literal ID="FormTitleLiteral" runat="server" Text="Thêm Sản Phẩm Mới" /></h2>
            </div>
            <div class="product-section">
                <h4>Thông tin cơ bản</h4>
                <div class="form-group">
                    <label>Hình ảnh sản phẩm <span class="text-danger">*</span></label>
                    <div class="upload-box" id="imageUploadBox">
                        <div class="upload-previews" id="imagePreviewList">
                            <asp:Literal ID="ImagePreviewLiteral" runat="server" />
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
                                <span><asp:Literal ID="CategorySelectedLiteral" runat="server" Text="Vui lòng chọn" /></span>
                                <i class="fa-solid fa-angle-down"></i>
                            </button>
                            <div class="category-select-menu" id="CategorySelectMenu">
                                <asp:Literal ID="CategoryMenuLiteral" runat="server" />
                            </div>
                            <asp:HiddenField ID="CategoryIdInput" runat="server" />
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
                        <div class="variant-config-rows" id="VariantConfigRows">
                            <div class="variant-config-row" data-variant-group="1">
                            <div class="form-group">
                                <label>Nhóm phân loại 1</label>
                                <select class="form-control variant-attr-select" data-variant-attr="1">
                                    <option value="">Chọn thuộc tính</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Giá trị</label>
                                <div class="variant-values" data-variant-values="1"></div>
                            </div>
                        </div>
                        </div>
                        <div class="variant-config-actions">
                            <button type="button" class="btn-outline" id="AddVariantGroupBtn" runat="server"><i class="fa-solid fa-plus"></i> Thêm phân loại</button>
                            <button type="button" class="btn-outline" id="BuildVariantsBtn" runat="server"><i class="fa-solid fa-check"></i> Tạo biến thể</button>
                        </div>
                    </div>

                    <div class="variant-base-row" id="VariantBaseRow">
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
                    <asp:HiddenField ID="VariantRowsInput" runat="server" />
                    <asp:Literal ID="VariantDataLiteral" runat="server" />
                </div>
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

            <div class="product-actions-footer">
                <asp:Button ID="CancelButton" runat="server" CssClass="btn-outline" Text="Hủy" CausesValidation="false" OnClick="CancelButton_Click" />
                <div class="action-gap"></div>
                <asp:Button ID="SaveDraftButton" runat="server" CssClass="btn-outline" Text="Lưu & Ẩn" OnClick="SaveDraftButton_Click" />
                <asp:Button ID="SavePublishButton" runat="server" CssClass="btn-primary" Text="Lưu & Hiển thị" OnClick="SavePublishButton_Click" />
            </div>
                    <asp:Literal ID="FormMessageLiteral" runat="server" />
                    <asp:HiddenField ID="ViewModeInput" runat="server" />
        </div>
    </div>
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
                    input.value = '';
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
            var viewModeInput = document.getElementById('<%= ViewModeInput.ClientID %>');

            function fillAttributes(selectEl) {
                if (!selectEl) return;
                selectEl.innerHTML = '<option value="">Chọn thuộc tính</option>';
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
                var options = variantData.values.filter(function (item) { return item.attributeId === attributeId; });
                options.forEach(function (item) {
                    var label = document.createElement('label');
                    label.className = 'variant-value-option';
                    var checkbox = document.createElement('input');
                    checkbox.type = 'checkbox';
                    checkbox.value = item.id;
                    checkbox.setAttribute('data-value-label', item.name);
                    label.appendChild(checkbox);
                    var text = document.createElement('span');
                    text.textContent = item.name;
                    label.appendChild(text);
                    container.appendChild(label);
                });
            }

            function getSelectedAttributeIds(excludeSelect) {
                var ids = [];
                if (!variantConfigRows) return ids;
                var selects = variantConfigRows.querySelectorAll('.variant-attr-select');
                selects.forEach(function (selectEl) {
                    if (excludeSelect && selectEl === excludeSelect) return;
                    var id = parseInt(selectEl.value || '0', 10);
                    if (id > 0) {
                        ids.push(id);
                    }
                });
                return ids;
            }

            function fillAttributesWithExclusions(selectEl) {
                if (!selectEl) return;
                var selected = getSelectedAttributeIds(selectEl);
                selectEl.innerHTML = '<option value="">Chọn thuộc tính</option>';
                variantData.attributes.forEach(function (item) {
                    if (selected.indexOf(item.id) !== -1) return;
                    var option = document.createElement('option');
                    option.value = item.id;
                    option.textContent = item.name;
                    selectEl.appendChild(option);
                });
            }

            function refreshAttributeOptions() {
                if (!variantConfigRows) return;
                var selects = variantConfigRows.querySelectorAll('.variant-attr-select');
                selects.forEach(function (selectEl) {
                    var current = selectEl.value;
                    fillAttributesWithExclusions(selectEl);
                    if (current) {
                        selectEl.value = current;
                    }
                });
            }

            function bindVariantConfigRow(row) {
                if (!row) return;
                var selectEl = row.querySelector('.variant-attr-select');
                if (!selectEl) return;
                fillAttributesWithExclusions(selectEl);
                selectEl.addEventListener('change', function () {
                    var groupId = selectEl.getAttribute('data-variant-attr');
                    var valuesBox = variantConfigRows.querySelector('[data-variant-values="' + groupId + '"]');
                    renderValues(valuesBox, parseInt(selectEl.value || '0', 10));
                    refreshAttributeOptions();
                });
            }

            function createVariantConfigRow(index, attributeId, selectedValues) {
                if (!variantConfigRows) return;
                var row = document.createElement('div');
                row.className = 'variant-config-row';
                row.setAttribute('data-variant-group', index.toString());
                row.innerHTML =
                    '<div class="form-group">' +
                    '<label>Nhóm phân loại ' + index + '</label>' +
                    '<select class="form-control variant-attr-select" data-variant-attr="' + index + '">' +
                    '<option value="">Chọn thuộc tính</option>' +
                    '</select>' +
                    '</div>' +
                    '<div class="form-group">' +
                    '<label>Giá trị</label>' +
                    '<div class="variant-values" data-variant-values="' + index + '"></div>' +
                    '</div>';
                variantConfigRows.appendChild(row);
                bindVariantConfigRow(row);
                var selectEl = row.querySelector('.variant-attr-select');
                if (selectEl && attributeId) {
                    selectEl.value = attributeId.toString();
                    var valuesBox = row.querySelector('[data-variant-values="' + index + '"]');
                    renderValues(valuesBox, attributeId);
                    if (selectedValues && selectedValues.length > 0 && valuesBox) {
                        var checkboxes = valuesBox.querySelectorAll('input[type="checkbox"]');
                        checkboxes.forEach(function (cb) {
                            if (selectedValues.indexOf(parseInt(cb.value, 10)) !== -1) {
                                cb.checked = true;
                            }
                        });
                    }
                }
                return row;
            }

            function buildVariantConfigFromPresets() {
                if (!variantConfigRows || presetRows.length === 0) return;
                var order = [];
                var map = {};
                presetRows.forEach(function (row) {
                    var mappings = row.mappings || [];
                    mappings.forEach(function (m) {
                        var attrId = m.attributeId || m.AttributeId || 0;
                        var valueId = m.valueId || m.ValueId || 0;
                        if (!attrId || !valueId) {
                            return;
                        }
                        if (!map[attrId]) {
                            map[attrId] = [];
                            order.push(attrId);
                        }
                        if (map[attrId].indexOf(valueId) === -1) {
                            map[attrId].push(valueId);
                        }
                    });
                });
                variantConfigRows.innerHTML = '';
                order.forEach(function (attrId, idx) {
                    createVariantConfigRow(idx + 1, attrId, map[attrId]);
                });
                refreshAttributeOptions();
            }

            function bindVariantConfig() {
                if (!variantConfigRows) return;
                var rows = variantConfigRows.querySelectorAll('.variant-config-row');
                rows.forEach(function (row) {
                    bindVariantConfigRow(row);
                });
                refreshAttributeOptions();
            }

            function getGroupSelections() {
                if (!variantConfig) return [];
                var groups = [];
                var selects = variantConfig.querySelectorAll('.variant-attr-select');
                selects.forEach(function (selectEl) {
                    var attributeId = parseInt(selectEl.value || '0', 10);
                    var groupId = selectEl.getAttribute('data-variant-attr');
                    var valuesBox = variantConfig.querySelector('[data-variant-values="' + groupId + '"]');
                    var values = [];
                    if (valuesBox) {
                        var checkboxes = valuesBox.querySelectorAll('input[type="checkbox"]:checked');
                        checkboxes.forEach(function (cb) {
                            values.push({
                                id: parseInt(cb.value, 10),
                                label: cb.getAttribute('data-value-label') || cb.parentNode.textContent.trim()
                            });
                        });
                    }
                    if (attributeId > 0 && values.length > 0) {
                        groups.push({
                            attributeId: attributeId,
                            values: values
                        });
                    }
                });
                return groups;
            }

            function applyVariantData(row, data) {
                if (!row || !data) return;
                var inputs = row.querySelectorAll('input[type="number"]');
                var nameInput = row.querySelector('.variant-name');
                var skuInput = row.querySelector('.variant-sku');
                var activeInput = row.querySelector('.variant-active');
                row.setAttribute('data-mappings', JSON.stringify(data.mappings || []));
                if (nameInput) {
                    nameInput.value = data.name || '';
                }
                if (skuInput) {
                    skuInput.value = data.sku || '';
                }
                if (activeInput) {
                    activeInput.checked = data.active !== false;
                }
                if (inputs.length > 0) {
                    inputs[0].value = data.price !== null && data.price !== undefined ? data.price : '';
                }
                if (inputs.length > 1) {
                    inputs[1].value = data.salePrice !== null && data.salePrice !== undefined ? data.salePrice : '';
                }
                if (inputs.length > 2) {
                    inputs[2].value = data.stock !== null && data.stock !== undefined ? data.stock : '';
                }
            }

            function buildVariantRows() {
                if (!variantRows || !variantTemplate) return;
                variantRows.innerHTML = '';
                var groups = getGroupSelections();
                if (groups.length === 0) {
                    if (baseRow) {
                        baseRow.classList.remove('hidden');
                    }
                    return;
                }

                var combinations = [{}];
                groups.forEach(function (group) {
                    var next = [];
                    combinations.forEach(function (combo) {
                        group.values.forEach(function (value) {
                            var clone = {
                                mappings: (combo.mappings || []).slice()
                            };
                            clone.mappings.push({
                                attributeId: group.attributeId,
                                valueId: value.id,
                                valueLabel: value.label
                            });
                            next.push(clone);
                        });
                    });
                    combinations = next;
                });

                combinations.forEach(function (combo, index) {
                    var clone = document.importNode(variantTemplate.content, true);
                    var row = clone.querySelector('.variant-row');
                    row.setAttribute('data-variant-row', (index + 1).toString());
                    var nameInput = row.querySelector('.variant-name');
                    var skuInput = row.querySelector('.variant-sku');
                    var activeInput = row.querySelector('.variant-active');
                    var inputs = row.querySelectorAll('input[type="number"]');
                    var name = combo.mappings.map(function (m) { return m.valueLabel; }).join(' + ');
                    row.setAttribute('data-mappings', JSON.stringify(combo.mappings.map(function (m) {
                        return { attributeId: m.attributeId, valueId: m.valueId };
                    })));
                    if (nameInput) {
                        nameInput.value = name;
                    }
                    if (skuInput) {
                        skuInput.value = '';
                    }
                    if (activeInput) {
                        activeInput.checked = true;
                    }
                    if (inputs.length > 0 && priceBase) {
                        inputs[0].value = priceBase.value || '';
                    }
                    if (inputs.length > 1 && salePriceBase) {
                        inputs[1].value = salePriceBase.value || '';
                    }
                    if (inputs.length > 2 && stockBase) {
                        inputs[2].value = stockBase.value || '';
                    }
                    variantRows.appendChild(clone);
                });

                if (baseRow) {
                    baseRow.classList.add('hidden');
                }
            }

            if (buildVariantsBtn) {
                buildVariantsBtn.addEventListener('click', function () {
                    buildVariantRows();
                });
            }

            if (addVariantGroupBtn && variantConfigRows) {
                addVariantGroupBtn.addEventListener('click', function () {
                    var rows = variantConfigRows.querySelectorAll('.variant-config-row');
                    var nextIndex = rows.length + 1;
                    createVariantConfigRow(nextIndex, 0, []);
                    refreshAttributeOptions();
                });
            }

            if (variantRows && presetRows.length > 0) {
                if (baseRow) {
                    baseRow.classList.add('hidden');
                }
                for (var i = 0; i < presetRows.length; i++) {
                    var clone = document.importNode(variantTemplate.content, true);
                    var row = clone.querySelector('.variant-row');
                    row.setAttribute('data-variant-row', (i + 1).toString());
                    variantRows.appendChild(clone);
                    applyVariantData(row, presetRows[i]);
                }
            }

            if (presetRows.length > 0) {
                buildVariantConfigFromPresets();
            } else {
                bindVariantConfig();
            }

            if (viewModeInput && viewModeInput.value === 'view') {
                if (variantConfig) {
                    var selects = variantConfig.querySelectorAll('select');
                    selects.forEach(function (el) { el.disabled = true; });
                    var checks = variantConfig.querySelectorAll('input[type="checkbox"]');
                    checks.forEach(function (el) { el.disabled = true; });
                }
                if (variantRows) {
                    var inputs = variantRows.querySelectorAll('input');
                    inputs.forEach(function (el) { el.disabled = true; });
                }
                if (addVariantGroupBtn) {
                    addVariantGroupBtn.disabled = true;
                }
                if (buildVariantsBtn) {
                    buildVariantsBtn.disabled = true;
                }
            }

            function parseNumber(value) {
                if (value === null || value === undefined) return null;
                var num = parseFloat(value);
                return isNaN(num) ? null : num;
            }

            function parseIntValue(value) {
                if (value === null || value === undefined) return null;
                var num = parseInt(value, 10);
                return isNaN(num) ? null : num;
            }

            function collectVariantRows() {
                if (!variantRowsInput) return;
                var rows = [];
                var rowEls = variantRows ? variantRows.querySelectorAll('.variant-row') : [];
                rowEls.forEach(function (row) {
                    var inputs = row.querySelectorAll('input[type="number"]');
                    var nameInput = row.querySelector('.variant-name');
                    var skuInput = row.querySelector('.variant-sku');
                    var activeInput = row.querySelector('.variant-active');
                    var mappings = row.getAttribute('data-mappings');
                    var parsedMappings = [];
                    if (mappings) {
                        try {
                            parsedMappings = JSON.parse(mappings) || [];
                        } catch (err) {
                            parsedMappings = [];
                        }
                    }
                    rows.push({
                        name: nameInput ? nameInput.value : '',
                        sku: skuInput ? skuInput.value : '',
                        active: activeInput ? activeInput.checked : true,
                        mappings: parsedMappings.map(function (m) {
                            return {
                                attributeId: m.attributeId || m.AttributeId || 0,
                                valueId: m.valueId || m.ValueId || 0
                            };
                        }),
                        price: inputs[0] ? parseNumber(inputs[0].value) : null,
                        salePrice: inputs[1] ? parseNumber(inputs[1].value) : null,
                        stock: inputs[2] ? parseIntValue(inputs[2].value) : null
                    });
                });
                variantRowsInput.value = JSON.stringify(rows);
            }

            var form = document.getElementById('form1');
            if (form) {
                form.addEventListener('submit', collectVariantRows);
            }
        })();
    </script>
</asp:Content>
