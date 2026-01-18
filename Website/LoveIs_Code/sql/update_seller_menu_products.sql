USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/product-list.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2034;

UPDATE dbo.cf_menu
SET Url = N'/seller/product-add.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2035;

UPDATE dbo.cf_menu
SET Url = N'/seller/product-locked.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2036;

UPDATE dbo.cf_menu
SET Url = N'/seller/product-violations.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2037;
GO
