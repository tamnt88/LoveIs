USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_order', 'ShippingFeePercent') IS NULL
BEGIN
    ALTER TABLE dbo.cf_order
    ADD ShippingFeePercent DECIMAL(5,2) NULL,
        ShippingFeeAmount DECIMAL(18,2) NULL,
        PaymentFeePercent DECIMAL(5,2) NULL,
        PaymentFeeAmount DECIMAL(18,2) NULL,
        PlatformFeePercent DECIMAL(5,2) NULL,
        PlatformFeeAmount DECIMAL(18,2) NULL,
        InfrastructureFee DECIMAL(18,2) NULL;
END
GO

IF COL_LENGTH('dbo.cf_shop_order', 'ShippingFeePercent') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_order
    ADD ShippingFeePercent DECIMAL(5,2) NULL,
        ShippingFeeAmount DECIMAL(18,2) NULL,
        PaymentFeePercent DECIMAL(5,2) NULL,
        PaymentFeeAmount DECIMAL(18,2) NULL,
        PlatformFeePercent DECIMAL(5,2) NULL,
        PlatformFeeAmount DECIMAL(18,2) NULL,
        InfrastructureFee DECIMAL(18,2) NULL;
END
GO

IF OBJECT_ID('dbo.cf_platform_fee_config', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_platform_fee_config
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        ShippingFeePercent DECIMAL(5,2) NOT NULL,
        PaymentFeePercent DECIMAL(5,2) NOT NULL,
        InfrastructureFee DECIMAL(18,2) NOT NULL,
        Status BIT NOT NULL DEFAULT (1),
        CreatedAt DATETIME NOT NULL DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL DEFAULT (0)
    );
END
GO

IF OBJECT_ID('dbo.cf_platform_fee_category', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_platform_fee_category
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CategoryId INT NOT NULL,
        PlatformFeePercent DECIMAL(5,2) NOT NULL,
        Status BIT NOT NULL DEFAULT (1),
        CreatedAt DATETIME NOT NULL DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL DEFAULT (0)
    );

    CREATE INDEX IX_cf_platform_fee_category_Category
        ON dbo.cf_platform_fee_category (CategoryId);
END
GO

IF OBJECT_ID('dbo.cf_customer_order_limit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_customer_order_limit
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        MinTotalSpent DECIMAL(18,2) NOT NULL,
        MaxTotalSpent DECIMAL(18,2) NULL,
        MaxItemsPerOrder INT NOT NULL,
        MaxQtyPerItem INT NOT NULL,
        Status BIT NOT NULL DEFAULT (1),
        CreatedAt DATETIME NOT NULL DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL DEFAULT (0)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_platform_fee_config)
BEGIN
    INSERT INTO dbo.cf_platform_fee_config
        (ShippingFeePercent, PaymentFeePercent, InfrastructureFee, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (4.90, 4.90, 3000, 1, GETDATE(), N'Seed', 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_platform_fee_category)
BEGIN
    INSERT INTO dbo.cf_platform_fee_category
        (CategoryId, PlatformFeePercent, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT
        c.Id,
        4.00,
        1,
        GETDATE(),
        N'Seed',
        c.SortOrder
    FROM dbo.cf_category c
    WHERE c.ParentId IS NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_customer_order_limit)
BEGIN
    INSERT INTO dbo.cf_customer_order_limit
        (MinTotalSpent, MaxTotalSpent, MaxItemsPerOrder, MaxQtyPerItem, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (0,        2000000, 5, 2, 1, GETDATE(), N'Seed', 0),
        (2000000,  10000000, 10, 3, 1, GETDATE(), N'Seed', 1),
        (10000000, 30000000, 20, 5, 1, GETDATE(), N'Seed', 2),
        (30000000, NULL,     50, 10, 1, GETDATE(), N'Seed', 3);
END
GO
