<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CommunityDefault" MasterPageFile="~/public/Public.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/public/assets/css/community.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="community-page">
        <div class="container">
            <div class="community-layout">
                <aside class="community-sidebar">
                    <div class="community-card community-search">
                        <asp:TextBox ID="SearchInput" runat="server" placeholder="Tìm bài viết..." />
                        <div class="mt-2">
                            <asp:Button ID="SearchButton" runat="server" CssClass="community-btn-outline" Text="Tìm kiếm" OnClick="SearchButton_Click" />
                        </div>
                    </div>
                    <div class="community-card">
                        <div class="fw-bold mb-2">Danh mục</div>
                        <a class="d-block mb-2" href="/cong-dong">Bảng tin</a>
                        <a class="d-block mb-2" href="/cong-dong/chat.aspx">Tin nhắn</a>
                        <a class="d-block" href="/cong-dong/nhom.aspx">Nhóm chat</a>
                    </div>
                </aside>
                <main>
                    <div class="community-card community-composer-bar" id="ComposerTrigger">
                        <div class="composer-bar">
                            <div class="composer-avatar">P</div>
                            <button type="button" class="composer-input" id="OpenComposer">Bạn đang nghĩ gì?</button>
                            <div class="composer-actions">
                                <span class="composer-icon" aria-hidden="true">📷</span>
                                <span class="composer-icon" aria-hidden="true">🖼️</span>
                                <span class="composer-icon" aria-hidden="true">🎥</span>
                            </div>
                        </div>
                    </div>

                    <div class="community-modal" id="ComposerModal" aria-hidden="true">
                        <div class="community-modal-backdrop" data-modal-close="true"></div>
                        <div class="community-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="ComposerTitle">
                            <div class="community-modal-header">
                                <div class="community-modal-title" id="ComposerTitle">Tạo bài viết</div>
                                <button type="button" class="community-modal-close" data-modal-close="true">×</button>
                            </div>
                            <div class="community-modal-body">
                                <asp:Label ID="PostMessage" runat="server" CssClass="account-message" />
                                <div class="community-modal-user">
                                    <div class="composer-avatar">P</div>
                                    <div>
                                        <div class="fw-bold">LoveIs Community</div>
                                        <div class="community-visibility">Công khai</div>
                                    </div>
                                </div>
                                <asp:TextBox ID="PostContentInput" runat="server" TextMode="MultiLine" CssClass="community-modal-textarea" placeholder="Bạn đang nghĩ gì?" />
                                <div class="community-modal-upload">
                                    <div class="upload-label">Thêm vào bài viết của bạn</div>
                                    <div class="upload-actions">
                                        <span class="composer-icon" aria-hidden="true">🖼️</span>
                                        <span class="composer-icon" aria-hidden="true">👥</span>
                                        <span class="composer-icon" aria-hidden="true">📍</span>
                                        <span class="composer-icon" aria-hidden="true">🎥</span>
                                    </div>
                                </div>
                                <asp:FileUpload ID="PostImagesUpload" runat="server" AllowMultiple="true" CssClass="community-upload-input" />
                            </div>
                            <div class="community-modal-footer">
                                <asp:Button ID="CreatePostButton" runat="server" CssClass="community-btn community-btn-block" Text="Đăng bài" OnClick="CreatePostButton_Click" />
                            </div>
                        </div>
                    </div>

                    <asp:Repeater ID="PostRepeater" runat="server" OnItemCommand="PostRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="community-card community-post">
                                <div class="community-post-header">
                                    <div>
                                        <div class="community-post-user">
                                            <%# Eval("AuthorName") %>
                                            <asp:PlaceHolder ID="SellerBadge" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsSeller")) %>'>
                                                <span class="community-badge">Người bán</span>
                                            </asp:PlaceHolder>
                                            <asp:PlaceHolder ID="ShopBadge" runat="server" Visible='<%# !string.IsNullOrWhiteSpace(Eval("ShopName") as string) %>'>
                                                <a class="community-shop-link" href="<%# Eval("ShopUrl") %>"><%# Eval("ShopName") %></a>
                                            </asp:PlaceHolder>
                                        </div>
                                        <div class="community-post-time"><%# Eval("CreatedAt") %></div>
                                    </div>
                                    <div class="community-post-time">Thích: <%# Eval("LikeCount") %> • Bình luận: <%# Eval("CommentCount") %></div>
                                </div>
                                <div class="community-post-content"><%# Eval("Content") %></div>
                                <asp:PlaceHolder ID="ImagePlaceholder" runat="server" Visible='<%# ((System.Collections.Generic.List<string>)Eval("Images")).Count > 0 %>'>
                                    <div class="community-post-images">
                                        <asp:Repeater ID="ImageRepeater" runat="server" DataSource='<%# Eval("Images") %>'>
                                            <ItemTemplate>
                                                <img src="<%# Container.DataItem %>" alt="community" />
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </asp:PlaceHolder>
                                <div class="community-post-actions">
                                    <asp:LinkButton ID="LikeButton" runat="server" CssClass="community-btn-outline" CommandName="like" CommandArgument='<%# Eval("PostId") %>'>
                                        <%# Eval("LikeLabel") %>
                                    </asp:LinkButton>
                                </div>
                                <div class="community-comments">
                                    <asp:Repeater ID="CommentRepeater" runat="server" DataSource='<%# Eval("Comments") %>'>
                                        <ItemTemplate>
                                            <div class="community-comment">
                                                <span class="community-comment-user"><%# Eval("AuthorName") %>:</span>
                                                <asp:PlaceHolder ID="CommentSellerBadge" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsSeller")) %>'>
                                                    <span class="community-badge">Người bán</span>
                                                </asp:PlaceHolder>
                                                <asp:PlaceHolder ID="CommentShopBadge" runat="server" Visible='<%# !string.IsNullOrWhiteSpace(Eval("ShopName") as string) %>'>
                                                    <a class="community-shop-link" href="<%# Eval("ShopUrl") %>"><%# Eval("ShopName") %></a>
                                                </asp:PlaceHolder>
                                                <span><%# Eval("Content") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <div class="community-comment-form">
                                        <asp:TextBox ID="CommentInput" runat="server" TextMode="MultiLine" placeholder="Viết bình luận..." />
                                        <asp:LinkButton ID="CommentButton" runat="server" CssClass="community-btn" CommandName="comment" CommandArgument='<%# Eval("PostId") %>'>Gửi</asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </main>
                <aside>
                    <div class="community-card">
                        <div class="fw-bold mb-2">Tìm người dùng</div>
                        <asp:TextBox ID="UserSearchInput" runat="server" placeholder="Nhập username hoặc tên shop..." />
                        <div class="mt-2">
                            <asp:Button ID="StartChatButton" runat="server" CssClass="community-btn-outline" Text="Nhắn tin" OnClick="StartChatButton_Click" />
                        </div>
                        <asp:Label ID="ChatMessage" runat="server" CssClass="account-message d-block mt-2" />
                    </div>
                </aside>
            </div>
        </div>
    </div>
    <script>
        (function () {
            var trigger = document.getElementById("ComposerTrigger");
            var modal = document.getElementById("ComposerModal");
            if (!trigger || !modal) {
                return;
            }

            function openModal() {
                modal.classList.add("is-open");
                modal.setAttribute("aria-hidden", "false");
            }

            function closeModal() {
                modal.classList.remove("is-open");
                modal.setAttribute("aria-hidden", "true");
            }

            trigger.addEventListener("click", openModal);
            modal.addEventListener("click", function (event) {
                if (event.target && event.target.getAttribute("data-modal-close") === "true") {
                    closeModal();
                }
            });
        })();
    </script>
</asp:Content>
