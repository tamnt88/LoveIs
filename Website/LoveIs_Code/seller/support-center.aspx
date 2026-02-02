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

        <div class="support-section-title">Danh Mục Hỗ Trợ</div>
        <div class="support-category-grid">
            <div class="card support-category-card">
                <div class="support-category-icon info-blue"><i class="fa-regular fa-mobile"></i></div>
                <div class="support-category-title">Hướng dẫn bán hàng</div>
                <div class="support-category-count">24 bài viết</div>
            </div>
            <div class="card support-category-card">
                <div class="support-category-icon info-purple"><i class="fa-solid fa-gear"></i></div>
                <div class="support-category-title">Quản lý đơn hàng</div>
                <div class="support-category-count">18 bài viết</div>
            </div>
            <div class="card support-category-card">
                <div class="support-category-icon info-orange"><i class="fa-solid fa-bolt"></i></div>
                <div class="support-category-title">Marketing & Quảng cáo</div>
                <div class="support-category-count">15 bài viết</div>
            </div>
            <div class="card support-category-card">
                <div class="support-category-icon info-green"><i class="fa-regular fa-file-lines"></i></div>
                <div class="support-category-title">Chính sách & Quy định</div>
                <div class="support-category-count">12 bài viết</div>
            </div>
        </div>

        <div class="card support-faq-card">
            <div class="support-faq-title">Câu Hỏi Thường Gặp</div>
            <div class="support-faq-list">
                <div class="support-faq-item">
                    <span>Cách tạo sản phẩm mới</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </div>
                <div class="support-faq-item">
                    <span>Xử lý đơn hàng hoàn trả</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </div>
                <div class="support-faq-item">
                    <span>Thiết lập chương trình Flash Sale</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </div>
                <div class="support-faq-item">
                    <span>Cách tạo mã giảm giá</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </div>
                <div class="support-faq-item">
                    <span>Tối ưu SEO cho sản phẩm</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </div>
                <div class="support-faq-item">
                    <span>Quy trình giao hàng</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
