<%@ Page Language="C#" AutoEventWireup="true" CodeFile="don-mua.aspx.cs" Inherits="CustomerOrders" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Đơn mua
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
                        <h4>Đơn mua</h4>
                        <p>Theo dõi trạng thái đơn hàng của bạn</p>
                    </div>
                    <asp:Repeater ID="OrderRepeater" runat="server">
                        <ItemTemplate>
                            <div class="account-list-item order-item">
                                <div>
                                    <div class="account-list-title">
                                        Mã đơn: <%# Eval("OrderCode") %>
                                        <a class="account-change-link ms-2" href="/tai-khoan/don-mua-chi-tiet.aspx?id=<%# Eval("Id") %>">Xem chi tiết</a>
                                    </div>
                                    <div class="account-list-text">Ngày đặt: <%# Eval("CreatedAt", "{0:dd/MM/yyyy HH:mm}") %></div>
                                    <div class="account-list-text">Trạng thái: <%# Eval("OrderStatus") %></div>
                                </div>
                                <div class="order-total">Tổng: <%# Eval("Total", "{0:N0} đ") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="EmptyPanel" runat="server" CssClass="account-empty" Visible="false">
                        Bạn chưa có đơn hàng nào.
                    </asp:Panel>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
