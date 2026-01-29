using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

public partial class SellerProductImport : System.Web.UI.Page
{
    private int? _batchId;
    private int? _itemId;
    private string _filter = "all";

    public string ProgressPercent { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        _batchId = ParseInt(Request.QueryString["batchId"]);
        _itemId = ParseInt(Request.QueryString["itemId"]);
        _filter = (Request.QueryString["filter"] ?? "all").Trim().ToLowerInvariant();

        if (!IsPostBack)
        {
            ProgressPercent = "0";
            ResolveBatchId();
            if (!_batchId.HasValue)
            {
                Response.Redirect("/seller/product-list.aspx");
                return;
            }

            BatchIdInput.Value = _batchId.Value.ToString(CultureInfo.InvariantCulture);
            BindDropdowns();
            BindItems();
            LoadCurrentItem();
            DataBind();
        }
    }

    protected void SaveNextButton_Click(object sender, EventArgs e)
    {
        if (!EnsureBatchAndItem())
        {
            return;
        }

        SaveDraftItem();
        RedirectToNextItem();
    }

    protected void FinishButton_Click(object sender, EventArgs e)
    {
        if (!EnsureBatchAndItem())
        {
            return;
        }

        SaveDraftItem();

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfProductImportItems
                .Where(i => i.BatchId == _batchId.Value)
                .ToList();

            var invalid = items
                .Where(i => !i.IsDuplicatedSku && !IsDraftCompleted(i))
                .ToList();
            if (invalid.Count > 0)
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng hoàn tất các sản phẩm còn thiếu thông tin.</div>";
                BindItems();
                LoadCurrentItem();
                return;
            }

            var now = DateTime.Now;
            using (var tx = db.Database.BeginTransaction())
            {
                try
                {
                    foreach (var item in items)
                    {
                        if (item.IsDuplicatedSku)
                        {
                            continue;
                        }

                        var product = new CfProduct
                        {
                            ProductName = item.ProductName,
                            CategoryId = item.CategoryId ?? 0,
                            BrandId = item.BrandId,
                            OriginId = item.OriginId,
                            ShopId = GetShopId(db),
                            Description = item.Description,
                            VideoUrl = item.VideoUrl,
                            Status = true,
                            CreatedAt = now,
                            CreatedBy = "Import",
                            SortOrder = 0,
                            PackageWeightGrams = item.PackageWeightGrams,
                            PackageLengthCm = item.PackageLengthCm,
                            PackageWidthCm = item.PackageWidthCm,
                            PackageHeightCm = item.PackageHeightCm,
                            RatingAvg = 0,
                            RatingCount = 0
                        };

                        db.CfProducts.Add(product);
                        db.SaveChanges();

                        var variantRows = ParseVariantRows(item.VariantData);
                        CreateProductVariants(db, product.Id, variantRows, item.BaseSku ?? string.Empty, item.BasePrice ?? 0, item.BaseSalePrice, item.BaseStock, true, now);

                        var imageUrls = ParseImageUrls(item.ImageUrls);
                        if (imageUrls.Count > 0)
                        {
                            var sortOrder = 0;
                            foreach (var imageUrl in imageUrls)
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
                    }

                    var batch = db.CfProductImportBatches.FirstOrDefault(b => b.Id == _batchId.Value);
                    if (batch != null)
                    {
                        batch.Status = "completed";
                        batch.UpdatedAt = now;
                    }

                    db.SaveChanges();
                    tx.Commit();
                }
                catch (Exception ex)
                {
                    tx.Rollback();
                    FormMessageLiteral.Text = "<div class=\"alert alert-danger mt-3\">Hoàn tất thất bại: " + HttpUtility.HtmlEncode(ex.Message) + "</div>";
                    return;
                }
            }
        }

