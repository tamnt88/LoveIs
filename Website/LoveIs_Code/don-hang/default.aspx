<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="OrderDetail" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" EnableEventValidation="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Xem đơn hàng | Beauty Story
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-5 order-detail">
        <asp:Panel ID="NotFoundPanel" runat="server" Visible="false" CssClass="order-not-found">
            <div class="order-not-found__icon"><i class="fa-regular fa-circle-xmark"></i></div>
            <h2>Không tìm thấy đơn hàng</h2>
            <p>Mã đơn hàng không hợp lệ hoặc đã hết hạn.</p>
            <a href="/" class="btn btn-brand btn-with-icon"><i class="fa-solid fa-house"></i>Về trang chủ</a>
        </asp:Panel>

        <asp:Panel ID="OrderPanel" runat="server" Visible="false">
            <div class="order-header">
                <div>
                    <h1>Đơn hàng của bạn</h1>
                    <div class="order-code">Mã đơn: <strong><asp:Literal ID="OrderCodeLiteral" runat="server" /></strong></div>
                    <div class="order-date">Ngày đặt: <asp:Literal ID="OrderDateLiteral" runat="server" /></div>
                </div>
                <div class="order-status">
                    <span class="status-pill"><asp:Literal ID="OrderStatusLiteral" runat="server" /></span>
                </div>
            </div>

            <div class="order-steps">
                <div class="order-step active" id="StepPlaced" runat="server">
                    <span class="order-step__dot"></span>
                    <span class="order-step__label">Đặt hàng</span>
                </div>
                <div class="order-step" id="StepConfirmed" runat="server">
                    <span class="order-step__dot"></span>
                    <span class="order-step__label">Xác nhận</span>
                </div>
                <div class="order-step" id="StepShipping" runat="server">
                    <span class="order-step__dot"></span>
                    <span class="order-step__label">Đang giao</span>
                </div>
                <div class="order-step" id="StepDone" runat="server">
                    <span class="order-step__dot"></span>
                    <span class="order-step__label">Hoàn tất</span>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="order-card">
                        <div class="order-card__title">Sản phẩm đã đặt</div>
                        <div class="order-items">
                            <asp:Repeater ID="OrderItemsRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="order-item">
                                        <a class="order-item__thumb" href="<%# Eval("ProductUrl") %>">
                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" class="order-item__img" />
                                        </a>
                                        <div class="order-item__info">
                                            <div class="order-item__name">
                                                <a href="<%# Eval("ProductUrl") %>"><%# Eval("ProductName") %></a>
                                            </div>
                                            <div class="order-item__variant"><%# Eval("VariantName") %></div>
                                            <div class="order-item__meta">Số lượng: <%# Eval("Quantity") %></div>
                                        </div>
                                        <div class="order-item__price">
                                            <span class="price"><%# Eval("UnitPrice") %></span>
                                            <span class="line-total"><%# Eval("LineTotal") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="order-card">
                        <div class="order-card__title">Thông tin giao hàng</div>
                        <div class="order-info">
                            <div><span>Họ tên:</span> <asp:Literal ID="CustomerNameLiteral" runat="server" /></div>
                            <div><span>Số điện thoại:</span> <asp:Literal ID="PhoneLiteral" runat="server" /></div>
                            <div><span>Địa chỉ:</span> <asp:Literal ID="AddressLiteral" runat="server" /></div>
                            <div><span>Ghi chú:</span> <asp:Literal ID="NoteLiteral" runat="server" /></div>
                        </div>
                    </div>
                    <asp:Panel ID="InvoicePanel" runat="server" CssClass="order-card mt-3" Visible="false">
                        <div class="order-card__title">Thông tin hóa đơn</div>
                        <div class="order-info">
                            <div><span>Tên công ty:</span> <asp:Literal ID="InvoiceCompanyLiteral" runat="server" /></div>
                            <div><span>Mã số thuế:</span> <asp:Literal ID="InvoiceTaxLiteral" runat="server" /></div>
                            <div><span>Email nhận hóa đơn:</span> <asp:Literal ID="InvoiceEmailLiteral" runat="server" /></div>
                            <div><span>Địa chỉ xuất hóa đơn:</span> <asp:Literal ID="InvoiceAddressLiteral" runat="server" /></div>
                        </div>
                    </asp:Panel>
                    <div class="order-card mt-3">
                        <div class="order-card__title">Vận chuyển & thanh toán</div>
                        <div class="order-info">
                            <div><span>Phương thức giao:</span> <asp:Literal ID="ShippingMethodLiteral" runat="server" /></div>
                            <div><span>Dự kiến:</span> <asp:Literal ID="ShippingEtaLiteral" runat="server" /></div>
                            <div><span>Thanh toán:</span> <asp:Literal ID="PaymentMethodLiteral" runat="server" /></div>
                        </div>
                    </div>
                    <div class="order-card mt-3">
                        <div class="order-card__title">Tổng tiền</div>
                        <div class="order-summary">
                            <div><span>Tạm tính</span><strong><asp:Literal ID="SubtotalLiteral" runat="server" /></strong></div>
                            <div><span>Phí giao hàng</span><strong><asp:Literal ID="ShippingFeeLiteral" runat="server" /></strong></div>
                            <div><span>Khuyến mãi</span><strong><asp:Literal ID="DiscountLiteral" runat="server" /></strong></div>
                            <div class="order-summary__total"><span>Tổng thanh toán</span><strong><asp:Literal ID="TotalLiteral" runat="server" /></strong></div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </main>
</asp:Content>
