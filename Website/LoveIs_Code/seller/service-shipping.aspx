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

        <div class="shipping-benefit-grid">
            <div class="card shipping-benefit-card">
                <span class="shipping-benefit-icon is-green"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="shipping-benefit-title">Tăng Doanh Số</div>
                <p>Khách hàng có xu hướng mua nhiều hơn khi được miễn phí vận chuyển</p>
            </div>
            <div class="card shipping-benefit-card">
                <span class="shipping-benefit-icon is-blue"><i class="fa-regular fa-star"></i></span>
                <div class="shipping-benefit-title">Tăng Uy Tín</div>
                <p>Badge FreeShip giúp shop nổi bật và thu hút khách hàng hơn</p>
            </div>
            <div class="card shipping-benefit-card">
                <span class="shipping-benefit-icon is-purple"><i class="fa-solid fa-cube"></i></span>
                <div class="shipping-benefit-title">Giảm Hủy Đơn</div>
                <p>Tỷ lệ hủy đơn giảm 25% nhờ khách không phải lo chi phí ship</p>
            </div>
        </div>

        <div class="card shipping-steps-card">
            <h3>Cách Tham Gia</h3>
            <div class="shipping-step-list">
                <div class="shipping-step-item">
                    <div class="shipping-step-index">1</div>
                    <div>
                        <div class="shipping-step-title">Đăng ký chương trình</div>
                        <div class="shipping-step-desc">Đăng ký tham gia FreeShip với Lovels</div>
                    </div>
                </div>
                <div class="shipping-step-item">
                    <div class="shipping-step-index">2</div>
                    <div>
                        <div class="shipping-step-title">Thiết lập điều kiện</div>
                        <div class="shipping-step-desc">Cài đặt giá trị đơn tối thiểu được freeship (VD: 300K)</div>
                    </div>
                </div>
                <div class="shipping-step-item">
                    <div class="shipping-step-index">3</div>
                    <div>
                        <div class="shipping-step-title">Kích hoạt</div>
                        <div class="shipping-step-desc">Lovels xét duyệt và kích hoạt trong 24h</div>
                    </div>
                </div>
                <div class="shipping-step-item">
                    <div class="shipping-step-index">4</div>
                    <div>
                        <div class="shipping-step-title">Nhận badge</div>
                        <div class="shipping-step-desc">Shop nhận badge FreeShip và bắt đầu hưởng lợi</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
