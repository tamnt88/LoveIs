using System;

using System.Collections.Generic;

using System.IO;

using System.Linq;

using System.Data.Entity;
using System.Web.UI.WebControls;

using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class CommunityDefault : CommunityPageBase

{

    public string ComposerDisplayName { get; set; }

    public string ComposerInitial { get; set; }

    public bool HasMorePosts { get; set; }

    public int? CurrentUserId { get; set; }
    public string MyPostsUrl { get; set; }



    public string NextPageUrl { get; set; }



    private const int PageSize = 20;



    protected override void OnLoad(EventArgs e)
    {
        if (string.Equals(Request.QueryString["debugdb"], "1", StringComparison.OrdinalIgnoreCase))
        {
            Response.Write(GetCurrentDatabaseName());
            Response.End();
            return;
        }

        base.OnLoad(e);
    }

    protected void Page_Load(object sender, EventArgs e)

    {

        BindComposerUser();

        if (!IsPostBack)

        {

            BindPosts();

        }

        BindOnlineUsers();

    }

    protected void SearchButton_Click(object sender, EventArgs e)



    {



        if (CurrentPageHidden != null)



        {



            CurrentPageHidden.Value = "1";



        }



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

        CurrentUserId = customerId.Value;
        MyPostsUrl = "/cong-dong?user=" + CurrentUserId.Value;

        if (CommunityHelper.IsRateLimited(customerId.Value, CommunityHelper.ActionPost, 5, 5))

        {

            PostMessage.Text = "Bạn đăng bài quá nhanh. Vui lòng thử lại sau.";

            return;

        }

        var content = PostContentInput.Text ?? string.Empty;

        var videoUrl = VideoUrlHidden != null ? VideoUrlHidden.Value : string.Empty;

        if (!string.IsNullOrWhiteSpace(videoUrl))

        {

            var embed = BuildYoutubeEmbed(videoUrl.Trim());

            if (!string.IsNullOrWhiteSpace(embed))

            {

                content = content + Environment.NewLine + embed;

            }

        }

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



        if (CurrentPageHidden != null)



        {



            CurrentPageHidden.Value = "1";



        }



        if (VideoUrlHidden != null)

        {

            VideoUrlHidden.Value = string.Empty;

        }

        BindPosts();

    }

    private void BindComposerUser()

    {

        MyPostsUrl = "/cong-dong";

        ComposerDisplayName = "LoveIs Community";

        ComposerInitial = "L";

        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();

        if (!customerId.HasValue)

        {

            return;

        }

        MyPostsUrl = "/cong-dong?user=" + customerId.Value;

        using (var db = new BeautyStoryContext())

        {

            var user = db.CfCustomers.AsNoTracking()

                .Where(c => c.Id == customerId.Value)

                .Select(c => new { c.DisplayName, c.Username })

                .FirstOrDefault();

            if (user == null)

            {

                return;

            }

            var name = string.IsNullOrWhiteSpace(user.DisplayName) ? user.Username : user.DisplayName;

            if (!string.IsNullOrWhiteSpace(name))

            {

                ComposerDisplayName = name;

                ComposerInitial = GetInitial(name);

            }

        }

    }

    private static string BuildYoutubeEmbed(string url)

    {

        if (string.IsNullOrWhiteSpace(url))

        {

            return string.Empty;

        }

        var id = ExtractYoutubeId(url);

        if (string.IsNullOrWhiteSpace(id))

        {

            return string.Empty;

        }

        return string.Format("<div class=\"community-video\"><iframe src=\"https://www.youtube.com/embed/{0}\" title=\"YouTube\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe></div>", id);

    }

    private static string ExtractYoutubeId(string url)

    {

        if (url.Contains("youtu.be/"))

        {

            var id = url.Split(new[] { "youtu.be/" }, StringSplitOptions.None)[1];

            var amp = id.IndexOf("?", StringComparison.Ordinal);

            return amp > -1 ? id.Substring(0, amp) : id;

        }

        var vIndex = url.IndexOf("v=", StringComparison.Ordinal);

        if (vIndex > -1)

        {

            var id = url.Substring(vIndex + 2);

            var amp = id.IndexOf("&", StringComparison.Ordinal);

            return amp > -1 ? id.Substring(0, amp) : id;

        }

        return string.Empty;

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

            var commentInput = e.Item.FindControl("ModalCommentInput") as System.Web.UI.WebControls.TextBox
                ?? e.Item.FindControl("CommentInput") as System.Web.UI.WebControls.TextBox;

            var replyHidden = e.Item.FindControl("ModalReplyToCommentId") as System.Web.UI.HtmlControls.HtmlInputHidden
                ?? e.Item.FindControl("ReplyToCommentId") as System.Web.UI.HtmlControls.HtmlInputHidden;

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

                PostMessage.Text = "Bạn thao tác quá nhanh. Vui lòng thử lại sau.";

                return;

            }

            if (!CommunityHelper.HasOnlyWhitelistedLinks(comment))

            {

                PostMessage.Text = "Nội dung chứa liên kết không được phép.";

                return;

            }

            int? replyToCommentId = null;

            if (replyHidden != null && !string.IsNullOrWhiteSpace(replyHidden.Value))

            {

                int parsed;

                if (int.TryParse(replyHidden.Value, out parsed))

                {

                    replyToCommentId = parsed;

                }

            }

            CreateComment(customerId.Value, postId, comment, replyToCommentId);


            commentInput.Text = string.Empty;

            if (replyHidden != null)

            {

                replyHidden.Value = string.Empty;

            }

            BindPosts();

        }

    }

    protected void LoadMoreButton_Click(object sender, EventArgs e)



    {



        int currentPage = 1;



        if (CurrentPageHidden != null && !string.IsNullOrWhiteSpace(CurrentPageHidden.Value))



        {



            int.TryParse(CurrentPageHidden.Value, out currentPage);



        }



        currentPage += 1;



        if (CurrentPageHidden != null)



        {



            CurrentPageHidden.Value = currentPage.ToString();



        }



        BindPosts();



    }



    private void BindPosts()

    {

        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();

        var query = (Request.QueryString["q"] ?? string.Empty).Trim();



        int currentPage = 1;

        if (CurrentPageHidden != null && !string.IsNullOrWhiteSpace(CurrentPageHidden.Value))

        {

            int.TryParse(CurrentPageHidden.Value, out currentPage);

        }

        else

        {

            int.TryParse(Request.QueryString["page"], out currentPage);

        }



        if (currentPage < 1)

        {

            currentPage = 1;

        }



        // SearchInput removed from UI.

        using (var db = new BeautyStoryContext())

        {

            var postQuery = db.CfCommunityPosts.Where(p => p.Status);
            int userId;
            if (int.TryParse(Request.QueryString["user"], out userId))
            {
                postQuery = postQuery.Where(p => p.CustomerId == userId);
            }

            if (!string.IsNullOrWhiteSpace(query))

            {

                postQuery = postQuery.Where(p => p.Content.Contains(query));

            }

            var takeCount = currentPage * PageSize;



            var posts = postQuery.AsNoTracking()



                .OrderByDescending(p => p.CreatedAt)



                .Take(takeCount + 1)



                .ToList();


            HasMorePosts = posts.Count > takeCount;



            if (HasMorePosts)



            {



                posts = posts.Take(takeCount).ToList();



            }



            if (CurrentPageHidden != null)



            {



                CurrentPageHidden.Value = currentPage.ToString();



            }



            if (LoadMoreButton != null)



            {



                LoadMoreButton.Visible = HasMorePosts;



            }



            if (posts.Count == 0)

            {

                PostRepeater.DataSource = new List<object>();

                PostRepeater.DataBind();

                return;

            }

            var postIds = posts.Select(p => p.Id).ToList();

            var images = db.CfCommunityPostImages

                .Where(i => postIds.Contains(i.PostId) && i.Status)

                .OrderBy(i => i.SortOrder)

                .AsNoTracking()

                .ToList();

            var comments = db.CfCommunityComments

                .Where(c => postIds.Contains(c.PostId) && c.Status)

                .OrderByDescending(c => c.CreatedAt)

                .AsNoTracking()

                .ToList();



            var commentIds = comments.Select(c => c.Id).ToList();



            var commentLikeCounts = commentIds.Count > 0



                ? db.CfCommunityCommentLikes.AsNoTracking()



                    .Where(l => commentIds.Contains(l.CommentId))



                    .GroupBy(l => l.CommentId)



                    .ToDictionary(g => g.Key, g => g.Count())



                : new Dictionary<int, int>();



            var commentLikedIds = customerId.HasValue && commentIds.Count > 0



                ? db.CfCommunityCommentLikes.AsNoTracking()



                    .Where(l => l.CustomerId == customerId.Value && commentIds.Contains(l.CommentId))



                    .Select(l => l.CommentId)



                    .ToList()



                : new List<int>();



            var commentLikedSet = new HashSet<int>(commentLikedIds);



            var likes = customerId.HasValue

                ? db.CfCommunityLikes.AsNoTracking()

                    .Where(l => l.CustomerId == customerId.Value && postIds.Contains(l.PostId))

                    .Select(l => l.PostId)

                    .ToList()

                : new List<int>();

            var customerIds = posts.Select(p => p.CustomerId).Distinct().ToList();

            var commentCustomerIds = comments.Select(c => c.CustomerId).Distinct().ToList();

            customerIds.AddRange(commentCustomerIds);

            customerIds = customerIds.Distinct().ToList();

            var customerInfo = db.CfCustomers.AsNoTracking()

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

                .Select(c => new CommunityUserInfo

                {

                    Id = c.Id,

                    Name = string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName,

                    IsSeller = c.IsSeller,

                    SellerId = c.SellerId

                })

                .ToList();

            var customers = customerInfo.ToDictionary(c => c.Id, c => c);

            var sellerIds = customerInfo

                .Where(c => c.IsSeller && c.SellerId.HasValue)

                .Select(c => c.SellerId.Value)

                .Distinct()

                .ToList();

            var shopLookup = sellerIds.Count > 0

                ? db.CfShops.AsNoTracking()

                    .Where(s => sellerIds.Contains(s.SellerId))

                    .ToList()

                    .ToDictionary(s => s.SellerId, s => s)

                : new Dictionary<int, CfShop>();

            var likedIds = new HashSet<int>(likes);

            var imagesByPost = images.ToLookup(i => i.PostId, i => i.ImageUrl);

            var commentsByPost = comments.ToLookup(c => c.PostId);

            var viewModels = posts.Select(post =>

            {

                var authorInfo = customers.ContainsKey(post.CustomerId) ? customers[post.CustomerId] : null;

                var isSeller = authorInfo != null && authorInfo.IsSeller;

                CfShop shop = null;

                if (isSeller && authorInfo != null && authorInfo.SellerId.HasValue && shopLookup.ContainsKey(authorInfo.SellerId.Value))

                {

                    shop = shopLookup[authorInfo.SellerId.Value];

                }

                return new CommunityPostViewModel
                {
                    PostId = post.Id,
                    AuthorName = authorInfo != null ? authorInfo.Name : "User",
                    AuthorUrl = authorInfo != null ? "/cong-dong?user=" + authorInfo.Id : "#",
                    AuthorInitial = GetInitial(authorInfo != null ? authorInfo.Name : "User"),
                    IsSeller = isSeller,
                    ShopName = shop != null ? shop.ShopName : string.Empty,
                    ShopUrl = shop != null && !string.IsNullOrWhiteSpace(shop.ShopCode) ? "/cua-hang/" + shop.ShopCode : "#",
                    CreatedAt = FormatRelativeTime(post.CreatedAt),
                    Content = HttpUtility.HtmlDecode(post.Content),
                    LikeCount = post.LikeCount,
                    CommentCount = post.CommentCount,
                    LikeLabel = likedIds.Contains(post.Id) ? "Bỏ thích" : "Thích",
                    IsLiked = likedIds.Contains(post.Id),
                    Images = imagesByPost[post.Id].ToList(),
                    Comments = BuildCommentViewModels(commentsByPost[post.Id].ToList(), customers, shopLookup, commentLikeCounts, commentLikedSet)
                };

            }).ToList();

            PostRepeater.DataSource = viewModels;

            PostRepeater.DataBind();

            int modalPostId;
            if (int.TryParse(Request.QueryString["post"], out modalPostId))
            {
                var selected = viewModels.FirstOrDefault(p => p.PostId == modalPostId);
                if (selected != null)
                {
                    PostModal.Visible = true;
                    PostModal.CssClass = "community-post-modal is-open";
                    PostModalRepeater.DataSource = new List<CommunityPostViewModel> { selected };
                    PostModalRepeater.DataBind();
                }
                else
                {
                    var modalPost = db.CfCommunityPosts.AsNoTracking()
                        .FirstOrDefault(p => p.Id == modalPostId && p.Status);
                    if (modalPost == null)
                    {
                        PostModal.Visible = false;
                        PostModal.CssClass = "community-post-modal";
                    }
                    else
                    {
                        var modalImages = db.CfCommunityPostImages.AsNoTracking()
                            .Where(i => i.PostId == modalPostId && i.Status)
                            .OrderBy(i => i.SortOrder)
                            .Select(i => i.ImageUrl)
                            .ToList();

                        var modalComments = db.CfCommunityComments.AsNoTracking()
                            .Where(c => c.PostId == modalPostId && c.Status)
                            .OrderByDescending(c => c.CreatedAt)
                            .ToList();

                        var modalCommentIds = modalComments.Select(c => c.Id).ToList();
                        var modalCommentLikeCounts = modalCommentIds.Count > 0
                            ? db.CfCommunityCommentLikes.AsNoTracking()
                                .Where(l => modalCommentIds.Contains(l.CommentId))
                                .GroupBy(l => l.CommentId)
                                .ToDictionary(g => g.Key, g => g.Count())
                            : new Dictionary<int, int>();

                        var modalCommentLikedIds = customerId.HasValue && modalCommentIds.Count > 0
                            ? db.CfCommunityCommentLikes.AsNoTracking()
                                .Where(l => l.CustomerId == customerId.Value && modalCommentIds.Contains(l.CommentId))
                                .Select(l => l.CommentId)
                                .ToList()
                            : new List<int>();
                        var modalCommentLikedSet = new HashSet<int>(modalCommentLikedIds);

                        var modalAuthor = db.CfCustomers.AsNoTracking()
                            .Where(c => c.Id == modalPost.CustomerId)
                            .Select(c => new
                            {
                                c.Id,
                                c.DisplayName,
                                c.Username,
                                c.IsSeller,
                                c.SellerId
                            })
                            .FirstOrDefault();

                        CommunityUserInfo modalAuthorInfo = null;
                        if (modalAuthor != null)
                        {
                            modalAuthorInfo = new CommunityUserInfo
                            {
                                Id = modalAuthor.Id,
                                Name = string.IsNullOrWhiteSpace(modalAuthor.DisplayName) ? modalAuthor.Username : modalAuthor.DisplayName,
                                IsSeller = modalAuthor.IsSeller,
                                SellerId = modalAuthor.SellerId
                            };
                        }

                        CfShop modalShop = null;
                        if (modalAuthorInfo != null && modalAuthorInfo.IsSeller && modalAuthorInfo.SellerId.HasValue)
                        {
                            modalShop = db.CfShops.AsNoTracking()
                                .FirstOrDefault(s => s.SellerId == modalAuthorInfo.SellerId.Value);
                        }

                        var modalLikes = customerId.HasValue
                            ? db.CfCommunityLikes.AsNoTracking()
                                .Where(l => l.CustomerId == customerId.Value && l.PostId == modalPostId)
                                .Select(l => l.PostId)
                                .ToList()
                            : new List<int>();
                        var modalLikedSet = new HashSet<int>(modalLikes);

                        var modalCustomerIds = modalComments.Select(c => c.CustomerId).Distinct().ToList();
                        if (modalAuthorInfo != null)
                        {
                            modalCustomerIds.Add(modalAuthorInfo.Id);
                        }
                        modalCustomerIds = modalCustomerIds.Distinct().ToList();
                        var modalCustomers = modalCustomerIds.Count > 0
                            ? db.CfCustomers.AsNoTracking()
                                .Where(c => modalCustomerIds.Contains(c.Id))
                                .Select(c => new
                                {
                                    c.Id,
                                    c.DisplayName,
                                    c.Username,
                                    c.IsSeller,
                                    c.SellerId
                                })
                                .ToList()
                                .Select(c => new CommunityUserInfo
                                {
                                    Id = c.Id,
                                    Name = string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName,
                                    IsSeller = c.IsSeller,
                                    SellerId = c.SellerId
                                })
                                .ToList()
                            : new List<CommunityUserInfo>();
                        var modalCustomerLookup = modalCustomers.ToDictionary(c => c.Id, c => c);

                        var modalViewModel = new CommunityPostViewModel
                        {
                            PostId = modalPost.Id,
                            AuthorName = modalAuthorInfo != null ? modalAuthorInfo.Name : "User",
                            AuthorUrl = modalAuthorInfo != null ? "/cong-dong?user=" + modalAuthorInfo.Id : "#",
                            AuthorInitial = GetInitial(modalAuthorInfo != null ? modalAuthorInfo.Name : "User"),
                            IsSeller = modalAuthorInfo != null && modalAuthorInfo.IsSeller,
                            ShopName = modalShop != null ? modalShop.ShopName : string.Empty,
                            ShopUrl = modalShop != null && !string.IsNullOrWhiteSpace(modalShop.ShopCode) ? "/cua-hang/" + modalShop.ShopCode : "#",
                            CreatedAt = FormatRelativeTime(modalPost.CreatedAt),
                            Content = HttpUtility.HtmlDecode(modalPost.Content),
                            LikeCount = modalPost.LikeCount,
                            CommentCount = modalPost.CommentCount,
                            LikeLabel = modalLikedSet.Contains(modalPost.Id) ? "Đã thích" : "Thích",
                            IsLiked = modalLikedSet.Contains(modalPost.Id),
                            Images = modalImages,
                            Comments = BuildCommentViewModels(modalComments, modalCustomerLookup, new Dictionary<int, CfShop>(), modalCommentLikeCounts, modalCommentLikedSet)
                        };

                        PostModal.Visible = true;
                        PostModal.CssClass = "community-post-modal is-open";
                        PostModalRepeater.DataSource = new List<CommunityPostViewModel> { modalViewModel };
                        PostModalRepeater.DataBind();
                    }
                }
            }
            else
            {
                PostModal.Visible = false;
                PostModal.CssClass = "community-post-modal";
            }

        }

    }

    protected void PostModalRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
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

        if (e.CommandName == "comment")
        {
            var commentInput = e.Item.FindControl("PostModalCommentInput") as System.Web.UI.WebControls.TextBox
                ?? e.Item.FindControl("ModalCommentInput") as System.Web.UI.WebControls.TextBox;
            var replyHidden = e.Item.FindControl("PostModalReplyToCommentId") as System.Web.UI.HtmlControls.HtmlInputHidden
                ?? e.Item.FindControl("ModalReplyToCommentId") as System.Web.UI.HtmlControls.HtmlInputHidden;
            if (commentInput == null)
            {
                return;
            }

            var comment = commentInput.Text ?? string.Empty;
            if (string.IsNullOrWhiteSpace(comment))
            {
                return;
            }

            int? replyToCommentId = null;
            if (replyHidden != null && !string.IsNullOrWhiteSpace(replyHidden.Value))
            {
                int parsed;
                if (int.TryParse(replyHidden.Value, out parsed))
                {
                    replyToCommentId = parsed;
                }
            }

            CreateComment(customerId.Value, postId, comment, replyToCommentId);
            commentInput.Text = string.Empty;
            if (replyHidden != null)
            {
                replyHidden.Value = string.Empty;
            }
            BindPosts();
        }
    }

    private static string GetCurrentDatabaseName()
    {
        using (var db = new BeautyStoryContext())
        {
            var name = db.Database.SqlQuery<string>("SELECT DB_NAME()").FirstOrDefault();
            return string.IsNullOrWhiteSpace(name) ? "UnknownDB" : name;
        }
    }

    private static List<object> BuildCommentViewModels(
        List<CfCommunityComment> comments,
        Dictionary<int, CommunityUserInfo> customers,
        Dictionary<int, CfShop> shopLookup,
        Dictionary<int, int> commentLikeCounts,
        HashSet<int> commentLikedSet)
    {
        if (comments == null || comments.Count == 0)
        {
            return new List<object>();
        }

        var activeComments = comments.Where(c => c.Status).ToList();
        var commentIds = new HashSet<int>(activeComments.Select(c => c.Id));
        var commentsByParent = activeComments
            .ToLookup(c =>
            {
                if (c.ParentId.HasValue && c.ParentId.Value > 0)
                {
                    return c.ParentId;
                }
                return (int?)null;
            });

        var topLevel = activeComments
            .Where(c => !c.ParentId.HasValue || c.ParentId.Value <= 0 || !commentIds.Contains(c.ParentId.Value))
            .OrderByDescending(c => c.CreatedAt)
            .ToList();

        var result = new List<object>();
        foreach (var comment in topLevel)
        {
            result.Add(BuildSingleCommentViewModel(comment, commentsByParent, customers, shopLookup, commentLikeCounts, commentLikedSet, 1));
        }

        return result;
    }

    private static object BuildSingleCommentViewModel(
        CfCommunityComment comment,
        ILookup<int?, CfCommunityComment> commentsByParent,
        Dictionary<int, CommunityUserInfo> customers,
        Dictionary<int, CfShop> shopLookup,
        Dictionary<int, int> commentLikeCounts,
        HashSet<int> commentLikedSet,
        int depth)
    {
        if (comment == null)
        {
            return null;
        }

        CommunityUserInfo authorInfo;
        customers.TryGetValue(comment.CustomerId, out authorInfo);
        var authorName = authorInfo != null ? authorInfo.Name : "User";
        var isSeller = authorInfo != null && authorInfo.IsSeller;
        CfShop shop = null;
        if (isSeller && authorInfo != null && authorInfo.SellerId.HasValue && shopLookup.ContainsKey(authorInfo.SellerId.Value))
        {
            shop = shopLookup[authorInfo.SellerId.Value];
        }

        var likeCount = 0;
        int countValue;
        if (commentLikeCounts != null && commentLikeCounts.TryGetValue(comment.Id, out countValue))
        {
            likeCount = countValue;
        }

        var replies = new List<object>();
        if (commentsByParent != null)
        {
            foreach (var child in commentsByParent[comment.Id].OrderBy(c => c.CreatedAt))
            {
                replies.Add(BuildSingleCommentViewModel(child, commentsByParent, customers, shopLookup, commentLikeCounts, commentLikedSet, depth + 1));
            }
        }

        return new
        {
            CommentId = comment.Id,
            AuthorName = authorName,
            AuthorInitial = GetInitial(authorName),
            Content = HttpUtility.HtmlDecode(comment.Content),
            CreatedAt = FormatRelativeTime(comment.CreatedAt),
            LikeCount = likeCount,
            IsLiked = commentLikedSet != null && commentLikedSet.Contains(comment.Id),
            IsSeller = isSeller,
            ShopName = shop != null ? shop.ShopName : string.Empty,
            ShopUrl = shop != null && !string.IsNullOrWhiteSpace(shop.ShopCode) ? "/cua-hang/" + shop.ShopCode : "#",
            Replies = replies,
            CanReply = depth < 3
        };
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object ToggleLikeAjax(int postId)
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return new { success = false };
        }

        using (var db = new BeautyStoryContext())
        {
            var existing = db.CfCommunityLikes.FirstOrDefault(l => l.PostId == postId && l.CustomerId == customerId.Value);
            var post = db.CfCommunityPosts.FirstOrDefault(p => p.Id == postId);
            if (post == null)
            {
                return new { success = false };
            }

            bool liked;
            if (existing != null)
            {
                db.CfCommunityLikes.Remove(existing);
                if (post.LikeCount > 0)
                {
                    post.LikeCount -= 1;
                }
                liked = false;
            }
            else
            {
                db.CfCommunityLikes.Add(new CfCommunityLike
                {
                    PostId = postId,
                    CustomerId = customerId.Value,
                    CreatedAt = DateTime.UtcNow
                });
                post.LikeCount += 1;
                liked = true;
            }

            db.SaveChanges();

            return new { success = true, likeCount = post.LikeCount, liked };
        }
    }


    private string BuildNextPageUrl(string query, int page, bool hasMore)



    {



        if (!hasMore)



        {



            return string.Empty;



        }



        var builder = new UriBuilder(Request.Url ?? new Uri("https://localhost/cong-dong"));



        var queryParts = HttpUtility.ParseQueryString(builder.Query);



        if (!string.IsNullOrWhiteSpace(query))



        {



            queryParts["q"] = query;



        }



        else



        {



            queryParts.Remove("q");



        }



        queryParts["page"] = page.ToString();



        builder.Query = queryParts.ToString();



        return builder.Path + (string.IsNullOrWhiteSpace(builder.Query) ? string.Empty : "?" + builder.Query);



    }





    private static string GetInitial(string name)

    {

        if (string.IsNullOrWhiteSpace(name))

        {

            return "U";

        }

        var trimmed = name.Trim();

        return trimmed.Substring(0, 1).ToUpperInvariant();

    }

    private void BindOnlineUsers()
    {
        using (var db = new BeautyStoryContext())
        {
            var since = DateTime.UtcNow.AddMinutes(-15);
            var onlineUsers = db.CfCustomers.AsNoTracking()
                .Where(c => c.Status && c.LastLoginAt.HasValue && c.LastLoginAt >= since)
                .OrderByDescending(c => c.LastLoginAt)
                .Take(100)
                .Select(c => new
                {
                    c.Id,
                    c.Username,
                    c.DisplayName
                })
                .ToList()
                .Select(c => new
                {
                    UserId = c.Id,
                    DisplayName = string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName,
                    Initial = GetInitial(string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName),
                    ProfileUrl = "/cong-dong?user=" + c.Id
                })
                .ToList();

            OnlineUserRepeater.DataSource = onlineUsers;
            OnlineUserRepeater.DataBind();
            OnlineEmpty.Visible = onlineUsers.Count == 0;
        }
    }


    private class CommunityUserInfo

    {

        public int Id { get; set; }

        public string Name { get; set; }

        public bool IsSeller { get; set; }

        public int? SellerId { get; set; }

    }

    private class CommunityPostViewModel
    {
        public int PostId { get; set; }
        public string AuthorName { get; set; }
        public string AuthorUrl { get; set; }
        public string AuthorInitial { get; set; }
        public bool IsSeller { get; set; }
        public string ShopName { get; set; }
        public string ShopUrl { get; set; }
        public string CreatedAt { get; set; }
        public string Content { get; set; }
        public int LikeCount { get; set; }
        public int CommentCount { get; set; }
        public string LikeLabel { get; set; }
        public bool IsLiked { get; set; }
        public List<string> Images { get; set; }
        public List<object> Comments { get; set; }
    }

    

    private static string FormatRelativeTime(DateTime createdAt)

    {

        var now = DateTime.UtcNow;

        var delta = now - createdAt;

        if (delta.TotalMinutes < 1)

        {

            return "Vừa xong";

        }

        if (delta.TotalMinutes < 60)

        {

            return string.Format("{0} phút", (int)delta.TotalMinutes);

        }

        if (delta.TotalHours < 24)

        {

            return string.Format("{0} giờ", (int)delta.TotalHours);

        }

        if (delta.TotalDays < 2)

        {

            return "Hôm qua";

        }

        if (delta.TotalDays < 7)

        {

            return string.Format("{0} ngày", (int)delta.TotalDays);

        }

        if (delta.TotalDays < 30)

        {

            return string.Format("{0} tuần", (int)(delta.TotalDays / 7));

        }

        if (delta.TotalDays < 365)

        {

            return string.Format("{0} tháng", (int)(delta.TotalDays / 30));

        }

        return string.Format("{0} năm", (int)(delta.TotalDays / 365));

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object ToggleCommentLikeAjax(int commentId)

    {

        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();

        if (!customerId.HasValue)

        {

            return new { success = false };

        }

        using (var db = new BeautyStoryContext())

        {

            var comment = db.CfCommunityComments.FirstOrDefault(c => c.Id == commentId && c.Status);

            if (comment == null)

            {

                return new { success = false };

            }

            var existing = db.CfCommunityCommentLikes.FirstOrDefault(l => l.CommentId == commentId && l.CustomerId == customerId.Value);

            bool liked;

            int likeCount;

            if (existing != null)

            {

                db.CfCommunityCommentLikes.Remove(existing);

                liked = false;

            }

            else

            {

                db.CfCommunityCommentLikes.Add(new CfCommunityCommentLike

                {

                    CommentId = commentId,

                    CustomerId = customerId.Value,

                    CreatedAt = DateTime.UtcNow

                });

                liked = true;

            }

            db.SaveChanges();

            likeCount = db.CfCommunityCommentLikes.Count(l => l.CommentId == commentId);

            return new { success = true, likeCount = likeCount, liked = liked };

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

    private void CreateComment(int customerId, int postId, string comment, int? replyToCommentId)

    {

        using (var db = new BeautyStoryContext())

        {

            var post = db.CfCommunityPosts.FirstOrDefault(p => p.Id == postId);

            if (post == null)

            {

                return;

            }

            int? normalizedParentId = null;
            if (replyToCommentId.HasValue && replyToCommentId.Value > 0)
            {
                normalizedParentId = replyToCommentId;
            }

            db.CfCommunityComments.Add(new CfCommunityComment

            {

                PostId = postId,

                CustomerId = customerId,

                Content = CommunityHelper.NormalizeContent(comment),

                ParentId = normalizedParentId,

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


