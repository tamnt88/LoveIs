<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-shipping-settings.aspx.cs" Inherits="SellerOrderShippingSettings" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Cài đặt vận chuyển</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-shipping">
        <div class="shipping-header">
            <div>
                <h2>Cài Đặt Vận Chuyển</h2>
                <p>Quản lý cài đặt giao hàng và đơn vị vận chuyển</p>
            </div>
        </div>
        <asp:Literal ID="ShippingMessageLiteral" runat="server" />

        <div class="card shipping-card">
            <div class="shipping-section-title"><i class="fa-solid fa-truck"></i> Đơn Vị Vận Chuyển</div>
            <div class="form-group form-group-full">
                <label>Phương thức vận chuyển</label>
                <asp:DropDownList ID="ShippingMethodDropDown" runat="server" CssClass="form-control" />
            </div>
            <div class="shipping-provider-grid">
                <asp:Repeater ID="CarrierRepeater" runat="server">
                    <ItemTemplate>
                        <div class="shipping-provider <%# (bool)Eval("IsDefault") ? "active" : "" %>">
                            <div>
                                <div class="shipping-provider-title"><%# Eval("Name") %></div>
                                <div class="shipping-provider-price"><%# Eval("Description") %></div>
                            </div>
                            <div class="shipping-provider-actions">
                                <label class="shipping-default">
                                    <input type="radio" name="defaultCarrier" value="<%# Eval("Id") %>" <%# (bool)Eval("IsDefault") ? "checked=\"checked\"" : "" %> />
                                    Mặc định
                                </label>
                                <label class="shipping-enable">
                                    <input type="checkbox" name="carrierIds" value="<%# Eval("Id") %>" <%# (bool)Eval("IsEnabled") ? "checked=\"checked\"" : "" %> />
                                    Bật
                                </label>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="card shipping-card">
            <div class="shipping-section-title"><i class="fa-solid fa-location-dot"></i> Địa Chỉ Lấy Hàng</div>
            <asp:Panel ID="PickupAddressPanel" runat="server" CssClass="shipping-address-card" Visible="false">
                <span class="address-pill" id="PickupDefaultPill" runat="server">Mặc định</span>
                <div class="address-card-title"><asp:Literal ID="PickupAddressTitleLiteral" runat="server" /></div>
                <div class="address-card-sub"><asp:Literal ID="PickupAddressLineLiteral" runat="server" /></div>
                <div class="address-card-sub">SDT: <asp:Literal ID="PickupAddressPhoneLiteral" runat="server" /></div>
            </asp:Panel>
            <asp:Panel ID="PickupEmptyPanel" runat="server" CssClass="shipping-address-card" Visible="false">
                <div class="address-card-title">Chưa có địa chỉ lấy hàng</div>
                <div class="address-card-sub">Vui lòng thêm địa chỉ để sử dụng khi giao hàng.</div>
            </asp:Panel>
            <a class="shipping-add-box" href="settings-address.aspx">+ Thêm Địa Chỉ Lấy Hàng Mới</a>
        </div>

        <div class="card shipping-card">
            <div class="shipping-section-title"><i class="fa-regular fa-clock"></i> Thời Gian Xử Lý</div>
            <div class="form-group form-group-full">
                <label>Thời gian chuẩn bị hàng</label>
                <select class="form-control">
                    <option>1 ngày</option>
                    <option>2 ngày</option>
                    <option>3 ngày</option>
                    <option>4 ngày</option>
                </select>
            </div>
            <div class="shipping-toggle-card">
                <div>
                    <div class="shipping-toggle-title">Tự động xác nhận đơn hàng</div>
                    <div class="shipping-toggle-sub">Tự động xác nhận sau 30 phút nhận đơn</div>
                </div>
                <label class="switch">
                    <input type="checkbox" checked />
                    <span class="slider"></span>
                </label>
            </div>
        </div>

        <div class="card shipping-card">
            <div class="shipping-section-title"><i class="fa-solid fa-dollar-sign"></i> Phí Vận Chuyển</div>
            <div class="shipping-toggle-card">
                <div>
                    <div class="shipping-toggle-title">Miễn phí vận chuyển</div>
                    <div class="shipping-toggle-sub">Áp dụng cho đơn hàng từ mức tối thiểu</div>
                </div>
                <label class="switch">
                    <input type="checkbox" id="FreeShippingToggle" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
            <div class="form-group form-group-full" style="margin-top:14px;">
                <label>Mức tối thiểu miễn phí vận chuyển</label>
                <asp:TextBox ID="FreeShippingMinOrderInput" runat="server" CssClass="form-control" placeholder="Ví dụ: 500000" />
            </div>
        </div>

        <div class="shipping-actions">
            <asp:LinkButton ID="SaveShippingButton" runat="server" CssClass="btn-address-primary" OnClick="SaveShippingButton_Click">Lưu Cài Đặt</asp:LinkButton>
        </div>
    </div>
</asp:Content>
