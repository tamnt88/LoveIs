DECLARE @SystemParentId INT;
SELECT @SystemParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Hệ thống' AND ParentId IS NULL;

IF @SystemParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'Admin', NULL, NULL, N'fa-solid fa-gear', 1, GETDATE(), N'Seed', 99);
    SET @SystemParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Menu footer' AND ParentId = @SystemParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Menu footer', N'Admin', N'/admin/system/footer-menus/default.aspx', @SystemParentId, N'fa-solid fa-list', 1, GETDATE(), N'Seed', 7);
END
