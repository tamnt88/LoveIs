SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';
    DECLARE @RootCategoryId INT = 4530;
    DECLARE @ProductCount INT = 240;

    IF OBJECT_ID('tempdb..#Cat4529') IS NOT NULL DROP TABLE #Cat4529;
    ;WITH CatTree AS (
        SELECT Id, ParentId, 0 AS Depth
        FROM dbo.cf_category
        WHERE Id = @RootCategoryId
        UNION ALL
        SELECT c.Id, c.ParentId, p.Depth + 1
        FROM dbo.cf_category c
        JOIN CatTree p ON c.ParentId = p.Id
    )
    SELECT Id, ParentId, Depth
    INTO #Cat4529
    FROM CatTree
    WHERE Depth > 0;

    IF NOT EXISTS (SELECT 1 FROM #Cat4529)
    BEGIN
        THROW 50001, N'Không tìm thấy danh mục con/cha cho Id 4530.', 1;
    END

    IF OBJECT_ID('tempdb..#TargetCats') IS NOT NULL DROP TABLE #TargetCats;
    SELECT Id AS CategoryId,
           ROW_NUMBER() OVER (ORDER BY Depth, Id) AS RowNum
    INTO #TargetCats
    FROM #Cat4529;

    DECLARE @CatCount INT = (SELECT COUNT(1) FROM #TargetCats);
    DECLARE @BaseCount INT = @ProductCount / @CatCount;
    DECLARE @Remainder INT = @ProductCount % @CatCount;

    ALTER TABLE #TargetCats ADD TargetCount INT NOT NULL DEFAULT (0);

    UPDATE t
    SET TargetCount = @BaseCount + CASE WHEN t.RowNum <= @Remainder THEN 1 ELSE 0 END
    FROM #TargetCats t;

    IF OBJECT_ID('tempdb..#PlannedProducts') IS NOT NULL DROP TABLE #PlannedProducts;
    CREATE TABLE #PlannedProducts (
        RowId INT IDENTITY(1,1) NOT NULL,
        CategoryId INT NOT NULL
    );

    ;WITH N AS (
        SELECT TOP (1000)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO #PlannedProducts (CategoryId)
    SELECT t.CategoryId
    FROM #TargetCats t
    JOIN N ON N.n <= t.TargetCount;

    IF OBJECT_ID('tempdb..#NamePrefix') IS NOT NULL DROP TABLE #NamePrefix;
    CREATE TABLE #NamePrefix (Value NVARCHAR(100) NOT NULL);
    INSERT INTO #NamePrefix (Value)
    VALUES
        (N'Basic'),
        (N'Thanh lịch'),
        (N'Trẻ trung'),
        (N'Nhẹ nhàng'),
        (N'Năng động'),
        (N'Cá tính'),
        (N'Tối giản'),
        (N'Tiêu chuẩn');

    IF OBJECT_ID('tempdb..#NameSuffix') IS NOT NULL DROP TABLE #NameSuffix;
    CREATE TABLE #NameSuffix (Value NVARCHAR(100) NOT NULL);
    INSERT INTO #NameSuffix (Value)
    VALUES
        (N'Form chuẩn'),
        (N'Chất liệu mềm'),
        (N'Dáng đẹp'),
        (N'Dễ phối'),
        (N'Mặc hàng ngày'),
        (N'Đi chơi'),
        (N'Công sở'),
        (N'Dạo phố');

    DECLARE @AttrSize INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE SortOrder = 1 AND Status = 1);
    DECLARE @AttrColor INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE SortOrder = 2 AND Status = 1);
    DECLARE @AttrMaterial INT = (SELECT TOP 1 Id FROM dbo.cf_variant_attribute WHERE SortOrder = 3 AND Status = 1);

    DECLARE @GroupSize INT = (SELECT TOP 1 Id FROM dbo.cf_filter_group WHERE SortOrder = 1 AND Status = 1);
    DECLARE @GroupColor INT = (SELECT TOP 1 Id FROM dbo.cf_filter_group WHERE SortOrder = 2 AND Status = 1);
    DECLARE @GroupMaterial INT = (SELECT TOP 1 Id FROM dbo.cf_filter_group WHERE SortOrder = 3 AND Status = 1);

    IF @AttrSize IS NULL OR @AttrColor IS NULL OR @AttrMaterial IS NULL
        THROW 50002, N'Không tìm thấy bộ thuộc tính Kích cỡ/Màu sắc/Chất liệu.', 1;

    IF @GroupSize IS NULL OR @GroupColor IS NULL OR @GroupMaterial IS NULL
        THROW 50003, N'Không tìm thấy nhóm filter Kích cỡ/Màu sắc/Chất liệu.', 1;

    IF OBJECT_ID('tempdb..#NewProducts') IS NOT NULL DROP TABLE #NewProducts;
    CREATE TABLE #NewProducts (Id INT NOT NULL, CategoryId INT NOT NULL);

    INSERT INTO dbo.cf_product
    (
        ProductName, CategoryId, BrandId, OriginId, ShopId,
        ShortDescription, Description, Specification, Ingredients, Usage,
        Status, CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.CategoryId INTO #NewProducts (Id, CategoryId)
    SELECT
        c.CategoryName + N' ' + pfx.Value + N' ' + sfx.Value + N' ' + RIGHT(N'0000' + CAST(p.RowId AS NVARCHAR(10)), 4),
        p.CategoryId,
        b.Id,
        o.Id,
        s.Id,
        N'Thiết kế hiện đại, chất liệu dễ chịu.',
        N'Mô tả sản phẩm thời trang nữ đang được cập nhật.',
        N'Thông số sản phẩm đang được cập nhật.',
        N'Thành phần chất liệu theo thuộc tính.',
        N'Hướng dẫn bảo quản đang được cập nhật.',
        1,
        DATEADD(MINUTE, -p.RowId, @Now),
        @SeedBy,
        p.RowId
    FROM #PlannedProducts p
    JOIN dbo.cf_category c ON c.Id = p.CategoryId
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_brand WHERE Status = 1 ORDER BY CHECKSUM(NEWID(), p.RowId)) b
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_origin WHERE Status = 1 ORDER BY CHECKSUM(NEWID(), p.RowId)) o
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_shop WHERE Status = N'Active' ORDER BY CHECKSUM(NEWID(), p.RowId)) s
    OUTER APPLY (SELECT TOP 1 Value FROM #NamePrefix ORDER BY CHECKSUM(NEWID(), p.RowId)) pfx
    OUTER APPLY (SELECT TOP 1 Value FROM #NameSuffix ORDER BY CHECKSUM(NEWID(), p.RowId)) sfx;

    IF OBJECT_ID('tempdb..#CategoryRoot') IS NOT NULL DROP TABLE #CategoryRoot;
    ;WITH C AS (
        SELECT Id, ParentId, Id AS RootId
        FROM dbo.cf_category
        WHERE ParentId IS NULL
        UNION ALL
        SELECT c.Id, c.ParentId, p.RootId
        FROM dbo.cf_category c
        JOIN C p ON c.ParentId = p.Id
    )
    SELECT Id AS CategoryId, RootId
    INTO #CategoryRoot
    FROM C;

    IF OBJECT_ID('tempdb..#ProductAttrConfig') IS NOT NULL DROP TABLE #ProductAttrConfig;
    CREATE TABLE #ProductAttrConfig (
        ProductId INT NOT NULL PRIMARY KEY,
        SizeCount INT NOT NULL,
        ColorCount INT NOT NULL,
        MaterialCount INT NOT NULL,
        IncludeMaterial BIT NOT NULL
    );

    INSERT INTO #ProductAttrConfig (ProductId, SizeCount, ColorCount, MaterialCount, IncludeMaterial)
    SELECT
        p.Id,
        2 + (ABS(CHECKSUM(NEWID())) % 3),
        2 + (ABS(CHECKSUM(NEWID())) % 3),
        2 + (ABS(CHECKSUM(NEWID())) % 3),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 1 ELSE 0 END
    FROM #NewProducts p;

    IF OBJECT_ID('tempdb..#SizeChoices') IS NOT NULL DROP TABLE #SizeChoices;
    SELECT p.ProductId, v.Id AS ValueId,
           ROW_NUMBER() OVER (PARTITION BY p.ProductId ORDER BY NEWID()) AS Seq
    INTO #SizeChoices
    FROM #ProductAttrConfig p
    CROSS JOIN dbo.cf_variant_attribute_value v
    WHERE v.AttributeId = @AttrSize;

    IF OBJECT_ID('tempdb..#ColorChoices') IS NOT NULL DROP TABLE #ColorChoices;
    SELECT p.ProductId, v.Id AS ValueId,
           ROW_NUMBER() OVER (PARTITION BY p.ProductId ORDER BY NEWID()) AS Seq
    INTO #ColorChoices
    FROM #ProductAttrConfig p
    CROSS JOIN dbo.cf_variant_attribute_value v
    WHERE v.AttributeId = @AttrColor;

    IF OBJECT_ID('tempdb..#MaterialChoices') IS NOT NULL DROP TABLE #MaterialChoices;
    SELECT p.ProductId, v.Id AS ValueId,
           ROW_NUMBER() OVER (PARTITION BY p.ProductId ORDER BY NEWID()) AS Seq
    INTO #MaterialChoices
    FROM #ProductAttrConfig p
    CROSS JOIN dbo.cf_variant_attribute_value v
    WHERE v.AttributeId = @AttrMaterial;

    IF OBJECT_ID('tempdb..#VariantPlan') IS NOT NULL DROP TABLE #VariantPlan;
    CREATE TABLE #VariantPlan (
        ProductId INT NOT NULL,
        VariantIndex INT NOT NULL,
        SizeValueId INT NOT NULL,
        ColorValueId INT NOT NULL,
        MaterialValueId INT NULL
    );

    ;WITH VariantNumbers AS (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    ),
    VariantCount AS (
        SELECT ProductId,
               CASE
                   WHEN IncludeMaterial = 1 THEN (SELECT MAX(v) FROM (VALUES (SizeCount),(ColorCount),(MaterialCount)) x(v))
                   ELSE (SELECT MAX(v) FROM (VALUES (SizeCount),(ColorCount)) x(v))
               END AS VariantCount
        FROM #ProductAttrConfig
    )
    INSERT INTO #VariantPlan (ProductId, VariantIndex, SizeValueId, ColorValueId, MaterialValueId)
    SELECT
        p.ProductId,
        v.n,
        sz.ValueId,
        cl.ValueId,
        CASE WHEN p.IncludeMaterial = 1 THEN mt.ValueId ELSE NULL END
    FROM #ProductAttrConfig p
    JOIN VariantCount vc ON vc.ProductId = p.ProductId
    JOIN VariantNumbers v ON v.n <= vc.VariantCount
    JOIN #SizeChoices sz ON sz.ProductId = p.ProductId AND sz.Seq = ((v.n - 1) % p.SizeCount) + 1
    JOIN #ColorChoices cl ON cl.ProductId = p.ProductId AND cl.Seq = ((v.n - 1) % p.ColorCount) + 1
    LEFT JOIN #MaterialChoices mt ON mt.ProductId = p.ProductId AND mt.Seq = ((v.n - 1) % p.MaterialCount) + 1;

    IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
    CREATE TABLE #NewVariants (
        VariantId INT NOT NULL,
        ProductId INT NOT NULL,
        VariantIndex INT NOT NULL,
        SizeValueId INT NULL,
        ColorValueId INT NULL,
        MaterialValueId INT NULL
    );

    INSERT INTO dbo.cf_product_variant
    (
        ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
        CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.ProductId, inserted.SortOrder
    INTO #NewVariants (VariantId, ProductId, VariantIndex)
    SELECT
        vp.ProductId,
        N'Phiên bản ' + CAST(vp.VariantIndex AS NVARCHAR(10)),
        N'LI-' + CAST(vp.ProductId AS NVARCHAR(10)) + N'-' + RIGHT(N'0' + CAST(vp.VariantIndex AS NVARCHAR(10)), 2),
        CAST(ROUND(180000 + (ABS(CHECKSUM(NEWID())) % 650000), 0) AS DECIMAL(18,2)),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
             THEN CAST(ROUND(150000 + (ABS(CHECKSUM(NEWID())) % 450000), 0) AS DECIMAL(18,2))
             ELSE NULL END,
        20 + (ABS(CHECKSUM(NEWID())) % 200),
        1,
        DATEADD(MINUTE, -vp.ProductId, @Now),
        @SeedBy,
        vp.VariantIndex
    FROM #VariantPlan vp;

    UPDATE v
    SET
        v.SizeValueId = vp.SizeValueId,
        v.ColorValueId = vp.ColorValueId,
        v.MaterialValueId = vp.MaterialValueId
    FROM #NewVariants v
    JOIN #VariantPlan vp
        ON vp.ProductId = v.ProductId
        AND vp.VariantIndex = v.VariantIndex;

    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT VariantId, @AttrSize, SizeValueId, 1, @Now, @SeedBy, 1
    FROM #NewVariants
    UNION ALL
    SELECT VariantId, @AttrColor, ColorValueId, 1, @Now, @SeedBy, 2
    FROM #NewVariants
    UNION ALL
    SELECT VariantId, @AttrMaterial, MaterialValueId, 1, @Now, @SeedBy, 3
    FROM #NewVariants
    WHERE MaterialValueId IS NOT NULL;

    ;WITH ImageNumbers AS (
        SELECT v.Number
        FROM (VALUES
            (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
            (11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
            (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
            (31),(32),(33),(34),(35),(36),(37),(38),(39),(40)
        ) v(Number)
    )
    INSERT INTO dbo.cf_product_image
    (
        ProductId, VariantId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        p.Id,
        NULL,
        N'/upload/products/images/4530/' + CAST(n.Number AS NVARCHAR(10)) + N'.webp',
        CASE WHEN n.rn = 1 THEN 1 ELSE 0 END,
        N'Sản phẩm ' + CAST(p.Id AS NVARCHAR(10)),
        1,
        @Now,
        @SeedBy,
        n.rn
    FROM #NewProducts p
    CROSS APPLY (
        SELECT TOP 3 Number, ROW_NUMBER() OVER (ORDER BY CHECKSUM(NEWID(), p.Id)) AS rn
        FROM ImageNumbers
        ORDER BY CHECKSUM(NEWID(), p.Id)
    ) n;

    INSERT INTO dbo.cf_product_filter
    (
        ProductId, GroupId, OptionId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        v.ProductId,
        fg.Id,
        fo.Id,
        1,
        @Now,
        @SeedBy,
        0
    FROM #NewVariants v
    JOIN dbo.cf_product_variant_attribute pva ON pva.VariantId = v.VariantId
    JOIN dbo.cf_variant_attribute va ON va.Id = pva.AttributeId
    JOIN dbo.cf_variant_attribute_value vav ON vav.Id = pva.AttributeValueId
    JOIN dbo.cf_filter_group fg ON fg.GroupName = va.AttributeName
    JOIN dbo.cf_filter_option fo ON fo.GroupId = fg.Id AND fo.OptionName = vav.ValueName;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Product', p.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), pr.ProductName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(p.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM #NewProducts p
    JOIN dbo.cf_product pr ON pr.Id = p.Id;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;

