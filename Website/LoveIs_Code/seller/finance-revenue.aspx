<%@ Page Language="C#" AutoEventWireup="true" CodeFile="finance-revenue.aspx.cs" Inherits="SellerFinanceRevenue" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Doanh thu</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-finance">
        <div class="finance-header">
            <div>
                <h2>Doanh Thu</h2>
                <p>Theo dõi doanh thu và lợi nhuận</p>
            </div>
        </div>

        <div class="finance-stat-grid">
            <div class="card finance-stat-card">
                <span class="finance-stat-icon info-green"><i class="fa-solid fa-dollar-sign"></i></span>
                <div class="finance-stat-label">Doanh Thu Tháng Này</div>
                <div class="finance-stat-value"><asp:Literal ID="MonthRevenueLiteral" runat="server" /></div>
            </div>
            <div class="card finance-stat-card">
                <div class="finance-stat-label">Đã Thanh Toán</div>
                <div class="finance-stat-value"><asp:Literal ID="PaidRevenueLiteral" runat="server" /></div>
            </div>
            <div class="card finance-stat-card">
                <div class="finance-stat-label">Chờ Thanh Toán</div>
                <div class="finance-stat-value"><asp:Literal ID="PendingRevenueLiteral" runat="server" /></div>
            </div>
            <div class="card finance-stat-card">
                <div class="finance-stat-label">Lợi Nhuận Ước Tính</div>
                <div class="finance-stat-value"><asp:Literal ID="EstimatedProfitLiteral" runat="server" /></div>
            </div>
        </div>

        <div class="finance-toolbar mt-3">
            <div class="data-filter">
                <i class="fa-regular fa-calendar"></i>
                <select id="RevenueRangeSelect">
                    <option value="6" <% if (RangeMonths == 6) { %>selected<% } %>>6 tháng gần nhất</option>
                    <option value="12" <% if (RangeMonths == 12) { %>selected<% } %>>12 tháng gần nhất</option>
                </select>
            </div>
            <a class="btn-address-outline" href="/seller/finance-revenue.aspx?range=<%= RangeMonths %>&export=1">
                <i class="fa-solid fa-download"></i>
                Xuất Excel
            </a>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-chart-head">
                <div class="finance-chart-title">Biểu Đồ Doanh Thu <%= RangeMonths %> Tháng</div>
            </div>
            <div id="monthly-revenue-chart" class="finance-chart-placeholder bar-chart has-canvas"></div>
        </div>

        <div class="card finance-chart-card">
            <div class="finance-history-head">
                <div class="finance-chart-title">Lịch Sử Doanh Thu</div>
                <div class="finance-history-search">
                    <input id="RevenueSearchInput" type="text" class="form-control" value="<%= SearchQuery %>" placeholder="Tìm kiếm giao dịch..." />
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Ngày</th>
                            <th>Loại</th>
                            <th>Số Tiền</th>
                            <th>Trạng Thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="RevenueHistoryRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("OrderCode") %></td>
                                    <td><%# Eval("CreatedAtText") %></td>
                                    <td><%# Eval("TypeLabel") %></td>
                                    <td><span class="text-success"><%# Eval("AmountText") %></span></td>
                                    <td><span class="badge bg-success-subtle text-success"><%# Eval("StatusLabel") %></span></td>
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
            var select = document.getElementById("RevenueRangeSelect");
            if (!select) return;
            select.addEventListener("change", function () {
                var value = select.value || "6";
                var search = document.getElementById("RevenueSearchInput");
                var keyword = search ? (search.value || "").trim() : "";
                var query = "/seller/finance-revenue.aspx?range=" + encodeURIComponent(value);
                if (keyword) {
                    query += "&search=" + encodeURIComponent(keyword);
                }
                window.location.href = query;
            });
        })();

        (function () {
            var input = document.getElementById("RevenueSearchInput");
            if (!input) return;
            input.addEventListener("keydown", function (event) {
                if (event.key !== "Enter") return;
                event.preventDefault();
                var keyword = (input.value || "").trim();
                var range = "<%= RangeMonths %>";
                var query = "/seller/finance-revenue.aspx?range=" + encodeURIComponent(range);
                if (keyword) {
                    query += "&search=" + encodeURIComponent(keyword);
                }
                window.location.href = query;
            });
        })();

        window.monthlyRevenueData = <%= MonthlyRevenueDataJson %>;

        (function () {
            var data = window.monthlyRevenueData || [];
            var container = document.getElementById("monthly-revenue-chart");
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
                    if (data[i].Total > max) {
                        max = data[i].Total;
                    }
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

                var xStep = data.length > 0 ? innerWidth / data.length : innerWidth;
                var barWidth = Math.max(16, xStep * 0.6);

                for (var j = 0; j < data.length; j++) {
                    var barHeight = max > 0 ? (data[j].Total / max) * innerHeight : 0;
                    var x = padding.left + xStep * j + (xStep - barWidth) / 2;
                    var y = padding.top + innerHeight - barHeight;

                    var rect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                    rect.setAttribute("x", x.toString());
                    rect.setAttribute("y", y.toString());
                    rect.setAttribute("width", barWidth.toString());
                    rect.setAttribute("height", barHeight.toString());
                    rect.setAttribute("rx", "6");
                    rect.setAttribute("fill", "#6a1c3d");
                    rect.style.cursor = "pointer";

                    rect.addEventListener("mouseenter", (function (point, centerX, centerY) {
                        return function () {
                            tooltip.innerHTML = "<div class=\"tooltip-title\">" + point.Label + "</div><div class=\"tooltip-value\">Doanh thu : " + formatCurrency(point.Total) + "</div>";
                            tooltip.style.left = centerX + "px";
                            tooltip.style.top = centerY + "px";
                            tooltip.classList.add("show");
                        };
                    })(data[j], x + barWidth / 2, y));

                    rect.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
                    });

                    svg.appendChild(rect);

                    var label = document.createElementNS("http://www.w3.org/2000/svg", "text");
                    label.setAttribute("x", (x + barWidth / 2).toString());
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
    </script>
</asp:Content>
