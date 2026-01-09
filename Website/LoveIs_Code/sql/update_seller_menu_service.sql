USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/service-warranty.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2063;

UPDATE dbo.cf_menu
SET Url = N'/seller/service-shipping.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2064;
GO
