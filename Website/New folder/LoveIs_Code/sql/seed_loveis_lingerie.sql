SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DELETE FROM dbo.cf_brand_showcase_banner;
    DELETE FROM dbo.cf_brand_showcase;
    DELETE FROM dbo.cf_product_filter;
    DELETE FROM dbo.cf_category_filter_group;
    DELETE FROM dbo.cf_filter_option;
    DELETE FROM dbo.cf_filter_group;
    DELETE FROM dbo.cf_product_variant_attribute;
    DELETE FROM dbo.cf_product_image;
    DELETE FROM dbo.cf_product_variant;
    DELETE FROM dbo.cf_product;
    DELETE FROM dbo.cf_variant_attribute_value;
    DELETE FROM dbo.cf_variant_attribute;
    DELETE FROM dbo.cf_brand;
    DELETE FROM dbo.cf_origin;
    DELETE FROM dbo.cf_category;

    DELETE FROM dbo.cf_seo_slug
    WHERE EntityType IN (N'Category', N'Brand', N'Origin', N'Product');

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    DECLARE @CatWomen INT;
    DECLARE @CatMen INT;
    DECLARE @CatAccessories INT;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Do lot nu', NULL, 1, @Now, @SeedBy, 1);
    SET @CatWomen = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Do lot nam', NULL, 1, @Now, @SeedBy, 2);
    SET @CatMen = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Phu kien', NULL, 1, @Now, @SeedBy, 3);
    SET @CatAccessories = SCOPE_IDENTITY();

    DECLARE @CatBra INT;
    DECLARE @CatPanty INT;
    DECLARE @CatSet INT;
    DECLARE @CatShapewear INT;
    DECLARE @CatSleepwear INT;
    DECLARE @CatBoxer INT;
    DECLARE @CatBrief INT;
    DECLARE @CatStrap INT;
    DECLARE @CatNipple INT;
    DECLARE @CatLaundry INT;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bra', @CatWomen, 1, @Now, @SeedBy, 1);
    SET @CatBra = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Panty', @CatWomen, 1, @Now, @SeedBy, 2);
    SET @CatPanty = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set', @CatWomen, 1, @Now, @SeedBy, 3);
    SET @CatSet = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Shapewear', @CatWomen, 1, @Now, @SeedBy, 4);
    SET @CatShapewear = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sleepwear', @CatWomen, 1, @Now, @SeedBy, 5);
    SET @CatSleepwear = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Boxer', @CatMen, 1, @Now, @SeedBy, 1);
    SET @CatBoxer = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Brief', @CatMen, 1, @Now, @SeedBy, 2);
    SET @CatBrief = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Day ao', @CatAccessories, 1, @Now, @SeedBy, 1);
    SET @CatStrap = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mi dan nguc', @CatAccessories, 1, @Now, @SeedBy, 2);
    SET @CatNipple = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vot giat do lot', @CatAccessories, 1, @Now, @SeedBy, 3);
    SET @CatLaundry = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_brand (BrandName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'LoveIs', 1, @Now, @SeedBy, 1),
        (N'Silkvibe', 1, @Now, @SeedBy, 2),
        (N'NoirLine', 1, @Now, @SeedBy, 3),
        (N'Cloudsoft', 1, @Now, @SeedBy, 4),
        (N'Contourix', 1, @Now, @SeedBy, 5),
        (N'GentleManor', 1, @Now, @SeedBy, 6);

    INSERT INTO dbo.cf_origin (OriginName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Vietnam', 1, @Now, @SeedBy, 1),
        (N'China', 1, @Now, @SeedBy, 2),
        (N'Thailand', 1, @Now, @SeedBy, 3),
        (N'Japan', 1, @Now, @SeedBy, 4),
        (N'Korea', 1, @Now, @SeedBy, 5),
        (N'France', 1, @Now, @SeedBy, 6);

    DECLARE @AttrSize INT;
    DECLARE @AttrCup INT;
    DECLARE @AttrColor INT;
    DECLARE @AttrMaterial INT;
    DECLARE @AttrStyle INT;

    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Size', N'Product size', 1, @Now, @SeedBy, 1),
        (N'Cup', N'Bra cup size', 1, @Now, @SeedBy, 2),
        (N'Color', N'Color', 1, @Now, @SeedBy, 3),
        (N'Material', N'Material', 1, @Now, @SeedBy, 4),
        (N'Style', N'Style', 1, @Now, @SeedBy, 5);

    SELECT @AttrSize = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Size';
    SELECT @AttrCup = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Cup';
    SELECT @AttrColor = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Color';
    SELECT @AttrMaterial = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Material';
    SELECT @AttrStyle = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Style';

    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@AttrSize, N'XS', 1, @Now, @SeedBy, 1),
        (@AttrSize, N'S', 1, @Now, @SeedBy, 2),
        (@AttrSize, N'M', 1, @Now, @SeedBy, 3),
        (@AttrSize, N'L', 1, @Now, @SeedBy, 4),
        (@AttrSize, N'XL', 1, @Now, @SeedBy, 5),
        (@AttrSize, N'XXL', 1, @Now, @SeedBy, 6),
        (@AttrCup, N'A', 1, @Now, @SeedBy, 1),
        (@AttrCup, N'B', 1, @Now, @SeedBy, 2),
        (@AttrCup, N'C', 1, @Now, @SeedBy, 3),
        (@AttrCup, N'D', 1, @Now, @SeedBy, 4),
        (@AttrCup, N'DD', 1, @Now, @SeedBy, 5),
        (@AttrCup, N'E', 1, @Now, @SeedBy, 6),
        (@AttrColor, N'Black', 1, @Now, @SeedBy, 1),
        (@AttrColor, N'White', 1, @Now, @SeedBy, 2),
        (@AttrColor, N'Nude', 1, @Now, @SeedBy, 3),
        (@AttrColor, N'Red', 1, @Now, @SeedBy, 4),
        (@AttrColor, N'Pink', 1, @Now, @SeedBy, 5),
        (@AttrColor, N'Blue', 1, @Now, @SeedBy, 6),
        (@AttrColor, N'Green', 1, @Now, @SeedBy, 7),
        (@AttrColor, N'Purple', 1, @Now, @SeedBy, 8),
        (@AttrColor, N'Beige', 1, @Now, @SeedBy, 9),
        (@AttrColor, N'Brown', 1, @Now, @SeedBy, 10),
        (@AttrMaterial, N'Cotton', 1, @Now, @SeedBy, 1),
        (@AttrMaterial, N'Lace', 1, @Now, @SeedBy, 2),
        (@AttrMaterial, N'Silk', 1, @Now, @SeedBy, 3),
        (@AttrMaterial, N'Satin', 1, @Now, @SeedBy, 4),
        (@AttrMaterial, N'Microfiber', 1, @Now, @SeedBy, 5),
        (@AttrMaterial, N'Mesh', 1, @Now, @SeedBy, 6),
        (@AttrStyle, N'Bralette', 1, @Now, @SeedBy, 1),
        (@AttrStyle, N'Push-up', 1, @Now, @SeedBy, 2),
        (@AttrStyle, N'Balcony', 1, @Now, @SeedBy, 3),
        (@AttrStyle, N'Full-coverage', 1, @Now, @SeedBy, 4),
        (@AttrStyle, N'Seamless', 1, @Now, @SeedBy, 5),
        (@AttrStyle, N'High-waist', 1, @Now, @SeedBy, 6),
        (@AttrStyle, N'Thong', 1, @Now, @SeedBy, 7),
        (@AttrStyle, N'Brief', 1, @Now, @SeedBy, 8),
        (@AttrStyle, N'Boxer', 1, @Now, @SeedBy, 9),
        (@AttrStyle, N'Bikini', 1, @Now, @SeedBy, 10),
        (@AttrStyle, N'Boyshort', 1, @Now, @SeedBy, 11),
        (@AttrStyle, N'G-string', 1, @Now, @SeedBy, 12),
        (@AttrStyle, N'Sleep-dress', 1, @Now, @SeedBy, 13),
        (@AttrStyle, N'Bodysuit', 1, @Now, @SeedBy, 14),
        (@AttrStyle, N'Corset', 1, @Now, @SeedBy, 15);

    DECLARE @GroupSize INT;
    DECLARE @GroupCup INT;
    DECLARE @GroupColor INT;
    DECLARE @GroupMaterial INT;
    DECLARE @GroupStyle INT;

    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Size', N'Size filter', 1, @Now, @SeedBy, 1),
        (N'Cup', N'Cup filter', 1, @Now, @SeedBy, 2),
        (N'Color', N'Color filter', 1, @Now, @SeedBy, 3),
        (N'Material', N'Material filter', 1, @Now, @SeedBy, 4),
        (N'Style', N'Style filter', 1, @Now, @SeedBy, 5);

    SELECT @GroupSize = Id FROM dbo.cf_filter_group WHERE GroupName = N'Size';
    SELECT @GroupCup = Id FROM dbo.cf_filter_group WHERE GroupName = N'Cup';
    SELECT @GroupColor = Id FROM dbo.cf_filter_group WHERE GroupName = N'Color';
    SELECT @GroupMaterial = Id FROM dbo.cf_filter_group WHERE GroupName = N'Material';
    SELECT @GroupStyle = Id FROM dbo.cf_filter_group WHERE GroupName = N'Style';

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupSize, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrSize;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupCup, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrCup;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupColor, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrColor;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupMaterial, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrMaterial;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupStyle, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrStyle;

    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@CatBra, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatBra, @GroupCup, 1, @Now, @SeedBy, 2),
        (@CatBra, @GroupColor, 1, @Now, @SeedBy, 3),
        (@CatBra, @GroupMaterial, 1, @Now, @SeedBy, 4),
        (@CatBra, @GroupStyle, 1, @Now, @SeedBy, 5),
        (@CatPanty, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatPanty, @GroupColor, 1, @Now, @SeedBy, 2),
        (@CatPanty, @GroupMaterial, 1, @Now, @SeedBy, 3),
        (@CatPanty, @GroupStyle, 1, @Now, @SeedBy, 4),
        (@CatSet, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatSet, @GroupCup, 1, @Now, @SeedBy, 2),
        (@CatSet, @GroupColor, 1, @Now, @SeedBy, 3),
        (@CatSet, @GroupMaterial, 1, @Now, @SeedBy, 4),
        (@CatSet, @GroupStyle, 1, @Now, @SeedBy, 5),
        (@CatShapewear, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatShapewear, @GroupColor, 1, @Now, @SeedBy, 2),
        (@CatShapewear, @GroupMaterial, 1, @Now, @SeedBy, 3),
        (@CatShapewear, @GroupStyle, 1, @Now, @SeedBy, 4),
        (@CatSleepwear, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatSleepwear, @GroupColor, 1, @Now, @SeedBy, 2),
        (@CatSleepwear, @GroupMaterial, 1, @Now, @SeedBy, 3),
        (@CatSleepwear, @GroupStyle, 1, @Now, @SeedBy, 4),
        (@CatBoxer, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatBoxer, @GroupColor, 1, @Now, @SeedBy, 2),
        (@CatBoxer, @GroupMaterial, 1, @Now, @SeedBy, 3),
        (@CatBoxer, @GroupStyle, 1, @Now, @SeedBy, 4),
        (@CatBrief, @GroupSize, 1, @Now, @SeedBy, 1),
        (@CatBrief, @GroupColor, 1, @Now, @SeedBy, 2),
        (@CatBrief, @GroupMaterial, 1, @Now, @SeedBy, 3),
        (@CatBrief, @GroupStyle, 1, @Now, @SeedBy, 4),
        (@CatStrap, @GroupColor, 1, @Now, @SeedBy, 1),
        (@CatStrap, @GroupMaterial, 1, @Now, @SeedBy, 2),
        (@CatStrap, @GroupStyle, 1, @Now, @SeedBy, 3),
        (@CatNipple, @GroupColor, 1, @Now, @SeedBy, 1),
        (@CatNipple, @GroupMaterial, 1, @Now, @SeedBy, 2),
        (@CatNipple, @GroupStyle, 1, @Now, @SeedBy, 3),
        (@CatLaundry, @GroupMaterial, 1, @Now, @SeedBy, 1),
        (@CatLaundry, @GroupStyle, 1, @Now, @SeedBy, 2);

    IF OBJECT_ID('tempdb..#NewProducts') IS NOT NULL DROP TABLE #NewProducts;
    CREATE TABLE #NewProducts (Id INT NOT NULL, CategoryId INT NOT NULL);

    ;WITH N AS (
        SELECT TOP (3000)
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
        c.CategoryName + N' ' + RIGHT(N'0000' + CAST(n AS NVARCHAR(10)), 4),
        c.Id,
        b.Id,
        o.Id,
        N'Lingerie designed for comfort and confidence.',
        N'Detailed description is being updated.',
        N'Specifications are being updated.',
        N'Materials are listed in attributes.',
        N'Care instructions are being updated.',
        1,
        DATEADD(MINUTE, -n, @Now),
        @SeedBy,
        n
    FROM N
    CROSS APPLY (
        SELECT TOP 1 Id, CategoryName FROM dbo.cf_category
        WHERE ParentId IS NOT NULL AND Status = 1
        ORDER BY NEWID()
    ) c
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_brand WHERE Status = 1 ORDER BY NEWID()) b
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_origin WHERE Status = 1 ORDER BY NEWID()) o;

    IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
    CREATE TABLE #NewVariants (VariantId INT NOT NULL, ProductId INT NOT NULL);

    INSERT INTO dbo.cf_product_variant
    (
        ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
        CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.ProductId INTO #NewVariants (VariantId, ProductId)
    SELECT
        p.Id,
        N'Standard',
        N'LI-' + CAST(p.Id AS NVARCHAR(10)) + N'-01',
        CAST(ROUND(150000 + (ABS(CHECKSUM(NEWID())) % 650000), 0) AS DECIMAL(18,2)),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
             THEN CAST(ROUND(120000 + (ABS(CHECKSUM(NEWID())) % 450000), 0) AS DECIMAL(18,2))
             ELSE NULL END,
        20 + (ABS(CHECKSUM(NEWID())) % 200),
        1,
        DATEADD(MINUTE, -p.Id, @Now),
        @SeedBy,
        1
    FROM #NewProducts p;

    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT v.VariantId, x.AttributeId, x.AttributeValueId, 1, @Now, @SeedBy, x.SortOrder
    FROM #NewVariants v
    CROSS APPLY (
        SELECT @AttrSize AS AttributeId,
               (SELECT TOP 1 Id FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrSize ORDER BY NEWID()) AS AttributeValueId,
               1 AS SortOrder
        UNION ALL
        SELECT @AttrCup AS AttributeId,
               (SELECT TOP 1 Id FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrCup ORDER BY NEWID()) AS AttributeValueId,
               2
        UNION ALL
        SELECT @AttrColor AS AttributeId,
               (SELECT TOP 1 Id FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrColor ORDER BY NEWID()) AS AttributeValueId,
               3
        UNION ALL
        SELECT @AttrMaterial AS AttributeId,
               (SELECT TOP 1 Id FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrMaterial ORDER BY NEWID()) AS AttributeValueId,
               4
        UNION ALL
        SELECT @AttrStyle AS AttributeId,
               (SELECT TOP 1 Id FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrStyle ORDER BY NEWID()) AS AttributeValueId,
               5
    ) x;

    DECLARE @Images TABLE (ImageUrl NVARCHAR(300) NOT NULL);
    INSERT INTO @Images (ImageUrl)
    VALUES
        (N'/upload/products/images/logo_loveis.png');

    INSERT INTO dbo.cf_product_image
    (
        ProductId, VariantId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        p.Id,
        NULL,
        img.ImageUrl,
        1,
        N'Product image ' + CAST(p.Id AS NVARCHAR(10)),
        1,
        @Now,
        @SeedBy,
        1
    FROM #NewProducts p
    CROSS APPLY (SELECT TOP 1 ImageUrl FROM @Images ORDER BY NEWID()) img;

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
    SELECT N'Category', c.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), c.CategoryName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(c.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_category c;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Brand', b.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), b.BrandName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(b.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_brand b;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Origin', o.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), o.OriginName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(o.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_origin o;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Product', p.Id, N'san-pham-' + CAST(p.Id AS NVARCHAR(10)), 1, @Now, @SeedBy, 0
    FROM #NewProducts p;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
