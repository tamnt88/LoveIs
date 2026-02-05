
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="marketing.aspx.cs" Inherits="SellerMarketing" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Kênh marketing</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-data" data-marketing-page="true">
        <div class="marketing-view" data-tab="my">
            <div class="marketing-header">
                <div>
                    <h2>Kênh Marketing Của Tôi</h2>
                    <p>Tổng quan các hoạt động marketing</p>
                </div>
            </div>

            <div class="marketing-channel-grid">
                <div class="marketing-channel-card is-orange">
                    <div class="marketing-channel-icon"><i class="fa-solid fa-bullhorn"></i></div>
                    <div class="marketing-channel-title">Quảng Cáo</div>
                    <div class="marketing-channel-sub">Tạo chiến dịch quảng cáo</div>
                </div>
                <div class="marketing-channel-card is-red">
                    <div class="marketing-channel-icon"><i class="fa-solid fa-arrow-trend-up"></i></div>
                    <div class="marketing-channel-title">Flash Sale</div>
                    <div class="marketing-channel-sub">Tạo chương trình flash sale</div>
                </div>
                <div class="marketing-channel-card is-purple">
                    <div class="marketing-channel-icon"><i class="fa-solid fa-percent"></i></div>
                    <div class="marketing-channel-title">Mã Giảm Giá</div>
                    <div class="marketing-channel-sub">Tạo voucher cho shop</div>
                </div>
                <div class="marketing-channel-card is-blue">
                    <div class="marketing-channel-icon"><i class="fa-solid fa-gift"></i></div>
                    <div class="marketing-channel-title">Add-on</div>
                    <div class="marketing-channel-sub">Gian hàng add-on</div>
                </div>
            </div>

            <div class="marketing-stat-grid">
                <div class="card marketing-stat-card">
                    <div class="marketing-stat-label">Tổng Chi Phí</div>
                    <div class="marketing-stat-value">5.2M</div>
                    <div class="marketing-stat-trend is-up">+12% so với tháng trước</div>
                </div>
                <div class="card marketing-stat-card">
                    <div class="marketing-stat-label">Doanh Thu Từ Marketing</div>
                    <div class="marketing-stat-value">45.8M</div>
                    <div class="marketing-stat-trend is-up">+18% so với tháng trước</div>
                </div>
                <div class="card marketing-stat-card">
                    <div class="marketing-stat-label">ROI</div>
                    <div class="marketing-stat-value">8.8x</div>
                    <div class="marketing-stat-trend">Hiệu quả tốt</div>
                </div>
                <div class="card marketing-stat-card">
                    <div class="marketing-stat-label">Đơn Hàng</div>
                    <div class="marketing-stat-value">234</div>
                    <div class="marketing-stat-trend is-up">+25% so với tháng trước</div>
                </div>
            </div>

            <div class="card marketing-running-card">
                <div class="marketing-running-header">
                    <h3>Chiến Dịch Đang Chạy</h3>
                </div>
                <div class="marketing-running-list">
                    <div class="marketing-running-item">
                        <div class="marketing-running-main">
                            <div class="marketing-running-title">
                                Flash Sale Cuối Tuần
                                <span class="marketing-status-chip is-running">Đang chạy</span>
                            </div>
                            <div class="marketing-running-meta">
                                <span>Doanh thu: 2.5M</span>
                                <span>Đơn hàng: 45</span>
                                <span>Kết thúc: 12/12/2024</span>
                            </div>
                        </div>
                        <button class="btn-address-outline" type="button">Quản lý</button>
                    </div>
                    <div class="marketing-running-item">
                        <div class="marketing-running-main">
                            <div class="marketing-running-title">
                                Voucher Giảm 20%
                                <span class="marketing-status-chip is-running">Đang chạy</span>
                            </div>
                            <div class="marketing-running-meta">
                                <span>Doanh thu: 1.8M</span>
                                <span>Đơn hàng: 32</span>
                                <span>Kết thúc: 15/12/2024</span>
                            </div>
                        </div>
                        <button class="btn-address-outline" type="button">Quản lý</button>
                    </div>
                    <div class="marketing-running-item">
                        <div class="marketing-running-main">
                            <div class="marketing-running-title">
                                Combo Tiết Kiệm
                                <span class="marketing-status-chip is-scheduled">Đã lên lịch</span>
                            </div>
                            <div class="marketing-running-meta">
                                <span>Doanh thu: 0đ</span>
                                <span>Đơn hàng: 0</span>
                                <span>Bắt đầu: 14/12/2024</span>
                            </div>
                        </div>
                        <button class="btn-address-outline" type="button">Chỉnh sửa</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="marketing-view" data-tab="ads">
            <div class="ads-header">
                <div>
                    <h2>Quảng Cáo Lovels</h2>
                    <p>Tạo và quản lý chiến dịch quảng cáo của bạn</p>
                </div>
                <button class="btn-primary-dark" type="button">
                    <i class="fa-solid fa-plus"></i>
                    Tạo Chiến Dịch Mới
                </button>
            </div>

            <div class="ads-stat-grid">
                <div class="card ads-stat-card">
                    <div class="ads-stat-icon is-purple"><i class="fa-solid fa-dollar-sign"></i></div>
                    <div class="ads-stat-label">Tổng Chi Phí</div>
                    <div class="ads-stat-value">14.800.000 đ</div>
                    <div class="ads-stat-sub">Tháng này</div>
                </div>
                <div class="card ads-stat-card">
                    <div class="ads-stat-icon is-blue"><i class="fa-solid fa-eye"></i></div>
                    <div class="ads-stat-label">Lượt Hiển Thị</div>
                    <div class="ads-stat-value">499.000</div>
                    <div class="ads-stat-trend is-up">+24%</div>
                </div>
                <div class="card ads-stat-card">
                    <div class="ads-stat-icon is-orange"><i class="fa-solid fa-location-arrow"></i></div>
                    <div class="ads-stat-label">Lượt Click</div>
                    <div class="ads-stat-value">15.500</div>
                    <div class="ads-stat-trend is-up">+18%</div>
                </div>
                <div class="card ads-stat-card">
                    <div class="ads-stat-icon is-green"><i class="fa-solid fa-cart-shopping"></i></div>
                    <div class="ads-stat-label">Đơn Hàng</div>
                    <div class="ads-stat-value">738</div>
                    <div class="ads-stat-trend is-up">+32%</div>
                </div>
                <div class="card ads-stat-card">
                    <div class="ads-stat-icon is-pink"><i class="fa-solid fa-chart-column"></i></div>
                    <div class="ads-stat-label">ROAS</div>
                    <div class="ads-stat-value">7.6x</div>
                    <div class="ads-stat-sub">Tỷ suất hoàn vốn</div>
                </div>
            </div>

            <div class="card ads-chart-card">
                <div class="ads-chart-head">
                    <h3>Hiệu Quả Quảng Cáo 7 Ngày Qua</h3>
                    <div class="ads-chart-legend">
                        <span class="legend-dot is-blue">Lượt hiển thị</span>
                        <span class="legend-dot is-orange">Lượt click</span>
                        <span class="legend-dot is-green">Đơn hàng</span>
                    </div>
                </div>
                <div class="ads-chart-placeholder">
                    <div class="ads-chart-grid"></div>
                    <div class="ads-chart-line is-impression"></div>
                    <div class="ads-chart-line is-click"></div>
                    <div class="ads-chart-line is-order"></div>
                    <div class="ads-chart-tooltip">
                        <div class="ads-chart-date">07/12</div>
                        <div class="ads-chart-item is-orange">clicks : 720</div>
                        <div class="ads-chart-item is-blue">impressions : 18900</div>
                        <div class="ads-chart-item is-green">orders : 42</div>
                    </div>
                </div>
            </div>

            <div class="card ads-campaign-card">
                <div class="ads-campaign-tabs">
                    <button class="ads-tab is-active" type="button">Tất Cả (4)</button>
                    <button class="ads-tab" type="button">Đang Chạy (2)</button>
                    <button class="ads-tab" type="button">Đã Lên Lịch (1)</button>
                    <button class="ads-tab" type="button">Đã Kết Thúc (1)</button>
                </div>
                <div class="ads-campaign-list">
                    <div class="ads-campaign-item">
                        <div class="ads-campaign-head">
                            <div>
                                <div class="ads-campaign-title">Flash Sale Cuối Tuần - Đồ Lót Giảm 50%</div>
                                <div class="ads-campaign-meta">Mã: ADS001 • 08/12/2024 - 15/12/2024</div>
                            </div>
                            <div class="ads-campaign-actions">
                                <span class="ads-chip is-running">Đang chạy</span>
                                <span class="ads-chip is-purple">Product Ads</span>
                                <button class="ads-icon-btn" type="button"><i class="fa-solid fa-pause"></i></button>
                                <button class="ads-icon-btn" type="button"><i class="fa-solid fa-gear"></i></button>
                            </div>
                        </div>
                        <div class="ads-campaign-metrics">
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Ngân Sách</div>
                                <div class="ads-metric-value">5.000.000 đ</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đã Chi</div>
                                <div class="ads-metric-value">3.200.000 đ</div>
                                <div class="ads-progress"><span style="width:64%"></span></div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Hiển Thị</div>
                                <div class="ads-metric-value">125.000</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Click</div>
                                <div class="ads-metric-value">4.500</div>
                                <div class="ads-metric-sub">CTR: 3.60%</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đơn Hàng</div>
                                <div class="ads-metric-value">187</div>
                                <div class="ads-metric-sub">CVR: 4.16%</div>
                            </div>
                            <div class="ads-metric-card is-highlight">
                                <div class="ads-metric-label">Doanh Thu</div>
                                <div class="ads-metric-value">28.500.000 đ</div>
                                <div class="ads-metric-sub">ROI: 891%</div>
                            </div>
                        </div>
                    </div>

                    <div class="ads-campaign-item">
                        <div class="ads-campaign-head">
                            <div>
                                <div class="ads-campaign-title">Quảng Bá Shop - Tăng Nhận Diện</div>
                                <div class="ads-campaign-meta">Mã: ADS002 • 05/12/2024 - 12/12/2024</div>
                            </div>
                            <div class="ads-campaign-actions">
                                <span class="ads-chip is-running">Đang chạy</span>
                                <span class="ads-chip is-blue">Shop Ads</span>
                                <button class="ads-icon-btn" type="button"><i class="fa-solid fa-pause"></i></button>
                                <button class="ads-icon-btn" type="button"><i class="fa-solid fa-gear"></i></button>
                            </div>
                        </div>
                        <div class="ads-campaign-metrics">
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Ngân Sách</div>
                                <div class="ads-metric-value">3.000.000 đ</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đã Chi</div>
                                <div class="ads-metric-value">1.800.000 đ</div>
                                <div class="ads-progress"><span style="width:60%"></span></div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Hiển Thị</div>
                                <div class="ads-metric-value">89.000</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Click</div>
                                <div class="ads-metric-value">2.100</div>
                                <div class="ads-metric-sub">CTR: 2.36%</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đơn Hàng</div>
                                <div class="ads-metric-value">95</div>
                                <div class="ads-metric-sub">CVR: 4.52%</div>
                            </div>
                            <div class="ads-metric-card is-highlight">
                                <div class="ads-metric-label">Doanh Thu</div>
                                <div class="ads-metric-value">14.200.000 đ</div>
                                <div class="ads-metric-sub">ROI: 789%</div>
                            </div>
                        </div>
                    </div>

                    <div class="ads-campaign-item">
                        <div class="ads-campaign-head">
                            <div>
                                <div class="ads-campaign-title">Banner Trang Chủ - Bộ Sưu Tập Mới</div>
                                <div class="ads-campaign-meta">Mã: ADS003 • 15/12/2024 - 22/12/2024</div>
                            </div>
                            <div class="ads-campaign-actions">
                                <span class="ads-chip is-scheduled">Đã lên lịch</span>
                                <span class="ads-chip is-orange">Display Banner</span>
                                <button class="ads-icon-btn is-play" type="button"><i class="fa-solid fa-play"></i></button>
                                <button class="ads-icon-btn" type="button"><i class="fa-solid fa-gear"></i></button>
                            </div>
                        </div>
                        <div class="ads-campaign-metrics">
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Ngân Sách</div>
                                <div class="ads-metric-value">8.000.000 đ</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đã Chi</div>
                                <div class="ads-metric-value">0 đ</div>
                                <div class="ads-progress"><span style="width:0%"></span></div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Hiển Thị</div>
                                <div class="ads-metric-value">0</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Click</div>
                                <div class="ads-metric-value">0</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đơn Hàng</div>
                                <div class="ads-metric-value">0</div>
                            </div>
                            <div class="ads-metric-card is-highlight">
                                <div class="ads-metric-label">Doanh Thu</div>
                                <div class="ads-metric-value">0 đ</div>
                            </div>
                        </div>
                    </div>

                    <div class="ads-campaign-item">
                        <div class="ads-campaign-head">
                            <div>
                                <div class="ads-campaign-title">Khuyến Mãi Black Friday</div>
                                <div class="ads-campaign-meta">Mã: ADS004 • 25/11/2024 - 30/11/2024</div>
                            </div>
                            <div class="ads-campaign-actions">
                                <span class="ads-chip is-ended">Đã kết thúc</span>
                                <span class="ads-chip is-purple">Product Ads</span>
                                <button class="ads-icon-btn" type="button"><i class="fa-solid fa-gear"></i></button>
                            </div>
                        </div>
                        <div class="ads-campaign-metrics">
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Ngân Sách</div>
                                <div class="ads-metric-value">10.000.000 đ</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đã Chi</div>
                                <div class="ads-metric-value">9.800.000 đ</div>
                                <div class="ads-progress"><span style="width:98%"></span></div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Hiển Thị</div>
                                <div class="ads-metric-value">285.000</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Click</div>
                                <div class="ads-metric-value">8.900</div>
                                <div class="ads-metric-sub">CTR: 3.12%</div>
                            </div>
                            <div class="ads-metric-card">
                                <div class="ads-metric-label">Đơn Hàng</div>
                                <div class="ads-metric-value">456</div>
                                <div class="ads-metric-sub">CVR: 5.12%</div>
                            </div>
                            <div class="ads-metric-card is-highlight">
                                <div class="ads-metric-label">Doanh Thu</div>
                                <div class="ads-metric-value">68.400.000 đ</div>
                                <div class="ads-metric-sub">ROI: 698%</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ads-info-grid">
                <div class="card ads-info-card">
                    <div class="ads-info-icon is-purple"><i class="fa-solid fa-bullhorn"></i></div>
                    <div class="ads-info-title">Quảng Cáo Sản Phẩm</div>
                    <p>Quảng bá sản phẩm cụ thể đến khách hàng tiềm năng. Hiển thị trong kết quả tìm kiếm và trang danh mục.</p>
                    <a class="ads-info-link" href="javascript:void(0)">Tìm hiểu thêm →</a>
                </div>
                <div class="card ads-info-card">
                    <div class="ads-info-icon is-blue"><i class="fa-solid fa-chart-line"></i></div>
                    <div class="ads-info-title">Quảng Cáo Shop</div>
                    <p>Tăng nhận diện thương hiệu và thu hút khách hàng đến shop của bạn. Hiển thị ở nhiều vị trí nổi bật.</p>
                    <a class="ads-info-link" href="javascript:void(0)">Tìm hiểu thêm →</a>
                </div>
                <div class="card ads-info-card">
                    <div class="ads-info-icon is-orange"><i class="fa-solid fa-eye"></i></div>
                    <div class="ads-info-title">Banner Hiển Thị</div>
                    <p>Đặt banner tại vị trí đắc địa trên trang chủ, trang danh mục. Tăng độ phủ sóng tối đa.</p>
                    <a class="ads-info-link" href="javascript:void(0)">Tìm hiểu thêm →</a>
                </div>
            </div>
        </div>

        <div class="marketing-view" data-tab="flash">
            <div class="flash-header">
                <div>
                    <h2>Chiến Dịch Flash Sale</h2>
                    <p>Tạo chương trình giảm giá trong thời gian ngắn để thu hút khách hàng</p>
                </div>
                <button class="btn-flash-create" type="button">
                    <i class="fa-solid fa-plus"></i>
                    Tạo Flash Sale Mới
                </button>
            </div>

            <div class="flash-stat-grid">
                <div class="flash-stat-card is-highlight">
                    <div class="flash-stat-icon"><i class="fa-solid fa-bolt"></i></div>
                    <div class="flash-stat-label">Tổng Flash Sale</div>
                    <div class="flash-stat-value">8</div>
                </div>
                <div class="card flash-stat-card">
                    <div class="flash-stat-icon is-green"><i class="fa-solid fa-dollar-sign"></i></div>
                    <div class="flash-stat-label">Doanh Thu FS</div>
                    <div class="flash-stat-value">132.000.000 đ</div>
                </div>
                <div class="card flash-stat-card">
                    <div class="flash-stat-icon is-blue"><i class="fa-solid fa-box"></i></div>
                    <div class="flash-stat-label">Đã Bán</div>
                    <div class="flash-stat-value">801</div>
                </div>
                <div class="card flash-stat-card">
                    <div class="flash-stat-icon is-purple"><i class="fa-solid fa-user-group"></i></div>
                    <div class="flash-stat-label">Lượt Xem</div>
                    <div class="flash-stat-value">57.5K</div>
                </div>
            </div>

            <div class="card flash-campaign-card">
                <div class="flash-tabs">
                    <button class="flash-tab is-active" type="button">Đang Diễn Ra (1)</button>
                    <button class="flash-tab" type="button">Sắp Diễn Ra (1)</button>
                    <button class="flash-tab" type="button">Đã Kết Thúc (1)</button>
                </div>
                <div class="flash-campaign-list">
                    <div class="flash-campaign-item">
                        <div class="flash-campaign-head">
                            <div class="flash-campaign-title">
                                <span class="flash-icon"><i class="fa-solid fa-bolt"></i></span>
                                Flash Sale Cuối Tuần - Giảm Sốc 50%
                            </div>
                            <div class="flash-campaign-actions">
                                <span class="flash-status-chip is-running">Đang diễn ra</span>
                                <button class="btn-outline-dark" type="button">Xem Chi Tiết</button>
                            </div>
                        </div>
                        <div class="flash-campaign-meta">
                            <span><i class="fa-regular fa-clock"></i> 10/12/2024 20:00 - 12/12/2024 23:59</span>
                            <span class="flash-tag">Giảm 50%</span>
                        </div>
                        <div class="flash-metric-grid">
                            <div class="flash-metric-card">
                                <div class="flash-metric-label">Sản Phẩm</div>
                                <div class="flash-metric-value">15</div>
                            </div>
                            <div class="flash-metric-card">
                                <div class="flash-metric-label">Đã Bán</div>
                                <div class="flash-metric-value is-green">234</div>
                            </div>
                            <div class="flash-metric-card">
                                <div class="flash-metric-label">Doanh Thu</div>
                                <div class="flash-metric-value">42.500.000 đ</div>
                            </div>
                            <div class="flash-metric-card">
                                <div class="flash-metric-label">Lượt Xem</div>
                                <div class="flash-metric-value">12.500</div>
                            </div>
                            <div class="flash-metric-card">
                                <div class="flash-metric-label">Tồn Kho</div>
                                <div class="flash-metric-value">156</div>
                            </div>
                        </div>
                        <div class="flash-progress">
                            <div class="flash-progress-label">
                                <span>Tiến độ bán hàng</span>
                                <span>60%</span>
                            </div>
                            <div class="flash-progress-bar">
                                <span style="width:60%"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flash-tip-card">
                <div class="flash-tip-title">
                    <i class="fa-regular fa-lightbulb"></i>
                    Mẹo Để Flash Sale Thành Công
                </div>
                <div class="flash-tip-grid">
                    <div class="flash-tip-item">Chọn sản phẩm bán chạy để tạo hiệu ứng viral</div>
                    <div class="flash-tip-item">Giảm giá 40-60% để thu hút sự chú ý</div>
                    <div class="flash-tip-item">Thời gian ngắn (2-6 giờ) tạo cảm giác khan hiếm</div>
                    <div class="flash-tip-item">Chuẩn bị đủ tồn kho trước khi bắt đầu</div>
                </div>
            </div>
        </div>
        <div class="marketing-view" data-tab="voucher">
            <div class="voucher-header">
                <div>
                    <h2>Mã Giảm Giá Của Shop</h2>
                    <p>Tạo và quản lý voucher để thu hút khách hàng</p>
                </div>
                <asp:Button ID="OpenVoucherModalButton" runat="server" CssClass="btn-voucher-create" Text="+ Tạo Mã Giảm Giá" OnClick="OpenVoucherModalButton_Click" UseSubmitBehavior="false" />
            </div>

            <div class="voucher-stat-grid">
                <div class="card voucher-stat-card">
                    <div class="voucher-stat-icon is-purple"><i class="fa-solid fa-percent"></i></div>
                    <div class="voucher-stat-label">Tổng Voucher</div>
                    <div class="voucher-stat-value"><asp:Literal ID="VoucherTotalLiteral" runat="server" /></div>
                </div>
                <div class="card voucher-stat-card">
                    <div class="voucher-stat-icon is-green"><i class="fa-solid fa-user-group"></i></div>
                    <div class="voucher-stat-label">Lượt Sử Dụng</div>
                    <div class="voucher-stat-value"><asp:Literal ID="VoucherUsageLiteral" runat="server" /></div>
                </div>
                <div class="card voucher-stat-card">
                    <div class="voucher-stat-icon is-blue"><i class="fa-solid fa-cart-shopping"></i></div>
                    <div class="voucher-stat-label">Đơn Hàng</div>
                    <div class="voucher-stat-value"><asp:Literal ID="VoucherOrderLiteral" runat="server" /></div>
                </div>
                <div class="card voucher-stat-card">
                    <div class="voucher-stat-icon is-orange"><i class="fa-solid fa-dollar-sign"></i></div>
                    <div class="voucher-stat-label">Doanh Thu</div>
                    <div class="voucher-stat-value"><asp:Literal ID="VoucherRevenueLiteral" runat="server" /></div>
                </div>
            </div>

            <div class="card voucher-list-card">
                <div class="voucher-tabs">
                    <asp:Button ID="TabActiveButton" runat="server" CssClass="voucher-tab" Text="Đang Hoạt Động" OnClick="TabButton_Click" CommandArgument="active" UseSubmitBehavior="false" />
                    <asp:Button ID="TabScheduledButton" runat="server" CssClass="voucher-tab" Text="Đã Lên Lịch" OnClick="TabButton_Click" CommandArgument="scheduled" UseSubmitBehavior="false" />
                    <asp:Button ID="TabExpiredButton" runat="server" CssClass="voucher-tab" Text="Đã Hết Hạn" OnClick="TabButton_Click" CommandArgument="expired" UseSubmitBehavior="false" />
                </div>
                <div class="voucher-list">
                    <asp:Repeater ID="VoucherRepeater" runat="server" OnItemCommand="VoucherRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="voucher-item">
                                <div class="voucher-info">
                                    <div class="voucher-badge">%<br /><span><%# Eval("BadgeText") %></span></div>
                                    <div>
                                        <div class="voucher-title">
                                            <%# Eval("Title") %>
                                            <span class="voucher-chip is-running"><%# Eval("StatusText") %></span>
                                            <span class="voucher-chip"><%# Eval("TypeText") %></span>
                                        </div>
                                        <div class="voucher-code-row">
                                            <span class="voucher-code"><%# Eval("Code") %></span>
                                            <span><%# Eval("DateText") %></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="voucher-actions">
                                    <asp:LinkButton ID="EditVoucherButton" runat="server" CssClass="voucher-icon-btn" CommandName="Edit" CommandArgument='<%# Eval("Id") %>' CausesValidation="false">✎</asp:LinkButton>
                                </div>
                                <div class="voucher-metrics">
                                    <div><div class="voucher-metric-label">Đơn tối thiểu</div><div class="voucher-metric-value"><%# Eval("MinOrderText") %></div></div>
                                    <div><div class="voucher-metric-label">Giảm tối đa</div><div class="voucher-metric-value"><%# Eval("MaxDiscountText") %></div></div>
                                    <div><div class="voucher-metric-label">Đã dùng</div><div class="voucher-metric-value is-green"><%# Eval("UsedText") %></div></div>
                                    <div><div class="voucher-metric-label">Còn lại</div><div class="voucher-metric-value"><%# Eval("RemainingText") %></div></div>
                                    <div><div class="voucher-metric-label">Doanh thu</div><div class="voucher-metric-value"><%# Eval("RevenueText") %></div></div>
                                </div>
                                <div class="voucher-progress"><span style='width:<%# Eval("ProgressPercent") %>%'></span></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="voucher-tip-card">
                <div class="voucher-tip-title">
                    <i class="fa-regular fa-lightbulb"></i>
                    Gợi Ý Tạo Voucher Hiệu Quả
                </div>
                <div class="voucher-tip-grid">
                    <div class="voucher-tip-item">Voucher giảm % phù hợp cho đơn giá trị cao</div>
                    <div class="voucher-tip-item">Mã giảm cố định để thu hút khách hàng mới</div>
                    <div class="voucher-tip-item">Freeship tăng tỷ lệ chuyển đổi đơn hàng</div>
                    <div class="voucher-tip-item">Giới hạn số lượng tạo cảm giác khan hiếm</div>
                </div>
            </div>

            <asp:Panel ID="VoucherModalPanel" runat="server" CssClass="voucher-modal-overlay" Visible="false">
                <div class="voucher-modal">
                    <h3><asp:Literal ID="VoucherModalTitleLiteral" runat="server" /></h3>
                    <div class="voucher-form-grid">
                        <div class="voucher-field"><asp:TextBox ID="VoucherCodeInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherCodeInput">Mã voucher</label></div>
                        <div class="voucher-field"><asp:TextBox ID="VoucherNameInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherNameInput">Tên voucher</label></div>
                        <div class="voucher-field voucher-field-full"><asp:TextBox ID="VoucherDescriptionInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherDescriptionInput">Mô tả</label></div>
                        <div class="voucher-field voucher-field-full"><asp:DropDownList ID="VoucherTypeInput" runat="server" CssClass="voucher-input" AutoPostBack="true" OnSelectedIndexChanged="VoucherTypeInput_SelectedIndexChanged"><asp:ListItem Value="Percent">Giảm %</asp:ListItem><asp:ListItem Value="Fixed">Giảm cố định</asp:ListItem></asp:DropDownList><label class="is-fixed">Loại giảm</label></div>
                        <asp:Panel ID="VoucherValueWrap" runat="server" CssClass="voucher-field voucher-field-full"><asp:TextBox ID="VoucherValueInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherValueInput">Giá trị giảm (%)</label></asp:Panel>
                        <div class="voucher-field"><asp:TextBox ID="VoucherMinOrderInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherMinOrderInput">Đơn tối thiểu</label></div>
                        <div class="voucher-field"><asp:TextBox ID="VoucherMaxDiscountInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherMaxDiscountInput">Giảm tối đa</label></div>
                        <div class="voucher-field"><asp:TextBox ID="VoucherUsageLimitInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherUsageLimitInput">Giới hạn lượt dùng</label></div>
                        <div class="voucher-field"><asp:TextBox ID="VoucherUsagePerUserInput" runat="server" CssClass="voucher-input" placeholder=" " /><label for="MainContent_VoucherUsagePerUserInput">Giới hạn / người dùng</label></div>
                        <div class="voucher-field"><asp:TextBox ID="VoucherStartAtInput" runat="server" CssClass="voucher-input" placeholder=" " TextMode="Date" /><label for="MainContent_VoucherStartAtInput">Ngày bắt đầu</label></div>
                        <div class="voucher-field"><asp:TextBox ID="VoucherEndAtInput" runat="server" CssClass="voucher-input" placeholder=" " TextMode="Date" /><label for="MainContent_VoucherEndAtInput">Ngày kết thúc</label></div>
                    </div>
                    <asp:Literal ID="VoucherFormErrorLiteral" runat="server" />
                    <asp:HiddenField ID="EditingVoucherIdHidden" runat="server" />
                    <div class="voucher-modal-actions">
                        <asp:Button ID="CloseVoucherModalButton" runat="server" CssClass="btn-address-outline" Text="Hủy" OnClick="CloseVoucherModalButton_Click" UseSubmitBehavior="false" />
                        <asp:Button ID="SaveVoucherButton" runat="server" CssClass="btn-voucher-create" Text="Lưu voucher" OnClick="SaveVoucherButton_Click" UseSubmitBehavior="false" />
                    </div>
                </div>
            </asp:Panel>
            <asp:Literal ID="ToastMessageLiteral" runat="server" />
            <div id="ToastHost" class="toast-host"></div>
        </div>

        <div class="marketing-view" data-tab="addon">
            <div class="addon-header">
                <div>
                    <h2>Gian Hàng Add-on</h2>
                    <p>Mở rộng tính năng shop với các công cụ chuyên nghiệp</p>
                </div>
            </div>

            <div class="addon-hero">
                <div class="addon-hero-content">
                    <div class="addon-hero-title">
                        <i class="fa-solid fa-rocket"></i>
                        Nâng Cấp Shop Của Bạn
                    </div>
                    <p>Khám phá các công cụ và tiện ích giúp tăng doanh số, tự động hóa vận hành và nâng cao trải nghiệm khách hàng</p>
                    <div class="addon-hero-stats">
                        <div>
                            <div class="addon-hero-value">50+</div>
                            <div class="addon-hero-label">Add-ons khả dụng</div>
                        </div>
                        <div>
                            <div class="addon-hero-value">10K+</div>
                            <div class="addon-hero-label">Seller đang dùng</div>
                        </div>
                        <div>
                            <div class="addon-hero-value">4.7★</div>
                            <div class="addon-hero-label">Đánh giá TB</div>
                        </div>
                    </div>
                </div>
                <div class="addon-hero-badge">
                    <i class="fa-solid fa-puzzle-piece"></i>
                </div>
            </div>

            <div class="addon-installed">
                <h3>Add-on Đã Cài Đặt</h3>
                <div class="addon-installed-card">
                    <div class="addon-installed-icon"><i class="fa-solid fa-chart-line"></i></div>
                    <div class="addon-installed-info">
                        <div class="addon-installed-title">Phân Tích Nâng Cao</div>
                        <p>Dashboard phân tích chuyên sâu với AI dự đoán xu hướng bán hàng</p>
                        <button class="btn-outline-dark" type="button">Cài Đặt</button>
                    </div>
                    <span class="addon-status-chip">Đang dùng</span>
                </div>
            </div>

            <div class="addon-filter-tabs">
                <button class="addon-filter is-active" type="button">Tất Cả</button>
                <button class="addon-filter" type="button">Phổ Biến</button>
                <button class="addon-filter" type="button">Marketing</button>
                <button class="addon-filter" type="button">Phân Tích</button>
                <button class="addon-filter" type="button">Bán Hàng</button>
                <button class="addon-filter" type="button">Vận Hành</button>
            </div>

            <div class="addon-card-grid">
                <div class="addon-card is-featured">
                    <span class="addon-tag">★ Phổ biến</span>
                    <div class="addon-card-head">
                        <div class="addon-card-icon is-pink"><i class="fa-solid fa-comment-dots"></i></div>
                        <div>
                            <div class="addon-card-title">Trợ Lý AI Bán Hàng</div>
                            <div class="addon-card-rating">★ 4.8 • 2.5K+ users</div>
                        </div>
                    </div>
                    <p>Chatbot AI tự động tư vấn khách hàng 24/7, tăng tỷ lệ chuyển đổi</p>
                    <div class="addon-card-features">
                        <span>• Tự động trả lời</span>
                        <span>• Học từ dữ liệu shop</span>
                        <span>• Đa ngôn ngữ</span>
                    </div>
                    <div class="addon-card-footer">
                        <div>
                            <div class="addon-card-price">500.000 đ</div>
                            <div class="addon-card-period">/tháng</div>
                        </div>
                        <button class="btn-primary-dark" type="button">Cài Đặt</button>
                    </div>
                </div>

                <div class="addon-card">
                    <div class="addon-card-head">
                        <div class="addon-card-icon is-gray"><i class="fa-solid fa-video"></i></div>
                        <div>
                            <div class="addon-card-title">Livestream Pro</div>
                            <div class="addon-card-rating">★ 4.7 • 3.2K+ users</div>
                        </div>
                    </div>
                    <p>Công cụ livestream chuyên nghiệp với hiệu ứng và tính năng tương tác</p>
                    <div class="addon-card-features">
                        <span>• Hiệu ứng pro</span>
                        <span>• Multi-stream</span>
                        <span>• Analytics realtime</span>
                    </div>
                    <div class="addon-card-footer">
                        <div>
                            <div class="addon-card-price">400.000 đ</div>
                            <div class="addon-card-period">/tháng</div>
                        </div>
                        <button class="btn-primary-dark" type="button">Cài Đặt</button>
                    </div>
                </div>

                <div class="addon-card">
                    <div class="addon-card-head">
                        <div class="addon-card-icon is-yellow"><i class="fa-solid fa-bolt"></i></div>
                        <div>
                            <div class="addon-card-title">Email Marketing Plus</div>
                            <div class="addon-card-rating">★ 4.5 • 1.2K+ users</div>
                        </div>
                    </div>
                    <p>Gửi email marketing tự động với template đẹp và theo dõi hiệu quả</p>
                    <div class="addon-card-features">
                        <span>• 10K email/tháng</span>
                        <span>• Auto campaign</span>
                        <span>• A/B testing</span>
                    </div>
                    <div class="addon-card-footer">
                        <div>
                            <div class="addon-card-price">250.000 đ</div>
                            <div class="addon-card-period">/tháng</div>
                        </div>
                        <button class="btn-primary-dark" type="button">Cài Đặt</button>
                    </div>
                </div>

                <div class="addon-card">
                    <div class="addon-card-head">
                        <div class="addon-card-icon is-gray"><i class="fa-solid fa-shield-halved"></i></div>
                        <div>
                            <div class="addon-card-title">Bảo Vệ Thương Hiệu</div>
                            <div class="addon-card-rating">★ 4.9 • 850+ users</div>
                        </div>
                    </div>
                    <p>Phát hiện và xử lý hàng giả, bảo vệ uy tín thương hiệu</p>
                    <div class="addon-card-features">
                        <span>• Scan hàng giả</span>
                        <span>• Báo cáo vi phạm</span>
                        <span>• Hỗ trợ pháp lý</span>
                    </div>
                    <div class="addon-card-footer">
                        <div>
                            <div class="addon-card-price">600.000 đ</div>
                            <div class="addon-card-period">/tháng</div>
                        </div>
                        <button class="btn-primary-dark" type="button">Cài Đặt</button>
                    </div>
                </div>

                <div class="addon-card">
                    <div class="addon-card-head">
                        <div class="addon-card-icon is-gray"><i class="fa-solid fa-arrow-trend-up"></i></div>
                        <div>
                            <div class="addon-card-title">Quản Lý Kho Thông Minh</div>
                            <div class="addon-card-rating">★ 4.4 • 920+ users</div>
                        </div>
                    </div>
                    <p>Tự động dự báo nhu cầu và đề xuất nhập hàng tối ưu</p>
                    <div class="addon-card-features">
                        <span>• Dự báo nhu cầu</span>
                        <span>• Cảnh báo tồn kho</span>
                        <span>• Tích hợp NCC</span>
                    </div>
                    <div class="addon-card-footer">
                        <div>
                            <div class="addon-card-price">350.000 đ</div>
                            <div class="addon-card-period">/tháng</div>
                        </div>
                        <button class="btn-primary-dark" type="button">Cài Đặt</button>
                    </div>
                </div>
            </div>

            <div class="addon-request-card">
                <div class="addon-request-text">
                    <div class="addon-request-title">
                        <i class="fa-regular fa-lightbulb"></i>
                        Không Tìm Thấy Add-on Phù Hợp?
                    </div>
                    <p>Gửi yêu cầu để chúng tôi phát triển add-on mới theo nhu cầu của bạn</p>
                </div>
                <button class="btn-primary-dark" type="button">Gửi Yêu Cầu</button>
            </div>
        </div>
    </div>

    <script>
        (function () {
            function showToast(message, type) {
                var host = document.getElementById("ToastHost");
                if (!host) return;
                var toast = document.createElement("div");
                var tone = (type || "success").toLowerCase();
                toast.className = "toast-message " + tone;
                var title = tone === "error" ? "Lỗi" : "Thành công";
                toast.innerHTML = '<div class="toast-accent"></div>'
                    + '<div class="toast-body">'
                    + '<div class="toast-title">' + title + '</div>'
                    + '<div class="toast-text">' + (message || "") + '</div>'
                    + '</div>'
                    + '<button type="button" class="toast-close" aria-label="Close">&times;</button>';
                host.appendChild(toast);
                setTimeout(function () {
                    toast.classList.add("show");
                }, 10);
                var closeBtn = toast.querySelector(".toast-close");
                if (closeBtn) {
                    closeBtn.addEventListener("click", function () {
                        toast.classList.remove("show");
                        setTimeout(function () {
                            if (toast && toast.parentNode) {
                                toast.parentNode.removeChild(toast);
                            }
                        }, 200);
                    });
                }
                setTimeout(function () {
                    toast.classList.remove("show");
                    setTimeout(function () {
                        if (toast && toast.parentNode) {
                            toast.parentNode.removeChild(toast);
                        }
                    }, 300);
                }, 2600);
            }
            window.SellerToast = { show: showToast };
        })();
        (function () {
            var page = document.querySelector('[data-marketing-page="true"]');
            if (!page) return;
            var params = new URLSearchParams(window.location.search);
            var tab = (params.get('tab') || 'my').toLowerCase();
            var views = page.querySelectorAll('.marketing-view');
            views.forEach(function (view) {
                view.style.display = view.getAttribute('data-tab') === tab ? '' : 'none';
            });
        })();
    </script>
</asp:Content>
