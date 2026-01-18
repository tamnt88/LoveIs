<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminSellersEdit" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Nhà bán hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Cập nhật nhà bán hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Xem và cập nhật thông tin nhà bán hàng.
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="/admin/sellers/default.aspx">Nhà bán hàng</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="SellerId" runat="server" />
    <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="tab-info" data-bs-toggle="tab" data-bs-target="#tab-info-pane" type="button" role="tab">
                <i class="fa-solid fa-user me-2"></i>Thông tin
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-shop" data-bs-toggle="tab" data-bs-target="#tab-shop-pane" type="button" role="tab">
                <i class="fa-solid fa-store me-2"></i>Shop
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-product" data-bs-toggle="tab" data-bs-target="#tab-product-pane" type="button" role="tab">
                <i class="fa-solid fa-box me-2"></i>Sản phẩm
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-order" data-bs-toggle="tab" data-bs-target="#tab-order-pane" type="button" role="tab">
                <i class="fa-solid fa-receipt me-2"></i>Đơn hàng
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-review" data-bs-toggle="tab" data-bs-target="#tab-review-pane" type="button" role="tab">
                <i class="fa-solid fa-star me-2"></i>Đánh giá
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-password" data-bs-toggle="tab" data-bs-target="#tab-password-pane" type="button" role="tab">
                <i class="fa-solid fa-key me-2"></i>Đổi mật khẩu
            </button>
        </li>
    </ul>
    <div class="tab-content pt-3">
        <div class="tab-pane fade show active" id="tab-info-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thông tin cơ bản</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <div class="row g-2 mb-3">
                    <div class="col-lg-3">
                        <label class="form-label">ID nhà bán hàng</label>
                        <asp:TextBox ID="SellerIdInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-9">
                        <label class="form-label">Tên đăng nhập</label>
                        <asp:TextBox ID="UsernameInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-lg-6">
                        <label class="form-label">Tên hiển thị</label>
                        <asp:TextBox ID="DisplayNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-lg-6">
                        <label class="form-label">Email</label>
                        <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-lg-6">
                        <label class="form-label">Số điện thoại</label>
                        <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-lg-3">
                        <label class="form-label">Ngày tạo</label>
                        <asp:TextBox ID="CreatedAtInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-3">
                        <label class="form-label">Lần đăng nhập</label>
                        <asp:TextBox ID="LastLoginInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-lg-6">
                        <label class="form-label">Khóa tới</label>
                        <asp:TextBox ID="LockedUntilInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="<%= StatusInput.ClientID %>">Đang hoạt động</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <a class="btn btn-outline-secondary btn-with-icon" href="/admin/sellers/default.aspx">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-shop-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Shop liên quan</h6>
                <div class="table-responsive">
                    <table id="shopTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Tên shop</th>
                                <th>Trạng thái</th>
                                <th>Đánh giá</th>
                                <th>Đơn hoàn thành</th>
                                <th>Theo dõi</th>
                                <th>Ngày tạo</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-product-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Sản phẩm</h6>
                <div class="table-responsive">
                    <table id="productTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Shop</th>
                                <th>Đánh giá</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-order-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Đơn hàng</h6>
                <div class="table-responsive">
                    <table id="orderTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Shop</th>
                                <th>Trạng thái</th>
                                <th>Thanh toán</th>
                                <th>Tổng tiền</th>
                                <th>Ngày tạo</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-review-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Đánh giá shop</h6>
                <div class="table-responsive">
                    <table id="reviewTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Shop</th>
                                <th>Điểm</th>
                                <th>Nội dung</th>
                                <th>Khách hàng</th>
                                <th>Ngày tạo</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-password-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Đổi mật khẩu nhanh</h6>
                <div class="row g-2 mb-3">
                    <div class="col-lg-6">
                        <label class="form-label">Mật khẩu mới</label>
                        <asp:TextBox ID="NewPasswordInput" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="col-lg-6">
                        <label class="form-label">Xác nhận mật khẩu</label>
                        <asp:TextBox ID="ConfirmPasswordInput" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    </div>
                </div>
                <asp:LinkButton ID="ChangePasswordButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ChangePasswordButton_Click">
                    <i class="fa-solid fa-key"></i> Đổi mật khẩu
                </asp:LinkButton>
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

            var sellerId = $("#<%= SellerId.ClientID %>").val();
            var shopLoaded = false;
            var productLoaded = false;
            var orderLoaded = false;
            var reviewLoaded = false;

            function initShopTable() {
                if (shopLoaded) return;
                shopLoaded = true;
                $("#shopTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetSellerShops",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                sellerId: sellerId
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
                        { data: "ShopName" },
                        { data: "StatusHtml", orderable: false, searchable: false },
                        { data: "RatingText" },
                        { data: "CompletedOrders" },
                        { data: "FollowerCount" },
                        { data: "CreatedAt" }
                    ],
                    columnDefs: [
                        { targets: [1], width: "16%", render: function (data) { return data; } }
                    ],
                    searching: false,
                    lengthChange: false,
                    ordering: false,
                    language: {
                        info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                        infoEmpty: "Không có dữ liệu",
                        zeroRecords: "Không có dữ liệu"
                    }
                });
            }

            function initProductTable() {
                if (productLoaded) return;
                productLoaded = true;
                $("#productTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetSellerProducts",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                sellerId: sellerId
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
                        { data: "ProductName" },
                        { data: "ShopName" },
                        { data: "RatingText" },
                        { data: "StockText" },
                        { data: "StatusHtml", orderable: false, searchable: false },
                        { data: "CreatedAt" },
                        { data: "ActionsHtml", orderable: false, searchable: false }
                    ],
                    columnDefs: [
                        { targets: [4], width: "14%", render: function (data) { return data; } },
                        { targets: [6], width: "120px", className: "text-end", render: function (data) { return data; } }
                    ],
                    searching: false,
                    lengthChange: false,
                    ordering: false,
                    language: {
                        info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                        infoEmpty: "Không có dữ liệu",
                        zeroRecords: "Không có dữ liệu"
                    }
                });
            }

            function initOrderTable() {
                if (orderLoaded) return;
                orderLoaded = true;
                $("#orderTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetSellerOrders",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                sellerId: sellerId
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
                        { data: "ShopName" },
                        { data: "OrderStatusHtml", orderable: false, searchable: false },
                        { data: "PaymentStatusHtml", orderable: false, searchable: false },
                        { data: "TotalText" },
                        { data: "CreatedAt" },
                        { data: "ActionsHtml", orderable: false, searchable: false }
                    ],
                    columnDefs: [
                        { targets: [2, 3], width: "14%", render: function (data) { return data; } },
                        { targets: [6], width: "120px", className: "text-end", render: function (data) { return data; } }
                    ],
                    searching: false,
                    lengthChange: false,
                    ordering: false,
                    language: {
                        info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                        infoEmpty: "Không có dữ liệu",
                        zeroRecords: "Không có dữ liệu"
                    }
                });
            }

            function initReviewTable() {
                if (reviewLoaded) return;
                reviewLoaded = true;
                $("#reviewTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetSellerReviews",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                sellerId: sellerId
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
                        { data: "ShopName" },
                        { data: "RatingText" },
                        { data: "Content" },
                        { data: "CustomerName" },
                        { data: "CreatedAt" }
                    ],
                    searching: false,
                    lengthChange: false,
                    ordering: false,
                    language: {
                        info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                        infoEmpty: "Không có dữ liệu",
                        zeroRecords: "Không có dữ liệu"
                    }
                });
            }

            $("button[data-bs-toggle=\"tab\"]").on("shown.bs.tab", function (event) {
                var target = $(event.target).data("bs-target");
                if (target === "#tab-shop-pane") {
                    initShopTable();
                } else if (target === "#tab-product-pane") {
                    initProductTable();
                } else if (target === "#tab-order-pane") {
                    initOrderTable();
                } else if (target === "#tab-review-pane") {
                    initReviewTable();
                }
            });
        })(jQuery);
    </script>
</asp:Content>
