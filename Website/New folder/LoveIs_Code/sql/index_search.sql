IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_Search' AND object_id = OBJECT_ID('dbo.cf_product'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_product_Search
    ON dbo.cf_product (Status, ProductName, CreatedAt, Id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_variant_Product_Status' AND object_id = OBJECT_ID('dbo.cf_product_variant'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_product_variant_Product_Status
    ON dbo.cf_product_variant (ProductId, Status, SalePrice, Price);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_image_Product_Status' AND object_id = OBJECT_ID('dbo.cf_product_image'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_product_image_Product_Status
    ON dbo.cf_product_image (ProductId, Status, IsPrimary);
END;
GO
