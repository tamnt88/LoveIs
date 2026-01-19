<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wallet-release.aspx.cs" Inherits="AdminSystemWalletRelease" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Giai ngan vi shop
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Giai ngan vi shop
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Duyet giai ngan va xu ly lenh rut tien
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chu</a></li>
    <li class="breadcrumb-item"><a href="#">He thong</a></li>
    <li class="breadcrumb-item active" aria-current="page">Giai ngan vi shop</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-kpi p-3 bg-white mb-4">
        <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
        <div class="row g-3 align-items-end">
            <div class="col-md-2">
                <label class="form-label">Payout ID</label>
                <asp:TextBox ID="ProofPayoutId" runat="server" CssClass="form-control" placeholder="VD: 12"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label">Chung tu</label>
                <asp:FileUpload ID="ProofUpload" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-4">
                <label class="form-label">Ghi chu</label>
                <asp:TextBox ID="ProofNote" runat="server" CssClass="form-control" placeholder="Ghi chu cho admin"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <asp:Button ID="UploadProofButton" runat="server" CssClass="btn btn-primary w-100" Text="Upload + Da chi tien"
                    OnClick="UploadProofButton_Click" />
            </div>
        </div>
    </div>

    <div class="card-kpi p-3 bg-white">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h5 class="mb-0">Release (Pending / Released / Available)</h5>
            <div class="d-flex gap-2">
                <select id="ReleaseStatusFilter" class="form-select form-select-sm">
                    <option value="">Tat ca</option>
                    <option value="Pending">Pending</option>
                    <option value="Released">Released</option>
                    <option value="Available">Available</option>
                </select>
                <button id="ReleaseReload" class="btn btn-outline-secondary btn-sm" type="button">Tai lai</button>
                <button id="ReleaseDue" class="btn btn-primary btn-sm" type="button">Giai ngan den han</button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Shop</th>
                        <th>Don hang</th>
                        <th>So tien</th>
                        <th>Trang thai</th>
                        <th>ReleaseAt</th>
                        <th>Thao tac</th>
                    </tr>
                </thead>
                <tbody id="ReleaseTableBody">
                    <tr>
                        <td colspan="6" class="text-center text-muted">Dang tai du lieu...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card-kpi p-3 bg-white mt-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h5 class="mb-0">Lenh rut tien</h5>
            <div class="d-flex gap-2">
                <select id="PayoutStatusFilter" class="form-select form-select-sm">
                    <option value="">Tat ca</option>
                    <option value="Requested">Requested</option>
                    <option value="Paid">Paid</option>
                    <option value="Rejected">Rejected</option>
                </select>
                <button id="PayoutReload" class="btn btn-outline-secondary btn-sm" type="button">Tai lai</button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Shop</th>
                        <th>So tien</th>
                        <th>Ngan hang</th>
                        <th>Trang thai</th>
                        <th>Ngay yeu cau</th>
                        <th>Thao tac</th>
                    </tr>
                </thead>
                <tbody id="PayoutTableBody">
                    <tr>
                        <td colspan="6" class="text-center text-muted">Dang tai du lieu...</td>
                    </tr>
                </tbody>
            </table>
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

            function formatMoney(amount) {
                if (amount === null || amount === undefined) {
                    return "-";
                }
                return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " d";
            }

            function formatDate(text) {
                return text || "-";
            }

            function loadReleases() {
                var status = document.getElementById("ReleaseStatusFilter").value || "";
                postJson("wallet-release.aspx/GetReleases", { status: status }, function (data) {
                    var body = document.getElementById("ReleaseTableBody");
                    body.innerHTML = "";
                    if (!data || data.length === 0) {
                        body.innerHTML = "<tr><td colspan='6' class='text-center text-muted'>Khong co du lieu.</td></tr>";
                        return;
                    }
                    data.forEach(function (item) {
                        var actions = "";
                        if (item.Status === "Pending") {
                            actions += "<button class='btn btn-sm btn-outline-primary me-1' data-act='approve' data-id='" + item.Id + "'>Duyet</button>";
                            actions += "<button class='btn btn-sm btn-primary' data-act='approve-release' data-id='" + item.Id + "'>Duyet + Giai ngan</button>";
                        } else if (item.Status === "Released") {
                            actions += "<button class='btn btn-sm btn-primary' data-act='release' data-id='" + item.Id + "'>Chuyen ve kha dung</button>";
                        }
                        var row = document.createElement("tr");
                        row.innerHTML =
                            "<td>" + item.ShopName + "</td>" +
                            "<td>" + item.OrderCode + "</td>" +
                            "<td>" + formatMoney(item.Amount) + "</td>" +
                            "<td>" + item.Status + "</td>" +
                            "<td>" + formatDate(item.ReleaseAtText || item.ReleaseAt) + "</td>" +
                            "<td>" + (actions || "-") + "</td>";
                        body.appendChild(row);
                    });
                });
            }

            function loadPayouts() {
                var status = document.getElementById("PayoutStatusFilter").value || "";
                postJson("wallet-release.aspx/GetPayoutRequests", { status: status }, function (data) {
                    var body = document.getElementById("PayoutTableBody");
                    body.innerHTML = "";
                    if (!data || data.length === 0) {
                        body.innerHTML = "<tr><td colspan='6' class='text-center text-muted'>Khong co du lieu.</td></tr>";
                        return;
                    }
                    data.forEach(function (item) {
                        var row = document.createElement("tr");
                        var actionHtml = "";
                        if (item.Status === "Requested") {
                            actionHtml =
                                "<form class='d-flex flex-column gap-1' method='post' enctype='multipart/form-data'>" +
                                "<input type='hidden' name='InlineUpload' value='1' />" +
                                "<input type='hidden' name='PayoutId' value='" + item.Id + "' />" +
                                "<input type='file' name='ProofFile' class='form-control form-control-sm js-proof-file' data-preview='" + item.Id + "' accept='image/*,application/pdf' />" +
                                "<div class='small text-muted' id='ProofPreview-" + item.Id + "'></div>" +
                                "<input type='text' name='ProofNote' class='form-control form-control-sm' placeholder='Ghi chu' />" +
                                "<div class='d-flex gap-1'>" +
                                "<button class='btn btn-sm btn-primary' type='submit'>Upload + Da chi tien</button>" +
                                "<button class='btn btn-sm btn-outline-danger' type='button' data-reject='" + item.Id + "'>Tu choi</button>" +
                                "</div>" +
                                "</form>";
                        }
                        row.innerHTML =
                            "<td>" + item.ShopName + "</td>" +
                            "<td>" + formatMoney(item.Amount) + "</td>" +
                            "<td>" + item.BankName + "</td>" +
                            "<td>" + item.Status + "</td>" +
                            "<td>" + formatDate(item.RequestedAtText || item.RequestedAt) + "</td>" +
                            "<td>" + (actionHtml || "-") + "</td>";
                        body.appendChild(row);
                    });
                });
            }

            document.getElementById("ReleaseReload").addEventListener("click", loadReleases);
            document.getElementById("PayoutReload").addEventListener("click", loadPayouts);
            document.getElementById("ReleaseStatusFilter").addEventListener("change", loadReleases);
            document.getElementById("PayoutStatusFilter").addEventListener("change", loadPayouts);

            document.getElementById("ReleaseDue").addEventListener("click", function () {
                postJson("wallet-release.aspx/ReleaseDue", {}, function () {
                    loadReleases();
                });
            });

            document.addEventListener("click", function (evt) {
                var target = evt.target;
                if (target && target.dataset && target.dataset.act) {
                    var id = parseInt(target.dataset.id || "0", 10);
                    if (target.dataset.act === "approve") {
                        postJson("wallet-release.aspx/ApproveRelease", { releaseId: id, note: "" }, function () {
                            loadReleases();
                        });
                    } else if (target.dataset.act === "approve-release") {
                        postJson("wallet-release.aspx/ApproveAndRelease", { releaseId: id, note: "" }, function () {
                            loadReleases();
                        });
                    } else if (target.dataset.act === "release") {
                        postJson("wallet-release.aspx/ReleaseToAvailable", { releaseId: id }, function () {
                            loadReleases();
                        });
                    }
                }

                if (target && target.dataset && target.dataset.pay) {
                    var payoutId = parseInt(target.dataset.pay || "0", 10);
                    var proofInput = document.querySelector("input[data-proof='" + payoutId + "']");
                    var noteInput = document.querySelector("input[data-note='" + payoutId + "']");
                    var proofUrl = proofInput ? proofInput.value : "";
                    var note = noteInput ? noteInput.value : "";
                    postJson("wallet-release.aspx/MarkPayoutPaid", {
                        payoutRequestId: payoutId,
                        note: note,
                        proofUrl: proofUrl,
                        proofName: ""
                    }, function () {
                        loadPayouts();
                    });
                }

                if (target && target.dataset && target.dataset.reject) {
                    var rejectId = parseInt(target.dataset.reject || "0", 10);
                    postJson("wallet-release.aspx/RejectPayout", { payoutRequestId: rejectId, note: "Admin tu choi" }, function () {
                        loadPayouts();
                    });
                }
            });

            document.addEventListener("change", function (evt) {
                var target = evt.target;
                if (!target || !target.classList || !target.classList.contains("js-proof-file")) {
                    return;
                }

                var previewId = target.getAttribute("data-preview");
                var previewEl = document.getElementById("ProofPreview-" + previewId);
                if (!previewEl) {
                    return;
                }

                previewEl.innerHTML = "";
                if (!target.files || target.files.length === 0) {
                    return;
                }

                var file = target.files[0];
                if (file.type && file.type.indexOf("image/") === 0) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        previewEl.innerHTML = "<img src='" + e.target.result + "' style='max-width:120px;max-height:80px;border:1px solid #eee;border-radius:6px;' />";
                    };
                    reader.readAsDataURL(file);
                } else {
                    previewEl.textContent = file.name;
                }
            });

            loadReleases();
            loadPayouts();
        })();
    </script>
</asp:Content>
