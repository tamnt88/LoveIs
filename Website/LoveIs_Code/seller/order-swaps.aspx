<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-swaps.aspx.cs" Inherits="SellerOrderSwaps" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Đơn đổi hàng / hàng ảo</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-order-swap">
        <div class="swap-header">
            <div>
                <h2>Đơn Đổi Hàng / Hàng Ảo</h2>
                <p>Quản lý yêu cầu đổi hàng và hàng ảo</p>
            </div>
        </div>

        <div class="swap-summary-grid">
            <div class="card swap-summary-card">
                <span class="swap-summary-icon info-blue"><i class="fa-solid fa-box"></i></span>
                <div class="swap-summary-label">Đơn Đổi Hàng</div>
                <div class="swap-summary-value">23</div>
            </div>
            <div class="card swap-summary-card">
                <span class="swap-summary-icon info-yellow"><i class="fa-solid fa-triangle-exclamation"></i></span>
                <div class="swap-summary-label">Đang Xử Lý</div>
                <div class="swap-summary-value">8</div>
            </div>
            <div class="card swap-summary-card">
                <span class="swap-summary-icon info-green"><i class="fa-solid fa-box-open"></i></span>
                <div class="swap-summary-label">Hoàn Thành</div>
                <div class="swap-summary-value">15</div>
            </div>
        </div>

        <div class="card swap-table">
            <div class="swap-table-title">Danh Sách Đổi Hàng</div>
            <div class="swap-table-head">
                <div>Mã Đổi Hàng</div>
                <div>Mã ĐH</div>
                <div>Khách Hàng</div>
                <div>SP Cũ</div>
                <div>SP Mới</div>
                <div>Trạng Thái</div>
                <div>Ngày YC</div>
            </div>
            <div class="swap-row">
                <div>EX001</div>
                <div>DH001260</div>
                <div>Nguyễn Văn A</div>
                <div>Áo Lót Size M</div>
                <div>Áo Lót Size L</div>
                <div><span class="swap-pill processing">Đang xử lý</span></div>
                <div>10/12/2024</div>
            </div>
            <div class="swap-row">
                <div>EX002</div>
                <div>DH001255</div>
                <div>Trần Thị B</div>
                <div>Set Đồ Màu Đỏ</div>
                <div>Set Đồ Màu Đen</div>
                <div><span class="swap-pill success">Hoàn thành</span></div>
                <div>09/12/2024</div>
            </div>
        </div>
    </div>
</asp:Content>
