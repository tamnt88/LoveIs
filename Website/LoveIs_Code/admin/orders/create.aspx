<%@ Page EnableEventValidation="false" Language="C#" AutoEventWireup="true" CodeFile="create.aspx.cs" Inherits="AdminOrdersCreate" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Tạo đơn hàng
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Tạo đơn hàng
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Tạo đơn giúp khách hàng và tự động gửi thông báo
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item"><a href="/admin/orders/default.aspx">Đơn hàng</a></li>
    <li class="breadcrumb-item active" aria-current="page">Tạo mới</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="row g-3">
            <div class="col-lg-7">
                <div class="card-kpi p-3 h-100">
                    <h6 class="section-title mb-3">Thông tin khách hàng</h6>
                    <div class="row g-2">
                        <div class="col-md-6">
                            <label class="form-label">Họ tên</label>
                            <asp:TextBox ID="CustomerNameInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ</label>
                            <asp:TextBox ID="AddressInput" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tỉnh</label>
                            <asp:DropDownList ID="ProvinceInput" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phường</label>
                            <asp:DropDownList ID="WardInput" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-12">
                            <label class="form-label">Ghi chú</label>
                            <asp:TextBox ID="NoteInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                        </div>
                    </div>
                    <div class="card-kpi p-3 mt-4">
                        <h6 class="section-title mb-3">Hóa đơn (tùy chỉnh)</h6>
                        <div class="form-check mb-3">
                            <asp:CheckBox ID="InvoiceCheckBox" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label" for="MainContent_InvoiceCheckBox">Xuất hóa đơn công ty</label>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên công ty</label>
                                <asp:TextBox ID="InvoiceCompanyInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mã số thuế</label>
                                <asp:TextBox ID="InvoiceTaxInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email nhận hóa đơn</label>
                                <asp:TextBox ID="InvoiceEmailInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Xuất hóa đơn công ty</label>
                                <asp:TextBox ID="InvoiceAddressInput" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </div>

                    <h6 class="section-title mb-3 mt-4">Sản phẩm</h6>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle mb-0" id="order-items-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm/biến thể</th>
                                    <th class="text-center" style="width:120px;">Số lượng</th>
                                    <th class="text-end" style="width:80px;"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <select class="form-select order-variant-select" name="variantId">
                                            <option value="">-- Chọn biến thể --</option>
                                            <asp:Repeater ID="VariantRepeater" runat="server">
                                                <ItemTemplate>
                                                    <option value="<%# Eval("Id") %>" data-price="<%# Eval("PriceText") %>"><%# Eval("Label") %></option>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </select>
                                    </td>
                                    <td class="text-center">
                                        <input type="number" class="form-control text-center" name="quantity" value="1" min="1" />
                                    </td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-sm btn-outline-danger remove-row"><i class="fa-solid fa-trash"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <button type="button" class="btn btn-outline-secondary btn-with-icon mt-2" id="add-row-btn">
                        <i class="fa-solid fa-plus"></i> Thêm sản phẩm
                    </button>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card-kpi p-3 h-100">
                    <h6 class="section-title mb-3">Thanh toán & trạng thái</h6>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái đơn</label>
                        <asp:DropDownList ID="OrderStatusInput" runat="server" CssClass="form-select" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái thanh toán</label>
                        <asp:DropDownList ID="PaymentStatusInput" runat="server" CssClass="form-select" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phương thức thanh toán</label>
                        <asp:DropDownList ID="PaymentMethodInput" runat="server" CssClass="form-select" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phương thức vận chuyển</label>
                        <asp:DropDownList ID="ShippingMethodInput" runat="server" CssClass="form-select" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phí vận chuyển</label>
                        <asp:TextBox ID="ShippingFeeInput" runat="server" CssClass="form-control" Text="0" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Số tiền cần thanh toán</label>
                        <asp:TextBox ID="PaymentTotalInput" runat="server" CssClass="form-control" ReadOnly="true" Text="0" />
                    </div>

                    <asp:Button ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" Text="Tạo đơn hàng" OnClick="SaveButton_Click" />
                    <a href="/admin/orders/default.aspx" class="btn btn-outline-secondary btn-with-icon ms-2">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/admin/assets/vendor/select2/select2.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/admin/assets/vendor/select2/select2.min.js"></script>
    <script>
        (function () {
            var table = document.getElementById("order-items-table");
            var addButton = document.getElementById("add-row-btn");
            var provinceSelect = document.getElementById("<%= ProvinceInput.ClientID %>");
            var wardSelect = document.getElementById("<%= WardInput.ClientID %>");
            var shippingFeeInput = document.getElementById("<%= ShippingFeeInput.ClientID %>");
            var paymentTotalInput = document.getElementById("<%= PaymentTotalInput.ClientID %>");

            if (!table || !addButton) {
                return;
            }

            var templateRow = table.querySelector("tbody tr").cloneNode(true);

            function initSelect2(select) {
                if (window.jQuery && jQuery.fn.select2) {
                    jQuery(select).select2({ width: "100%" });
                }
            }

            function bindRemoveButton(row) {
                var button = row.querySelector(".remove-row");
                if (!button) {
                    return;
                }
                button.addEventListener("click", function () {
                    var rows = table.querySelectorAll("tbody tr");
                    if (rows.length <= 1) {
                        return;
                    }
                    row.remove();
                    updateTotal();
                });
            }

            function parseNumber(value) {
                if (!value) {
                    return 0;
                }
                var cleaned = value.toString().replace(/,/g, "").replace(/\s/g, "");
                var number = parseFloat(cleaned);
                return isNaN(number) ? 0 : number;
            }

            function formatNumber(value) {
                if (typeof value !== "number" || isNaN(value)) {
                    return "0";
                }
                return value.toLocaleString("vi-VN");
            }

            function updateTotal() {
                if (!paymentTotalInput) {
                    return;
                }

                var total = 0;
                var rows = table.querySelectorAll("tbody tr");
                rows.forEach(function (row) {
                    var select = row.querySelector("select");
                    var qtyInput = row.querySelector("input[name='quantity']");
                    var qty = qtyInput ? parseInt(qtyInput.value, 10) || 0 : 0;
                    var price = 0;
                    if (select) {
                        var option = select.options[select.selectedIndex];
                        if (option) {
                            price = parseNumber(option.getAttribute("data-price"));
                        }
                    }
                    total += price * qty;
                });

                total += parseNumber(shippingFeeInput ? shippingFeeInput.value : 0);
                paymentTotalInput.value = formatNumber(total) + " đ";
            }

            function resetWardOptions() {
                if (!wardSelect) {
                    return;
                }
                wardSelect.innerHTML = "";
                var option = document.createElement("option");
                option.value = "";
                option.textContent = "-- Chọn phường --";
                wardSelect.appendChild(option);
            }

            function loadWards(provinceId) {
                if (!wardSelect) {
                    return;
                }
                resetWardOptions();
                if (!provinceId) {
                    return;
                }

                fetch("create.aspx/GetWards", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json; charset=utf-8"
                    },
                    body: JSON.stringify({ provinceId: parseInt(provinceId, 10) })
                })
                    .then(function (response) { return response.json(); })
                    .then(function (data) {
                        var items = data && data.d ? data.d : [];
                        items.forEach(function (item) {
                            var option = document.createElement("option");
                            option.value = item.Id;
                            option.textContent = item.Name;
                            wardSelect.appendChild(option);
                        });
                    })
                    .catch(function () {
                        resetWardOptions();
                    });
            }

            addButton.addEventListener("click", function () {
                var body = table.querySelector("tbody");
                if (!body) {
                    return;
                }

                var newRow = templateRow.cloneNode(true);
                var select = newRow.querySelector("select");
                if (select) {
                    select.value = "";
                }
                var qty = newRow.querySelector("input[name='quantity']");
                if (qty) {
                    qty.value = "1";
                }

                body.appendChild(newRow);
                bindRemoveButton(newRow);
                if (select) {
                    initSelect2(select);
                }
                updateTotal();
            });

            var firstSelect = table.querySelector("tbody tr select");
            if (firstSelect) {
                initSelect2(firstSelect);
            }

            bindRemoveButton(table.querySelector("tbody tr"));

            table.addEventListener("change", function (event) {
                if (event.target.matches("select") || event.target.matches("input[name='quantity']")) {
                    updateTotal();
                }
            });

            table.addEventListener("input", function (event) {
                if (event.target.matches("input[name='quantity']")) {
                    updateTotal();
                }
            });

            if (shippingFeeInput) {
                shippingFeeInput.addEventListener("input", updateTotal);
                shippingFeeInput.addEventListener("change", updateTotal);
            }

            if (provinceSelect) {
                provinceSelect.addEventListener("change", function () {
                    loadWards(provinceSelect.value);
                });
            }

            updateTotal();
        })();
    </script>
</asp:Content>
