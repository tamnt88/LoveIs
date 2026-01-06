-- Marketplace upgrade schema for LoveIsDB
-- Adds seller/customer/shop, split orders, returns, payment/shipping tracking, reviews, and product stats.

USE LoveIsDB;
GO

-- Buyer (customer) account
IF OBJECT_ID('dbo.cf_customer', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_customer (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Username NVARCHAR(100) NOT NULL,
        DisplayName NVARCHAR(200) NULL,
        Email NVARCHAR(200) NULL,
        Phone NVARCHAR(30) NULL,
        PasswordHash VARBINARY(64) NOT NULL,
        PasswordSalt VARBINARY(32) NOT NULL,
        PasswordIterations INT NOT NULL,
        LastLoginAt DATETIME NULL,
        LockedUntil DATETIME NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_customer_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_customer_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_customer_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_customer_Username UNIQUE (Username)
    );
END
GO

-- Seller account (1-1 with shop)
IF OBJECT_ID('dbo.cf_seller', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_seller (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Username NVARCHAR(100) NOT NULL,
        DisplayName NVARCHAR(200) NULL,
        Email NVARCHAR(200) NULL,
        Phone NVARCHAR(30) NULL,
        PasswordHash VARBINARY(64) NOT NULL,
        PasswordSalt VARBINARY(32) NOT NULL,
        PasswordIterations INT NOT NULL,
        LastLoginAt DATETIME NULL,
        LockedUntil DATETIME NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_seller_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_seller_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_seller_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_seller_Username UNIQUE (Username)
    );
END
GO

-- Shop
IF OBJECT_ID('dbo.cf_shop', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SellerId INT NOT NULL,
        ShopCode NVARCHAR(50) NOT NULL,
        ShopName NVARCHAR(200) NOT NULL,
        LogoUrl NVARCHAR(300) NULL,
        BannerUrl NVARCHAR(300) NULL,
        Description NVARCHAR(MAX) NULL,
        AddressLine NVARCHAR(300) NULL,
        WardId INT NULL,
        ProvinceId INT NULL,
        WardName NVARCHAR(150) NULL,
        ProvinceName NVARCHAR(150) NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shop_Status DEFAULT (N'Pending'),
        RatingAvg DECIMAL(3,2) NOT NULL CONSTRAINT DF_cf_shop_RatingAvg DEFAULT (0),
        RatingCount INT NOT NULL CONSTRAINT DF_cf_shop_RatingCount DEFAULT (0),
        CompletedOrders INT NOT NULL CONSTRAINT DF_cf_shop_CompletedOrders DEFAULT (0),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_seller FOREIGN KEY (SellerId) REFERENCES dbo.cf_seller(Id),
        CONSTRAINT UQ_cf_shop_Seller UNIQUE (SellerId),
        CONSTRAINT UQ_cf_shop_ShopCode UNIQUE (ShopCode)
    );
END
GO

-- Optional staff mapping (future proof)
IF OBJECT_ID('dbo.cf_shop_user', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_user (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        SellerId INT NOT NULL,
        UserRole NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shop_user_UserRole DEFAULT (N'Owner'),
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_user_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_user_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_user_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_user_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id),
        CONSTRAINT FK_cf_shop_user_seller FOREIGN KEY (SellerId) REFERENCES dbo.cf_seller(Id),
        CONSTRAINT UQ_cf_shop_user UNIQUE (ShopId, SellerId)
    );
END
GO

-- Add ShopId + stats columns to product
IF COL_LENGTH('dbo.cf_product', 'ShopId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product ADD ShopId INT NULL;
END
GO

IF COL_LENGTH('dbo.cf_product', 'ViewCount') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product ADD ViewCount INT NOT NULL CONSTRAINT DF_cf_product_ViewCount DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'Sold30d') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product ADD Sold30d INT NOT NULL CONSTRAINT DF_cf_product_Sold30d DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'RatingAvg') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product ADD RatingAvg DECIMAL(3,2) NOT NULL CONSTRAINT DF_cf_product_RatingAvg DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'RatingCount') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product ADD RatingCount INT NOT NULL CONSTRAINT DF_cf_product_RatingCount DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'ContentScore') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product ADD ContentScore INT NOT NULL CONSTRAINT DF_cf_product_ContentScore DEFAULT (0);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_product_shop')
BEGIN
    ALTER TABLE dbo.cf_product
    ADD CONSTRAINT FK_cf_product_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);
END
GO

