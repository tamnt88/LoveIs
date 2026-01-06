<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminProductAttributesDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Quản lý thuộc tính
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Quản lý thuộc tính
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý thuộc tính biến thể sản phẩm
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
    <li class="breadcrumb-item active" aria-current="page">Thuộc tính</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <div class="admin-filters mb-3">
            <div class="row g-2">
                <div class="col-md-4">
                    <label class="form-label">Tên thuộc tính</label>
                    <input type="text" id="filterName" class="form-control" placeholder="Nhập tên thuộc tính" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Trạng thái</label>
                    <select id="filterStatus" class="form-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="1">Hiển thị</option>
                        <option value="0">Ẩn</option>
                    </select>
                </div>
                <div class="col-md-5 d-flex align-items-end gap-2">
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
            <h6 class="mb-0 section-title">Danh sách thuộc tính</h6>
            <a href="/admin/products/attributes/edit.aspx" class="btn btn-primary btn-with-icon">
                <i class="fa-solid fa-plus"></i> Thêm thuộc tính
            </a>
        </div>
        <asp:Label ID="ListMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="table-responsive">
            <table id="attributeTable" class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Thuộc tính</th>
                        <th>Số giá trị</th>
                        <th>Thứ tự</th>
                        <th>Trạng thái</th>
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

            var table = $("#attributeTable").DataTable({
                pageLength: 25,
                order: [[2, "asc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "default.aspx/GetAttributes",
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
                            orderDir: d.order && d.order.length ? d.order[0].dir : "asc",
                            name: $("#filterName").val(),
                            status: $("#filterStatus").val()
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
                    { data: "AttributeName" },
                    { data: "ValueCount" },
                    { data: "SortOrder" },
                    { data: "StatusHtml", orderable: false, searchable: false },
                    { data: "ActionsHtml", orderable: false, searchable: false }
                ],
                columnDefs: [
                    { targets: [4], className: "text-end", render: function (data) { return data; } },
                    { targets: [3], render: function (data) { return data; } }
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

            window.deleteAttribute = function (id) {
                if (!confirm("Xóa thuộc tính này?")) {
                    return;
                }

                $.ajax({
                    url: "default.aspx/DeleteAttribute",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    success: function (res) {
                        var result = res && res.d ? res.d : null;
                        var messageEl = $("#<%= ListMessage.ClientID %>");
                        if (result && result.Success) {
                            messageEl.removeClass("text-danger").addClass("text-success").text(result.Message);
                            table.ajax.reload(null, false);
                        } else {
                            messageEl.removeClass("text-success").addClass("text-danger").text(result ? result.Message : "Không thể xóa.");
                        }
                    },
                    error: function () {
                        $("#<%= ListMessage.ClientID %>").removeClass("text-success").addClass("text-danger").text("Lỗi hệ thống, vui lòng thử lại.");
                    }
                });
            };

            $("#applyFilters").on("click", function () {
                table.ajax.reload();
            });

            $("#resetFilters").on("click", function () {
                $("#filterName").val("");
                $("#filterStatus").val("");
                table.ajax.reload();
            });
        })(jQuery);
    </script>
</asp:Content>

