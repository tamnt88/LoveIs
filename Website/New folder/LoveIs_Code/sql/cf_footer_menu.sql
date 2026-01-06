IF OBJECT_ID('dbo.cf_footer_menu', 'U') IS NOT NULL
    DROP TABLE dbo.cf_footer_menu;
GO

CREATE TABLE dbo.cf_footer_menu (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    GroupName NVARCHAR(200) NOT NULL,
    GroupSortOrder INT NOT NULL CONSTRAINT DF_cf_footer_menu_GroupSortOrder DEFAULT (0),
    Title NVARCHAR(200) NOT NULL,
    Url NVARCHAR(500) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_footer_menu_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_footer_menu_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_footer_menu_SortOrder DEFAULT (0)
);
GO

CREATE INDEX IX_cf_footer_menu_GroupName ON dbo.cf_footer_menu(GroupName);
GO

CREATE INDEX IX_cf_footer_menu_GroupSortOrder ON dbo.cf_footer_menu(GroupSortOrder);
GO
