<%@ Page Language="C#" AutoEventWireup="true" CodeFile="data-marketing.aspx.cs" Inherits="SellerDataMarketing" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Kênh marketing</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data">
        <div class="marketing-header">
            <div>
                <h2>Kênh Marketing Của Tôi</h2>
                <p>Tổng quan các hoạt động marketing</p>
            </div>
        </div>

        <div class="marketing-channel-grid">
            <div class="marketing-channel-card is-orange">
                <div class="marketing-channel-icon"><i class="fa-solid fa-bullhorn"></i></div>
                <div class="marketing-channel-title">Quảng Cáo</div>
                <div class="marketing-channel-sub">Tạo chiến dịch quảng cáo</div>
            </div>
            <div class="marketing-channel-card is-red">
                <div class="marketing-channel-icon"><i class="fa-solid fa-arrow-trend-up"></i></div>
                <div class="marketing-channel-title">Flash Sale</div>
                <div class="marketing-channel-sub">Tạo chương trình flash sale</div>
            </div>
            <div class="marketing-channel-card is-purple">
                <div class="marketing-channel-icon"><i class="fa-solid fa-percent"></i></div>
                <div class="marketing-channel-title">Mã Giảm Giá</div>
                <div class="marketing-channel-sub">Tạo voucher cho shop</div>
            </div>
            <div class="marketing-channel-card is-blue">
                <div class="marketing-channel-icon"><i class="fa-solid fa-gift"></i></div>
                <div class="marketing-channel-title">Add-on</div>
                <div class="marketing-channel-sub">Gian hàng add-on</div>
            </div>
        </div>

        <div class="marketing-stat-grid">
            <div class="card marketing-stat-card">
                <div class="marketing-stat-label">Tổng Chi Phí</div>
                <div class="marketing-stat-value">5.2M</div>
                <div class="marketing-stat-trend is-up">+12% so với tháng trước</div>
            </div>
            <div class="card marketing-stat-card">
                <div class="marketing-stat-label">Doanh Thu Từ Marketing</div>
                <div class="marketing-stat-value">45.8M</div>
                <div class="marketing-stat-trend is-up">+18% so với tháng trước</div>
            </div>
            <div class="card marketing-stat-card">
                <div class="marketing-stat-label">ROI</div>
                <div class="marketing-stat-value">8.8x</div>
                <div class="marketing-stat-trend">Hiệu quả tốt</div>
            </div>
            <div class="card marketing-stat-card">
                <div class="marketing-stat-label">Đơn Hàng</div>
                <div class="marketing-stat-value">234</div>
                <div class="marketing-stat-trend is-up">+25% so với tháng trước</div>
            </div>
        </div>

        <div class="card marketing-running-card">
            <div class="marketing-running-header">
                <h3>Chiến Dịch Đang Chạy</h3>
            </div>
            <div class="marketing-running-list">
                <div class="marketing-running-item">
                    <div class="marketing-running-main">
                        <div class="marketing-running-title">
                            Flash Sale Cuối Tuần
                            <span class="marketing-status-chip is-running">Đang chạy</span>
                        </div>
                        <div class="marketing-running-meta">
                            <span>Doanh thu: 2.5M</span>
                            <span>Đơn hàng: 45</span>
                            <span>Kết thúc: 12/12/2024</span>
                        </div>
                    </div>
                    <button class="btn-address-outline" type="button">Quản lý</button>
                </div>
                <div class="marketing-running-item">
                    <div class="marketing-running-main">
                        <div class="marketing-running-title">
                            Voucher Giảm 20%
                            <span class="marketing-status-chip is-running">Đang chạy</span>
                        </div>
                        <div class="marketing-running-meta">
                            <span>Doanh thu: 1.8M</span>
                            <span>Đơn hàng: 32</span>
                            <span>Kết thúc: 15/12/2024</span>
                        </div>
                    </div>
                    <button class="btn-address-outline" type="button">Quản lý</button>
                </div>
                <div class="marketing-running-item">
                    <div class="marketing-running-main">
                        <div class="marketing-running-title">
                            Combo Tiết Kiệm
                            <span class="marketing-status-chip is-scheduled">Đã lên lịch</span>
                        </div>
                        <div class="marketing-running-meta">
                            <span>Doanh thu: 0đ</span>
                            <span>Đơn hàng: 0</span>
                            <span>Bắt đầu: 14/12/2024</span>
                        </div>
                    </div>
                    <button class="btn-address-outline" type="button">Chỉnh sửa</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
