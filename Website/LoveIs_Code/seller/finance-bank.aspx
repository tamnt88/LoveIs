<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-bank.aspx.cs" Inherits="SellerFinanceBank" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thiết lập tài khoản ngân hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header finance-header-split">
            <div>
                <h2>Thiết Lập Tài Khoản Ngân Hàng</h2>
                <p>Quản lý tài khoản ngân hàng để nhận thanh toán</p>
            </div>
            <a class="btn-address-primary" href="#BankForm">Thêm tài khoản ngân hàng</a>
        </div>

        <div class="finance-alert">
            <i class="fa-solid fa-shield-halved"></i>
            <div>
                <strong>Bảo mật thông tin:</strong> Thông tin tài khoản ngân hàng của bạn được mã hóa và bảo mật tuyệt đối.
                <div>Thời gian xử lý rút tiền: 1-3 ngày làm việc. Vui lòng đảm bảo thông tin chính xác để tránh sai sót.</div>
            </div>
        </div>

        <div class="review-reply-modal" id="BankModal">
            <div class="review-reply-dialog bank-modal-dialog">
                <div class="review-reply-head">
                    <span>Thêm / chỉnh sửa tài khoản ngân hàng</span>
                    <button type="button" class="review-reply-close" data-bank-modal-close>&times;</button>
                </div>
                <div class="review-reply-body">
                    <div class="settings-card" id="BankForm">
                        <asp:Literal ID="BankMessageLiteral" runat="server" />
                        <asp:HiddenField ID="BankIdField" runat="server" />
                        <asp:HiddenField ID="BankShopIdField" runat="server" />
                        <asp:HiddenField ID="BankModalOpenField" runat="server" ClientIDMode="Static" />
                        <div class="settings-grid">
                            <div class="form-group form-group-full bank-select-row">
                                <label>Ngân hàng</label>
                                <div class="bank-select">
                                    <div class="bank-select-logo">
                                        <asp:Image ID="BankLogoPreview" runat="server" AlternateText="Bank logo" />
                                    </div>
                                    <asp:DropDownList ID="BankNameDropDown" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="form-group">
                                    <label>Số tài khoản</label>
                                    <div class="bank-number-input">
                                        <asp:TextBox ID="AccountNumberInput" runat="server" CssClass="form-control bank-number-field" />
                                        <asp:LinkButton ID="CheckAccountButton" runat="server" CssClass="bank-check-link inline" OnClick="CheckAccountButton_Click" OnClientClick="document.getElementById('BankModalOpenField').value='1';">Kiểm tra</asp:LinkButton>
                                    </div>
                            </div>
                            <div class="form-group">
                                <label>Chủ tài khoản</label>
                                <asp:TextBox ID="AccountNameInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="form-group form-group-full">
                                <label class="bank-default-inline">
                                    <asp:CheckBox ID="IsDefaultCheckBox" runat="server" />
                                    <span>Mặc định</span>
                                </label>
                            </div>
                        </div>
                        <div class="settings-actions">
                            <asp:LinkButton ID="ResetBankButton" runat="server" CssClass="btn-address-outline" OnClick="ResetBankButton_Click">Làm mới</asp:LinkButton>
                            <asp:LinkButton ID="SaveBankButton" runat="server" CssClass="btn-address-primary" OnClick="SaveBankButton_Click">Lưu</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="finance-bank-grid">
            <asp:Repeater ID="BankRepeater" runat="server" OnItemCommand="BankRepeater_ItemCommand">
                <ItemTemplate>
                    <div class='<%# (bool)Eval("IsDefault") ? "finance-bank-card finance-bank-main" : "finance-bank-card" %>'>
                        <div class="finance-bank-top">
                            <div class="bank-logo"><%# Eval("BankShort") %></div>
                            <div class="bank-title">
                                <div class="bank-name"><%# Eval("BankName") %></div>
                                <div class="bank-meta">Chủ tài khoản</div>
                                <div class="bank-number bank-owner"><%# Eval("AccountName") %></div>
                            </div>
                            <asp:PlaceHolder ID="DefaultHolder" runat="server" Visible='<%# Eval("IsDefault") %>'>
                                <span class="bank-pill">Mặc định</span>
                            </asp:PlaceHolder>
                        </div>
                        <div class="finance-bank-body">
                            <div>
                                <div class="bank-meta">Số tài khoản</div>
                                <div class="bank-number"><%# Eval("MaskedAccountNumber") %></div>
                            </div>
                            <div>
                                <div class="bank-meta">Chi nhánh</div>
                                <div class="bank-number"><%# Eval("Branch") %></div>
                            </div>
                        </div>
                        <div class="finance-bank-actions">
                            <asp:LinkButton ID="SetDefaultButton" runat="server" CssClass="btn-address-outline" CommandName="SetDefault" CommandArgument='<%# Eval("Id") %>' Visible='<%# !(bool)Eval("IsDefault") %>'>Đặt Mặc Định</asp:LinkButton>
                            <asp:LinkButton ID="EditButton" runat="server" CssClass="address-icon-btn" CommandName="EditBank" CommandArgument='<%# Eval("Id") %>'><i class="fa-regular fa-pen-to-square"></i></asp:LinkButton>
                            <asp:LinkButton ID="DeleteButton" runat="server" CssClass="address-icon-btn danger bank-delete" CommandName="DeleteBank" CommandArgument='<%# Eval("Id") %>'><i class="fa-regular fa-trash-can"></i></asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <script>
        (function () {
            var modal = document.getElementById("BankModal");
            var openBtn = document.querySelector(".finance-header .btn-address-primary");
            if (!modal || !openBtn) {
                return;
            }
            var closeBtn = modal.querySelector("[data-bank-modal-close]");
            var modalField = document.getElementById("BankModalOpenField");

            function openModal() {
                modal.classList.add("open");
                if (modalField) {
                    modalField.value = "1";
                }
            }

            function closeModal() {
                modal.classList.remove("open");
                if (modalField) {
                    modalField.value = "";
                }
            }

            openBtn.addEventListener("click", function (event) {
                event.preventDefault();
                openModal();
            });

            if (closeBtn) {
                closeBtn.addEventListener("click", closeModal);
            }

            modal.addEventListener("click", function (event) {
                if (event.target === modal) {
                    closeModal();
                }
            });
        })();
    </script>
    <script>
        (function () {
            var select = document.getElementById("<%= BankNameDropDown.ClientID %>");
            var logo = document.getElementById("<%= BankLogoPreview.ClientID %>");
            if (!select || !logo) {
                return;
            }

            function updateLogo() {
                var option = select.options[select.selectedIndex];
                var logoUrl = option ? option.getAttribute("data-logo") : "";
                logo.src = logoUrl || "/images/fav.png";
            }

            select.addEventListener("change", updateLogo);
            updateLogo();
        })();
    </script>
    <script>
        (function () {
            var input = document.getElementById("<%= AccountNumberInput.ClientID %>");
            var checkBtn = document.getElementById("<%= CheckAccountButton.ClientID %>");
            if (!input || !checkBtn) {
                return;
            }

            function toggleCheck() {
                var hasValue = !!(input.value || "").trim();
                checkBtn.style.display = hasValue ? "inline-flex" : "none";
            }

            input.addEventListener("input", toggleCheck);
            toggleCheck();
        })();
    </script>
</asp:Content>
