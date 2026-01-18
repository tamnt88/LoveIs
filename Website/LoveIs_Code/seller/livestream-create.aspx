<%@ Page Language="C#" AutoEventWireup="true" CodeFile="livestream-create.aspx.cs" Inherits="SellerLivestreamCreate" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Tạo livestream mới</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-livestream">
        <div class="livestream-header">
            <div>
                <h2>Tạo Livestream Mới</h2>
                <p>Thiết lập buổi livestream bán hàng của bạn</p>
            </div>
        </div>

        <div class="card livestream-steps">
            <div class="livestream-step">
                <span class="step-dot active">1</span>
                <span class="step-line"></span>
                <span class="step-label">Thông tin cơ bản</span>
            </div>
            <div class="livestream-step">
                <span class="step-dot">2</span>
                <span class="step-line"></span>
                <span class="step-label">Chọn sản phẩm</span>
            </div>
            <div class="livestream-step">
                <span class="step-dot">3</span>
                <span class="step-line"></span>
                <span class="step-label">Cài đặt</span>
            </div>
            <div class="livestream-step">
                <span class="step-dot">4</span>
                <span class="step-label">Xác nhận</span>
            </div>
        </div>

        <div class="card livestream-form">
            <div class="livestream-form-title">Thông Tin Livestream</div>
            <div class="form-group">
                <label>Tiêu Đề Livestream *</label>
                <input class="form-control" type="text" placeholder="VD: Flash Sale Cuối Tuần - Giảm 50% Toàn Bộ Đồ Lót" />
            </div>
            <div class="form-group">
                <label>Mô Tả</label>
                <textarea class="form-control livestream-textarea" rows="5" placeholder="Mô tả chi tiết về buổi livestream, sản phẩm và ưu đãi..."></textarea>
            </div>
        </div>
    </div>
</asp:Content>
