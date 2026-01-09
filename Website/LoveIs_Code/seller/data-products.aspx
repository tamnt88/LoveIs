<%@ Page Language="C#" AutoEventWireup="true" CodeFile="data-products.aspx.cs" Inherits="SellerDataProducts" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Phân tích sản phẩm</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data">
        <div class="data-header">
            <div>
                <h2>Phân Tích Sản Phẩm</h2>
                <p>Dữ liệu chi tiết về hiệu suất sản phẩm</p>
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
                    <option>Tất cả danh mục</option>
                </select>
            </div>
            <button class="btn-address-outline" type="button">
                <i class="fa-solid fa-download"></i>
                Xuất Excel
            </button>
        </div>

        <div class="data-stat-grid five-col">
            <div class="card data-stat-card">
                <span class="data-stat-icon info-purple"><i class="fa-solid fa-box"></i></span>
                <div class="data-stat-label">Tổng SP Đang Bán</div>
                <div class="data-stat-value">248</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-blue"><i class="fa-regular fa-eye"></i></span>
                <div class="data-stat-label">Lượt Xem</div>
                <div class="data-stat-value">121K</div>
                <div class="data-stat-trend up">+18%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-green"><i class="fa-solid fa-cart-shopping"></i></span>
                <div class="data-stat-label">Đã Bán</div>
                <div class="data-stat-value">753</div>
                <div class="data-stat-trend up">+24%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-yellow"><i class="fa-solid fa-star"></i></span>
                <div class="data-stat-label">Đánh Giá TB</div>
                <div class="data-stat-value">4.8★</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-orange"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="data-stat-label">Tỷ Lệ Chuyển Đổi</div>
                <div class="data-stat-value">3.4%</div>
            </div>
        </div>

        <div class="data-panel-grid">
            <div class="card data-panel">
                <div class="data-panel-title">Xu Hướng Hiệu Suất</div>
                <div class="data-chart-placeholder line-chart multi"></div>
            </div>
            <div class="card data-panel">
                <div class="data-panel-title">Phân Bổ Theo Danh Mục</div>
                <div class="data-chart-placeholder pie-chart">
                    <div class="pie-labels">
                        <span>Bộ đồ lót 45%</span>
                        <span>Áo ngực 25%</span>
                        <span>Quần lót 18%</span>
                        <span>Đồ ngủ 12%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
