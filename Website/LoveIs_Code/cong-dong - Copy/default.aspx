<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CommunityDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Mạng xã hội dành cho cộng đồng người mua/bán của LoveIs
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/public/assets/css/community.css" /><script>
        document.addEventListener("click", function (event) {
            var btn = event.target.closest("[data-action='comment']");
            if (!btn) {
                return;
            }
            var post = btn.closest(".community-post");
            if (!post) {
                return;
            }
            var input = post.querySelector(".community-comment-input");
            if (input) {
                input.focus();
                input.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        });
    </script>
    <script>
        document.addEventListener("click", function (event) {
            var btn = event.target.closest(".js-like");
            if (!btn) {
                return;
            }
            var postId = btn.getAttribute("data-post-id");
            if (!postId || !window.PageMethods || !window.PageMethods.ToggleLikeAjax) {
                return;
            }
            btn.disabled = true;
            PageMethods.ToggleLikeAjax(parseInt(postId, 10), function (result) {
                btn.disabled = false;
                if (!result || !result.success) {
                    return;
                }
                var post = btn.closest(".community-post");
                if (!post) {
                    return;
                }
                var countEl = post.querySelector(".reaction-like-count");
                if (countEl) {
                    countEl.textContent = result.likeCount;
                }
                if (result.liked) {
                    btn.classList.add("is-liked");
                } else {
                    btn.classList.remove("is-liked");
                }
            }, function () {
                btn.disabled = false;
            });
        });
    </script>
    <script>
        function initCommunityScroll() {
            if (!window.jQuery || !jQuery.fn || !jQuery.fn.mCustomScrollbar) {
                return;
            }
            jQuery(".community-comment-list, .community-online-list").each(function () {
                var $el = jQuery(this);
                if ($el.find(".mCSB_container").length) {
                    $el.mCustomScrollbar("destroy");
                }
                $el.mCustomScrollbar({
                    theme: "minimal-dark",
                    autoHideScrollbar: true,
                    scrollInertia: 100
                });
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            initCommunityScroll();
        });

        if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                setTimeout(initCommunityScroll, 50); setTimeout(initComposerModal, 50);
            });
        }

        if (window.Sys && Sys.Application) {
            Sys.Application.add_load(function () {
                setTimeout(initCommunityScroll, 50); setTimeout(initComposerModal, 50);
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="community-page">
        <div class="container">
            <div class="community-layout">
                <aside class="community-sidebar">
                    <div class="community-card">
                        <div class="fw-bold mb-2">Danh mục</div>
                        <a class="d-block mb-2" href="/cong-dong"><i class="fa-solid fa-house me-2"></i>Bảng tin</a>
                        <a class="d-block mb-2" href="/cong-dong/chat.aspx"><i class="fa-regular fa-comments me-2"></i>Tin nhắn</a>
                        <a class="d-block mb-2" href="/cong-dong/nhom.aspx"><i class="fa-solid fa-user-group me-2"></i>Nhóm chat</a>
                        <a class="d-block" href="<%= MyPostsUrl %>"><i class="fa-regular fa-pen-to-square me-2"></i>Bài viết của bạn</a>
                    </div>
                </aside>
                <main>
                    <div class="community-card community-composer-bar" id="ComposerTrigger">
                        <div class="composer-bar">
                            <div class="composer-avatar"><%= ComposerInitial %></div>
                            <button type="button" class="composer-input" id="OpenComposer"><%= ComposerDisplayName %> , bạn đang nghĩ gì?</button>
                            <div class="composer-actions">
                                <span class="composer-icon" aria-hidden="true"><i class="fa-regular fa-image"></i></span>
                                <span class="composer-icon" aria-hidden="true"><i class="fa-regular fa-face-smile"></i></span>
                                <%--<span class="composer-icon" aria-hidden="true">??</span>--%>
                            </div>
                        </div>
                    </div>

                    <div class="community-modal" id="ComposerModal" aria-hidden="true">
                        <div class="community-modal-backdrop"></div>
                        <div class="community-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="ComposerTitle">
                            <div class="community-modal-header">
                                <div class="community-modal-title" id="ComposerTitle">Tạo bài viết</div>
                                <button type="button" class="community-modal-close" data-modal-close="true">×</button>
                            </div>
                            <div class="community-modal-body">
                                <asp:Label ID="PostMessage" runat="server" CssClass="account-message" />
                                <div class="community-modal-user">
                                    <div class="composer-avatar"><%= ComposerInitial %></div>
                                    <div>
                                        <div class="fw-bold"><%= ComposerDisplayName %></div>
                                        <div class="community-visibility">Công khai</div>
                                    </div>
                                </div>
                                <asp:TextBox ID="PostContentInput" runat="server" TextMode="MultiLine" CssClass="community-modal-textarea" placeholder="Bạn đang nghĩ gì?" />
                                <div class="community-modal-upload">
                                    <div class="upload-label">Thêm vào bài viết của bạn</div>
                                    <div class="upload-actions">
                                        <button type="button" class="composer-icon-btn" id="ImagePickerBtn" title="áº¢nh"><i class="fa-regular fa-image" aria-hidden="true"></i></button>
                                        <button type="button" class="composer-icon-btn" id="EmojiPickerBtn" title="Emoji"><i class="fa-regular fa-face-smile" aria-hidden="true"></i></button>
                                        <div class="emoji-panel" id="EmojiPanel" aria-hidden="true"></div>
                                    </div>
                                </div>
                                <div id="ImagePreview" class="community-preview"></div>
                                <div id="VideoPreview" class="community-preview"></div>
                                <asp:HiddenField ID="VideoUrlHidden" runat="server" />
                                <asp:FileUpload ID="PostImagesUpload" runat="server" AllowMultiple="true" CssClass="community-upload-input" />
                            </div>
                            <div class="community-modal-footer">
                                <asp:Button ID="CreatePostButton" runat="server" CssClass="community-btn community-btn-block" Text="Đăng bài" OnClick="CreatePostButton_Click" />
                            </div>
                        </div>
                    


    
                    </div>

    <asp:Panel ID="PostModal" runat="server" CssClass="community-post-modal" Visible="false">
        <div class="community-modal-backdrop"></div>
        <div class="community-post-modal-dialog">
            <button type="button" class="community-modal-close" data-modal-close="post">x</button>
            <asp:Repeater ID="PostModalRepeater" runat="server" OnItemCommand="PostModalRepeater_ItemCommand">
                <ItemTemplate>
                    <div class="community-card community-post">
                        <div class="community-post-header">
                            <div>
                                <div class="community-post-user">
                                    <span class="post-avatar"><%# Eval("AuthorInitial") %></span>
                                    <a class="community-author-link" href='<%# Eval("AuthorUrl") %>'><%# Eval("AuthorName") %></a>
                                </div>
                                <div class="community-post-time"><%# Eval("CreatedAt") %></div>
                            </div>
                        </div>
                        <div class="community-post-content"><%# Eval("Content") %></div>
                        <asp:PlaceHolder ID="ModalImagePlaceholder" runat="server" Visible='<%# ((System.Collections.Generic.List<string>)Eval("Images")).Count > 0 %>'>
                            <div class="community-post-images">
                                <asp:Repeater ID="ModalImageRepeater" runat="server" DataSource='<%# Eval("Images") %>'>
                                    <ItemTemplate>
                                        <img src="<%# Container.DataItem %>" alt="community" />
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:PlaceHolder>
                        <div class="community-reaction-summary">
                            <div class="reaction-left">
                                <span class="reaction-chip">
                                    <i class="fa-solid fa-thumbs-up"></i>
                                    <span class="reaction-like-count"><%# Eval("LikeCount") %></span>
                                </span>
                            </div>
                            <div class="reaction-right">
                                <span><%# Eval("CommentCount") %> bình luận</span>
                                <span>0 lượt chia sẻ</span>
                            </div>
                        </div>
                        <div class="community-reaction-actions">
                            <button type="button" class='community-action-btn js-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-post-id='<%# Eval("PostId") %>'>
                                <i class="fa-regular fa-thumbs-up"></i>
                                <span>Thích</span>
                            </button>
                            <button type="button" class="community-action-btn" data-action="comment">
                                <i class="fa-regular fa-comment"></i>
                                <span>bình luận</span>
                            </button>
                            <button type="button" class="community-action-btn js-share" data-post-id='<%# Eval("PostId") %>'>
                                <i class="fa-solid fa-share"></i>
                                <span>Chia sẻ</span>
                            </button>
                        </div>
                        <div class="community-comments">
                            <div class="community-comment-list">
                                <asp:Repeater ID="PostModalCommentRepeater" runat="server" DataSource='<%# Eval("Comments") %>'>
                                    <ItemTemplate>
                                        <div class="community-comment" data-comment-id="<%# Eval("CommentId") %>" data-author="<%# Eval("AuthorName") %>">
                                            <div class="comment-avatar">
                                                <span class="comment-avatar-text"><%# Eval("AuthorInitial") %></span>
                                            </div>
                                            <div class="comment-body">
                                                <div class="comment-bubble">
                                                    <div class="comment-author"><%# Eval("AuthorName") %></div>
                                                    <div class="comment-content"><%# Eval("Content") %></div>
                                                </div>
                                                <div class="comment-meta">
                                                    <span class="comment-time"><%# Eval("CreatedAt") %></span>
                                                    <button type="button" class='comment-action js-comment-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-comment-id='<%# Eval("CommentId") %>'>
                                                        Thích
                                                    </button>
                                                    <span class="comment-like-count" style='<%# Convert.ToInt32(Eval("LikeCount")) > 0 ? string.Empty: "display:none;" %>'>
                                                        <%# Eval("LikeCount") %>
                                                    </span>
                                                    <asp:PlaceHolder ID="PostModalReplyButton" runat="server" Visible='<%# Convert.ToBoolean(Eval("CanReply")) %>'>
                                                        <button type="button" class='comment-action js-comment-reply' data-comment-id='<%# Eval("CommentId") %>' data-author='<%# Eval("AuthorName") %>'>
                                                            Trả lời
                                                        </button>
                                                    </asp:PlaceHolder>
                                                </div>
                                                <asp:Repeater ID="PostModalRepliesRepeater" runat="server" DataSource='<%# Eval("Replies") %>'>
                                                    <ItemTemplate>
                                                        <div class="community-comment reply-comment" data-comment-id="<%# Eval("CommentId") %>" data-author="<%# Eval("AuthorName") %>">
                                                            <div class="comment-avatar">
                                                                <span class="comment-avatar-text"><%# Eval("AuthorInitial") %></span>
                                                            </div>
                                                            <div class="comment-body">
                                                                <div class="comment-bubble">
                                                                    <div class="comment-author"><%# Eval("AuthorName") %></div>
                                                                    <div class="comment-content"><%# Eval("Content") %></div>
                                                                </div>
                                                                <div class="comment-meta">
                                                                    <span class="comment-time"><%# Eval("CreatedAt") %></span>
                                                                    <button type="button" class='comment-action js-comment-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-comment-id='<%# Eval("CommentId") %>'>Thích</button>
                                                                    <span class="comment-like-count" style='<%# Convert.ToInt32(Eval("LikeCount")) > 0 ? string.Empty: "display:none;" %>'>
                                                                        <%# Eval("LikeCount") %>
                                                                    </span>
                                                                    <asp:PlaceHolder ID="PostModalReplyButton" runat="server" Visible='<%# Convert.ToBoolean(Eval("CanReply")) %>'>
                                                                        <button type="button" class='comment-action js-comment-reply' data-comment-id='<%# Eval("CommentId") %>' data-author='<%# Eval("AuthorName") %>'>Trả lời</button>
                                                                    </asp:PlaceHolder>
                                                                </div>
                                                                <asp:Repeater ID="PostModalReplyRepliesRepeater" runat="server" DataSource='<%# Eval("Replies") %>'>
                                                                    <ItemTemplate>
                                                                        <div class="community-comment reply-comment" data-comment-id="<%# Eval("CommentId") %>" data-author="<%# Eval("AuthorName") %>">
                                                                            <div class="comment-avatar">
                                                                                <span class="comment-avatar-text"><%# Eval("AuthorInitial") %></span>
                                                                            </div>
                                                                            <div class="comment-body">
                                                                                <div class="comment-bubble">
                                                                                    <div class="comment-author"><%# Eval("AuthorName") %></div>
                                                                                    <div class="comment-content"><%# Eval("Content") %></div>
                                                                                </div>
                                                                                <div class="comment-meta">
                                                                                    <span class="comment-time"><%# Eval("CreatedAt") %></span>
                                                                                    <button type="button" class='comment-action js-comment-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-comment-id='<%# Eval("CommentId") %>'>Thích</button>
                                                                                    <span class="comment-like-count" style='<%# Convert.ToInt32(Eval("LikeCount")) > 0 ? string.Empty: "display:none;" %>'>
                                                                                        <%# Eval("LikeCount") %>
                                                                                    </span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="community-comment-form">
                                <input id="PostModalReplyToCommentId" runat="server" type="hidden" class="comment-reply-target" />
                                <asp:TextBox ID="PostModalCommentInput" runat="server" TextMode="MultiLine" Rows="1" CssClass="community-comment-input" placeholder="Viết bình luận..." />
                                <asp:LinkButton ID="PostModalCommentButton" runat="server" CssClass="community-btn" CommandName="comment" CommandArgument='<%# Eval("PostId") %>'>Gửi</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
                    <asp:HiddenField ID="CurrentPageHidden" runat="server" Value="1" />
                    <asp:UpdatePanel ID="PostListUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Repeater ID="PostRepeater" runat="server" OnItemCommand="PostRepeater_ItemCommand">
                                <ItemTemplate>
                                    <div class="community-card community-post">
                                        <div class="community-post-header">
                                            <div>
                                                <div class="community-post-user">
                                                    <span class="post-avatar"><%# Eval("AuthorInitial") %></span>
                                                    <a class="community-author-link" href='<%# Eval("AuthorUrl") %>'><%# Eval("AuthorName") %></a>
                                                    <asp:PlaceHolder ID="SellerBadge" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsSeller")) %>'>
                                                        <span class="community-badge">Người bán</span>
                                                    </asp:PlaceHolder>
                                                    <asp:PlaceHolder ID="ShopBadge" runat="server" Visible='<%# !string.IsNullOrWhiteSpace(Eval("ShopName") as string) %>'>
                                                        <a class="community-shop-link" href="<%# Eval("ShopUrl") %>"><%# Eval("ShopName") %></a>
                                                    </asp:PlaceHolder>
                                                </div>
                                                <a class="community-post-time post-time-link" href='<%# "/cong-dong?post=" + Eval("PostId") %>'><%# Eval("CreatedAt") %></a>
                                            </div>
                                            <div class="community-post-time"></div>
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
                                        <div class="community-reaction-summary">
                                            <div class="reaction-left">
                                                <span class="reaction-chip">
                                                    <i class="fa-solid fa-thumbs-up"></i>
                                                    <span class="reaction-like-count"><%# Eval("LikeCount") %></span>
                                                </span>
                                            </div>
                                            <div class="reaction-right">
                                                <span><%# Eval("CommentCount") %> bình luận</span>
                                                <span>0 lượt chia sẻ</span>
                                            </div>
                                        </div>
                                        <div class="community-reaction-actions">
                                            <button type="button" class='community-action-btn js-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-post-id='<%# Eval("PostId") %>'>
                                                <i class="fa-regular fa-thumbs-up"></i>
                                                <span>Thích</span>
                                            </button>
                                            <button type="button" class="community-action-btn" data-action="comment">
                                                <i class="fa-regular fa-comment"></i>
                                                <span>bình luận</span>
                                            </button>
                                            <button type="button" class="community-action-btn js-share" data-post-id='<%# Eval("PostId") %>'>
                                                <i class="fa-solid fa-share"></i>
                                                <span>Chia sẻ</span>
                                            </button>
                                        </div>
                                        <div class="community-comments">
                                            <div class="community-comment-list">
                                                <asp:Repeater ID="ModalCommentRepeater" runat="server" DataSource='<%# Eval("Comments") %>'>
                                                    <ItemTemplate>
                                                        <div class="community-comment" data-comment-id="<%# Eval("CommentId") %>" data-author="<%# Eval("AuthorName") %>">
                                                            <div class="comment-avatar">
                                                                <span class="comment-avatar-text"><%# Eval("AuthorInitial") %></span>
                                                            </div>
                                                            <div class="comment-body">
                                                                <div class="comment-bubble">
                                                                    <div class="comment-author"><%# Eval("AuthorName") %></div>
                                                                    <div class="comment-content"><%# Eval("Content") %></div>
                                                                </div>
                                                                <div class="comment-meta">
                                                                    <span class="comment-time"><%# Eval("CreatedAt") %></span>
                                                                    <button type="button" class='comment-action js-comment-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-comment-id='<%# Eval("CommentId") %>'>
                                                                        Thích
                                                   
                                                                    </button>
                                                                    <span class="comment-like-count" style='<%# Convert.ToInt32(Eval("LikeCount")) > 0 ? string.Empty: "display:none;" %>'>
                                                                        <%# Eval("LikeCount") %>
                                                                    </span>
                                                                    <asp:PlaceHolder ID="ModalReplyButton" runat="server" Visible='<%# Convert.ToBoolean(Eval("CanReply")) %>'>
                                                                        <button type="button" class='comment-action js-comment-reply' data-comment-id='<%# Eval("CommentId") %>' data-author='<%# Eval("AuthorName") %>'>
                                                                            Trả lời
                                                       
                                                                        </button>
                                                                    </asp:PlaceHolder>
                                                                </div>
                                                                <asp:Repeater ID="ModalRepliesRepeater" runat="server" DataSource='<%# Eval("Replies") %>'>
                                                                    <ItemTemplate>
                                                                        <div class="community-comment reply-comment" data-comment-id="<%# Eval("CommentId") %>" data-author="<%# Eval("AuthorName") %>">
                                                                            <div class="comment-avatar">
                                                                                <span class="comment-avatar-text"><%# Eval("AuthorInitial") %></span>
                                                                            </div>
                                                                            <div class="comment-body">
                                                                                <div class="comment-bubble">
                                                                                    <div class="comment-author"><%# Eval("AuthorName") %></div>
                                                                                    <div class="comment-content"><%# Eval("Content") %></div>
                                                                                </div>
                                                                                <div class="comment-meta">
                                                                                    <span class="comment-time"><%# Eval("CreatedAt") %></span>
                                                                                    <button type="button" class='comment-action js-comment-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-comment-id='<%# Eval("CommentId") %>'>
                                                                                        Thích
                                                                                    </button>
                                                                                    <span class="comment-like-count" style='<%# Convert.ToInt32(Eval("LikeCount")) > 0 ? string.Empty: "display:none;" %>'>
                                                                                        <%# Eval("LikeCount") %>
                                                                                    </span>
                                                                                    <asp:PlaceHolder ID="ReplyButton" runat="server" Visible='<%# Convert.ToBoolean(Eval("CanReply")) %>'>
                                                                                        <button type="button" class='comment-action js-comment-reply' data-comment-id='<%# Eval("CommentId") %>' data-author='<%# Eval("AuthorName") %>'>
                                                                                            Trả lời
                                                                                        </button>
                                                                                    </asp:PlaceHolder>
                                                                                </div>
                                                                                <asp:Repeater ID="ModalReplyRepliesRepeater" runat="server" DataSource='<%# Eval("Replies") %>'>
                                                                                    <ItemTemplate>
                                                                                        <div class="community-comment reply-comment" data-comment-id="<%# Eval("CommentId") %>" data-author="<%# Eval("AuthorName") %>">
                                                                                            <div class="comment-avatar">
                                                                                                <span class="comment-avatar-text"><%# Eval("AuthorInitial") %></span>
                                                                                            </div>
                                                                                            <div class="comment-body">
                                                                                                <div class="comment-bubble">
                                                                                                    <div class="comment-author"><%# Eval("AuthorName") %></div>
                                                                                                    <div class="comment-content"><%# Eval("Content") %></div>
                                                                                                </div>
                                                                                                <div class="comment-meta">
                                                                                                    <span class="comment-time"><%# Eval("CreatedAt") %></span>
                                                                                                    <button type="button" class='comment-action js-comment-like <%# Convert.ToBoolean(Eval("IsLiked")) ? "is-liked" : string.Empty %>' data-comment-id='<%# Eval("CommentId") %>'>
                                                                                                        Thích
                                                                                                    </button>
                                                                                                    <span class="comment-like-count" style='<%# Convert.ToInt32(Eval("LikeCount")) > 0 ? string.Empty: "display:none;" %>'>
                                                                                                        <%# Eval("LikeCount") %>
                                                                                                    </span>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </ItemTemplate>
                                                                                </asp:Repeater>
                                                                            </div>
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                            <div class="community-comment-form">
                                                <input id="ModalReplyToCommentId" runat="server" type="hidden" class="comment-reply-target" />
                                                <asp:TextBox ID="ModalCommentInput" runat="server" TextMode="MultiLine" Rows="1" CssClass="community-comment-input" placeholder="Viết bình luận..." />
                                                <asp:LinkButton ID="ModalCommentButton" runat="server" CssClass="community-btn" CommandName="comment" CommandArgument='<%# Eval("PostId") %>'>Gửi</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="community-load-more">
                                <asp:LinkButton ID="LoadMoreButton" runat="server" CssClass="community-btn community-btn-loadmore" OnClick="LoadMoreButton_Click">Xem th?m</asp:LinkButton>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </main>
                <aside class="community-sidebar community-sidebar-right">
                    <div class="community-card">
                        <div class="fw-bold mb-2">Đang online</div>
                        <div class="community-online-list">
                            <asp:Repeater ID="OnlineUserRepeater" runat="server">
                                <ItemTemplate>
                                    <a class="community-online-item" href="<%# Eval("ProfileUrl") %>">
                                        <span class="community-online-avatar"><%# Eval("Initial") %></span>
                                        <span class="community-online-name"><%# Eval("DisplayName") %></span>
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:PlaceHolder ID="OnlineEmpty" runat="server" Visible="false">
                                <div class="community-empty">Không có ai đang trực tuyến.</div>
                            </asp:PlaceHolder>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </div>
    <script>
        (function () {
            function initComposerModal() {
                var trigger = document.getElementById("ComposerTrigger");
                var modal = document.getElementById("ComposerModal");
                var openBtn = document.getElementById("OpenComposer");
                if (!trigger || !modal || modal.dataset.bound === "1") {
                    return;
                }
                modal.dataset.bound = "1";
                function openModal() {
                    modal.classList.add("is-open");
                    modal.setAttribute("aria-hidden", "false");
                }
                function closeModal() {
                    modal.classList.remove("is-open");
                    modal.setAttribute("aria-hidden", "true");
                }
                trigger.addEventListener("click", openModal);
                if (openBtn) {
                    openBtn.addEventListener("click", openModal);
                }
                modal.addEventListener("click", function (event) {
                    if (event.target && event.target.getAttribute("data-modal-close") === "true") {
                        closeModal();
                    }
                });
            }

            initComposerModal();

            var fileInput = document.getElementById("<%= PostImagesUpload.ClientID %>");
            var imageBtn = document.getElementById("ImagePickerBtn");
            var imagePreview = document.getElementById("ImagePreview");
            if (imageBtn && fileInput) {
                imageBtn.addEventListener("click", function () {
                    fileInput.click();
                });

                fileInput.addEventListener("change", function () {
                    if (!imagePreview) {
                        return;
                    }
                    imagePreview.innerHTML = "";
                    if (!fileInput.files || fileInput.files.length === 0) {
                        return;
                    }
                    Array.prototype.forEach.call(fileInput.files, function (file) {
                        if (!file.type || !file.type.startsWith("image/")) {
                            return;
                        }
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            var img = document.createElement("img");
                            img.src = e.target.result;
                            imagePreview.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    });
                });
            }

            var emojiBtn = document.getElementById("EmojiPickerBtn");
            var postInput = document.getElementById("<%= PostContentInput.ClientID %>");
            var emojiPanel = document.getElementById("EmojiPanel");
            if (emojiBtn && postInput && emojiPanel) {
                var emojis = ["\uD83D\uDE00", "\uD83D\uDE01", "\uD83D\uDE02", "\uD83E\uDD23", "\uD83D\uDE0A", "\uD83D\uDE0D", "\uD83D\uDE18", "\uD83D\uDE0E", "\uD83E\uDD29", "\uD83D\uDE22", "\uD83D\uDE21", "\uD83D\uDC4D", "\uD83D\uDC4E", "\uD83D\uDC4F", "\uD83D\uDE4F", "\u2764\uFE0F", "\uD83D\uDD25", "\uD83C\uDF89", "\uD83D\uDCAF"];
                emojiPanel.innerHTML = "";
                emojis.forEach(function (emoji) {
                    var btn = document.createElement("button");
                    btn.type = "button";
                    btn.className = "emoji-item";
                    btn.textContent = emoji;
                    btn.addEventListener("click", function () {
                        var start = postInput.selectionStart || 0;
                        var end = postInput.selectionEnd || 0;
                        var value = postInput.value || "";
                        postInput.value = value.slice(0, start) + emoji + value.slice(end);
                        postInput.focus();
                        postInput.selectionStart = postInput.selectionEnd = start + emoji.length;
                        emojiPanel.setAttribute("aria-hidden", "true");
                        emojiPanel.classList.remove("is-open");
                    });
                    emojiPanel.appendChild(btn);
                });
                emojiBtn.addEventListener("click", function (event) {
                    event.preventDefault();
                    var isOpen = emojiPanel.classList.toggle("is-open");
                    emojiPanel.setAttribute("aria-hidden", isOpen ? "false" : "true");
                });
                document.addEventListener("click", function (event) {
                    if (!emojiPanel.classList.contains("is-open")) {
                        return;
                    }
                    if (emojiPanel.contains(event.target) || emojiBtn.contains(event.target)) {
                        return;
                    }
                    emojiPanel.classList.remove("is-open");
                    emojiPanel.setAttribute("aria-hidden", "true");
                });
            }

            var videoBtn = document.getElementById("VideoPickerBtn");
            var videoPreview = document.getElementById("VideoPreview");
            var videoHidden = document.getElementById("<%= VideoUrlHidden.ClientID %>");
            if (videoBtn && videoHidden) {
                videoBtn.addEventListener("click", function () {
                    var url = window.prompt("NhÃ¡ÂºÂ­p link YouTube:");
                    if (!url) {
                        return;
                    }
                    videoHidden.value = url;
                    if (videoPreview) {
                        videoPreview.innerHTML = "";
                        var iframe = document.createElement("iframe");
                        iframe.src = url.replace("watch?v=", "embed/").replace("youtu.be/", "www.youtube.com/embed/");
                        iframe.setAttribute("allowfullscreen", "allowfullscreen");
                        iframe.setAttribute("frameborder", "0");
                        videoPreview.appendChild(iframe);
                    }
                });
            }
        })();
    </script>

    <script>
        document.addEventListener("click", function (event) {
            var btn = event.target.closest("[data-action='comment']");
            if (!btn) {
                return;
            }
            var post = btn.closest(".community-post");
            if (!post) {
                return;
            }
            var input = post.querySelector(".community-comment-input");
            if (input) {
                input.focus();
                input.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        });
    </script>
    <script>
        document.addEventListener("click", function (event) {
            var btn = event.target.closest(".js-share");
            if (!btn) {
                return;
            }
            var postId = btn.getAttribute("data-post-id");
            if (!postId) {
                return;
            }
            var url = window.location.origin + "/cong-dong?post=" + encodeURIComponent(postId);
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(url).then(function () {
                    showShareToast("ÄÃ£ sao chÃ©p liÃªn káº¿t bÃ i viáº¿t.");
                }).catch(function () {
                    window.prompt("Copy link:", url);
                });
            } else {
                window.prompt("Copy link:", url);
            }
        });
    </script>
    <script>
        document.addEventListener("click", function (event) {
            var closeBtn = event.target.closest("[data-modal-close='post']");
            if (!closeBtn) {
                return;
            }
            var modal = document.querySelector(".community-post-modal");
            if (modal) {
                modal.classList.remove("is-open");
            }
        });
        var postModal = document.querySelector(".community-post-modal");
        if (postModal) {
            postModal.classList.add("is-open");
        }
    </script>
    <script>
        function showShareToast(message) {
            var toast = document.getElementById("shareToast");
            if (!toast) {
                toast = document.createElement("div");
                toast.id = "shareToast";
                toast.className = "community-toast";
                document.body.appendChild(toast);
            }
            toast.textContent = message;
            toast.classList.add("is-visible");
            setTimeout(function () {
                toast.classList.remove("is-visible");
            }, 1600);
        }
    </script>
    <script>
        document.addEventListener("click", function (event) {
            var btn = event.target.closest(".js-comment-like");
            if (!btn) {
                return;
            }
            var commentId = btn.getAttribute("data-comment-id");
            if (!commentId || !window.PageMethods || !window.PageMethods.ToggleCommentLikeAjax) {
                return;
            }
            btn.disabled = true;
            PageMethods.ToggleCommentLikeAjax(parseInt(commentId, 10), function (result) {
                btn.disabled = false;
                if (!result || !result.success) {
                    return;
                }
                var comment = btn.closest(".community-comment");
                if (!comment) {
                    return;
                }
                var countEl = comment.querySelector(".comment-like-count");
                if (countEl) {
                    if (result.likeCount > 0) {
                        countEl.textContent = result.likeCount;
                        countEl.style.display = "";
                    } else {
                        countEl.style.display = "none";
                    }
                }
                if (result.liked) {
                    btn.classList.add("is-liked");
                } else {
                    btn.classList.remove("is-liked");
                }
            }, function () {
                btn.disabled = false;
            });
        });
    </script>
    <script>
        document.addEventListener("click", function (event) {
            var btn = event.target.closest(".js-comment-reply");
            if (!btn) {
                return;
            }
            var post = btn.closest(".community-post");
            if (!post) {
                return;
            }
            var input = post.querySelector(".community-comment-input");
            var hidden = post.querySelector(".comment-reply-target");
            if (hidden) {
                hidden.value = btn.getAttribute("data-comment-id") || "";
            }
            if (input) {
                var author = btn.getAttribute("data-author") || "";
                if (author) {
                    input.placeholder = "Tráº£ lá»i " + author + "...";
                }
                input.focus();
                input.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        });
    </script>
</asp:Content>




