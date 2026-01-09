<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-revenue.aspx.cs" Inherits="SellerFinanceRevenue" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Doanh thu</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Doanh Thu</h2>
                <p>Theo dõi doanh thu và lợi nhuận</p>
            </div>
        </div>

        <div class="finance-stat-grid">
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-green"><i class="fa-solid fa-dollar-sign"></i></span>
                <div class="finance-stat-label">Doanh Thu Tháng Này</div>
                <div class="finance-stat-value">58.000.000 đ</div>
                <div class="finance-stat-trend up">+15.2%</div>
            </div>
            <div class="card finance-stat-card">
                <div class="finance-stat-label">Đã Thanh Toán</div>
                <div class="finance-stat-value">52.000.000 đ</div>
            </div>
            <div class="card finance-stat-card">
                <div class="finance-stat-label">Chờ Thanh Toán</div>
                <div class="finance-stat-value">6.000.000 đ</div>
            </div>
            <div class="card finance-stat-card">
                <div class="finance-stat-label">Lợi Nhuận Ước Tính</div>
                <div class="finance-stat-value">18.500.000 đ</div>
            </div>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-chart-head">
                <div class="finance-chart-title">Biểu Đồ Doanh Thu 6 Tháng</div>
                <button class="btn-address-outline" type="button">
                    <i class="fa-solid fa-download"></i>
                    Xuất Báo Cáo
                </button>
            </div>
            <div class="finance-chart-placeholder bar-chart"></div>
        </div>
    </div>
</asp:Content>
