<%@ Page Language="C#" AutoEventWireup="true" CodeFile="contact-messages.aspx.cs" Inherits="AdminSystemContactMessages" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Tin nhắn liên hệ
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Tin nhắn liên hệ
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý nội dung khách hàng gửi từ trang liên hệ
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="#">Hệ thống</a></li>
    <li class="breadcrumb-item active" aria-current="page">Liên hệ</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="ListMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="table-responsive">
            <table class="table table-striped align-middle" id="contactMessageTable">
                <thead>
                    <tr>
                        <th>Khách hàng</th>
                        <th>Chủ đề</th>
                        <th>Nội dung</th>
                        <th>Thời gian</th>
                        <th></th>
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

            var table = $("#contactMessageTable").DataTable({
                pageLength: 25,
                order: [[3, "desc"]],
                serverSide: true,
                processing: true,
                ajax: {
                    url: "contact-messages.aspx/GetMessages",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: function (d) {
                        return JSON.stringify({
                            draw: d.draw,
                            start: d.start,
                            length: d.length,
                            search: d.search ? d.search.value : "",
                            orderColumn: d.order && d.order.length ? d.order[0].column : 3,
                            orderDir: d.order && d.order.length ? d.order[0].dir : "desc"
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
                    { data: "CustomerHtml", orderable: false },
                    { data: "Subject" },
                    { data: "MessageHtml", orderable: false },
                    { data: "CreatedAt" },
                    { data: "ActionsHtml", orderable: false, searchable: false }
                ],
                columnDefs: [
                    { targets: [4], className: "text-end", render: function (data) { return data; } },
                    { targets: [0, 2], render: function (data) { return data; } }
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

            window.deleteContactMessage = function (id) {
                if (!confirm("Xóa tin nhắn này?")) {
                    return;
                }

                $.ajax({
                    url: "contact-messages.aspx/DeleteMessage",
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
        })(jQuery);
    </script>
</asp:Content>
