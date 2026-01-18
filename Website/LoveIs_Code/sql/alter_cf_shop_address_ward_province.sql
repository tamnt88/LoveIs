-- Add WardId, ProvinceId for cf_shop_address
USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_shop_address', 'WardId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_address ADD WardId INT NULL;
END

IF COL_LENGTH('dbo.cf_shop_address', 'ProvinceId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_address ADD ProvinceId INT NULL;
END

IF COL_LENGTH('dbo.cf_shop_address', 'DistrictName') IS NOT NULL
BEGIN
    ALTER TABLE dbo.cf_shop_address DROP COLUMN DistrictName;
END
GO
