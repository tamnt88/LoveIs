IF COL_LENGTH('dbo.cf_seller', 'BirthDate') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller
    ADD BirthDate DATE NULL;
END
GO

IF COL_LENGTH('dbo.cf_seller', 'AvatarUrl') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller
    ADD AvatarUrl NVARCHAR(300) NULL;
END
GO
