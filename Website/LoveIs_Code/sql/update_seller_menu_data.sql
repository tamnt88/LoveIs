USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/data-sales.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2054;

UPDATE dbo.cf_menu
SET Url = N'/seller/data-performance.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2055;

UPDATE dbo.cf_menu
SET Url = N'/seller/data-products.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2056;

UPDATE dbo.cf_menu
SET Url = N'/seller/data-marketing.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2057;
GO
