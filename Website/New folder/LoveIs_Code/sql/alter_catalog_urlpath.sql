-- Add configurable URL paths for category/brand/origin.

USE BeautyStoryDB;
GO

IF COL_LENGTH('dbo.cf_category', 'UrlPath') IS NULL
    ALTER TABLE dbo.cf_category ADD UrlPath NVARCHAR(200) NULL;
GO

IF COL_LENGTH('dbo.cf_brand', 'UrlPath') IS NULL
    ALTER TABLE dbo.cf_brand ADD UrlPath NVARCHAR(200) NULL;
GO

IF COL_LENGTH('dbo.cf_origin', 'UrlPath') IS NULL
    ALTER TABLE dbo.cf_origin ADD UrlPath NVARCHAR(200) NULL;
GO
