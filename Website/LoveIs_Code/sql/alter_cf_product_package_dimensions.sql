USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_product', 'PackageWeightGrams') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD PackageWeightGrams DECIMAL(10,2) NULL;
END
GO

IF COL_LENGTH('dbo.cf_product', 'PackageLengthCm') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD PackageLengthCm DECIMAL(10,2) NULL;
END
GO

IF COL_LENGTH('dbo.cf_product', 'PackageWidthCm') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD PackageWidthCm DECIMAL(10,2) NULL;
END
GO

IF COL_LENGTH('dbo.cf_product', 'PackageHeightCm') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD PackageHeightCm DECIMAL(10,2) NULL;
END
GO
