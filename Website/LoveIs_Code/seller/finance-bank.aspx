<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-bank.aspx.cs" Inherits="SellerFinanceBank" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thiết lập tài khoản ngân hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header finance-header-split">
            <div>
                <h2>Thiết Lập Tài Khoản Ngân Hàng</h2>
                <p>Quản lý tài khoản ngân hàng để nhận thanh toán</p>
            </div>
        </div>

        <div class="finance-alert">
            <i class="fa-solid fa-shield-halved"></i>
            <div>
                <strong>Bảo mật thông tin:</strong> Thông tin tài khoản ngân hàng của bạn được mã hóa và bảo mật tuyệt đối.
                <div>Thời gian xử lý rút tiền: 1-3 ngày làm việc. Vui lòng đảm bảo thông tin chính xác để tránh sai sót.</div>
            </div>
        </div>

        <div class="card settings-card">
            <div class="settings-card-title">
                <i class="fa-solid fa-plus"></i>
                Thêm / chỉnh sửa tài khoản ngân hàng
            </div>
            <asp:Literal ID="BankMessageLiteral" runat="server" />
            <asp:HiddenField ID="BankIdField" runat="server" />
            <div class="settings-grid">
                <div class="form-group">
                    <label>Shop</label>
                    <asp:DropDownList ID="BankShopDropDown" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Ngân hàng</label>
                    <asp:TextBox ID="BankNameInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Chủ tài khoản</label>
                    <asp:TextBox ID="AccountNameInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Số tài khoản</label>
                    <asp:TextBox ID="AccountNumberInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Chi nhánh</label>
                    <asp:TextBox ID="BranchInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Mặc định</label>
                    <asp:CheckBox ID="IsDefaultCheckBox" runat="server" />
                </div>
            </div>
            <div class="settings-actions">
                <asp:LinkButton ID="ResetBankButton" runat="server" CssClass="btn-address-outline" OnClick="ResetBankButton_Click">Làm mới</asp:LinkButton>
                <asp:LinkButton ID="SaveBankButton" runat="server" CssClass="btn-address-primary" OnClick="SaveBankButton_Click">Lưu</asp:LinkButton>
            </div>
        </div>

        <asp:Repeater ID="BankRepeater" runat="server" OnItemCommand="BankRepeater_ItemCommand">
            <ItemTemplate>
                <div class='<%# (bool)Eval("IsDefault") ? "finance-bank-card finance-bank-main" : "finance-bank-card" %>'>
                    <div class="finance-bank-left">
                        <div class="bank-logo"><%# Eval("BankShort") %></div>
                        <div>
                            <div class="bank-name"><%# Eval("BankName") %></div>
                            <div class="bank-meta">Số tài khoản</div>
                            <div class="bank-number"><%# Eval("AccountNumber") %></div>
                            <div class="bank-meta">Chi nhánh</div>
                            <div class="bank-number"><%# Eval("Branch") %></div>
                        </div>
                        <asp:PlaceHolder ID="DefaultHolder" runat="server" Visible='<%# Eval("IsDefault") %>'>
                            <span class="bank-pill">Mặc định</span>
                        </asp:PlaceHolder>
                    </div>
                    <div class="finance-bank-right">
                        <div>
                            <div class="bank-meta">Chủ tài khoản</div>
                            <div class="bank-number"><%# Eval("AccountName") %></div>
                        </div>
                        <div class="address-actions">
                            <asp:LinkButton ID="SetDefaultButton" runat="server" CssClass="btn-address-outline" CommandName="SetDefault" CommandArgument='<%# Eval("Id") %>' Visible='<%# !(bool)Eval("IsDefault") %>'>Đặt Mặc Định</asp:LinkButton>
                            <asp:LinkButton ID="EditButton" runat="server" CssClass="address-icon-btn" CommandName="EditBank" CommandArgument='<%# Eval("Id") %>'><i class="fa-regular fa-pen-to-square"></i></asp:LinkButton>
                            <asp:LinkButton ID="DeleteButton" runat="server" CssClass="address-icon-btn danger" CommandName="DeleteBank" CommandArgument='<%# Eval("Id") %>'><i class="fa-regular fa-trash-can"></i></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
