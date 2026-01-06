using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public partial class NewsDefault : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindData();
        }
    }

    private void BindData()
    {
        string slug = RouteData.Values["slug"] as string;
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            var categorySlugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "PostCategory")
                .ToList()
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            int? currentCategoryId = null;
            if (!string.IsNullOrWhiteSpace(slug))
            {
                var matched = categorySlugs.FirstOrDefault(s => s.Value == slug);
                if (matched.Key > 0)
                {
                    currentCategoryId = matched.Key;
                }
            }

            var categoryItems = categories
                .Select(c => new PostCategoryItem
                {
                    Id = c.Id,
                    CategoryName = c.CategoryName,
                    SeoSlug = categorySlugs.ContainsKey(c.Id) ? categorySlugs[c.Id] : string.Empty,
                    IsActive = currentCategoryId.HasValue && currentCategoryId.Value == c.Id ? "active" : string.Empty,
                    Children = new List<PostCategoryItem>()
                })
                .Where(c => !string.IsNullOrWhiteSpace(c.SeoSlug))
                .ToList();

            var categoryLookup = categories.ToDictionary(c => c.Id, c => c);
            var nodeLookup = categoryItems.ToDictionary(c => c.Id, c => c);
            foreach (var item in categoryItems)
            {
                var source = categoryLookup[item.Id];
                if (source.ParentId.HasValue && nodeLookup.ContainsKey(source.ParentId.Value))
                {
                    nodeLookup[source.ParentId.Value].Children.Add(item);
                }
            }

            var roots = categoryItems
                .Where(item => !categoryLookup[item.Id].ParentId.HasValue)
                .ToList();

            foreach (var root in roots)
            {
                foreach (var child in root.Children)
                {
                    var childSource = categoryLookup[child.Id];
                    child.Children = categoryItems
                        .Where(n => categoryLookup[n.Id].ParentId == childSource.Id)
                        .ToList();
                }
            }

            foreach (var root in roots)
            {
                root.IsOpen = IsTreeActive(root, currentCategoryId) ? "open" : string.Empty;
            }

            PostCategoryRepeater.DataSource = roots;
            PostCategoryRepeater.DataBind();

            var postSlugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Post")
                .ToList()
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var postQuery = db.CfPosts.Where(p => p.Status);
            if (currentCategoryId.HasValue)
            {
                postQuery = postQuery.Where(p => p.CategoryId == currentCategoryId.Value);
            }

            var posts = postQuery
                .OrderByDescending(p => p.CreatedAt)
                .Take(30)
                .ToList();

            var postItems = posts.Select(p => new PostItem
            {
                PostTitle = p.Title,
                CreatedAt = p.CreatedAt.ToString("dd/MM/yyyy"),
                Excerpt = string.IsNullOrWhiteSpace(p.Summary) ? "Đang cập nhật nội dung." : p.Summary,
                SeoSlug = postSlugs.ContainsKey(p.Id) ? postSlugs[p.Id] : string.Empty,
                ImageUrl = string.IsNullOrWhiteSpace(p.FeaturedImage) ? "/images/logo_doc.png" : p.FeaturedImage
            }).ToList();

            EmptyPanel.Visible = postItems.Count == 0;
            PostRepeater.DataSource = postItems;
            PostRepeater.DataBind();

            string pageTitle = "Tin tức";
            if (currentCategoryId.HasValue)
            {
                var currentCategory = categories.FirstOrDefault(c => c.Id == currentCategoryId.Value);
                if (currentCategory != null)
                {
                    pageTitle = currentCategory.CategoryName;
                }
            }

            PageTitleLiteral.Text = HttpUtility.HtmlEncode(pageTitle);
            BreadcrumbTitleLiteral.Text = HttpUtility.HtmlEncode(pageTitle);
            SeoTitleLiteral.Text = HttpUtility.HtmlEncode(pageTitle + " | LoveIs Store");
            SeoMetaLiteral.Text = string.Empty;
        }
    }

    private sealed class PostCategoryItem
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public string IsActive { get; set; }
        public string IsOpen { get; set; }
        public List<PostCategoryItem> Children { get; set; }
    }

    private sealed class PostItem
    {
        public string PostTitle { get; set; }
        public string CreatedAt { get; set; }
        public string Excerpt { get; set; }
        public string SeoSlug { get; set; }
        public string ImageUrl { get; set; }
    }

    private static bool IsTreeActive(PostCategoryItem node, int? currentCategoryId)
    {
        if (!currentCategoryId.HasValue)
        {
            return false;
        }

        if (node.Id == currentCategoryId.Value)
        {
            return true;
        }

        if (node.Children == null)
        {
            return false;
        }

        return node.Children.Any(child => IsTreeActive(child, currentCategoryId));
    }
}
