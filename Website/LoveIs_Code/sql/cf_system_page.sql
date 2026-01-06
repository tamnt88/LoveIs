IF OBJECT_ID('dbo.cf_system_page', 'U') IS NOT NULL
    DROP TABLE dbo.cf_system_page;

CREATE TABLE dbo.cf_system_page (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PageKey NVARCHAR(100) NOT NULL,
    PageName NVARCHAR(255) NOT NULL,
    StaticPageId INT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_system_page_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_system_page_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_system_page_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_system_page_PageKey UNIQUE (PageKey),
    CONSTRAINT FK_cf_system_page_static_page FOREIGN KEY (StaticPageId) REFERENCES dbo.cf_static_page(Id)
);

CREATE INDEX IX_cf_system_page_Status ON dbo.cf_system_page(Status);
CREATE INDEX IX_cf_system_page_SortOrder ON dbo.cf_system_page(SortOrder);
