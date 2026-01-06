using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminProductsDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindFilters();
        }
    }

    private void BindFilters()
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfCategories
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .Select(c => new { c.Id, c.CategoryName })
                .ToList();

            FilterCategory.Items.Clear();
            FilterCategory.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả danh mục", ""));
            foreach (var item in categories)
            {
                FilterCategory.Items.Add(new System.Web.UI.WebControls.ListItem(item.CategoryName, item.Id.ToString()));
            }

            var brands = db.CfBrands
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();

            FilterBrand.Items.Clear();
            FilterBrand.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả thương hiệu", ""));
            foreach (var item in brands)
            {
                FilterBrand.Items.Add(new System.Web.UI.WebControls.ListItem(item.BrandName, item.Id.ToString()));
            }

            var origins = db.CfOrigins
                .OrderBy(o => o.SortOrder)
                .ThenBy(o => o.OriginName)
                .Select(o => new { o.Id, o.OriginName })
                .ToList();

            FilterOrigin.Items.Clear();
            FilterOrigin.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả xuất xứ", ""));
            foreach (var item in origins)
            {
                FilterOrigin.Items.Add(new System.Web.UI.WebControls.ListItem(item.OriginName, item.Id.ToString()));
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ProductRow> GetProducts(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string categoryId, string brandId, string originId, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var productInfos = (from p in db.CfProducts
                                join c in db.CfCategories on p.CategoryId equals c.Id
                                join b in db.CfBrands on p.BrandId equals b.Id into bjoin
                                from b in bjoin.DefaultIfEmpty()
                                join o in db.CfOrigins on p.OriginId equals o.Id into ojoin
                                from o in ojoin.DefaultIfEmpty()
                                select new
                                {
                                    Product = p,
                                    CategoryName = c.CategoryName,
                                    BrandName = b != null ? b.BrandName : null,
                                    OriginName = o != null ? o.OriginName : null
                                }).ToList();
            var slugs = db.CfSeoSlugs
                .Where(s => s.EntityType == "Product")
                .ToList();
            var slugLookup = slugs.ToDictionary(s => s.EntityId, s => s.SeoSlug);

            var variantPrices = db.CfProductVariants
                .Where(v => v.Status && (v.Price > 0 || (v.SalePrice.HasValue && v.SalePrice.Value > 0)))
                .GroupBy(v => v.ProductId)
                .Select(g => new
                {
                    ProductId = g.Key,
                    MinPrice = g.Min(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 ? v.SalePrice.Value : v.Price),
                    StockQty = g.Sum(v => v.StockQty)
                })
                .ToList();
            var priceLookup = variantPrices.ToDictionary(v => v.ProductId, v => v.MinPrice);
            var stockLookup = variantPrices.ToDictionary(v => v.ProductId, v => v.StockQty);

            var imageLookup = db.CfProductImages
                .Where(i => i.Status)
                .GroupBy(i => i.ProductId)
                .Select(g => new
                {
                    ProductId = g.Key,
                    ImageUrl = g.OrderByDescending(i => i.IsPrimary).ThenBy(i => i.SortOrder).Select(i => i.ImageUrl).FirstOrDefault()
                })
                .ToDictionary(i => i.ProductId, i => i.ImageUrl);

            var filteredProducts = productInfos.AsEnumerable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                filteredProducts = filteredProducts.Where(p => !string.IsNullOrWhiteSpace(p.Product.ProductName) && p.Product.ProductName.ToLowerInvariant().Contains(keyword));
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                filteredProducts = filteredProducts.Where(p => !string.IsNullOrWhiteSpace(p.Product.ProductName) && p.Product.ProductName.ToLowerInvariant().Contains(keyword));
            }

            int categoryFilterId;
            if (!string.IsNullOrWhiteSpace(categoryId) && int.TryParse(categoryId, out categoryFilterId))
            {
                filteredProducts = filteredProducts.Where(p => p.Product.CategoryId == categoryFilterId);
            }

            int brandFilterId;
            if (!string.IsNullOrWhiteSpace(brandId) && int.TryParse(brandId, out brandFilterId))
            {
                filteredProducts = filteredProducts.Where(p => p.Product.BrandId.HasValue && p.Product.BrandId.Value == brandFilterId);
            }

            int originFilterId;
            if (!string.IsNullOrWhiteSpace(originId) && int.TryParse(originId, out originFilterId))
            {
                filteredProducts = filteredProducts.Where(p => p.Product.OriginId.HasValue && p.Product.OriginId.Value == originFilterId);
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                bool statusValue = statusFilter == 1;
                filteredProducts = filteredProducts.Where(p => p.Product.Status == statusValue);
            }

            var total = productInfos.Count();
            var filtered = filteredProducts.Count();

            var rows = filteredProducts.Select(p =>
            {
                var slug = slugLookup.ContainsKey(p.Product.Id) ? slugLookup[p.Product.Id] : string.Empty;
                var slugHtml = string.IsNullOrWhiteSpace(slug) ? string.Empty : string.Format("<span class=\"slug-tag\">/{0}</span>", slug);
                decimal price = priceLookup.ContainsKey(p.Product.Id) ? priceLookup[p.Product.Id] : 0;
                int stockQty = stockLookup.ContainsKey(p.Product.Id) ? stockLookup[p.Product.Id] : 0;
                string imageUrl = imageLookup.ContainsKey(p.Product.Id) ? imageLookup[p.Product.Id] : "/images/logo_doc.png";

                return new ProductRow
                {
                    Id = p.Product.Id,
                    ImageHtml = string.Format("<img src=\"{0}\" alt=\"{1}\" class=\"table-thumb\" />", imageUrl, p.Product.ProductName),
                    ProductName = string.Format("{0}<div class=\"slug-wrap\">{1}</div>", p.Product.ProductName, slugHtml),
                    CategoryName = ProductTagHelper.FormatTag(p.CategoryName ?? "-", "info-tag-blue"),
                    BrandName = ProductTagHelper.FormatTag(p.BrandName ?? "-", "info-tag-rose"),
                    OriginName = ProductTagHelper.FormatTag(p.OriginName ?? "-", "info-tag-olive"),
                    MinPrice = price > 0 ? string.Format(new CultureInfo("vi-VN"), "{0:C0}", price) : "-",
                    StockQty = stockQty,
                    SortOrder = p.Product.SortOrder,
                    StatusValue = p.Product.Status ? 1 : 0,
                    StatusHtml = p.Product.Status
                        ? "<span class=\"status-tag status-on\">Hiển thị</span>"
                        : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/products/edit.aspx?id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteProduct({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button>" +
                        "</div>", p.Product.Id)
                };
            });

            rows = ProductTableSorter.ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length);

            return new DataTableResult<ProductRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = filtered,
                data = rows.ToList()
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult DeleteProduct(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var product = db.CfProducts.FirstOrDefault(p => p.Id == id);
            if (product == null)
            {
                return new ActionResult { Success = false, Message = "Sản phẩm không tồn tại." };
            }

            bool hasVariants = db.CfProductVariants.Any(v => v.ProductId == id);
            bool hasImages = db.CfProductImages.Any(i => i.ProductId == id);
            bool hasFilters = db.CfProductFilters.Any(f => f.ProductId == id);
            if (hasVariants || hasImages || hasFilters)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa sản phẩm đang được sử dụng." };
            }

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Product" && s.EntityId == id);
            if (slug != null)
            {
                db.CfSeoSlugs.Remove(slug);
            }

            db.CfProducts.Remove(product);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }
}