-- Split order by shop
IF OBJECT_ID('dbo.cf_shop_order', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_order (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        OrderId INT NOT NULL,
        ShopId INT NOT NULL,
        ShippingMethod NVARCHAR(100) NOT NULL,
        ShippingFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_order_ShippingFee DEFAULT (0),
        ShippingEta NVARCHAR(100) NULL,
        PaymentStatus NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shop_order_PaymentStatus DEFAULT (N'Pending'),
        OrderStatus NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shop_order_OrderStatus DEFAULT (N'New'),
        Subtotal DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_order_Subtotal DEFAULT (0),
        Discount DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_order_Discount DEFAULT (0),
        Total DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_order_Total DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_order_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_order_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_order_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_order_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id),
        CONSTRAINT FK_cf_shop_order_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id)
    );
END
GO

IF OBJECT_ID('dbo.cf_shop_order_history', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_order_history (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopOrderId INT NOT NULL,
        Action NVARCHAR(200) NOT NULL,
        Note NVARCHAR(MAX) NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_order_history_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_order_history_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_order_history_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_order_history_shop_order FOREIGN KEY (ShopOrderId) REFERENCES dbo.cf_shop_order(Id)
    );
END
GO

-- Returns
IF OBJECT_ID('dbo.cf_return_request', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_return_request (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        OrderId INT NOT NULL,
        ShopId INT NOT NULL,
        Reason NVARCHAR(300) NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_return_request_Status DEFAULT (N'Pending'),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_return_request_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_return_request_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_return_request_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id),
        CONSTRAINT FK_cf_return_request_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id)
    );
END
GO

IF OBJECT_ID('dbo.cf_return_item', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_return_item (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ReturnRequestId INT NOT NULL,
        OrderItemId INT NOT NULL,
        Quantity INT NOT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_return_item_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_return_item_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_return_item_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_return_item_request FOREIGN KEY (ReturnRequestId) REFERENCES dbo.cf_return_request(Id),
        CONSTRAINT FK_cf_return_item_order_item FOREIGN KEY (OrderItemId) REFERENCES dbo.cf_order_item(Id)
    );
END
GO

-- Payment tracking (mock now, ready for integrations)
IF OBJECT_ID('dbo.cf_payment_transaction', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_payment_transaction (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        OrderId INT NOT NULL,
        Provider NVARCHAR(50) NOT NULL,
        ProviderRef NVARCHAR(100) NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_payment_transaction_Status DEFAULT (N'Pending'),
        Amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_payment_transaction_Amount DEFAULT (0),
        MetaJson NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_payment_transaction_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_payment_transaction_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_payment_transaction_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id)
    );
END
GO

-- Shipping tracking per shop order
IF OBJECT_ID('dbo.cf_shipping_tracking', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shipping_tracking (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopOrderId INT NOT NULL,
        Carrier NVARCHAR(100) NOT NULL,
        TrackingCode NVARCHAR(100) NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shipping_tracking_Status DEFAULT (N'Pending'),
        MetaJson NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shipping_tracking_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shipping_tracking_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shipping_tracking_shop_order FOREIGN KEY (ShopOrderId) REFERENCES dbo.cf_shop_order(Id)
    );
END
GO

-- Product review
IF OBJECT_ID('dbo.cf_product_review', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_product_review (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ProductId INT NOT NULL,
        CustomerId INT NOT NULL,
        Rating INT NOT NULL,
        Content NVARCHAR(MAX) NULL,
        IsVerified BIT NOT NULL CONSTRAINT DF_cf_product_review_IsVerified DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_product_review_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_review_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_product_review_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_product_review_product FOREIGN KEY (ProductId) REFERENCES dbo.cf_product(Id),
        CONSTRAINT FK_cf_product_review_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id)
    );
END
GO

-- Shop review
IF OBJECT_ID('dbo.cf_shop_review', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_review (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        CustomerId INT NOT NULL,
        Rating INT NOT NULL,
        Content NVARCHAR(MAX) NULL,
        IsVerified BIT NOT NULL CONSTRAINT DF_cf_shop_review_IsVerified DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_review_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_review_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_review_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_review_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id),
        CONSTRAINT FK_cf_shop_review_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id)
    );
END
GO

-- Helpful indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_shop' AND object_id = OBJECT_ID('dbo.cf_product'))
    CREATE INDEX IX_cf_product_shop ON dbo.cf_product(ShopId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_shop_order_order' AND object_id = OBJECT_ID('dbo.cf_shop_order'))
    CREATE INDEX IX_cf_shop_order_order ON dbo.cf_shop_order(OrderId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_shop_order_shop' AND object_id = OBJECT_ID('dbo.cf_shop_order'))
    CREATE INDEX IX_cf_shop_order_shop ON dbo.cf_shop_order(ShopId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_review_product' AND object_id = OBJECT_ID('dbo.cf_product_review'))
    CREATE INDEX IX_cf_product_review_product ON dbo.cf_product_review(ProductId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_shop_review_shop' AND object_id = OBJECT_ID('dbo.cf_shop_review'))
    CREATE INDEX IX_cf_shop_review_shop ON dbo.cf_shop_review(ShopId);
GO
