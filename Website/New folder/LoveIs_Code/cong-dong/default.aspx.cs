using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

public partial class CommunityDefault : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CommunityUserHelper.EnsureCommunityCustomerId().HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/cong-dong";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        if (!IsPostBack)
        {
            BindPosts();
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        BindPosts();
    }

    protected void CreatePostButton_Click(object sender, EventArgs e)
    {
        PostMessage.Text = string.Empty;
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        if (CommunityHelper.IsRateLimited(customerId.Value, CommunityHelper.ActionPost, 5, 5))
        {
            PostMessage.Text = "Bạn đăng bài quá nhanh. Vui lòng thử lại sau.";
            return;
        }

        var content = PostContentInput.Text ?? string.Empty;
        if (string.IsNullOrWhiteSpace(content))
        {
            PostMessage.Text = "Vui lòng nhập nội dung bài viết.";
            return;
        }

        if (!CommunityHelper.HasOnlyWhitelistedLinks(content))
        {
            PostMessage.Text = "Nội dung chứa liên kết không được phép.";
            return;
        }

        var normalized = CommunityHelper.NormalizeContent(content);
        var imageUrls = SavePostImages();

        using (var db = new BeautyStoryContext())
        {
            var post = new CfCommunityPost
            {
                CustomerId = customerId.Value,
                Content = normalized,
                LikeCount = 0,
                CommentCount = 0,
                Status = true,
                CreatedAt = DateTime.UtcNow
            };
            db.CfCommunityPosts.Add(post);
            db.SaveChanges();

            if (imageUrls.Count > 0)
            {
                int sort = 0;
                foreach (var url in imageUrls)
                {
                    db.CfCommunityPostImages.Add(new CfCommunityPostImage
                    {
                        PostId = post.Id,
                        ImageUrl = url,
                        SortOrder = sort++,
                        Status = true,
                        CreatedAt = DateTime.UtcNow
                    });
                }
                db.SaveChanges();
            }
        }

        CommunityHelper.LogAction(customerId.Value, CommunityHelper.ActionPost, "post");
        PostContentInput.Text = string.Empty;
        BindPosts();
    }

    protected void PostRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        int postId;
        if (!int.TryParse(e.CommandArgument.ToString(), out postId))
        {
            return;
        }

        if (e.CommandName == "like")
        {
            ToggleLike(customerId.Value, postId);
            BindPosts();
        }
        else if (e.CommandName == "comment")
        {
            var commentInput = e.Item.FindControl("CommentInput") as System.Web.UI.WebControls.TextBox;
            if (commentInput == null)
            {
                return;
            }

            var comment = commentInput.Text ?? string.Empty;
            if (string.IsNullOrWhiteSpace(comment))
            {
                return;
            }

            if (CommunityHelper.IsRateLimited(customerId.Value, CommunityHelper.ActionComment, 20, 5))
            {
                PostMessage.Text = "Bạn bình luận quá nhanh. Vui lòng thử lại sau.";
                return;
            }

            if (!CommunityHelper.HasOnlyWhitelistedLinks(comment))
            {
                PostMessage.Text = "Bình luận chứa liên kết không được phép.";
                return;
            }

            CreateComment(customerId.Value, postId, comment);
            commentInput.Text = string.Empty;
            BindPosts();
        }
    }

    protected void StartChatButton_Click(object sender, EventArgs e)
    {
        ChatMessage.Text = string.Empty;
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        var username = (UserSearchInput.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(username))
        {
            ChatMessage.Text = "Vui lòng nhập username.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var normalized = username.ToLowerInvariant();
            var target = db.CfCustomers.FirstOrDefault(c => c.Username.ToLower() == normalized);
            if (target == null)
            {
                var seller = db.CfSellers.FirstOrDefault(s => s.Username.ToLower() == normalized);
                if (seller != null)
                {
                    var sellerCustomerId = CommunityUserHelper.EnsureCustomerForSellerId(seller.Id, false);
                    if (sellerCustomerId.HasValue)
                    {
                        target = db.CfCustomers.FirstOrDefault(c => c.Id == sellerCustomerId.Value);
                    }
                }
                if (target == null)
                {
                    var shop = db.CfShops.FirstOrDefault(s => s.ShopCode.ToLower() == normalized || s.ShopName.ToLower() == normalized);
                    if (shop == null)
                    {
                        shop = db.CfShops.FirstOrDefault(s => s.ShopName.ToLower().Contains(normalized));
                    }
                    if (shop != null)
                    {
                        var sellerCustomerId = CommunityUserHelper.EnsureCustomerForSellerId(shop.SellerId, false);
                        if (sellerCustomerId.HasValue)
                        {
                            target = db.CfCustomers.FirstOrDefault(c => c.Id == sellerCustomerId.Value);
                        }
                    }
                }
                if (target == null)
                {
                    ChatMessage.Text = "Không tìm thấy người dùng.";
                    return;
                }
            }

            if (target.Id == customerId.Value)
            {
                ChatMessage.Text = "Bạn không thể chat với chính mình.";
                return;
            }

            var roomId = GetOrCreateDirectRoom(db, customerId.Value, target.Id);
            Response.Redirect("/cong-dong/chat.aspx?roomId=" + roomId);
        }
    }

    private void BindPosts()
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        var query = (SearchInput.Text ?? Request.QueryString["q"] ?? string.Empty).Trim();
        if (SearchInput != null && string.IsNullOrWhiteSpace(SearchInput.Text))
        {
            SearchInput.Text = query;
        }

        using (var db = new BeautyStoryContext())
        {
            var postQuery = db.CfCommunityPosts.Where(p => p.Status);
            if (!string.IsNullOrWhiteSpace(query))
            {
                postQuery = postQuery.Where(p => p.Content.Contains(query));
            }

            var posts = postQuery
                .OrderByDescending(p => p.CreatedAt)
                .Take(50)
                .ToList();

            var postIds = posts.Select(p => p.Id).ToList();
            var images = db.CfCommunityPostImages
                .Where(i => postIds.Contains(i.PostId) && i.Status)
                .OrderBy(i => i.SortOrder)
                .ToList();
            var comments = db.CfCommunityComments
                .Where(c => postIds.Contains(c.PostId) && c.Status)
                .OrderByDescending(c => c.CreatedAt)
                .ToList();
            var likes = db.CfCommunityLikes
                .Where(l => postIds.Contains(l.PostId))
                .ToList();
            var customerIds = posts.Select(p => p.CustomerId).Distinct().ToList();
            var commentCustomerIds = comments.Select(c => c.CustomerId).Distinct().ToList();
            customerIds.AddRange(commentCustomerIds);
            customerIds = customerIds.Distinct().ToList();
            var customerInfo = db.CfCustomers
                .Where(c => customerIds.Contains(c.Id))
                .Select(c => new
                {
                    c.Id,
                    c.DisplayName,
                    c.Username,
                    c.IsSeller,
                    c.SellerId
                })
                .ToList()
                .Select(c => new
                {
                    c.Id,
                    Name = string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName,
                    c.IsSeller,
                    c.SellerId
                })
                .ToList();

            var customers = customerInfo.ToDictionary(c => c.Id, c => c.Name);

            var sellerIds = customerInfo
                .Where(c => c.IsSeller && c.SellerId.HasValue)
                .Select(c => c.SellerId.Value)
                .Distinct()
                .ToList();

            var shopLookup = sellerIds.Count > 0
                ? db.CfShops
                    .Where(s => sellerIds.Contains(s.SellerId))
                    .ToList()
                    .ToDictionary(s => s.SellerId, s => s)
                : new Dictionary<int, CfShop>();

            var likedIds = customerId.HasValue
                ? new HashSet<int>(likes.Where(l => l.CustomerId == customerId.Value).Select(l => l.PostId))
                : new HashSet<int>();

            var viewModels = posts.Select(post =>
            {
                var authorInfo = customerInfo.FirstOrDefault(c => c.Id == post.CustomerId);
                var isSeller = authorInfo != null && authorInfo.IsSeller;
                CfShop shop = null;
                if (isSeller && authorInfo != null && authorInfo.SellerId.HasValue && shopLookup.ContainsKey(authorInfo.SellerId.Value))
                {
                    shop = shopLookup[authorInfo.SellerId.Value];
                }

                return new
                {
                    PostId = post.Id,
                    AuthorName = customers.ContainsKey(post.CustomerId) ? customers[post.CustomerId] : "User",
                    IsSeller = isSeller,
                    ShopName = shop != null ? shop.ShopName : string.Empty,
                    ShopUrl = shop != null && !string.IsNullOrWhiteSpace(shop.ShopCode) ? "/cua-hang/" + shop.ShopCode : "#",
                    CreatedAt = post.CreatedAt.ToString("dd/MM HH:mm"),
                    Content = HttpUtility.HtmlDecode(post.Content),
                    LikeCount = post.LikeCount,
                    CommentCount = post.CommentCount,
                    LikeLabel = likedIds.Contains(post.Id) ? "Bỏ thích" : "Thích",
                    Images = images.Where(i => i.PostId == post.Id).Select(i => i.ImageUrl).ToList(),
                    Comments = comments.Where(c => c.PostId == post.Id)
                        .OrderByDescending(c => c.CreatedAt)
                        .Take(3)
                        .Select(c =>
                        {
                            var commentInfo = customerInfo.FirstOrDefault(x => x.Id == c.CustomerId);
                            var commentIsSeller = commentInfo != null && commentInfo.IsSeller;
                            CfShop commentShop = null;
                            if (commentIsSeller && commentInfo != null && commentInfo.SellerId.HasValue && shopLookup.ContainsKey(commentInfo.SellerId.Value))
                            {
                                commentShop = shopLookup[commentInfo.SellerId.Value];
                            }
                            return new
                            {
                                AuthorName = customers.ContainsKey(c.CustomerId) ? customers[c.CustomerId] : "User",
                                IsSeller = commentIsSeller,
                                ShopName = commentShop != null ? commentShop.ShopName : string.Empty,
                                ShopUrl = commentShop != null && !string.IsNullOrWhiteSpace(commentShop.ShopCode) ? "/cua-hang/" + commentShop.ShopCode : "#",
                                Content = HttpUtility.HtmlDecode(c.Content)
                            };
                        }).ToList()
                };
            }).ToList();

            PostRepeater.DataSource = viewModels;
            PostRepeater.DataBind();
        }
    }

    private void ToggleLike(int customerId, int postId)
    {
        using (var db = new BeautyStoryContext())
        {
            var existing = db.CfCommunityLikes.FirstOrDefault(l => l.PostId == postId && l.CustomerId == customerId);
            var post = db.CfCommunityPosts.FirstOrDefault(p => p.Id == postId);
            if (post == null)
            {
                return;
            }

            if (existing != null)
            {
                db.CfCommunityLikes.Remove(existing);
                if (post.LikeCount > 0)
                {
                    post.LikeCount -= 1;
                }
            }
            else
            {
                db.CfCommunityLikes.Add(new CfCommunityLike
                {
                    PostId = postId,
                    CustomerId = customerId,
                    CreatedAt = DateTime.UtcNow
                });
                post.LikeCount += 1;

                if (post.CustomerId != customerId)
                {
                    CommunityNotificationHelper.Notify(post.CustomerId, "like", post.Id, "Bài viết của bạn vừa được thích.");
                }
            }

            db.SaveChanges();
        }
    }

    private void CreateComment(int customerId, int postId, string comment)
    {
        using (var db = new BeautyStoryContext())
        {
            var post = db.CfCommunityPosts.FirstOrDefault(p => p.Id == postId);
            if (post == null)
            {
                return;
            }

            db.CfCommunityComments.Add(new CfCommunityComment
            {
                PostId = postId,
                CustomerId = customerId,
                Content = CommunityHelper.NormalizeContent(comment),
                Status = true,
                CreatedAt = DateTime.UtcNow
            });
            post.CommentCount += 1;
            db.SaveChanges();

            if (post.CustomerId != customerId)
            {
                CommunityNotificationHelper.Notify(post.CustomerId, "comment", post.Id, "Bài viết của bạn có bình luận mới.");
            }
        }

        CommunityHelper.LogAction(customerId, CommunityHelper.ActionComment, "comment");
    }

    private List<string> SavePostImages()
    {
        var results = new List<string>();
        if (!PostImagesUpload.HasFiles)
        {
            return results;
        }

        var uploadRoot = Server.MapPath("~/upload/community");
        if (!Directory.Exists(uploadRoot))
        {
            Directory.CreateDirectory(uploadRoot);
        }

        foreach (var file in PostImagesUpload.PostedFiles)
        {
            var posted = file as HttpPostedFile;
            if (posted == null || posted.ContentLength <= 0)
            {
                continue;
            }

            var ext = Path.GetExtension(posted.FileName);
            var name = Guid.NewGuid().ToString("N") + ext;
            var path = Path.Combine(uploadRoot, name);
            posted.SaveAs(path);
            results.Add("/upload/community/" + name);
        }

        return results;
    }

    private int GetOrCreateDirectRoom(BeautyStoryContext db, int customerId, int targetId)
    {
        var existingRoomId = (from r in db.CfCommunityRooms
                              join m in db.CfCommunityRoomMembers on r.Id equals m.RoomId
                              where r.Status && !r.IsGroup
                                    && m.Status
                                    && (m.CustomerId == customerId || m.CustomerId == targetId)
                              group m by new { r.Id, r.CreatedAt } into g
                              where g.Select(x => x.CustomerId).Distinct().Count() == 2
                              orderby g.Key.CreatedAt descending
                              select g.Key.Id).FirstOrDefault();

        if (existingRoomId > 0)
        {
            return existingRoomId;
        }

        var room = new CfCommunityRoom
        {
            RoomName = null,
            IsGroup = false,
            CreatedBy = customerId,
            Status = true,
            CreatedAt = DateTime.UtcNow
        };
        db.CfCommunityRooms.Add(room);
        db.SaveChanges();

        db.CfCommunityRoomMembers.Add(new CfCommunityRoomMember
        {
            RoomId = room.Id,
            CustomerId = customerId,
            Role = "owner",
            Status = true,
            JoinedAt = DateTime.UtcNow
        });
        db.CfCommunityRoomMembers.Add(new CfCommunityRoomMember
        {
            RoomId = room.Id,
            CustomerId = targetId,
            Role = "member",
            Status = true,
            JoinedAt = DateTime.UtcNow
        });
        db.SaveChanges();

        return room.Id;
    }
}
