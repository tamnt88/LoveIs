<%@ Page Language="C#" AutoEventWireup="true" CodeFile="data-marketing.aspx.cs" Inherits="SellerDataMarketing" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Phân tích marketing</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data">
        <div class="data-header">
            <div>
                <h2>Phân Tích Marketing</h2>
                <p>Hiệu quả các chiến dịch marketing</p>
            </div>
        </div>

        <div class="data-toolbar">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select>
                    <option>30 ngày qua</option>
                </select>
            </div>
            <div class="data-filter">
                <select>
                    <option>Tất cả kênh</option>
                </select>
            </div>
            <button class="btn-address-outline" type="button">
                <i class="fa-solid fa-download"></i>
                Xuất Báo Cáo
            </button>
        </div>

        <div class="data-stat-grid five-col">
            <div class="card data-stat-card">
                <span class="data-stat-icon info-purple"><i class="fa-solid fa-bullhorn"></i></span>
                <div class="data-stat-label">Chiến Dịch Đang Chạy</div>
                <div class="data-stat-value">8</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-blue"><i class="fa-solid fa-dollar-sign"></i></span>
                <div class="data-stat-label">Chi Phí Marketing</div>
                <div class="data-stat-value">13.500.000 đ</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-green"><i class="fa-solid fa-chart-line"></i></span>
                <div class="data-stat-label">Doanh Thu Từ MKT</div>
                <div class="data-stat-value">185.000.000 đ</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-orange"><i class="fa-solid fa-percent"></i></span>
                <div class="data-stat-label">ROAS</div>
                <div class="data-stat-value">13.7x</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-pink"><i class="fa-solid fa-user-group"></i></span>
                <div class="data-stat-label">Khách Hàng Mới</div>
                <div class="data-stat-value">892</div>
            </div>
        </div>
    </div>
</asp:Content>
