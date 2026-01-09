<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-list.aspx.cs" Inherits="SellerOrders" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Đơn hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-orders">
        <div class="order-header">
            <h2><asp:Literal ID="OrderTitleLiteral" runat="server" /></h2>
            <p class="order-subtitle" runat="server" id="OrderSubtitle"></p>
        </div>
        <div class="order-tabs">
            <a class="tab <%# GetTabClass("all") %>" href="/seller/order-list.aspx?status=all">Tất cả</a>
            <a class="tab <%# GetTabClass("NEW") %>" href="/seller/order-list.aspx?status=NEW">Chờ xác nhận</a>
            <a class="tab <%# GetTabClass("CONFIRMED") %>" href="/seller/order-list.aspx?status=CONFIRMED">Chờ lấy hàng</a>
            <a class="tab <%# GetTabClass("SHIPPING") %>" href="/seller/order-list.aspx?status=SHIPPING">Đang giao</a>
            <a class="tab <%# GetTabClass("COMPLETED") %>" href="/seller/order-list.aspx?status=COMPLETED">Đã giao</a>
            <a class="tab <%# GetTabClass("CANCELLED") %>" href="/seller/order-list.aspx?status=CANCELLED">Trả hàng/Hoàn tiền/Hủy</a>
        </div>
        <div class="order-filters card">
            <div class="order-filters-row">
                <div class="search-box">
                    <input type="text" placeholder="Mã đơn hàng" />
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>
                <select>
                    <option>Mã phiếu đơn hàng</option>
                </select>
                <button class="btn-outline" type="button">Xuất</button>
                <button class="btn-outline" type="button">Lịch sử Xuất Báo cáo</button>
            </div>
            <div class="order-filters-row">
                <label>Đơn vị vận chuyển</label>
                <select>
                    <option>Tất cả vị VN/VC</option>
                </select>
                <div class="spacer"></div>
                <button class="btn-primary" type="button">Áp dụng</button>
                <button class="btn-outline" type="button">Đặt lại</button>
            </div>
        </div>
        <div class="order-summary">
            <asp:Literal ID="OrderSummaryLiteral" runat="server" />
        </div>
        <div class="order-table">
            <div class="order-table-head">
                <div>Sản phẩm</div>
                <div>Tổng Đơn hàng</div>
                <div>Trạng thái</div>
                <div>Đơn vị vận chuyển</div>
                <div>Thao tác</div>
            </div>
            <asp:Repeater ID="OrderRepeater" runat="server">
                <ItemTemplate>
                    <div class="order-card">
                        <div class="order-buyer">
                            <div class="buyer-name"><%# Eval("CustomerName") %></div>
                            <div class="order-code">Mã đơn hàng: <%# Eval("OrderCode") %></div>
                        </div>
                        <asp:Repeater ID="OrderItemRepeater" runat="server" DataSource='<%# Eval("Items") %>'>
                            <ItemTemplate>
                                <div class="order-row">
                                    <div class="product-cell">
                                        <div class="thumb">
                                            <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                        </div>
                                        <div>
                                            <div class="product-name"><%# Eval("ProductName") %></div>
                                            <div class="product-meta"><%# Eval("VariantLabel") %></div>
                                            <div class="product-qty">x<%# Eval("Quantity") %></div>
                                        </div>
                                    </div>
                                    <div class="order-total">
                                        <%# (bool)Eval("ShowSummary") ? Eval("OrderTotalHtml") : "&nbsp;" %>
                                    </div>
                                    <div class="order-status">
                                        <%# (bool)Eval("ShowSummary") ? Eval("OrderStatusHtml") : "&nbsp;" %>
                                    </div>
                                    <div class="order-ship">
                                        <%# (bool)Eval("ShowSummary") ? Eval("ShippingHtml") : "&nbsp;" %>
                                    </div>
                                    <div class="order-action">
                                        <%# (bool)Eval("ShowSummary") ? Eval("ActionHtml") : "&nbsp;" %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="seller-pagination">
            <div class="pagination-info"><asp:Literal ID="PaginationInfoLiteral" runat="server" /></div>
            <div class="pagination-links"><asp:Literal ID="PaginationLiteral" runat="server" /></div>
        </div>
    </div>
</asp:Content>

