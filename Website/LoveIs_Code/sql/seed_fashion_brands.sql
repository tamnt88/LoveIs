SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    IF OBJECT_ID('dbo.cf_seo_slug', 'U') IS NOT NULL
        DELETE FROM dbo.cf_seo_slug
        WHERE EntityType = N'Brand';

    IF OBJECT_ID('dbo.cf_brand', 'U') IS NOT NULL
        DELETE FROM dbo.cf_brand;

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    INSERT INTO dbo.cf_brand (BrandName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'LoveIs', 1, @Now, @SeedBy, 1),
        (N'Nữ Tính', 1, @Now, @SeedBy, 2),
        (N'Thanh Lịch', 1, @Now, @SeedBy, 3),
        (N'Phong Cách', 1, @Now, @SeedBy, 4),
        (N'Mây Mềm', 1, @Now, @SeedBy, 5),
        (N'Đường Phố', 1, @Now, @SeedBy, 6),
        (N'Ánh Nắng', 1, @Now, @SeedBy, 7),
        (N'Lụa Việt', 1, @Now, @SeedBy, 8);

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Brand', b.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), b.BrandName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and')),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_brand b;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
