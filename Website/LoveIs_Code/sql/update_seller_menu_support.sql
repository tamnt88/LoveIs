USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/support-center.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2066;

UPDATE dbo.cf_menu
SET Url = N'/seller/support-chat.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2067;

UPDATE dbo.cf_menu
SET Url = N'/seller/support-tickets.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2068;
GO
