SET NOCOUNT ON;

DECLARE @Now DATETIME = GETDATE();

DECLARE @Attr_DungTich INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung tích');
DECLARE @Attr_MuiHuong INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Mùi hương');

IF @Attr_MuiHuong IS NULL
BEGIN
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mùi hương', N'Mùi hương sản phẩm', 1, @Now, N'Seed', 6);

    SET @Attr_MuiHuong = SCOPE_IDENTITY();
END;

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @Attr_MuiHuong)
BEGIN
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@Attr_MuiHuong, N'Hương hoa', 1, @Now, N'Seed', 1),
        (@Attr_MuiHuong, N'Hương gỗ', 1, @Now, N'Seed', 2),
        (@Attr_MuiHuong, N'Hương trái cây', 1, @Now, N'Seed', 3),
        (@Attr_MuiHuong, N'Hương vani', 1, @Now, N'Seed', 4),
        (@Attr_MuiHuong, N'Hương thảo mộc', 1, @Now, N'Seed', 5),
        (@Attr_MuiHuong, N'Hương cam chanh', 1, @Now, N'Seed', 6);
END;

IF @Attr_DungTich IS NULL
BEGIN
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dung tích', N'Dung tích/khối lượng', 1, @Now, N'Seed', 1);

    SET @Attr_DungTich = SCOPE_IDENTITY();
END;

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @Attr_DungTich)
BEGIN
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@Attr_DungTich, N'15ml', 1, @Now, N'Seed', 1),
        (@Attr_DungTich, N'30ml', 1, @Now, N'Seed', 2),
        (@Attr_DungTich, N'50ml', 1, @Now, N'Seed', 3),
        (@Attr_DungTich, N'100ml', 1, @Now, N'Seed', 4),
        (@Attr_DungTich, N'200ml', 1, @Now, N'Seed', 5);
END;

DECLARE @SeedProducts TABLE (Id INT PRIMARY KEY);
INSERT INTO @SeedProducts (Id)
SELECT Id
FROM dbo.cf_product
WHERE CreatedBy = N'Seed';

DELETE FROM dbo.cf_product_variant_attribute
WHERE VariantId IN (
    SELECT v.Id
    FROM dbo.cf_product_variant v
    WHERE v.ProductId IN (SELECT Id FROM @SeedProducts)
);

IF OBJECT_ID('dbo.cf_stock_movement', 'U') IS NOT NULL
BEGIN
    DELETE FROM dbo.cf_stock_movement
    WHERE VariantId IN (
        SELECT v.Id
        FROM dbo.cf_product_variant v
        WHERE v.ProductId IN (SELECT Id FROM @SeedProducts)
    );
END;

DELETE FROM dbo.cf_product_variant
WHERE ProductId IN (SELECT Id FROM @SeedProducts);

IF OBJECT_ID('tempdb..#VariantsToInsert') IS NOT NULL DROP TABLE #VariantsToInsert;
CREATE TABLE #VariantsToInsert (
    ProductId INT NOT NULL,
    VariantName NVARCHAR(200) NOT NULL,
    Sku NVARCHAR(100) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    SalePrice DECIMAL(18,2) NULL,
    StockQty INT NOT NULL,
    SortOrder INT NOT NULL,
    DungTichValueId INT NOT NULL,
    MuiHuongValueId INT NOT NULL
);

INSERT INTO #VariantsToInsert
(
    ProductId, VariantName, Sku, Price, SalePrice, StockQty, SortOrder, DungTichValueId, MuiHuongValueId
)
SELECT
    p.Id,
    combo.ValueName,
    N'BS-' + CAST(p.Id AS NVARCHAR(10)) + N'-' + CAST(combo.rn AS NVARCHAR(10)),
    CAST(ROUND(50000 + (ABS(CHECKSUM(NEWID())) % 950000), 0) AS DECIMAL(18,2)),
    CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
         THEN CAST(ROUND(30000 + (ABS(CHECKSUM(NEWID())) % 750000), 0) AS DECIMAL(18,2))
         ELSE NULL END,
    10 + (ABS(CHECKSUM(NEWID())) % 200),
    combo.rn,
    combo.DungTichValueId,
    combo.MuiHuongValueId
FROM @SeedProducts p
CROSS APPLY (
    SELECT TOP (2 + ABS(CHECKSUM(NEWID())) % 2)
        ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn,
        dt.Id AS DungTichValueId,
        mh.Id AS MuiHuongValueId,
        dt.ValueName + N' - ' + mh.ValueName AS ValueName
    FROM dbo.cf_variant_attribute_value dt
    CROSS JOIN dbo.cf_variant_attribute_value mh
    WHERE dt.AttributeId = @Attr_DungTich
      AND mh.AttributeId = @Attr_MuiHuong
    ORDER BY NEWID()
) combo;

IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
CREATE TABLE #NewVariants (
    VariantId INT NOT NULL,
    ProductId INT NOT NULL,
    Sku NVARCHAR(100) NOT NULL,
    DungTichValueId INT NULL,
    MuiHuongValueId INT NULL
);

INSERT INTO dbo.cf_product_variant
(
    ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
    CreatedAt, CreatedBy, SortOrder
)
OUTPUT inserted.Id, inserted.ProductId, inserted.Sku
INTO #NewVariants (VariantId, ProductId, Sku)
SELECT
    src.ProductId,
    src.VariantName,
    src.Sku,
    src.Price,
    src.SalePrice,
    src.StockQty,
    1,
    DATEADD(MINUTE, -src.ProductId, @Now),
    N'Seed',
    src.SortOrder
FROM #VariantsToInsert src;

UPDATE nv
SET
    DungTichValueId = vti.DungTichValueId,
    MuiHuongValueId = vti.MuiHuongValueId
FROM #NewVariants nv
JOIN #VariantsToInsert vti
    ON vti.ProductId = nv.ProductId
   AND vti.Sku = nv.Sku;

INSERT INTO dbo.cf_product_variant_attribute
(
    VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
)
SELECT
    v.VariantId,
    @Attr_DungTich,
    v.DungTichValueId,
    1,
    @Now,
    N'Seed',
    1
FROM #NewVariants v;

INSERT INTO dbo.cf_product_variant_attribute
(
    VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
)
SELECT
    v.VariantId,
    @Attr_MuiHuong,
    v.MuiHuongValueId,
    1,
    @Now,
    N'Seed',
    2
FROM #NewVariants v;
