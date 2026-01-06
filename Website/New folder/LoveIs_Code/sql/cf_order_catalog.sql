SET NOCOUNT ON;

IF OBJECT_ID('dbo.cf_shipping_method', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shipping_method (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(500) NULL,
        BaseFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shipping_method_BaseFee DEFAULT (0),
        InnerCityFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shipping_method_InnerCityFee DEFAULT (0),
        EtaText NVARCHAR(100) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_shipping_method_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shipping_method_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shipping_method_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shipping_method_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_shipping_method_Code UNIQUE (Code)
    );
END

IF OBJECT_ID('dbo.cf_payment_method', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_payment_method (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(500) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_payment_method_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_payment_method_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_payment_method_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_payment_method_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_payment_method_Code UNIQUE (Code)
    );
END

IF OBJECT_ID('dbo.cf_order_status', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_order_status (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(500) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_order_status_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_order_status_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_order_status_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_order_status_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_order_status_Code UNIQUE (Code)
    );
END

IF OBJECT_ID('dbo.cf_payment_status', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_payment_status (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(500) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_payment_status_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_payment_status_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_payment_status_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_payment_status_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_payment_status_Code UNIQUE (Code)
    );
END

IF COL_LENGTH('dbo.cf_order', 'ShippingMethodId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_order ADD ShippingMethodId INT NULL;
END
IF COL_LENGTH('dbo.cf_order', 'PaymentMethodId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_order ADD PaymentMethodId INT NULL;
END
IF COL_LENGTH('dbo.cf_order', 'PaymentStatusId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_order ADD PaymentStatusId INT NULL;
END
IF COL_LENGTH('dbo.cf_order', 'OrderStatusId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_order ADD OrderStatusId INT NULL;
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_shipping_method)
BEGIN
    INSERT INTO dbo.cf_shipping_method (Code, Name, Description, BaseFee, InnerCityFee, EtaText, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (N'STANDARD', N'Giao hàng tiêu chuẩn', N'Giao hàng tiêu chuẩn 2-4 ngày', 30000, 20000, N'2-4 ngày', 1, 1, GETDATE(), N'Seed', 1),
    (N'EXPRESS', N'Giao nhanh', N'Giao trong ngày', 50000, 50000, N'Trong ngày', 0, 1, GETDATE(), N'Seed', 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_method)
BEGIN
    INSERT INTO dbo.cf_payment_method (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (N'COD', N'Thanh toán khi nhận hàng', N'Thanh toán bằng tiền mặt khi nhận hàng', 1, 1, GETDATE(), N'Seed', 1),
    (N'BANK', N'Chuyển khoản ngân hàng', N'Chuyển khoản qua tài khoản ngân hàng', 0, 1, GETDATE(), N'Seed', 2),
    (N'WALLET', N'Ví điện tử', N'Thanh toán qua ví điện tử', 0, 0, GETDATE(), N'Seed', 3);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_order_status)
BEGIN
    INSERT INTO dbo.cf_order_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (N'NEW', N'Đặt hàng', N'Đơn hàng vừa tạo', 1, 1, GETDATE(), N'Seed', 1),
    (N'CONFIRMED', N' Xác nhận', N'Đã xác nhận đơn hàng', 0, 1, GETDATE(), N'Seed', 2),
    (N'SHIPPING', N'Đang giao', N'Đơn hàng đang giao', 0, 1, GETDATE(), N'Seed', 3),
    (N'COMPLETED', N'Hoàn tất', N'Đơn hàng đã hoàn tất', 0, 1, GETDATE(), N'Seed', 4),
    (N'CANCELLED', N'Đã hủy', N'Đơn hàng đã bị hủy', 0, 1, GETDATE(), N'Seed', 5);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_status)
BEGIN
    INSERT INTO dbo.cf_payment_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (N'PENDING', N'Chưa thanh toán', N'Chưa thanh toán', 1, 1, GETDATE(), N'Seed', 1),
    (N'PAID', N'Đã thanh toán', N'Đã thanh toán', 0, 1, GETDATE(), N'Seed', 2),
    (N'FAILED', N'Thanh toán thất bại', N'Thanh toán thất bại', 0, 1, GETDATE(), N'Seed', 3);
END
