IF OBJECT_ID('dbo.cf_banner', 'U') IS NOT NULL
    DROP TABLE dbo.cf_banner;
GO

CREATE TABLE dbo.cf_banner (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TitleLine1 NVARCHAR(200) NULL,
    TitleLine2 NVARCHAR(200) NULL,
    TitleLine3 NVARCHAR(200) NULL,
    ImageUrl NVARCHAR(500) NULL,
    MediaType NVARCHAR(20) NULL,
    MediaUrl NVARCHAR(500) NULL,
    PosterUrl NVARCHAR(500) NULL,
    LinkUrl NVARCHAR(500) NULL,
    LinkText NVARCHAR(200) NULL,
    ShowLink BIT NOT NULL CONSTRAINT DF_cf_banner_ShowLink DEFAULT (1),
    Position NVARCHAR(100) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_banner_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_banner_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_banner_SortOrder DEFAULT (0)
);
GO
