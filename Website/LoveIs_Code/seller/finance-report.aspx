<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-report.aspx.cs" Inherits="SellerFinanceReport" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Báo cáo tài chính</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Báo Cáo Tài Chính</h2>
                <p>Báo cáo chi tiết về tình hình tài chính của shop</p>
            </div>
        </div>

        <div class="finance-toolbar">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select>
                    <option>Tháng này</option>
                </select>
            </div>
            <div class="finance-toolbar-actions">
                <button class="btn-address-outline" type="button"><i class="fa-solid fa-print"></i> In</button>
                <button class="btn-finance-primary" type="button"><i class="fa-solid fa-download"></i> Xuất PDF</button>
            </div>
        </div>

        <div class="finance-report-tabs">
            <button class="finance-tab active" type="button">Báo Cáo Tổng Hợp</button>
            <button class="finance-tab" type="button">Báo Cáo Chi Tiết</button>
            <button class="finance-tab" type="button">Báo Cáo Thuế</button>
        </div>

        <div class="finance-stat-grid">
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-blue"><i class="fa-solid fa-dollar-sign"></i></span>
                <div class="finance-stat-label">Tổng Doanh Thu</div>
                <div class="finance-stat-value">339.000.000 đ</div>
                <div class="finance-stat-trend up">+18%</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-orange"><i class="fa-solid fa-basket-shopping"></i></span>
                <div class="finance-stat-label">Giá Vốn Hàng Bán</div>
                <div class="finance-stat-value">135.600.000 đ</div>
                <div class="finance-stat-sub">40% doanh thu</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-red"><i class="fa-solid fa-percent"></i></span>
                <div class="finance-stat-label">Chi Phí Hoạt Động</div>
                <div class="finance-stat-value">67.800.000 đ</div>
                <div class="finance-stat-sub">20% doanh thu</div>
            </div>
            <div class="finance-profit-card large">
                <span class="finance-stat-icon info-green"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="finance-stat-label">Lợi Nhuận Ròng</div>
                <div class="finance-stat-value">203.400.000 đ</div>
                <div class="finance-stat-sub">60% doanh thu</div>
            </div>
        </div>

        <div class="finance-chart-grid">
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Doanh Thu &amp; Chi Phí</div>
                <div class="finance-chart-placeholder bar-chart dual blue"></div>
            </div>
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Xu Hướng Lợi Nhuận</div>
                <div class="finance-chart-placeholder line-chart green"></div>
            </div>
        </div>
    </div>
</asp:Content>
