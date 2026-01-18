<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminSellersDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Nhà bán hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Nhà bán hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý nhà bán hàng trong hệ thống.
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item active" aria-current="page">Nhà bán hàng</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <div class="admin-filters mb-3">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Từ khóa</label>
                    <input type="text" id="filterKeyword" class="form-control" placeholder="Tên, email, số điện thoại, shop" />
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
                    <label class="form-label">Có shop</label>
                    <select id="filterHasShop" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="1">Có</option>
                        <option value="0">Không</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái shop</label>
                    <select id="filterShopStatus" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="Active">Hoạt động</option>
                        <option value="Pending">Chờ duyệt</option>
                        <option value="Inactive">Tạm dừng</option>
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
            <h6 class="mb-0 section-title">Danh sách nhà bán hàng</h6>
        </div>
        <div class="table-responsive">
            <table id="sellerTable" class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Tên đăng nhập</th>
                        <th>Shop</th>
                        <th>Số điện thoại</th>
                        <th>Đánh giá</th>
                        <th>Tổng đơn</th>
                        <th>Doanh thu</th>
                        <th>Trạng thái shop</th>
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

            var table = $("#sellerTable").DataTable({
                pageLength: 25,
                order: [[8, "desc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "default.aspx/GetSellers",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: function (d) {
                        return JSON.stringify({
                            draw: d.draw,
                            start: d.start,
                            length: d.length,
                            search: d.search ? d.search.value : "",
                            orderColumn: d.order && d.order.length ? d.order[0].column : 8,
                            orderDir: d.order && d.order.length ? d.order[0].dir : "desc",
                            keyword: $("#filterKeyword").val(),
                            status: $("#filterStatus").val(),
                            hasShop: $("#filterHasShop").val(),
                            shopStatus: $("#filterShopStatus").val(),
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
                    { data: "ShopLabel" },
                    { data: "Phone" },
                    { data: "RatingText" },
                    { data: "TotalOrdersText" },
                    { data: "TotalRevenueText" },
                    { data: "ShopStatusHtml", orderable: false, searchable: false },
                    { data: "StatusHtml", orderable: false, searchable: false },
                    { data: "CreatedAt" },
                    { data: "ActionsHtml", orderable: false, searchable: false }
                ],
                columnDefs: [
                    { targets: [9], className: "text-end", width: "160px", render: function (data) { return data; } },
                    { targets: [6, 7], render: function (data) { return data; } }
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
                $("#filterHasShop").val("");
                $("#filterShopStatus").val("");
                $("#filterFrom").val("");
                $("#filterTo").val("");
                table.ajax.reload();
            });

            $(document).on("click", ".js-toggle-seller", function () {
                var id = $(this).data("id");
                var label = $(this).data("label");
                if (!id) {
                    return;
                }
                if (!confirm(label + " nhà bán hàng này?")) {
                    return;
                }

                $.ajax({
                    url: "default.aspx/ToggleSellerStatus",
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
