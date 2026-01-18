<%@ Page Language="C#" AutoEventWireup="true" CodeFile="data-sales.aspx.cs" Inherits="SellerDataSales" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Phân tích bán hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data">
        <div class="data-header">
            <div>
                <h2>Phân Tích Bán Hàng</h2>
                <p>Dữ liệu chi tiết về hoạt động bán hàng</p>
            </div>
        </div>

        <div class="data-stat-grid">
            <div class="card data-stat-card">
                <span class="data-stat-icon info-maroon"><i class="fa-solid fa-chart-line"></i></span>
                <div class="data-stat-label">Tổng Đơn Hàng</div>
                <div class="data-stat-value">424</div>
                <div class="data-stat-trend up">+22%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-blue"><i class="fa-solid fa-cart-shopping"></i></span>
                <div class="data-stat-label">Giá Trị Đơn TB</div>
                <div class="data-stat-value">285.000 đ</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-purple"><i class="fa-solid fa-arrow-trend-up"></i></span>
                <div class="data-stat-label">Tỷ Lệ Chuyển Đổi</div>
                <div class="data-stat-value">3.8%</div>
            </div>
            <div class="card data-stat-card">
                <span class="data-stat-icon info-green"><i class="fa-solid fa-rotate-right"></i></span>
                <div class="data-stat-label">Khách Quay Lại</div>
                <div class="data-stat-value">42%</div>
            </div>
        </div>

        <div class="data-panel-grid">
            <div class="card data-panel">
                <div class="data-panel-title">Phân Bổ Theo Danh Mục</div>
                <div id="category-pie-chart" class="data-chart-placeholder pie-chart has-canvas"></div>
                <div id="category-pie-legend" class="pie-legend"></div>
            </div>
            <div class="card data-panel">
                <div class="data-panel-title">Xu Hướng Bán Hàng</div>
                <div id="weekly-orders-chart" class="data-chart-placeholder line-chart has-canvas"></div>
            </div>
        </div>
    </div>

    <script>
        window.weeklyOrderData = <%= WeeklyOrderDataJson %>;
        window.categoryDistributionData = <%= CategoryDistributionJson %>;

        (function () {
            var data = window.weeklyOrderData || [];
            var container = document.getElementById("weekly-orders-chart");
            if (!container || !data.length) return;

            function renderChart() {
                var width = container.clientWidth;
                var height = 260;
                var padding = { left: 64, right: 24, top: 24, bottom: 36 };
                var innerWidth = Math.max(0, width - padding.left - padding.right);
                var innerHeight = Math.max(0, height - padding.top - padding.bottom);
                var max = 1;

                for (var i = 0; i < data.length; i++) {
                    if (data[i].Count > max) {
                        max = data[i].Count;
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
                    var y = padding.top + innerHeight - (data[j].Count / max) * innerHeight;
                    points.push({ x: x, y: y, day: data[j].Day, date: data[j].DateText, count: data[j].Count });
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
                    tick.textContent = tickValues[t].toString();
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
                            tooltip.textContent = point.date + ": " + point.count + " đơn";
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

        (function () {
            var container = document.getElementById("category-pie-chart");
            var legend = document.getElementById("category-pie-legend");
            if (!container) return;

            function renderPie() {
                var data = window.categoryDistributionData || [];
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

                    path.addEventListener("mouseenter", (function (item, angle) {
                        return function () {
                            var percent = total > 0 ? Math.round((item.Count / total) * 100) : 0;
                            var pos = polarToCartesian(center, center, radius * 0.6, angle);
                            tooltip.textContent = item.Name + " (" + percent + "%)";
                            tooltip.style.left = pos.x + "px";
                            tooltip.style.top = pos.y + "px";
                            tooltip.classList.add("show");
                        };
                    })(data[j], startAngle + sliceAngle / 2));

                    path.addEventListener("mouseleave", function () {
                        tooltip.classList.remove("show");
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
