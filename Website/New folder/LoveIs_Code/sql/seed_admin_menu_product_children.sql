-- Reset product child menus under parent Id = 11 (UTF-8)
USE BeautyStoryDB;
GO

DECLARE @ProductParentId INT = 11;

-- Remove any existing product child menus (including garbled ones)
DELETE FROM dbo.cf_menu
WHERE Url LIKE N'/admin/products/%'
  AND ParentId <> @ProductParentId;

DELETE FROM dbo.cf_menu
WHERE ParentId = @ProductParentId
  AND Url LIKE N'/admin/products/%';

-- Insert clean product child menus under parent Id = 11
INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
VALUES
    (N'Danh m?c', N'Admin', N'/admin/products/categories/default.aspx', @ProductParentId, N'fa-solid fa-sitemap', 1, GETDATE(), N'Seed', 1),
    (N'Th??ng hi?u', N'Admin', N'/admin/products/brands/default.aspx', @ProductParentId, N'fa-solid fa-award', 1, GETDATE(), N'Seed', 2),
    (N'Xu?t x?', N'Admin', N'/admin/products/origins/default.aspx', @ProductParentId, N'fa-solid fa-flag', 1, GETDATE(), N'Seed', 3),
    (N'B? l?c', N'Admin', N'/admin/products/filters/default.aspx', @ProductParentId, N'fa-solid fa-filter', 1, GETDATE(), N'Seed', 4),
    (N'Thu?c t?nh', N'Admin', N'/admin/products/attributes/default.aspx', @ProductParentId, N'fa-solid fa-sliders', 1, GETDATE(), N'Seed', 5),
    (N'Danh s?ch s?n ph?m', N'Admin', N'/admin/products/default.aspx', @ProductParentId, N'fa-solid fa-box', 1, GETDATE(), N'Seed', 6),
    (N'Bi?n th?', N'Admin', N'/admin/products/variants/default.aspx', @ProductParentId, N'fa-solid fa-layer-group', 1, GETDATE(), N'Seed', 7),
    (N'H?nh ?nh', N'Admin', N'/admin/products/images/default.aspx', @ProductParentId, N'fa-solid fa-image', 1, GETDATE(), N'Seed', 8);
GO