public class ProductRow
{
    public int Id { get; set; }
    public string ImageHtml { get; set; }
    public string ProductName { get; set; }
    public int CategoryId { get; set; }
    public int? BrandId { get; set; }
    public int? OriginId { get; set; }
    public string CategoryName { get; set; }
    public string BrandName { get; set; }
    public string OriginName { get; set; }
    public string MinPrice { get; set; }
    public int StockQty { get; set; }
    public int SortOrder { get; set; }
    public int StatusValue { get; set; }
    public string StatusHtml { get; set; }
    public string ActionsHtml { get; set; }
}

public static class ProductTableSorter
{
    public static IEnumerable<ProductRow> ApplyOrdering(IEnumerable<ProductRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.ProductName) : rows.OrderBy(r => r.ProductName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.CategoryName) : rows.OrderBy(r => r.CategoryName);
            case 2:
                return desc ? rows.OrderByDescending(r => r.BrandName) : rows.OrderBy(r => r.BrandName);
            case 3:
                return desc ? rows.OrderByDescending(r => r.OriginName) : rows.OrderBy(r => r.OriginName);
            case 4:
                return desc ? rows.OrderByDescending(r => r.MinPrice) : rows.OrderBy(r => r.MinPrice);
            default:
                return desc ? rows.OrderByDescending(r => r.ProductName) : rows.OrderBy(r => r.ProductName);
        }
    }
}

public static class ProductTagHelper
{
    public static string FormatTag(string value, string className)
    {
        if (string.IsNullOrWhiteSpace(value) || value == "-")
        {
            return "-";
        }

        return string.Format("<span class=\"info-tag {0}\">{1}</span>", className, value);
    }
}
