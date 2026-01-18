<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit.aspx.cs" Inherits="AdminCustomersEdit" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Khách hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Cập nhật khách hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Xem và cập nhật thông tin khách hàng.
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="/admin/customers/default.aspx">Khách hàng</a></li>
    <li class="breadcrumb-item active" aria-current="page">Cập nhật</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="CustomerId" runat="server" />
    <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="tab-info" data-bs-toggle="tab" data-bs-target="#tab-info-pane" type="button" role="tab"><i class="fa-solid fa-user me-2"></i>Thông tin</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-address" data-bs-toggle="tab" data-bs-target="#tab-address-pane" type="button" role="tab"><i class="fa-solid fa-location-dot me-2"></i>Địa chỉ</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-bank" data-bs-toggle="tab" data-bs-target="#tab-bank-pane" type="button" role="tab"><i class="fa-solid fa-building-columns me-2"></i>Ngân hàng</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-wishlist" data-bs-toggle="tab" data-bs-target="#tab-wishlist-pane" type="button" role="tab"><i class="fa-solid fa-heart me-2"></i>Yêu thích</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-orders" data-bs-toggle="tab" data-bs-target="#tab-orders-pane" type="button" role="tab"><i class="fa-solid fa-receipt me-2"></i>Đơn hàng</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-password" data-bs-toggle="tab" data-bs-target="#tab-password-pane" type="button" role="tab"><i class="fa-solid fa-key me-2"></i>Đổi mật khẩu</button>
        </li>
    </ul>
    <div class="tab-content pt-3">
        <div class="tab-pane fade show active" id="tab-info-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thông tin cơ bản</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <div class="row g-2 mb-3">
                    <div class="col-lg-3">
                        <label class="form-label">ID khách hàng</label>
                        <asp:TextBox ID="CustomerIdInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-3">
                        <label class="form-label">Seller ID</label>
                        <asp:TextBox ID="SellerIdInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-6">
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
                        <label class="form-label">Giới tính</label>
                        <asp:DropDownList ID="GenderInput" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Không rõ" Value="" />
                            <asp:ListItem Text="Nam" Value="1" />
                            <asp:ListItem Text="Nữ" Value="2" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-lg-3">
                        <label class="form-label">Ngày sinh</label>
                        <asp:TextBox ID="BirthDateInput" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-lg-4">
                        <label class="form-label">Ngày tạo</label>
                        <asp:TextBox ID="CreatedAtInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label">Lần đăng nhập</label>
                        <asp:TextBox ID="LastLoginInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label">Khóa tới</label>
                        <asp:TextBox ID="LockedUntilInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-lg-6">
                        <label class="form-label">Token xác minh</label>
                        <asp:TextBox ID="EmailVerifyTokenInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-lg-6">
                        <label class="form-label">Hết hạn token</label>
                        <asp:TextBox ID="EmailVerifyExpiresInput" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
                <div class="form-check mb-2">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="<%= StatusInput.ClientID %>">Đang hoạt động</label>
                </div>
                <div class="form-check mb-2">
                    <asp:CheckBox ID="EmailVerifiedInput" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="<%= EmailVerifiedInput.ClientID %>">Đã xác minh email</label>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="IsSellerInput" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label" for="<%= IsSellerInput.ClientID %>">Là nhà bán hàng</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <a class="btn btn-outline-secondary btn-with-icon" href="/admin/customers/default.aspx">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-address-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Địa chỉ</h6>
                <div class="table-responsive">
                    <table id="addressTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ</th>
                                <th>Mặc định</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-bank-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Ngân hàng</h6>
                <div class="table-responsive">
                    <table id="bankTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Ngân hàng</th>
                                <th>Chủ tài khoản</th>
                                <th>Số tài khoản</th>
                                <th>Chi nhánh</th>
                                <th>Mặc định</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-wishlist-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Yêu thích</h6>
                <div class="table-responsive">
                    <table id="wishlistTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Sản phẩm</th>
                                <th>SKU</th>
                                <th>Danh mục</th>
                                <th>Cửa hàng</th>
                                <th>Thương hiệu</th>
                                <th>Xuất xứ</th>
                                <th>Giá từ</th>
                                <th>Tồn kho</th>
                                <th>Ngày thêm</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="tab-orders-pane" role="tabpanel">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Đơn hàng gần đây</h6>
                <div class="table-responsive">
                    <table id="orderTable" class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Ngày tạo</th>
                                <th>Thanh toán</th>
                                <th>Vận chuyển</th>
                                <th>Trạng thái</th>
                                <th>Tổng tiền</th>
                                <th class="text-end">Thao tác</th>
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

            var customerId = $("#<%= CustomerId.ClientID %>").val();
            var addressLoaded = false;
            var bankLoaded = false;
            var wishlistLoaded = false;
            var orderLoaded = false;

            function initAddressTable() {
                if (addressLoaded) return;
                addressLoaded = true;
                $("#addressTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetCustomerAddresses",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                customerId: customerId
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
                        { data: "FullName" },
                        { data: "Phone" },
                        { data: "AddressText" },
                        { data: "IsDefaultText" }
                    ],
                    columnDefs: [
                        { targets: 0, width: "22%" },
                        { targets: 1, width: "18%" },
                        { targets: 2, width: "45%" },
                        { targets: 3, width: "15%" }
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

            function initBankTable() {
                if (bankLoaded) return;
                bankLoaded = true;
                $("#bankTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetCustomerBanks",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                customerId: customerId
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
                        { data: "BankName" },
                        { data: "AccountName" },
                        { data: "AccountNumber" },
                        { data: "Branch" },
                        { data: "IsDefaultText" }
                    ],
                    columnDefs: [
                        { targets: 0, width: "22%" },
                        { targets: 1, width: "22%" },
                        { targets: 2, width: "20%" },
                        { targets: 3, width: "22%" },
                        { targets: 4, width: "14%" }
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

            function initWishlistTable() {
                if (wishlistLoaded) return;
                wishlistLoaded = true;
                $("#wishlistTable").DataTable({
                    pageLength: 10,
                    serverSide: true,
                    processing: true,
                    autoWidth: false,
                    ajax: {
                        url: "edit.aspx/GetCustomerWishlist",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                customerId: customerId
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
                        { data: "ImageHtml", orderable: false, searchable: false },
                        { data: "ProductName" },
                        { data: "Sku" },
                        { data: "CategoryName" },
                        { data: "ShopName" },
                        { data: "BrandName" },
                        { data: "OriginName" },
                        { data: "MinPrice" },
                        { data: "StockQty" },
                        { data: "CreatedAt" },
                        { data: "ActionsHtml", orderable: false, searchable: false }
                    ],
                    columnDefs: [
                        { targets: [10], width: "140px", className: "text-end", render: function (data) { return data; } },
                        { targets: [0], width: "60px", render: function (data) { return data; } }
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
                        url: "edit.aspx/GetCustomerOrders",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (d) {
                            return JSON.stringify({
                                draw: d.draw,
                                start: d.start,
                                length: d.length,
                                customerId: customerId
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
                        { data: "CreatedAt" },
                        { data: "PaymentStatusHtml", orderable: false, searchable: false },
                        { data: "ShippingStatusHtml", orderable: false, searchable: false },
                        { data: "OrderStatusHtml", orderable: false, searchable: false },
                        { data: "TotalText" },
                        { data: "ActionsHtml", orderable: false, searchable: false }
                    ],
                    columnDefs: [
                        { targets: 0, width: "18%" },
                        { targets: 1, width: "18%" },
                        { targets: 2, width: "14%", render: function (data) { return data; } },
                        { targets: 3, width: "14%", render: function (data) { return data; } },
                        { targets: 4, width: "16%", render: function (data) { return data; } },
                        { targets: 5, width: "12%" },
                        { targets: [6], width: "8%", className: "text-end", render: function (data) { return data; } }
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

            initAddressTable();

            $("button[data-bs-toggle=\"tab\"]").on("shown.bs.tab", function (event) {
                var target = $(event.target).data("bs-target");
                if (target === "#tab-address-pane") {
                    initAddressTable();
                } else if (target === "#tab-bank-pane") {
                    initBankTable();
                } else if (target === "#tab-wishlist-pane") {
                    initWishlistTable();
                } else if (target === "#tab-orders-pane") {
                    initOrderTable();
                }
            });
        })(jQuery);
    </script>
</asp:Content>
