using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.IO;
using System.Web.UI.WebControls;

public partial class SellerProductAdd : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!IsPostBack)
        {
            BindDropdowns();
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
            var product = new CfProduct
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

            var variant = new CfProductVariant
            {
                ProductId = product.Id,
                VariantName = "Mặc định",
                Sku = (SkuInput.Text ?? string.Empty).Trim(),
                Price = price,
                SalePrice = salePrice,
                StockQty = stock.Value,
                Status = publish,
                CreatedAt = now,
                CreatedBy = "Seller",
                SortOrder = 0
            };
            db.CfProductVariants.Add(variant);

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
