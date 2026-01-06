IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Đơn hàng' AND ActionName = N'View')
BEGIN
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đơn hàng', N'View', N'Xem đơn hàng', 1, GETDATE(), N'Seed', 1);
END

DECLARE @OrderParentId INT;
SELECT @OrderParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Đơn hàng' AND ParentId IS NULL;

IF @OrderParentId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Danh sách đơn hàng' AND ParentId = @OrderParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Danh sách đơn hàng', N'Admin', N'/admin/orders/default.aspx', @OrderParentId, N'fa-solid fa-clipboard-list', 1, GETDATE(), N'Seed', 1);
    END
END

DECLARE @OrderMenuId INT;
SELECT @OrderMenuId = Id FROM dbo.cf_menu WHERE MenuName = N'Danh sách đơn hàng' AND Url = N'/admin/orders/default.aspx';

DECLARE @OrderViewPermissionId INT;
SELECT @OrderViewPermissionId = Id FROM dbo.cf_permission WHERE MenuGroup = N'Đơn hàng' AND ActionName = N'View';

IF @OrderMenuId IS NOT NULL AND @OrderViewPermissionId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu_permission WHERE MenuId = @OrderMenuId AND PermissionId = @OrderViewPermissionId)
    BEGIN
        INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@OrderMenuId, @OrderViewPermissionId, 1, GETDATE(), N'Seed', 1);
    END
END
