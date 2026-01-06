using System;
using System.Globalization;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

public partial class AdminProductsEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLookups();

            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && id > 0)
            {
                LoadProductToForm(id);
                LoadMatrixSelectionsFromProduct(id);
            }
            else
            {
                BindImages();
            }
            BindVariants();
            BindVariantAttributeLookups();
            BindVariantAttributes();
            BindMatrixAttributes();
            BindMatrixAttributeValues();
            BindMatrixValues(ParseSelectedAttributeIds());
            BindFilterGroups();
        }
    }

    private void BindLookups()
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfCategories
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .ToList();

            CategoryInput.Items.Clear();
            CategoryInput.Items.Add(new ListItem("-- Chọn danh mục --", ""));
            AddCategoryOptions(CategoryInput, categories, null, 0);

            var brands = db.CfBrands
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();

            BrandInput.Items.Clear();
            BrandInput.Items.Add(new ListItem("Không chọn", ""));
            foreach (var item in brands)
            {
                BrandInput.Items.Add(new ListItem(item.BrandName, item.Id.ToString()));
            }

            var origins = db.CfOrigins
                .OrderBy(o => o.SortOrder)
                .ThenBy(o => o.OriginName)
                .Select(o => new { o.Id, o.OriginName })
                .ToList();

            OriginInput.Items.Clear();
            OriginInput.Items.Add(new ListItem("Không chọn", ""));
            foreach (var item in origins)
            {
                OriginInput.Items.Add(new ListItem(item.OriginName, item.Id.ToString()));
            }
        }
    }
    private static void AddCategoryOptions(ListControl target, List<CfCategory> categories, int? parentId, int level)
    {
        var items = categories
            .Where(c => c.ParentId == parentId)
            .OrderBy(c => c.SortOrder)
            .ThenBy(c => c.CategoryName)
            .ToList();

        string prefix = string.Empty;
        for (int i = 0; i < level; i++)
        {
            prefix += "|-- ";
        }

        foreach (var item in items)
        {
            string label = string.Concat(prefix, item.CategoryName);
            target.Items.Add(new ListItem(label, item.Id.ToString()));
            AddCategoryOptions(target, categories, item.Id, level + 1);
        }
    }
    private void BindFilterGroups()
    {
        FilterMessage.Text = string.Empty;

        int categoryId;
        if (!int.TryParse(CategoryInput.SelectedValue, out categoryId) || categoryId <= 0)
        {
            FilterGroupRepeater.DataSource = null;
            FilterGroupRepeater.DataBind();
            FilterMessage.Text = "Vui lòng chọn danh mục để hiển thị bộ lọc.";
            return;
        }

        int productId;
        int.TryParse(ProductId.Value, out productId);

        using (var db = new BeautyStoryContext())
        {
            var groupIds = db.CfCategoryFilterGroups
                .Where(c => c.CategoryId == categoryId && c.Status)
                .Select(c => c.GroupId)
                .ToList();

            if (groupIds.Count == 0)
            {
                groupIds = db.CfFilterGroups.Where(g => g.Status).Select(g => g.Id).ToList();
            }

            bool hasMapping = groupIds.Count > 0;
            if (!hasMapping)
            {
                groupIds = db.CfFilterGroups.Where(g => g.Status).Select(g => g.Id).ToList();
            }

            var selectedOptionIds = new HashSet<int>();
            if (productId > 0)
            {
                selectedOptionIds = new HashSet<int>(db.CfProductFilters
                    .Where(f => f.ProductId == productId)
                    .Select(f => f.OptionId)
                    .ToList());
            }

            var groups = db.CfFilterGroups
                .Where(g => groupIds.Contains(g.Id) && g.Status)
                .OrderBy(g => g.SortOrder)
                .ThenBy(g => g.GroupName)
                .Select(g => new { g.Id, g.GroupName })
                .ToList();

            var options = db.CfFilterOptions
                .Where(o => groupIds.Contains(o.GroupId) && o.Status)
                .OrderBy(o => o.SortOrder)
                .ThenBy(o => o.OptionName)
                .Select(o => new { o.Id, o.GroupId, o.OptionName })
                .ToList();

            var data = groups.Select(g => new FilterGroupView
            {
                GroupId = g.Id,
                GroupName = g.GroupName,
                Options = options
                    .Where(o => o.GroupId == g.Id)
                    .Select(o => new FilterOptionView
                    {
                        GroupId = g.Id,
                        OptionId = o.Id,
                        OptionName = o.OptionName,
                        IsSelected = selectedOptionIds.Contains(o.Id)
                    })
                    .ToList()
            }).ToList();

            FilterGroupRepeater.DataSource = data;
            FilterGroupRepeater.DataBind();

            if (!hasMapping)
            {
                FilterMessage.Text = "Danh mục chưa được gán bộ lọc. Đang hiển thị tất cả bộ lọc.";
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (ProductNameInput.Text ?? string.Empty).Trim();
        string shortDesc = (ShortDescriptionInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string specification = (SpecificationInput.Text ?? string.Empty).Trim();
        string ingredients = (IngredientsInput.Text ?? string.Empty).Trim();
        string usage = (UsageInput.Text ?? string.Empty).Trim();
        string seoTitle = (SeoTitleInput.Text ?? string.Empty).Trim();
        string seoSlug = (SeoSlugInput.Text ?? string.Empty).Trim();
        string seoDescription = (SeoDescriptionInput.Text ?? string.Empty).Trim();
        string seoKeywords = (SeoKeywordsInput.Text ?? string.Empty).Trim();
        string ogTitle = (OgTitleInput.Text ?? string.Empty).Trim();
        string ogDescription = (OgDescriptionInput.Text ?? string.Empty).Trim();
        string ogImage = SaveUploadedFile(OgImageUpload, "products/og", OgImageValue.Value);
        string ogType = (OgTypeInput.Text ?? string.Empty).Trim();
        string twitterTitle = (TwitterTitleInput.Text ?? string.Empty).Trim();
        string twitterDescription = (TwitterDescriptionInput.Text ?? string.Empty).Trim();
        string twitterImage = SaveUploadedFile(TwitterImageUpload, "products/twitter", TwitterImageValue.Value);
        string canonicalUrl = (CanonicalUrlInput.Text ?? string.Empty).Trim();
        string robots = (RobotsInput.Text ?? string.Empty).Trim();
        decimal? packageWeight = ParseNullableDecimal(PackageWeightInput.Text);
        decimal? packageLength = ParseNullableDecimal(PackageLengthInput.Text);
        decimal? packageWidth = ParseNullableDecimal(PackageWidthInput.Text);
        decimal? packageHeight = ParseNullableDecimal(PackageHeightInput.Text);
        string sortText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool isNewArrival = NewArrivalInput.Checked;
        bool isTrending = TrendingInput.Checked;
        bool isBestSelling = BestSellingInput.Checked;
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên sản phẩm.";
            return;
        }

        if (string.IsNullOrWhiteSpace(seoSlug))
        {
            FormMessage.Text = "Vui lòng nhập slug cho sản phẩm.";
            return;
        }

        int categoryId;
        if (!int.TryParse(CategoryInput.SelectedValue, out categoryId) || categoryId <= 0)
        {
            FormMessage.Text = "Vui lòng chọn danh mục.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        int? brandId = null;
        int brandParsed;
        if (int.TryParse(BrandInput.SelectedValue, out brandParsed) && brandParsed > 0)
        {
            brandId = brandParsed;
        }

        int? originId = null;
        int originParsed;
        if (int.TryParse(OriginInput.SelectedValue, out originParsed) && originParsed > 0)
        {
            originId = originParsed;
        }

        using (var db = new BeautyStoryContext())
        {
            CfProduct product;
            int id;
            if (int.TryParse(ProductId.Value, out id) && id > 0)
            {
                product = db.CfProducts.FirstOrDefault(p => p.Id == id);
                if (product == null)
                {
                    FormMessage.Text = "Sản phẩm không tồn tại.";
                    return;
                }
            }
            else
            {
                product = new CfProduct();
                product.CreatedAt = DateTime.UtcNow;
                product.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfProducts.Add(product);
            }

            product.ProductName = name;
            product.CategoryId = categoryId;
            product.BrandId = brandId;
            product.OriginId = originId;
            product.ShortDescription = string.IsNullOrWhiteSpace(shortDesc) ? null : shortDesc;
            product.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            product.Specification = string.IsNullOrWhiteSpace(specification) ? null : specification;
            product.Ingredients = string.IsNullOrWhiteSpace(ingredients) ? null : ingredients;
            product.Usage = string.IsNullOrWhiteSpace(usage) ? null : usage;
            product.SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle;
            product.SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription;
            product.SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords;
            product.OgTitle = string.IsNullOrWhiteSpace(ogTitle) ? null : ogTitle;
            product.OgDescription = string.IsNullOrWhiteSpace(ogDescription) ? null : ogDescription;
            product.OgImage = string.IsNullOrWhiteSpace(ogImage) ? null : ogImage;
            product.OgType = string.IsNullOrWhiteSpace(ogType) ? null : ogType;
            product.TwitterTitle = string.IsNullOrWhiteSpace(twitterTitle) ? null : twitterTitle;
            product.TwitterDescription = string.IsNullOrWhiteSpace(twitterDescription) ? null : twitterDescription;
            product.TwitterImage = string.IsNullOrWhiteSpace(twitterImage) ? null : twitterImage;
            product.CanonicalUrl = string.IsNullOrWhiteSpace(canonicalUrl) ? null : canonicalUrl;
            product.Robots = string.IsNullOrWhiteSpace(robots) ? null : robots;
            product.PackageWeightGrams = packageWeight;
            product.PackageLengthCm = packageLength;
            product.PackageWidthCm = packageWidth;
            product.PackageHeightCm = packageHeight;
            product.SortOrder = sortOrder;
            product.IsNewArrival = isNewArrival;
            product.IsTrending = isTrending;
            product.IsBestSelling = isBestSelling;
            product.Status = status;
            product.UpdatedAt = DateTime.UtcNow;
            product.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            string normalizedSlug = seoSlug.ToLowerInvariant();
            bool slugExists = db.CfSeoSlugs.Any(s => s.SeoSlug == normalizedSlug && (s.EntityType != "Product" || s.EntityId != product.Id));
            if (slugExists)
            {
                FormMessage.Text = "Slug đã tồn tại. Vui lòng chọn slug khác.";
                return;
            }

            db.SaveChanges();

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Product" && s.EntityId == product.Id);
            if (slug == null)
            {
                slug = new CfSeoSlug
                {
                    EntityType = "Product",
                    EntityId = product.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfSeoSlugs.Add(slug);
            }

            slug.SeoSlug = normalizedSlug;
            slug.Status = product.Status;
            slug.SortOrder = product.SortOrder;
            slug.UpdatedAt = DateTime.UtcNow;
            slug.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();

            ProductId.Value = product.Id.ToString();
            SetPreview(OgImagePreview, product.OgImage);
            SetPreview(TwitterImagePreview, product.TwitterImage);
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
        BindImages();
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
        BindImages();
        BindVariants();
        BindVariantAttributes();
    }
    protected void MatrixGenerateButton_Click(object sender, EventArgs e)
    {
        MatrixMessage.Text = string.Empty;
        BindMatrixRows();
    }

    protected void MatrixAttributeSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        MatrixMessage.Text = string.Empty;
        BindMatrixAttributeValues();
    }

    protected void CategoryInput_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindFilterGroups();
    }

    protected void FilterSaveButton_Click(object sender, EventArgs e)
    {
        FilterMessage.Text = string.Empty;

        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            FilterMessage.Text = "Vui lòng lưu sản phẩm trước khi chọn bộ lọc.";
            return;
        }

        int categoryId;
        if (!int.TryParse(CategoryInput.SelectedValue, out categoryId) || categoryId <= 0)
        {
            FilterMessage.Text = "Vui lòng chọn danh mục.";
            return;
        }

        var selectedValues = Request.Form.GetValues("filterOption") ?? new string[0];
        var selectedIds = new List<int>();
        foreach (var raw in selectedValues)
        {
            int id;
            if (int.TryParse(raw, out id) && id > 0)
            {
                selectedIds.Add(id);
            }
        }

        using (var db = new BeautyStoryContext())
        {
            var groupIds = db.CfCategoryFilterGroups
                .Where(c => c.CategoryId == categoryId && c.Status)
                .Select(c => c.GroupId)
                .ToList();
            if (groupIds.Count == 0)
            {
                groupIds = db.CfFilterGroups.Where(g => g.Status).Select(g => g.Id).ToList();
            }

            var removeItems = db.CfProductFilters
                .Where(p => p.ProductId == productId && groupIds.Contains(p.GroupId))
                .ToList();

            if (removeItems.Count > 0)
            {
                db.CfProductFilters.RemoveRange(removeItems);
            }

            if (selectedIds.Count > 0)
            {
                var optionItems = db.CfFilterOptions
                    .Where(o => selectedIds.Contains(o.Id) && groupIds.Contains(o.GroupId) && o.Status)
                    .Select(o => new { o.Id, o.GroupId })
                    .ToList();

                foreach (var option in optionItems)
                {
                    var item = new CfProductFilter
                    {
                        ProductId = productId,
                        GroupId = option.GroupId,
                        OptionId = option.Id,
                        Status = true,
                        SortOrder = 0,
                        CreatedAt = DateTime.UtcNow,
                        CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                    };
                    db.CfProductFilters.Add(item);
                }
            }

            db.SaveChanges();
        }

        FilterMessage.CssClass = "text-success small d-block mb-2";
        FilterMessage.Text = "Đã lưu bộ lọc thành công.";
        BindFilterGroups();
    }

    protected void MatrixAddAttributeButton_Click(object sender, EventArgs e)
    {
        MatrixMessage.Text = string.Empty;

        int attrId;
        if (!int.TryParse(MatrixAttributeSelect.SelectedValue, out attrId) || attrId <= 0)
        {
            MatrixMessage.Text = "Vui lòng chọn thuộc tính.";
            return;
        }

        var selectedValueIds = MatrixAttributeValueSelect.Items.Cast<ListItem>()
            .Where(item => item.Selected)
            .Select(item => int.Parse(item.Value))
            .ToList();

        if (selectedValueIds.Count == 0)
        {
            MatrixMessage.Text = "Vui lòng chọn giá trị thuộc tính.";
            return;
        }

        var selectedAttrIds = ParseSelectedAttributeIds();
        if (selectedAttrIds.Contains(attrId))
        {
            MatrixMessage.Text = "Thuộc tính đã được chọn.";
            return;
        }

        if (selectedAttrIds.Count >= 5)
        {
            MatrixMessage.Text = "Tối đa 5 thuộc tính cho một matrix.";
            return;
        }

        selectedAttrIds.Add(attrId);
        MatrixSelectedAttributeIds.Value = string.Join(",", selectedAttrIds);

        var map = GetMatrixSelectedValues();
        map[attrId] = selectedValueIds;
        SaveMatrixSelectedValues(map);

        BindMatrixValues(selectedAttrIds);
        MatrixRepeater.DataSource = null;
        MatrixRepeater.DataBind();
    }

    protected void MatrixValueRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "remove")
        {
            return;
        }

        int attrId;
        if (!int.TryParse(e.CommandArgument.ToString(), out attrId))
        {
            return;
        }

        var selectedAttrIds = ParseSelectedAttributeIds();
        if (selectedAttrIds.Remove(attrId))
        {
            MatrixSelectedAttributeIds.Value = string.Join(",", selectedAttrIds);
            var map = GetMatrixSelectedValues();
            if (map.ContainsKey(attrId))
            {
                map.Remove(attrId);
                SaveMatrixSelectedValues(map);
            }
            BindMatrixValues(selectedAttrIds);
            MatrixRepeater.DataSource = null;
            MatrixRepeater.DataBind();
        }
    }

    protected void MatrixValueRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        var data = (MatrixAttributeOption)e.Item.DataItem;
        var list = (ListBox)e.Item.FindControl("MatrixValueList");
        if (list == null)
        {
            return;
        }

        list.Items.Clear();
        foreach (var option in data.Values)
        {
            list.Items.Add(new ListItem(option.ValueName, option.Id.ToString()));
        }

        var map = GetMatrixSelectedValues();
        if (map.ContainsKey(data.AttributeId))
        {
            var selectedValues = map[data.AttributeId];
            foreach (ListItem item in list.Items)
            {
                item.Selected = selectedValues.Contains(int.Parse(item.Value));
            }
            return;
        }

        if (!Page.IsPostBack)
        {
            return;
        }

        var postedValues = Request.Form.GetValues(list.UniqueID);
        if (postedValues == null)
        {
            return;
        }

        foreach (ListItem item in list.Items)
        {
            item.Selected = postedValues.Contains(item.Value);
        }
    }

    protected void MatrixSaveButton_Click(object sender, EventArgs e)
    {
        MatrixMessage.Text = string.Empty;

        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            MatrixMessage.Text = "Vui lòng lưu sản phẩm trước khi tạo biến thể.";
            return;
        }

        var selectedAttrIds = ParseSelectedAttributeIds();

        if (selectedAttrIds.Count == 0)
        {
            MatrixMessage.Text = "Vui lòng chọn ít nhất 1 thuộc tính.";
            return;
        }

        if (selectedAttrIds.Count > 5)
        {
            MatrixMessage.Text = "Tối đa 5 thuộc tính cho một matrix.";
            return;
        }

        if (MatrixValueRepeater.Items.Count == 0)
        {
            BindMatrixValues(selectedAttrIds);
        }

        using (var db = new BeautyStoryContext())
        {
            foreach (RepeaterItem item in MatrixRepeater.Items)
            {
                var variantIdField = (HiddenField)item.FindControl("RowVariantId");
                var valueIdsField = (HiddenField)item.FindControl("RowValueIds");
                var skuInput = (TextBox)item.FindControl("RowSku");
                var priceInput = (TextBox)item.FindControl("RowPrice");
                var saleInput = (TextBox)item.FindControl("RowSalePrice");
                var stockInput = (TextBox)item.FindControl("RowStock");
                var statusInput = (CheckBox)item.FindControl("RowStatus");

                var valueIdList = new List<int>();
                if (!string.IsNullOrWhiteSpace(valueIdsField.Value))
                {
                    var rawIds = valueIdsField.Value.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var rawId in rawIds)
                    {
                        int valueId;
                        if (int.TryParse(rawId, out valueId) && valueId > 0)
                        {
                            valueIdList.Add(valueId);
                        }
                    }
                }

                if (valueIdList.Count == 0)
                {
                    continue;
                }

                decimal price;
                if (!TryParseDecimal(priceInput.Text, out price))
                {
                    price = 0;
                }

                decimal? salePrice = null;
                decimal saleValue;
                if (!string.IsNullOrWhiteSpace(saleInput.Text) && TryParseDecimal(saleInput.Text, out saleValue))
                {
                    salePrice = saleValue;
                }

                int stockQty = 0;
                int.TryParse(stockInput.Text, out stockQty);

                CfProductVariant variant;
                int variantId;
                if (int.TryParse(variantIdField.Value, out variantId) && variantId > 0)
                {
                    variant = db.CfProductVariants.FirstOrDefault(v => v.Id == variantId && v.ProductId == productId);
                    if (variant == null)
                    {
                        continue;
                    }
                }
                else
                {
                    variant = new CfProductVariant
                    {
                        ProductId = productId,
                        CreatedAt = DateTime.UtcNow,
                        CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                    };
                    db.CfProductVariants.Add(variant);
                }

                var nameParts = valueIdList.Select(id => GetValueName(db, id)).Where(name => !string.IsNullOrWhiteSpace(name)).ToList();
                variant.VariantName = string.Join(" - ", nameParts);
                variant.Sku = string.IsNullOrWhiteSpace(skuInput.Text) ? null : skuInput.Text.Trim();
                variant.Price = price;
                variant.SalePrice = salePrice;
                variant.StockQty = stockQty;
                variant.Status = statusInput.Checked;
                variant.UpdatedAt = DateTime.UtcNow;
                variant.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

                db.SaveChanges();

                int mapCount = Math.Min(selectedAttrIds.Count, valueIdList.Count);
                for (int index = 0; index < mapCount; index++)
                {
                    UpsertVariantAttribute(db, variant.Id, selectedAttrIds[index], valueIdList[index]);
                }
                db.SaveChanges();
            }
        }

        MatrixMessage.CssClass = "text-success small d-block mb-2";
        MatrixMessage.Text = "Lưu biến thể theo matrix thành công.";
        BindVariants();
        BindMatrixRows();
    }


    protected void OgRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("og");
    }

    protected void TwitterRemoveButton_Click(object sender, EventArgs e)
    {
        RemoveImage("twitter");
    }

    protected void ImageSaveButton_Click(object sender, EventArgs e)
    {
        ImageMessage.Text = string.Empty;

        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            ImageMessage.Text = "Vui lòng lưu sản phẩm trước khi tải ảnh.";
            return;
        }

        if (ImageUpload == null || !ImageUpload.HasFile)
        {
            ImageMessage.Text = "Vui lòng chọn ảnh để tải.";
            return;
        }

        string imageUrl = SaveUploadedFile(ImageUpload, "products/images", null);
        string altText = (ImageAltInput.Text ?? string.Empty).Trim();
        string sortText = (ImageSortOrderInput.Text ?? string.Empty).Trim();
        bool isPrimary = ImagePrimaryInput.Checked;

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            if (isPrimary)
            {
                var existing = db.CfProductImages.Where(i => i.ProductId == productId).ToList();
                foreach (var img in existing)
                {
                    img.IsPrimary = false;
                }
            }

            var image = new CfProductImage
            {
                ProductId = productId,
                ImageUrl = imageUrl,
                AltText = string.IsNullOrWhiteSpace(altText) ? null : altText,
                IsPrimary = isPrimary,
                Status = true,
                SortOrder = sortOrder,
                CreatedAt = DateTime.UtcNow,
                CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
            };
            db.CfProductImages.Add(image);
            db.SaveChanges();
        }

        ImageMessage.CssClass = "text-success small d-block mt-2";
        ImageMessage.Text = "Tải ảnh thành công.";
        ResetImageForm();
        BindImages();
    }

    protected void ImageResetButton_Click(object sender, EventArgs e)
    {
        ResetImageForm();
    }

    protected void ImageRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "DeleteImage")
        {
            DeleteImage(id);
        }
        else if (e.CommandName == "SetPrimary")
        {
            SetPrimaryImage(id);
        }

        BindImages();
    }

    protected void VariantSaveButton_Click(object sender, EventArgs e)
    {
        VariantMessage.Text = string.Empty;

        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            VariantMessage.Text = "Vui lòng lưu sản phẩm trước khi thêm biến thể.";
            return;
        }

        string name = (VariantNameInput.Text ?? string.Empty).Trim();
        string sku = (VariantSkuInput.Text ?? string.Empty).Trim();
        string priceText = (VariantPriceInput.Text ?? string.Empty).Trim();
        string saleText = (VariantSalePriceInput.Text ?? string.Empty).Trim();
        string stockText = (VariantStockInput.Text ?? string.Empty).Trim();
        string sortText = (VariantSortOrderInput.Text ?? string.Empty).Trim();
        bool status = VariantStatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            VariantMessage.Text = "Vui lòng nhập tên biến thể.";
            return;
        }

        decimal price;
        if (!TryParseDecimal(priceText, out price) || price < 0)
        {
            VariantMessage.Text = "Giá không hợp lệ.";
            return;
        }

        decimal? salePrice = null;
        decimal saleValue;
        if (!string.IsNullOrWhiteSpace(saleText))
        {
            if (!TryParseDecimal(saleText, out saleValue))
            {
                VariantMessage.Text = "Giá khuyến mãi không hợp lệ.";
                return;
            }
            salePrice = saleValue;
        }

        int stockQty = 0;
        if (!string.IsNullOrWhiteSpace(stockText))
        {
            int.TryParse(stockText, out stockQty);
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            CfProductVariant variant;
            int id;
            if (int.TryParse(VariantEditId.Value, out id) && id > 0)
            {
                variant = db.CfProductVariants.FirstOrDefault(v => v.Id == id && v.ProductId == productId);
                if (variant == null)
                {
                    VariantMessage.Text = "Biến thể không tồn tại.";
                    return;
                }
            }
            else
            {
                variant = new CfProductVariant();
                variant.ProductId = productId;
                variant.CreatedAt = DateTime.UtcNow;
                variant.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfProductVariants.Add(variant);
            }

            variant.VariantName = string.IsNullOrWhiteSpace(name) ? null : name;
            variant.Sku = string.IsNullOrWhiteSpace(sku) ? null : sku;
            variant.Price = price;
            variant.SalePrice = salePrice;
            variant.StockQty = stockQty;
            variant.SortOrder = sortOrder;
            variant.Status = status;
            variant.UpdatedAt = DateTime.UtcNow;
            variant.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        VariantMessage.CssClass = "text-success small d-block mb-2";
        VariantMessage.Text = "Lưu biến thể thành công.";
        ResetVariantForm();
        BindVariants();
    }

    protected void VariantResetButton_Click(object sender, EventArgs e)
    {
        ResetVariantForm();
    }

    protected void VariantRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditVariant")
        {
            LoadVariantToForm(id);
        }
        else if (e.CommandName == "SelectVariant")
        {
            SelectDropdown(VariantSelectInput, id);
            BindAttributeValues();
            BindVariantAttributes();
            VariantAttrMessage.CssClass = "text-success small d-block mb-2";
            VariantAttrMessage.Text = "Đã chọn biến thể để gán thuộc tính.";
        }
        else if (e.CommandName == "DeleteVariant")
        {
            DeleteVariant(id);
            BindVariants();
        }
    }

    protected void VariantSelectInput_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindVariantAttributes();
    }

    protected void AttributeSelectInput_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAttributeValues();
    }

    private void LoadProductToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var product = db.CfProducts.FirstOrDefault(p => p.Id == id);
            if (product == null)
            {
                return;
            }

            ProductId.Value = product.Id.ToString();
            ProductNameInput.Text = product.ProductName;
            SelectDropdown(CategoryInput, product.CategoryId);
            SelectDropdown(BrandInput, product.BrandId);
            SelectDropdown(OriginInput, product.OriginId);
            ShortDescriptionInput.Text = product.ShortDescription;
            DescriptionInput.Text = product.Description;
            SpecificationInput.Text = product.Specification;
            IngredientsInput.Text = product.Ingredients;
            UsageInput.Text = product.Usage;
            SeoTitleInput.Text = product.SeoTitle;
            SeoDescriptionInput.Text = product.SeoDescription;
            SeoKeywordsInput.Text = product.SeoKeywords;
            OgTitleInput.Text = product.OgTitle;
            OgDescriptionInput.Text = product.OgDescription;
            OgImageValue.Value = product.OgImage;
            SetPreview(OgImagePreview, product.OgImage);
            OgTypeInput.Text = product.OgType;
            TwitterTitleInput.Text = product.TwitterTitle;
            TwitterDescriptionInput.Text = product.TwitterDescription;
            TwitterImageValue.Value = product.TwitterImage;
            SetPreview(TwitterImagePreview, product.TwitterImage);
            CanonicalUrlInput.Text = product.CanonicalUrl;
            RobotsInput.Text = product.Robots;
            PackageWeightInput.Text = FormatNullableDecimal(product.PackageWeightGrams);
            PackageLengthInput.Text = FormatNullableDecimal(product.PackageLengthCm);
            PackageWidthInput.Text = FormatNullableDecimal(product.PackageWidthCm);
            PackageHeightInput.Text = FormatNullableDecimal(product.PackageHeightCm);
            SortOrderInput.Text = product.SortOrder.ToString();
            NewArrivalInput.Checked = product.IsNewArrival;
            TrendingInput.Checked = product.IsTrending;
            BestSellingInput.Checked = product.IsBestSelling;
            StatusInput.Checked = product.Status;

            var slug = db.CfSeoSlugs.FirstOrDefault(s => s.EntityType == "Product" && s.EntityId == product.Id);
            SeoSlugInput.Text = slug != null ? slug.SeoSlug : string.Empty;
        }

        BindImages();
        BindVariants();
        BindVariantAttributeLookups();
        BindVariantAttributes();
    }

    private void BindImages()
    {
        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            ImageRepeater.DataSource = null;
            ImageRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var images = db.CfProductImages
                .Where(i => i.ProductId == productId)
                .OrderByDescending(i => i.IsPrimary)
                .ThenBy(i => i.SortOrder)
                .Select(i => new
                {
                    i.Id,
                    i.ImageUrl,
                    i.AltText,
                    i.IsPrimary,
                    i.SortOrder,
                    IsPrimaryTag = i.IsPrimary
                        ? "<span class=\"status-tag status-on\">Chính</span>"
                        : "<span class=\"status-tag status-off\">Phụ</span>"
                })
                .ToList();

            ImageRepeater.DataSource = images;
            ImageRepeater.DataBind();
        }
    }

    private void BindVariants()
    {
        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            VariantRepeater.DataSource = null;
            VariantRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var variants = db.CfProductVariants
                .Where(v => v.ProductId == productId)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.VariantName)
                .Select(v => new
                {
                    v.Id,
                    v.VariantName,
                    v.Sku,
                    v.Price,
                    v.SalePrice,
                    v.StockQty,
                    v.Status
                })
                .ToList()
                .Select(v => new
                {
                    v.Id,
                    VariantName = v.VariantName ?? "-",
                    v.Sku,
                    PriceLabel = v.SalePrice.HasValue && v.SalePrice.Value > 0
                        ? string.Format(new CultureInfo("vi-VN"), "{0:C0}", v.SalePrice.Value)
                        : string.Format(new CultureInfo("vi-VN"), "{0:C0}", v.Price),
                    v.StockQty,
                    v.Status
                })
                .ToList();

            VariantRepeater.DataSource = variants;
            VariantRepeater.DataBind();
        }
    }
    private void BindMatrixAttributes()
    {
        using (var db = new BeautyStoryContext())
        {
            var attributes = db.CfVariantAttributes
                .OrderBy(a => a.SortOrder)
                .ThenBy(a => a.AttributeName)
                .Select(a => new { a.Id, a.AttributeName })
                .ToList();

            MatrixAttributeSelect.Items.Clear();
            MatrixAttributeSelect.Items.Add(new ListItem(HttpUtility.HtmlDecode("-- Chọn thuộc tính. --"), ""));

            foreach (var item in attributes)
            {
                MatrixAttributeSelect.Items.Add(new ListItem(item.AttributeName, item.Id.ToString()));
            }
        }
    }

    private void LoadMatrixSelectionsFromProduct(int productId)
    {
        using (var db = new BeautyStoryContext())
        {
            var attributeOrder = db.CfVariantAttributes
                .OrderBy(a => a.SortOrder)
                .ThenBy(a => a.AttributeName)
                .Select(a => a.Id)
                .ToList();

            var map = db.CfProductVariantAttributes
                .Where(x => x.Variant.ProductId == productId)
                .Select(x => new { x.AttributeId, x.AttributeValueId })
                .ToList()
                .GroupBy(x => x.AttributeId)
                .ToDictionary(g => g.Key, g => g.Select(v => v.AttributeValueId).Distinct().ToList());

            if (map.Count == 0)
            {
                return;
            }

            var selectedAttrIds = attributeOrder.Where(map.ContainsKey).Take(5).ToList();
            if (selectedAttrIds.Count == 0)
            {
                return;
            }

            MatrixSelectedAttributeIds.Value = string.Join(",", selectedAttrIds);
            SaveMatrixSelectedValues(map);
            BindMatrixValues(selectedAttrIds);
            BindMatrixRows();

            var firstAttrId = selectedAttrIds.FirstOrDefault();
            if (firstAttrId > 0)
            {
                MatrixAttributeSelect.SelectedValue = firstAttrId.ToString();
                BindMatrixAttributeValues();
            }
        }
    }

    private List<int> ParseSelectedAttributeIds()
    {
        var result = new List<int>();
        if (string.IsNullOrWhiteSpace(MatrixSelectedAttributeIds.Value))
        {
            return result;
        }

        var parts = MatrixSelectedAttributeIds.Value.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
        foreach (var part in parts)
        {
            int id;
            if (int.TryParse(part, out id) && id > 0)
            {
                result.Add(id);
            }
        }

        return result;
    }

    private Dictionary<int, List<int>> GetMatrixSelectedValues()
    {
        var map = ViewState["MatrixSelectedValues"] as Dictionary<int, List<int>>;
        if (map == null)
        {
            map = new Dictionary<int, List<int>>();
            ViewState["MatrixSelectedValues"] = map;
        }

        return map;
    }

    private void SaveMatrixSelectedValues(Dictionary<int, List<int>> map)
    {
        ViewState["MatrixSelectedValues"] = map;
    }

    private void BindMatrixAttributeValues()
    {
        int attrId;
        if (!int.TryParse(MatrixAttributeSelect.SelectedValue, out attrId) || attrId <= 0)
        {
            MatrixAttributeValueSelect.Items.Clear();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var values = db.CfVariantAttributeValues
                .Where(v => v.AttributeId == attrId)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.ValueName)
                .Select(v => new { v.Id, v.ValueName })
                .ToList();

            MatrixAttributeValueSelect.Items.Clear();
            foreach (var item in values)
            {
                MatrixAttributeValueSelect.Items.Add(new ListItem(item.ValueName, item.Id.ToString()));
            }

            var map = GetMatrixSelectedValues();
            if (map.ContainsKey(attrId))
            {
                var selectedValues = map[attrId];
                foreach (ListItem listItem in MatrixAttributeValueSelect.Items)
                {
                    listItem.Selected = selectedValues.Contains(int.Parse(listItem.Value));
                }
            }
        }
    }

    private class MatrixValueOption
    {
        public int Id { get; set; }
        public string ValueName { get; set; }
    }

    private class MatrixAttributeOption
    {
        public int AttributeId { get; set; }
        public string AttributeName { get; set; }
        public List<MatrixValueOption> Values { get; set; }
    }

    private void BindMatrixValues(List<int> attributeIds)
    {
        if (attributeIds == null || attributeIds.Count == 0)
        {
            MatrixValueRepeater.DataSource = null;
            MatrixValueRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var attributes = db.CfVariantAttributes
                .Where(a => attributeIds.Contains(a.Id))
                .OrderBy(a => a.SortOrder)
                .ThenBy(a => a.AttributeName)
                .Select(a => new { a.Id, a.AttributeName })
                .ToList();

            var values = db.CfVariantAttributeValues
                .Where(v => attributeIds.Contains(v.AttributeId))
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.ValueName)
                .Select(v => new { v.Id, v.AttributeId, v.ValueName })
                .ToList();

            var data = attributes.Select(a => new MatrixAttributeOption
            {
                AttributeId = a.Id,
                AttributeName = a.AttributeName,
                Values = values
                    .Where(v => v.AttributeId == a.Id)
                    .Select(v => new MatrixValueOption { Id = v.Id, ValueName = v.ValueName })
                    .ToList()
            }).ToList();

            MatrixValueRepeater.DataSource = data;
            MatrixValueRepeater.DataBind();
        }
    }

    private void BindMatrixRows()
    {
        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            MatrixRepeater.DataSource = null;
            MatrixRepeater.DataBind();
            return;
        }

        var selectedAttrIds = ParseSelectedAttributeIds();

        if (selectedAttrIds.Count == 0)
        {
            MatrixMessage.Text = "Vui lòng chọn ít nhất 1 thuộc tính.";
            return;
        }

        if (selectedAttrIds.Count > 5)
        {
            MatrixMessage.Text = "Tối đa 5 thuộc tính cho một matrix.";
            return;
        }

        var selectedValuesByAttr = new Dictionary<int, List<int>>();

        var map = GetMatrixSelectedValues();

        var selectedNamesByAttr = new Dictionary<int, List<string>>();

        foreach (RepeaterItem item in MatrixValueRepeater.Items)
        {
            var attrField = (HiddenField)item.FindControl("MatrixAttrId");
            var list = (ListBox)item.FindControl("MatrixValueList");
            if (attrField == null || list == null)
            {
                continue;
            }

            int attrId;
            if (!int.TryParse(attrField.Value, out attrId) || attrId <= 0)
            {
                continue;
            }

            var selectedItems = list.Items.Cast<ListItem>().Where(i => i.Selected).ToList();
            selectedValuesByAttr[attrId] = selectedItems.Select(i => int.Parse(i.Value)).ToList();
            selectedNamesByAttr[attrId] = selectedItems.Select(i => i.Text).ToList();
        }

        var valueIdsByAttr = selectedAttrIds
            .Select(id => selectedValuesByAttr.ContainsKey(id) ? selectedValuesByAttr[id] : new List<int>())
            .ToList();

        var valueNamesByAttr = selectedAttrIds
            .Select(id => selectedNamesByAttr.ContainsKey(id) ? selectedNamesByAttr[id] : new List<string>())
            .ToList();

        if (valueIdsByAttr.Any(list => list.Count == 0))
        {
            MatrixMessage.Text = "Vui lòng chọn giá trị cho tất cả thuộc tính.";
            MatrixRepeater.DataSource = null;
            MatrixRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var variantAttrs = db.CfProductVariantAttributes
                .Where(x => x.Variant.ProductId == productId && selectedAttrIds.Contains(x.AttributeId))
                .Select(x => new { x.VariantId, x.AttributeId, x.AttributeValueId })
                .ToList();

            var variants = db.CfProductVariants
                .Where(v => v.ProductId == productId)
                .ToList();

            var variantMap = new Dictionary<string, CfProductVariant>();
            foreach (var variant in variants)
            {
                var valueIds = new List<int>();
                bool hasAllValues = true;
                foreach (var attrId in selectedAttrIds)
                {
                    int valueId = variantAttrs
                        .Where(a => a.VariantId == variant.Id && a.AttributeId == attrId)
                        .Select(a => a.AttributeValueId)
                        .FirstOrDefault();

                    if (valueId <= 0)
                    {
                        hasAllValues = false;
                        break;
                    }

                    valueIds.Add(valueId);
                }

                if (!hasAllValues)
                {
                    continue;
                }

                string key = string.Join(":", valueIds);
                if (!variantMap.ContainsKey(key))
                {
                    variantMap[key] = variant;
                }
            }

            var combinations = new List<MatrixCombination>();
            BuildCombinations(valueIdsByAttr, valueNamesByAttr, 0, new List<int>(), new List<string>(), combinations);

            var rows = combinations.Select(combo =>
            {
                string key = string.Join(":", combo.ValueIds);
                CfProductVariant variant = null;
                variantMap.TryGetValue(key, out variant);

                return new
                {
                    VariantId = variant != null ? variant.Id : 0,
                    ValueIds = string.Join(",", combo.ValueIds),
                    CombinationLabel = combo.Label,
                    Sku = variant != null ? variant.Sku : string.Empty,
                    Price = variant != null ? variant.Price.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) : "0",
                    SalePrice = variant != null && variant.SalePrice.HasValue ? variant.SalePrice.Value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) : string.Empty,
                    StockQty = variant != null ? variant.StockQty.ToString() : "0",
                    Status = variant == null || variant.Status
                };
            }).ToList();

            MatrixRepeater.DataSource = rows;
            MatrixRepeater.DataBind();
        }
    }

    private class MatrixCombination
    {
        public List<int> ValueIds { get; set; }
        public string Label { get; set; }
    }

    private static void BuildCombinations(
        List<List<int>> valueIdsByAttr,
        List<List<string>> valueNamesByAttr,
        int index,
        List<int> currentIds,
        List<string> currentNames,
        List<MatrixCombination> results)
    {
        if (index >= valueIdsByAttr.Count)
        {
            results.Add(new MatrixCombination
            {
                ValueIds = new List<int>(currentIds),
                Label = string.Join(" - ", currentNames)
            });
            return;
        }

        var ids = valueIdsByAttr[index];
        var names = valueNamesByAttr[index];

        for (int i = 0; i < ids.Count; i++)
        {
            currentIds.Add(ids[i]);
            currentNames.Add(names[i]);
            BuildCombinations(valueIdsByAttr, valueNamesByAttr, index + 1, currentIds, currentNames, results);
            currentIds.RemoveAt(currentIds.Count - 1);
            currentNames.RemoveAt(currentNames.Count - 1);
        }
    }

    private static void UpsertVariantAttribute(BeautyStoryContext db, int variantId, int attributeId, int valueId)
    {
        var mapping = db.CfProductVariantAttributes.FirstOrDefault(x => x.VariantId == variantId && x.AttributeId == attributeId);
        if (mapping == null)
        {
            mapping = new CfProductVariantAttribute
            {
                VariantId = variantId,
                AttributeId = attributeId,
                AttributeValueId = valueId,
                Status = true,
                CreatedAt = DateTime.UtcNow
            };
            db.CfProductVariantAttributes.Add(mapping);
        }
        else
        {
            mapping.AttributeValueId = valueId;
            mapping.UpdatedAt = DateTime.UtcNow;
        }
    }

    private static string GetValueName(BeautyStoryContext db, int valueId)
    {
        if (valueId <= 0)
        {
            return string.Empty;
        }

        var value = db.CfVariantAttributeValues.FirstOrDefault(v => v.Id == valueId);
        return value != null ? value.ValueName : string.Empty;
    }

    private void BindVariantAttributeLookups()
    {
        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            VariantSelectInput.Items.Clear();
            VariantSelectInput.Items.Add(new ListItem("-- Chọn biến thể --", ""));
            AttributeSelectInput.Items.Clear();
            AttributeSelectInput.Items.Add(new ListItem("-- Chọn thuộc tính --", ""));
            ValueSelectInput.Items.Clear();
            ValueSelectInput.Items.Add(new ListItem("-- Chọn giá trị --", ""));
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var variants = db.CfProductVariants
                .Where(v => v.ProductId == productId)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.VariantName)
                .Select(v => new { v.Id, v.VariantName })
                .ToList();

            VariantSelectInput.Items.Clear();
            VariantSelectInput.Items.Add(new ListItem("-- Chọn biến thể --", ""));
            foreach (var v in variants)
            {
                VariantSelectInput.Items.Add(new ListItem(v.VariantName ?? ("Biến thể " + v.Id), v.Id.ToString()));
            }

            if (variants.Count > 0 && string.IsNullOrWhiteSpace(VariantSelectInput.SelectedValue))
            {
                VariantSelectInput.SelectedValue = variants[0].Id.ToString();
            }

            var attributes = db.CfVariantAttributes
                .OrderBy(a => a.SortOrder)
                .ThenBy(a => a.AttributeName)
                .Select(a => new { a.Id, a.AttributeName })
                .ToList();

            AttributeSelectInput.Items.Clear();
            AttributeSelectInput.Items.Add(new ListItem("-- Chọn thuộc tính --", ""));
            foreach (var a in attributes)
            {
                AttributeSelectInput.Items.Add(new ListItem(a.AttributeName, a.Id.ToString()));
            }
        }

        BindAttributeValues();
    }

    private void BindAttributeValues()
    {
        int attributeId;
        if (!int.TryParse(AttributeSelectInput.SelectedValue, out attributeId) || attributeId <= 0)
        {
            ValueSelectInput.Items.Clear();
            ValueSelectInput.Items.Add(new ListItem("-- Chọn giá trị --", ""));
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var values = db.CfVariantAttributeValues
                .Where(v => v.AttributeId == attributeId)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.ValueName)
                .Select(v => new { v.Id, v.ValueName })
                .ToList();

            ValueSelectInput.Items.Clear();
            ValueSelectInput.Items.Add(new ListItem("-- Chọn giá trị --", ""));
            foreach (var v in values)
            {
                ValueSelectInput.Items.Add(new ListItem(v.ValueName, v.Id.ToString()));
            }
        }
    }

    private void BindVariantAttributes()
    {
        int productId;
        int variantId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            VariantAttrRepeater.DataSource = null;
            VariantAttrRepeater.DataBind();
            return;
        }

        int.TryParse(VariantSelectInput.SelectedValue, out variantId);

        using (var db = new BeautyStoryContext())
        {
            var query = from va in db.CfProductVariantAttributes
                        join v in db.CfProductVariants on va.VariantId equals v.Id
                        join a in db.CfVariantAttributes on va.AttributeId equals a.Id
                        join val in db.CfVariantAttributeValues on va.AttributeValueId equals val.Id
                        where v.ProductId == productId
                        select new
                        {
                            va.Id,
                            va.VariantId,
                            VariantName = v.VariantName ?? ("Biến thể " + v.Id),
                            AttributeName = a.AttributeName,
                            ValueName = val.ValueName,
                            va.SortOrder,
                            va.Status
                        };

            if (variantId > 0)
            {
                query = query.Where(x => x.VariantId == variantId);
            }

            var items = query
                .OrderBy(x => x.VariantName)
                .ThenBy(x => x.SortOrder)
                .ToList();

            VariantAttrRepeater.DataSource = items;
            VariantAttrRepeater.DataBind();
        }
    }

    protected void VariantAttrSaveButton_Click(object sender, EventArgs e)
    {
        VariantAttrMessage.Text = string.Empty;

        int productId;
        if (!int.TryParse(ProductId.Value, out productId) || productId <= 0)
        {
            VariantAttrMessage.Text = "Vui lòng lưu sản phẩm trước khi thêm thuộc tính.";
            return;
        }

        int variantId;
        if (!int.TryParse(VariantSelectInput.SelectedValue, out variantId) || variantId <= 0)
        {
            VariantAttrMessage.Text = "Vui lòng chọn biến thể.";
            return;
        }

        int attributeId;
        if (!int.TryParse(AttributeSelectInput.SelectedValue, out attributeId) || attributeId <= 0)
        {
            VariantAttrMessage.Text = "Vui lòng chọn thuộc tính.";
            return;
        }

        int valueId;
        if (!int.TryParse(ValueSelectInput.SelectedValue, out valueId) || valueId <= 0)
        {
            VariantAttrMessage.Text = "Vui lòng chọn giá trị.";
            return;
        }

        int sortOrder = 0;
        int.TryParse(VariantAttrSortOrderInput.Text, out sortOrder);
        bool status = VariantAttrStatusInput.Checked;

        using (var db = new BeautyStoryContext())
        {
            var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == variantId && v.ProductId == productId);
            if (variant == null)
            {
                VariantAttrMessage.Text = "Biến thể không tồn tại.";
                return;
            }

            var value = db.CfVariantAttributeValues.FirstOrDefault(v => v.Id == valueId && v.AttributeId == attributeId);
            if (value == null)
            {
                VariantAttrMessage.Text = "Giá trị không hợp lệ.";
                return;
            }

            CfProductVariantAttribute mapping;
            int editId;
            if (int.TryParse(VariantAttrEditId.Value, out editId) && editId > 0)
            {
                mapping = db.CfProductVariantAttributes.FirstOrDefault(x => x.Id == editId);
                if (mapping == null)
                {
                    VariantAttrMessage.Text = "Thuộc tính biến thể không tồn tại.";
                    return;
                }
            }
            else
            {
                bool exists = db.CfProductVariantAttributes.Any(x =>
                    x.VariantId == variantId && x.AttributeId == attributeId && x.AttributeValueId == valueId);
                if (exists)
                {
                    VariantAttrMessage.Text = "Thuộc tính này đã tồn tại cho biến thể.";
                    return;
                }

                mapping = new CfProductVariantAttribute
                {
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null
                };
                db.CfProductVariantAttributes.Add(mapping);
            }

            mapping.VariantId = variantId;
            mapping.AttributeId = attributeId;
            mapping.AttributeValueId = valueId;
            mapping.SortOrder = sortOrder;
            mapping.Status = status;
            mapping.UpdatedAt = DateTime.UtcNow;
            mapping.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        VariantAttrMessage.CssClass = "text-success small d-block mb-2";
        VariantAttrMessage.Text = "Lưu thuộc tính biến thể thành công.";
        ResetVariantAttrForm();
        BindVariantAttributes();
    }

    protected void VariantAttrResetButton_Click(object sender, EventArgs e)
    {
        ResetVariantAttrForm();
    }

    protected void VariantAttrRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditVariantAttr")
        {
            LoadVariantAttrToForm(id);
        }
        else if (e.CommandName == "DeleteVariantAttr")
        {
            DeleteVariantAttr(id);
            BindVariantAttributes();
        }
    }

    private void LoadVariantAttrToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var item = db.CfProductVariantAttributes.FirstOrDefault(x => x.Id == id);
            if (item == null)
            {
                return;
            }

            VariantAttrEditId.Value = item.Id.ToString();
            SelectDropdown(VariantSelectInput, item.VariantId);
            SelectDropdown(AttributeSelectInput, item.AttributeId);
            BindAttributeValues();
            SelectDropdown(ValueSelectInput, item.AttributeValueId);
            VariantAttrSortOrderInput.Text = item.SortOrder.ToString();
            VariantAttrStatusInput.Checked = item.Status;
        }
    }

    private void DeleteVariantAttr(int id)
    {
        VariantAttrMessage.Text = string.Empty;

        using (var db = new BeautyStoryContext())
        {
            var item = db.CfProductVariantAttributes.FirstOrDefault(x => x.Id == id);
            if (item == null)
            {
                VariantAttrMessage.Text = "Thuộc tính biến thể không tồn tại.";
                return;
            }

            db.CfProductVariantAttributes.Remove(item);
            db.SaveChanges();
        }

        VariantAttrMessage.CssClass = "text-success small d-block mb-2";
        VariantAttrMessage.Text = "Xóa thuộc tính biến thể thành công.";
        ResetVariantAttrForm();
    }

    private void LoadVariantToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == id);
            if (variant == null)
            {
                return;
            }

            VariantEditId.Value = variant.Id.ToString();
            VariantNameInput.Text = variant.VariantName;
            VariantSkuInput.Text = variant.Sku;
            VariantPriceInput.Text = variant.Price.ToString(CultureInfo.InvariantCulture);
            VariantSalePriceInput.Text = variant.SalePrice.HasValue ? variant.SalePrice.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            VariantStockInput.Text = variant.StockQty.ToString();
            VariantSortOrderInput.Text = variant.SortOrder.ToString();
            VariantStatusInput.Checked = variant.Status;
        }
    }

    private void DeleteVariant(int id)
    {
        VariantMessage.Text = string.Empty;

        using (var db = new BeautyStoryContext())
        {
            var variant = db.CfProductVariants.FirstOrDefault(v => v.Id == id);
            if (variant == null)
            {
                VariantMessage.Text = "Biến thể không tồn tại.";
                return;
            }

            bool hasAttributes = db.CfProductVariantAttributes.Any(a => a.VariantId == id);
            bool hasImages = db.CfProductImages.Any(i => i.VariantId == id);
            if (hasAttributes || hasImages)
            {
                VariantMessage.Text = "Không thể xóa biến thể đang được sử dụng.";
                return;
            }

            db.CfProductVariants.Remove(variant);
            db.SaveChanges();
        }

        VariantMessage.CssClass = "text-success small d-block mb-2";
        VariantMessage.Text = "Xóa biến thể thành công.";
        ResetVariantForm();
    }

    private void DeleteImage(int id)
    {
        ImageMessage.Text = string.Empty;

        using (var db = new BeautyStoryContext())
        {
            var image = db.CfProductImages.FirstOrDefault(i => i.Id == id);
            if (image == null)
            {
                ImageMessage.Text = "Ảnh không tồn tại.";
                return;
            }

            db.CfProductImages.Remove(image);
            db.SaveChanges();
        }

        ImageMessage.CssClass = "text-success small d-block mt-2";
        ImageMessage.Text = "Xóa ảnh thành công.";
    }

    private void SetPrimaryImage(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var image = db.CfProductImages.FirstOrDefault(i => i.Id == id);
            if (image == null)
            {
                return;
            }

            var images = db.CfProductImages.Where(i => i.ProductId == image.ProductId).ToList();
            foreach (var img in images)
            {
                img.IsPrimary = img.Id == id;
            }

            db.SaveChanges();
        }
    }

    private void ResetForm()
    {
        ProductId.Value = string.Empty;
        ProductNameInput.Text = string.Empty;
        CategoryInput.ClearSelection();
        BrandInput.ClearSelection();
        OriginInput.ClearSelection();
        ShortDescriptionInput.Text = string.Empty;
        DescriptionInput.Text = string.Empty;
        SpecificationInput.Text = string.Empty;
        IngredientsInput.Text = string.Empty;
        UsageInput.Text = string.Empty;
        SeoTitleInput.Text = string.Empty;
        SeoSlugInput.Text = string.Empty;
        SeoDescriptionInput.Text = string.Empty;
        SeoKeywordsInput.Text = string.Empty;
        OgTitleInput.Text = string.Empty;
        OgDescriptionInput.Text = string.Empty;
        OgImageValue.Value = string.Empty;
        SetPreview(OgImagePreview, null);
        OgTypeInput.Text = string.Empty;
        TwitterTitleInput.Text = string.Empty;
        TwitterDescriptionInput.Text = string.Empty;
        TwitterImageValue.Value = string.Empty;
        SetPreview(TwitterImagePreview, null);
        CanonicalUrlInput.Text = string.Empty;
        RobotsInput.Text = string.Empty;
        PackageWeightInput.Text = string.Empty;
        PackageLengthInput.Text = string.Empty;
        PackageWidthInput.Text = string.Empty;
        PackageHeightInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        NewArrivalInput.Checked = false;
        TrendingInput.Checked = false;
        BestSellingInput.Checked = false;
        StatusInput.Checked = true;
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
        ResetImageForm();
        ResetVariantForm();
        ResetVariantAttrForm();
        MatrixMessage.Text = string.Empty;
    }

    private static decimal? ParseNullableDecimal(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        decimal parsed;
        if (decimal.TryParse(value, NumberStyles.Number, CultureInfo.CurrentCulture, out parsed))
        {
            return parsed;
        }

        if (decimal.TryParse(value, NumberStyles.Number, CultureInfo.InvariantCulture, out parsed))
        {
            return parsed;
        }

        return null;
    }

    private static string FormatNullableDecimal(decimal? value)
    {
        return value.HasValue ? value.Value.ToString("0.##", CultureInfo.CurrentCulture) : string.Empty;
    }

    private void ResetImageForm()
    {
        ImageAltInput.Text = string.Empty;
        ImageSortOrderInput.Text = "0";
        ImagePrimaryInput.Checked = false;
        ImageMessage.Text = string.Empty;
        ImageMessage.CssClass = "text-danger small d-block mt-2";
    }

    private void ResetVariantForm()
    {
        VariantEditId.Value = string.Empty;
        VariantNameInput.Text = string.Empty;
        VariantSkuInput.Text = string.Empty;
        VariantPriceInput.Text = "0";
        VariantSalePriceInput.Text = string.Empty;
        VariantStockInput.Text = "0";
        VariantSortOrderInput.Text = "0";
        VariantStatusInput.Checked = true;
        VariantMessage.Text = string.Empty;
        VariantMessage.CssClass = "text-danger small d-block mb-2";
    }

    private void ResetVariantAttrForm()
    {
        VariantAttrEditId.Value = string.Empty;
        VariantAttrSortOrderInput.Text = "0";
        VariantAttrStatusInput.Checked = true;
        VariantAttrMessage.Text = string.Empty;
        VariantAttrMessage.CssClass = "text-danger small d-block mb-2";
    }

    private static bool TryParseDecimal(string value, out decimal result)
    {
        return decimal.TryParse(value, NumberStyles.Any, CultureInfo.GetCultureInfo("vi-VN"), out result)
            || decimal.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out result);
    }

    private static void SetPreview(System.Web.UI.WebControls.Image image, string url)
    {
        if (image == null)
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(url))
        {
            image.Visible = false;
            image.ImageUrl = string.Empty;
            return;
        }

        image.Visible = true;
        image.ImageUrl = url;
    }

    private string SaveUploadedFile(FileUpload upload, string folder, string existingPath)
    {
        if (upload == null || !upload.HasFile)
        {
            return existingPath;
        }

        string fileName = Path.GetFileName(upload.FileName);
        string extension = Path.GetExtension(fileName);
        string uniqueName = string.Format("{0}_{1:yyyyMMddHHmmssfff}{2}", Guid.NewGuid().ToString("N"), DateTime.UtcNow, extension);
        string virtualFolder = string.Format("~/upload/{0}", folder.Trim('/'));
        string physicalFolder = Server.MapPath(virtualFolder);

        if (!Directory.Exists(physicalFolder))
        {
            Directory.CreateDirectory(physicalFolder);
        }

        string physicalPath = Path.Combine(physicalFolder, uniqueName);
        upload.SaveAs(physicalPath);
        return string.Format("/upload/{0}/{1}", folder.Trim('/'), uniqueName);
    }

    private void RemoveImage(string type)
    {
        int id;
        if (!int.TryParse(ProductId.Value, out id) || id <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var product = db.CfProducts.FirstOrDefault(p => p.Id == id);
            if (product == null)
            {
                return;
            }

            switch (type)
            {
                case "og":
                    product.OgImage = null;
                    OgImageValue.Value = string.Empty;
                    SetPreview(OgImagePreview, null);
                    break;
                case "twitter":
                    product.TwitterImage = null;
                    TwitterImageValue.Value = string.Empty;
                    SetPreview(TwitterImagePreview, null);
                    break;
            }

            product.UpdatedAt = DateTime.UtcNow;
            product.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }
    }

    private static void SelectDropdown(ListControl control, int? value)
    {
        if (control == null)
        {
            return;
        }

        control.ClearSelection();
        if (value.HasValue)
        {
            var item = control.Items.FindByValue(value.Value.ToString());
            if (item != null)
            {
                item.Selected = true;
            }
        }
    }
    private class FilterGroupView
    {
        public int GroupId { get; set; }
        public string GroupName { get; set; }
        public List<FilterOptionView> Options { get; set; }
    }

    private class FilterOptionView
    {
        public int GroupId { get; set; }
        public int OptionId { get; set; }
        public string OptionName { get; set; }
        public bool IsSelected { get; set; }
    }
}









