IF OBJECT_ID('dbo.cf_system_setting', 'U') IS NOT NULL
    DROP TABLE dbo.cf_system_setting;
GO

CREATE TABLE dbo.cf_system_setting (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Key] NVARCHAR(200) NOT NULL,
    [Value] NVARCHAR(MAX) NULL,
    [Group] NVARCHAR(100) NULL,
    [Description] NVARCHAR(500) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_system_setting_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_system_setting_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_system_setting_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_system_setting_Key UNIQUE ([Key])
);
GO
