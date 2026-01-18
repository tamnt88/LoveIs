<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-account.aspx.cs" Inherits="SellerSettingsAccount" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Tài khoản</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-account-settings">
        <div class="settings-header">
            <div>
                <h2>Tài khoản</h2>
                <p>Quản lý thông tin tài khoản của bạn</p>
            </div>
        </div>

        <div class="card settings-card account-card">
            <div class="settings-card-title">
                <i class="fa-regular fa-user"></i>
                Thông tin cá nhân
            </div>
            <asp:Literal ID="AccountMessageLiteral" runat="server" />
            <div class="account-grid">
                <div class="account-avatar">
                    <div class="avatar-circle">
                        <asp:Image ID="AvatarImage" runat="server" CssClass="avatar-image" Visible="false" />
                        <asp:Literal ID="AvatarInitialsLiteral" runat="server" Text="FA" />
                    </div>
                    <asp:FileUpload ID="AvatarUpload" runat="server" CssClass="d-none" accept="image/*" />
                    <button type="button" class="btn-address-outline" id="AvatarUploadTrigger">Đổi ảnh</button>
                </div>
                <div class="account-form">
                    <div class="settings-grid">
                        <div class="form-group">
                            <label>Họ và tên</label>
                            <asp:TextBox ID="DisplayNameInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" TextMode="Email" />
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <asp:TextBox ID="BirthDateInput" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                    </div>
                    <div class="settings-actions account-actions">
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn-address-primary" OnClick="SaveButton_Click">Lưu thay đổi</asp:LinkButton>
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
            var avatarInput = document.getElementById('<%= AvatarUpload.ClientID %>');
            var avatarTrigger = document.getElementById('AvatarUploadTrigger');
            var avatarImage = document.getElementById('<%= AvatarImage.ClientID %>');
            var avatarInitials = document.getElementById('<%= AvatarInitialsLiteral.ClientID %>');
            if (avatarTrigger && avatarInput) {
                avatarTrigger.addEventListener('click', function () {
                    avatarInput.click();
                });
            }
            if (avatarInput) {
                avatarInput.addEventListener('change', function () {
                    if (!avatarInput.files || avatarInput.files.length === 0) {
                        return;
                    }
                    if (avatarImage) {
                        avatarImage.src = window.URL.createObjectURL(avatarInput.files[0]);
                        avatarImage.style.display = 'block';
                    }
                    if (avatarInitials) {
                        avatarInitials.style.display = 'none';
                    }
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
        })();
    </script>
</asp:Content>
