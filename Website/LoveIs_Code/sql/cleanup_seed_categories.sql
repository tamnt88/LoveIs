SET NOCOUNT ON;

DECLARE @SeedProducts TABLE (Id INT PRIMARY KEY);
INSERT INTO @SeedProducts (Id)
SELECT Id
FROM dbo.cf_product
WHERE CreatedBy = N'Seed';

DELETE FROM dbo.cf_product_filter
WHERE ProductId IN (SELECT Id FROM @SeedProducts);

DELETE FROM dbo.cf_product_image
WHERE ProductId IN (SELECT Id FROM @SeedProducts);

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

DELETE FROM dbo.cf_product
WHERE Id IN (SELECT Id FROM @SeedProducts);

DECLARE @SeedCategories TABLE (Id INT PRIMARY KEY);
INSERT INTO @SeedCategories (Id)
SELECT Id
FROM dbo.cf_category
WHERE CreatedBy = N'Seed' AND ParentId IS NOT NULL;

DELETE FROM dbo.cf_category_filter_group
WHERE CategoryId IN (SELECT Id FROM @SeedCategories);

DELETE FROM dbo.cf_seo_slug
WHERE EntityType = N'Category' AND EntityId IN (SELECT Id FROM @SeedCategories);

DELETE FROM dbo.cf_category
WHERE Id IN (SELECT Id FROM @SeedCategories);
