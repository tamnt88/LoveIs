<%@ Page Language="C#" AutoEventWireup="true" CodeFile="review-shops.aspx.cs" Inherits="SellerShopReviews" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">ShopReviews</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-shop-reviews">
        <div class="shop-reviews-main">
            <div class="reviews-header">
                <div>
                    <h2>Đánh Giá Shop</h2>
                    <p>Xem và quản lý đánh giá chung về shop của bạn</p>
                </div>
            </div>

            <div class="shop-summary-grid">
                <div class="card shop-score-card">
                    <div class="shop-score-left">
                        <div class="shop-score-line">
                            <div class="shop-score-value">4.7</div>
                            <div class="shop-score-total">/5</div>
                        </div>
                        <div class="review-stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star-half-stroke"></i>
                        </div>
                        <div class="shop-score-count">12 đánh giá</div>
                    </div>
                    <div class="shop-score-bars">
                        <div class="shop-score-row">
                            <span>5 ★</span>
                            <div class="shop-score-track"><span style="width: 72%"></span></div>
                            <span>9</span>
                        </div>
                        <div class="shop-score-row">
                            <span>4 ★</span>
                            <div class="shop-score-track"><span style="width: 30%"></span></div>
                            <span>2</span>
                        </div>
                        <div class="shop-score-row">
                            <span>3 ★</span>
                            <div class="shop-score-track"><span style="width: 12%"></span></div>
                            <span>1</span>
                        </div>
                        <div class="shop-score-row">
                            <span>2 ★</span>
                            <div class="shop-score-track"><span style="width: 4%"></span></div>
                            <span>0</span>
                        </div>
                        <div class="shop-score-row">
                            <span>1 ★</span>
                            <div class="shop-score-track"><span style="width: 2%"></span></div>
                            <span>0</span>
                        </div>
                    </div>
                </div>

                <div class="shop-metric-stack">
                    <div class="card shop-metric-card">
                        <div class="shop-metric-icon icon-blue"><i class="fa-solid fa-box"></i></div>
                        <div>
                            <div class="shop-metric-label">Chất lượng sản phẩm</div>
                            <div class="shop-metric-line">
                                <div class="shop-metric-value">4.8</div>
                                <div class="review-stars small">
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card shop-metric-card">
                        <div class="shop-metric-icon icon-orange"><i class="fa-solid fa-truck-fast"></i></div>
                        <div>
                            <div class="shop-metric-label">Giao hàng</div>
                            <div class="shop-metric-line">
                                <div class="shop-metric-value">4.6</div>
                                <div class="review-stars small">
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="shop-metric-stack">
                    <div class="card shop-metric-card">
                        <div class="shop-metric-icon icon-green"><i class="fa-solid fa-certificate"></i></div>
                        <div>
                            <div class="shop-metric-label">Đúng với mô tả</div>
                            <div class="shop-metric-line">
                                <div class="shop-metric-value">4.8</div>
                                <div class="review-stars small">
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card shop-metric-card">
                        <div class="shop-metric-icon icon-purple"><i class="fa-solid fa-headset"></i></div>
                        <div>
                            <div class="shop-metric-label">Dịch vụ</div>
                            <div class="shop-metric-line">
                                <div class="shop-metric-value">4.8</div>
                                <div class="review-stars small">
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card review-panel">
                <div class="review-tabs">
                    <a class="review-tab active" href="#"><asp:Literal ID="TotalCountLiteral" runat="server" /></a>
                    <a class="review-tab" href="#"><asp:Literal ID="NeedReplyLiteral" runat="server" /></a>
                    <a class="review-tab" href="#"><asp:Literal ID="RepliedLiteral" runat="server" /></a>
                </div>
                <div class="review-filters">
                    <div class="review-pill-row">
                        <span class="review-pill-label">Số sao đánh giá:</span>
                        <button class="review-pill active" type="button"><asp:Literal ID="RatingAllLiteral" runat="server" /></button>
                        <button class="review-pill" type="button"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating5Literal" runat="server" /></button>
                        <button class="review-pill" type="button"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating4Literal" runat="server" /></button>
                        <button class="review-pill" type="button"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating3Literal" runat="server" /></button>
                        <button class="review-pill" type="button"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating2Literal" runat="server" /></button>
                        <button class="review-pill" type="button"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating1Literal" runat="server" /></button>
                    </div>
                    <div class="review-toolbar">
                        <div class="review-search">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" placeholder="Tìm kiếm theo tên người mua, nội dung đánh giá..." />
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shop-review-list">
                <asp:Repeater ID="ShopReviewRepeater" runat="server">
                    <ItemTemplate>
                        <div class="shop-review-item">
                            <div class="shop-review-head">
                                <div class="review-avatar">
                                    <img src="<%# Eval("BuyerAvatarUrl") %>" alt="Avatar" />
                                </div>
                                <div>
                                    <div class="shop-review-name"><%# Eval("BuyerName") %></div>
                                    <div class="shop-review-meta">Đã mua <%# Eval("OrderCount") %> lần</div>
                                </div>
                                <div class="shop-review-time"><%# Eval("CreatedAtLabel") %></div>
                            </div>
                            <div class="review-stars small"><%# RenderStars((int)Eval("Rating"), "small") %></div>
                            <div class="shop-review-content"><%# Eval("Content") %></div>
                            <div class="shop-review-tags">
                                <div>
                                    <div class="tag-title">Chất lượng SP</div>
                                    <div class="tag-stars"><i class="fa-solid fa-star"></i> <%# Eval("QualityRating") %></div>
                                </div>
                                <div>
                                    <div class="tag-title">Đúng mô tả</div>
                                    <div class="tag-stars"><i class="fa-solid fa-star"></i> <%# Eval("DescriptionRating") %></div>
                                </div>
                                <div>
                                    <div class="tag-title">Giao hàng</div>
                                    <div class="tag-stars"><i class="fa-solid fa-star"></i> <%# Eval("ShippingRating") %></div>
                                </div>
                                <div>
                                    <div class="tag-title">Dịch vụ</div>
                                    <div class="tag-stars"><i class="fa-solid fa-star"></i> <%# Eval("ServiceRating") %></div>
                                </div>
                            </div>
                            <div class="review-helpful">
                                <i class="fa-regular fa-thumbs-up"></i>
                                Hữu ích (<%# Eval("HelpfulCount") %>)
                            </div>
                            <asp:PlaceHolder ID="ReplyHolder" runat="server" Visible='<%# Eval("HasReply") %>'>
                                <div class="review-reply">
                                    <div class="review-reply-title">Phản hồi của Shop</div>
                                    <div><%# Eval("ReplyContent") %></div>
                                </div>
                            </asp:PlaceHolder>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="seller-pagination">
                <div class="pagination-info"><asp:Literal ID="PaginationInfoLiteral" runat="server" /></div>
                <div class="pagination-links"><asp:Literal ID="PaginationLiteral" runat="server" /></div>
            </div>
        </div>

        <aside class="reviews-aside">
            <h3>Thông tin đánh giá shop</h3>
            <div class="shop-info-card">
                <div class="shop-info-head">
                    <span class="shop-info-icon"><i class="fa-solid fa-chart-line"></i></span>
                    <div>
                        <div class="shop-info-title">Tăng đánh giá shop</div>
                        <div class="shop-info-desc">Shop có đánh giá tốt sẽ tăng độ tin cậy và thu hút nhiều khách hàng hơn!</div>
                    </div>
                </div>
                <button class="review-tool-btn" type="button">Xem cách cải thiện</button>
            </div>

            <div class="shop-stat-card">
                <div class="shop-stat-title"><i class="fa-solid fa-chart-column"></i> Thống kê 30 ngày</div>
                <div class="shop-stat-row"><span>Đánh giá mới:</span><strong>↑ 12%</strong></div>
                <div class="shop-stat-row"><span>Điểm trung bình:</span><strong>↑ 0.2</strong></div>
                <div class="shop-stat-row"><span>Tỷ lệ 5 sao:</span><strong>75%</strong></div>
            </div>

            <div class="shop-tip-card">
                <div class="review-tip-title"><i class="fa-regular fa-lightbulb"></i> Mẹo quản lý đánh giá</div>
                <ul>
                    <li>Trả lời mọi đánh giá để tăng uy tín</li>
                    <li>Xử lý đánh giá tiêu cực chuyên nghiệp</li>
                    <li>Cảm ơn khách đánh giá tích cực</li>
                    <li>Học hỏi từ phản hồi để cải thiện</li>
                    <li>Theo dõi xu hướng đánh giá định kỳ</li>
                </ul>
            </div>
        </aside>
    </div>
</asp:Content>
