<%@ Page Language="C#" AutoEventWireup="true" CodeFile="livestream.aspx.cs" Inherits="SellerLivestreamList" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Livestream của tôi</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-livestream">
        <div class="livestream-header">
            <div>
                <h2>Livestream Của Tôi</h2>
                <p>Quản lý các buổi livestream</p>
            </div>
        </div>

        <div class="livestream-hero">
            <i class="fa-solid fa-video"></i>
            <span>Tạo Livestream Mới</span>
        </div>

        <div class="livestream-summary-grid">
            <div class="card livestream-summary-card">
                <span class="livestream-summary-icon info-blue"><i class="fa-solid fa-play"></i></span>
                <div>
                    <div class="livestream-summary-label">Tổng Livestream</div>
                    <div class="livestream-summary-value">8</div>
                </div>
            </div>
            <div class="card livestream-summary-card">
                <span class="livestream-summary-icon info-purple"><i class="fa-solid fa-users"></i></span>
                <div>
                    <div class="livestream-summary-label">Người Xem TB</div>
                    <div class="livestream-summary-value">856</div>
                </div>
            </div>
            <div class="card livestream-summary-card">
                <span class="livestream-summary-icon info-green"><i class="fa-solid fa-bag-shopping"></i></span>
                <div>
                    <div class="livestream-summary-label">Đơn Hàng</div>
                    <div class="livestream-summary-value">234</div>
                </div>
            </div>
        </div>

        <div class="card livestream-list">
            <div class="livestream-list-title">Danh Sách Livestream</div>
            <div class="livestream-item">
                <div class="livestream-thumb">
                    <i class="fa-solid fa-video"></i>
                </div>
                <div class="livestream-info">
                    <div class="livestream-name">Sale Sốc - Đồ Lót Giảm 50%</div>
                    <div class="livestream-meta">
                        <span class="livestream-chip">Sắp diễn ra</span>
                        <span><i class="fa-regular fa-eye"></i> 0 lượt xem</span>
                        <span><i class="fa-solid fa-bag-shopping"></i> 0 đơn hàng</span>
                        <span><i class="fa-regular fa-calendar"></i> 15/12/2024 20:00</span>
                    </div>
                </div>
                <button class="btn-address-outline" type="button">Chỉnh Sửa</button>
            </div>
            <div class="livestream-item">
                <div class="livestream-thumb">
                    <i class="fa-solid fa-video"></i>
                </div>
                <div class="livestream-info">
                    <div class="livestream-name">Review Bộ Sưu Tập Mới</div>
                    <div class="livestream-meta">
                        <span class="livestream-chip muted">Đã kết thúc</span>
                        <span><i class="fa-regular fa-eye"></i> 1.234 lượt xem</span>
                        <span><i class="fa-solid fa-bag-shopping"></i> 45 đơn hàng</span>
                        <span><i class="fa-regular fa-calendar"></i> 08/12/2024 19:00</span>
                    </div>
                </div>
                <button class="btn-address-outline" type="button">Xem Chi Tiết</button>
            </div>
        </div>
    </div>
</asp:Content>
