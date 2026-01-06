DECLARE @CmsParentId INT;
SELECT @CmsParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Bài viết' AND ParentId IS NULL;

IF @CmsParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bài viết', N'Admin', NULL, NULL, N'fa-solid fa-newspaper', 1, GETDATE(), N'Seed', 40);
    SET @CmsParentId = SCOPE_IDENTITY();
END

IF @CmsParentId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Trang tĩnh' AND ParentId = @CmsParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Trang tĩnh', N'Admin', N'/admin/cms/pages/default.aspx', @CmsParentId, N'fa-solid fa-file-lines', 1, GETDATE(), N'Seed', 4);
    END
END

DECLARE @SystemParentId INT;
SELECT @SystemParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Hệ thống' AND ParentId IS NULL;

IF @SystemParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'Admin', NULL, NULL, N'fa-solid fa-gear', 1, GETDATE(), N'Seed', 99);
    SET @SystemParentId = SCOPE_IDENTITY();
END

IF @SystemParentId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Trang hệ thống' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Trang hệ thống', N'Admin', N'/admin/system/pages.aspx', @SystemParentId, N'fa-solid fa-sitemap', 1, GETDATE(), N'Seed', 6);
    END
END
