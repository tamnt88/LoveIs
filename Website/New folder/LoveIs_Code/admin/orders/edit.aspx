<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminOrdersEdit" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Chi tiết đơn hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Chi tiết đơn hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Cập nhật trạng thái đơn hàng
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Đơn hàng</a></li>
    <li class="breadcrumb-item"><a href="/admin/orders/default.aspx">Danh sách</a></li>
    <li class="breadcrumb-item active" aria-current="page">Chi tiết</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="OrderPanel" runat="server" CssClass="card-kpi p-3 bg-white">
        <div class="row g-3">
            <div class="col-lg-7">
                <div class="card-kpi p-3">
                    <h6 class="section-title mb-3">Thông tin đơn hàng</h6>
                    <div class="row g-2">
                        <div class="col-md-6">
                            <label class="form-label">Mã đơn hàng</label>
                            <asp:Literal ID="OrderCodeLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày đặt</label>
                            <asp:Literal ID="OrderDateLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Khách hàng</label>
                            <asp:Literal ID="CustomerLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <asp:Literal ID="PhoneLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Địa chỉ giao hàng</label>
                            <asp:Literal ID="AddressLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Ghi chú</label>
                            <asp:Literal ID="NoteLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <div class="card-kpi p-3 mt-3">
                    <h6 class="section-title mb-3">Sản phẩm đặt mua</h6>
                    <div class="table-responsive">
                        <table class="table table-striped align-middle">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Biến thể</th>
                                    <th class="text-end">Giá</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-end">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="ItemsRepeater" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("ProductName") %></td>
                                            <td><%# Eval("VariantName") %></td>
                                            <td class="text-end"><%# Eval("PriceText") %></td>
                                            <td class="text-center"><%# Eval("Quantity") %></td>
                                            <td class="text-end"><%# Eval("LineTotalText") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="card-kpi p-3">
                    <h6 class="section-title mb-3">Trạng thái & thanh toán</h6>
                    <asp:Label ID="SaveMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái đơn</label>
                        <asp:DropDownList ID="OrderStatusInput" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái thanh toán</label>
                        <asp:DropDownList ID="PaymentStatusInput" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phương thức thanh toán</label>
                        <asp:Literal ID="PaymentMethodLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Vận chuyển</label>
                        <asp:Literal ID="ShippingLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phí vận chuyển</label>
                        <asp:Literal ID="ShippingFeeLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Dự kiến giao</label>
                        <asp:Literal ID="ShippingEtaLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tạm tính</label>
                        <asp:Literal ID="SubtotalLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Khuyến mãi</label>
                        <asp:Literal ID="DiscountLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tổng cộng</label>
                        <asp:Literal ID="TotalLiteral" runat="server"></asp:Literal>
                    </div>
                    <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Lưu cập nhật" OnClick="SaveButton_Click" />
                    <a href="/admin/orders/default.aspx" class="btn btn-outline-secondary btn-with-icon ms-2">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>

                <div class="card-kpi p-3 mt-3">
                    <h6 class="section-title mb-3">Thông tin hóa đơn</h6>
                    <div class="row g-2">
                        <div class="col-12">
                            <label class="form-label">Xuất hóa đơn</label>
                            <asp:Literal ID="InvoiceRequiredLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Tên công ty</label>
                            <asp:Literal ID="InvoiceCompanyLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mã số thuế</label>
                            <asp:Literal ID="InvoiceTaxLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Email nhận hóa đơn</label>
                            <asp:Literal ID="InvoiceEmailLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ hóa đơn</label>
                            <asp:Literal ID="InvoiceAddressLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <div class="card-kpi p-3 mt-3">
                    <h6 class="section-title mb-3">Lịch sử xử lý</h6>
                    <asp:Repeater ID="HistoryRepeater" runat="server">
                        <ItemTemplate>
                            <div class="border-bottom pb-2 mb-2">
                                <div class="fw-semibold"><%# Eval("Action") %></div>
                                <div class="text-muted small"><%# Eval("CreatedAt") %></div>
                                <div class="small"><%# Eval("Note") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="OrderIdField" runat="server" />
    </asp:Panel>
    <asp:Label ID="ErrorMessage" runat="server" CssClass="text-danger small d-block"></asp:Label>
</asp:Content>
