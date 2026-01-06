IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Hệ thống' AND ActionName = N'View')
BEGIN
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'View', N'Xem hệ thống', 1, GETDATE(), N'Seed', 4);
END

DECLARE @SystemParentId INT;
SELECT @SystemParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Hệ thống' AND ParentId IS NULL;

IF @SystemParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'Admin', NULL, NULL, N'fa-solid fa-gear', 1, GETDATE(), N'Seed', 99);
    SET @SystemParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Banner' AND ParentId = @SystemParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Banner', N'Admin', N'/admin/system/banners/default.aspx', @SystemParentId, N'fa-solid fa-image', 1, GETDATE(), N'Seed', 6);
END

DECLARE @BannerMenuId INT = (SELECT TOP 1 Id FROM dbo.cf_menu WHERE MenuName = N'Banner' AND ParentId = @SystemParentId);
DECLARE @BannerPermissionId INT = (SELECT TOP 1 Id FROM dbo.cf_permission WHERE MenuGroup = N'Hệ thống' AND ActionName = N'View');
IF @BannerMenuId IS NOT NULL AND @BannerPermissionId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu_permission WHERE MenuId = @BannerMenuId AND PermissionId = @BannerPermissionId)
    BEGIN
        INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@BannerMenuId, @BannerPermissionId, 1, GETDATE(), N'Seed', 0);
    END
END
