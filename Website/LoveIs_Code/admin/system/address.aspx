<%@ Page Language="C#" AutoEventWireup="true" CodeFile="address.aspx.cs" Inherits="AdminSystemAddress" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Quản lý tỉnh/phường
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Quản lý tỉnh/phường
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Danh sách + tìm kiếm + thêm/sửa/xóa tỉnh và phường
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Tỉnh/phường</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="ActiveTabInput" runat="server" />
    <ul class="nav nav-tabs mb-3" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link <%= ActiveTab == "province" ? "active" : "" %>" id="tab-province" data-bs-toggle="tab" data-bs-target="#pane-province" type="button" role="tab">
                Tỉnh
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link <%= ActiveTab == "ward" ? "active" : "" %>" id="tab-ward" data-bs-toggle="tab" data-bs-target="#pane-ward" type="button" role="tab">
                Phường
            </button>
        </li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade <%= ActiveTab == "province" ? "show active" : "" %>" id="pane-province" role="tabpanel">
            <div class="card-kpi p-3 bg-white mb-3">
                <asp:Label ID="ProvinceMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="ProvinceIdInput" runat="server" />
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Tên tỉnh</label>
                        <asp:TextBox ID="ProvinceNameInput" runat="server" CssClass="form-control" placeholder="Nhập tên tỉnh"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Thứ tự</label>
                        <asp:TextBox ID="ProvinceSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <div class="form-check">
                            <asp:CheckBox ID="ProvinceStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label" for="ProvinceStatusInput">Hiển thị</label>
                        </div>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="ProvinceSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon w-100" Text="Lưu tỉnh" OnClick="ProvinceSaveButton_Click" />
                    </div>
                </div>
            </div>

            <div class="card-kpi p-3 bg-white">
                <div class="admin-filters mb-3">
                    <div class="row g-2">
                        <div class="col-md-4">
                            <label class="form-label">Tên tỉnh</label>
                            <input type="text" id="provinceFilterName" class="form-control" placeholder="Nhập tên tỉnh" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select id="provinceFilterStatus" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="1">Hiển thị</option>
                                <option value="0">Ẩn</option>
                            </select>
                        </div>
                        <div class="col-md-5 d-flex align-items-end gap-2">
                            <button type="button" class="btn btn-outline-dark btn-with-icon" id="applyProvinceFilters">
                                <i class="fa-solid fa-filter"></i> Lọc
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-with-icon" id="resetProvinceFilters">
                                <i class="fa-solid fa-rotate-left"></i> Làm mới
                            </button>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table id="provinceTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Tỉnh</th>
                                <th>Thứ tự</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="tab-pane fade <%= ActiveTab == "ward" ? "show active" : "" %>" id="pane-ward" role="tabpanel">
            <div class="card-kpi p-3 bg-white mb-3">
                <asp:Label ID="WardMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="WardIdInput" runat="server" />
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Tỉnh</label>
                        <asp:DropDownList ID="WardProvinceInput" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Tên phường</label>
                        <asp:TextBox ID="WardNameInput" runat="server" CssClass="form-control" placeholder="Nhập tên phường"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Thứ tự</label>
                        <asp:TextBox ID="WardSortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <div class="form-check">
                            <asp:CheckBox ID="WardStatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label" for="WardStatusInput">Hiển thị</label>
                        </div>
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <asp:Button ID="WardSaveButton" runat="server" CssClass="btn btn-primary btn-with-icon w-100" Text="Lưu" OnClick="WardSaveButton_Click" />
                    </div>
                </div>
            </div>

            <div class="card-kpi p-3 bg-white">
                <div class="admin-filters mb-3">
                    <div class="row g-2">
                        <div class="col-md-4">
                            <label class="form-label">Tên phường</label>
                            <input type="text" id="wardFilterName" class="form-control" placeholder="Nhập tên phường" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Tỉnh</label>
                            <select id="wardFilterProvince" class="form-select">
                                <option value="">Tất cả tỉnh</option>
                                <asp:Repeater ID="WardProvinceFilterRepeater" runat="server">
                                    <ItemTemplate>
                                        <option value="<%# Eval("Id") %>"><%# Eval("ProvinceName") %></option>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select id="wardFilterStatus" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="1">Hiển thị</option>
                                <option value="0">Ẩn</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end gap-2">
                            <button type="button" class="btn btn-outline-dark btn-with-icon" id="applyWardFilters">
                                <i class="fa-solid fa-filter"></i>
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-with-icon" id="resetWardFilters">
                                <i class="fa-solid fa-rotate-left"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table id="wardTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Phường</th>
                                <th>Tỉnh</th>
                                <th>Thứ tự</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
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

            var provinceTable = $("#provinceTable").DataTable({
                pageLength: 25,
                order: [[1, "asc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "address.aspx/GetProvinces",
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
                            name: $("#provinceFilterName").val(),
                            status: $("#provinceFilterStatus").val()
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
                    { data: "ProvinceName" },
                    { data: "SortOrder" },
                    { data: "StatusHtml", orderable: false, searchable: false },
                    { data: "ActionsHtml", orderable: false, searchable: false }
                ],
                columnDefs: [
                    { targets: [3], className: "text-end", render: function (data) { return data; } },
                    { targets: [2], render: function (data) { return data; } }
                ],
                searching: false,
                lengthChange: false,
                language: {
                    info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                    infoEmpty: "Không có dữ liệu",
                    infoFiltered: "(lọc từ _MAX_ mục)",
                    zeroRecords: "Không tìm thấy dữ liệu phù hợp",
                    paginate: { first: "&laquo;", last: "&raquo;", next: "&rsaquo;", previous: "&lsaquo;" }
                }
            });

            var wardTable = $("#wardTable").DataTable({
                pageLength: 25,
                order: [[2, "asc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "address.aspx/GetWards",
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
                            name: $("#wardFilterName").val(),
                            provinceId: $("#wardFilterProvince").val(),
                            status: $("#wardFilterStatus").val()
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
                    { data: "WardName" },
                    { data: "ProvinceName" },
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
                    paginate: { first: "&laquo;", last: "&raquo;", next: "&rsaquo;", previous: "&lsaquo;" }
                }
            });

            $("#applyProvinceFilters").on("click", function () {
                provinceTable.ajax.reload();
            });
            $("#resetProvinceFilters").on("click", function () {
                $("#provinceFilterName").val("");
                $("#provinceFilterStatus").val("");
                provinceTable.ajax.reload();
            });

            $("#applyWardFilters").on("click", function () {
                wardTable.ajax.reload();
            });
            $("#resetWardFilters").on("click", function () {
                $("#wardFilterName").val("");
                $("#wardFilterProvince").val("");
                $("#wardFilterStatus").val("");
                wardTable.ajax.reload();
            });

            window.deleteProvince = function (id) {
                if (!confirm("Xóa tỉnh này?")) {
                    return;
                }
                $.ajax({
                    url: "address.aspx/DeleteProvince",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    success: function (res) {
                        var result = res && res.d ? res.d : null;
                        var messageEl = $("#<%= ProvinceMessage.ClientID %>");
                        if (result && result.Success) {
                            messageEl.removeClass("text-danger").addClass("text-success").text(result.Message);
                            provinceTable.ajax.reload(null, false);
                        } else {
                            messageEl.removeClass("text-success").addClass("text-danger").text(result ? result.Message : "Không thể xóa.");
                        }
                    },
                    error: function () {
                        $("#<%= ProvinceMessage.ClientID %>").removeClass("text-success").addClass("text-danger").text("Lỗi hệ thống, vui lòng thử lại.");
                    }
                });
            };

            window.deleteWard = function (id) {
                if (!confirm("Xóa phường này?")) {
                    return;
                }
                $.ajax({
                    url: "address.aspx/DeleteWard",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    success: function (res) {
                        var result = res && res.d ? res.d : null;
                        var messageEl = $("#<%= WardMessage.ClientID %>");
                        if (result && result.Success) {
                            messageEl.removeClass("text-danger").addClass("text-success").text(result.Message);
                            wardTable.ajax.reload(null, false);
                        } else {
                            messageEl.removeClass("text-success").addClass("text-danger").text(result ? result.Message : "Không thể xóa.");
                        }
                    },
                    error: function () {
                        $("#<%= WardMessage.ClientID %>").removeClass("text-success").addClass("text-danger").text("Lỗi hệ thống, vui lòng thử lại.");
                    }
                });
            };
        })(jQuery);
    </script>
</asp:Content>

