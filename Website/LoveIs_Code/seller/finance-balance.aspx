<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-balance.aspx.cs" Inherits="SellerFinanceBalance" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Số dư tài khoản</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Số Dư Tài Khoản</h2>
                <p>Theo dõi số dư và lịch sử giao dịch tài khoản LoveIs</p>
            </div>
        </div>

        <div class="finance-toolbar">
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

        <div class="finance-balance-grid">
            <div class="finance-balance-hero">
                <div class="finance-balance-label"><i class="fa-solid fa-dollar-sign"></i> Số Dư Hiện Tại</div>
                <div class="finance-balance-value">68.500.000 đ</div>
                <div class="finance-balance-note">+4.300.000 đ so với tháng trước</div>
            </div>
            <div class="card finance-mini-card">
                <span class="finance-mini-icon info-green"><i class="fa-solid fa-arrow-up"></i></span>
                <div class="finance-mini-label">Tiền Vào</div>
                <div class="finance-mini-value">125.500.000 đ</div>
                <div class="finance-mini-sub">30 ngày qua</div>
            </div>
            <div class="card finance-mini-card">
                <span class="finance-mini-icon info-red"><i class="fa-solid fa-arrow-down"></i></span>
                <div class="finance-mini-label">Tiền Ra</div>
                <div class="finance-mini-value">57.000.000 đ</div>
                <div class="finance-mini-sub">30 ngày qua</div>
            </div>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-chart-title">Biến Động Số Dư</div>
            <div class="finance-chart-placeholder line-chart"></div>
        </div>
    </div>
</asp:Content>
