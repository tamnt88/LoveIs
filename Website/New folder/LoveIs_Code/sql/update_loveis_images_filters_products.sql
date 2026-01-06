SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    DELETE FROM dbo.cf_product_filter;
    DELETE FROM dbo.cf_product_variant_attribute;
    DELETE FROM dbo.cf_category_filter_group;

    ;WITH CategoryContext AS (
        SELECT c.Id AS CategoryId,
               c.CategoryName,
               p.CategoryName AS ParentName,
               gp.CategoryName AS GrandName
        FROM dbo.cf_category c
        LEFT JOIN dbo.cf_category p ON p.Id = c.ParentId
        LEFT JOIN dbo.cf_category gp ON gp.Id = p.ParentId
        WHERE c.ParentId IS NOT NULL
    ),
    AllowedGroups AS (
        SELECT cc.CategoryId,
               fg.Id AS GroupId
        FROM CategoryContext cc
        JOIN dbo.cf_filter_group fg ON fg.Status = 1
        WHERE fg.GroupName IN (N'Kích cỡ', N'Màu sắc', N'Chất liệu', N'Kiểu dáng')

        UNION ALL

        SELECT cc.CategoryId,
               fg.Id AS GroupId
        FROM CategoryContext cc
        JOIN dbo.cf_filter_group fg ON fg.GroupName = N'Cúp'
        WHERE cc.CategoryName LIKE N'%Áo ngực%'
           OR cc.CategoryName LIKE N'%Bralette%'
           OR cc.CategoryName LIKE N'%Bra%'
           OR cc.CategoryName LIKE N'%Bộ đồ lót%'
           OR cc.ParentName LIKE N'%Áo ngực%'
           OR cc.ParentName LIKE N'%Bralette%'
           OR cc.ParentName LIKE N'%Bra%'
           OR cc.ParentName LIKE N'%Bộ đồ lót%'
           OR cc.GrandName LIKE N'%Áo ngực%'
           OR cc.GrandName LIKE N'%Bralette%'
           OR cc.GrandName LIKE N'%Bra%'
           OR cc.GrandName LIKE N'%Bộ đồ lót%'
    )
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT DISTINCT ag.CategoryId,
           ag.GroupId,
           1,
           @Now,
           @SeedBy,
           0
    FROM AllowedGroups ag;

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
    AllowedCount AS (
        SELECT VariantId, COUNT(*) AS Cnt
        FROM AllowedAttr
        GROUP BY VariantId
    ),
    PickedAttr AS (
        SELECT c.VariantId,
               p.AttributeId,
               ROW_NUMBER() OVER (PARTITION BY c.VariantId ORDER BY NEWID()) AS SortOrder
        FROM AllowedCount c
        CROSS APPLY (
            SELECT TOP (CASE WHEN c.Cnt < 1 THEN 0 ELSE 1 + ABS(CHECKSUM(NEWID())) % c.Cnt END)
                a.AttributeId
            FROM AllowedAttr a
            WHERE a.VariantId = c.VariantId
            ORDER BY NEWID()
        ) p
    )
    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT p.VariantId,
           p.AttributeId,
           vav.Id,
           1,
           @Now,
           @SeedBy,
           p.SortOrder
    FROM PickedAttr p
    CROSS APPLY (
        SELECT TOP 1 Id
        FROM dbo.cf_variant_attribute_value
        WHERE AttributeId = p.AttributeId
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

    DELETE FROM dbo.cf_product_image;

    DECLARE @Images TABLE (ImageUrl NVARCHAR(300) NOT NULL);
    ;WITH N AS (
        SELECT TOP (240) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO @Images (ImageUrl)
    SELECT N'/upload/products/images/seed-real-' + RIGHT(N'000' + CAST(n AS NVARCHAR(3)), 3) + N'.jpg'
    FROM N;

    INSERT INTO dbo.cf_product_image
    (
        ProductId, VariantId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        p.Id,
        NULL,
        img.ImageUrl,
        CASE WHEN img.SortOrder = 1 THEN 1 ELSE 0 END,
        N'Sản phẩm ' + CAST(p.Id AS NVARCHAR(10)),
        1,
        @Now,
        @SeedBy,
        img.SortOrder
    FROM dbo.cf_product p
    CROSS APPLY (
        SELECT TOP 4
            ImageUrl,
            ROW_NUMBER() OVER (ORDER BY NEWID()) AS SortOrder
        FROM @Images
        ORDER BY NEWID()
    ) img;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
