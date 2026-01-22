using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Data;
using System.Data.OleDb;
using System.Text;
using System.Web;

public partial class SellerProducts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProducts();
            DataBind();
        }
    }

    private const int PageSize = 10;
    private int _currentPage = 1;
    private string _statusKey = "all";
    private string _searchText = string.Empty;

    private void BindProducts()
    {
        _statusKey = (Request.QueryString["status"] ?? "all").Trim().ToLowerInvariant();
        _currentPage = ParsePage(Request.QueryString["page"]);
        _searchText = (Request.QueryString["q"] ?? string.Empty).Trim();

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                BindEmpty();
                return;
            }

            var products = db.CfProducts
                .Where(p => shopIds.Contains(p.ShopId ?? 0))
                .ToList();

            var productIds = products.Select(p => p.Id).ToList();
            var categories = db.CfCategories
                .Where(c => c.Status)
                .ToList()
                .ToDictionary(c => c.Id, c => c.CategoryName);

            var productSlugs = db.CfSeoSlugs
                .Where(s => s.Status && s.EntityType == "Product" && productIds.Contains(s.EntityId))
                .ToList()
                .GroupBy(s => s.EntityId)
                .ToDictionary(g => g.Key, g => g.First().SeoSlug);

            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            var images = db.CfProductImages
                .Where(i => i.Status && productIds.Contains(i.ProductId))
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .ToList()
                .GroupBy(i => i.ProductId)
                .ToDictionary(g => g.Key, g => g.First().ImageUrl);

            var totalCount = products.Count;
            var activeCount = products.Count(p => p.Status);
            var hiddenCount = products.Count(p => !p.Status);
            var outOfStockCount = products.Count(p => GetStockQty(variants, p.Id) <= 0);

            TotalProductLiteral.Text = totalCount.ToString();
            ActiveProductLiteral.Text = activeCount.ToString();
            HiddenProductLiteral.Text = hiddenCount.ToString();
            OutOfStockLiteral.Text = outOfStockCount.ToString();

            TabAllLiteral.Text = totalCount.ToString();
            TabActiveLiteral.Text = activeCount.ToString();
            TabHiddenLiteral.Text = hiddenCount.ToString();
            TabOutLiteral.Text = outOfStockCount.ToString();

            var filtered = FilterProducts(products, variants, _statusKey);
            if (!string.IsNullOrWhiteSpace(_searchText))
            {
                filtered = filtered
                    .Where(p =>
                    {
                        var categoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : string.Empty;
                        return (!string.IsNullOrWhiteSpace(p.ProductName) && p.ProductName.IndexOf(_searchText, StringComparison.OrdinalIgnoreCase) >= 0)
                            || (!string.IsNullOrWhiteSpace(categoryName) && categoryName.IndexOf(_searchText, StringComparison.OrdinalIgnoreCase) >= 0);
                    })
                    .ToList();
            }
            var totalPages = (int)Math.Ceiling(filtered.Count / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var paged = filtered
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var viewModels = paged.Select(p =>
            {
                var stockQty = GetStockQty(variants, p.Id);
                var rating = p.RatingAvg;
                var reviewCount = p.RatingCount;
                var imageUrl = images.ContainsKey(p.Id) ? images[p.Id] : "/images/fav.png";
                var priceLabel = GetPriceLabel(variants, p.Id);

                return new ProductRowViewModel
                {
                    ProductName = p.ProductName,
                    Sku = GetSku(variants, p.Id),
                    PriceLabel = priceLabel,
                    CategoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : "-",
                    StockLabel = stockQty.ToString(CultureInfo.InvariantCulture),
                    SoldLabel = p.Sold30d.ToString(CultureInfo.InvariantCulture),
                    RatingLabel = rating.ToString("0.0", CultureInfo.InvariantCulture),
                    ReviewLabel = string.Format("{0} đánh giá", reviewCount),
                    ViewLabel = p.ViewCount.ToString("N0", CultureInfo.InvariantCulture),
                    ImageUrl = imageUrl,
                    StatusLabel = ResolveStatusLabel(p, stockQty),
                    StatusClass = ResolveStatusClass(p, stockQty),
                    ProductId = p.Id,
                    ProductUrl = "/san-pham/" + (productSlugs.ContainsKey(p.Id) ? productSlugs[p.Id] : ("san-pham-" + p.Id)),
                    ViewUrl = "/seller/product-add.aspx?id=" + p.Id + "&mode=view",
                    EditUrl = "/seller/product-add.aspx?id=" + p.Id + "&mode=edit"
                };
            }).ToList();

            ProductRepeater.DataSource = viewModels;
            ProductRepeater.DataBind();

            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(filtered.Count);

            SearchTextBox.Text = _searchText;
        }
    }

    protected void ApplyFiltersButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(BuildFilterUrl(resetPage: true, clearFilters: false));
    }

    protected void ExportButton_Click(object sender, EventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        _statusKey = (Request.QueryString["status"] ?? "all").Trim().ToLowerInvariant();
        _searchText = (SearchTextBox.Text ?? string.Empty).Trim();

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return;
            }

            var products = db.CfProducts
                .Where(p => shopIds.Contains(p.ShopId ?? 0))
                .ToList();

            var productIds = products.Select(p => p.Id).ToList();
            var categories = db.CfCategories
                .Where(c => c.Status)
                .ToList()
                .ToDictionary(c => c.Id, c => c.CategoryName);

            var variants = db.CfProductVariants
                .Where(v => productIds.Contains(v.ProductId) && v.Status)
                .ToList();

            var filtered = FilterProducts(products, variants, _statusKey);
            if (!string.IsNullOrWhiteSpace(_searchText))
            {
                filtered = filtered
                    .Where(p =>
                    {
                        var categoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : string.Empty;
                        return (!string.IsNullOrWhiteSpace(p.ProductName) && p.ProductName.IndexOf(_searchText, StringComparison.OrdinalIgnoreCase) >= 0)
                            || (!string.IsNullOrWhiteSpace(categoryName) && categoryName.IndexOf(_searchText, StringComparison.OrdinalIgnoreCase) >= 0);
                    })
                    .ToList();
            }

            var rows = filtered.Select(p =>
            {
                var stockQty = GetStockQty(variants, p.Id);
                var rating = p.RatingAvg;
                var reviewCount = p.RatingCount;
                var categoryName = categories.ContainsKey(p.CategoryId) ? categories[p.CategoryId] : "-";
                var statusLabel = ResolveStatusLabel(p, stockQty);
                var actions = string.Format("Xem: {0} | Sửa: {1}", "/san-pham/" + p.Id, "/seller/products/edit.aspx?id=" + p.Id);

                return new ExportRow
                {
                    ProductName = p.ProductName,
                    CategoryName = categoryName,
                    StockLabel = stockQty.ToString(CultureInfo.InvariantCulture),
                    SoldLabel = p.Sold30d.ToString(CultureInfo.InvariantCulture),
                    RatingLabel = string.Format("{0:0.0} ({1} đánh giá)", rating, reviewCount),
                    ViewLabel = p.ViewCount.ToString("N0", CultureInfo.InvariantCulture),
                    StatusLabel = statusLabel,
                    Actions = actions
                };
            }).ToList();

            var fileName = "tat-ca-san-pham-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx";
            WriteXlsxResponse(rows, fileName);
        }
    }

    protected void ImportSubmitButton_Click(object sender, EventArgs e)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        if (ImportFileUpload == null || !ImportFileUpload.HasFile)
        {
            ImportMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng chọn file để nhập.</div>";
            return;
        }

        var extension = Path.GetExtension(ImportFileUpload.FileName);
        if (!string.Equals(extension, ".xlsx", StringComparison.OrdinalIgnoreCase))
        {
            ImportMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">File không hợp lệ. Vui lòng dùng file .xlsx.</div>";
            return;
        }

        List<ImportRow> rows;
        List<string> errors;
        if (!TryParseImportRows(out rows, out errors))
        {
            ImportMessageLiteral.Text = "<div class=\"alert alert-danger mt-3\">File không tuân thủ các trường cần thiết:<br/>" + string.Join("<br/>", errors) + "</div>";
            return;
        }

        if (rows.Count == 0)
        {
            ImportMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">File không có dữ liệu.</div>";
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var now = DateTime.Now;
            using (var tx = db.Database.BeginTransaction())
            {
                try
                {
                    foreach (var row in rows)
                    {
                        var product = new CfProduct
                        {
                            ProductName = row.ProductName,
                            CategoryId = row.CategoryId,
                            BrandId = row.BrandId,
                            OriginId = row.OriginId,
                            ShopId = row.ShopId,
                            Description = row.Description,
                            VideoUrl = row.VideoUrl,
                            Status = true,
                            CreatedAt = now,
                            CreatedBy = "Import",
                            SortOrder = 0,
                            PackageWeightGrams = row.WeightGrams,
                            PackageLengthCm = row.LengthCm,
                            PackageWidthCm = row.WidthCm,
                            PackageHeightCm = row.HeightCm,
                            RatingAvg = 0,
                            RatingCount = 0
                        };

                        db.CfProducts.Add(product);
                        db.SaveChanges();

                        var variant = new CfProductVariant
                        {
                            ProductId = product.Id,
                            VariantName = "Mặc định",
                            Sku = row.Sku,
                            Price = row.Price,
                            SalePrice = row.SalePrice,
                            StockQty = row.StockQty,
                            Status = true,
                            CreatedAt = now,
                            CreatedBy = "Import",
                            SortOrder = 0
                        };
                        db.CfProductVariants.Add(variant);

                        if (row.ImageUrls.Count > 0)
                        {
                            var sortOrder = 0;
                            foreach (var imageUrl in row.ImageUrls)
                            {
                                db.CfProductImages.Add(new CfProductImage
                                {
                                    ProductId = product.Id,
                                    ImageUrl = imageUrl,
                                    IsPrimary = sortOrder == 0,
                                    Status = true,
                                    CreatedAt = now,
                                    CreatedBy = "Import",
                                    SortOrder = sortOrder
                                });
                                sortOrder++;
                            }
                        }

                        db.SaveChanges();
                    }

                    tx.Commit();
                }
                catch (Exception ex)
                {
                    tx.Rollback();
                    ImportMessageLiteral.Text = "<div class=\"alert alert-danger mt-3\">Import thất bại: " + HttpUtility.HtmlEncode(ex.Message) + "</div>";
                    return;
                }
            }
        }

        ImportMessageLiteral.Text = "<div class=\"alert alert-success mt-3\">Đã nhập " + rows.Count + " sản phẩm.</div>";
        BindProducts();
        DataBind();
    }

    public string GetTabClass(string key)
    {
        return string.Equals(_statusKey, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    private static List<CfProduct> FilterProducts(List<CfProduct> products, List<CfProductVariant> variants, string statusKey)
    {
        if (string.IsNullOrWhiteSpace(statusKey) || statusKey == "all")
        {
            return products;
        }

        if (statusKey == "active")
        {
            return products.Where(p => p.Status).ToList();
        }

        if (statusKey == "hidden")
        {
            return products.Where(p => !p.Status).ToList();
        }

        if (statusKey == "out")
        {
            return products.Where(p => GetStockQty(variants, p.Id) <= 0).ToList();
        }

        return products;
    }

    private static int GetStockQty(List<CfProductVariant> variants, int productId)
    {
        return variants
            .Where(v => v.ProductId == productId)
            .Sum(v => v.StockQty);
    }

    private static string GetSku(List<CfProductVariant> variants, int productId)
    {
        var sku = variants
            .Where(v => v.ProductId == productId && !string.IsNullOrWhiteSpace(v.Sku))
            .OrderBy(v => v.SortOrder)
            .Select(v => v.Sku)
            .FirstOrDefault();
        return string.IsNullOrWhiteSpace(sku) ? "-" : sku;
    }

    private static string GetPriceLabel(List<CfProductVariant> variants, int productId)
    {
        var productVariants = variants.Where(v => v.ProductId == productId).ToList();
        if (productVariants.Count == 0)
        {
            return "Liên hệ";
        }

        var saleVariant = productVariants
            .Where(v => v.SalePrice.HasValue && v.SalePrice.Value > 0 && v.SalePrice.Value < v.Price)
            .OrderBy(v => v.SalePrice.Value)
            .FirstOrDefault();

        var variant = saleVariant ?? productVariants.OrderBy(v => v.Price).First();
        var price = variant.SalePrice.HasValue && variant.SalePrice.Value > 0 ? variant.SalePrice.Value : variant.Price;
        return string.Format("{0:N0} đ", price);
    }

    private static string ResolveStatusLabel(CfProduct product, int stockQty)
    {
        if (!product.Status)
        {
            return "Tạm ẩn";
        }
        if (stockQty <= 0)
        {
            return "Hết hàng";
        }
        return "Đang bán";
    }

    private static string ResolveStatusClass(CfProduct product, int stockQty)
    {
        if (!product.Status)
        {
            return "status-hidden";
        }
        if (stockQty <= 0)
        {
            return "status-out";
        }
        return "status-selling";
    }

    private void BindEmpty()
    {
        TotalProductLiteral.Text = "0";
        ActiveProductLiteral.Text = "0";
        HiddenProductLiteral.Text = "0";
        OutOfStockLiteral.Text = "0";
        TabAllLiteral.Text = "0";
        TabActiveLiteral.Text = "0";
        TabHiddenLiteral.Text = "0";
        TabOutLiteral.Text = "0";
        ProductRepeater.DataSource = new List<ProductRowViewModel>();
        ProductRepeater.DataBind();
        PaginationLiteral.Text = string.Empty;
    }

    private static int ParsePage(string raw)
    {
        int page;
        if (int.TryParse(raw, out page) && page > 0)
        {
            return page;
        }
        return 1;
    }

    private string BuildPagination(int totalPages)
    {
        if (totalPages <= 1)
        {
            return string.Empty;
        }

        var links = new List<string>();
        var baseUrl = BuildBaseUrl();

        links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&laquo;</a>", BuildPageUrl(baseUrl, 1)));
        if (_currentPage > 1)
        {
            links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&lsaquo;</a>", BuildPageUrl(baseUrl, _currentPage - 1)));
        }

        var start = Math.Max(1, _currentPage - 2);
        var end = Math.Min(totalPages, _currentPage + 2);
        for (int i = start; i <= end; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<span class=\"page-link active\">{0}</span>", i));
            }
            else
            {
                links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">{1}</a>", BuildPageUrl(baseUrl, i), i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&rsaquo;</a>", BuildPageUrl(baseUrl, _currentPage + 1)));
        }
        links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&raquo;</a>", BuildPageUrl(baseUrl, totalPages)));

        return string.Join("", links);
    }

    private string BuildPaginationInfo(int totalItems)
    {
        if (totalItems == 0)
        {
            return "Hiển thị 0 trong tổng số 0 sản phẩm";
        }

        int start = (_currentPage - 1) * PageSize + 1;
        int end = Math.Min(_currentPage * PageSize, totalItems);
        return string.Format("Hiển thị {0}-{1} trong tổng số {2} sản phẩm", start, end, totalItems);
    }

    private string BuildBaseUrl()
    {
        var query = new List<string>();
        if (!string.IsNullOrWhiteSpace(_statusKey))
        {
            query.Add("status=" + HttpUtility.UrlEncode(_statusKey));
        }

        if (!string.IsNullOrWhiteSpace(_searchText))
        {
            query.Add("q=" + HttpUtility.UrlEncode(_searchText));
        }

        if (query.Count == 0)
        {
            return "/seller/product-list.aspx";
        }
        return "/seller/product-list.aspx?" + string.Join("&", query);
    }

    protected void ProductRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (!string.Equals(e.CommandName, "DeleteProduct", StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        int productId;
        if (!int.TryParse(e.CommandArgument.ToString(), out productId))
        {
            ActionMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Sản phẩm không hợp lệ.</div>";
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            var product = db.CfProducts.FirstOrDefault(p => p.Id == productId && p.ShopId.HasValue && shopIds.Contains(p.ShopId.Value));
            if (product == null)
            {
                ActionMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Không tìm thấy sản phẩm.</div>";
                return;
            }

            product.Status = false;
            product.UpdatedAt = DateTime.Now;
            product.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);

            var variants = db.CfProductVariants.Where(v => v.ProductId == productId).ToList();
            foreach (var variant in variants)
            {
                variant.Status = false;
                variant.UpdatedAt = DateTime.Now;
                variant.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
            }

            var images = db.CfProductImages.Where(i => i.ProductId == productId).ToList();
            foreach (var image in images)
            {
                image.Status = false;
                image.UpdatedAt = DateTime.Now;
                image.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
            }

            db.SaveChanges();
        }

        ActionMessageLiteral.Text = "<div class=\"alert alert-success mt-3\">Đã xóa sản phẩm.</div>";
        BindProducts();
        DataBind();
    }

    private string BuildFilterUrl(bool resetPage, bool clearFilters)
    {
        var query = new List<string>();
        if (!string.IsNullOrWhiteSpace(_statusKey))
        {
            query.Add("status=" + HttpUtility.UrlEncode(_statusKey));
        }

        if (!clearFilters)
        {
            var search = (SearchTextBox.Text ?? string.Empty).Trim();
            if (!string.IsNullOrWhiteSpace(search))
            {
                query.Add("q=" + HttpUtility.UrlEncode(search));
            }
        }

        if (!resetPage && _currentPage > 1)
        {
            query.Add("page=" + _currentPage);
        }

        if (query.Count == 0)
        {
            return "/seller/product-list.aspx";
        }

        return "/seller/product-list.aspx?" + string.Join("&", query);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    private void WriteXlsxResponse(List<ExportRow> rows, string fileName)
    {
        var bytes = BuildXlsx(rows);
        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        Response.BinaryWrite(bytes);
        Response.End();
    }

    private static byte[] BuildXlsx(List<ExportRow> rows)
    {
        var headers = new[]
        {
            "Sản phẩm", "Danh mục", "Kho", "Đã bán", "Đánh giá", "Lượt xem", "Trạng thái", "Thao tác"
        };
        var data = new List<string[]>
        {
            headers
        };

        foreach (var row in rows)
        {
            data.Add(new[]
            {
                row.ProductName ?? string.Empty,
                row.CategoryName ?? string.Empty,
                row.StockLabel ?? string.Empty,
                row.SoldLabel ?? string.Empty,
                row.RatingLabel ?? string.Empty,
                row.ViewLabel ?? string.Empty,
                row.StatusLabel ?? string.Empty,
                row.Actions ?? string.Empty
            });
        }

        using (var stream = new MemoryStream())
        {
            using (var archive = new ZipArchive(stream, ZipArchiveMode.Create, true))
            {
                AddZipEntry(archive, "[Content_Types].xml", BuildContentTypesXml());
                AddZipEntry(archive, "_rels/.rels", BuildRootRelsXml());
                AddZipEntry(archive, "xl/workbook.xml", BuildWorkbookXml());
                AddZipEntry(archive, "xl/_rels/workbook.xml.rels", BuildWorkbookRelsXml());
                AddZipEntry(archive, "xl/worksheets/sheet1.xml", BuildWorksheetXml(data));
            }

            return stream.ToArray();
        }
    }

    private static void AddZipEntry(ZipArchive archive, string path, string content)
    {
        var entry = archive.CreateEntry(path, CompressionLevel.Fastest);
        using (var writer = new StreamWriter(entry.Open(), Encoding.UTF8))
        {
            writer.Write(content);
        }
    }

    private static string BuildContentTypesXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">"
            + "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>"
            + "<Default Extension=\"xml\" ContentType=\"application/xml\"/>"
            + "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>"
            + "<Override PartName=\"/xl/worksheets/sheet1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>"
            + "</Types>";
    }

    private static string BuildRootRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorkbookXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" "
            + "xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">"
            + "<sheets><sheet name=\"Products\" sheetId=\"1\" r:id=\"rId1\"/></sheets>"
            + "</workbook>";
    }

    private static string BuildWorkbookRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorksheetXml(List<string[]> rows)
    {
        var builder = new StringBuilder();
        builder.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        builder.Append("<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
        builder.Append("<sheetData>");

        for (var i = 0; i < rows.Count; i++)
        {
            var rowIndex = i + 1;
            builder.Append("<row r=\"").Append(rowIndex).Append("\">");
            var cols = rows[i];
            for (var c = 0; c < cols.Length; c++)
            {
                var cellRef = ColumnName(c) + rowIndex.ToString(CultureInfo.InvariantCulture);
                builder.Append("<c r=\"").Append(cellRef).Append("\" t=\"inlineStr\"><is><t xml:space=\"preserve\">");
                builder.Append(EscapeXml(cols[c] ?? string.Empty));
                builder.Append("</t></is></c>");
            }
            builder.Append("</row>");
        }

        builder.Append("</sheetData>");
        builder.Append("</worksheet>");
        return builder.ToString();
    }

    private static string ColumnName(int index)
    {
        var dividend = index + 1;
        var name = string.Empty;
        while (dividend > 0)
        {
            var modulo = (dividend - 1) % 26;
            name = Convert.ToChar(65 + modulo) + name;
            dividend = (dividend - modulo) / 26;
        }
        return name;
    }

    private static string EscapeXml(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return string.Empty;
        }

        return value
            .Replace("&", "&amp;")
            .Replace("<", "&lt;")
            .Replace(">", "&gt;")
            .Replace("\"", "&quot;")
            .Replace("'", "&apos;");
    }

    public class ProductRowViewModel
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductUrl { get; set; }
        public string Sku { get; set; }
        public string PriceLabel { get; set; }
        public string CategoryName { get; set; }
        public string StockLabel { get; set; }
        public string SoldLabel { get; set; }
        public string RatingLabel { get; set; }
        public string ReviewLabel { get; set; }
        public string ViewLabel { get; set; }
        public string ImageUrl { get; set; }
        public string StatusLabel { get; set; }
        public string StatusClass { get; set; }
        public string ViewUrl { get; set; }
        public string EditUrl { get; set; }
    }

    private bool TryParseImportRows(out List<ImportRow> rows, out List<string> errors)
    {
        rows = new List<ImportRow>();
        errors = new List<string>();

        var lines = ReadExcelRows(ImportFileUpload.PostedFile.InputStream);
        if (lines.Count == 0)
        {
            errors.Add("Thiếu dòng tiêu đề.");
            return false;
        }

        var headers = lines[0];
        var headerMap = headers
            .Select((h, i) => new { Header = (h ?? string.Empty).Trim(), Index = i })
            .Where(h => !string.IsNullOrWhiteSpace(h.Header))
            .ToDictionary(h => h.Header, h => h.Index, StringComparer.OrdinalIgnoreCase);

        var required = new[] { "ProductName", "CategoryName", "ShopName", "Price", "StockQty" };
        foreach (var key in required)
        {
            if (!headerMap.ContainsKey(key))
            {
                errors.Add("Thiếu cột bắt buộc: " + key);
            }
        }

        if (errors.Count > 0)
        {
            return false;
        }

        var sellerId = SellerAuth.GetSellerId();
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfCategories
                .Where(c => c.Status)
                .ToList()
                .GroupBy(c => c.CategoryName ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First().Id, StringComparer.OrdinalIgnoreCase);
            var defaultCategoryId = categories.Values.FirstOrDefault();

            var brands = db.CfBrands
                .Where(b => b.Status)
                .ToList()
                .GroupBy(b => b.BrandName ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First().Id, StringComparer.OrdinalIgnoreCase);

            var origins = db.CfOrigins
                .Where(o => o.Status)
                .ToList()
                .GroupBy(o => o.OriginName ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First().Id, StringComparer.OrdinalIgnoreCase);

            var shops = db.CfShops
                .Where(s => sellerId.HasValue && s.SellerId == sellerId.Value)
                .ToList()
                .GroupBy(s => s.ShopName ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First().Id, StringComparer.OrdinalIgnoreCase);
            var defaultShopId = shops.Values.FirstOrDefault();

            for (var i = 1; i < lines.Count; i++)
            {
                var values = lines[i];
                if (values.All(string.IsNullOrWhiteSpace))
                {
                    continue;
                }
                var productName = GetField(values, headerMap, "ProductName");
                var categoryName = GetField(values, headerMap, "CategoryName");
                var shopName = GetField(values, headerMap, "ShopName");
                var priceRaw = GetField(values, headerMap, "Price");
                var stockRaw = GetField(values, headerMap, "StockQty");

                var rowErrors = new List<string>();

                if (string.IsNullOrWhiteSpace(productName))
                {
                    rowErrors.Add("thiếu ProductName");
                }

                int categoryId;
                if (!string.IsNullOrWhiteSpace(categoryName) && categories.ContainsKey(categoryName))
                {
                    categoryId = categories[categoryName];
                }
                else
                {
                    var categoryIdRaw = GetField(values, headerMap, "CategoryId");
                    int parsedCategoryId;
                    if (int.TryParse(categoryIdRaw, out parsedCategoryId) && parsedCategoryId > 0)
                    {
                        categoryId = parsedCategoryId;
                    }
                    else if (defaultCategoryId > 0)
                    {
                        categoryId = defaultCategoryId;
                    }
                    else
                    {
                        rowErrors.Add("CategoryName/CategoryId không hợp lệ");
                        categoryId = 0;
                    }
                }

                int shopId;
                if (!string.IsNullOrWhiteSpace(shopName) && shops.ContainsKey(shopName))
                {
                    shopId = shops[shopName];
                }
                else
                {
                    var shopIdRaw = GetField(values, headerMap, "ShopId");
                    int parsedShopId;
                    if (int.TryParse(shopIdRaw, out parsedShopId) && parsedShopId > 0)
                    {
                        shopId = parsedShopId;
                    }
                    else if (defaultShopId > 0)
                    {
                        shopId = defaultShopId;
                    }
                    else
                    {
                        rowErrors.Add("ShopName/ShopId không hợp lệ");
                        shopId = 0;
                    }
                }

                var price = ParseDecimal(priceRaw);
                if (price <= 0)
                {
                    rowErrors.Add("Price không hợp lệ");
                }

                int stockQty;
                if (!int.TryParse(stockRaw, out stockQty) || stockQty < 0)
                {
                    rowErrors.Add("StockQty không hợp lệ");
                }

                var brandName = GetField(values, headerMap, "BrandName");
                int? brandId = null;
                if (!string.IsNullOrWhiteSpace(brandName))
                {
                    if (brands.ContainsKey(brandName))
                    {
                        brandId = brands[brandName];
                    }
                    else
                    {
                        rowErrors.Add("BrandName không hợp lệ");
                    }
                }

                var originName = GetField(values, headerMap, "OriginName");
                int? originId = null;
                if (!string.IsNullOrWhiteSpace(originName))
                {
                    if (origins.ContainsKey(originName))
                    {
                        originId = origins[originName];
                    }
                    else
                    {
                        rowErrors.Add("OriginName không hợp lệ");
                    }
                }

                var salePrice = ParseNullableDecimal(GetField(values, headerMap, "SalePrice"));
                var description = GetField(values, headerMap, "Description");
                var sku = GetField(values, headerMap, "Sku");
                var videoUrl = GetField(values, headerMap, "VideoUrl");
                var imageUrls = ParseImageUrls(GetField(values, headerMap, "ImageUrls"));

                var weight = ParseNullableDecimal(GetField(values, headerMap, "WeightGrams"));
                var length = ParseNullableDecimal(GetField(values, headerMap, "LengthCm"));
                var width = ParseNullableDecimal(GetField(values, headerMap, "WidthCm"));
                var height = ParseNullableDecimal(GetField(values, headerMap, "HeightCm"));

                if (rowErrors.Count > 0)
                {
                    errors.Add("Dòng " + (i + 1) + ": " + string.Join(", ", rowErrors));
                    continue;
                }

                rows.Add(new ImportRow
                {
                    ProductName = productName,
                    CategoryId = categoryId,
                    ShopId = shopId,
                    BrandId = brandId,
                    OriginId = originId,
                    Price = price,
                    SalePrice = salePrice,
                    StockQty = stockQty,
                    Description = description,
                    Sku = sku,
                    VideoUrl = videoUrl,
                    ImageUrls = imageUrls,
                    WeightGrams = weight,
                    LengthCm = length,
                    WidthCm = width,
                    HeightCm = height
                });
            }
        }

        if (errors.Count > 0)
        {
            return false;
        }

        return true;
    }

    private static List<List<string>> ReadExcelRows(Stream stream)
    {
        var rows = new List<List<string>>();
        if (stream == null)
        {
            return rows;
        }

        var tempPath = Path.GetTempFileName();
        var tempFile = Path.ChangeExtension(tempPath, ".xlsx");
        try
        {
            using (var fileStream = File.Create(tempFile))
            {
                stream.Position = 0;
                stream.CopyTo(fileStream);
            }

            var connectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + tempFile + ";Extended Properties='Excel 12.0 Xml;HDR=YES;IMEX=1';";
            using (var connection = new OleDbConnection(connectionString))
            {
                connection.Open();
                var schema = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (schema == null || schema.Rows.Count == 0)
                {
                    return rows;
                }

                var sheetName = schema.Rows[0]["TABLE_NAME"].ToString();
                if (string.IsNullOrWhiteSpace(sheetName))
                {
                    return rows;
                }

                var commandText = "SELECT * FROM [" + sheetName + "]";
                using (var adapter = new OleDbDataAdapter(commandText, connection))
                {
                    var table = new DataTable();
                    adapter.Fill(table);

                    var headers = new List<string>();
                    foreach (DataColumn col in table.Columns)
                    {
                        headers.Add(col.ColumnName ?? string.Empty);
                    }
                    rows.Add(headers);

                    foreach (DataRow row in table.Rows)
                    {
                        var values = new List<string>();
                        foreach (var item in row.ItemArray)
                        {
                            values.Add(item == null ? string.Empty : item.ToString());
                        }
                        rows.Add(values);
                    }
                }
            }
        }
        catch
        {
            return new List<List<string>>();
        }
        finally
        {
            try
            {
                if (File.Exists(tempFile))
                {
                    File.Delete(tempFile);
                }
                else if (File.Exists(tempPath))
                {
                    File.Delete(tempPath);
                }
            }
            catch
            {
                // Ignore cleanup failures.
            }
        }

        return rows;
    }

    private static string GetField(List<string> values, Dictionary<string, int> headerMap, string key)
    {
        int index;
        if (!headerMap.TryGetValue(key, out index))
        {
            return string.Empty;
        }
        return index < values.Count ? (values[index] ?? string.Empty).Trim() : string.Empty;
    }

    private static decimal ParseDecimal(string raw)
    {
        decimal value;
        if (decimal.TryParse(raw, NumberStyles.Number, CultureInfo.InvariantCulture, out value))
        {
            return value;
        }
        if (decimal.TryParse(raw, NumberStyles.Number, CultureInfo.GetCultureInfo("vi-VN"), out value))
        {
            return value;
        }
        return 0;
    }

    private static decimal? ParseNullableDecimal(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return null;
        }
        var value = ParseDecimal(raw);
        return value > 0 ? (decimal?)value : null;
    }

    private static List<string> ParseImageUrls(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return new List<string>();
        }

        return raw
            .Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(u => (u ?? string.Empty).Trim())
            .Where(u => !string.IsNullOrWhiteSpace(u))
            .ToList();
    }

    private class ImportRow
    {
        public ImportRow()
        {
            ImageUrls = new List<string>();
        }

        public string ProductName { get; set; }
        public int CategoryId { get; set; }
        public int ShopId { get; set; }
        public int? BrandId { get; set; }
        public int? OriginId { get; set; }
        public decimal Price { get; set; }
        public decimal? SalePrice { get; set; }
        public int StockQty { get; set; }
        public string Description { get; set; }
        public string Sku { get; set; }
        public string VideoUrl { get; set; }
        public List<string> ImageUrls { get; set; }
        public decimal? WeightGrams { get; set; }
        public decimal? LengthCm { get; set; }
        public decimal? WidthCm { get; set; }
        public decimal? HeightCm { get; set; }
    }

    private class ExportRow
    {
        public string ProductName { get; set; }
        public string CategoryName { get; set; }
        public string StockLabel { get; set; }
        public string SoldLabel { get; set; }
        public string RatingLabel { get; set; }
        public string ViewLabel { get; set; }
        public string StatusLabel { get; set; }
        public string Actions { get; set; }
    }
}


