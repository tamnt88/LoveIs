<%@ Page Language="C#" AutoEventWireup="true" CodeFile="don-mua-chi-tiet.aspx.cs" Inherits="CustomerOrderDetail" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Chi tiết đơn mua
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 account-page">
        <div class="row g-4">
            <div class="col-lg-3">
                <uc:CustomerSidebar ID="CustomerSidebar" runat="server" />
            </div>
            <div class="col-lg-9">
                <div class="account-card">
                    <div class="account-card-header">
                        <h4>Chi tiết đơn mua</h4>
                        <asp:Literal ID="OrderInfoLiteral" runat="server" />
                    </div>
                    <asp:Panel ID="OrderMetaPanel" runat="server" CssClass="order-meta">
                        <div class="order-meta-row">
                            <span>Trạng thái đơn hàng:</span>
                            <strong><asp:Literal ID="OrderStatusLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-meta-row">
                            <span>Thanh toán:</span>
                            <strong><asp:Literal ID="PaymentStatusLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-meta-row">
                            <span>Vận chuyển:</span>
                            <strong><asp:Literal ID="ShippingMethodLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-meta-row">
                            <span>Phí vận chuyển:</span>
                            <strong><asp:Literal ID="ShippingFeeLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-meta-row">
                            <span>Ngày đặt:</span>
                            <strong><asp:Literal ID="OrderDateLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-meta-row">
                            <span>Địa chỉ giao hàng:</span>
                            <strong><asp:Literal ID="ShippingAddressLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-meta-row">
                            <span>Ghi chú:</span>
                            <strong><asp:Literal ID="OrderNoteLiteral" runat="server" /></strong>
                        </div>
                    </asp:Panel>
                    <div class="order-timeline">
                        <div class="order-timeline-title">Lịch sử trạng thái</div>
                        <asp:Repeater ID="OrderHistoryRepeater" runat="server">
                            <ItemTemplate>
                                <div class="order-timeline-item">
                                    <span class="dot"></span>
                                    <div>
                                        <div class="order-timeline-note"><%# Eval("Note") %></div>
                                        <div class="order-timeline-time"><%# Eval("CreatedAt", "{0:dd/MM/yyyy HH:mm}") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <asp:Repeater ID="ShopRepeater" runat="server">
                        <ItemTemplate>
                            <div class="order-shop">
                                <div class="order-shop-header">
                                    <a class="order-shop-name" href="<%# Eval("ShopUrl") %>"><%# Eval("ShopName") %></a>
                                </div>
                                <asp:Repeater ID="OrderItemRepeater" runat="server" DataSource='<%# Eval("Items") %>'>
                                    <ItemTemplate>
                                        <div class="account-list-item order-item">
                                            <div>
                                                <div class="account-list-title"><%# Eval("ProductName") %></div>
                                                <div class="account-list-text"><%# Eval("VariantName") %></div>
                                                <div class="account-list-text">Số lượng: <%# Eval("Quantity") %></div>
                                            </div>
                                            <div class="order-total"><%# Eval("LineTotal", "{0:N0} đ") %></div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <div class="order-summary">
                        <div class="order-summary-row">
                            <span>Tạm tính:</span>
                            <strong><asp:Literal ID="SubtotalLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-summary-row">
                            <span>Phí vận chuyển:</span>
                            <strong><asp:Literal ID="OrderShippingFeeLiteral" runat="server" /></strong>
                        </div>
                        <div class="order-summary-row total">
                            <span>Tổng cộng:</span>
                            <strong><asp:Literal ID="OrderTotalLiteral" runat="server" /></strong>
                        </div>
                    </div>
                    <asp:Panel ID="EmptyPanel" runat="server" CssClass="account-empty" Visible="false">
                        Không tìm thấy đơn hàng.
                    </asp:Panel>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
