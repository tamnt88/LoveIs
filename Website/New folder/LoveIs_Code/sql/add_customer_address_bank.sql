-- Create customer address and bank tables.
-- Run on LoveIsDB.

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

IF OBJECT_ID('dbo.cf_customer_address', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_customer_address (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CustomerId INT NOT NULL,
        FullName NVARCHAR(200) NULL,
        Phone NVARCHAR(30) NULL,
        AddressLine NVARCHAR(300) NULL,
        WardId INT NULL,
        ProvinceId INT NULL,
        WardName NVARCHAR(120) NULL,
        ProvinceName NVARCHAR(120) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_customer_address_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_customer_address_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_customer_address_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL
    );
END;
GO

IF OBJECT_ID('dbo.cf_customer_bank', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_customer_bank (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CustomerId INT NOT NULL,
        BankName NVARCHAR(120) NULL,
        AccountName NVARCHAR(120) NULL,
        AccountNumber NVARCHAR(50) NULL,
        Branch NVARCHAR(120) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_customer_bank_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_customer_bank_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_customer_bank_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_customer_address_CustomerId'
      AND object_id = OBJECT_ID('dbo.cf_customer_address')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_customer_address_CustomerId
    ON dbo.cf_customer_address (CustomerId, IsDefault);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_customer_bank_CustomerId'
      AND object_id = OBJECT_ID('dbo.cf_customer_bank')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_customer_bank_CustomerId
    ON dbo.cf_customer_bank (CustomerId, IsDefault);
END;
GO
