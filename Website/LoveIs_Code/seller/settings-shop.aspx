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
                <i class="fa-solid fa-house"></i>
                Thông tin shop
            </div>
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

        <div class="settings-actions">
            <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn-address-outline" OnClick="CancelButton_Click">Hủy</asp:LinkButton>
            <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn-address-primary" OnClick="SaveButton_Click">Lưu thay đổi</asp:LinkButton>
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
        })();
    </script>
</asp:Content>
