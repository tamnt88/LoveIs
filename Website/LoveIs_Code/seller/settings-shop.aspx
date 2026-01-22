<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-shop.aspx.cs" Inherits="SellerSettingsShop" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Cài đặt cửa hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-shop-settings">
        <div class="settings-header">
            <div>
                <h2>Cài đặt shop</h2>
                <p>Quản lý thông tin và cài đặt shop của bạn</p>
            </div>
        </div>

        <asp:Literal ID="FormMessageLiteral" runat="server" />

        <div class="card settings-card">
            <div class="settings-card-title">
                <i class="fa-regular fa-file-lines"></i>
                Thông tin kinh doanh
            </div>
            <div class="settings-grid">
                <div class="form-group">
                    <label>Loại hình kinh doanh</label>
                    <asp:DropDownList ID="BusinessTypeDropDown" runat="server" CssClass="form-control">
                        <asp:ListItem Value="individual">Cá nhân</asp:ListItem>
                        <asp:ListItem Value="company">Doanh nghiệp</asp:ListItem>
                        <asp:ListItem Value="household">Hộ kinh doanh</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Mã số thuế</label>
                    <asp:TextBox ID="TaxCodeInput" runat="server" CssClass="form-control" Placeholder="Nhập mã số thuế (nếu có)" />
                </div>
            </div>
        </div>

        <div class="card settings-card">
            <div class="settings-card-title">
                <i class="fa-solid fa-id-card"></i>
                Xác thực người bán (KYC)
            </div>
            <asp:Literal ID="KycMessageLiteral" runat="server" />
            <div class="settings-grid">
                <div class="form-group form-group-full">
                    <label>Trạng thái</label>
                    <asp:TextBox ID="KycStatusInput" runat="server" CssClass="form-control" ReadOnly="true" />
                    <div class="helper-text" id="KycStatusNote" runat="server"></div>
                </div>
                <div class="form-group">
                    <label>Họ và tên</label>
                    <asp:TextBox ID="KycFullNameInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Ngày sinh</label>
                    <asp:TextBox ID="KycBirthDateInput" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="form-group">
                    <label>Số CCCD/CMND</label>
                    <asp:TextBox ID="KycIdNumberInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Ngày cấp</label>
                    <asp:TextBox ID="KycIdIssuedDateInput" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="form-group form-group-full">
                    <label>Nơi cấp</label>
                    <asp:TextBox ID="KycIdIssuedPlaceInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>CCCD mặt trước</label>
                    <div class="image-upload-card">
                        <asp:Image ID="KycFrontPreview" runat="server" CssClass="image-preview square" />
                        <asp:FileUpload ID="KycFrontUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="KycFrontTrigger">Tải lên</button>
                    </div>
                </div>
                <div class="form-group">
                    <label>CCCD mặt sau</label>
                    <div class="image-upload-card">
                        <asp:Image ID="KycBackPreview" runat="server" CssClass="image-preview square" />
                        <asp:FileUpload ID="KycBackUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="KycBackTrigger">Tải lên</button>
                    </div>
                </div>
                <div class="form-group">
                    <label>Selfie cầm CCCD</label>
                    <div class="image-upload-card">
                        <asp:Image ID="KycSelfiePreview" runat="server" CssClass="image-preview square" />
                        <asp:FileUpload ID="KycSelfieUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="KycSelfieTrigger">Tải lên</button>
                    </div>
                </div>
            </div>
            <div class="settings-actions">
                <asp:LinkButton ID="SubmitKycButton" runat="server" CssClass="btn-address-primary" OnClick="SubmitKycButton_Click">Gửi xác thực</asp:LinkButton>
            </div>
        </div>

        <div class="settings-actions">
            <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn-address-outline" OnClick="CancelButton_Click">Hủy</asp:LinkButton>
            <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn-address-primary" OnClick="SaveButton_Click">Lưu thay đổi</asp:LinkButton>
        </div>
    </div>
    <script>
        (function () {
            var saveButton = document.getElementById('<%= SaveButton.ClientID %>');
            if (!saveButton) return;

            var kycFrontInput = document.getElementById('<%= KycFrontUpload.ClientID %>');
            var kycBackInput = document.getElementById('<%= KycBackUpload.ClientID %>');
            var kycSelfieInput = document.getElementById('<%= KycSelfieUpload.ClientID %>');
            var kycFrontTrigger = document.getElementById('KycFrontTrigger');
            var kycBackTrigger = document.getElementById('KycBackTrigger');
            var kycSelfieTrigger = document.getElementById('KycSelfieTrigger');
            if (kycFrontTrigger && kycFrontInput) {
                kycFrontTrigger.addEventListener('click', function () {
                    kycFrontInput.click();
                });
            }
            if (kycBackTrigger && kycBackInput) {
                kycBackTrigger.addEventListener('click', function () {
                    kycBackInput.click();
                });
            }
            if (kycSelfieTrigger && kycSelfieInput) {
                kycSelfieTrigger.addEventListener('click', function () {
                    kycSelfieInput.click();
                });
            }
        })();
    </script>
</asp:Content>
