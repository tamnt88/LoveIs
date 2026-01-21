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
                            <div class="shop-score-value"><asp:Literal ID="ShopScoreLiteral" runat="server" /></div>
                            <div class="shop-score-total">/5</div>
                        </div>
                        <div class="review-stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star-half-stroke"></i>
                        </div>
                        <div class="shop-score-count"><asp:Literal ID="ShopScoreCountLiteral" runat="server" /></div>
                    </div>
                    <div class="shop-score-bars">
                        <div class="shop-score-row">
                            <span>5 ★</span>
                            <div class="shop-score-track"><span id="Star5Bar" runat="server"></span></div>
                            <span><asp:Literal ID="Star5CountLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-score-row">
                            <span>4 ★</span>
                            <div class="shop-score-track"><span id="Star4Bar" runat="server"></span></div>
                            <span><asp:Literal ID="Star4CountLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-score-row">
                            <span>3 ★</span>
                            <div class="shop-score-track"><span id="Star3Bar" runat="server"></span></div>
                            <span><asp:Literal ID="Star3CountLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-score-row">
                            <span>2 ★</span>
                            <div class="shop-score-track"><span id="Star2Bar" runat="server"></span></div>
                            <span><asp:Literal ID="Star2CountLiteral" runat="server" /></span>
                        </div>
                        <div class="shop-score-row">
                            <span>1 ★</span>
                            <div class="shop-score-track"><span id="Star1Bar" runat="server"></span></div>
                            <span><asp:Literal ID="Star1CountLiteral" runat="server" /></span>
                        </div>
                    </div>
                </div>

                <div class="shop-metric-stack">
                    <div class="card shop-metric-card">
                        <div class="shop-metric-icon icon-blue"><i class="fa-solid fa-box"></i></div>
                        <div>
                            <div class="shop-metric-label">Chất lượng sản phẩm</div>
                            <div class="shop-metric-line">
                                <div class="shop-metric-value"><asp:Literal ID="QualityScoreLiteral" runat="server" /></div>
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
                                <div class="shop-metric-value"><asp:Literal ID="ShippingScoreLiteral" runat="server" /></div>
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
                                <div class="shop-metric-value"><asp:Literal ID="DescriptionScoreLiteral" runat="server" /></div>
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
                                <div class="shop-metric-value"><asp:Literal ID="ServiceScoreLiteral" runat="server" /></div>
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
                    <a class="review-tab <%# GetTabClass("all") %>" href="/seller/review-shops.aspx?tab=all"><asp:Literal ID="TotalCountLiteral" runat="server" /></a>
                    <a class="review-tab <%# GetTabClass("need-reply") %>" href="/seller/review-shops.aspx?tab=need-reply"><asp:Literal ID="NeedReplyLiteral" runat="server" /></a>
                    <a class="review-tab <%# GetTabClass("replied") %>" href="/seller/review-shops.aspx?tab=replied"><asp:Literal ID="RepliedLiteral" runat="server" /></a>
                </div>
                <div class="review-filters">
                    <div class="review-pill-row">
                        <span class="review-pill-label">Số sao đánh giá:</span>
                        <a class="review-pill <%# GetRatingClass(0) %>" href="<%# BuildRatingUrl(0) %>"><asp:Literal ID="RatingAllLiteral" runat="server" /></a>
                        <a class="review-pill <%# GetRatingClass(5) %>" href="<%# BuildRatingUrl(5) %>"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating5Literal" runat="server" /></a>
                        <a class="review-pill <%# GetRatingClass(4) %>" href="<%# BuildRatingUrl(4) %>"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating4Literal" runat="server" /></a>
                        <a class="review-pill <%# GetRatingClass(3) %>" href="<%# BuildRatingUrl(3) %>"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating3Literal" runat="server" /></a>
                        <a class="review-pill <%# GetRatingClass(2) %>" href="<%# BuildRatingUrl(2) %>"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating2Literal" runat="server" /></a>
                        <a class="review-pill <%# GetRatingClass(1) %>" href="<%# BuildRatingUrl(1) %>"><i class="fa-solid fa-star"></i> <asp:Literal ID="Rating1Literal" runat="server" /></a>
                    </div>
                    <div class="review-toolbar">
                        <div class="review-search">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <asp:TextBox ID="SearchTextBox" runat="server" Placeholder="Tìm kiếm theo tên người mua, nội dung đánh giá..." />
                        </div>
                        <asp:LinkButton ID="ApplyFiltersButton" runat="server" CssClass="btn-outline" OnClick="ApplyFiltersButton_Click">Lọc</asp:LinkButton>
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

    </div>
</asp:Content>
