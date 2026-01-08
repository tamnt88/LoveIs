<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-reviews.aspx.cs" Inherits="SellerProductReviews" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">SellerReviews</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-reviews">
        <div class="reviews-main">
            <div class="reviews-header">
                <div>
                    <h2>Quản lý đánh giá</h2>
                    <p>Quản lý và phản hồi đánh giá từ khách hàng</p>
                </div>
            </div>

            <div class="review-summary-grid">
                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Đánh Giá Shop</div>
                        <div class="review-score">
                            <span class="review-score-value">4.6</span>
                            <span class="review-score-total">/5</span>
                        </div>
                        <div class="review-stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star-half-stroke"></i>
                        </div>
                    </div>
                </div>

                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Tổng lượt đánh giá</div>
                        <div class="review-value">12</div>
                        <div class="review-trend up">so với 30 ngày trước: ↑ 12%</div>
                    </div>
                </div>

                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Tỷ lệ đánh giá đơn hàng</div>
                        <div class="review-value">8%</div>
                        <div class="review-trend up">so với 30 ngày trước: ↑ 5%</div>
                    </div>
                </div>

                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Tỷ lệ đánh giá tốt</div>
                        <div class="review-value">92%</div>
                        <div class="review-trend down">so với 30 ngày trước: ↓ 2%</div>
                    </div>
                </div>
            </div>

            <div class="review-mini-grid">
                <div class="card review-mini-card">
                    <div class="review-mini-head">
                        <div class="review-mini-title">Đánh giá tốt cụ thể sản phẩm nổi</div>
                        <a class="review-mini-link" href="#">Xem →</a>
                    </div>
                    <div class="review-mini-value">0</div>
                    <div class="review-mini-desc">Các đánh giá có 4 &amp; 5 sao có bình luận hoặc hình ảnh</div>
                </div>
                <div class="card review-mini-card">
                    <div class="review-mini-head">
                        <div class="review-mini-title">Đánh giá gần đây</div>
                        <a class="review-mini-link" href="#">Xem →</a>
                    </div>
                    <div class="review-mini-value">0</div>
                    <div class="review-mini-desc">Đánh giá mới nhất cập nhật trong vòng dưới 48h</div>
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
                            <input type="text" placeholder="Tìm kiếm: Tên sản phẩm, Mã đơn hàng, Tên đăng nhập người mua..." />
                        </div>
                        <div class="review-select">
                            <select>
                                <option>Thời gian đánh giá</option>
                            </select>
                            <i class="fa-solid fa-angle-down"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card review-table">
                <div class="review-table-head">
                    <div>Thông tin Sản phẩm</div>
                    <div>Đánh giá của Người mua</div>
                    <div class="review-table-action">Thao tác</div>
                </div>
                <asp:Repeater ID="ProductReviewRepeater" runat="server">
                    <ItemTemplate>
                        <div class="review-row">
                            <div class="review-product">
                                <div class="review-thumb">
                                    <img src="<%# Eval("ProductImageUrl") %>" alt="Ảnh sản phẩm" />
                                </div>
                                <div>
                                    <div class="review-product-name"><%# Eval("ProductName") %></div>
                                    <div class="review-product-meta"><%# Eval("ProductMeta") %></div>
                                </div>
                            </div>
                            <div class="review-buyer">
                                <div class="review-buyer-head">
                                    <div class="review-avatar">
                                        <img src="<%# Eval("BuyerAvatarUrl") %>" alt="Avatar" />
                                    </div>
                                    <div>
                                        <div class="review-buyer-name"><%# Eval("BuyerName") %></div>
                                        <div class="review-buyer-time"><%# Eval("CreatedAtLabel") %></div>
                                    </div>
                                </div>
                                <div class="review-stars small"><%# RenderStars((int)Eval("Rating"), "small") %></div>
                                <div class="review-comment"><%# Eval("Content") %></div>
                                <asp:PlaceHolder ID="ReviewPhotoHolder" runat="server" Visible='<%# ((System.Collections.Generic.List<string>)Eval("ImageUrls")).Count > 0 %>'>
                                    <div class="review-photos">
                                        <asp:Repeater ID="ReviewPhotoRepeater" runat="server" DataSource='<%# Eval("ImageUrls") %>'>
                                            <ItemTemplate>
                                                <img src="<%# Container.DataItem %>" alt="Ảnh đánh giá" />
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </asp:PlaceHolder>
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
                            <div class="review-action">
                                <a href="<%# Eval("ActionUrl") %>">Chi tiết</a>
                            </div>
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
            <h3>Công cụ đánh giá</h3>
            <div class="review-tool-card">
                <div class="review-tool-head">
                    <span class="review-tool-icon"><i class="fa-solid fa-star"></i></span>
                    <div>
                        <div class="review-tool-title">Xu Thưởng Đánh Giá</div>
                        <div class="review-tool-desc">Tặng xu cho khách đánh giá mình từ đơn hàng hoàn thành để nhận thêm nội dung review!</div>
                    </div>
                </div>
                <button class="review-tool-btn" type="button">Tìm hiểu ngay</button>
            </div>

            <div class="review-tip-card">
                <div class="review-tip-title"><i class="fa-regular fa-lightbulb"></i> Mẹo phản hồi đánh giá</div>
                <ul>
                    <li>Phản hồi trong vòng 24h để tăng uy tín</li>
                    <li>Cảm ơn khách hàng trước khi giải đáp</li>
                    <li>Giải quyết vấn đề nếu đánh giá tiêu cực</li>
                    <li>Khuyến khích khách mua lại ở cuối</li>
                    <li>Giữ thái độ chuyên nghiệp, thân thiện</li>
                </ul>
            </div>
        </aside>
    </div>
</asp:Content>
