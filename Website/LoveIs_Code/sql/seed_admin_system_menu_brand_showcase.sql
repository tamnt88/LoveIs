IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Hệ thống' AND ActionName = N'BrandShowcase')
BEGIN
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'BrandShowcase', N'Quản lý thương hiệu tiêu biểu', 1, GETDATE(), N'Seed', 6);
END

DECLARE @SystemParentId INT;
SELECT @SystemParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Hệ thống' AND ParentId IS NULL;

IF @SystemParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'Admin', NULL, NULL, N'fa-solid fa-gear', 1, GETDATE(), N'Seed', 99);
    SET @SystemParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Thương hiệu tiêu biểu' AND ParentId = @SystemParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thương hiệu tiêu biểu', N'Admin', N'/admin/system/brand-showcases/default.aspx', @SystemParentId, N'fa-solid fa-star', 1, GETDATE(), N'Seed', 8);
END
