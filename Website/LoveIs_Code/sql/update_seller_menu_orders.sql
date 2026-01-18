USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/order-list.aspx?status=all',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2027;

UPDATE dbo.cf_menu
SET Url = N'/seller/order-cancelled.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2028;

UPDATE dbo.cf_menu
SET Url = N'/seller/order-returns.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2029;

UPDATE dbo.cf_menu
SET Url = N'/seller/order-swaps.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2030;

UPDATE dbo.cf_menu
SET Url = N'/seller/order-protect.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2031;

UPDATE dbo.cf_menu
SET Url = N'/seller/order-shipping-settings.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2032;
GO
