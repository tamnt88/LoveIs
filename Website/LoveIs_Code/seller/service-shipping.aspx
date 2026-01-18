<%@ Page Language="C#" AutoEventWireup="true" CodeFile="service-shipping.aspx.cs" Inherits="SellerServiceShipping" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Miễn phí vận chuyển</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-service">
        <div class="service-header">
            <div>
                <h2>Chương Trình Miễn Phí Vận Chuyển</h2>
                <p>Tham gia chương trình freeship để tăng doanh số</p>
            </div>
        </div>

        <div class="service-hero shipping-hero">
            <div>
                <div class="service-hero-title">FreeShip Toàn Quốc</div>
                <div class="service-hero-desc">Tăng tỷ lệ chuyển đổi lên đến 40% khi tham gia chương trình freeship</div>
                <button class="service-hero-btn" type="button">Tham Gia Ngay</button>
            </div>
            <span class="service-hero-icon large"><i class="fa-solid fa-truck"></i></span>
        </div>

        <div class="service-stat-grid">
            <div class="card service-stat-card">
                <span class="service-stat-icon info-blue"><i class="fa-solid fa-box"></i></span>
                <div class="service-stat-value">2,345</div>
                <div class="service-stat-label">Đơn FreeShip</div>
            </div>
            <div class="card service-stat-card">
                <span class="service-stat-icon info-green"><i class="fa-solid fa-dollar-sign"></i></span>
                <div class="service-stat-value">12.5M</div>
                <div class="service-stat-label">Tiết kiệm phí ship</div>
            </div>
            <div class="card service-stat-card">
                <span class="service-stat-icon info-purple"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="service-stat-value">+34%</div>
                <div class="service-stat-label">Tăng trưởng</div>
            </div>
            <div class="card service-stat-card">
                <span class="service-stat-icon info-yellow"><i class="fa-solid fa-star"></i></span>
                <div class="service-stat-value">4.9★</div>
                <div class="service-stat-label">Đánh giá TB</div>
            </div>
        </div>
    </div>
</asp:Content>
