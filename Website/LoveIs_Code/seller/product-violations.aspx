<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-violations.aspx.cs" Inherits="SellerProductViolations" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Vi phạm sản phẩm</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-product-violations">
        <div class="locked-header">
            <div>
                <h2>Vi Phạm Sản Phẩm</h2>
                <p>Theo dõi các vi phạm và xử lý kịp thời</p>
            </div>
        </div>

        <div class="locked-alert warning">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <div>
                <strong>Cảnh báo:</strong> Nhiều vi phạm có thể dẫn đến hạn chế hoặc khóa tài khoản.
                <div>Vui lòng tuân thủ các chính sách của LoveIs để duy trì hoạt động kinh doanh.</div>
            </div>
        </div>

        <div class="locked-summary-grid four-col">
            <div class="card locked-summary-card">
                <div class="locked-summary-label">Tổng Vi Phạm</div>
                <div class="locked-summary-value">15</div>
            </div>
            <div class="card locked-summary-card border-danger">
                <div class="locked-summary-label">Mức Cao</div>
                <div class="locked-summary-value text-danger">3</div>
            </div>
            <div class="card locked-summary-card border-warn">
                <div class="locked-summary-label">Mức Trung Bình</div>
                <div class="locked-summary-value text-warn">7</div>
            </div>
            <div class="card locked-summary-card border-ok">
                <div class="locked-summary-label">Mức Thấp</div>
                <div class="locked-summary-value text-ok">5</div>
            </div>
        </div>

        <div class="card locked-table">
            <div class="locked-table-title">Lịch Sử Vi Phạm</div>
            <div class="locked-table-head violations">
                <div>Mã VP</div>
                <div>Sản Phẩm</div>
                <div>Loại Vi Phạm</div>
                <div>Mức Độ</div>
                <div>Ngày Phát Hiện</div>
                <div>Xử Phạt</div>
                <div>Thao Tác</div>
            </div>
            <div class="locked-row violations">
                <div>VP001</div>
                <div>Set Đồ Lót Ren Premium</div>
                <div>Hình ảnh không phù hợp</div>
                <div><span class="violation-pill high">Cao</span></div>
                <div>10/12/2024</div>
                <div>Cảnh cáo lần 1</div>
                <div><a class="locked-action" href="#"><i class="fa-regular fa-file-lines"></i> Chi tiết</a></div>
            </div>
            <div class="locked-row violations">
                <div>VP002</div>
                <div>Áo Lót Không Gọng</div>
                <div>Mô tả sai lệch</div>
                <div><span class="violation-pill medium">TB</span></div>
                <div>08/12/2024</div>
                <div>Yêu cầu chỉnh sửa</div>
                <div><a class="locked-action" href="#"><i class="fa-regular fa-file-lines"></i> Chi tiết</a></div>
            </div>
            <div class="locked-row violations">
                <div>VP003</div>
                <div>Quần Lót Cotton</div>
                <div>Giá không hợp lý</div>
                <div><span class="violation-pill low">Thấp</span></div>
                <div>05/12/2024</div>
                <div>Thông báo</div>
                <div><a class="locked-action" href="#"><i class="fa-regular fa-file-lines"></i> Chi tiết</a></div>
            </div>
        </div>
    </div>
</asp:Content>
