SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    DELETE FROM dbo.cf_product_filter;
    DELETE FROM dbo.cf_product_variant_attribute;
    DELETE FROM dbo.cf_product_variant;

    IF OBJECT_ID('tempdb..#AllowedAttr') IS NOT NULL DROP TABLE #AllowedAttr;
    CREATE TABLE #AllowedAttr (
        ProductId INT NOT NULL,
        AttributeId INT NOT NULL
    );

    IF OBJECT_ID('tempdb..#SelectedAttr') IS NOT NULL DROP TABLE #SelectedAttr;
    CREATE TABLE #SelectedAttr (
        ProductId INT NOT NULL,
        AttributeId INT NOT NULL
    );

    IF OBJECT_ID('tempdb..#AttrRank') IS NOT NULL DROP TABLE #AttrRank;
    CREATE TABLE #AttrRank (
        ProductId INT NOT NULL,
        AttributeId INT NOT NULL,
        AttrRank INT NOT NULL
    );

    IF OBJECT_ID('tempdb..#SelectedValues') IS NOT NULL DROP TABLE #SelectedValues;
    CREATE TABLE #SelectedValues (
        ProductId INT NOT NULL,
        AttributeId INT NOT NULL,
        ValueId INT NOT NULL
    );

    IF OBJECT_ID('tempdb..#Combos') IS NOT NULL DROP TABLE #Combos;
    CREATE TABLE #Combos (
        ProductId INT NOT NULL,
        Val1 INT NOT NULL,
        Val2 INT NOT NULL,
        Val3 INT NULL
    );

    IF OBJECT_ID('tempdb..#ComboRanked') IS NOT NULL DROP TABLE #ComboRanked;
    CREATE TABLE #ComboRanked (
        ProductId INT NOT NULL,
        Val1 INT NOT NULL,
        Val2 INT NOT NULL,
        Val3 INT NULL,
        ComboRank INT NOT NULL
    );

    IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
    CREATE TABLE #NewVariants (
        VariantId INT NOT NULL,
        ProductId INT NOT NULL,
        ComboRank INT NOT NULL
    );

    ;WITH Products AS (
        SELECT p.Id AS ProductId,
               c.CategoryName,
               p2.CategoryName AS ParentName,
               p3.CategoryName AS GrandName
        FROM dbo.cf_product p
        JOIN dbo.cf_category c ON c.Id = p.CategoryId
        LEFT JOIN dbo.cf_category p2 ON p2.Id = c.ParentId
        LEFT JOIN dbo.cf_category p3 ON p3.Id = p2.ParentId
    )
    INSERT INTO #AllowedAttr (ProductId, AttributeId)
    SELECT p.ProductId, va.Id
    FROM Products p
    JOIN dbo.cf_variant_attribute va
        ON va.AttributeName IN (N'Kích cỡ', N'Màu sắc', N'Chất liệu', N'Kiểu dáng')
    WHERE EXISTS (
        SELECT 1 FROM dbo.cf_variant_attribute_value v
        WHERE v.AttributeId = va.Id
        GROUP BY v.AttributeId
        HAVING COUNT(*) >= 2
    )

    UNION ALL

    SELECT p.ProductId, va.Id
    FROM Products p
    JOIN dbo.cf_variant_attribute va ON va.AttributeName = N'Cúp'
    WHERE (
            p.CategoryName LIKE N'%Áo ngực%'
         OR p.CategoryName LIKE N'%Bralette%'
         OR p.CategoryName LIKE N'%Bra%'
         OR p.CategoryName LIKE N'%Bộ đồ lót%'
         OR p.ParentName LIKE N'%Áo ngực%'
         OR p.ParentName LIKE N'%Bralette%'
         OR p.ParentName LIKE N'%Bra%'
         OR p.ParentName LIKE N'%Bộ đồ lót%'
         OR p.GrandName LIKE N'%Áo ngực%'
         OR p.GrandName LIKE N'%Bralette%'
         OR p.GrandName LIKE N'%Bra%'
         OR p.GrandName LIKE N'%Bộ đồ lót%'
        )
      AND EXISTS (
        SELECT 1 FROM dbo.cf_variant_attribute_value v
        WHERE v.AttributeId = va.Id
        GROUP BY v.AttributeId
        HAVING COUNT(*) >= 2
    );

    ;WITH AllowedCount AS (
        SELECT ProductId, COUNT(*) AS Cnt
        FROM #AllowedAttr
        GROUP BY ProductId
    )
    INSERT INTO #SelectedAttr (ProductId, AttributeId)
    SELECT ac.ProductId, a.AttributeId
    FROM AllowedCount ac
    CROSS APPLY (
        SELECT TOP (CASE WHEN ac.Cnt < 2 THEN ac.Cnt ELSE 2 + ABS(CHECKSUM(NEWID())) % 2 END)
            AttributeId
        FROM #AllowedAttr aa
        WHERE aa.ProductId = ac.ProductId
        ORDER BY NEWID()
    ) a;

    INSERT INTO #AttrRank (ProductId, AttributeId, AttrRank)
    SELECT ProductId,
           AttributeId,
           ROW_NUMBER() OVER (PARTITION BY ProductId ORDER BY NEWID()) AS AttrRank
    FROM #SelectedAttr;

    INSERT INTO #SelectedValues (ProductId, AttributeId, ValueId)
    SELECT ar.ProductId,
           ar.AttributeId,
           vav.Id
    FROM #AttrRank ar
    CROSS APPLY (
        SELECT TOP (2 + ABS(CHECKSUM(NEWID())) % 2)
            Id
        FROM dbo.cf_variant_attribute_value v
        WHERE v.AttributeId = ar.AttributeId
        ORDER BY NEWID()
    ) vav;

    ;WITH Attr1 AS (
        SELECT ProductId, AttributeId
        FROM #AttrRank
        WHERE AttrRank = 1
    ),
    Attr2 AS (
        SELECT ProductId, AttributeId
        FROM #AttrRank
        WHERE AttrRank = 2
    ),
    Attr3 AS (
        SELECT ProductId, AttributeId
        FROM #AttrRank
        WHERE AttrRank = 3
    ),
    Val1 AS (
        SELECT ProductId, ValueId
        FROM #SelectedValues sv
        WHERE sv.AttributeId IN (SELECT AttributeId FROM Attr1 WHERE Attr1.ProductId = sv.ProductId)
    ),
    Val2 AS (
        SELECT ProductId, ValueId
        FROM #SelectedValues sv
        WHERE sv.AttributeId IN (SELECT AttributeId FROM Attr2 WHERE Attr2.ProductId = sv.ProductId)
    ),
    Val3 AS (
        SELECT ProductId, ValueId
        FROM #SelectedValues sv
        WHERE sv.AttributeId IN (SELECT AttributeId FROM Attr3 WHERE Attr3.ProductId = sv.ProductId)
    )
    INSERT INTO #Combos (ProductId, Val1, Val2, Val3)
    SELECT a1.ProductId, v1.ValueId, v2.ValueId, v3.ValueId
    FROM Attr1 a1
    JOIN Attr2 a2 ON a2.ProductId = a1.ProductId
    JOIN Val1 v1 ON v1.ProductId = a1.ProductId
    JOIN Val2 v2 ON v2.ProductId = a1.ProductId
    LEFT JOIN Attr3 a3 ON a3.ProductId = a1.ProductId
    LEFT JOIN Val3 v3 ON v3.ProductId = a1.ProductId;

    INSERT INTO #ComboRanked (ProductId, Val1, Val2, Val3, ComboRank)
    SELECT ProductId, Val1, Val2, Val3,
           ROW_NUMBER() OVER (PARTITION BY ProductId ORDER BY NEWID()) AS ComboRank
    FROM #Combos;

    INSERT INTO dbo.cf_product_variant
    (
        ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
        CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.ProductId, inserted.SortOrder
        INTO #NewVariants (VariantId, ProductId, ComboRank)
    SELECT
        src.ProductId,
        N'Biến thể ' + CAST(src.ComboRank AS NVARCHAR(10)),
        N'LI-' + CAST(src.ProductId AS NVARCHAR(10)) + N'-' + RIGHT(N'00' + CAST(src.ComboRank AS NVARCHAR(10)), 2),
        CAST(ROUND(150000 + (ABS(CHECKSUM(NEWID())) % 650000), 0) AS DECIMAL(18,2)),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
             THEN CAST(ROUND(120000 + (ABS(CHECKSUM(NEWID())) % 450000), 0) AS DECIMAL(18,2))
             ELSE NULL END,
        20 + (ABS(CHECKSUM(NEWID())) % 200),
        1,
        DATEADD(MINUTE, -src.ProductId, @Now),
        @SeedBy,
        src.ComboRank
    FROM (
        SELECT ProductId, Val1, Val2, Val3, ComboRank
        FROM #ComboRanked
        WHERE ComboRank <= 9
    ) src;

    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT nv.VariantId,
           ar.AttributeId,
           CASE ar.AttrRank
                WHEN 1 THEN cr.Val1
                WHEN 2 THEN cr.Val2
                WHEN 3 THEN cr.Val3
           END AS AttributeValueId,
           1,
           @Now,
           @SeedBy,
           ar.AttrRank
    FROM #NewVariants nv
    JOIN #ComboRanked cr
        ON cr.ProductId = nv.ProductId AND cr.ComboRank = nv.ComboRank
    JOIN #AttrRank ar
        ON ar.ProductId = nv.ProductId
    WHERE ar.AttrRank IN (1,2,3)
      AND (ar.AttrRank <> 3 OR cr.Val3 IS NOT NULL);

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
