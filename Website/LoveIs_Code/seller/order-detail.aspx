<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-detail.aspx.cs" Inherits="SellerOrderDetail" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Chi tiết đơn hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-orders">
        <asp:HiddenField ID="ShopOrderIdField" runat="server" />
        <div class="order-detail-header card">
            <div>
                <h2>Chi tiết đơn hàng</h2>
            </div>
            <div class="order-detail-status">
                <span class="status-pill <%= StatusClassField.Value %>"><asp:Literal ID="StatusLabelLiteral" runat="server" /></span>
                <div class="order-detail-code">Mã đơn hàng: <asp:Literal ID="OrderCodeLiteral" runat="server" /></div>
                <div class="status-time"><asp:Literal ID="OrderCreatedLiteral" runat="server" /></div>
            </div>
        </div>

        <div class="card order-detail-card order-progress">
            <div class="order-detail-title">Tiến trình đơn hàng</div>
            <div class="order-progress-steps steps-8">
                <asp:LinkButton ID="StepNewButton" runat="server" CssClass="order-progress-step" CommandArgument="NEW" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">1</span>
                    <span class="step-label">Đơn mới</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepConfirmedButton" runat="server" CssClass="order-progress-step" CommandArgument="CONFIRMED" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">2</span>
                    <span class="step-label">Đã xác nhận</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepPackingButton" runat="server" CssClass="order-progress-step" CommandArgument="PACKING" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">3</span>
                    <span class="step-label">Đang đóng gói</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepReadyButton" runat="server" CssClass="order-progress-step" CommandArgument="READY_TO_SHIP" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">4</span>
                    <span class="step-label">Sẵn sàng giao</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepShippedButton" runat="server" CssClass="order-progress-step" CommandArgument="SHIPPED" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">5</span>
                    <span class="step-label">Đã bàn giao</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepDeliveringButton" runat="server" CssClass="order-progress-step" CommandArgument="DELIVERING" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">6</span>
                    <span class="step-label">Đang giao</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepDeliveredButton" runat="server" CssClass="order-progress-step" CommandArgument="DELIVERED" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">7</span>
                    <span class="step-label">Đã giao</span>
                </asp:LinkButton>
                <asp:LinkButton ID="StepCompletedButton" runat="server" CssClass="order-progress-step" CommandArgument="COMPLETED" OnCommand="UpdateStatusButton_Command">
                    <span class="step-dot">8</span>
                    <span class="step-label">Hoàn tất</span>
                </asp:LinkButton>
            </div>
        </div>

        <div class="order-detail-grid">
            <div class="card order-detail-card">
                <div class="order-detail-title">Thông tin đơn hàng</div>
                <div class="order-detail-row"><span>Khách hàng:</span><strong><asp:Literal ID="CustomerNameLiteral" runat="server" /></strong></div>
                <div class="order-detail-row"><span>Điện thoại:</span><strong><asp:Literal ID="CustomerPhoneLiteral" runat="server" /></strong></div>
                <div class="order-detail-row"><span>Địa chỉ:</span><strong><asp:Literal ID="ShippingAddressLiteral" runat="server" /></strong></div>
                <div class="order-detail-row"><span>Ghi chú:</span><strong><asp:Literal ID="OrderNoteLiteral" runat="server" /></strong></div>
            </div>

            <div class="card order-detail-card">
                <div class="order-detail-title">Vận chuyển & Thanh toán</div>
                <div class="order-detail-row"><span>Vận chuyển:</span><strong><asp:Literal ID="ShippingMethodLiteral" runat="server" /></strong></div>
                <div class="order-detail-row"><span>Mã vận chuyển:</span><strong><asp:Literal ID="ShippingCodeLiteral" runat="server" /></strong></div>
                <div class="order-detail-row"><span>Phí vận chuyển:</span><strong><asp:Literal ID="ShippingFeeLiteral" runat="server" /></strong></div>
                <div class="order-detail-row"><span>Thanh toán:</span><strong><asp:Literal ID="PaymentStatusLiteral" runat="server" /></strong></div>
            </div>

            <div class="card order-detail-card">
                <div class="order-detail-title">Thông tin hóa đơn</div>
                <asp:Panel ID="InvoicePanel" runat="server">
                    <div class="order-detail-row"><span>Công ty:</span><strong><asp:Literal ID="InvoiceCompanyLiteral" runat="server" /></strong></div>
                    <div class="order-detail-row"><span>Mã số thuế:</span><strong><asp:Literal ID="InvoiceTaxLiteral" runat="server" /></strong></div>
                    <div class="order-detail-row"><span>Email:</span><strong><asp:Literal ID="InvoiceEmailLiteral" runat="server" /></strong></div>
                    <div class="order-detail-row"><span>Địa chỉ:</span><strong><asp:Literal ID="InvoiceAddressLiteral" runat="server" /></strong></div>
                </asp:Panel>
                <asp:Literal ID="InvoiceNoneLiteral" runat="server" />
            </div>
        </div>

        <div class="card order-detail-card">
            <div class="order-detail-title">Sản phẩm</div>
            <asp:Repeater ID="OrderItemRepeater" runat="server">
                <ItemTemplate>
                    <div class="order-detail-item">
                        <div class="order-detail-product">
                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                            <div>
                                <div class="product-name"><%# Eval("ProductName") %></div>
                                <div class="product-meta"><%# Eval("VariantLabel") %></div>
                                <div class="product-qty">x<%# Eval("Quantity") %></div>
                            </div>
                        </div>
                        <div class="order-detail-total"><%# Eval("LineTotalLabel") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <div class="order-detail-summary">
                <div class="order-summary-row"><span>Tạm tính</span><span>:</span><strong><asp:Literal ID="SubtotalLiteral" runat="server" /></strong></div>
                <div class="order-summary-row"><span>Phí vận chuyển</span><span>:</span><strong><asp:Literal ID="ShopShippingFeeLiteral" runat="server" /></strong></div>
                <div class="order-summary-row total"><span>Tổng cộng</span><span>:</span><strong><asp:Literal ID="TotalLiteral" runat="server" /></strong></div>
            </div>
        </div>

        <div class="card order-detail-card">
            <div class="order-detail-title">Lịch sử xử lý</div>
            <asp:Repeater ID="OrderHistoryRepeater" runat="server">
                <ItemTemplate>
                    <div class="order-history-item">
                        <div class="order-history-note"><%# Eval("Note") %></div>
                        <div class="order-history-meta"><%# Eval("CreatedAt", "{0:dd/MM/yyyy HH:mm}") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:HiddenField ID="StatusClassField" runat="server" />
    </div>
</asp:Content>
