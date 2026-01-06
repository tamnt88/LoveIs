IF OBJECT_ID('dbo.cf_static_page', 'U') IS NOT NULL
    DROP TABLE dbo.cf_static_page;

CREATE TABLE dbo.cf_static_page (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PageName NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(255) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(500) NULL,
    CanonicalUrl NVARCHAR(500) NULL,
    Robots NVARCHAR(200) NULL,
    OgTitle NVARCHAR(255) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(500) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(255) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(500) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_static_page_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_static_page_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_static_page_SortOrder DEFAULT (0)
);

CREATE INDEX IX_cf_static_page_Status ON dbo.cf_static_page(Status);
CREATE INDEX IX_cf_static_page_SortOrder ON dbo.cf_static_page(SortOrder);
