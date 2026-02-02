<%@ Page Language="C#" AutoEventWireup="true" CodeFile="service-warranty.aspx.cs" Inherits="SellerServiceWarranty" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">LoveIs bảo hành</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-service">
        <div class="service-header">
            <div>
                <h2>LoveIs Bảo Hành</h2>
                <p>Dịch vụ bảo hành chính hãng cho sản phẩm</p>
            </div>
        </div>

        <div class="service-hero warranty-hero">
            <span class="service-hero-icon"><i class="fa-solid fa-shield"></i></span>
            <div>
                <div class="service-hero-title">Chương Trình Bảo Hành LoveIs</div>
                <div class="service-hero-desc">Bảo vệ sản phẩm, yên tâm kinh doanh</div>
            </div>
        </div>

        <div class="service-card-grid">
            <div class="card service-info-card">
                <span class="service-info-icon info-blue"><i class="fa-solid fa-shield"></i></span>
                <div>
                    <div class="service-info-title">Bảo hành chính hãng</div>
                    <div class="service-info-desc">100% sản phẩm được bảo hành theo chính sách nhà sản xuất</div>
                </div>
            </div>
            <div class="card service-info-card">
                <span class="service-info-icon info-blue"><i class="fa-regular fa-clock"></i></span>
                <div>
                    <div class="service-info-title">Xử lý nhanh chóng</div>
                    <div class="service-info-desc">Thời gian xử lý yêu cầu bảo hành trong 24-48 giờ</div>
                </div>
            </div>
            <div class="card service-info-card">
                <span class="service-info-icon info-blue"><i class="fa-solid fa-box"></i></span>
                <div>
                    <div class="service-info-title">Miễn phí vận chuyển</div>
                    <div class="service-info-desc">Free ship 2 chiều cho sản phẩm bảo hành</div>
                </div>
            </div>
            <div class="card service-info-card">
                <span class="service-info-icon info-blue"><i class="fa-regular fa-circle-check"></i></span>
                <div>
                    <div class="service-info-title">Đổi mới 1-1</div>
                    <div class="service-info-desc">Đổi sản phẩm mới nếu lỗi do nhà sản xuất</div>
                </div>
            </div>
        </div>

        <div class="card warranty-flow-card">
            <div class="service-section-title">Quy Trình Bảo Hành</div>
            <div class="warranty-steps">
                <div class="warranty-step">
                    <div class="warranty-step-number">1</div>
                    <div class="warranty-step-title">Tạo yêu cầu</div>
                    <div class="warranty-step-desc">Khách hàng gửi yêu cầu bảo hành</div>
                </div>
                <div class="warranty-step">
                    <div class="warranty-step-number">2</div>
                    <div class="warranty-step-title">Kiểm tra</div>
                    <div class="warranty-step-desc">Shop xác nhận và kiểm tra sản phẩm</div>
                </div>
                <div class="warranty-step">
                    <div class="warranty-step-number">3</div>
                    <div class="warranty-step-title">Xử lý</div>
                    <div class="warranty-step-desc">LoveIs xử lý bảo hành/đổi mới</div>
                </div>
                <div class="warranty-step">
                    <div class="warranty-step-number">4</div>
                    <div class="warranty-step-title">Hoàn tất</div>
                    <div class="warranty-step-desc">Giao sản phẩm về cho khách</div>
                </div>
            </div>
        </div>

        <div class="card warranty-policy-card">
            <div class="service-section-title">Chính Sách Bảo Hành</div>
            <div class="warranty-policy-list">
                <div class="warranty-policy-item">
                    <span class="warranty-policy-icon success"><i class="fa-solid fa-check"></i></span>
                    <div>
                        <div class="warranty-policy-title">Sản phẩm được bảo hành</div>
                        <div class="warranty-policy-desc">Tất cả sản phẩm chính hãng, còn trong thời hạn bảo hành theo nhà sản xuất</div>
                    </div>
                </div>
                <div class="warranty-policy-item">
                    <span class="warranty-policy-icon warning"><i class="fa-solid fa-circle-exclamation"></i></span>
                    <div>
                        <div class="warranty-policy-title">Điều kiện bảo hành</div>
                        <div class="warranty-policy-desc">Sản phẩm nguyên vẹn, không qua sửa chữa, có tem bảo hành và hóa đơn</div>
                    </div>
                </div>
                <div class="warranty-policy-item">
                    <span class="warranty-policy-icon info"><i class="fa-regular fa-clock"></i></span>
                    <div>
                        <div class="warranty-policy-title">Thời gian bảo hành</div>
                        <div class="warranty-policy-desc">Từ 6-12 tháng tùy theo sản phẩm và chính sách nhà sản xuất</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
