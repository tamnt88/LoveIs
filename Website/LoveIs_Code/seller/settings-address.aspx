<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-address.aspx.cs" Inherits="SellerSettingsAddress" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Địa chỉ của tôi</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-addresses">
        <div class="address-header">
            <div>
                <h2>Địa Chỉ Của Tôi</h2>
                <p>Quản lý địa chỉ lấy hàng và giao hàng</p>
            </div>
            <button class="btn-address-primary" type="button">
                <i class="fa-solid fa-plus"></i>
                Thêm Địa Chỉ
            </button>
        </div>

        <div class="address-summary-grid">
            <div class="address-summary-card address-pickup">
                <div class="address-summary-top">
                    <span class="address-summary-icon"><i class="fa-solid fa-house"></i></span>
                    <div>
                        <div class="address-summary-title">Địa Chỉ Lấy Hàng</div>
                        <div class="address-summary-sub">Kho/Shop của bạn</div>
                    </div>
                </div>
                <div class="address-summary-value">2</div>
            </div>
            <div class="address-summary-card address-return">
                <div class="address-summary-top">
                    <span class="address-summary-icon"><i class="fa-solid fa-building"></i></span>
                    <div>
                        <div class="address-summary-title">Địa Chỉ Trả Hàng</div>
                        <div class="address-summary-sub">Nhận hàng hoàn trả</div>
                    </div>
                </div>
                <div class="address-summary-value">1</div>
            </div>
        </div>

        <div class="address-card address-card-main">
            <div class="address-card-head">
                <div class="address-card-left">
                    <span class="address-card-icon"><i class="fa-solid fa-location-dot"></i></span>
                    <div>
                        <div class="address-card-title">Kho chính</div>
                        <div class="address-card-sub">Địa chỉ lấy hàng</div>
                    </div>
                    <span class="address-pill">Mặc định</span>
                </div>
                <button class="address-icon-btn" type="button"><i class="fa-regular fa-pen-to-square"></i></button>
            </div>
            <div class="address-card-body">
                <div class="address-row"><span>Người liên hệ:</span> Nguyễn Văn A | 0912345678</div>
                <div class="address-row"><span>Địa chỉ:</span> 123 Đường ABC, Phường XYZ</div>
                <div class="address-row"><span>Khu vực:</span> Phường Láng Hạ, Quận Đống Đa, Hà Nội</div>
            </div>
        </div>

        <div class="address-card">
            <div class="address-card-head">
                <div class="address-card-left">
                    <span class="address-card-icon"><i class="fa-solid fa-location-dot"></i></span>
                    <div>
                        <div class="address-card-title">Chi nhánh 2</div>
                        <div class="address-card-sub">Địa chỉ lấy hàng</div>
                    </div>
                </div>
                <div class="address-actions">
                    <button class="btn-address-outline" type="button">Đặt Mặc Định</button>
                    <button class="address-icon-btn" type="button"><i class="fa-regular fa-pen-to-square"></i></button>
                    <button class="address-icon-btn danger" type="button"><i class="fa-regular fa-trash-can"></i></button>
                </div>
            </div>
            <div class="address-card-body">
                <div class="address-row"><span>Người liên hệ:</span> Trần Thị B | 0987654321</div>
                <div class="address-row"><span>Địa chỉ:</span> 456 Đường DEF, Phường UVW</div>
                <div class="address-row"><span>Khu vực:</span> Phường Cầu Giấy, Quận Cầu Giấy, Hà Nội</div>
            </div>
        </div>
    </div>
</asp:Content>
