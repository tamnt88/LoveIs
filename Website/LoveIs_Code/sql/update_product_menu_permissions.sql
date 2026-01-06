SET NOCOUNT ON;

DECLARE @ProductParentId INT;
SELECT @ProductParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Sản phẩm' AND ParentId IS NULL;

IF @ProductParentId IS NULL AND EXISTS (SELECT 1 FROM dbo.cf_menu WHERE Id = 11)
    SET @ProductParentId = 11;

IF @ProductParentId IS NULL
BEGIN
    RAISERROR(N'Không tìm thấy menu cha "Sản phẩm".', 16, 1);
    RETURN;
END

DECLARE @MenuId INT;

-- Danh mục
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Danh mục' AND ParentId = @ProductParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Danh mục', N'Admin', N'/admin/products/categories/default.aspx', @ProductParentId, N'fa-solid fa-sitemap', 1, GETDATE(), N'Seed', 1);
END
ELSE
BEGIN
    UPDATE dbo.cf_menu
    SET Url = N'/admin/products/categories/default.aspx'
    WHERE MenuName = N'Danh mục' AND ParentId = @ProductParentId;
END

-- Thương hiệu
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Thương hiệu' AND ParentId = @ProductParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thương hiệu', N'Admin', N'/admin/products/brands/default.aspx', @ProductParentId, N'fa-solid fa-award', 1, GETDATE(), N'Seed', 2);
END
ELSE
BEGIN
    UPDATE dbo.cf_menu
    SET Url = N'/admin/products/brands/default.aspx'
    WHERE MenuName = N'Thương hiệu' AND ParentId = @ProductParentId;
END

-- Xuất xứ
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Xuất xứ' AND ParentId = @ProductParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Xuất xứ', N'Admin', N'/admin/products/origins/default.aspx', @ProductParentId, N'fa-solid fa-flag', 1, GETDATE(), N'Seed', 3);
END
ELSE
BEGIN
    UPDATE dbo.cf_menu
    SET Url = N'/admin/products/origins/default.aspx'
    WHERE MenuName = N'Xuất xứ' AND ParentId = @ProductParentId;
END

-- Permissions
IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Sản phẩm' AND ActionName = N'View')
BEGIN
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sản phẩm', N'View', N'Xem sản phẩm', 1, GETDATE(), N'Seed', 1);
END

DECLARE @ViewPermissionId INT;
SELECT @ViewPermissionId = Id FROM dbo.cf_permission WHERE MenuGroup = N'Sản phẩm' AND ActionName = N'View';

IF @ViewPermissionId IS NOT NULL
BEGIN
    -- Danh mục
    SELECT @MenuId = Id FROM dbo.cf_menu WHERE MenuName = N'Danh mục' AND ParentId = @ProductParentId;
    IF @MenuId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_menu_permission WHERE MenuId = @MenuId AND PermissionId = @ViewPermissionId)
        INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@MenuId, @ViewPermissionId, 1, GETDATE(), N'Seed', 1);

    -- Thương hiệu
    SELECT @MenuId = Id FROM dbo.cf_menu WHERE MenuName = N'Thương hiệu' AND ParentId = @ProductParentId;
    IF @MenuId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_menu_permission WHERE MenuId = @MenuId AND PermissionId = @ViewPermissionId)
        INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@MenuId, @ViewPermissionId, 1, GETDATE(), N'Seed', 2);

    -- Xuất xứ
    SELECT @MenuId = Id FROM dbo.cf_menu WHERE MenuName = N'Xuất xứ' AND ParentId = @ProductParentId;
    IF @MenuId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_menu_permission WHERE MenuId = @MenuId AND PermissionId = @ViewPermissionId)
        INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@MenuId, @ViewPermissionId, 1, GETDATE(), N'Seed', 3);
END
