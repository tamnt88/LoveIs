-- Update admin menu URLs to match folder-based pages.

USE BeautyStoryDB;
GO

UPDATE dbo.cf_menu SET Url = N'/admin/users/default.aspx' WHERE MenuName = N'Quản lý user';
UPDATE dbo.cf_menu SET Url = N'/admin/roles/default.aspx' WHERE MenuName = N'Quản lý role';
UPDATE dbo.cf_menu SET Url = N'/admin/menus/default.aspx' WHERE MenuName = N'Menu admin';
UPDATE dbo.cf_menu SET Url = N'/admin/permissions/default.aspx' WHERE MenuName = N'Gán quyền';
GO
