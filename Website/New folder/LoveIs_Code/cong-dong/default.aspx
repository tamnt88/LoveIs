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
                    <div class="community-card community-composer">
                        <asp:Label ID="PostMessage" runat="server" CssClass="account-message" />
                        <asp:TextBox ID="PostContentInput" runat="server" TextMode="MultiLine" placeholder="Bạn đang nghĩ gì?" />
                        <div class="composer-actions">
                            <asp:FileUpload ID="PostImagesUpload" runat="server" AllowMultiple="true" />
                            <asp:Button ID="CreatePostButton" runat="server" CssClass="community-btn" Text="Đăng bài" OnClick="CreatePostButton_Click" />
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
                                    <div class="community-post-time">Thích: <%# Eval("LikeCount") %> · Bình luận: <%# Eval("CommentCount") %></div>
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
                                        <asp:TextBox ID="CommentInput" runat="server" TextMode="MultiLine" placeholder="Viết Bình luận..." />
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
</asp:Content>