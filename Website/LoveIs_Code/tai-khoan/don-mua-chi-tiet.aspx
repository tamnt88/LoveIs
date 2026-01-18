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
                        <div class="order-meta-row">
                            <span>Hóa đơn:</span>
                            <strong>
                                <asp:LinkButton ID="InvoiceInfoButton" runat="server" CssClass="btn btn-outline-dark btn-sm" OnClientClick="var modal = new bootstrap.Modal(document.getElementById('InvoiceInfoModal')); modal.show(); return false;" Visible="false">
                                    Có xuất hóa đơn
                                </asp:LinkButton>
                                <asp:Literal ID="InvoiceNoneLiteral" runat="server" />
                            </strong>
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
                                    <a class="order-shop-name" href="<%# Eval("ShopUrl") %>">
                                        <i class="fa-solid fa-shop"></i>
                                        <%# Eval("ShopName") %>
                                    </a>
                                    <div class="order-shop-tags">
                                        <span class="<%# Eval("ShopStatusClass") %>">
                                            <i class="<%# Eval("ShopStatusIconClass") %>"></i>
                                            Trạng thái: <%# Eval("ShopStatusText") %>
                                        </span>
                                        <span class="<%# Eval("ShopPaymentStatusClass") %>">
                                            <i class="<%# Eval("ShopPaymentIconClass") %>"></i>
                                            Thanh toán: <%# Eval("ShopPaymentStatusText") %>
                                        </span>
                                    </div>
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
                                <div class="order-shop-footer">
                                    <div class="order-shop-fee">Phí vận chuyển: <strong><%# Eval("ShopShippingFeeText") %></strong></div>
                                    <div class="order-shop-subtotal">Tạm tính (shop): <strong><%# Eval("ShopSubtotalText") %></strong></div>
                                </div>
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
                    <asp:Panel ID="OrderActionPanel" runat="server" CssClass="mt-3" Visible="false">
                        <asp:HiddenField ID="OrderIdField" runat="server" />
                        <asp:HiddenField ID="OpenCancelModalField" runat="server" />
                        <asp:Literal ID="ActionMessageLiteral" runat="server" />
                        <div class="small text-muted mb-2">Chức năng: Hủy đơn hoặc yêu cầu hoàn tiền/đổi trả.</div>
                        <asp:Panel ID="ReturnItemsPanel" runat="server" CssClass="mt-2" Visible="false">
                            <div class="small text-muted mb-2">Chọn sản phẩm và số lượng cần đổi/trả hoặc hoàn tiền:</div>
                            <asp:Repeater ID="ReturnItemsRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="d-flex align-items-start gap-2 mb-2">
                                        <asp:CheckBox ID="ReturnItemCheckBox" runat="server" CssClass="form-check-input mt-1" />
                                        <div class="flex-grow-1">
                                            <div class="fw-semibold"><%# Eval("ProductName") %></div>
                                            <div class="text-muted small"><%# Eval("VariantName") %></div>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <asp:HiddenField ID="ReturnItemIdField" runat="server" Value='<%# Eval("OrderItemId") %>' />
                                            <asp:TextBox ID="ReturnQtyInput" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("Quantity") %>' Style="width:64px" />
                                            <span class="small text-muted">/ <%# Eval("Quantity") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </asp:Panel>

                        <asp:Panel ID="ReturnReasonPanel" runat="server" CssClass="form-group mt-2" Visible="false">
                            <label for="ReturnReasonInput">Lý do (bắt buộc khi hoàn tiền/đổi trả)</label>
                            <asp:TextBox ID="ReturnReasonInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                        </asp:Panel>
                        <div class="d-flex gap-2 mt-2 order-action-row">
                            <asp:LinkButton ID="CancelOrderButton" runat="server" CssClass="btn btn-outline-danger" OnClientClick="var modal = new bootstrap.Modal(document.getElementById('CancelOrderModal')); modal.show(); return false;" Visible="false">
                                <i class="fa-solid fa-ban"></i> Hủy đơn hàng
                            </asp:LinkButton>
                            <asp:LinkButton ID="RequestRefundButton" runat="server" CssClass="btn btn-outline-dark" OnClick="RequestRefundButton_Click" Visible="false">
                                <i class="fa-solid fa-rotate-left"></i> Yêu cầu hoàn tiền
                            </asp:LinkButton>
                            <asp:LinkButton ID="RequestReturnButton" runat="server" CssClass="btn btn-outline-dark" OnClick="RequestReturnButton_Click" Visible="false">
                                <i class="fa-solid fa-right-left"></i> Yêu cầu đổi/trả
                            </asp:LinkButton>
                            <asp:LinkButton ID="ReorderButton" runat="server" CssClass="btn btn-dark" OnClick="ReorderButton_Click">
                                <i class="fa-solid fa-cart-plus"></i> Mua lại
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="EmptyPanel" runat="server" CssClass="account-empty" Visible="false">
                        Không tìm thấy đơn hàng.
                    </asp:Panel>
                </div>
            </div>
        </div>
    </main>

    <div class="modal fade" id="CancelOrderModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hủy đơn hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <asp:Literal ID="CancelReasonMessageLiteral" runat="server" />
                    <div class="form-group">
                        <label for="CancelReasonInput">Lý do hủy (bắt buộc)</label>
                        <asp:TextBox ID="CancelReasonInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
                    <asp:LinkButton ID="ConfirmCancelButton" runat="server" CssClass="btn btn-danger" OnClick="CancelOrderButton_Click">
                        Xác nhận hủy
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="InvoiceInfoModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thông tin hóa đơn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <div class="order-meta-row">
                        <span>Tên công ty:</span>
                        <strong><asp:Literal ID="InvoiceCompanyLiteral" runat="server" /></strong>
                    </div>
                    <div class="order-meta-row">
                        <span>Mã số thuế:</span>
                        <strong><asp:Literal ID="InvoiceTaxLiteral" runat="server" /></strong>
                    </div>
                    <div class="order-meta-row">
                        <span>Email nhận hóa đơn:</span>
                        <strong><asp:Literal ID="InvoiceEmailLiteral" runat="server" /></strong>
                    </div>
                    <div class="order-meta-row">
                        <span>Địa chỉ xuất hóa đơn:</span>
                        <strong><asp:Literal ID="InvoiceAddressLiteral" runat="server" /></strong>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        .order-shop-header {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 12px 16px;
            justify-content: space-between;
        }
        .order-shop-name {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
        }
        .order-shop-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
        }
        .status-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            border: 1px solid transparent;
            white-space: nowrap;
        }
        .status-tag--success {
            color: #1f7a4b;
            background: #e8f7ef;
            border-color: #bfe7d2;
        }
        .status-tag--warning {
            color: #9a6b00;
            background: #fff3d4;
            border-color: #f3d89d;
        }
        .status-tag--info {
            color: #2563eb;
            background: #eaf2ff;
            border-color: #c6ddff;
        }
        .status-tag--primary {
            color: #6b21a8;
            background: #f3e8ff;
            border-color: #e0c8ff;
        }
        .status-tag--danger {
            color: #b42318;
            background: #fdecec;
            border-color: #f7c8c8;
        }
        .status-tag--neutral {
            color: #4b5563;
            background: #f3f4f6;
            border-color: #e5e7eb;
        }
        .order-shop-footer {
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            flex-wrap: wrap;
            padding-top: 8px;
            border-top: none;
            margin-top: 8px;
        }
        .order-shop-fee,
        .order-shop-subtotal {
            font-size: 16px;
            color: #7a2b4a;
            white-space: nowrap;
        }
        .order-action-row {
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 10px;
        }
        #CancelOrderModal .form-control {
            border: 1px solid #e3d6db;
        }
    </style>
</asp:Content>
