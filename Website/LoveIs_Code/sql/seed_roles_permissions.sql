-- Seed sample roles and permissions.

USE BeautyStoryDB;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_role WHERE RoleName = N'Nhân viên sản phẩm')
BEGIN
    INSERT INTO dbo.cf_role (RoleName, RoleDescription, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhân viên sản phẩm', N'Quản lý sản phẩm', 1, GETDATE(), N'Seed', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_role WHERE RoleName = N'Nhân viên đơn hàng')
BEGIN
    INSERT INTO dbo.cf_role (RoleName, RoleDescription, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhân viên đơn hàng', N'Xử lý đơn hàng', 1, GETDATE(), N'Seed', 2);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_role WHERE RoleName = N'Nhân viên kho')
BEGIN
    INSERT INTO dbo.cf_role (RoleName, RoleDescription, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhân viên kho', N'Quản lý kho', 1, GETDATE(), N'Seed', 3);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_role WHERE RoleName = N'Kế toán')
BEGIN
    INSERT INTO dbo.cf_role (RoleName, RoleDescription, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kế toán', N'Quản lý kế toán', 1, GETDATE(), N'Seed', 4);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Sản phẩm' AND ActionName = N'View')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sản phẩm', N'View', N'Xem sản phẩm', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Sản phẩm' AND ActionName = N'Create')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sản phẩm', N'Create', N'Thêm sản phẩm', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Sản phẩm' AND ActionName = N'Edit')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sản phẩm', N'Edit', N'Sửa sản phẩm', 1, GETDATE(), N'Seed', 3);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Sản phẩm' AND ActionName = N'Delete')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sản phẩm', N'Delete', N'Xóa sản phẩm', 1, GETDATE(), N'Seed', 4);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Đơn hàng' AND ActionName = N'View')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đơn hàng', N'View', N'Xem đơn hàng', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Đơn hàng' AND ActionName = N'Update')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đơn hàng', N'Update', N'Cập nhật đơn hàng', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Kho' AND ActionName = N'View')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kho', N'View', N'Xem kho', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Kho' AND ActionName = N'Update')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kho', N'Update', N'Cập nhật kho', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Kế toán' AND ActionName = N'View')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kế toán', N'View', N'Xem báo cáo', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Kế toán' AND ActionName = N'Approve')
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kế toán', N'Approve', N'Duyệt đối soát', 1, GETDATE(), N'Seed', 2);
GO
