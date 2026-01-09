<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-shipping-settings.aspx.cs" Inherits="SellerOrderShippingSettings" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Cài đặt vận chuyển</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-shipping">
        <div class="shipping-header">
            <div>
                <h2>Cài Đặt Vận Chuyển</h2>
                <p>Quản lý cài đặt giao hàng và đơn vị vận chuyển</p>
            </div>
        </div>

        <div class="card shipping-card">
            <div class="shipping-section-title"><i class="fa-solid fa-truck"></i> Đơn Vị Vận Chuyển</div>
            <div class="shipping-provider-grid">
                <div class="shipping-provider active">
                    <div>
                        <div class="shipping-provider-title">Giao Hàng Nhanh</div>
                        <div class="shipping-provider-price">Phí: 15,000đ - 50,000đ</div>
                    </div>
                    <input type="checkbox" checked />
                </div>
                <div class="shipping-provider">
                    <div>
                        <div class="shipping-provider-title">Giao Hàng Tiết Kiệm</div>
                        <div class="shipping-provider-price">Phí: 12,000đ - 40,000đ</div>
                    </div>
                    <input type="checkbox" />
                </div>
                <div class="shipping-provider">
                    <div>
                        <div class="shipping-provider-title">VNPost</div>
                        <div class="shipping-provider-price">Phí: 10,000đ - 35,000đ</div>
                    </div>
                    <input type="checkbox" />
                </div>
            </div>
        </div>

        <div class="card shipping-card">
            <div class="shipping-section-title"><i class="fa-solid fa-location-dot"></i> Địa Chỉ Lấy Hàng</div>
            <div class="shipping-address-card">
                <span class="address-pill">Mặc định</span>
                <div class="address-card-title">Kho Chính - Flow Agency Amara</div>
                <div class="address-card-sub">123 Đường ABC, Phường XYZ, Quận 1, TP.HCM</div>
                <div class="address-card-sub">SDT: 0901234567</div>
            </div>
            <div class="shipping-add-box">+ Thêm Địa Chỉ Lấy Hàng Mới</div>
        </div>
    </div>
</asp:Content>

