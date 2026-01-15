<%@ Page Language="C#" AutoEventWireup="true" CodeFile="order-cancelled.aspx.cs" Inherits="SellerCancelledOrders" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Assembly Name="System.IO.Compression" %>
<%@ Assembly Name="System.IO.Compression.FileSystem" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Đơn Hàng Đã Hủy</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-orders">
        <div class="order-header">
            <h2>Đơn Hàng Đã Hủy</h2>
            <p class="order-subtitle">Quản lý các đơn hàng đã bị hủy</p>
        </div>
        <div class="cancel-summary-grid">
            <div class="summary-card">
                <div class="summary-label">Tổng Đơn Hủy</div>
                <div class="summary-value"><asp:Literal ID="CancelTotalLiteral" runat="server" /></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Hủy Bởi Khách</div>
                <div class="summary-value"><asp:Literal ID="CancelByCustomerLiteral" runat="server" /></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Hủy Bởi Shop</div>
                <div class="summary-value"><asp:Literal ID="CancelByShopLiteral" runat="server" /></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Giá Trị Hủy</div>
                <div class="summary-value"><asp:Literal ID="CancelTotalAmountLiteral" runat="server" /></div>
            </div>
        </div>
        <div class="cancel-toolbar card">
            <div class="cancel-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <asp:TextBox ID="SearchTextBox" runat="server" Placeholder="Mã đơn hàng hoặc tên khách hàng"></asp:TextBox>
            </div>
            <asp:LinkButton ID="ApplyFiltersButton" runat="server" CssClass="btn-outline" OnClick="ApplyFiltersButton_Click"><i class="fa-solid fa-filter"></i> Bộ lọc</asp:LinkButton>
            <asp:LinkButton ID="ExportButton" runat="server" CssClass="btn-outline" OnClick="ExportButton_Click"><i class="fa-solid fa-download"></i> Xuất File</asp:LinkButton>
            <asp:LinkButton ID="ResetFiltersButton" runat="server" CssClass="btn-primary" OnClick="ResetFiltersButton_Click"><i class="fa-solid fa-rotate-right"></i> Làm Mới</asp:LinkButton>
        </div>
        <div class="cancel-table card">
            <div class="cancel-table-head">
                <div>Mã ĐH</div>
                <div>Khách Hàng</div>
                <div>Sản Phẩm</div>
                <div>SL</div>
                <div>Giá Trị</div>
                <div>Ngày Hủy</div>
                <div>Lý Do</div>
                <div>Hủy Bởi</div>
            </div>
            <asp:Repeater ID="CancelRepeater" runat="server">
                <ItemTemplate>
                    <div class="cancel-row">
                        <div class="cancel-code"><%# Eval("OrderCode") %></div>
                        <div><%# Eval("CustomerName") %></div>
                        <div><%# Eval("ProductName") %></div>
                        <div><%# Eval("Quantity") %></div>
                        <div><%# Eval("TotalLabel") %></div>
                        <div><%# Eval("CancelledAt") %></div>
                        <div><%# Eval("Reason") %></div>
                        <div><span class="cancel-pill <%# Eval("CancelledByClass") %>"><%# Eval("CancelledBy") %></span></div>
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

