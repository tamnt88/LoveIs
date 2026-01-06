SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    ;WITH Level3Targets AS (
        SELECT c.Id, c.CategoryName
        FROM dbo.cf_category c
        WHERE c.ParentId IN (SELECT Id FROM dbo.cf_category WHERE ParentId IS NULL)
    )
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT
        CASE c.CategoryName
            WHEN N'Áo ngực' THEN N'Áo ngực demi'
            WHEN N'Bralette' THEN N'Bralette ren'
            WHEN N'Quần lót nữ' THEN N'Quần lót thun lạnh'
            WHEN N'Bộ đồ lót' THEN N'Bộ đồ lót ren'
            WHEN N'Thong/G-String' THEN N'Thong dây mảnh'
            WHEN N'Không đường may' THEN N'Quần lót seamless'
            WHEN N'Áo ngực thể thao' THEN N'Áo ngực thể thao nâng đỡ'
            WHEN N'Áo ngực đặc biệt' THEN N'Áo ngực không dây'
            WHEN N'Boxer nam' THEN N'Boxer cotton'
            WHEN N'Brief nam' THEN N'Brief modal'
            WHEN N'Áo lót nam' THEN N'Áo lót nam cổ tròn'
            WHEN N'Bộ đồ lót nam' THEN N'Bộ đồ lót nam cotton'
            WHEN N'Giữ nhiệt nam' THEN N'Giữ nhiệt siêu mỏng'
            WHEN N'Modal nam' THEN N'Quần lót modal'
            WHEN N'Bodysuit định hình' THEN N'Bodysuit ôm bụng'
            WHEN N'Corset định hình' THEN N'Corset định hình eo'
            WHEN N'Quần định hình' THEN N'Quần định hình cạp cao'
            WHEN N'Legging định hình' THEN N'Legging nâng mông'
            WHEN N'Váy ngủ' THEN N'Váy ngủ trơn'
            WHEN N'Bộ ngủ' THEN N'Bộ ngủ tay dài'
            WHEN N'Áo choàng ngủ' THEN N'Áo choàng lụa'
            WHEN N'Baby doll' THEN N'Baby doll ren'
            WHEN N'Dây áo' THEN N'Dây áo silicon'
            WHEN N'Miếng dán ngực' THEN N'Miếng dán hoa'
            WHEN N'Vớ/Stocking' THEN N'Vớ lưới'
            WHEN N'Bộ bảo quản' THEN N'Bộ bảo quản đồ lót'
            WHEN N'Túi giặt đồ lót' THEN N'Túi giặt lưới'
            WHEN N'Bộ mặc nhà' THEN N'Bộ mặc nhà cotton'
            WHEN N'Váy mặc nhà' THEN N'Váy mặc nhà mềm'
            WHEN N'Áo choàng' THEN N'Áo choàng mỏng'
            WHEN N'Bra thể thao' THEN N'Bra thể thao seamless'
            WHEN N'Set thể thao' THEN N'Set thể thao nâng đỡ'
            WHEN N'Áo ngực cho con bú' THEN N'Áo ngực cho con bú mềm'
            WHEN N'Quần bầu' THEN N'Quần bầu cạp cao'
            WHEN N'Bé gái' THEN N'Đồ lót bé gái cotton'
            WHEN N'Bé trai' THEN N'Đồ lót bé trai cotton'
            ELSE c.CategoryName + N' - Phiên bản mới'
        END,
        c.Id,
        1,
        GETDATE(),
        N'Seed',
        1
    FROM Level3Targets c
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.cf_category c3
        WHERE c3.ParentId = c.Id
    );

    ;WITH ExtraLevel3 AS (
        SELECT c.Id, c.CategoryName
        FROM dbo.cf_category c
        WHERE c.ParentId IN (SELECT Id FROM dbo.cf_category WHERE ParentId IS NULL)
    )
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT
        c.CategoryName + N' - Premium',
        c.Id,
        1,
        GETDATE(),
        N'Seed',
        2
    FROM ExtraLevel3 c
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.cf_category c3
        WHERE c3.ParentId = c.Id
          AND c3.CategoryName = c.CategoryName + N' - Premium'
    );

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Category', c.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), c.CategoryName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(c.Id AS NVARCHAR(20)),
           1, GETDATE(), N'Seed', 0
    FROM dbo.cf_category c
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.cf_seo_slug s
        WHERE s.EntityType = N'Category' AND s.EntityId = c.Id
    );

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
