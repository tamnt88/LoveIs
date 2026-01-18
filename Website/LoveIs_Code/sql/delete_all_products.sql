SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    IF OBJECT_ID('dbo.cf_product_review', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product_review;

    IF OBJECT_ID('dbo.cf_product_filter', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product_filter;

    IF OBJECT_ID('dbo.cf_product_variant_attribute', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product_variant_attribute;

    IF OBJECT_ID('dbo.cf_product_image', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product_image;

    IF OBJECT_ID('dbo.cf_product_variant', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product_variant;

    IF OBJECT_ID('dbo.cf_product', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product;

    IF OBJECT_ID('dbo.cf_seo_slug', 'U') IS NOT NULL
        DELETE FROM dbo.cf_seo_slug
        WHERE EntityType = N'Product';

    IF OBJECT_ID('dbo.cf_product', 'U') IS NOT NULL
        DBCC CHECKIDENT ('dbo.cf_product', RESEED, 0);
    IF OBJECT_ID('dbo.cf_product_variant', 'U') IS NOT NULL
        DBCC CHECKIDENT ('dbo.cf_product_variant', RESEED, 0);
    IF OBJECT_ID('dbo.cf_product_image', 'U') IS NOT NULL
        DBCC CHECKIDENT ('dbo.cf_product_image', RESEED, 0);
    IF OBJECT_ID('dbo.cf_product_variant_attribute', 'U') IS NOT NULL
        DBCC CHECKIDENT ('dbo.cf_product_variant_attribute', RESEED, 0);
    IF OBJECT_ID('dbo.cf_product_filter', 'U') IS NOT NULL
        DBCC CHECKIDENT ('dbo.cf_product_filter', RESEED, 0);
    IF OBJECT_ID('dbo.cf_product_review', 'U') IS NOT NULL
        DBCC CHECKIDENT ('dbo.cf_product_review', RESEED, 0);

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
