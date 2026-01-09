<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-add.aspx.cs" Inherits="SellerProductAdd" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thêm Sản Phẩm</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-product-add">
        <div class="product-add-card card">
            <div class="product-add-header">
                <h2>Thêm Sản Phẩm Mới</h2>
            </div>
            <div class="product-section">
                <h4>Thông tin cơ bản</h4>
                <div class="form-group">
                    <label>Hình ảnh sản phẩm <span class="text-danger">*</span></label>
                    <div class="upload-box" id="imageUploadBox">
                        <div class="upload-previews" id="imagePreviewList"></div>
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
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>Ngành hàng <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="CategoryDropdown" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Thương hiệu</label>
                        <asp:DropDownList ID="BrandDropdown" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="product-section">
                <h4>Thông tin chi tiết</h4>
                <div class="form-group">
                    <label>Mô tả sản phẩm</label>
                    <div class="editor-box">
                        <div class="editor-toolbar">
                            <div class="btn-group">
                                <button type="button" class="btn-outline">B</button>
                                <button type="button" class="btn-outline">I</button>
                                <button type="button" class="btn-outline">U</button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn-outline">•</button>
                                <button type="button" class="btn-outline">1.</button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn-outline"><i class="fa-solid fa-link"></i></button>
                                <button type="button" class="btn-outline"><i class="fa-regular fa-image"></i></button>
                            </div>
                        </div>
                        <asp:TextBox ID="DescriptionInput" runat="server" CssClass="editor-area" TextMode="MultiLine" />
                    </div>
                    <div class="helper-text">Tối đa 3000 ký tự</div>
                </div>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>Nguồn gốc</label>
                        <asp:DropDownList ID="OriginDropdown" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Xuất xứ</label>
                        <asp:TextBox ID="OriginTextInput" runat="server" CssClass="form-control" placeholder="Vui lòng nhập" />
                    </div>
                </div>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>SKU sản phẩm</label>
                        <asp:TextBox ID="SkuInput" runat="server" CssClass="form-control" placeholder="Vui lòng nhập" />
                    </div>
                    <div class="form-group">
                        <label>Chất liệu</label>
                        <asp:TextBox ID="MaterialInput" runat="server" CssClass="form-control" placeholder="Vui lòng nhập" />
                    </div>
                </div>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>Gửi từ</label>
                        <asp:DropDownList ID="WarehouseDropdown" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Tình trạng sản phẩm</label>
                        <select class="form-control"><option>Vui lòng chọn</option></select>
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="product-section">
                <h4>Thông tin bán hàng</h4>
                <div class="form-group">
                    <label>Phân loại hàng</label>
                    <button type="button" class="btn-outline"><i class="fa-solid fa-plus"></i> Thêm phân loại hàng</button>
                    <div class="helper-text">Bạn có thể thêm tối đa 2 nhóm phân loại (Ví dụ: Màu sắc, Kích cỡ)</div>
                </div>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>Giá <span class="text-danger">*</span></label>
                        <asp:TextBox ID="PriceInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                    </div>
                    <div class="form-group">
                        <label>Giá sau khuyến mãi</label>
                        <asp:TextBox ID="SalePriceInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                    </div>
                </div>
                <div class="form-group">
                    <label>Kho hàng <span class="text-danger">*</span></label>
                    <asp:TextBox ID="StockInput" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
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
                    <select class="form-control"><option>Vui lòng chọn</option></select>
                </div>
                <div class="form-group">
                    <label>SKU Người bán</label>
                    <asp:TextBox ID="SellerSkuInput" runat="server" CssClass="form-control" placeholder="Nhập SKU người bán" />
                </div>
            </div>

            <div class="product-actions-footer">
                <asp:Button ID="CancelButton" runat="server" CssClass="btn-outline" Text="Hủy" CausesValidation="false" />
                <div class="action-gap"></div>
                <asp:Button ID="SaveDraftButton" runat="server" CssClass="btn-outline" Text="Lưu & Ẩn" OnClick="SaveDraftButton_Click" />
                <asp:Button ID="SavePublishButton" runat="server" CssClass="btn-primary" Text="Lưu & Hiển thị" OnClick="SavePublishButton_Click" />
            </div>
            <asp:Literal ID="FormMessageLiteral" runat="server" />
        </div>
    </div>
    <script>
        (function () {
            var input = document.getElementById('<%= ImageUpload.ClientID %>');
            var preview = document.getElementById('imagePreviewList');
            var box = document.getElementById('imageUploadBox');
            var placeholder = document.getElementById('imageUploadPlaceholder');
            var previewsData = [];
            if (!input || !preview) return;

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
        })();
    </script>
</asp:Content>
