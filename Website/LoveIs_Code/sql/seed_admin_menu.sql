-- Seed product management child menus under existing 'S?n ph?m' parent.
-- Run with UTF-8: sqlcmd -f 65001

USE BeautyStoryDB;
GO

DECLARE @ProductParentId INT;
SELECT @ProductParentId = Id FROM dbo.cf_menu WHERE MenuName = N'S?n ph?m';

IF @ProductParentId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Danh m?c' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Danh m?c', N'Admin', N'/admin/products/categories/default.aspx', @ProductParentId, N'fa-solid fa-sitemap', 1, GETDATE(), N'Seed', 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Th??ng hi?u' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Th??ng hi?u', N'Admin', N'/admin/products/brands/default.aspx', @ProductParentId, N'fa-solid fa-award', 1, GETDATE(), N'Seed', 2);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Xu?t x?' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Xu?t x?', N'Admin', N'/admin/products/origins/default.aspx', @ProductParentId, N'fa-solid fa-flag', 1, GETDATE(), N'Seed', 3);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'B? l?c' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'B? l?c', N'Admin', N'/admin/products/filters/default.aspx', @ProductParentId, N'fa-solid fa-filter', 1, GETDATE(), N'Seed', 4);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Thu?c t?nh' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Thu?c t?nh', N'Admin', N'/admin/products/attributes/default.aspx', @ProductParentId, N'fa-solid fa-sliders', 1, GETDATE(), N'Seed', 5);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'S?n ph?m' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'S?n ph?m', N'Admin', N'/admin/products/default.aspx', @ProductParentId, N'fa-solid fa-box', 1, GETDATE(), N'Seed', 6);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Bi?n th?' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Bi?n th?', N'Admin', N'/admin/products/variants/default.aspx', @ProductParentId, N'fa-solid fa-layer-group', 1, GETDATE(), N'Seed', 7);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'H?nh ?nh' AND ParentId = @ProductParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'H?nh ?nh', N'Admin', N'/admin/products/images/default.aspx', @ProductParentId, N'fa-solid fa-image', 1, GETDATE(), N'Seed', 8);
    END
END
GO
