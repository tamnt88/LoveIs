<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerSidebar.ascx.cs" Inherits="CustomerSidebar" %>

<div class="account-sidebar">
    <div class="account-user">
        <div class="account-avatar">
            <img src="/images/fav.png" alt="Avatar" />
        </div>
        <div>
            <div class="account-username"><asp:Literal ID="UsernameLiteral" runat="server" /></div>
            <a class="account-edit" href="/tai-khoan/ho-so.aspx">Sửa hồ sơ</a>
        </div>
    </div>
    <div class="account-menu">
        <div class="account-menu-title">Tài khoản của tôi</div>
        <a class="account-menu-item <%= IsActive("/tai-khoan/ho-so.aspx") %>" href="/tai-khoan/ho-so.aspx">Hồ sơ</a>
        <a class="account-menu-item <%= IsActive("/tai-khoan/ngan-hang.aspx") %>" href="/tai-khoan/ngan-hang.aspx">Ngân hàng</a>
        <a class="account-menu-item <%= IsActive("/tai-khoan/dia-chi.aspx") %>" href="/tai-khoan/dia-chi.aspx">Địa chỉ</a>
        <a class="account-menu-item <%= IsActive("/tai-khoan/doi-mat-khau.aspx") %>" href="/tai-khoan/doi-mat-khau.aspx">Đổi mật khẩu</a>
        <a class="account-menu-item <%= IsActive("#notify") %>" href="#">Cài đặt thông báo</a>
        <a class="account-menu-item <%= IsActive("#privacy") %>" href="#">Thiết lập riêng tư</a>
        <div class="account-menu-title mt-3">Đơn mua</div>
        <a class="account-menu-item <%= IsActive("/tai-khoan/don-mua.aspx") %>" href="/tai-khoan/don-mua.aspx">Đơn mua</a>
        <a class="account-menu-item <%= IsActive("#voucher") %>" href="#">Kho voucher</a>
        <a class="account-menu-item <%= IsActive("#coin") %>" href="#">LoveIs Xu</a>
    </div>
</div>
