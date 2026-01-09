<%@ Page Language="C#" AutoEventWireup="true" CodeFile="data-sales.aspx.cs" Inherits="SellerDataSales" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Phân tích bán hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data">
        <div class="data-header">
            <div>
                <h2>Phân Tích Bán Hàng</h2>
                <p>Dữ liệu chi tiết về hoạt động bán hàng</p>
            </div>
        </div>

        <div class="data-stat-grid">
            <div class="card data-stat-card">
                <span class="data-stat-icon info-maroon"><i class="fa-solid fa-chart-line"></i></span>
                <div class="data-stat-label">Tổng Đơn Hàng</div>
                <div class="data-stat-value">424</div>
                <div class="data-stat-trend up">+22%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-blue"><i class="fa-solid fa-cart-shopping"></i></span>
                <div class="data-stat-label">Giá Trị Đơn TB</div>
                <div class="data-stat-value">285.000 đ</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-purple"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="data-stat-label">Tỷ Lệ Chuyển Đổi</div>
                <div class="data-stat-value">3.8%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-green"><i class="fa-solid fa-rotate-right"></i></span>
                <div class="data-stat-label">Khách Quay Lại</div>
                <div class="data-stat-value">42%</div>
            </div>
        </div>

        <div class="data-panel-grid">
            <div class="card data-panel">
                <div class="data-panel-title">Xu Hướng Bán Hàng</div>
                <div class="data-chart-placeholder line-chart"></div>
            </div>
            <div class="card data-panel">
                <div class="data-panel-title">Phân Bổ Theo Danh Mục</div>
                <div class="data-chart-placeholder pie-chart">
                    <div class="pie-labels">
                        <span>Áo Lót 40%</span>
                        <span>Quần Lót 30%</span>
                        <span>Set Đồ 20%</span>
                        <span>Đồ Ngủ 10%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
