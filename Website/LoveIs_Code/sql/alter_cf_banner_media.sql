IF COL_LENGTH('dbo.cf_banner', 'MediaType') IS NULL
    ALTER TABLE dbo.cf_banner ADD MediaType NVARCHAR(20) NULL;
GO

IF COL_LENGTH('dbo.cf_banner', 'MediaUrl') IS NULL
    ALTER TABLE dbo.cf_banner ADD MediaUrl NVARCHAR(500) NULL;
GO

IF COL_LENGTH('dbo.cf_banner', 'PosterUrl') IS NULL
    ALTER TABLE dbo.cf_banner ADD PosterUrl NVARCHAR(500) NULL;
GO
