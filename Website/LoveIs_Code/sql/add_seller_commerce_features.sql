IF OBJECT_ID('dbo.cf_collection', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_collection (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Slug NVARCHAR(200) NULL,
        Description NVARCHAR(MAX) NULL,
        BannerUrl NVARCHAR(500) NULL,
        LikeCount INT NOT NULL CONSTRAINT DF_cf_collection_LikeCount DEFAULT (0),
        ClickCount INT NOT NULL CONSTRAINT DF_cf_collection_ClickCount DEFAULT (0),
        ViewCount INT NOT NULL CONSTRAINT DF_cf_collection_ViewCount DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_collection_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_collection_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(50) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(50) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_collection_SortOrder DEFAULT (0)
    );

    ALTER TABLE dbo.cf_collection
    ADD CONSTRAINT FK_cf_collection_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);
END

IF OBJECT_ID('dbo.cf_collection_item', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_collection_item (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CollectionId INT NOT NULL,
        ProductId INT NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_collection_item_SortOrder DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_collection_item_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_collection_item_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_collection_item
    ADD CONSTRAINT FK_cf_collection_item_collection FOREIGN KEY (CollectionId) REFERENCES dbo.cf_collection(Id);

    ALTER TABLE dbo.cf_collection_item
    ADD CONSTRAINT FK_cf_collection_item_product FOREIGN KEY (ProductId) REFERENCES dbo.cf_product(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_collection_item_collection_product'
      AND object_id = OBJECT_ID('dbo.cf_collection_item')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_collection_item_collection_product
    ON dbo.cf_collection_item (CollectionId, ProductId);
END

IF OBJECT_ID('dbo.cf_collection_event', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_collection_event (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CollectionId INT NOT NULL,
        EventType NVARCHAR(20) NOT NULL,
        CustomerId INT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_collection_event_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_collection_event
    ADD CONSTRAINT FK_cf_collection_event_collection FOREIGN KEY (CollectionId) REFERENCES dbo.cf_collection(Id);

    ALTER TABLE dbo.cf_collection_event
    ADD CONSTRAINT FK_cf_collection_event_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_collection_event_collection_type'
      AND object_id = OBJECT_ID('dbo.cf_collection_event')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_collection_event_collection_type
    ON dbo.cf_collection_event (CollectionId, EventType, CreatedAt DESC);
END

IF OBJECT_ID('dbo.cf_coupon', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_coupon (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Scope NVARCHAR(20) NOT NULL,
        ShopId INT NULL,
        DiscountType NVARCHAR(20) NOT NULL,
        DiscountValue DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_coupon_DiscountValue DEFAULT (0),
        MinOrder DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_coupon_MinOrder DEFAULT (0),
        MaxDiscount DECIMAL(18,2) NULL,
        StartAt DATETIME NULL,
        EndAt DATETIME NULL,
        UsageLimit INT NULL,
        UsagePerUser INT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_coupon_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_coupon_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(50) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(50) NULL
    );

    ALTER TABLE dbo.cf_coupon
    ADD CONSTRAINT FK_cf_coupon_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_coupon_code'
      AND object_id = OBJECT_ID('dbo.cf_coupon')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_coupon_code
    ON dbo.cf_coupon (Code);
END

IF OBJECT_ID('dbo.cf_coupon_usage', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_coupon_usage (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CouponId INT NOT NULL,
        OrderId INT NOT NULL,
        CustomerId INT NOT NULL,
        DiscountAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_coupon_usage_DiscountAmount DEFAULT (0),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_coupon_usage_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_coupon_usage
    ADD CONSTRAINT FK_cf_coupon_usage_coupon FOREIGN KEY (CouponId) REFERENCES dbo.cf_coupon(Id);

    ALTER TABLE dbo.cf_coupon_usage
    ADD CONSTRAINT FK_cf_coupon_usage_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id);

    ALTER TABLE dbo.cf_coupon_usage
    ADD CONSTRAINT FK_cf_coupon_usage_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_coupon_usage_coupon_order'
      AND object_id = OBJECT_ID('dbo.cf_coupon_usage')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_coupon_usage_coupon_order
    ON dbo.cf_coupon_usage (CouponId, OrderId);
END

IF OBJECT_ID('dbo.cf_shop_shipping_config', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_shipping_config (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        DefaultShippingMethodId INT NULL,
        FreeShippingEnabled BIT NOT NULL CONSTRAINT DF_cf_shop_shipping_config_FreeShippingEnabled DEFAULT (0),
        FreeShippingMinOrder DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_shipping_config_FreeShippingMinOrder DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_shipping_config_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_shipping_config_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL
    );

    ALTER TABLE dbo.cf_shop_shipping_config
    ADD CONSTRAINT FK_cf_shop_shipping_config_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);

    ALTER TABLE dbo.cf_shop_shipping_config
    ADD CONSTRAINT FK_cf_shop_shipping_config_method FOREIGN KEY (DefaultShippingMethodId) REFERENCES dbo.cf_shipping_method(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_shop_shipping_config_shop'
      AND object_id = OBJECT_ID('dbo.cf_shop_shipping_config')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_shop_shipping_config_shop
    ON dbo.cf_shop_shipping_config (ShopId);
END

IF OBJECT_ID('dbo.cf_shop_shipping_method', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_shipping_method (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        ShippingMethodId INT NOT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_shipping_method_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_shipping_method_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_shop_shipping_method
    ADD CONSTRAINT FK_cf_shop_shipping_method_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);

    ALTER TABLE dbo.cf_shop_shipping_method
    ADD CONSTRAINT FK_cf_shop_shipping_method_method FOREIGN KEY (ShippingMethodId) REFERENCES dbo.cf_shipping_method(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_shop_shipping_method_shop_method'
      AND object_id = OBJECT_ID('dbo.cf_shop_shipping_method')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_shop_shipping_method_shop_method
    ON dbo.cf_shop_shipping_method (ShopId, ShippingMethodId);
END

IF OBJECT_ID('dbo.cf_shipping_fee_adjustment', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shipping_fee_adjustment (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        OrderId INT NOT NULL,
        ShopOrderId INT NULL,
        ShopId INT NOT NULL,
        CustomerId INT NULL,
        OldShippingMethodId INT NULL,
        NewShippingMethodId INT NULL,
        OldFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shipping_fee_adjustment_OldFee DEFAULT (0),
        NewFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shipping_fee_adjustment_NewFee DEFAULT (0),
        DeltaFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shipping_fee_adjustment_DeltaFee DEFAULT (0),
        Payer NVARCHAR(20) NOT NULL,
        Reason NVARCHAR(200) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shipping_fee_adjustment_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(50) NULL
    );

    ALTER TABLE dbo.cf_shipping_fee_adjustment
    ADD CONSTRAINT FK_cf_shipping_fee_adjustment_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id);

    ALTER TABLE dbo.cf_shipping_fee_adjustment
    ADD CONSTRAINT FK_cf_shipping_fee_adjustment_shop_order FOREIGN KEY (ShopOrderId) REFERENCES dbo.cf_shop_order(Id);

    ALTER TABLE dbo.cf_shipping_fee_adjustment
    ADD CONSTRAINT FK_cf_shipping_fee_adjustment_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);

    ALTER TABLE dbo.cf_shipping_fee_adjustment
    ADD CONSTRAINT FK_cf_shipping_fee_adjustment_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);

    ALTER TABLE dbo.cf_shipping_fee_adjustment
    ADD CONSTRAINT FK_cf_shipping_fee_adjustment_old_method FOREIGN KEY (OldShippingMethodId) REFERENCES dbo.cf_shipping_method(Id);

    ALTER TABLE dbo.cf_shipping_fee_adjustment
    ADD CONSTRAINT FK_cf_shipping_fee_adjustment_new_method FOREIGN KEY (NewShippingMethodId) REFERENCES dbo.cf_shipping_method(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_shipping_fee_adjustment_shop'
      AND object_id = OBJECT_ID('dbo.cf_shipping_fee_adjustment')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shipping_fee_adjustment_shop
    ON dbo.cf_shipping_fee_adjustment (ShopId, CreatedAt DESC);
END

IF OBJECT_ID('dbo.cf_shop_promotion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_promotion (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        DiscountType NVARCHAR(20) NOT NULL,
        DiscountValue DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_promotion_DiscountValue DEFAULT (0),
        StartAt DATETIME NOT NULL,
        EndAt DATETIME NOT NULL,
        AppliesTo NVARCHAR(20) NOT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_promotion_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_promotion_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(50) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(50) NULL
    );

    ALTER TABLE dbo.cf_shop_promotion
    ADD CONSTRAINT FK_cf_shop_promotion_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);
END

IF OBJECT_ID('dbo.cf_shop_promotion_item', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_promotion_item (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PromotionId INT NOT NULL,
        ProductId INT NULL,
        CategoryId INT NULL,
        CollectionId INT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_promotion_item_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_promotion_item_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_shop_promotion_item
    ADD CONSTRAINT FK_cf_shop_promotion_item_promotion FOREIGN KEY (PromotionId) REFERENCES dbo.cf_shop_promotion(Id);

    ALTER TABLE dbo.cf_shop_promotion_item
    ADD CONSTRAINT FK_cf_shop_promotion_item_product FOREIGN KEY (ProductId) REFERENCES dbo.cf_product(Id);

    ALTER TABLE dbo.cf_shop_promotion_item
    ADD CONSTRAINT FK_cf_shop_promotion_item_collection FOREIGN KEY (CollectionId) REFERENCES dbo.cf_collection(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_shop_promotion_item_promotion'
      AND object_id = OBJECT_ID('dbo.cf_shop_promotion_item')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shop_promotion_item_promotion
    ON dbo.cf_shop_promotion_item (PromotionId, Status);
END
