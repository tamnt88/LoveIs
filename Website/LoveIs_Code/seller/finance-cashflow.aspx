<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-cashflow.aspx.cs" Inherits="SellerFinanceCashflow" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thu chi người bán</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Thu Chi Người Bán</h2>
                <p>Quản lý thu chi và theo dõi lợi nhuận</p>
            </div>
        </div>

        <div class="finance-toolbar">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select>
                    <option>Tháng này</option>
                </select>
            </div>
            <button class="btn-address-outline" type="button">
                <i class="fa-solid fa-download"></i>
                Xuất Excel
            </button>
        </div>

        <div class="finance-stat-grid">
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-blue"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="finance-stat-label">Tổng Thu</div>
                <div class="finance-stat-value">58.000.000 đ</div>
                <div class="finance-stat-sub">Tháng này</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-red"><i class="fa-solid fa-arrow-trend-down"></i></span>
                <div class="finance-stat-label">Tổng Chi</div>
                <div class="finance-stat-value">12.500.000 đ</div>
                <div class="finance-stat-sub">Tháng này</div>
            </div>
            <div class="finance-profit-card">
                <span class="finance-stat-icon info-green"><i class="fa-solid fa-wallet"></i></span>
                <div class="finance-stat-label">Lợi Nhuận</div>
                <div class="finance-stat-value">45.500.000 đ</div>
                <div class="finance-stat-trend up">+22% so với tháng trước</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-purple"><i class="fa-solid fa-percent"></i></span>
                <div class="finance-stat-label">Tỷ Lệ Lợi Nhuận</div>
                <div class="finance-stat-value">78.4%</div>
                <div class="finance-stat-sub">Rất tốt</div>
            </div>
        </div>

        <div class="finance-chart-grid">
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Thu Chi 6 Tháng</div>
                <div class="finance-chart-placeholder bar-chart dual"></div>
            </div>
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Phân Bổ Chi Phí</div>
                <div class="finance-chart-placeholder pie-chart">
                    <div class="pie-labels">
                        <span>Chi phí quảng cáo 40%</span>
                        <span>Phí dịch vụ 20%</span>
                        <span>Chi phí khác 14%</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="card finance-withdraw-card mt-4">
            <div class="finance-chart-title">Rut tien ve tai khoan</div>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Shop</label>
                    <select id="PayoutShop" class="form-select"></select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Tai khoan ngan hang</label>
                    <select id="PayoutBank" class="form-select"></select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">So tien</label>
                    <input id="PayoutAmount" type="number" min="0" class="form-control" placeholder="Vi du: 200000" />
                </div>
                <div class="col-12">
                    <label class="form-label">Ghi chu</label>
                    <input id="PayoutNote" type="text" class="form-control" placeholder="Ghi chu cho admin" />
                </div>
            </div>
            <div class="mt-3">
                <button id="PayoutSubmit" type="button" class="btn btn-primary btn-with-icon">
                    <i class="fa-solid fa-paper-plane"></i> Gui yeu cau rut tien
                </button>
                <span id="PayoutMessage" class="ms-2 text-danger small"></span>
            </div>
        </div>

        <div class="card finance-withdraw-card mt-4">
            <div class="finance-chart-title">Lich su yeu cau rut tien</div>
            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Shop</th>
                            <th>So tien</th>
                            <th>Ngan hang</th>
                            <th>Trang thai</th>
                            <th>Thoi gian</th>
                        </tr>
                    </thead>
                    <tbody id="PayoutTableBody">
                        <tr>
                            <td colspan="5" class="text-center text-muted">Dang tai du lieu...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        (function () {
            function postJson(url, payload, onDone) {
                if (!window.jQuery) {
                    return;
                }
                $.ajax({
                    type: "POST",
                    url: url,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: JSON.stringify(payload || {}),
                    success: function (res) {
                        onDone(res && res.d ? res.d : res);
                    },
                    error: function () {
                        onDone(null);
                    }
                });
            }

            function renderOptions(el, items, emptyText) {
                el.innerHTML = "";
                if (!items || items.length === 0) {
                    var opt = document.createElement("option");
                    opt.value = "";
                    opt.textContent = emptyText || "Khong co du lieu";
                    el.appendChild(opt);
                    return;
                }
                items.forEach(function (item) {
                    var opt = document.createElement("option");
                    opt.value = item.Id;
                    opt.textContent = item.Name;
                    el.appendChild(opt);
                });
            }

            function loadFormData() {
                postJson("finance-cashflow.aspx/GetPayoutFormData", {}, function (data) {
                    if (!data) {
                        return;
                    }
                    renderOptions(document.getElementById("PayoutShop"), data.Shops, "Khong co shop");
                    renderOptions(document.getElementById("PayoutBank"), data.Banks, "Chua co tai khoan");
                });
            }

            function loadPayouts() {
                postJson("finance-cashflow.aspx/GetPayoutRequests", {}, function (data) {
                    var body = document.getElementById("PayoutTableBody");
                    body.innerHTML = "";
                    if (!data || data.length === 0) {
                        var row = document.createElement("tr");
                        row.innerHTML = "<td colspan='5' class='text-center text-muted'>Chua co yeu cau rut tien.</td>";
                        body.appendChild(row);
                        return;
                    }
                    data.forEach(function (item) {
                        var row = document.createElement("tr");
                        row.innerHTML =
                            "<td>" + item.ShopName + "</td>" +
                            "<td>" + item.AmountText + "</td>" +
                            "<td>" + item.BankName + "</td>" +
                            "<td>" + item.Status + "</td>" +
                            "<td>" + item.RequestedAtText + "</td>";
                        body.appendChild(row);
                    });
                });
            }

            document.getElementById("PayoutSubmit").addEventListener("click", function () {
                var message = document.getElementById("PayoutMessage");
                message.textContent = "";
                message.classList.remove("text-success");
                message.classList.add("text-danger");
                var shopId = parseInt(document.getElementById("PayoutShop").value || "0", 10);
                var bankId = parseInt(document.getElementById("PayoutBank").value || "0", 10);
                var amount = parseFloat(document.getElementById("PayoutAmount").value || "0");
                var note = document.getElementById("PayoutNote").value || "";
                postJson("finance-cashflow.aspx/CreatePayoutRequest", {
                    shopId: shopId,
                    bankAccountId: bankId,
                    amount: amount,
                    note: note
                }, function (res) {
                    if (!res || !res.Success) {
                        message.textContent = res && res.Message ? res.Message : "Khong the tao yeu cau.";
                        return;
                    }
                    message.textContent = res.Message || "Da tao yeu cau.";
                    message.classList.remove("text-danger");
                    message.classList.add("text-success");
                    loadPayouts();
                });
            });

            loadFormData();
            loadPayouts();
        })();
    </script>
</asp:Content>
