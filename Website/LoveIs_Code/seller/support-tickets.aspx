<%@ Page Language="C#" AutoEventWireup="true" CodeFile="support-tickets.aspx.cs" Inherits="SellerSupportTickets" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Yêu cầu hỗ trợ</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-support">
        <div class="support-header support-header-split">
            <div>
                <h2>Yêu Cầu Hỗ Trợ</h2>
                <p>Gửi yêu cầu hỗ trợ chi tiết</p>
            </div>
            <button class="btn-support-primary" type="button">
                <i class="fa-solid fa-plus"></i>
                Tạo Yêu Cầu Mới
            </button>
        </div>

        <div class="support-summary-grid">
            <div class="card support-summary-card">
                <div class="support-summary-icon info-blue"><i class="fa-regular fa-circle-question"></i></div>
                <div class="support-summary-label">Tổng Yêu Cầu</div>
                <div class="support-summary-value">18</div>
            </div>
            <div class="card support-summary-card">
                <div class="support-summary-icon info-yellow"><i class="fa-regular fa-clock"></i></div>
                <div class="support-summary-label">Đang Xử Lý</div>
                <div class="support-summary-value">3</div>
            </div>
            <div class="card support-summary-card">
                <div class="support-summary-icon info-green"><i class="fa-regular fa-circle-check"></i></div>
                <div class="support-summary-label">Đã Giải Quyết</div>
                <div class="support-summary-value">15</div>
            </div>
            <div class="card support-summary-card">
                <div class="support-summary-icon info-purple"><i class="fa-regular fa-hourglass"></i></div>
                <div class="support-summary-label">Thời Gian TB</div>
                <div class="support-summary-value">4.2h</div>
            </div>
        </div>

        <div class="card support-table">
            <div class="support-table-title">Lịch Sử Yêu Cầu</div>
            <div class="support-table-head">
                <div>Mã YC</div>
                <div>Tiêu Đề</div>
                <div>Danh Mục</div>
                <div>Ngày Tạo</div>
                <div>Trạng Thái</div>
                <div>Ưu Tiên</div>
            </div>
            <div class="support-row">
                <div>SR001</div>
                <div>Không thể xuất Excel báo cáo doanh thu</div>
                <div>Kỹ thuật</div>
                <div>08/12/2024</div>
                <div><span class="support-status success">Đã giải quyết</span></div>
                <div><span class="support-priority high">Cao</span></div>
            </div>
            <div class="support-row">
                <div>SR002</div>
                <div>Hỏi về chính sách hoa hồng</div>
                <div>Tài chính</div>
                <div>10/12/2024</div>
                <div><span class="support-status processing">Đang xử lý</span></div>
                <div><span class="support-priority medium">TB</span></div>
            </div>
            <div class="support-row">
                <div>SR003</div>
                <div>Yêu cầu hỗ trợ marketing</div>
                <div>Marketing</div>
                <div>11/12/2024</div>
                <div><span class="support-status pending">Chờ xử lý</span></div>
                <div><span class="support-priority low">Thấp</span></div>
            </div>
        </div>
    </div>
</asp:Content>
