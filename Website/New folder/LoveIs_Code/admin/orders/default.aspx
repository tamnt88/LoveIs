<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminOrdersDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Quản lý đơn hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Quản lý đơn hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Danh sách đơn hàng
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Đơn hàng</a></li>
    <li class="breadcrumb-item active" aria-current="page">Danh sách</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <div class="admin-filters mb-3">
            <div class="row g-2 align-items-end">
                <div class="col-md-3">
                    <label class="form-label">Mã đơn hàng</label>
                    <input type="text" id="filterCode" class="form-control" placeholder="Nhập mã đơn hàng" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Khách hàng</label>
                    <input type="text" id="filterCustomer" class="form-control" placeholder="Họ tên khách hàng" />
                </div>
                <div class="col-md-2">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" id="filterPhone" class="form-control" placeholder="Số điện thoại" />
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái đơn</label>
                    <asp:DropDownList ID="FilterOrderStatus" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Thanh toán</label>
                    <asp:DropDownList ID="FilterPaymentStatus" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>
            </div>
            <div class="row g-2 align-items-end mt-1">
                <div class="col-md-3">
                    <label class="form-label">Vận chuyển</label>
                    <asp:DropDownList ID="FilterShippingMethod" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" id="filterFrom" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" id="filterTo" class="form-control" />
                </div>
                <div class="col-md-3 d-flex gap-2 align-items-end">
                    <button type="button" class="btn btn-outline-dark btn-with-icon" id="applyFilters">
                        <i class="fa-solid fa-filter"></i> Lọc
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-with-icon" id="resetFilters">
                        <i class="fa-solid fa-rotate-left"></i> Làm mới
                    </button>
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="mb-0 section-title">Danh sách đơn hàng</h6>
            <a class="btn btn-sm btn-primary" href="/admin/orders/create.aspx"><i class="fa-solid fa-plus"></i> Tạo đơn hàng</a>
        </div>
        <asp:Label ID="ListMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="table-responsive">
            <table id="orderTable" class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>SĐT</th>
                        <th>Ngày đặt</th>
                        <th>Thanh toán</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Tổng tiền</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/admin/assets/vendor/datatables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="/admin/assets/vendor/datatables/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/admin/assets/vendor/datatables/js/jquery.dataTables.min.js"></script>
    <script src="/admin/assets/vendor/datatables/js/dataTables.bootstrap5.min.js"></script>
    <script>
        (function ($) {
            if (!$.fn.DataTable) {
                return;
            }

            var table = $("#orderTable").DataTable({
                pageLength: 25,
                order: [[3, "desc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "default.aspx/GetOrders",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: function (d) {
                        return JSON.stringify({
                            draw: d.draw,
                            start: d.start,
                            length: d.length,
                            search: d.search ? d.search.value : "",
                            orderColumn: d.order && d.order.length ? d.order[0].column : 0,
                            orderDir: d.order && d.order.length ? d.order[0].dir : "desc",
                            code: $("#filterCode").val(),
                            customer: $("#filterCustomer").val(),
                            phone: $("#filterPhone").val(),
                            orderStatusId: $("#<%= FilterOrderStatus.ClientID %>").val(),
                            paymentStatusId: $("#<%= FilterPaymentStatus.ClientID %>").val(),
                            shippingMethodId: $("#<%= FilterShippingMethod.ClientID %>").val(),
                            fromDate: $("#filterFrom").val(),
                            toDate: $("#filterTo").val()
                        });
                    },
                    dataFilter: function (data) {
                        try {
                            var parsed = JSON.parse(data);
                            return JSON.stringify(parsed.d ? parsed.d : parsed);
                        } catch (e) {
                            return data;
                        }
                    },
                    dataSrc: "data"
                },
                columns: [
                    { data: "OrderCode" },
                    { data: "CustomerName" },
                    { data: "Phone" },
                    { data: "CreatedAt" },
                    { data: "PaymentStatusHtml", orderable: false, searchable: false },
                    { data: "OrderStatusHtml", orderable: false, searchable: false },
                    { data: "TotalText" },
                    { data: "ActionsHtml", orderable: false, searchable: false }
                ],
                columnDefs: [
                    { targets: [7, 6], className: "text-end", render: function (data) { return data; } },
                    { targets: [4, 5], render: function (data) { return data; } }
                ],
                searching: false,
                lengthChange: false,
                language: {
                    info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                    infoEmpty: "Không có dữ liệu",
                    infoFiltered: "(lọc từ _MAX_ mục)",
                    zeroRecords: "Không tìm thấy dữ liệu phù hợp",
                    paginate: {
                        first: "&laquo;",
                        last: "&raquo;",
                        next: "&rsaquo;",
                        previous: "&lsaquo;"
                    }
                }
            });

            $("#applyFilters").on("click", function () {
                table.ajax.reload();
            });

            $("#resetFilters").on("click", function () {
                $("#filterCode").val("");
                $("#filterCustomer").val("");
                $("#filterPhone").val("");
                $("#filterFrom").val("");
                $("#filterTo").val("");
                $("#<%= FilterOrderStatus.ClientID %>").val("");
                $("#<%= FilterPaymentStatus.ClientID %>").val("");
                $("#<%= FilterShippingMethod.ClientID %>").val("");
                table.ajax.reload();
            });
        })(jQuery);
    </script>
</asp:Content>