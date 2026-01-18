<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-locked.aspx.cs" Inherits="SellerProductLocked" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Sản phẩm bị khóa</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-product-locked">
        <div class="locked-header">
            <div>
                <h2>Sản Phẩm Bị Khóa</h2>
                <p>Danh sách sản phẩm bị khóa và lý do</p>
            </div>
        </div>

        <div class="locked-alert">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <div>
                <strong>Lưu ý:</strong> Sản phẩm bị khóa sẽ không hiển thị trên gian hàng và không thể bán.
                <div>Vui lòng chỉnh sửa sản phẩm theo yêu cầu và gửi lại để được xét duyệt.</div>
            </div>
        </div>

        <div class="locked-summary-grid">
            <div class="card locked-summary-card">
                <span class="locked-summary-icon danger"><i class="fa-solid fa-lock"></i></span>
                <div class="locked-summary-label">Tổng SP Bị Khóa</div>
                <div class="locked-summary-value text-danger">12</div>
            </div>
            <div class="card locked-summary-card">
                <span class="locked-summary-icon warn"><i class="fa-regular fa-eye"></i></span>
                <div class="locked-summary-label">Đang Xét Duyệt</div>
                <div class="locked-summary-value text-warn">3</div>
            </div>
            <div class="card locked-summary-card">
                <span class="locked-summary-icon ok"><i class="fa-solid fa-lock-open"></i></span>
                <div class="locked-summary-label">Đã Mở Khóa</div>
                <div class="locked-summary-value text-ok">8</div>
            </div>
        </div>

        <div class="card locked-table">
            <div class="locked-table-title">Danh Sách Sản Phẩm Bị Khóa</div>
            <div class="locked-table-head">
                <div>Mã SP</div>
                <div>Tên Sản Phẩm</div>
                <div>Lý Do Khóa</div>
                <div>Ngày Khóa</div>
                <div>Trạng Thái</div>
                <div>Thao Tác</div>
            </div>
            <div class="locked-row">
                <div>SP001</div>
                <div>Set Đồ Lót Cao Cấp</div>
                <div class="text-danger">Hình ảnh không phù hợp</div>
                <div>08/12/2024</div>
                <div><span class="status-pill status-returns">Đã khóa</span></div>
                <div><a class="locked-action" href="#">Chỉnh Sửa</a></div>
            </div>
            <div class="locked-row">
                <div>SP002</div>
                <div>Áo Lót Sexy Gợi Cảm</div>
                <div class="text-danger">Vi phạm chính sách</div>
                <div>05/12/2024</div>
                <div><span class="status-pill status-returns">Đã khóa</span></div>
                <div><a class="locked-action" href="#">Chỉnh Sửa</a></div>
            </div>
            <div class="locked-row">
                <div>SP003</div>
                <div>Quần Lót Lọt Khe</div>
                <div class="text-danger">Từ ngữ không phù hợp</div>
                <div>03/12/2024</div>
                <div><span class="status-pill status-pending">Đang xét duyệt</span></div>
                <div><a class="locked-action" href="#">Chỉnh Sửa</a></div>
            </div>
        </div>
    </div>
</asp:Content>
