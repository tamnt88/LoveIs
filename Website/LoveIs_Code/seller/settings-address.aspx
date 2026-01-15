<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-address.aspx.cs" Inherits="SellerSettingsAddress" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Địa chỉ của tôi</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-addresses">
        <div class="address-header">
            <div>
                <h2>Địa Chỉ Của Tôi</h2>
                <p>Quản lý địa chỉ lấy hàng và giao hàng</p>
            </div>
            <asp:LinkButton ID="AddAddressButton" runat="server" CssClass="btn-address-primary" OnClick="AddAddressButton_Click">
                <i class="fa-solid fa-plus"></i>
                Thêm Địa Chỉ
            </asp:LinkButton>
        </div>

        <div class="address-summary-grid">
            <div class="address-summary-card address-pickup">
                <div class="address-summary-top">
                    <span class="address-summary-icon"><i class="fa-solid fa-house"></i></span>
                    <div>
                        <div class="address-summary-title">Địa Chỉ Lấy Hàng</div>
                        <div class="address-summary-sub">Kho/Shop của bạn</div>
                    </div>
                </div>
                <div class="address-summary-value"><asp:Literal ID="PickupCountLiteral" runat="server" /></div>
            </div>
            <div class="address-summary-card address-return">
                <div class="address-summary-top">
                    <span class="address-summary-icon"><i class="fa-solid fa-building"></i></span>
                    <div>
                        <div class="address-summary-title">Địa Chỉ Trả Hàng</div>
                        <div class="address-summary-sub">Nhận hàng hoàn trả</div>
                    </div>
                </div>
                <div class="address-summary-value"><asp:Literal ID="ReturnCountLiteral" runat="server" /></div>
            </div>
        </div>

        <asp:Repeater ID="AddressRepeater" runat="server" OnItemCommand="AddressRepeater_ItemCommand">
            <ItemTemplate>
                <div class="address-card <%# Eval("MainCardClass") %>">
                    <div class="address-card-head">
                        <div class="address-card-left">
                            <span class="address-card-icon"><i class="fa-solid fa-location-dot"></i></span>
                            <div>
                                <div class="address-card-title"><%# Eval("Title") %></div>
                                <div class="address-card-sub"><%# Eval("TypeLabel") %></div>
                            </div>
                            <span class="address-pill" <%# (bool)Eval("IsDefault") ? "" : "style=\"display:none;\"" %>>Mặc định</span>
                        </div>
                        <div class="address-actions">
                            <asp:LinkButton ID="SetDefaultButton" runat="server" CssClass="btn-address-outline" CommandName="SetDefault" CommandArgument='<%# Eval("Id") %>' Visible='<%# !(bool)Eval("IsDefault") %>'>Đặt Mặc Định</asp:LinkButton>
                            <asp:LinkButton ID="EditButton" runat="server" CssClass="address-icon-btn" CommandName="EditAddress" CommandArgument='<%# Eval("Id") %>'><i class="fa-regular fa-pen-to-square"></i></asp:LinkButton>
                            <asp:LinkButton ID="DeleteButton" runat="server" CssClass="address-icon-btn danger" CommandName="DeleteAddress" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Bạn có chắc muốn xóa địa chỉ này không?');"><i class="fa-regular fa-trash-can"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div class="address-card-body">
                        <div class="address-row"><span>Người liên hệ:</span> <%# Eval("ContactLine") %></div>
                        <div class="address-row"><span>Địa chỉ:</span> <%# Eval("AddressLine") %></div>
                        <div class="address-row"><span>Khu vực:</span> <%# Eval("AreaLine") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="AddressModal" runat="server" CssClass="address-modal" Visible="false">
        <div class="address-modal-card">
            <div class="address-modal-header">
                <div><asp:Literal ID="ModalTitleLiteral" runat="server" /></div>
                <asp:LinkButton ID="CloseModalButton" runat="server" CssClass="address-icon-btn" OnClick="CloseModalButton_Click"><i class="fa-solid fa-xmark"></i></asp:LinkButton>
            </div>
            <div class="address-modal-body">
                <asp:HiddenField ID="AddressIdHidden" runat="server" />
                <asp:HiddenField ID="ShopIdHidden" runat="server" />
                <div class="address-form-grid">
                    <div class="form-group">
                        <label>Tên địa chỉ</label>
                        <asp:TextBox ID="TitleInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Loại địa chỉ</label>
                        <asp:DropDownList ID="TypeDropDown" runat="server" CssClass="form-control">
                            <asp:ListItem Value="pickup">Địa chỉ lấy hàng</asp:ListItem>
                            <asp:ListItem Value="return">Địa chỉ trả hàng</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Người liên hệ</label>
                        <asp:TextBox ID="ContactNameInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group form-group-full">
                        <label>Địa chỉ</label>
                        <asp:TextBox ID="AddressLineInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Phường/Xã</label>
                        <asp:TextBox ID="WardInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Quận/Huyện</label>
                        <asp:TextBox ID="DistrictInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Tỉnh/Thành phố</label>
                        <asp:TextBox ID="ProvinceInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group form-group-full">
                        <asp:CheckBox ID="DefaultCheckBox" runat="server" Text="Đặt làm mặc định" />
                    </div>
                </div>
            </div>
            <div class="address-modal-footer">
                <asp:LinkButton ID="CancelModalButton" runat="server" CssClass="btn-outline" OnClick="CloseModalButton_Click">Hủy</asp:LinkButton>
                <asp:LinkButton ID="SaveAddressButton" runat="server" CssClass="btn-primary" OnClick="SaveAddressButton_Click">Lưu địa chỉ</asp:LinkButton>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
