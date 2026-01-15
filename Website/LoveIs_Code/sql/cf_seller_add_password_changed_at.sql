IF COL_LENGTH('dbo.cf_seller', 'PasswordChangedAt') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller
    ADD PasswordChangedAt DATETIME NULL;
END
GO
