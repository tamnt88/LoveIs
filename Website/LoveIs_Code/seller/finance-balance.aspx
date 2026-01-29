<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-balance.aspx.cs" Inherits="SellerFinanceBalance" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Số dư tài khoản</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Số Dư Tài Khoản</h2>
                <p>Theo dõi số dư và lịch sử giao dịch tài khoản LoveIs</p>
            </div>
        </div>

        <div class="finance-toolbar">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select id="BalanceRangeSelect">
                    <option value="7" <% if (RangeDays == 7) { %>selected<% } %>>7 ngày qua</option>
                    <option value="30" <% if (RangeDays == 30) { %>selected<% } %>>30 ngày qua</option>
                </select>
            </div>
            <a class="btn-address-outline" href="/seller/finance-balance.aspx?range=<%= RangeDays %>&export=1">
                <i class="fa-solid fa-download"></i>
                Xuất Excel
            </a>
        </div>

        <div class="finance-balance-grid">
            <div class="finance-balance-hero">
                <div class="finance-balance-label"><i class="fa-solid fa-dollar-sign"></i> Số Dư Hiện Tại</div>
                <div class="finance-balance-value"><asp:Literal ID="WalletBalanceLiteral" runat="server" /></div>
                <div class="finance-balance-note"><asp:Literal ID="WalletBalanceNoteLiteral" runat="server" /></div>
                <button type="button" class="btn-address-outline btn-balance-withdraw" id="BalanceWithdrawButton">
                    <i class="fa-solid fa-hand-holding-dollar"></i>
                    Rút tiền về bank
                </button>
            </div>
            <div class="card finance-mini-card">
                <span class="finance-mini-icon info-green"><i class="fa-solid fa-arrow-up"></i></span>
                <div class="finance-mini-label">Tiền Vào</div>
                <div class="finance-mini-value"><asp:Literal ID="CashInLiteral" runat="server" /></div>
                <div class="finance-mini-sub"><%= RangeDays %> ngày qua</div>
            </div>
            <div class="card finance-mini-card">
                <span class="finance-mini-icon info-red"><i class="fa-solid fa-arrow-down"></i></span>
                <div class="finance-mini-label">Tiền Ra</div>
                <div class="finance-mini-value"><asp:Literal ID="CashOutLiteral" runat="server" /></div>
                <div class="finance-mini-sub"><%= RangeDays %> ngày qua</div>
            </div>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-chart-title">Biến Động Số Dư</div>
            <div id="balance-trend-chart" class="finance-chart-placeholder line-chart has-canvas"></div>
        </div>

        <div class="review-reply-modal" id="BalanceWithdrawModal">
            <div class="review-reply-dialog bank-modal-dialog">
                <div class="review-reply-head">
                    <span>Yêu cầu rút tiền về ngân hàng</span>
                    <button type="button" class="review-reply-close" data-balance-modal-close>&times;</button>
                </div>
                <div class="review-reply-body">
                    <div class="settings-card">
                        <asp:Literal ID="PayoutMessageLiteral" runat="server" />
                        <asp:HiddenField ID="BalanceModalOpenField" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="PayoutFeeValueField" runat="server" ClientIDMode="Static" Value="0" />
                        <div class="settings-grid">
                            <div class="form-group form-group-full bank-select-row">
                                <div class="form-row-inline">
                                    <label>Tài khoản ngân hàng</label>
                                    <div class="form-row-field">
                                        <asp:DropDownList ID="PayoutBankSelect" runat="server" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group form-group-full">
                                <div class="form-row-inline">
                                    <label>Giá trị yêu cầu thanh toán</label>
                                    <div class="form-row-field">
                                        <asp:TextBox ID="PayoutAmountInput" runat="server" CssClass="form-control" TextMode="Number" />
                                        <div class="form-note">Số dư khả dụng: <asp:Literal ID="AvailableBalanceNoteLiteral" runat="server" /></div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group form-group-full payout-summary">
                                <div class="form-row-inline">
                                    <label>Phí thanh toán</label>
                                    <div class="form-row-field">
                                        <div class="payout-summary-row">
                                            <strong id="PayoutFeeLabel">0 đ</strong>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-row-inline">
                                    <label>Số tiền chuyển vào tài khoản</label>
                                    <div class="form-row-field">
                                        <div class="payout-summary-row">
                                            <strong id="PayoutNetLabel" class="payout-net-amount">0 đ</strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group form-group-full">
                                <div class="form-row-inline">
                                    <label>Ghi chú</label>
                                    <div class="form-row-field">
                                        <asp:TextBox ID="PayoutNoteInput" runat="server" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="settings-actions">
                            <asp:LinkButton ID="SubmitPayoutButton" runat="server" CssClass="btn-address-primary" OnClick="SubmitPayoutButton_Click" OnClientClick="document.getElementById('BalanceModalOpenField').value='1';">Gửi yêu cầu rút tiền</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-history-head">
                <div class="finance-chart-title">Lịch Sử Giao Dịch</div>
                <div class="finance-history-search">
                    <input id="BalanceSearchInput" type="text" class="form-control" value="<%= SearchQuery %>" placeholder="Tìm kiếm giao dịch..." />
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Thời gian</th>
                            <th>Mô tả</th>
                            <th>Loại</th>
                            <th>Số tiền</th>
                            <th>Số dư sau GD</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="WalletTxnRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("TxnCode") %></td>
                                    <td><%# Eval("CreatedAtText") %></td>
                                    <td><%# Eval("Description") %></td>
                                    <td><span class='<%# Eval("TypeBadgeClass") %>'><%# Eval("TypeLabel") %></span></td>
                                    <td><span class='<%# Eval("AmountClass") %>'><%# Eval("AmountText") %></span></td>
                                    <td><%# Eval("BalanceAfterText") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <div class="finance-history-footer">
                <div class="history-count">Hiển thị <%= PageStart %>-<%= PageEnd %> của <%= TotalRows %> giao dịch</div>
                <div class="history-pager"><%= PagerHtml %></div>
            </div>
        </div>
    </div>

    <script>
        (function () {
            var select = document.getElementById("BalanceRangeSelect");
            if (!select) return;
            select.addEventListener("change", function () {
                var value = select.value || "7";
                var search = document.getElementById("BalanceSearchInput");
                var keyword = search ? (search.value || "").trim() : "";
                var query = "/seller/finance-balance.aspx?range=" + encodeURIComponent(value);
                if (keyword) {
                    query += "&search=" + encodeURIComponent(keyword);
                }
                window.location.href = query;
            });
        })();

        (function () {
            var input = document.getElementById("BalanceSearchInput");
            if (!input) return;
            input.addEventListener("keydown", function (event) {
                if (event.key !== "Enter") return;
                event.preventDefault();
                var keyword = (input.value || "").trim();
                var range = "<%= RangeDays %>";
                var query = "/seller/finance-balance.aspx?range=" + encodeURIComponent(range);
                if (keyword) {
                    query += "&search=" + encodeURIComponent(keyword);
                }
                window.location.href = query;
            });
        })();

        (function () {
            var modal = document.getElementById("BalanceWithdrawModal");
            var openBtn = document.getElementById("BalanceWithdrawButton");
            if (!modal || !openBtn) {
                return;
            }
            var closeBtn = modal.querySelector("[data-balance-modal-close]");
            var modalField = document.getElementById("BalanceModalOpenField");

            function openModal() {
                modal.classList.add("open");
                if (modalField) {
                    modalField.value = "1";
                }
            }
            function closeModal() {
                modal.classList.remove("open");
                if (modalField) {
                    modalField.value = "";
                }
            }

            openBtn.addEventListener("click", openModal);
            if (closeBtn) {
                closeBtn.addEventListener("click", closeModal);
            }
            modal.addEventListener("click", function (event) {
                if (event.target === modal) {
                    closeModal();
                }
            });
        })();

        (function () {
            var amountInput = document.getElementById("<%= PayoutAmountInput.ClientID %>");
            var feeLabel = document.getElementById("PayoutFeeLabel");
            var netLabel = document.getElementById("PayoutNetLabel");
            var feeField = document.getElementById("PayoutFeeValueField");
            if (!amountInput || !feeLabel || !netLabel || !feeField) return;

            function formatCurrency(value) {
                return value.toLocaleString("vi-VN") + " đ";
            }

            function updateSummary() {
                var amount = parseFloat(amountInput.value || "0");
                if (isNaN(amount) || amount < 0) {
                    amount = 0;
                }
                var fee = parseFloat(feeField.value || "0");
                if (isNaN(fee) || fee < 0) {
                    fee = 0;
                }
                var net = Math.max(0, amount - fee);
                feeLabel.textContent = formatCurrency(fee);
                netLabel.textContent = formatCurrency(net);
            }

            amountInput.addEventListener("input", updateSummary);
            updateSummary();
        })();

        window.balanceTrendData = <%= BalanceTrendDataJson %>;

        (function () {
            var data = window.balanceTrendData || [];
            var container = document.getElementById("balance-trend-chart");
            if (!container || !data.length) return;

            function formatCurrency(value) {
                return value.toLocaleString("vi-VN") + " đ";
            }

            function renderChart() {
                var width = container.clientWidth;
                var height = 260;
                var padding = { left: 70, right: 24, top: 24, bottom: 36 };
                var innerWidth = Math.max(0, width - padding.left - padding.right);
                var innerHeight = Math.max(0, height - padding.top - padding.bottom);
                var max = 1;

                for (var i = 0; i < data.length; i++) {
                    if (data[i].Amount > max) {
                        max = data[i].Amount;
                    }
                }

                container.innerHTML = "";

                var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
                svg.setAttribute("viewBox", "0 0 " + width + " " + height);
                svg.setAttribute("class", "data-chart-canvas");
                svg.setAttribute("preserveAspectRatio", "none");

                var axis = document.createElementNS("http://www.w3.org/2000/svg", "path");
                axis.setAttribute("d", "M " + padding.left + " " + padding.top + " V " + (height - padding.bottom) + " H " + (width - padding.right));
                axis.setAttribute("fill", "none");
                axis.setAttribute("stroke", "#2e1a22");
                axis.setAttribute("stroke-width", "2");
                svg.appendChild(axis);

                var xStep = data.length > 1 ? innerWidth / (data.length - 1) : 0;
                var path = "";
                var points = [];
                var tooltip = document.createElement("div");
                tooltip.className = "data-line-tooltip";

                for (var j = 0; j < data.length; j++) {
                    var x = padding.left + xStep * j;
                    var y = padding.top + innerHeight - (data[j].Amount / max) * innerHeight;
                    points.push({ x: x, y: y, day: data[j].Day, date: data[j].DateText, amount: data[j].Amount });
                    path += (j === 0 ? "M " : " L ") + x + " " + y;

                    var label = document.createElementNS("http://www.w3.org/2000/svg", "text");
                    label.setAttribute("x", x.toString());
                    label.setAttribute("y", (height - padding.bottom + 18).toString());
                    label.setAttribute("text-anchor", "middle");
                    label.setAttribute("font-size", "12");
                    label.setAttribute("fill", "#2e1a22");
                    label.textContent = data[j].Day;
                    svg.appendChild(label);
                }

                var line = document.createElementNS("http://www.w3.org/2000/svg", "path");
                line.setAttribute("d", path);
                line.setAttribute("fill", "none");
                line.setAttribute("stroke", "#3a0517");
                line.setAttribute("stroke-width", "3");
                svg.appendChild(line);

                var tickValues = [0, Math.round(max / 2), max];
                for (var t = 0; t < tickValues.length; t++) {
                    var tickY = padding.top + innerHeight - (tickValues[t] / max) * innerHeight;
                    var tick = document.createElementNS("http://www.w3.org/2000/svg", "text");
                    tick.setAttribute("x", (padding.left - 10).toString());
                    tick.setAttribute("y", (tickY + 4).toString());
                    tick.setAttribute("text-anchor", "end");
                    tick.setAttribute("font-size", "11");
                    tick.setAttribute("fill", "#6f5b63");
                    tick.textContent = formatCurrency(tickValues[t]);
                    svg.appendChild(tick);
                }

                for (var k = 0; k < points.length; k++) {
                    var circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                    circle.setAttribute("cx", points[k].x.toString());
                    circle.setAttribute("cy", points[k].y.toString());
                    circle.setAttribute("r", "5");
                    circle.setAttribute("fill", "#ffffff");
                    circle.setAttribute("stroke", "#3a0517");
                    circle.setAttribute("stroke-width", "2");
                    circle.style.cursor = "pointer";
                    svg.appendChild(circle);
                    circle.addEventListener("mouseenter", (function (point) {
                        return function () {
                            tooltip.innerHTML = "<div class=\"tooltip-title\">" + point.date + "</div><div class=\"tooltip-value\">Số dư : " + formatCurrency(point.amount) + "</div>";
                            tooltip.style.left = point.x + "px";
                            tooltip.style.top = point.y + "px";
                            tooltip.classList.add("show");
                        };
                    })(points[k]));
                    circle.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
                    });
                }

                container.appendChild(svg);
                container.appendChild(tooltip);
            }

            renderChart();
            window.addEventListener("resize", renderChart);
        })();
    </script>
</asp:Content>
