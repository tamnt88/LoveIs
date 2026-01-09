<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-returns.aspx.cs" Inherits="SellerReturns" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Trả hàng / Hoàn tiền</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-returns">
        <div class="order-header">
            <h2>Trả hàng / Hoàn tiền</h2>
            <p class="order-subtitle">Quản lý yêu cầu trả hàng và hoàn tiền</p>
        </div>
        <div class="return-summary-grid">
            <div class="summary-card">
                <div class="summary-label">Tổng yêu cầu</div>
                <div class="summary-value"><asp:Literal ID="TotalRequestLiteral" runat="server" /></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Chờ xử lý</div>
                <div class="summary-value text-pending"><asp:Literal ID="PendingRequestLiteral" runat="server" /></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Đã chấp nhận</div>
                <div class="summary-value text-approved"><asp:Literal ID="ApprovedRequestLiteral" runat="server" /></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Đã từ chối</div>
                <div class="summary-value text-rejected"><asp:Literal ID="RejectedRequestLiteral" runat="server" /></div>
            </div>
        </div>
        <div class="return-tabs">
            <a class="tab <%# GetTabClass("all") %>" href="/seller/order-returns.aspx?status=all">Tất cả</a>
            <a class="tab <%# GetTabClass("PENDING") %>" href="/seller/order-returns.aspx?status=PENDING">Chờ xử lý</a>
            <a class="tab <%# GetTabClass("APPROVED") %>" href="/seller/order-returns.aspx?status=APPROVED">Đã chấp nhận</a>
            <a class="tab <%# GetTabClass("REJECTED") %>" href="/seller/order-returns.aspx?status=REJECTED">Đã từ chối</a>
            <a class="tab <%# GetTabClass("PICKUP") %>" href="/seller/order-returns.aspx?status=PICKUP">Đã nhận hàng</a>
            <a class="tab <%# GetTabClass("RETURNED") %>" href="/seller/order-returns.aspx?status=RETURNED">Đã trả lại</a>
            <a class="tab <%# GetTabClass("REFUNDED") %>" href="/seller/order-returns.aspx?status=REFUNDED">Đã hoàn tiền</a>
            <a class="tab <%# GetTabClass("CLOSED") %>" href="/seller/order-returns.aspx?status=CLOSED">Đã đóng</a>
        </div>
        <div class="return-toolbar card">
            <div class="return-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Tìm kiếm theo mã đơn, mã trả hàng..." />
            </div>
            <button class="btn-outline" type="button"><i class="fa-solid fa-filter"></i> Bộ lọc</button>
        </div>
        <div class="return-table card">
            <div class="return-table-head">
                <div>Mã trả hàng</div>
                <div>Mã ĐH</div>
                <div>Khách hàng</div>
                <div>Sản phẩm</div>
                <div>Lý do</div>
                <div>Giá trị</div>
                <div>Ngày YC</div>
                <div>Trạng thái</div>
                <div>Thao tác</div>
            </div>
            <asp:Repeater ID="ReturnRepeater" runat="server">
                <ItemTemplate>
                    <div class="return-row">
                        <div class="return-code"><%# Eval("RequestCode") %></div>
                        <div><%# Eval("OrderCode") %></div>
                        <div><%# Eval("CustomerName") %></div>
                        <div><%# Eval("ProductName") %></div>
                        <div><%# Eval("Reason") %></div>
                        <div><%# Eval("TotalLabel") %></div>
                        <div><%# Eval("RequestedAt") %></div>
                        <div><span class="return-pill <%# Eval("StatusClass") %>"><%# Eval("StatusLabel") %></span></div>
                        <div class="return-action"><a href="<%# Eval("ActionUrl") %>"><i class="fa-solid fa-eye"></i> Xem</a></div>
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
