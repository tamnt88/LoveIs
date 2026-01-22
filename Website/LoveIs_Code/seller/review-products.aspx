<%@ Page Language="C#" AutoEventWireup="true" CodeFile="review-products.aspx.cs" Inherits="SellerProductReviews" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
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
                            <span class="review-score-value"><asp:Literal ID="ReviewScoreLiteral" runat="server" /></span>
                            <span class="review-score-total">/5</span>
                        </div>
                        <div class="review-stars"><asp:Literal ID="ReviewScoreStarsLiteral" runat="server" /></div>
                    </div>
                </div>

                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Tổng lượt đánh giá</div>
                        <div class="review-value"><asp:Literal ID="TotalReviewsLiteral" runat="server" /></div>
                        <div class="review-trend" runat="server" id="TotalReviewsTrend"></div>
                    </div>
                </div>

                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Tỷ lệ đánh giá đơn hàng</div>
                        <div class="review-value"><asp:Literal ID="ReviewRateLiteral" runat="server" /></div>
                        <div class="review-trend" runat="server" id="ReviewRateTrend"></div>
                    </div>
                </div>

                <div class="card review-card">
                    <div class="review-card-body">
                        <div class="review-label">Tỷ lệ đánh giá tốt</div>
                        <div class="review-value"><asp:Literal ID="GoodReviewRateLiteral" runat="server" /></div>
                        <div class="review-trend" runat="server" id="GoodReviewRateTrend"></div>
                    </div>
                </div>
            </div>

            <div class="review-mini-grid" style="display: none;">
                <div class="card review-mini-card">
                    <div class="review-mini-head">
                        <div class="review-mini-title">Đánh giá tốt cụ thể sản phẩm nổi</div>
                        <a class="review-mini-link" href="#">Xem →</a>
                    </div>
                    <div class="review-mini-value"><asp:Literal ID="HighlightedGoodReviewLiteral" runat="server" /></div>
                    <div class="review-mini-desc">Các đánh giá có 4 &amp; 5 sao có bình luận hoặc hình ảnh</div>
                </div>
                <div class="card review-mini-card">
                    <div class="review-mini-head">
                        <div class="review-mini-title">Đánh giá gần đây</div>
                        <a class="review-mini-link" href="#">Xem →</a>
                    </div>
                    <div class="review-mini-value"><asp:Literal ID="RecentReviewLiteral" runat="server" /></div>
                    <div class="review-mini-desc">Đánh giá mới nhất cập nhật trong vòng dưới 48h</div>
                </div>
            </div>

            <div class="card review-panel">
                <div class="review-tabs">
                    <a class="review-tab <%# GetTabClass("all") %>" href="/seller/review-products.aspx?tab=all"><asp:Literal ID="TotalCountLiteral" runat="server" /></a>
                    <a class="review-tab <%# GetTabClass("need-reply") %>" href="/seller/review-products.aspx?tab=need-reply"><asp:Literal ID="NeedReplyLiteral" runat="server" /></a>
                    <a class="review-tab <%# GetTabClass("replied") %>" href="/seller/review-products.aspx?tab=replied"><asp:Literal ID="RepliedLiteral" runat="server" /></a>
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
                            <asp:TextBox ID="SearchTextBox" runat="server" Placeholder="Tìm kiếm: Tên sản phẩm, Mã đơn hàng, Tên đăng nhập người mua..." />
                        </div>
                        <div class="review-select">
                            <select>
                                <option>Thời gian đánh giá</option>
                            </select>
                            <i class="fa-solid fa-angle-down"></i>
                        </div>
                        <asp:LinkButton ID="ApplyFiltersButton" runat="server" CssClass="btn-outline" OnClick="ApplyFiltersButton_Click">Lọc</asp:LinkButton>
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
                                    <a class="review-product-name" href="<%# Eval("ProductUrl") %>"><%# Eval("ProductName") %></a>
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
                                    <button type="button"
                                        class="btn-outline small review-reply-trigger"
                                        data-review-id="<%# Eval("ReviewId") %>"
                                        data-reply-content="<%# System.Web.HttpUtility.HtmlAttributeEncode(Eval("ReplyContent") as string ?? string.Empty) %>">
                                        <%# Eval("ReplyActionLabel") %>
                                    </button>
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

    </div>
    <div class="review-reply-modal" id="ProductReplyModal" aria-hidden="true">
        <div class="review-reply-dialog" role="dialog" aria-modal="true">
            <div class="review-reply-head">
                <div>Phản hồi đánh giá</div>
                <button type="button" class="review-reply-close" data-close="ProductReplyModal">&times;</button>
            </div>
            <div class="review-reply-body">
                <asp:HiddenField ID="ProductReplyIdField" runat="server" />
                <asp:TextBox ID="ProductReplyTextBox" runat="server" CssClass="review-reply-input" TextMode="MultiLine" Rows="5" placeholder="Nhập phản hồi cho khách hàng..." />
            </div>
            <div class="review-reply-actions">
                <asp:LinkButton ID="SubmitProductReplyButton" runat="server" CssClass="btn-primary small" OnClick="SubmitProductReplyButton_Click">Gửi phản hồi</asp:LinkButton>
                <button type="button" class="btn-outline small" data-close="ProductReplyModal">Hủy</button>
            </div>
        </div>
    </div>
    <script>
        (function () {
            function openModal(modalId, reviewId, content) {
                var modal = document.getElementById(modalId);
                if (!modal) return;
                var idField = document.getElementById("<%= ProductReplyIdField.ClientID %>");
                var textBox = document.getElementById("<%= ProductReplyTextBox.ClientID %>");
                if (idField) idField.value = reviewId || "";
                if (textBox) textBox.value = content || "";
                modal.classList.add("open");
                modal.setAttribute("aria-hidden", "false");
            }

            function closeModal(modal) {
                if (!modal) return;
                modal.classList.remove("open");
                modal.setAttribute("aria-hidden", "true");
            }

            document.querySelectorAll(".review-reply-trigger").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    openModal("ProductReplyModal", btn.getAttribute("data-review-id"), btn.getAttribute("data-reply-content"));
                });
            });

            document.querySelectorAll("[data-close='ProductReplyModal']").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    closeModal(document.getElementById("ProductReplyModal"));
                });
            });

            var overlay = document.getElementById("ProductReplyModal");
            if (overlay) {
                overlay.addEventListener("click", function (event) {
                    if (event.target === overlay) {
                        closeModal(overlay);
                    }
                });
            }
        })();
    </script>
</asp:Content>
