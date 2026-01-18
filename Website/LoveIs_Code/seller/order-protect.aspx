<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-protect.aspx.cs" Inherits="SellerOrdersProtect" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Bảo hộ đơn hủy</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-protect">
        <div class="protect-header">
            <div>
                <h2>Bảo Hộ Đơn Hủy</h2>
                <p>Chương trình bảo vệ người bán khỏi đơn hủy bất thường</p>
            </div>
        </div>

        <div class="protect-hero">
            <span class="protect-hero-icon"><i class="fa-solid fa-shield-halved"></i></span>
            <div>
                <div class="protect-hero-title">Chương Trình Bảo Hộ Đơn Hủy LoveIs</div>
                <div class="protect-hero-desc">Bảo vệ shop của bạn khỏi những đơn hàng bị hủy bất thường, giúp giảm thiểu thiệt hại và duy trì uy tín.</div>
                <button class="protect-hero-btn" type="button">Đăng Ký Ngay</button>
            </div>
        </div>

        <div class="protect-summary-grid">
            <div class="card protect-summary-card">
                <span class="protect-summary-icon info-green"><i class="fa-solid fa-shield"></i></span>
                <div class="protect-summary-label">Đơn Được Bảo Hộ</div>
                <div class="protect-summary-value">45</div>
            </div>
            <div class="card protect-summary-card">
                <span class="protect-summary-icon info-blue"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="protect-summary-label">Tiết Kiệm Được</div>
                <div class="protect-summary-value">12.5M</div>
            </div>
            <div class="card protect-summary-card">
                <span class="protect-summary-icon info-yellow"><i class="fa-solid fa-circle-exclamation"></i></span>
                <div class="protect-summary-label">Đang Xử Lý</div>
                <div class="protect-summary-value">3</div>
            </div>
        </div>

        <div class="card protect-benefits">
            <div class="protect-benefits-title">Lợi Ích Của Chương Trình</div>
            <div class="protect-benefits-grid">
                <div class="protect-benefit">
                    <span class="protect-benefit-icon"><i class="fa-solid fa-check"></i></span>
                    <div>
                        <div class="protect-benefit-title">Bảo Vệ Doanh Thu</div>
                        <div class="protect-benefit-desc">Hoàn tiền cho các đơn hủy bất thường</div>
                    </div>
                </div>
                <div class="protect-benefit">
                    <span class="protect-benefit-icon"><i class="fa-solid fa-check"></i></span>
                    <div>
                        <div class="protect-benefit-title">Giảm Thiểu Rủi Ro</div>
                        <div class="protect-benefit-desc">Bảo vệ khỏi hành vi gian lận</div>
                    </div>
                </div>
                <div class="protect-benefit">
                    <span class="protect-benefit-icon"><i class="fa-solid fa-check"></i></span>
                    <div>
                        <div class="protect-benefit-title">Hỗ Trợ 24/7</div>
                        <div class="protect-benefit-desc">Đội ngũ hỗ trợ luôn sẵn sàng</div>
                    </div>
                </div>
                <div class="protect-benefit">
                    <span class="protect-benefit-icon"><i class="fa-solid fa-check"></i></span>
                    <div>
                        <div class="protect-benefit-title">Miễn Phí Tham Gia</div>
                        <div class="protect-benefit-desc">Không mất phí đăng ký</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

