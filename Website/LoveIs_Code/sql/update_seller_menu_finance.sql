USE LoveIsDB;
GO

UPDATE dbo.cf_menu
SET Url = N'/seller/finance-revenue.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2048;

UPDATE dbo.cf_menu
SET Url = N'/seller/finance-balance.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2049;

UPDATE dbo.cf_menu
SET Url = N'/seller/finance-cashflow.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2050;

UPDATE dbo.cf_menu
SET Url = N'/seller/finance-report.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2051;

UPDATE dbo.cf_menu
SET Url = N'/seller/finance-bank.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2052;
GO
