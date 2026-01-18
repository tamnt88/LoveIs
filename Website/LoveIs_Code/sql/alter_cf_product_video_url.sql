USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_product', 'VideoUrl') IS NULL
    ALTER TABLE dbo.cf_product ADD VideoUrl NVARCHAR(300) NULL;
GO
