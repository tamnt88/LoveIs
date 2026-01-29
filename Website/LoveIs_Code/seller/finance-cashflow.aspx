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
                <select id="CashflowRangeSelect">
                    <option value="6" <% if (RangeMonths == 6) { %>selected<% } %>>6 tháng gần nhất</option>
                    <option value="12" <% if (RangeMonths == 12) { %>selected<% } %>>12 tháng gần nhất</option>
                </select>
            </div>
        </div>

        <div class="finance-stat-grid">
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-blue"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="finance-stat-label">Tổng Thu</div>
                <div class="finance-stat-value"><asp:Literal ID="TotalIncomeLiteral" runat="server" /></div>
                <div class="finance-stat-sub"><%= RangeMonths %> tháng gần nhất</div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-red"><i class="fa-solid fa-arrow-trend-down"></i></span>
                <div class="finance-stat-label">Tổng Chi</div>
                <div class="finance-stat-value"><asp:Literal ID="TotalExpenseLiteral" runat="server" /></div>
                <div class="finance-stat-sub"><%= RangeMonths %> tháng gần nhất</div>
            </div>
            <div class="finance-profit-card">
                <span class="finance-stat-icon info-green"><i class="fa-solid fa-wallet"></i></span>
                <div class="finance-stat-label">Lợi Nhuận</div>
                <div class="finance-stat-value"><asp:Literal ID="ProfitLiteral" runat="server" /></div>
                <div class="finance-stat-trend up"><asp:Literal ID="ProfitTrendLiteral" runat="server" /></div>
            </div>
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-purple"><i class="fa-solid fa-percent"></i></span>
                <div class="finance-stat-label">Tỷ Lệ Lợi Nhuận</div>
                <div class="finance-stat-value"><asp:Literal ID="ProfitRateLiteral" runat="server" /></div>
                <div class="finance-stat-sub"><asp:Literal ID="ProfitRateNoteLiteral" runat="server" /></div>
            </div>
        </div>

        <div class="finance-chart-grid">
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Thu Chi 6 Tháng</div>
                <div id="cashflow-dual-chart" class="finance-chart-placeholder bar-chart has-canvas"></div>
            </div>
            <div class="card finance-chart-card">
                <div class="finance-chart-title">Phân Bổ Chi Phí</div>
                <div id="fee-pie-chart" class="data-chart-placeholder pie-chart has-canvas"></div>
                <div id="fee-pie-legend" class="pie-legend"></div>
            </div>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-history-head">
                <div class="finance-chart-title">Giao Dịch Gần Đây</div>
                <div class="finance-history-search">
                    <input id="CashflowSearchInput" type="text" class="form-control" value="<%= SearchQuery %>" placeholder="Tìm kiếm giao dịch..." />
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Ngày</th>
                            <th>Danh mục</th>
                            <th>Mô tả</th>
                            <th>Loại</th>
                            <th>Số tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="RecentTxnRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("DateText") %></td>
                                    <td><%# Eval("Category") %></td>
                                    <td><%# Eval("Description") %></td>
                                    <td><span class='<%# Eval("TypeBadgeClass") %>'><%# Eval("TypeLabel") %></span></td>
                                    <td><span class='<%# Eval("AmountClass") %>'><%# Eval("AmountText") %></span></td>
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
            var select = document.getElementById("CashflowRangeSelect");
            if (!select) return;
            select.addEventListener("change", function () {
                var value = select.value || "6";
                var search = document.getElementById("CashflowSearchInput");
                var keyword = search ? (search.value || "").trim() : "";
                var query = "/seller/finance-cashflow.aspx?range=" + encodeURIComponent(value);
                if (keyword) {
                    query += "&search=" + encodeURIComponent(keyword);
                }
                window.location.href = query;
            });
        })();

        (function () {
            var input = document.getElementById("CashflowSearchInput");
            if (!input) return;
            input.addEventListener("keydown", function (event) {
                if (event.key !== "Enter") return;
                event.preventDefault();
                var keyword = (input.value || "").trim();
                var range = "<%= RangeMonths %>";
                var query = "/seller/finance-cashflow.aspx?range=" + encodeURIComponent(range);
                if (keyword) {
                    query += "&search=" + encodeURIComponent(keyword);
                }
                window.location.href = query;
            });
        })();

        window.cashflowMonthlyData = <%= MonthlyCashflowDataJson %>;
        window.feeDistributionData = <%= FeeDistributionJson %>;

        (function () {
            var data = window.cashflowMonthlyData || [];
            var container = document.getElementById("cashflow-dual-chart");
            if (!container || !data.length) return;

            function formatCurrency(value) {
                return value.toLocaleString("vi-VN") + " đ";
            }

            function renderBar() {
                var width = container.clientWidth;
                var height = 280;
                var padding = { left: 70, right: 24, top: 24, bottom: 40 };
                var innerWidth = Math.max(0, width - padding.left - padding.right);
                var innerHeight = Math.max(0, height - padding.top - padding.bottom);
                var max = 1;

                for (var i = 0; i < data.length; i++) {
                    max = Math.max(max, data[i].Income || 0, data[i].Expense || 0);
                }

                container.innerHTML = "";

                var tooltip = document.createElement("div");
                tooltip.className = "data-line-tooltip";

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

                var groupWidth = data.length > 0 ? innerWidth / data.length : innerWidth;
                var barWidth = Math.max(10, groupWidth * 0.28);

                for (var j = 0; j < data.length; j++) {
                    var baseX = padding.left + groupWidth * j;
                    var incomeHeight = max > 0 ? (data[j].Income / max) * innerHeight : 0;
                    var expenseHeight = max > 0 ? (data[j].Expense / max) * innerHeight : 0;

                    var incomeX = baseX + (groupWidth / 2) - barWidth - 4;
                    var expenseX = baseX + (groupWidth / 2) + 4;

                    var incomeY = padding.top + innerHeight - incomeHeight;
                    var expenseY = padding.top + innerHeight - expenseHeight;

                    var incomeRect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                    incomeRect.setAttribute("x", incomeX.toString());
                    incomeRect.setAttribute("y", incomeY.toString());
                    incomeRect.setAttribute("width", barWidth.toString());
                    incomeRect.setAttribute("height", incomeHeight.toString());
                    incomeRect.setAttribute("rx", "6");
                    incomeRect.setAttribute("fill", "#17b26a");
                    incomeRect.style.cursor = "pointer";

                    incomeRect.addEventListener("mouseenter", (function (point, centerX, centerY) {
                        return function () {
                            tooltip.innerHTML = "<div class=\"tooltip-title\">" + point.Label + "</div><div class=\"tooltip-value\">Thu : " + formatCurrency(point.Income) + "</div>";
                            tooltip.style.left = centerX + "px";
                            tooltip.style.top = centerY + "px";
                            tooltip.classList.add("show");
                        };
                    })(data[j], incomeX + barWidth / 2, incomeY));

                    incomeRect.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
                    });

                    var expenseRect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                    expenseRect.setAttribute("x", expenseX.toString());
                    expenseRect.setAttribute("y", expenseY.toString());
                    expenseRect.setAttribute("width", barWidth.toString());
                    expenseRect.setAttribute("height", expenseHeight.toString());
                    expenseRect.setAttribute("rx", "6");
                    expenseRect.setAttribute("fill", "#ef4f4f");
                    expenseRect.style.cursor = "pointer";

                    expenseRect.addEventListener("mouseenter", (function (point, centerX, centerY) {
                        return function () {
                            tooltip.innerHTML = "<div class=\"tooltip-title\">" + point.Label + "</div><div class=\"tooltip-value\">Chi : " + formatCurrency(point.Expense) + "</div>";
                            tooltip.style.left = centerX + "px";
                            tooltip.style.top = centerY + "px";
                            tooltip.classList.add("show");
                        };
                    })(data[j], expenseX + barWidth / 2, expenseY));

                    expenseRect.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
                    });

                    svg.appendChild(incomeRect);
                    svg.appendChild(expenseRect);

                    var label = document.createElementNS("http://www.w3.org/2000/svg", "text");
                    label.setAttribute("x", (baseX + groupWidth / 2).toString());
                    label.setAttribute("y", (height - padding.bottom + 18).toString());
                    label.setAttribute("text-anchor", "middle");
                    label.setAttribute("font-size", "12");
                    label.setAttribute("fill", "#2e1a22");
                    label.textContent = data[j].ShortLabel;
                    svg.appendChild(label);
                }

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

                container.appendChild(svg);
                container.appendChild(tooltip);
            }

            renderBar();
            window.addEventListener("resize", renderBar);
        })();

        (function () {
            var container = document.getElementById("fee-pie-chart");
            var legend = document.getElementById("fee-pie-legend");
            if (!container) return;

            function renderPie() {
                var data = window.feeDistributionData || [];
                var size = 220;
                var radius = 90;
                var center = size / 2;
                var colors = ["#3a0517", "#6a1c3d", "#a43b6b", "#d64f86", "#e7a0c2", "#f2c7d8"];

                container.innerHTML = "";
                if (legend) {
                    legend.innerHTML = "";
                }

                var tooltip = document.createElement("div");
                tooltip.className = "data-pie-tooltip";

                var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
                svg.setAttribute("viewBox", "0 0 " + size + " " + size);
                svg.setAttribute("class", "data-chart-canvas");

                var total = 0;
                for (var i = 0; i < data.length; i++) {
                    total += data[i].Count;
                }

                if (!data.length || total === 0) {
                    var circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                    circle.setAttribute("cx", center.toString());
                    circle.setAttribute("cy", center.toString());
                    circle.setAttribute("r", radius.toString());
                    circle.setAttribute("fill", "#e7e1e4");
                    svg.appendChild(circle);

                    if (legend) {
                        var emptyItem = document.createElement("div");
                        emptyItem.className = "pie-legend-item";
                        emptyItem.innerHTML = "<span class=\"pie-legend-color\" style=\"background:#e7e1e4\"></span><span>Chưa có dữ liệu</span>";
                        legend.appendChild(emptyItem);
                    }

                    circle.addEventListener("mouseenter", function () {
                        tooltip.textContent = "Chưa có dữ liệu";
                        tooltip.style.left = center + "px";
                        tooltip.style.top = center + "px";
                        tooltip.classList.add("show");
                    });
                    circle.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
                    });

                    container.appendChild(svg);
                    container.appendChild(tooltip);
                    return;
                }

                function polarToCartesian(cx, cy, r, angle) {
                    var rad = (angle - 90) * (Math.PI / 180);
                    return {
                        x: cx + r * Math.cos(rad),
                        y: cy + r * Math.sin(rad)
                    };
                }

                function describeArc(cx, cy, r, startAngle, endAngle) {
                    var start = polarToCartesian(cx, cy, r, endAngle);
                    var end = polarToCartesian(cx, cy, r, startAngle);
                    var largeArc = endAngle - startAngle <= 180 ? "0" : "1";
                    return "M " + start.x + " " + start.y + " A " + r + " " + r + " 0 " + largeArc + " 0 " + end.x + " " + end.y + " L " + cx + " " + cy + " Z";
                }

                var startAngle = 0;
                for (var j = 0; j < data.length; j++) {
                    var sliceAngle = (data[j].Count / total) * 360;
                    var endAngle = startAngle + sliceAngle;
                    var path = document.createElementNS("http://www.w3.org/2000/svg", "path");
                    path.setAttribute("d", describeArc(center, center, radius, startAngle, endAngle === startAngle ? startAngle + 0.1 : endAngle));
                    path.setAttribute("fill", colors[j % colors.length]);
                    path.style.cursor = "pointer";

                    var percentText = Math.round((data[j].Count / total) * 100);
                    if (percentText > 0) {
                        var labelPos = polarToCartesian(center, center, radius * 0.55, startAngle + sliceAngle / 2);
                        var percentLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
                        percentLabel.setAttribute("x", labelPos.x.toString());
                        percentLabel.setAttribute("y", (labelPos.y + 4).toString());
                        percentLabel.setAttribute("text-anchor", "middle");
                        percentLabel.setAttribute("font-size", "12");
                        percentLabel.setAttribute("font-weight", "700");
                        percentLabel.setAttribute("fill", "#ffffff");
                        percentLabel.textContent = percentText + "%";
                        svg.appendChild(percentLabel);
                    }

                    path.addEventListener("mouseenter", (function (item, angle) {
                        return function () {
                            var percent = total > 0 ? Math.round((item.Count / total) * 100) : 0;
                            tooltip.textContent = item.Name + " (" + percent + "%)";
                            tooltip.classList.add("show");
                        };
                    })(data[j], startAngle + sliceAngle / 2));

                    path.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
                    });

                    path.addEventListener("mousemove", function (event) {
                        var rect = container.getBoundingClientRect();
                        tooltip.style.left = (event.clientX - rect.left + 10) + "px";
                        tooltip.style.top = (event.clientY - rect.top + 10) + "px";
                    });

                    svg.appendChild(path);

                    if (legend) {
                        var legendItem = document.createElement("div");
                        legendItem.className = "pie-legend-item";
                        legendItem.innerHTML = "<span class=\"pie-legend-color\" style=\"background:" + colors[j % colors.length] + "\"></span><span>" + data[j].Name + "</span>";
                        legend.appendChild(legendItem);
                    }

                    startAngle = endAngle;
                }

                container.appendChild(svg);
                container.appendChild(tooltip);
            }

            renderPie();
            window.addEventListener("resize", renderPie);
        })();
    </script>
</asp:Content>
