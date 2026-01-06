IF OBJECT_ID('dbo.cf_contact_info', 'U') IS NOT NULL
    DROP TABLE dbo.cf_contact_info;
GO

CREATE TABLE dbo.cf_contact_info (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CompanyName NVARCHAR(200) NULL,
    Hotline NVARCHAR(100) NULL,
    Email NVARCHAR(200) NULL,
    Address NVARCHAR(500) NULL,
    GoogleMapUrl NVARCHAR(500) NULL,
    GoogleMapEmbed NVARCHAR(MAX) NULL,
    LogoHorizontalUrl NVARCHAR(500) NULL,
    LogoVerticalUrl NVARCHAR(500) NULL,
    FaviconUrl NVARCHAR(500) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_contact_info_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_contact_info_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_contact_info_SortOrder DEFAULT (0)
);
GO

IF OBJECT_ID('dbo.cf_email_account', 'U') IS NOT NULL
    DROP TABLE dbo.cf_email_account;
GO

CREATE TABLE dbo.cf_email_account (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Email NVARCHAR(200) NULL,
    [Password] NVARCHAR(300) NULL,
    DisplayName NVARCHAR(200) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_email_account_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_email_account_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_email_account_SortOrder DEFAULT (0)
);
GO

IF OBJECT_ID('dbo.cf_social_link', 'U') IS NOT NULL
    DROP TABLE dbo.cf_social_link;
GO

CREATE TABLE dbo.cf_social_link (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DisplayName NVARCHAR(200) NULL,
    IconClass NVARCHAR(200) NULL,
    Url NVARCHAR(500) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_social_link_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_social_link_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_social_link_SortOrder DEFAULT (0)
);
GO

IF OBJECT_ID('dbo.cf_tracking_code', 'U') IS NOT NULL
    DROP TABLE dbo.cf_tracking_code;
GO

CREATE TABLE dbo.cf_tracking_code (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    HeaderCode NVARCHAR(MAX) NULL,
    BodyCode NVARCHAR(MAX) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_tracking_code_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_tracking_code_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_tracking_code_SortOrder DEFAULT (0)
);
GO
