<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dia-chi.aspx.cs" Inherits="CustomerAddressPage" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Địa chỉ của tôi
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 account-page">
        <div class="row g-4">
            <div class="col-lg-3">
                <uc:CustomerSidebar ID="CustomerSidebar" runat="server" />
            </div>
            <div class="col-lg-9">
                <asp:UpdatePanel ID="AddressUpdatePanel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                <div class="account-card">
                    <div class="account-card-header account-card-header-row">
                        <div>
                            <h4>Địa chỉ của tôi</h4>
                            <p>Quản lý địa chỉ giao hàng để đặt đơn nhanh hơn</p>
                        </div>
                        <button type="button" class="btn btn-dark account-add-btn" data-toggle="address-form">+ Thêm địa chỉ mới</button>
                    </div>

                    <asp:Label ID="StatusMessage" runat="server" CssClass="account-message" />

                    <div class="collapse account-form" id="AddressForm" runat="server">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ và tên</label>
                                <asp:TextBox ID="FullNameInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Địa chỉ</label>
                                <asp:TextBox ID="AddressInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tỉnh/Thành phố</label>
                                <asp:DropDownList ID="ProvinceSelect" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ProvinceSelect_SelectedIndexChanged" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phường/Xã</label>
                                <asp:DropDownList ID="WardSelect" runat="server" CssClass="form-select" />
                            </div>
                        </div>
                        <asp:Button ID="SaveAddressButton" runat="server" CssClass="btn btn-dark account-save" Text="Lưu địa chỉ" OnClick="SaveAddressButton_Click" />
                    </div>

                    <asp:Repeater ID="AddressRepeater" runat="server" OnItemCommand="AddressRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="account-list-item">
                                <div>
                                    <div class="account-list-title"><%# Eval("FullName") %> | <%# Eval("Phone") %></div>
                                    <div class="account-list-text"><%# Eval("AddressLine") %></div>
                                    <div class="account-list-text"><%# Eval("WardName") %>, <%# Eval("ProvinceName") %></div>
                                    <asp:Literal ID="DefaultBadge" runat="server" Text='<%# (bool)Eval("IsDefault") ? "<span class=\"account-badge\">Mặc định</span>" : "" %>' />
                                </div>
                                <div class="account-list-actions">
                                    <asp:LinkButton ID="SetDefaultButton" runat="server" CommandName="set-default" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-outline-dark btn-sm">Thiết lập mặc định</asp:LinkButton>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CommandName="delete" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-link text-danger">Xóa</asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SaveAddressButton" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </main>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        (function () {
            var button = document.querySelector('[data-toggle="address-form"]');
            var target = document.getElementById('<%= AddressForm.ClientID %>');
            if (!button || !target) {
                return;
            }
            button.addEventListener('click', function () {
                target.classList.toggle('show');
            });
        })();
    </script>
</asp:Content>
