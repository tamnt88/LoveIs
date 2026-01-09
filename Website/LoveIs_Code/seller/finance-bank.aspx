<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-bank.aspx.cs" Inherits="SellerFinanceBank" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thiết lập tài khoản ngân hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header finance-header-split">
            <div>
                <h2>Thiết Lập Tài Khoản Ngân Hàng</h2>
                <p>Quản lý tài khoản ngân hàng để nhận thanh toán</p>
            </div>
            <button class="btn-finance-primary" type="button">
                <i class="fa-solid fa-plus"></i>
                Thêm Tài Khoản
            </button>
        </div>

        <div class="finance-alert">
            <i class="fa-solid fa-shield-halved"></i>
            <div>
                <strong>Bảo mật thông tin:</strong> Thông tin tài khoản ngân hàng của bạn được mã hóa và bảo mật tuyệt đối.
                <div>Thời gian xử lý rút tiền: 1-3 ngày làm việc. Vui lòng đảm bảo thông tin chính xác để tránh sai sót.</div>
            </div>
        </div>

        <div class="finance-bank-card finance-bank-main">
            <div class="finance-bank-left">
                <div class="bank-logo">VCB</div>
                <div>
                    <div class="bank-name">Vietcombank</div>
                    <div class="bank-meta">Số tài khoản</div>
                    <div class="bank-number">0123456789</div>
                    <div class="bank-meta">Chi nhánh</div>
                    <div class="bank-number">Chi nhánh TP.HCM</div>
                </div>
                <span class="bank-pill">Mặc định</span>
                <span class="bank-pill soft">Đã xác thực</span>
            </div>
            <div class="finance-bank-right">
                <div>
                    <div class="bank-meta">Chủ tài khoản</div>
                    <div class="bank-number">NGUYEN VAN A</div>
                </div>
                <button class="address-icon-btn" type="button"><i class="fa-regular fa-pen-to-square"></i></button>
            </div>
        </div>

        <div class="finance-bank-card">
            <div class="finance-bank-left">
                <div class="bank-logo">TCB</div>
                <div>
                    <div class="bank-name">Techcombank</div>
                    <div class="bank-meta">Số tài khoản</div>
                    <div class="bank-number">9876543210</div>
                    <div class="bank-meta">Chi nhánh</div>
                    <div class="bank-number">Chi nhánh Đống Đa</div>
                </div>
                <span class="bank-pill soft">Đã xác thực</span>
            </div>
            <div class="finance-bank-right">
                <div>
                    <div class="bank-meta">Chủ tài khoản</div>
                    <div class="bank-number">NGUYEN VAN A</div>
                </div>
                <div class="address-actions">
                    <button class="btn-address-outline" type="button">Đặt Mặc Định</button>
                    <button class="address-icon-btn" type="button"><i class="fa-regular fa-pen-to-square"></i></button>
                    <button class="address-icon-btn danger" type="button"><i class="fa-regular fa-trash-can"></i></button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
