-- Create tables to manage province/ward data imported from the Excel file.
-- Target database: BeautyStoryDB

USE BeautyStoryDB;
GO

IF OBJECT_ID('dbo.cf_ward', 'U') IS NOT NULL
    DROP TABLE dbo.cf_ward;
GO

IF OBJECT_ID('dbo.cf_province', 'U') IS NOT NULL
    DROP TABLE dbo.cf_province;
GO

CREATE TABLE dbo.cf_province (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProvinceName NVARCHAR(200) NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_province_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_province_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_province_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_province_ProvinceName UNIQUE (ProvinceName)
);
GO

CREATE TABLE dbo.cf_ward (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProvinceId INT NOT NULL,
    WardName NVARCHAR(200) NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_ward_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_ward_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_ward_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_ward_cf_province
        FOREIGN KEY (ProvinceId) REFERENCES dbo.cf_province(Id),
    CONSTRAINT UQ_cf_ward_ProvinceId_WardName UNIQUE (ProvinceId, WardName)
);
GO

CREATE INDEX IX_cf_ward_WardName ON dbo.cf_ward(WardName);
GO
