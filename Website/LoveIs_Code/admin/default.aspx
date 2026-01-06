<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Tổng quan
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Bảng điều khiển
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Chào mừng bạn đến hệ thống quản trị BeautyStory
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item active" aria-current="page">Tổng quan</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-md-4 col-lg-3">
            <div class="card-kpi p-3 bg-white dashboard-card">
                <div class="text-muted small">Đơn hàng hôm nay</div>
                <div class="fs-4 fw-semibold"><asp:Literal ID="OrdersTodayLiteral" runat="server" /></div>
                <div class="text-muted small">Doanh thu: <asp:Literal ID="RevenueTodayLiteral" runat="server" /></div>
            </div>
        </div>
        <div class="col-md-4 col-lg-3">
            <div class="card-kpi p-3 bg-white dashboard-card">
                <div class="text-muted small">Tổng đơn hàng</div>
                <div class="fs-4 fw-semibold"><asp:Literal ID="OrdersTotalLiteral" runat="server" /></div>
                <div class="text-muted small">Chờ xử lý: <asp:Literal ID="OrdersPendingLiteral" runat="server" /></div>
            </div>
        </div>
        <div class="col-md-4 col-lg-3">
            <div class="card-kpi p-3 bg-white dashboard-card">
                <div class="text-muted small">Sản phẩm</div>
                <div class="fs-4 fw-semibold"><asp:Literal ID="ProductsTotalLiteral" runat="server" /></div>
                <div class="text-muted small">Sắp hết hàng: <asp:Literal ID="LowStockCountLiteral" runat="server" /></div>
            </div>
        </div>
        <div class="col-md-4 col-lg-3">
            <div class="card-kpi p-3 bg-white dashboard-card">
                <div class="text-muted small">Khách hàng</div>
                <div class="fs-4 fw-semibold"><asp:Literal ID="CustomersTotalLiteral" runat="server" /></div>
                <div class="text-muted small">Liên hệ mới: <asp:Literal ID="ContactNewLiteral" runat="server" /></div>
            </div>
        </div>
    </div>

    <div class="row g-3 mt-2">
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <h6 class="mb-0 section-title">Đơn hàng gần đây</h6>
                    <div class="d-flex gap-2">
                        <a class="btn btn-sm btn-primary" href="/admin/orders/create.aspx">Tạo đơn hàng</a>
                        <a class="btn btn-sm btn-outline-secondary" href="/admin/orders/default.aspx">Xem tất cả</a>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-sm align-middle mb-0 dashboard-table">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Khách hàng</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Tổng tiền</th>
                                <th>Ngày</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RecentOrdersRepeater" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><a href="/admin/orders/edit.aspx?id=<%# Eval("Id") %>"><%# Eval("OrderCode") %></a></td>
                                        <td><%# Eval("CustomerName") %></td>
                                        <td><span class="info-tag info-tag-blue"><%# Eval("OrderStatus") %></span></td>
                                        <td class="text-end"><%# Eval("TotalText") %></td>
                                        <td><%# Eval("CreatedAtText") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="RecentOrdersEmpty" runat="server" CssClass="text-muted small mt-2" Visible="false">
                        Chưa có đơn hàng.
                    </asp:Panel>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <h6 class="mb-0 section-title">Sắp hết hàng</h6>
                    <a class="btn btn-sm btn-outline-secondary" href="/admin/products/default.aspx">Quản lý</a>
                </div>
                <div class="dashboard-list">
                    <asp:Repeater ID="LowStockRepeater" runat="server">
                        <ItemTemplate>
                            <div class="dashboard-list-item">
                                <div>
                                    <div class="fw-semibold"><%# Eval("ProductName") %></div>
                                    <div class="text-muted small"><%# Eval("VariantName") %></div>
                                </div>
                                <span class="info-tag info-tag-rose"><%# Eval("StockQty") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="LowStockEmpty" runat="server" CssClass="text-muted small" Visible="false">
                        Không có sản phẩm sắp hết hàng.
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3 mt-2">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white h-100">
                <h6 class="mb-2 section-title">Tác vụ nhanh</h6>
                <div class="d-grid gap-2">
                    <a class="btn btn-primary btn-with-icon" href="/admin/orders/create.aspx"><i class="fa-solid fa-plus"></i> Tạo đơn hàng</a>
                    <a class="btn btn-outline-secondary btn-with-icon" href="/admin/products/edit.aspx"><i class="fa-solid fa-box"></i> Thêm sản phẩm</a>
                    <a class="btn btn-outline-secondary btn-with-icon" href="/admin/cms/posts/edit.aspx"><i class="fa-solid fa-pen"></i> Viết bài viết</a>
                    <a class="btn btn-outline-secondary btn-with-icon" href="/admin/system/banners/default.aspx"><i class="fa-solid fa-image"></i> Quản lý banner</a>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <h6 class="mb-0 section-title">Tin nhắn liên hệ mới</h6>
                    <a class="btn btn-sm btn-outline-secondary" href="/admin/system/contact-messages.aspx">Xem tất cả</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-sm align-middle mb-0 dashboard-table">
                        <thead>
                            <tr>
                                <th>Khách hàng</th>
                                <th>Chủ đề</th>
                                <th>Ngày</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RecentContactsRepeater" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="fw-semibold"><%# Eval("FullName") %></div>
                                            <div class="text-muted small"><%# Eval("Email") %></div>
                                        </td>
                                        <td><%# Eval("Subject") %></td>
                                        <td><%# Eval("CreatedAtText") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="RecentContactsEmpty" runat="server" CssClass="text-muted small mt-2" Visible="false">
                        Chưa có tin nhắn liên hệ.
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>