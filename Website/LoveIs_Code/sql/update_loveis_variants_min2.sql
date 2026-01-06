SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    ;WITH OneVariant AS (
        SELECT p.Id AS ProductId,
               COUNT(v.Id) AS VariantCount
        FROM dbo.cf_product p
        LEFT JOIN dbo.cf_product_variant v ON v.ProductId = p.Id
        GROUP BY p.Id
        HAVING COUNT(v.Id) < 2
    )
    INSERT INTO dbo.cf_product_variant
    (
        ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
        CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        ov.ProductId,
        N'Tiêu chuẩn 2',
        N'LI-' + CAST(ov.ProductId AS NVARCHAR(10)) + N'-02',
        CAST(ROUND(150000 + (ABS(CHECKSUM(NEWID())) % 650000), 0) AS DECIMAL(18,2)),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
             THEN CAST(ROUND(120000 + (ABS(CHECKSUM(NEWID())) % 450000), 0) AS DECIMAL(18,2))
             ELSE NULL END,
        20 + (ABS(CHECKSUM(NEWID())) % 200),
        1,
        DATEADD(MINUTE, -ov.ProductId, @Now),
        @SeedBy,
        2
    FROM OneVariant ov;

    DELETE FROM dbo.cf_product_filter;
    DELETE FROM dbo.cf_product_variant_attribute;

    ;WITH VariantContext AS (
        SELECT v.Id AS VariantId,
               p.CategoryId,
               c.CategoryName,
               p2.CategoryName AS ParentName,
               p3.CategoryName AS GrandName
        FROM dbo.cf_product_variant v
        JOIN dbo.cf_product p ON p.Id = v.ProductId
        JOIN dbo.cf_category c ON c.Id = p.CategoryId
        LEFT JOIN dbo.cf_category p2 ON p2.Id = c.ParentId
        LEFT JOIN dbo.cf_category p3 ON p3.Id = p2.ParentId
    ),
    AllowedAttr AS (
        SELECT vc.VariantId,
               va.Id AS AttributeId
        FROM VariantContext vc
        JOIN dbo.cf_variant_attribute va ON va.AttributeName IN (N'Kích cỡ', N'Màu sắc', N'Chất liệu', N'Kiểu dáng')

        UNION ALL

        SELECT vc.VariantId,
               va.Id AS AttributeId
        FROM VariantContext vc
        JOIN dbo.cf_variant_attribute va ON va.AttributeName = N'Cúp'
        WHERE vc.CategoryName LIKE N'%Áo ngực%'
           OR vc.CategoryName LIKE N'%Bralette%'
           OR vc.CategoryName LIKE N'%Bra%'
           OR vc.CategoryName LIKE N'%Bộ đồ lót%'
           OR vc.ParentName LIKE N'%Áo ngực%'
           OR vc.ParentName LIKE N'%Bralette%'
           OR vc.ParentName LIKE N'%Bra%'
           OR vc.ParentName LIKE N'%Bộ đồ lót%'
           OR vc.GrandName LIKE N'%Áo ngực%'
           OR vc.GrandName LIKE N'%Bralette%'
           OR vc.GrandName LIKE N'%Bra%'
           OR vc.GrandName LIKE N'%Bộ đồ lót%'
    ),
    PickedAttr AS (
        SELECT a.VariantId,
               a.AttributeId,
               ROW_NUMBER() OVER (PARTITION BY a.VariantId ORDER BY NEWID()) AS SortOrder
        FROM AllowedAttr a
    ),
    SelectedAttr AS (
        SELECT p.VariantId,
               p.AttributeId,
               p.SortOrder
        FROM PickedAttr p
        WHERE p.SortOrder <= 3
    )
    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT s.VariantId,
           s.AttributeId,
           vav.Id,
           1,
           @Now,
           @SeedBy,
           s.SortOrder
    FROM SelectedAttr s
    CROSS APPLY (
        SELECT TOP 1 Id
        FROM dbo.cf_variant_attribute_value
        WHERE AttributeId = s.AttributeId
        ORDER BY NEWID()
    ) vav;

    INSERT INTO dbo.cf_product_filter
    (
        ProductId, GroupId, OptionId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT DISTINCT
        v.ProductId,
        fg.Id,
        fo.Id,
        1,
        @Now,
        @SeedBy,
        0
    FROM dbo.cf_product_variant v
    JOIN dbo.cf_product_variant_attribute pva ON pva.VariantId = v.Id
    JOIN dbo.cf_variant_attribute va ON va.Id = pva.AttributeId
    JOIN dbo.cf_variant_attribute_value vav ON vav.Id = pva.AttributeValueId
    JOIN dbo.cf_filter_group fg ON fg.GroupName = va.AttributeName
    JOIN dbo.cf_filter_option fo ON fo.GroupId = fg.Id AND fo.OptionName = vav.ValueName;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
