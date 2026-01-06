IF OBJECT_ID('dbo.cf_brand_showcase_banner', 'U') IS NOT NULL
    DROP TABLE dbo.cf_brand_showcase_banner;
GO

IF OBJECT_ID('dbo.cf_brand_showcase', 'U') IS NOT NULL
    DROP TABLE dbo.cf_brand_showcase;
GO

CREATE TABLE dbo.cf_brand_showcase (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BrandId INT NOT NULL,
    Title NVARCHAR(200) NULL,
    VideoUrl NVARCHAR(500) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_brand_showcase_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_brand_showcase_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_brand_showcase_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_brand_showcase_cf_brand
        FOREIGN KEY (BrandId) REFERENCES dbo.cf_brand(Id)
);
GO

CREATE TABLE dbo.cf_brand_showcase_banner (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ShowcaseId INT NOT NULL,
    TitleLine1 NVARCHAR(200) NULL,
    TitleLine2 NVARCHAR(200) NULL,
    TitleLine3 NVARCHAR(200) NULL,
    ImageUrl NVARCHAR(500) NULL,
    LinkUrl NVARCHAR(500) NULL,
    LinkText NVARCHAR(200) NULL,
    ShowLink BIT NOT NULL CONSTRAINT DF_cf_brand_showcase_banner_ShowLink DEFAULT (1),
    Status BIT NOT NULL CONSTRAINT DF_cf_brand_showcase_banner_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_brand_showcase_banner_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_brand_showcase_banner_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_brand_showcase_banner_showcase
        FOREIGN KEY (ShowcaseId) REFERENCES dbo.cf_brand_showcase(Id)
);
GO

CREATE INDEX IX_cf_brand_showcase_BrandId ON dbo.cf_brand_showcase(BrandId);
GO

CREATE INDEX IX_cf_brand_showcase_banner_ShowcaseId ON dbo.cf_brand_showcase_banner(ShowcaseId);
GO
