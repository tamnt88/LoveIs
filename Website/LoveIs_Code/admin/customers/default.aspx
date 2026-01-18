<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminCustomersDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Khách hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Khách hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý khách hàng trong hệ thống.
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item active" aria-current="page">Khách hàng</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <div class="admin-filters mb-3">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Từ khóa</label>
                    <input type="text" id="filterKeyword" class="form-control" placeholder="Tên, email, số điện thoại" />
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select id="filterStatus" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="1">Đang hoạt động</option>
                        <option value="0">Tạm khóa</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Nhà bán hàng</label>
                    <select id="filterSeller" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="1">Có</option>
                        <option value="0">Không</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Xác minh email</label>
                    <select id="filterEmailVerified" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="1">Đã xác minh</option>
                        <option value="0">Chưa xác minh</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex gap-2 align-items-end">
                    <button type="button" class="btn btn-outline-dark btn-with-icon" id="applyFilters">
                        <i class="fa-solid fa-filter"></i> Lọc
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-with-icon" id="resetFilters">
                        <i class="fa-solid fa-rotate-left"></i> Làm mới
                    </button>
                </div>
            </div>
            <div class="row g-2 align-items-end mt-1">
                <div class="col-md-3">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" id="filterFrom" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" id="filterTo" class="form-control" />
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="mb-0 section-title">Danh sách khách hàng</h6>
        </div>
        <div class="table-responsive">
            <table id="customerTable" class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Tên đăng nhập</th>
                        <th>Tên hiển thị</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Nhà bán hàng</th>
                        <th>Xác minh</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
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

            var table = $("#customerTable").DataTable({
                pageLength: 25,
                order: [[7, "desc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "default.aspx/GetCustomers",
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
                            keyword: $("#filterKeyword").val(),
                            status: $("#filterStatus").val(),
                            isSeller: $("#filterSeller").val(),
                            emailVerified: $("#filterEmailVerified").val(),
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
                    { data: "Username" },
                    { data: "DisplayName" },
                    { data: "Email" },
                    { data: "Phone" },
                    { data: "IsSellerText", orderable: false, searchable: false },
                    { data: "EmailVerifiedHtml", orderable: false, searchable: false },
                    { data: "StatusHtml", orderable: false, searchable: false },
                    { data: "CreatedAt" },
                    { data: "ActionsHtml", orderable: false, searchable: false }
                ],
                columnDefs: [
                    { targets: [8], className: "text-end", width: "140px", render: function (data) { return data; } },
                    { targets: [5, 6], render: function (data) { return data; } }
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
                $("#filterKeyword").val("");
                $("#filterStatus").val("");
                $("#filterSeller").val("");
                $("#filterEmailVerified").val("");
                $("#filterFrom").val("");
                $("#filterTo").val("");
                table.ajax.reload();
            });

            $(document).on("click", ".js-toggle-customer", function () {
                var id = $(this).data("id");
                var label = $(this).data("label");
                if (!id) {
                    return;
                }
                if (!confirm(label + " khách hàng này?")) {
                    return;
                }

                $.ajax({
                    url: "default.aspx/ToggleCustomerStatus",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: JSON.stringify({ id: id })
                }).done(function () {
                    table.ajax.reload(null, false);
                });
            });
        })(jQuery);
    </script>
</asp:Content>
