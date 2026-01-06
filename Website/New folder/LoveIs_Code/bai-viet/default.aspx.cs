using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

public partial class PostDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPost();
        }
    }

    private void BindPost()
    {
        string slug = RouteData.Values["slug"] as string;
        if (string.IsNullOrWhiteSpace(slug))
        {
            Response.Redirect("/tin-tuc");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfPostCategories.Where(c => c.Status).ToList();
            var categorySlugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "PostCategory")
                .ToList();

            var slugEntry = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Post" && s.SeoSlug == slug);
            if (slugEntry == null)
            {
                Response.Redirect("/tin-tuc");
                return;
            }

            var post = db.CfPosts.FirstOrDefault(p => p.Id == slugEntry.EntityId && p.Status);
            if (post == null)
            {
                Response.Redirect("/tin-tuc");
                return;
            }

            BindCategoryMenu(categories, categorySlugs, post.CategoryId);

            TitleLiteral.Text = HttpUtility.HtmlEncode(post.Title);
            BreadcrumbTitleLiteral.Text = TitleLiteral.Text;
            DateLiteral.Text = post.CreatedAt.ToString("dd/MM/yyyy");

            var contentHtml = post.Content ?? string.Empty;
            var tocHtml = BuildTableOfContents(ref contentHtml);
            ContentLiteral.Text = contentHtml;
            TocLiteral.Text = tocHtml;
            TocPanel.Visible = !string.IsNullOrWhiteSpace(tocHtml);

            if (!string.IsNullOrWhiteSpace(post.FeaturedImage))
            {
                FeaturedImage.ImageUrl = ResolveUrl(post.FeaturedImage);
                FeaturedImage.Visible = true;
            }

            var pageTitle = !string.IsNullOrWhiteSpace(post.SeoTitle) ? post.SeoTitle : post.Title;
            SeoTitleLiteral.Text = HttpUtility.HtmlEncode(pageTitle + " | LoveIs Store");

            SeoMetaLiteral.Text = string.Format(
                "<meta name=\"description\" content=\"{0}\" />",
                HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(post.SeoDescription) ? post.Summary : post.SeoDescription));

            BindTags(db, post.Id);
            BindRelatedPosts(db, post.Id, post.CategoryId);
        }
    }

    private void BindCategoryMenu(List<CfPostCategory> categories, List<CfSeoSlug> slugs, int activeCategoryId)
    {
        var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);
        var roots = categories
            .Where(c => !c.ParentId.HasValue)
            .OrderBy(c => c.SortOrder)
            .ThenBy(c => c.CategoryName)
            .ToList();

        var items = new List<CategoryItem>();
        foreach (var root in roots)
        {
            items.Add(BuildCategoryItem(root, categories, slugLookup, activeCategoryId));
        }

        PostCategoryRepeater.DataSource = items;
        PostCategoryRepeater.DataBind();
    }

    private CategoryItem BuildCategoryItem(
        CfPostCategory category,
        List<CfPostCategory> categories,
        Dictionary<int, string> slugLookup,
        int activeCategoryId)
    {
        var children = categories
            .Where(c => c.ParentId == category.Id)
            .OrderBy(c => c.SortOrder)
            .ThenBy(c => c.CategoryName)
            .ToList();

        var item = new CategoryItem
        {
            Id = category.Id,
            CategoryName = category.CategoryName,
            SeoSlug = slugLookup.ContainsKey(category.Id) ? slugLookup[category.Id] : string.Empty,
            Children = children.Select(child => BuildCategoryItem(child, categories, slugLookup, activeCategoryId)).ToList()
        };

        item.IsActive = category.Id == activeCategoryId ? "active" : string.Empty;
        item.IsOpen = IsTreeActive(item, activeCategoryId) ? "open" : string.Empty;
        return item;
    }

    private bool IsTreeActive(CategoryItem item, int activeCategoryId)
    {
        if (item.Id == activeCategoryId)
        {
            return true;
        }

        return item.Children.Any(child => IsTreeActive(child, activeCategoryId));
    }

    private void BindTags(BeautyStoryContext db, int postId)
    {
        var tagMaps = db.CfPostTagMaps
            .Where(m => m.PostId == postId && m.Status)
            .Select(m => m.TagId)
            .ToList();

        if (!tagMaps.Any())
        {
            TagPanel.Visible = false;
            return;
        }

        var tags = db.CfPostTags
            .Where(t => tagMaps.Contains(t.Id) && t.Status)
            .ToList();
        var slugLookup = db.CfSeoSlugs
            .Where(s => s.EntityType == "PostTag" && tagMaps.Contains(s.EntityId))
            .ToDictionary(s => s.EntityId, s => s.SeoSlug);

        var items = tags
            .OrderBy(t => t.SortOrder)
            .ThenBy(t => t.TagName)
            .Select(t => new TagItem
            {
                TagName = t.TagName,
                Url = BuildTagUrl(slugLookup.ContainsKey(t.Id) ? slugLookup[t.Id] : string.Empty)
            })
            .ToList();

        TagRepeater.DataSource = items;
        TagRepeater.DataBind();
        TagPanel.Visible = items.Any();
    }

    private string BuildTagUrl(string slug)
    {
        if (string.IsNullOrWhiteSpace(slug))
        {
            return "/tin-tuc";
        }

        return "/tin-tuc?tag=" + slug;
    }

    private void BindRelatedPosts(BeautyStoryContext db, int postId, int categoryId)
    {
        var related = db.CfPosts
            .Where(p => p.Status && p.Id != postId && p.CategoryId == categoryId)
            .OrderByDescending(p => p.CreatedAt)
            .Take(12)
            .ToList();

        if (!related.Any())
        {
            RelatedPanel.Visible = false;
            return;
        }

        var relatedIds = related.Select(p => p.Id).ToList();
        var slugLookup = db.CfSeoSlugs
            .Where(s => s.EntityType == "Post" && relatedIds.Contains(s.EntityId))
            .ToDictionary(s => s.EntityId, s => s.SeoSlug);

        var items = related.Select(p => new RelatedPostItem
        {
            PostTitle = p.Title,
            CreatedAt = p.CreatedAt.ToString("dd/MM/yyyy"),
            ImageUrl = string.IsNullOrWhiteSpace(p.FeaturedImage) ? "/images/logo_doc.png" : p.FeaturedImage,
            SeoSlug = slugLookup.ContainsKey(p.Id) ? slugLookup[p.Id] : string.Empty
        }).ToList();

        RelatedRepeater.DataSource = items;
        RelatedRepeater.DataBind();
        RelatedPanel.Visible = items.Any();
    }

    private string BuildTableOfContents(ref string contentHtml)
    {
        if (string.IsNullOrWhiteSpace(contentHtml))
        {
            return string.Empty;
        }

        var headings = new List<TocItem>();
        var usedIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var headingRegex = new Regex("<h([23])([^>]*)>(.*?)</h\\1>", RegexOptions.IgnoreCase | RegexOptions.Singleline);

        contentHtml = headingRegex.Replace(contentHtml, match =>
        {
            var level = match.Groups[1].Value;
            var attrs = match.Groups[2].Value ?? string.Empty;
            var innerHtml = match.Groups[3].Value ?? string.Empty;
            var plainText = StripHtml(innerHtml);

            if (string.IsNullOrWhiteSpace(plainText))
            {
                return match.Value;
            }

            var idMatch = Regex.Match(attrs, "\\bid\\s*=\\s*([\"'])(.*?)\\1", RegexOptions.IgnoreCase);
            var id = idMatch.Success ? idMatch.Groups[2].Value : BuildSlug(plainText);

            if (string.IsNullOrWhiteSpace(id))
            {
                return match.Value;
            }

            id = EnsureUniqueId(id, usedIds);
            headings.Add(new TocItem { Level = level, Title = plainText, Id = id });

            var updatedAttrs = idMatch.Success
                ? attrs
                : (string.IsNullOrWhiteSpace(attrs) ? " id=\"" + id + "\"" : attrs + " id=\"" + id + "\"");

            return "<h" + level + updatedAttrs + ">" + innerHtml + "</h" + level + ">";
        });

        if (!headings.Any())
        {
            return string.Empty;
        }

        var builder = new StringBuilder();
        builder.Append("<div class=\"post-toc-title\">Mục lục</div>");
        builder.Append("<ul class=\"post-toc-list\">");
        foreach (var item in headings)
        {
            builder.Append("<li class=\"post-toc-item post-toc-level-");
            builder.Append(item.Level);
            builder.Append("\"><a href=\"#");
            builder.Append(HttpUtility.HtmlAttributeEncode(item.Id));
            builder.Append("\">");
            builder.Append(HttpUtility.HtmlEncode(item.Title));
            builder.Append("</a></li>");
        }
        builder.Append("</ul>");
        return builder.ToString();
    }

    private static string StripHtml(string html)
    {
        var text = Regex.Replace(html, "<.*?>", string.Empty);
        return HttpUtility.HtmlDecode(text ?? string.Empty).Trim();
    }

    private static string BuildSlug(string text)
    {
        if (string.IsNullOrWhiteSpace(text))
        {
            return string.Empty;
        }

        var normalized = text.ToLowerInvariant().Normalize(NormalizationForm.FormD);
        var builder = new StringBuilder();
        foreach (var ch in normalized)
        {
            var category = CharUnicodeInfo.GetUnicodeCategory(ch);
            if (category == UnicodeCategory.NonSpacingMark)
            {
                continue;
            }
            if (char.IsLetterOrDigit(ch))
            {
                builder.Append(ch);
            }
            else if (char.IsWhiteSpace(ch) || ch == '-' || ch == '_')
            {
                builder.Append('-');
            }
        }

        var slug = Regex.Replace(builder.ToString(), "-{2,}", "-").Trim('-');
        return slug;
    }

    private static string EnsureUniqueId(string id, HashSet<string> usedIds)
    {
        var unique = id;
        var index = 1;
        while (usedIds.Contains(unique))
        {
            unique = id + "-" + index;
            index++;
        }
        usedIds.Add(unique);
        return unique;
    }

    private class TocItem
    {
        public string Level { get; set; }
        public string Title { get; set; }
        public string Id { get; set; }
    }

    public class CategoryItem
    {
        public CategoryItem()
        {
            Children = new List<CategoryItem>();
        }

        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string SeoSlug { get; set; }
        public string IsActive { get; set; }
        public string IsOpen { get; set; }
        public List<CategoryItem> Children { get; set; }
    }

    public class TagItem
    {
        public string TagName { get; set; }
        public string Url { get; set; }
    }

    public class RelatedPostItem
    {
        public string PostTitle { get; set; }
        public string CreatedAt { get; set; }
        public string ImageUrl { get; set; }
        public string SeoSlug { get; set; }
    }
}
