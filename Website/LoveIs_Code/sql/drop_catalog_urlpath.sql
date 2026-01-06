-- Drop UrlPath columns; SEO URLs are managed in cf_seo_slug.

USE BeautyStoryDB;
GO

IF COL_LENGTH('dbo.cf_category', 'UrlPath') IS NOT NULL
    ALTER TABLE dbo.cf_category DROP COLUMN UrlPath;
GO

IF COL_LENGTH('dbo.cf_brand', 'UrlPath') IS NOT NULL
    ALTER TABLE dbo.cf_brand DROP COLUMN UrlPath;
GO

IF COL_LENGTH('dbo.cf_origin', 'UrlPath') IS NOT NULL
    ALTER TABLE dbo.cf_origin DROP COLUMN UrlPath;
GO
