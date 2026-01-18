<%@ Page Language="C#" AutoEventWireup="true" CodeFile="support-center.aspx.cs" Inherits="SellerSupportCenter" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Trung tâm hỗ trợ</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-support">
        <div class="support-header">
            <div>
                <h2>Trung tâm hỗ trợ</h2>
                <p>Tra cứu hướng dẫn và chính sách hỗ trợ dành cho người bán.</p>
            </div>
        </div>

        <div class="support-info-grid">
            <div class="card support-info-card">
                <div class="support-info-icon info-blue"><i class="fa-regular fa-circle-question"></i></div>
                <div>
                    <div class="support-info-title">Câu hỏi thường gặp</div>
                    <div class="support-info-desc">Tìm câu trả lời nhanh cho các tình huống phổ biến.</div>
                </div>
            </div>
            <div class="card support-info-card">
                <div class="support-info-icon info-green"><i class="fa-regular fa-circle-check"></i></div>
                <div>
                    <div class="support-info-title">Chính sách người bán</div>
                    <div class="support-info-desc">Cập nhật điều khoản, quy định, xử lý vi phạm.</div>
                </div>
            </div>
            <div class="card support-info-card">
                <div class="support-info-icon info-orange"><i class="fa-regular fa-file-lines"></i></div>
                <div>
                    <div class="support-info-title">Hướng dẫn thao tác</div>
                    <div class="support-info-desc">Hướng dẫn đăng sản phẩm, xử lý đơn và hoàn trả.</div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