        Response.Redirect("/seller/product-list.aspx");
    }

    protected void SaveSelectButton_Click(object sender, EventArgs e)
    {
        if (!EnsureBatchAndItem())
        {
            return;
        }

        SaveDraftItem();
        var nextId = ParseInt(NextItemIdInput.Value);
        if (nextId.HasValue)
        {
            Response.Redirect(BuildItemUrl(nextId.Value));
        }
    }

    private void ResolveBatchId()
    {
        if (_batchId.HasValue)
        {
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            _batchId = db.CfProductImportBatches
                .Where(b => b.SellerId == sellerId.Value && b.Status == "draft")
                .OrderByDescending(b => b.Id)
                .Select(b => (int?)b.Id)
                .FirstOrDefault();
        }
    }

    private void BindDropdowns()
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .Select(c => new { c.Id, c.CategoryName })
                .ToList();

            CategoryRepeater.DataSource = categories.Select(c => new { c.Id, Label = c.CategoryName }).ToList();
            CategoryRepeater.DataBind();

            var brands = db.CfBrands
                .Where(b => b.Status)
                .OrderBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();
            BrandDropdown.DataSource = brands;
            BrandDropdown.DataTextField = "BrandName";
            BrandDropdown.DataValueField = "Id";
            BrandDropdown.DataBind();
            BrandDropdown.Items.Insert(0, new ListItem("Chọn thương hiệu", string.Empty));

            var origins = db.CfOrigins
                .Where(o => o.Status)
                .OrderBy(o => o.OriginName)
                .Select(o => new { o.Id, o.OriginName })
                .ToList();
            OriginDropdown.DataSource = origins;
            OriginDropdown.DataTextField = "OriginName";
            OriginDropdown.DataValueField = "Id";
            OriginDropdown.DataBind();
            OriginDropdown.Items.Insert(0, new ListItem("Chọn xuất xứ", string.Empty));

            ListingStatusDropdown.Items.Clear();
            ListingStatusDropdown.Items.Add(new ListItem("Vui lòng chọn", ""));
            ListingStatusDropdown.Items.Add(new ListItem("Đang kinh doanh", "active"));
            ListingStatusDropdown.Items.Add(new ListItem("Ngừng kinh doanh", "inactive"));

            var attributes = db.CfVariantAttributes
                .Where(a => a.Status)
                .OrderBy(a => a.SortOrder)
                .ThenBy(a => a.AttributeName)
                .Select(a => new { a.Id, a.AttributeName })
                .ToList();

            var values = db.CfVariantAttributeValues
                .Where(v => v.Status)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.ValueName)
                .Select(v => new { v.Id, v.AttributeId, v.ValueName })
                .ToList();

            var variantData = new
            {
                attributes = attributes.Select(a => new { id = a.Id, name = a.AttributeName }).ToList(),
                values = values.Select(v => new { id = v.Id, attributeId = v.AttributeId, name = v.ValueName }).ToList()
            };

            var serializer = new JavaScriptSerializer();
            VariantDataLiteral.Text = "<script>window.variantData=" + serializer.Serialize(variantData) + ";window.variantRows=[];</script>";
        }
    }

    private void BindItems()
    {
        if (!_batchId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfProductImportItems
                .Where(i => i.BatchId == _batchId.Value)
                .OrderBy(i => i.RowIndex)
                .ToList();

            var completedCount = items.Count(i => i.IsCompleted);
            var totalCount = items.Count;
            ProgressLabelLiteral.Text = "Đã hoàn thành " + completedCount + "/" + totalCount + " sản phẩm";
            ProgressPercent = totalCount == 0 ? "0" : ((completedCount * 100m) / totalCount).ToString("0", CultureInfo.InvariantCulture);
            AllCountLiteral.Text = totalCount.ToString(CultureInfo.InvariantCulture);
            CompleteCountLiteral.Text = completedCount.ToString(CultureInfo.InvariantCulture);
            IncompleteCountLiteral.Text = (totalCount - completedCount).ToString(CultureInfo.InvariantCulture);

            var filtered = FilterItems(items);
            ImportItemRepeater.DataSource = filtered.Select(i => new ImportItemViewModel
            {
                ItemLink = BuildItemLink(i),
                StatusClass = BuildStatusClass(i)
            }).ToList();
            ImportItemRepeater.DataBind();

            var showFinish = items.Count > 0 && items.All(i => i.IsCompleted || i.IsDuplicatedSku);
            FinishButton.Visible = showFinish;
            SaveNextButton.Visible = !showFinish;
        }
    }

    private void LoadCurrentItem()
    {
        if (!_batchId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfProductImportItems
                .Where(i => i.BatchId == _batchId.Value)
                .OrderBy(i => i.RowIndex)
                .ToList();

            var current = items.FirstOrDefault(i => _itemId.HasValue && i.Id == _itemId.Value);
            if (current == null)
            {
                current = items.FirstOrDefault(i => !i.IsDuplicatedSku) ?? items.FirstOrDefault();
            }

            if (current == null)
            {
                return;
            }

            if (current.IsDuplicatedSku)
            {
                var next = items.FirstOrDefault(i => !i.IsDuplicatedSku);
                if (next != null)
                {
                    Response.Redirect(BuildItemUrl(next.Id));
                    return;
                }
            }

            ItemIdInput.Value = current.Id.ToString(CultureInfo.InvariantCulture);
            ProductNameInput.Text = current.ProductName ?? string.Empty;
            DescriptionInput.Text = current.Description ?? string.Empty;
            CategoryIdInput.Value = current.CategoryId.HasValue ? current.CategoryId.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            CategoryLabelLiteral.Text = ResolveCategoryLabel(db, current.CategoryId);
            if (current.BrandId.HasValue)
            {
                BrandDropdown.SelectedValue = current.BrandId.Value.ToString(CultureInfo.InvariantCulture);
            }
            if (current.OriginId.HasValue)
            {
                OriginDropdown.SelectedValue = current.OriginId.Value.ToString(CultureInfo.InvariantCulture);
            }
            SkuInput.Text = current.BaseSku ?? string.Empty;
            PriceInput.Text = current.BasePrice.HasValue ? current.BasePrice.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
            SalePriceInput.Text = current.BaseSalePrice.HasValue ? current.BaseSalePrice.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
            StockInput.Text = current.BaseStock.HasValue ? current.BaseStock.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            WeightInput.Text = current.PackageWeightGrams.HasValue ? current.PackageWeightGrams.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
            LengthInput.Text = current.PackageLengthCm.HasValue ? current.PackageLengthCm.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
            WidthInput.Text = current.PackageWidthCm.HasValue ? current.PackageWidthCm.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
            HeightInput.Text = current.PackageHeightCm.HasValue ? current.PackageHeightCm.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
            VariantRowsInput.Value = current.VariantData ?? string.Empty;

            var serializer = new JavaScriptSerializer();
            VariantDataLiteral.Text += "<script>window.variantRows=" + serializer.Serialize(ParseVariantConfig(current.VariantData)) + ";</script>";

            var images = ParseImageUrls(current.ImageUrls);
            ImageRepeater.DataSource = images.Select(u => new { ImageUrl = u }).ToList();
            ImageRepeater.DataBind();
        }
    }

    private void SaveDraftItem()
    {
        var itemId = ParseInt(ItemIdInput.Value);
        if (!itemId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var item = db.CfProductImportItems.FirstOrDefault(i => i.Id == itemId.Value);
            if (item == null)
            {
                return;
            }

            item.ProductName = (ProductNameInput.Text ?? string.Empty).Trim();
            item.Description = DescriptionInput.Text ?? string.Empty;
            item.CategoryId = ParseInt(CategoryIdInput.Value);
            item.BaseSku = (SkuInput.Text ?? string.Empty).Trim();
            item.BasePrice = ParseNullableDecimal(PriceInput.Text);
            item.BaseSalePrice = ParseNullableDecimal(SalePriceInput.Text);
            item.BaseStock = ParseInt(StockInput.Text);
            item.BrandId = ParseInt(BrandDropdown.SelectedValue);
            item.OriginId = ParseInt(OriginDropdown.SelectedValue);
            item.PackageWeightGrams = ParseNullableDecimal(WeightInput.Text);
            item.PackageLengthCm = ParseNullableDecimal(LengthInput.Text);
            item.PackageWidthCm = ParseNullableDecimal(WidthInput.Text);
            item.PackageHeightCm = ParseNullableDecimal(HeightInput.Text);
            item.VariantData = VariantRowsInput.Value;
            item.LastSavedAt = DateTime.Now;

            var uploadRoot = Server.MapPath("~/upload");
            if (!Directory.Exists(uploadRoot))
            {
                Directory.CreateDirectory(uploadRoot);
            }

            var imageUrls = ParseImageUrls(item.ImageUrls);
            imageUrls.AddRange(SaveUploads(ImageUpload, uploadRoot));
            item.ImageUrls = string.Join(";", imageUrls);

            var videoUrl = SaveUpload(VideoUpload, uploadRoot);
            if (!string.IsNullOrWhiteSpace(videoUrl))
            {
                item.VideoUrl = videoUrl;
            }

            item.IsCompleted = IsDraftCompleted(item);
            db.SaveChanges();
        }
    }

    private void RedirectToNextItem()
    {
        if (!_batchId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfProductImportItems
                .Where(i => i.BatchId == _batchId.Value)
                .OrderBy(i => i.RowIndex)
                .ToList();

            var next = items.FirstOrDefault(i => !i.IsDuplicatedSku && !i.IsCompleted);
            if (next == null)
            {
                next = items.FirstOrDefault(i => !i.IsDuplicatedSku);
            }

            if (next != null)
            {
                Response.Redirect(BuildItemUrl(next.Id));
                return;
            }
        }
    }

    private bool EnsureBatchAndItem()
    {
        _batchId = ParseInt(BatchIdInput.Value);
        _itemId = ParseInt(ItemIdInput.Value);
        return _batchId.HasValue && _itemId.HasValue;
    }

    public string GetFilterClass(string key)
    {
        return string.Equals(_filter, key, StringComparison.OrdinalIgnoreCase) ? "active" : string.Empty;
    }

    public string BuildFilterUrl(string key)
    {
        return "/seller/product-import.aspx?batchId=" + _batchId + "&filter=" + key;
    }

    private string BuildItemUrl(int itemId)
    {
        return "/seller/product-import.aspx?batchId=" + _batchId + "&itemId=" + itemId + "&filter=" + _filter;
    }

    private string BuildItemLink(CfProductImportItem item)
    {
        var name = string.IsNullOrWhiteSpace(item.ProductName) ? "Chưa đặt tên" : item.ProductName;
        var price = item.BasePrice.HasValue ? item.BasePrice.Value.ToString("N0", CultureInfo.InvariantCulture) + " đ" : "-";
        var status = item.IsDuplicatedSku ? "Đã tồn tại (SKU trùng)" : (item.IsCompleted ? "Đã hoàn thành" : "Chưa hoàn thành");
        var badge = item.IsDuplicatedSku ? "warn" : (item.IsCompleted ? "success" : "danger");

        var content = "<div class=\"import-item-main\">" +
                      "<div class=\"import-item-title\">" + HttpUtility.HtmlEncode(name) + "</div>" +
                      "<div class=\"import-item-price\">" + HttpUtility.HtmlEncode(price) + "</div>" +
                      "</div>" +
                      "<div class=\"import-item-status " + badge + "\">" + HttpUtility.HtmlEncode(status) + "</div>";

        if (item.IsDuplicatedSku)
        {
            return "<div class=\"import-item-link disabled\" data-item-id=\"" + item.Id + "\">" + content + "</div>";
        }

        var url = BuildItemUrl(item.Id);
        return "<a class=\"import-item-link\" data-item-id=\"" + item.Id + "\" href=\"" + url + "\">" + content + "</a>";
    }

    private string BuildStatusClass(CfProductImportItem item)
    {
        if (item.IsDuplicatedSku)
        {
            return "duplicated";
        }
        return item.IsCompleted ? "completed" : "incomplete";
    }

    private List<CfProductImportItem> FilterItems(List<CfProductImportItem> items)
    {
        if (_filter == "complete")
        {
            return items.Where(i => i.IsCompleted).ToList();
        }
        if (_filter == "incomplete")
        {
            return items.Where(i => !i.IsCompleted).ToList();
        }
        return items;
    }

    private string ResolveCategoryLabel(BeautyStoryContext db, int? categoryId)
    {
        if (!categoryId.HasValue)
        {
            return "Chọn ngành hàng";
        }

        return db.CfCategories
            .Where(c => c.Id == categoryId.Value)
            .Select(c => c.CategoryName)
            .FirstOrDefault() ?? "Chọn ngành hàng";
    }

    private int GetShopId(BeautyStoryContext db)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return 0;
        }

        return db.CfShops
            .Where(s => s.SellerId == sellerId.Value)
            .OrderBy(s => s.Id)
            .Select(s => s.Id)
            .FirstOrDefault();
    }

    private static bool IsDraftCompleted(CfProductImportItem item)
    {
        if (string.IsNullOrWhiteSpace(item.ProductName) || !item.CategoryId.HasValue)
        {
            return false;
        }

        var variantRows = ParseVariantRows(item.VariantData);
        if (variantRows.Count > 0)
        {
            return !variantRows.Any(r => r.Price <= 0 || !r.Stock.HasValue || r.Stock.Value < 0);
        }

        return item.BasePrice.HasValue && item.BasePrice.Value > 0
            && item.BaseStock.HasValue && item.BaseStock.Value >= 0;
    }

    private static int? ParseInt(string raw)
    {
        int value;
        return int.TryParse(raw, out value) ? (int?)value : null;
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
        return raw.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(u => (u ?? string.Empty).Trim())
            .Where(u => !string.IsNullOrWhiteSpace(u))
            .ToList();
    }

    private static List<VariantRowDto> ParseVariantRows(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return new List<VariantRowDto>();
        }

        try
        {
            var serializer = new JavaScriptSerializer();
            var rows = serializer.Deserialize<List<VariantRowDto>>(raw);
            return rows ?? new List<VariantRowDto>();
        }
        catch
        {
            return new List<VariantRowDto>();
        }
    }

    private static List<object> ParseVariantConfig(string raw)
    {
        var rows = ParseVariantRows(raw);
        var groups = rows
            .SelectMany(r => r.Mappings ?? new List<VariantMappingDto>())
            .GroupBy(m => m.AttributeId)
            .Select(g => new
            {
                attributeId = g.Key,
                values = g.Select(x => x.ValueId).Distinct().ToList()
            })
            .Cast<object>()
            .ToList();
        return groups;
    }

    private static void CreateProductVariants(
        BeautyStoryContext db,
        int productId,
        List<VariantRowDto> variantRows,
        string skuBase,
        decimal fallbackPrice,
        decimal? fallbackSalePrice,
        int? fallbackStock,
        bool publish,
        DateTime now)
    {
        var rows = variantRows ?? new List<VariantRowDto>();
        if (rows.Count == 0)
        {
            var variant = new CfProductVariant
            {
                ProductId = productId,
                VariantName = "Mặc định",
                Sku = skuBase,
                Price = fallbackPrice,
                SalePrice = fallbackSalePrice,
                StockQty = fallbackStock ?? 0,
                Status = publish,
                CreatedAt = now,
                CreatedBy = "Import",
                SortOrder = 0
            };
            db.CfProductVariants.Add(variant);
            return;
        }

        var attributeIds = rows
            .SelectMany(r => r.Mappings ?? new List<VariantMappingDto>())
            .Select(m => m.AttributeId)
            .Distinct()
            .ToList();
        var valueIds = rows
            .SelectMany(r => r.Mappings ?? new List<VariantMappingDto>())
            .Select(m => m.ValueId)
            .Distinct()
            .ToList();
        var values = db.CfVariantAttributeValues
            .Where(v => valueIds.Contains(v.Id))
            .ToDictionary(v => v.Id, v => v.ValueName);

        var sortOrder = 0;
        foreach (var row in rows)
        {
            var mappingList = row.Mappings ?? new List<VariantMappingDto>();
            var variantName = row.Name;
            if (string.IsNullOrWhiteSpace(variantName))
            {
                var valueNames = new List<string>();
                foreach (var mapping in mappingList)
                {
                    string valueName;
                    if (values.TryGetValue(mapping.ValueId, out valueName) && !string.IsNullOrWhiteSpace(valueName))
                    {
                        valueNames.Add(valueName);
                    }
                }
                variantName = valueNames.Count > 0
                    ? string.Join(" + ", valueNames)
                    : "Biến thể " + (sortOrder + 1).ToString(CultureInfo.InvariantCulture);
            }

            var variant = new CfProductVariant
            {
                ProductId = productId,
                VariantName = variantName,
                Sku = !string.IsNullOrWhiteSpace(row.Sku)
                    ? row.Sku.Trim()
                    : (string.IsNullOrWhiteSpace(skuBase) ? string.Empty : skuBase + "-" + (sortOrder + 1).ToString(CultureInfo.InvariantCulture)),
                Price = row.Price > 0 ? row.Price : fallbackPrice,
                SalePrice = row.SalePrice.HasValue && row.SalePrice.Value > 0 ? row.SalePrice : fallbackSalePrice,
                StockQty = row.Stock.HasValue ? row.Stock.Value : (fallbackStock ?? 0),
                Status = row.Active ?? publish,
                CreatedAt = now,
                CreatedBy = "Import",
                SortOrder = sortOrder
            };
            db.CfProductVariants.Add(variant);
            db.SaveChanges();

            foreach (var mapping in mappingList)
            {
                db.CfProductVariantAttributes.Add(new CfProductVariantAttribute
                {
                    VariantId = variant.Id,
                    AttributeId = mapping.AttributeId,
                    AttributeValueId = mapping.ValueId,
                    Status = true,
                    CreatedAt = now,
                    CreatedBy = "Import",
                    SortOrder = 0
                });
            }

            sortOrder++;
        }
    }

    private string SaveUpload(FileUpload upload, string uploadRoot)
    {
        if (upload == null || !upload.HasFile)
        {
            return null;
        }

        var extension = Path.GetExtension(upload.FileName);
        var fileName = string.Format("{0}_{1}{2}", DateTime.Now.ToString("yyyyMMddHHmmssfff"), Guid.NewGuid().ToString("N"), extension);
        var filePath = Path.Combine(uploadRoot, fileName);
        upload.SaveAs(filePath);
        return "/upload/" + fileName;
    }

    private List<string> SaveUploads(FileUpload upload, string uploadRoot)
    {
        var urls = new List<string>();
        if (upload == null)
        {
            return urls;
        }

        if (upload.PostedFiles != null && upload.PostedFiles.Count > 0)
        {
            foreach (var postedFile in upload.PostedFiles)
            {
                var file = postedFile as HttpPostedFile;
                if (file == null || file.ContentLength <= 0)
                {
                    continue;
                }
                var extension = Path.GetExtension(file.FileName);
                var fileName = string.Format("{0}_{1}{2}", DateTime.Now.ToString("yyyyMMddHHmmssfff"), Guid.NewGuid().ToString("N"), extension);
                var filePath = Path.Combine(uploadRoot, fileName);
                file.SaveAs(filePath);
                urls.Add("/upload/" + fileName);
            }
            return urls;
        }

        var single = SaveUpload(upload, uploadRoot);
        if (!string.IsNullOrWhiteSpace(single))
        {
            urls.Add(single);
        }
        return urls;
    }

    private class ImportItemViewModel
    {
        public string ItemLink { get; set; }
        public string StatusClass { get; set; }
    }

    private class VariantRowDto
    {
        public string Name { get; set; }
        public string Sku { get; set; }
        public bool? Active { get; set; }
        public List<VariantMappingDto> Mappings { get; set; }
        public decimal Price { get; set; }
        public decimal? SalePrice { get; set; }
        public int? Stock { get; set; }
    }

    private class VariantMappingDto
    {
        public int AttributeId { get; set; }
        public int ValueId { get; set; }
    }
}
