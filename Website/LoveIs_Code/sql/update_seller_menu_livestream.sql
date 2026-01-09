USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/livestream.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2059;

UPDATE dbo.cf_menu
SET Url = N'/seller/livestream-create.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2060;
GO
