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
                <div class="form-grid two-col">
                    <div>
                        <label>Hình ảnh sản phẩm <span class="text-danger">*</span></label>
                        <div class="upload-box">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm hình</span>
                        </div>
                        <div class="helper-text">Thêm 0/9 ảnh. Tải lên tối đa 9 ảnh. Định dạng: JPG, JPEG, PNG. Kích thước tối đa 5MB</div>
                    </div>
                    <div>
                        <label>Video sản phẩm</label>
                        <button type="button" class="btn-outline upload-btn"><i class="fa-solid fa-upload"></i> Thêm video</button>
                        <div class="helper-text">Kích thước tối đa 30Mb, độ phân giải không vượt quá 1280x1280px</div>
                    </div>
                </div>
                <div class="form-group">
                    <label>Tên sản phẩm <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" placeholder="Tên sản phẩm + Thương hiệu + Model + Thông số kỹ thuật" />
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
                        <textarea class="editor-area"></textarea>
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
                        <input type="text" class="form-control" placeholder="Vui lòng nhập" />
                    </div>
                </div>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label>SKU sản phẩm</label>
                        <input type="text" class="form-control" placeholder="Vui lòng nhập" />
                    </div>
                    <div class="form-group">
                        <label>Chất liệu</label>
                        <input type="text" class="form-control" placeholder="Vui lòng nhập" />
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
                        <input type="number" class="form-control" placeholder="0" />
                    </div>
                    <div class="form-group">
                        <label>Giá sau khuyến mãi</label>
                        <input type="number" class="form-control" placeholder="0" />
                    </div>
                </div>
                <div class="form-group">
                    <label>Kho hàng <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" placeholder="0" />
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
                            <input type="number" class="form-control" placeholder="0" />
                            <span class="suffix">gr</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Kích thước đóng gói</label>
                        <div class="input-inline multi">
                            <input type="number" class="form-control" placeholder="R" />
                            <span class="suffix">x</span>
                            <input type="number" class="form-control" placeholder="D" />
                            <span class="suffix">x</span>
                            <input type="number" class="form-control" placeholder="C" />
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
                    <input type="text" class="form-control" placeholder="Nhập SKU người bán" />
                </div>
            </div>

            <div class="product-actions-footer">
                <button type="button" class="btn-outline">Hủy</button>
                <div class="action-gap"></div>
                <button type="button" class="btn-outline">Lưu & Ẩn</button>
                <button type="button" class="btn-primary">Lưu & Hiển thị</button>
            </div>
        </div>
    </div>
</asp:Content>
