using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public partial class BrandList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBrandList();
        }
    }

    private void BindBrandList()
    {
        using (var db = new BeautyStoryContext())
        {
            var brands = db.CfBrands
                .Where(b => b.Status)
                .ToList();

            var slugLookup = db.CfSeoSlugs
                .Where(s => s.EntityType == "Brand")
                .ToList()
                .ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var items = brands
                .Select(b => new BrandItem
                {
                    Id = b.Id,
                    BrandName = b.BrandName,
                    GroupKey = GetGroupKey(b.BrandName),
                    LogoUrl = ResolveLogoUrl(b),
                    Url = BuildBrandUrl(slugLookup, b.Id)
                })
                .OrderBy(b => b.BrandName)
                .ToList();

            BrandCountLiteral.Text = string.Format("Xem {0:N0} thương hiệu", items.Count);

            var groups = BuildGroups(items);
            IndexRepeater.DataSource = groups.Select(g => new { g.Key, g.Label }).ToList();
            IndexRepeater.DataBind();

            GroupRepeater.DataSource = groups;
            GroupRepeater.DataBind();

            SeoTitleLiteral.Text = "Thương hiệu | LoveIs Store";
            SeoMetaLiteral.Text = string.Empty;
        }
    }

    private static string ResolveLogoUrl(CfBrand brand)
    {
        if (brand == null)
        {
            return "/images/logo_ngang.png";
        }

        if (!string.IsNullOrWhiteSpace(brand.LogoUrl))
        {
            return brand.LogoUrl;
        }

        if (!string.IsNullOrWhiteSpace(brand.IconUrl))
        {
            return brand.IconUrl;
        }

        return "/images/logo_ngang.png";
    }

    private static string BuildBrandUrl(Dictionary<int, string> slugLookup, int brandId)
    {
        string slug = slugLookup.ContainsKey(brandId) ? slugLookup[brandId] : string.Empty;
        return string.IsNullOrWhiteSpace(slug) ? "/thuong-hieu" : "/thuong-hieu/" + slug;
    }

    private static string GetGroupKey(string brandName)
    {
        if (string.IsNullOrWhiteSpace(brandName))
        {
            return "0-9";
        }

        char first = brandName.Trim()[0];
        if (char.IsDigit(first))
        {
            return "0-9";
        }

        if (char.IsLetter(first))
        {
            return char.ToUpperInvariant(first).ToString();
        }

        return "0-9";
    }

    private static List<BrandGroup> BuildGroups(List<BrandItem> items)
    {
        var grouped = items
            .GroupBy(i => i.GroupKey)
            .ToDictionary(g => g.Key, g => g.OrderBy(i => i.BrandName).ToList());

        var orderedKeys = new List<string> { "0-9" };
        for (char c = 'A'; c <= 'Z'; c++)
        {
            orderedKeys.Add(c.ToString());
        }

        var result = new List<BrandGroup>();
        foreach (var key in orderedKeys)
        {
            if (!grouped.ContainsKey(key))
            {
                continue;
            }

            result.Add(new BrandGroup
            {
                Key = key,
                Label = key,
                Items = grouped[key]
            });
        }

        return result;
    }

    private class BrandItem
    {
        public int Id { get; set; }
        public string BrandName { get; set; }
        public string LogoUrl { get; set; }
        public string Url { get; set; }
        public string GroupKey { get; set; }
    }

    private class BrandGroup
    {
        public string Key { get; set; }
        public string Label { get; set; }
        public List<BrandItem> Items { get; set; }
    }
}
