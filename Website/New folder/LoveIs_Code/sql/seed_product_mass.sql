SET NOCOUNT ON;

DECLARE @TargetCount INT = 7230;
DECLARE @Now DATETIME = GETDATE();

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute)
BEGIN
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Dung tích', N'Dung tích/khối lượng', 1, @Now, N'Seed', 1),
        (N'Màu sắc', N'Màu sắc sản phẩm', 1, @Now, N'Seed', 2),
        (N'Phiên bản', N'Phiên bản/loại', 1, @Now, N'Seed', 3),
        (N'Loại da', N'Loại da phù hợp', 1, @Now, N'Seed', 4),
        (N'Kết cấu', N'Kết cấu sản phẩm', 1, @Now, N'Seed', 5);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value)
BEGIN
    DECLARE @Attr_DungTich INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung tích');
    DECLARE @Attr_MauSac INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Màu sắc');
    DECLARE @Attr_PhienBan INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Phiên bản');
    DECLARE @Attr_LoaiDa INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Loại da');
    DECLARE @Attr_KetCau INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Kết cấu');

    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@Attr_DungTich, N'15ml', 1, @Now, N'Seed', 1),
        (@Attr_DungTich, N'30ml', 1, @Now, N'Seed', 2),
        (@Attr_DungTich, N'50ml', 1, @Now, N'Seed', 3),
        (@Attr_DungTich, N'100ml', 1, @Now, N'Seed', 4),
        (@Attr_DungTich, N'200ml', 1, @Now, N'Seed', 5),
        (@Attr_MauSac, N'Đỏ gạch', 1, @Now, N'Seed', 1),
        (@Attr_MauSac, N'Hồng đất', 1, @Now, N'Seed', 2),
        (@Attr_MauSac, N'Cam đất', 1, @Now, N'Seed', 3),
        (@Attr_MauSac, N'Trắng ngà', 1, @Now, N'Seed', 4),
        (@Attr_MauSac, N'Nude', 1, @Now, N'Seed', 5),
        (@Attr_PhienBan, N'Tiêu chuẩn', 1, @Now, N'Seed', 1),
        (@Attr_PhienBan, N'Cao cấp', 1, @Now, N'Seed', 2),
        (@Attr_PhienBan, N'Phiên bản mới', 1, @Now, N'Seed', 3),
        (@Attr_PhienBan, N'Limited', 1, @Now, N'Seed', 4),
        (@Attr_LoaiDa, N'Da dầu', 1, @Now, N'Seed', 1),
        (@Attr_LoaiDa, N'Da khô', 1, @Now, N'Seed', 2),
        (@Attr_LoaiDa, N'Da nhạy cảm', 1, @Now, N'Seed', 3),
        (@Attr_LoaiDa, N'Da hỗn hợp', 1, @Now, N'Seed', 4),
        (@Attr_KetCau, N'Dạng gel', 1, @Now, N'Seed', 1),
        (@Attr_KetCau, N'Dạng kem', 1, @Now, N'Seed', 2),
        (@Attr_KetCau, N'Dạng lotion', 1, @Now, N'Seed', 3),
        (@Attr_KetCau, N'Dạng serum', 1, @Now, N'Seed', 4);
END;

IF OBJECT_ID('tempdb..#NewProducts') IS NOT NULL DROP TABLE #NewProducts;
CREATE TABLE #NewProducts (
    Id INT NOT NULL,
    CategoryId INT NOT NULL
);

;WITH N AS (
    SELECT TOP (@TargetCount)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO dbo.cf_product
(
    ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description,
    Specification, Ingredients, Usage, Status, CreatedAt, CreatedBy, SortOrder
)
OUTPUT inserted.Id, inserted.CategoryId INTO #NewProducts (Id, CategoryId)
SELECT
    N'Sản phẩm ' + CAST(n AS NVARCHAR(10)),
    c.Id,
    b.Id,
    o.Id,
    N'Chăm sóc da và làm đẹp mỗi ngày.',
    N'Mô tả sản phẩm đang được cập nhật.',
    N'Thông số đang được cập nhật.',
    N'Thành phần đang được cập nhật.',
    N'HDSD đang được cập nhật.',
    1,
    DATEADD(MINUTE, -n, @Now),
    N'Seed',
    n
FROM N
CROSS APPLY (SELECT TOP 1 Id FROM dbo.cf_category WHERE Status = 1 ORDER BY NEWID()) c
OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_brand WHERE Status = 1 ORDER BY NEWID()) b
OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_origin WHERE Status = 1 ORDER BY NEWID()) o;

IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
CREATE TABLE #NewVariants (
    VariantId INT NOT NULL,
    ProductId INT NOT NULL
);

INSERT INTO dbo.cf_product_variant
(
    ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
    CreatedAt, CreatedBy, SortOrder
)
OUTPUT inserted.Id, inserted.ProductId INTO #NewVariants (VariantId, ProductId)
SELECT
    p.Id,
    N'Phiên bản ' + CAST(v.rn AS NVARCHAR(10)),
    N'BS-' + CAST(p.Id AS NVARCHAR(10)) + N'-' + CAST(v.rn AS NVARCHAR(10)),
    CAST(ROUND(50000 + (ABS(CHECKSUM(NEWID())) % 950000), 0) AS DECIMAL(18,2)),
    CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0
         THEN CAST(ROUND(30000 + (ABS(CHECKSUM(NEWID())) % 750000), 0) AS DECIMAL(18,2))
         ELSE NULL END,
    10 + (ABS(CHECKSUM(NEWID())) % 200),
    1,
    DATEADD(MINUTE, -p.Id, @Now),
    N'Seed',
    v.rn
FROM #NewProducts p
CROSS APPLY (
    SELECT TOP (2 + ABS(CHECKSUM(NEWID())) % 2)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM sys.all_objects
) v;

INSERT INTO dbo.cf_product_variant_attribute
(
    VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
)
SELECT
    v.VariantId,
    a.Id,
    av.Id,
    1,
    @Now,
    N'Seed',
    ROW_NUMBER() OVER (PARTITION BY v.VariantId ORDER BY a.Id)
FROM #NewVariants v
CROSS APPLY (
    SELECT TOP 2 Id
    FROM dbo.cf_variant_attribute
    ORDER BY NEWID()
) a
CROSS APPLY (
    SELECT TOP 1 Id
    FROM dbo.cf_variant_attribute_value
    WHERE AttributeId = a.Id
    ORDER BY NEWID()
) av;

INSERT INTO dbo.cf_product_image
(
    ProductId, VariantId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder
)
SELECT
    p.Id,
    NULL,
    N'/images/logo_doc.png',
    CASE WHEN img.idx = 1 THEN 1 ELSE 0 END,
    N'Hình sản phẩm ' + CAST(p.Id AS NVARCHAR(10)),
    1,
    @Now,
    N'Seed',
    img.idx
FROM #NewProducts p
CROSS APPLY (
    SELECT 1 AS idx
    UNION ALL SELECT 2
    UNION ALL SELECT 3
) img;

INSERT INTO dbo.cf_product_filter
(
    ProductId, GroupId, OptionId, Status, CreatedAt, CreatedBy, SortOrder
)
SELECT
    p.Id,
    g.GroupId,
    o.Id,
    1,
    @Now,
    N'Seed',
    0
FROM #NewProducts p
JOIN dbo.cf_category_filter_group g
    ON g.CategoryId = p.CategoryId
CROSS APPLY (
    SELECT TOP 1 Id
    FROM dbo.cf_filter_option fo
    WHERE fo.GroupId = g.GroupId
    ORDER BY NEWID()
) o;

INSERT INTO dbo.cf_seo_slug
(
    EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder
)
SELECT
    N'Product',
    p.Id,
    N'san-pham-' + CAST(p.Id AS NVARCHAR(10)),
    1,
    @Now,
    N'Seed',
    0
FROM #NewProducts p
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_seo_slug s
    WHERE s.EntityType = N'Product' AND s.EntityId = p.Id
);
