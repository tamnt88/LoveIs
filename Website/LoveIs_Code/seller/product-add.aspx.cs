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
        var categoryId = ParseInt(CategoryDropdown.SelectedValue);
        var shopId = ParseInt(WarehouseDropdown.SelectedValue);
        var price = ParseDecimal(PriceInput.Text);
        var stock = ParseInt(StockInput.Text);

        if (string.IsNullOrWhiteSpace(name) || !categoryId.HasValue || !shopId.HasValue || price <= 0 || !stock.HasValue || stock.Value < 0)
        {
            FormMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng nhập đầy đủ Tên sản phẩm, Ngành hàng, Gửi từ, Giá và Kho hàng.</div>";
            return;
        }

        var salePrice = ParseNullableDecimal(SalePriceInput.Text);
        var weight = ParseNullableDecimal(WeightInput.Text);
        var length = ParseNullableDecimal(LengthInput.Text);
        var width = ParseNullableDecimal(WidthInput.Text);
        var height = ParseNullableDecimal(HeightInput.Text);

        using (var db = new BeautyStoryContext())
        {
            var now = DateTime.Now;
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

                var variant = db.CfProductVariants
                    .Where(v => v.ProductId == product.Id)
                    .OrderBy(v => v.SortOrder)
                    .FirstOrDefault();
                if (variant == null)
                {
                    variant = new CfProductVariant
                    {
                        ProductId = product.Id,
                        VariantName = "Mặc định",
                        Status = publish,
                        CreatedAt = now,
                        CreatedBy = "Seller",
                        SortOrder = 0
                    };
                    db.CfProductVariants.Add(variant);
                }

                variant.Sku = (SkuInput.Text ?? string.Empty).Trim();
                variant.Price = price;
                variant.SalePrice = salePrice;
                variant.StockQty = stock.Value;
                variant.Status = publish;
                variant.UpdatedAt = now;
                variant.UpdatedBy = "Seller";
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

                var skuBase = (SkuInput.Text ?? string.Empty).Trim();
                var group1Name = NormalizeOptional(VariantGroup1NameInput.Text);
                var group1Values = ParseVariantValues(VariantGroup1ValuesInput.Text);
                var group2Name = NormalizeOptional(VariantGroup2NameInput.Text);
                var group2Values = ParseVariantValues(VariantGroup2ValuesInput.Text);

                if (group1Values.Count == 0 && group2Values.Count == 0)
                {
                    var variant = new CfProductVariant
                    {
                        ProductId = product.Id,
                        VariantName = "Mặc định",
                        Sku = skuBase,
                        Price = price,
                        SalePrice = salePrice,
                        StockQty = stock.Value,
                        Status = publish,
                        CreatedAt = now,
                        CreatedBy = "Seller",
                        SortOrder = 0
                    };
                    db.CfProductVariants.Add(variant);
                }
                else
                {
                    var attributes = new List<CfVariantAttribute>();
                    if (!string.IsNullOrWhiteSpace(group1Name))
                    {
                        attributes.Add(UpsertVariantAttribute(db, group1Name, now));
                    }
                    if (!string.IsNullOrWhiteSpace(group2Name))
                    {
                        attributes.Add(UpsertVariantAttribute(db, group2Name, now));
                    }

                    db.SaveChanges();

                    var group1Attribute = attributes.Count > 0 ? attributes[0] : null;
                    var group2Attribute = attributes.Count > 1 ? attributes[1] : null;
                    var group1ValueEntities = UpsertVariantValues(db, group1Attribute, group1Values, now);
                    var group2ValueEntities = UpsertVariantValues(db, group2Attribute, group2Values, now);

                    db.SaveChanges();

                    var combinations = BuildVariantCombinations(group1Attribute, group1ValueEntities, group2Attribute, group2ValueEntities);
                    var sortOrder = 0;
                    foreach (var combo in combinations)
                    {
                        var variantName = combo.DisplayName;
                        var sku = string.IsNullOrWhiteSpace(skuBase) ? string.Empty : skuBase + "-" + (sortOrder + 1).ToString(CultureInfo.InvariantCulture);
                        var variant = new CfProductVariant
                        {
                            ProductId = product.Id,
                            VariantName = variantName,
                            Sku = sku,
                            Price = price,
                            SalePrice = salePrice,
                            StockQty = stock.Value,
                            Status = publish,
                            CreatedAt = now,
                            CreatedBy = "Seller",
                            SortOrder = sortOrder
                        };
                        db.CfProductVariants.Add(variant);
                        db.SaveChanges();

                        foreach (var mapping in combo.Mappings)
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

        FormMessageLiteral.Text = "<div class=\"alert alert-success mt-3\">Lưu sản phẩm thành công.</div>";
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
            var categories = db.CfCategories
                .Where(c => c.Status && !c.ParentId.HasValue)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .Select(c => new
                {
                    c.Id,
                    c.CategoryName
                })
                .ToList();

            CategoryDropdown.DataSource = categories;
            CategoryDropdown.DataTextField = "CategoryName";
            CategoryDropdown.DataValueField = "Id";
            CategoryDropdown.DataBind();

            CategoryDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

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

            var warehouses = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .OrderBy(s => s.ShopName)
                .Select(s => new { s.Id, s.ShopName })
                .ToList();
            WarehouseDropdown.DataSource = warehouses;
            WarehouseDropdown.DataTextField = "ShopName";
            WarehouseDropdown.DataValueField = "Id";
            WarehouseDropdown.DataBind();
            WarehouseDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

            ProductConditionDropdown.Items.Clear();
            ProductConditionDropdown.Items.Add(new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));
            ProductConditionDropdown.Items.Add(new System.Web.UI.WebControls.ListItem("Mới", "new"));
            ProductConditionDropdown.Items.Add(new System.Web.UI.WebControls.ListItem("Đã qua sử dụng", "used"));

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
            CategoryDropdown.SelectedValue = product.CategoryId.ToString(CultureInfo.InvariantCulture);
            if (product.BrandId.HasValue)
            {
                BrandDropdown.SelectedValue = product.BrandId.Value.ToString(CultureInfo.InvariantCulture);
            }
            if (product.OriginId.HasValue)
            {
                OriginDropdown.SelectedValue = product.OriginId.Value.ToString(CultureInfo.InvariantCulture);
            }
            if (product.ShopId.HasValue)
            {
                WarehouseDropdown.SelectedValue = product.ShopId.Value.ToString(CultureInfo.InvariantCulture);
            }

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
        CategoryDropdown.Enabled = false;
        BrandDropdown.Enabled = false;
        OriginDropdown.Enabled = false;
        WarehouseDropdown.Enabled = false;
        DescriptionInput.Enabled = false;
        OriginTextInput.Enabled = false;
        SkuInput.Enabled = false;
        MaterialInput.Enabled = false;
        PriceInput.Enabled = false;
        SalePriceInput.Enabled = false;
        StockInput.Enabled = false;
        WeightInput.Enabled = false;
        LengthInput.Enabled = false;
        WidthInput.Enabled = false;
        HeightInput.Enabled = false;
        ProductConditionDropdown.Enabled = false;
        ListingStatusDropdown.Enabled = false;
        VariantGroup1NameInput.Enabled = false;
        VariantGroup1ValuesInput.Enabled = false;
        VariantGroup2NameInput.Enabled = false;
        VariantGroup2ValuesInput.Enabled = false;
        ImageUpload.Enabled = false;
        VideoUpload.Enabled = false;
        SaveDraftButton.Visible = false;
        SavePublishButton.Visible = false;
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

    private static string NormalizeOptional(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return null;
        }

        return raw.Trim();
    }

    private static List<string> ParseVariantValues(string raw)
    {
        var values = new List<string>();
        if (string.IsNullOrWhiteSpace(raw))
        {
            return values;
        }

        var parts = raw.Split(new[] { ',', ';', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);
        foreach (var part in parts)
        {
            var value = part.Trim();
            if (string.IsNullOrWhiteSpace(value))
            {
                continue;
            }
            if (!values.Contains(value))
            {
                values.Add(value);
            }
        }

        return values;
    }

    private static CfVariantAttribute UpsertVariantAttribute(BeautyStoryContext db, string name, DateTime now)
    {
        var lower = name.Trim().ToLowerInvariant();
        var existing = db.CfVariantAttributes.FirstOrDefault(a => a.AttributeName.ToLower() == lower);
        if (existing != null)
        {
            return existing;
        }

        var attribute = new CfVariantAttribute
        {
            AttributeName = name.Trim(),
            Status = true,
            CreatedAt = now,
            CreatedBy = "Seller",
            SortOrder = 0
        };
        db.CfVariantAttributes.Add(attribute);
        return attribute;
    }

    private static List<CfVariantAttributeValue> UpsertVariantValues(BeautyStoryContext db, CfVariantAttribute attribute, List<string> values, DateTime now)
    {
        var result = new List<CfVariantAttributeValue>();
        if (attribute == null || values == null || values.Count == 0)
        {
            return result;
        }

        var attrId = attribute.Id;
        foreach (var value in values)
        {
            var lower = value.ToLowerInvariant();
            var existing = db.CfVariantAttributeValues.FirstOrDefault(v => v.AttributeId == attrId && v.ValueName.ToLower() == lower);
            if (existing != null)
            {
                result.Add(existing);
                continue;
            }

            var entry = new CfVariantAttributeValue
            {
                AttributeId = attrId,
                ValueName = value,
                Status = true,
                CreatedAt = now,
                CreatedBy = "Seller",
                SortOrder = 0
            };
            db.CfVariantAttributeValues.Add(entry);
            result.Add(entry);
        }

        return result;
    }

    private static List<VariantCombination> BuildVariantCombinations(
        CfVariantAttribute group1,
        List<CfVariantAttributeValue> group1Values,
        CfVariantAttribute group2,
        List<CfVariantAttributeValue> group2Values)
    {
        var combos = new List<VariantCombination>();
        if (group1Values.Count == 0 && group2Values.Count == 0)
        {
            return combos;
        }

        if (group2Values.Count == 0)
        {
            foreach (var value in group1Values)
            {
                combos.Add(new VariantCombination
                {
                    DisplayName = value.ValueName,
                    Mappings = new List<VariantMapping>
                    {
                        new VariantMapping { AttributeId = group1.Id, ValueId = value.Id }
                    }
                });
            }
            return combos;
        }

        if (group1Values.Count == 0)
        {
            foreach (var value in group2Values)
            {
                combos.Add(new VariantCombination
                {
                    DisplayName = value.ValueName,
                    Mappings = new List<VariantMapping>
                    {
                        new VariantMapping { AttributeId = group2.Id, ValueId = value.Id }
                    }
                });
            }
            return combos;
        }

        foreach (var value1 in group1Values)
        {
            foreach (var value2 in group2Values)
            {
                combos.Add(new VariantCombination
                {
                    DisplayName = value1.ValueName + " - " + value2.ValueName,
                    Mappings = new List<VariantMapping>
                    {
                        new VariantMapping { AttributeId = group1.Id, ValueId = value1.Id },
                        new VariantMapping { AttributeId = group2.Id, ValueId = value2.Id }
                    }
                });
            }
        }

        return combos;
    }

    private class VariantCombination
    {
        public string DisplayName { get; set; }
        public List<VariantMapping> Mappings { get; set; }
    }

    private class VariantMapping
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
