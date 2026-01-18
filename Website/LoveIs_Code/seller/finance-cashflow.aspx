<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-cashflow.aspx.cs" Inherits="SellerFinanceCashflow" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thu chi người bán</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Thu Chi Người Bán</h2>
                <p>Quản lý thu chi và theo dõi lợi nhuận</p>
            </div>
        </div>

        <div class="finance-toolbar">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select>
                    <option>Tháng này</option>
                </select>
            </div>
            <button class="btn-address-outline" type="button">
                <i class="fa-solid fa-download"></i>
                Xuất Excel
            </button>
        </div>

        <div class="finance-stat-grid">
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-blue"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="finance-stat-label">Tổng Thu</div>
                <div class="finance-stat-value">58.000.000 đ</div>
                <div class="finance-stat-sub">Tháng này</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-red"><i class="fa-solid fa-arrow-trend-down"></i></span>
                <div class="finance-stat-label">Tổng Chi</div>
                <div class="finance-stat-value">12.500.000 đ</div>
                <div class="finance-stat-sub">Tháng này</div>
            </div>
            <div class="finance-profit-card">
                <span class="finance-stat-icon info-green"><i class="fa-solid fa-wallet"></i></span>
                <div class="finance-stat-label">Lợi Nhuận</div>
                <div class="finance-stat-value">45.500.000 đ</div>
                <div class="finance-stat-trend up">+22% so với tháng trước</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-purple"><i class="fa-solid fa-percent"></i></span>
                <div class="finance-stat-label">Tỷ Lệ Lợi Nhuận</div>
                <div class="finance-stat-value">78.4%</div>
                <div class="finance-stat-sub">Rất tốt</div>
            </div>
        </div>

        <div class="finance-chart-grid">
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Thu Chi 6 Tháng</div>
                <div class="finance-chart-placeholder bar-chart dual"></div>
            </div>
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Phân Bổ Chi Phí</div>
                <div class="finance-chart-placeholder pie-chart">
                    <div class="pie-labels">
                        <span>Chi phí quảng cáo 40%</span>
                        <span>Phí dịch vụ 20%</span>
                        <span>Chi phí khác 14%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
