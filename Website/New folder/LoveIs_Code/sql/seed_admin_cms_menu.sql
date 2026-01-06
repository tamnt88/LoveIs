DECLARE @CmsParentId INT;
SELECT @CmsParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Bài viết' AND ParentId IS NULL;

IF @CmsParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bài viết', N'Admin', NULL, NULL, N'fa-solid fa-newspaper', 1, GETDATE(), N'Seed', 40);
    SET @CmsParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Danh mục bài viết' AND ParentId = @CmsParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Danh mục bài viết', N'Admin', N'/admin/cms/categories/default.aspx', @CmsParentId, N'fa-solid fa-folder-open', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Bài viết' AND ParentId = @CmsParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bài viết', N'Admin', N'/admin/cms/posts/default.aspx', @CmsParentId, N'fa-solid fa-pen-to-square', 1, GETDATE(), N'Seed', 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Tag bài viết' AND ParentId = @CmsParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tag bài viết', N'Admin', N'/admin/cms/tags/default.aspx', @CmsParentId, N'fa-solid fa-tags', 1, GETDATE(), N'Seed', 3);
END

DECLARE @CmsPermissionId INT;
SELECT @CmsPermissionId = Id FROM dbo.cf_permission WHERE MenuGroup = N'Bài viết' AND ActionName = N'View';
IF @CmsPermissionId IS NULL
BEGIN
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bài viết', N'View', N'Quản lý bài viết', 1, GETDATE(), N'Seed', 1);
    SET @CmsPermissionId = SCOPE_IDENTITY();
END

DECLARE @CmsMenuIds TABLE (Id INT);
INSERT INTO @CmsMenuIds (Id)
SELECT Id FROM dbo.cf_menu WHERE ParentId = @CmsParentId;

INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
SELECT m.Id, @CmsPermissionId, 1, GETDATE(), N'Seed', 0
FROM @CmsMenuIds m
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_menu_permission mp
    WHERE mp.MenuId = m.Id AND mp.PermissionId = @CmsPermissionId
);
