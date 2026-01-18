USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/settings-address.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2070;

UPDATE dbo.cf_menu
SET Url = N'/seller/settings-shop.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2071;

UPDATE dbo.cf_menu
SET Url = N'/seller/settings-account.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2072;

UPDATE dbo.cf_menu
SET Url = N'/seller/settings-notifications.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2073;
GO
