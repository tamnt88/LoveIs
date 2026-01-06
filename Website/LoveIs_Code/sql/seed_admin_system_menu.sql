IF NOT EXISTS (SELECT 1 FROM dbo.cf_permission WHERE MenuGroup = N'Hệ thống' AND ActionName = N'View')
BEGIN
    INSERT INTO dbo.cf_permission (MenuGroup, ActionName, PermissionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'View', N'Xem cấu hình hệ thống', 1, GETDATE(), N'Seed', 1);
END

DECLARE @SystemParentId INT;
SELECT @SystemParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Hệ thống' AND ParentId IS NULL;

IF @SystemParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hệ thống', N'Admin', NULL, NULL, N'fa-solid fa-gear', 1, GETDATE(), N'Seed', 99);
    SET @SystemParentId = SCOPE_IDENTITY();
END

IF @SystemParentId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Thông tin liên hệ' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Thông tin liên hệ', N'Admin', N'/admin/system/contact.aspx', @SystemParentId, N'fa-solid fa-address-book', 1, GETDATE(), N'Seed', 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Tài khoản gửi email' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Tài khoản gửi email', N'Admin', N'/admin/system/email.aspx', @SystemParentId, N'fa-solid fa-envelope', 1, GETDATE(), N'Seed', 2);
    END

    
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Tin nhan lien he' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Tin nhan lien he', N'Admin', N'/admin/system/contact-messages.aspx', @SystemParentId, N'fa-solid fa-inbox', 1, GETDATE(), N'Seed', 2);
    END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Địa chỉ (tỉnh/phường)' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Địa chỉ (tỉnh/phường)', N'Admin', N'/admin/system/address.aspx', @SystemParentId, N'fa-solid fa-map-location-dot', 1, GETDATE(), N'Seed', 3);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Mạng xã hội' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Mạng xã hội', N'Admin', N'/admin/system/social.aspx', @SystemParentId, N'fa-brands fa-facebook', 1, GETDATE(), N'Seed', 4);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Mã theo dõi' AND ParentId = @SystemParentId)
    BEGIN
        INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (N'Mã theo dõi', N'Admin', N'/admin/system/integrations.aspx', @SystemParentId, N'fa-solid fa-code', 1, GETDATE(), N'Seed', 5);
    END
END

DECLARE @SystemViewPermissionId INT;
SELECT @SystemViewPermissionId = Id FROM dbo.cf_permission WHERE MenuGroup = N'Hệ thống' AND ActionName = N'View';

IF @SystemViewPermissionId IS NOT NULL
BEGIN
    INSERT INTO dbo.cf_menu_permission (MenuId, PermissionId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT m.Id, @SystemViewPermissionId, 1, GETDATE(), N'Seed', 1
    FROM dbo.cf_menu m
    WHERE m.ParentId = @SystemParentId
      AND NOT EXISTS (
          SELECT 1 FROM dbo.cf_menu_permission mp
          WHERE mp.MenuId = m.Id AND mp.PermissionId = @SystemViewPermissionId
      );
END
