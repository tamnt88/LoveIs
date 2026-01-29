using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

public partial class SellerProductAdd : System.Web.UI.Page
{
    private int? _productId;
    private string _mode = "create";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        _productId = ParseInt(Request.QueryString["id"]);
        _mode = (Request.QueryString["mode"] ?? "create").Trim().ToLowerInvariant();

        if (!IsPostBack)
        {
            BindDropdowns();
            if (_productId.HasValue)
            {
                LoadProduct(_productId.Value);
            }
            if (!_productId.HasValue && IsImportFlow())
            {
                ApplyImportDraft();
            }
            if (string.Equals(Request.QueryString["saved"], "1", StringComparison.Ordinal))
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-success mt-3\">Lưu sản phẩm thành công.</div>";
            }
            ApplyMode();
        }
    }

    protected void SaveDraftButton_Click(object sender, EventArgs e)
    {
        SaveProduct(false);
    }

    protected void SavePublishButton_Click(object sender, EventArgs e)
    {
        SaveProduct(true);
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/seller/product-list.aspx");
    }

    private void SaveProduct(bool publish)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        var name = (ProductNameInput.Text ?? string.Empty).Trim();
        var categoryId = ParseInt(CategoryIdInput.Value);
        var skuBase = (SkuInput.Text ?? string.Empty).Trim();
        var price = ParseDecimal(PriceInput.Text);
        var stock = ParseInt(StockInput.Text);
        var variantRows = ParseVariantRows(VariantRowsInput.Value);
        var validVariantRows = variantRows
            .Where(r => r.Mappings != null && r.Mappings.Count > 0)
            .ToList();

        if (string.IsNullOrWhiteSpace(name) || !categoryId.HasValue)
        {
            FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng nhập đầy đủ Tên sản phẩm và Ngành hàng.</div>";
            return;
        }

        if (validVariantRows.Count == 0)
        {
            if (price <= 0 || !stock.HasValue || stock.Value < 0)
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng nhập đầy đủ Giá và Kho hàng.</div>";
                return;
            }
        }
        else
        {
            var hasInvalidRow = validVariantRows.Any(r => r.Price <= 0 || !r.Stock.HasValue || r.Stock.Value < 0);
            if (hasInvalidRow)
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng nhập đủ Giá và Kho hàng cho từng biến thể.</div>";
                return;
            }
        }

        var salePrice = ParseNullableDecimal(SalePriceInput.Text);
        var weight = ParseNullableDecimal(WeightInput.Text);
        var length = ParseNullableDecimal(LengthInput.Text);
        var width = ParseNullableDecimal(WidthInput.Text);
        var height = ParseNullableDecimal(HeightInput.Text);

        var redirectId = _productId;
        using (var db = new BeautyStoryContext())
        {
            var now = DateTime.Now;
            var sellerId = SellerAuth.GetSellerId();
            if (!sellerId.HasValue)
            {
                Response.Redirect("/seller/login.aspx");
                return;
            }

            var shopId = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .OrderBy(s => s.Id)
                .Select(s => (int?)s.Id)
                .FirstOrDefault();
            if (!shopId.HasValue)
            {
                FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Chưa có shop để tạo sản phẩm.</div>";
                return;
            }

            var uploadRoot = Server.MapPath("~/upload");
            if (!Directory.Exists(uploadRoot))
            {
                Directory.CreateDirectory(uploadRoot);
            }

            var imageUrls = SaveUploads(ImageUpload, uploadRoot);
            var videoUrl = SaveUpload(VideoUpload, uploadRoot);

            CfProduct product;
            if (_productId.HasValue)
            {
                product = db.CfProducts.FirstOrDefault(p => p.Id == _productId.Value);
                if (product == null)
                {
                    FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Không tìm thấy sản phẩm.</div>";
                    return;
                }

                product.ProductName = name;
                product.CategoryId = categoryId.Value;
                product.BrandId = ParseInt(BrandDropdown.SelectedValue);
                product.OriginId = ParseInt(OriginDropdown.SelectedValue);
                product.ShopId = shopId.Value;
                product.Description = DescriptionInput.Text;
                if (!string.IsNullOrWhiteSpace(videoUrl))
                {
                    product.VideoUrl = videoUrl;
                }
                product.Status = publish;
                product.PackageWeightGrams = weight;
                product.PackageLengthCm = length;
                product.PackageWidthCm = width;
                product.PackageHeightCm = height;
                product.UpdatedAt = now;
                product.UpdatedBy = "Seller";

                var existingVariants = db.CfProductVariants
                    .Where(v => v.ProductId == product.Id)
                    .ToList();
                var existingVariantIds = existingVariants.Select(v => v.Id).ToList();
                if (existingVariantIds.Count > 0)
                {
                    var mappings = db.CfProductVariantAttributes
                        .Where(m => existingVariantIds.Contains(m.VariantId))
                        .ToList();
                    if (mappings.Count > 0)
                    {
                        db.CfProductVariantAttributes.RemoveRange(mappings);
                    }
                    db.CfProductVariants.RemoveRange(existingVariants);
                }

                CreateProductVariants(db, product.Id, validVariantRows, skuBase, price, salePrice, stock, publish, now);
                redirectId = product.Id;
            }
            else
            {
                product = new CfProduct
                {
                    ProductName = name,
                    CategoryId = categoryId.Value,
                    BrandId = ParseInt(BrandDropdown.SelectedValue),
                    OriginId = ParseInt(OriginDropdown.SelectedValue),
                    ShopId = shopId.Value,
                    Description = DescriptionInput.Text,
                    VideoUrl = videoUrl,
                    Status = publish,
                    CreatedAt = now,
                    CreatedBy = "Seller",
                    SortOrder = 0,
                    PackageWeightGrams = weight,
                    PackageLengthCm = length,
                    PackageWidthCm = width,
                    PackageHeightCm = height,
                    RatingAvg = 0,
                    RatingCount = 0
                };

                db.CfProducts.Add(product);
                db.SaveChanges();

                CreateProductVariants(db, product.Id, validVariantRows, skuBase, price, salePrice, stock, publish, now);
                redirectId = product.Id;
            }

            if (imageUrls.Count > 0)
            {
                var hasPrimary = db.CfProductImages.Any(i => i.ProductId == product.Id && i.IsPrimary && i.Status);
                var sortOrder = 0;
                foreach (var imageUrl in imageUrls)
                {
                    db.CfProductImages.Add(new CfProductImage
                    {
                        ProductId = product.Id,
                        ImageUrl = imageUrl,
                        IsPrimary = !hasPrimary && sortOrder == 0,
                        Status = true,
                        CreatedAt = now,
                        CreatedBy = "Seller",
                        SortOrder = sortOrder
                    });
                    sortOrder++;
                }
            }

            db.SaveChanges();
        }

        if (HandleImportRedirect())
        {
            return;
        }

        Response.Redirect("/seller/product-add.aspx?id=" + (redirectId ?? 0) + "&mode=edit&saved=1");
    }

    private bool IsImportFlow()
    {
        return string.Equals(Request.QueryString["import"], "1", StringComparison.Ordinal);
    }

    private void ApplyImportDraft()
    {
        var drafts = Session["ProductImportDrafts"] as List<ProductImportDraft>;
        if (drafts == null || drafts.Count == 0)
        {
            return;
        }

        var index = Session["ProductImportDraftIndex"] as int? ?? 0;
        if (index < 0 || index >= drafts.Count)
        {
            return;
        }

        var draft = drafts[index];
        ProductNameInput.Text = draft.ProductName ?? string.Empty;
        DescriptionInput.Text = draft.Description ?? string.Empty;
        SkuInput.Text = draft.Sku ?? string.Empty;
        PriceInput.Text = draft.Price.HasValue ? draft.Price.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
        SalePriceInput.Text = draft.SalePrice.HasValue ? draft.SalePrice.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
        StockInput.Text = draft.StockQty.HasValue ? draft.StockQty.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
        WeightInput.Text = draft.WeightGrams.HasValue ? draft.WeightGrams.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
        LengthInput.Text = draft.LengthCm.HasValue ? draft.LengthCm.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
        WidthInput.Text = draft.WidthCm.HasValue ? draft.WidthCm.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;
        HeightInput.Text = draft.HeightCm.HasValue ? draft.HeightCm.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;

        var remaining = drafts.Count - index;
        FormMessageLiteral.Text = "<div class=\"alert alert-info mt-3\">Đang nhập từ file. Còn lại " + remaining.ToString(CultureInfo.InvariantCulture) + " sản phẩm.</div>";
    }

    private bool HandleImportRedirect()
    {
        if (!IsImportFlow())
        {
            return false;
        }

        var drafts = Session["ProductImportDrafts"] as List<ProductImportDraft>;
        if (drafts == null || drafts.Count == 0)
        {
            Session.Remove("ProductImportDrafts");
            Session.Remove("ProductImportDraftIndex");
            return false;
        }

        var index = Session["ProductImportDraftIndex"] as int? ?? 0;
        index++;
        if (index < drafts.Count)
        {
            Session["ProductImportDraftIndex"] = index;
            Response.Redirect("/seller/product-add.aspx?import=1");
            return true;
        }

        Session.Remove("ProductImportDrafts");
        Session.Remove("ProductImportDraftIndex");
        return false;
    }

    private void BindDropdowns()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
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

            var variantRows = new List<object>();
            if (_productId.HasValue)
            {
                var variants = db.CfProductVariants
                    .Where(v => v.ProductId == _productId.Value)
                    .OrderBy(v => v.SortOrder)
                    .ThenBy(v => v.Id)
                    .ToList();

                var variantIds = variants.Select(v => v.Id).ToList();
                var mappings = db.CfProductVariantAttributes
                    .Where(m => variantIds.Contains(m.VariantId))
                    .OrderBy(m => m.Id)
                    .ToList()
                    .GroupBy(m => m.VariantId)
                    .ToDictionary(g => g.Key, g => g.ToList());

                foreach (var variant in variants)
                {
                    variantRows.Add(new
                    {
                        name = variant.VariantName,
                        sku = variant.Sku,
                        active = variant.Status,
                        mappings = mappings.ContainsKey(variant.Id)
                            ? mappings[variant.Id].Select(m => new VariantMappingDto { AttributeId = m.AttributeId, ValueId = m.AttributeValueId }).ToList()
                            : new List<VariantMappingDto>(),
                        price = variant.Price,
                        salePrice = variant.SalePrice,
                        stock = variant.StockQty
                    });
                }
            }

            var variantPayload = new
            {
                data = variantData,
                rows = variantRows
            };

            VariantDataLiteral.Text = "<script>window.variantData = " + new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(variantPayload.data) +
                "; window.variantRows = " + new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(variantPayload.rows) + ";</script>";

            var allCategories = db.CfCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            CategoryMenuLiteral.Text = RenderCategoryMenu(allCategories);

            var brands = db.CfBrands
                .Where(b => b.Status)
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();
            BrandDropdown.DataSource = brands;
            BrandDropdown.DataTextField = "BrandName";
            BrandDropdown.DataValueField = "Id";
            BrandDropdown.DataBind();
            BrandDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

            var origins = db.CfOrigins
                .Where(o => o.Status)
                .OrderBy(o => o.SortOrder)
                .ThenBy(o => o.OriginName)
                .Select(o => new { o.Id, o.OriginName })
                .ToList();
            OriginDropdown.DataSource = origins;
            OriginDropdown.DataTextField = "OriginName";
            OriginDropdown.DataValueField = "Id";
            OriginDropdown.DataBind();
            OriginDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

            ListingStatusDropdown.Items.Clear();
            ListingStatusDropdown.Items.Add(new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));
            ListingStatusDropdown.Items.Add(new System.Web.UI.WebControls.ListItem("Đang kinh doanh", "active"));
            ListingStatusDropdown.Items.Add(new System.Web.UI.WebControls.ListItem("Ngừng kinh doanh", "inactive"));
        }
    }

    private void LoadProduct(int productId)
    {
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
                FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Không tìm thấy sản phẩm.</div>";
                return;
            }

            ProductNameInput.Text = product.ProductName ?? string.Empty;
            DescriptionInput.Text = product.Description ?? string.Empty;
            if (product.BrandId.HasValue)
            {
                BrandDropdown.SelectedValue = product.BrandId.Value.ToString(CultureInfo.InvariantCulture);
            }
            if (product.OriginId.HasValue)
            {
                OriginDropdown.SelectedValue = product.OriginId.Value.ToString(CultureInfo.InvariantCulture);
            }

            CategoryIdInput.Value = product.CategoryId.ToString(CultureInfo.InvariantCulture);
            CategorySelectedLiteral.Text = ResolveCategoryPath(product.CategoryId);

            WeightInput.Text = product.PackageWeightGrams.HasValue ? product.PackageWeightGrams.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            LengthInput.Text = product.PackageLengthCm.HasValue ? product.PackageLengthCm.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            WidthInput.Text = product.PackageWidthCm.HasValue ? product.PackageWidthCm.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            HeightInput.Text = product.PackageHeightCm.HasValue ? product.PackageHeightCm.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;

            var variant = db.CfProductVariants
                .Where(v => v.ProductId == product.Id)
                .OrderBy(v => v.SortOrder)
                .FirstOrDefault();
            if (variant != null)
            {
                SkuInput.Text = variant.Sku ?? string.Empty;
                PriceInput.Text = variant.Price.ToString(CultureInfo.InvariantCulture);
                SalePriceInput.Text = variant.SalePrice.HasValue ? variant.SalePrice.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
                StockInput.Text = variant.StockQty.ToString(CultureInfo.InvariantCulture);
            }

            var images = db.CfProductImages
                .Where(i => i.ProductId == product.Id && i.Status)
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .Select(i => i.ImageUrl)
                .ToList();
            if (images.Count > 0)
            {
                ImagePreviewLiteral.Text = string.Join("", images.Select(u => "<img src=\"" + HttpUtility.HtmlEncode(u) + "\" alt=\"Hình sản phẩm\" />"));
            }

            FormTitleLiteral.Text = string.Equals(_mode, "view", StringComparison.OrdinalIgnoreCase) ? "Chi tiết sản phẩm" : "Chỉnh sửa sản phẩm";
        }
    }

    private void ApplyMode()
    {
        if (!string.Equals(_mode, "view", StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        ProductNameInput.Enabled = false;
        CategorySelectBtn.Disabled = true;
        BrandDropdown.Enabled = false;
        OriginDropdown.Enabled = false;
        DescriptionInput.Enabled = false;
        SkuInput.Enabled = false;
        PriceInput.Enabled = false;
        SalePriceInput.Enabled = false;
        StockInput.Enabled = false;
        WeightInput.Enabled = false;
        LengthInput.Enabled = false;
        WidthInput.Enabled = false;
        HeightInput.Enabled = false;
        ListingStatusDropdown.Enabled = false;
        ImageUpload.Enabled = false;
        VideoUpload.Enabled = false;
        AddVariantGroupBtn.Disabled = true;
        BuildVariantsBtn.Disabled = true;
        ViewModeInput.Value = "view";
        SaveDraftButton.Visible = false;
        SavePublishButton.Visible = false;
    }
    private static string RenderCategoryMenu(List<CfCategory> categories)
    {
        var lookup = categories
            .Where(c => c.Status)
            .GroupBy(c => c.ParentId ?? 0)
            .ToDictionary(g => g.Key, g => g.OrderBy(x => x.SortOrder).ThenBy(x => x.CategoryName).ToList());

        var roots = lookup.ContainsKey(0) ? lookup[0] : new List<CfCategory>();
        var sb = new System.Text.StringBuilder();
        sb.Append("<ul class=\"category-menu\">");
        foreach (var root in roots)
        {
            RenderCategoryNode(sb, lookup, root, root.CategoryName, 1);
        }
        sb.Append("</ul>");
        return sb.ToString();
    }

    private static void RenderCategoryNode(System.Text.StringBuilder sb, Dictionary<int, List<CfCategory>> lookup, CfCategory node, string path, int depth)
    {
        var hasChildren = lookup.ContainsKey(node.Id) && lookup[node.Id].Count > 0;
        sb.Append("<li>");
        sb.Append("<div class=\"category-item");
        if (hasChildren)
        {
            sb.Append(" has-children");
        }
        sb.Append("\" data-category-id=\"");
        sb.Append(node.Id.ToString(CultureInfo.InvariantCulture));
        sb.Append("\" data-category-label=\"");
        sb.Append(HttpUtility.HtmlEncode(path));
        sb.Append("\">");
        sb.Append(HttpUtility.HtmlEncode(node.CategoryName));
        sb.Append("</div>");

        if (hasChildren && depth < 3)
        {
            sb.Append("<ul class=\"category-submenu\">");
            foreach (var child in lookup[node.Id])
            {
                RenderCategoryNode(sb, lookup, child, path + " > " + child.CategoryName, depth + 1);
            }
            sb.Append("</ul>");
        }

        sb.Append("</li>");
    }

    private string ResolveCategoryPath(int categoryId)
    {
        using (var db = new BeautyStoryContext())
        {
            var category = db.CfCategories.FirstOrDefault(c => c.Id == categoryId);
            if (category == null)
            {
                return "Vui lòng chọn";
            }

            var names = new List<string>();
            var current = category;
            while (current != null)
            {
                if (!string.IsNullOrWhiteSpace(current.CategoryName))
                {
                    names.Add(current.CategoryName);
                }
                if (!current.ParentId.HasValue)
                {
                    break;
                }
                current = db.CfCategories.FirstOrDefault(c => c.Id == current.ParentId.Value);
            }

            names.Reverse();
            return names.Count > 0 ? string.Join(" > ", names) : category.CategoryName;
        }
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

    private static List<VariantRowDto> ParseVariantRows(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return new List<VariantRowDto>();
        }

        try
        {
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            var rows = serializer.Deserialize<List<VariantRowDto>>(raw);
            return rows ?? new List<VariantRowDto>();
        }
        catch
        {
            return new List<VariantRowDto>();
        }
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
                CreatedBy = "Seller",
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
        var attributes = db.CfVariantAttributes
            .Where(a => attributeIds.Contains(a.Id))
            .ToDictionary(a => a.Id, a => a.AttributeName);
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
                CreatedBy = "Seller",
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
                    CreatedBy = "Seller",
                    SortOrder = 0
                });
            }

            sortOrder++;
        }
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
                var file = postedFile as System.Web.HttpPostedFile;
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
}
