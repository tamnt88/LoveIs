<%@ Page Language="C#" AutoEventWireup="true" CodeFile="data-performance.aspx.cs" Inherits="SellerDataPerformance" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Hiệu quả hoạt động</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data">
        <div class="data-header">
            <div>
                <h2>Hiệu Quả Hoạt Động</h2>
                <p>Đánh giá toàn diện về hiệu suất vận hành shop</p>
            </div>
        </div>

        <div class="data-toolbar">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select>
                    <option>30 ngày qua</option>
                </select>
            </div>
            <button class="btn-address-outline" type="button">
                <i class="fa-solid fa-download"></i>
                Xuất Báo Cáo
            </button>
        </div>

        <div class="data-performance-hero">
            <div>
                <div class="performance-label">Điểm Hiệu Suất Tổng Thể</div>
                <div class="performance-score">
                    <span>87</span>
                    <small>/100</small>
                </div>
                <div class="performance-trend">+5 điểm so với tháng trước</div>
            </div>
            <div class="performance-meta">
                <div>
                    <div class="performance-meta-value">A</div>
                    <div class="performance-meta-label">Hạng Đánh Giá</div>
                </div>
                <div>
                    <div class="performance-meta-value">#8</div>
                    <div class="performance-meta-label">Xếp Hạng</div>
                </div>
            </div>
        </div>

        <div class="data-stat-grid five-col">
            <div class="card data-stat-card">
                <span class="data-stat-icon info-blue"><i class="fa-solid fa-percent"></i></span>
                <div class="data-stat-label">Tỷ Lệ Chuyển Đổi</div>
                <div class="data-stat-value">4.2%</div>
                <div class="data-stat-trend up">+0.5%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-purple"><i class="fa-solid fa-cart-shopping"></i></span>
                <div class="data-stat-label">Giá Trị ĐH TB</div>
                <div class="data-stat-value">335.000 đ</div>
                <div class="data-stat-trend up">+8%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-yellow"><i class="fa-solid fa-star"></i></span>
                <div class="data-stat-label">Đánh Giá TB</div>
                <div class="data-stat-value">4.9★</div>
                <div class="data-stat-trend up">+0.2</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-green"><i class="fa-solid fa-user-group"></i></span>
                <div class="data-stat-label">Khách Quay Lại</div>
                <div class="data-stat-value">42%</div>
                <div class="data-stat-trend up">+3%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-red"><i class="fa-regular fa-clock"></i></span>
                <div class="data-stat-label">Thời Gian XL</div>
                <div class="data-stat-value">1.2h</div>
                <div class="data-stat-trend up">Nhanh hơn</div>
            </div>
        </div>
    </div>
</asp:Content>
