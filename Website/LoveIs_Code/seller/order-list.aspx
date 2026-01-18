<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-list.aspx.cs" Inherits="SellerOrders" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Assembly Name="System.IO.Compression" %>
<%@ Assembly Name="System.IO.Compression.FileSystem" %>
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
                    <asp:TextBox ID="OrderCodeTextBox" runat="server" Placeholder="Mã đơn hàng"></asp:TextBox>
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>
                <select>
                    <option>Mã phiếu đơn hàng</option>
                </select>
                <asp:LinkButton ID="ExportButton" runat="server" CssClass="btn-outline" OnClick="ExportButton_Click">Xuất</asp:LinkButton>
                <asp:LinkButton ID="ExportHistoryButton" runat="server" CssClass="btn-outline" OnClick="ExportHistoryButton_Click">Lịch sử Xuất Báo cáo</asp:LinkButton>
            </div>
            <div class="order-filters-row">
                <label>Đơn vị vận chuyển</label>
                <asp:DropDownList ID="ShippingMethodDropDown" runat="server"></asp:DropDownList>
                <div class="spacer"></div>
                <asp:LinkButton ID="ApplyFiltersButton" runat="server" CssClass="btn-primary" OnClick="ApplyFiltersButton_Click">Áp dụng</asp:LinkButton>
                <asp:LinkButton ID="ResetFiltersButton" runat="server" CssClass="btn-outline" OnClick="ResetFiltersButton_Click">Đặt lại</asp:LinkButton>
            </div>
        </div>
        <asp:Panel ID="ExportHistoryPanel" runat="server" CssClass="export-history-modal" Visible="false">
            <div class="export-history-card">
                <div class="export-history-header">
                    <div>Lịch sử xuất báo cáo</div>
                    <asp:HyperLink ID="ExportHistoryCloseLink" runat="server" CssClass="btn-primary small">Đóng</asp:HyperLink>
                </div>
                <div class="export-history-body">
                    <asp:Repeater ID="ExportHistoryRepeater" runat="server">
                        <HeaderTemplate>
                            <div class="export-history-table-head">
                                <div>Thời gian xuất</div>
                                <div>Tổng đơn hàng</div>
                                <div>Tên file</div>
                                <div>Thao tác</div>
                            </div>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="export-history-row">
                                <div><%# Eval("CreatedAtText") %></div>
                                <div><%# Eval("TotalOrders") %></div>
                                <div><%# Eval("FileName") %></div>
                                <div><a class="btn-primary small" href="<%# Eval("DownloadUrl") %>">Tải lại</a></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </asp:Panel>
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

