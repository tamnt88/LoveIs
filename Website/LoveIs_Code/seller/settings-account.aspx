<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-account.aspx.cs" Inherits="SellerSettingsAccount" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thông tin cửa hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-account-settings">
        <div class="settings-header">
            <div>
                <h2>Thông tin cửa hàng</h2>
                <p>Quản lý thông tin cửa hàng của bạn</p>
            </div>
        </div>

        <div class="card settings-card">
            <div class="settings-card-title">
                <i class="fa-solid fa-house"></i>
                Thông tin shop
            </div>
            <asp:Literal ID="AccountMessageLiteral" runat="server" />
            <div class="settings-grid">
                <div class="form-group">
                    <label>Tên shop</label>
                    <asp:TextBox ID="ShopNameInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group form-group-full">
                    <label>Mô tả shop</label>
                    <asp:TextBox ID="DescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" TextMode="Email" />
                </div>
            </div>
            <div class="settings-actions account-actions">
                <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn-address-primary" OnClick="SaveButton_Click">Lưu thay đổi</asp:LinkButton>
            </div>
        </div>

        <div class="card settings-card">
            <div class="settings-card-title">
                <i class="fa-regular fa-images"></i>
                Logo &amp; hình ảnh
            </div>
            <div class="settings-grid logo-grid">
                <div class="form-group">
                    <label>Logo shop</label>
                    <div class="image-upload-card">
                        <asp:Image ID="LogoPreview" runat="server" CssClass="image-preview square" />
                        <asp:FileUpload ID="LogoUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="LogoUploadTrigger">Tải lên logo</button>
                    </div>
                </div>
                <div class="form-group">
                    <label>Banner shop</label>
                    <div class="image-upload-card wide">
                        <asp:Image ID="BannerPreview" runat="server" CssClass="image-preview wide" />
                        <asp:FileUpload ID="BannerUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="BannerUploadTrigger">Tải lên banner</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card settings-card account-security-card">
            <div class="settings-card-title">
                <i class="fa-solid fa-shield-halved"></i>
                Bảo mật tài khoản
            </div>
            <asp:Literal ID="PasswordMessageLiteral" runat="server" />
            <div class="security-item">
                <div class="security-icon password">
                    <i class="fa-solid fa-key"></i>
                </div>
                <div class="security-info">
                    <div class="security-title">Mật khẩu</div>
                    <div class="security-subtitle">
                        Thay đổi lần cuối: <asp:Literal ID="PasswordChangedAtLiteral" runat="server" />
                    </div>
                </div>
                <button type="button" class="btn-address-outline" id="TogglePasswordForm">Đổi mật khẩu</button>
            </div>
            <div class="security-form" id="PasswordForm">
                <div class="settings-grid">
                    <div class="form-group">
                        <label>Mật khẩu hiện tại</label>
                        <asp:TextBox ID="CurrentPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <asp:TextBox ID="NewPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu mới</label>
                        <asp:TextBox ID="ConfirmPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                </div>
                <div class="settings-actions account-actions">
                    <asp:LinkButton ID="ChangePasswordButton" runat="server" CssClass="btn-address-primary" OnClick="ChangePasswordButton_Click">Cập nhật mật khẩu</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <script>
        (function () {
            var logoInput = document.getElementById('<%= LogoUpload.ClientID %>');
            var bannerInput = document.getElementById('<%= BannerUpload.ClientID %>');
            var saveButton = document.getElementById('<%= SaveButton.ClientID %>');
            if (!saveButton) return;

            function bindUpload(input) {
                if (!input) return;
                input.addEventListener('change', function () {
                    if (input.files && input.files.length > 0) {
                        saveButton.click();
                    }
                });
            }

            bindUpload(logoInput);
            bindUpload(bannerInput);

            var logoTrigger = document.getElementById('LogoUploadTrigger');
            var bannerTrigger = document.getElementById('BannerUploadTrigger');
            if (logoTrigger && logoInput) {
                logoTrigger.addEventListener('click', function () {
                    logoInput.click();
                });
            }
            if (bannerTrigger && bannerInput) {
                bannerTrigger.addEventListener('click', function () {
                    bannerInput.click();
                });
            }

            var passwordToggle = document.getElementById('TogglePasswordForm');
            var passwordForm = document.getElementById('PasswordForm');
            if (passwordForm) {
                passwordForm.classList.remove('open');
            }
            if (passwordToggle && passwordForm) {
                passwordToggle.addEventListener('click', function () {
                    passwordForm.classList.toggle('open');
                });
            }
            if (passwordForm && window.location.hash === '#password') {
                passwordForm.classList.add('open');
                passwordForm.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        })();
    </script>
</asp:Content>
