USE LoveIsDB;
GO

IF OBJECT_ID('dbo.cf_product_review', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_product_review (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ProductId INT NOT NULL,
        CustomerId INT NOT NULL,
        Rating INT NOT NULL,
        Content NVARCHAR(MAX) NULL,
        ImageUrls NVARCHAR(MAX) NULL,
        HelpfulCount INT NOT NULL CONSTRAINT DF_cf_product_review_HelpfulCount DEFAULT (0),
        ReplyContent NVARCHAR(MAX) NULL,
        ReplyAt DATETIME NULL,
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

IF OBJECT_ID('dbo.cf_shop_review', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_review (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        CustomerId INT NOT NULL,
        Rating INT NOT NULL,
        Content NVARCHAR(MAX) NULL,
        QualityRating INT NOT NULL CONSTRAINT DF_cf_shop_review_QualityRating DEFAULT (0),
        DescriptionRating INT NOT NULL CONSTRAINT DF_cf_shop_review_DescriptionRating DEFAULT (0),
        ShippingRating INT NOT NULL CONSTRAINT DF_cf_shop_review_ShippingRating DEFAULT (0),
        ServiceRating INT NOT NULL CONSTRAINT DF_cf_shop_review_ServiceRating DEFAULT (0),
        HelpfulCount INT NOT NULL CONSTRAINT DF_cf_shop_review_HelpfulCount DEFAULT (0),
        ReplyContent NVARCHAR(MAX) NULL,
        ReplyAt DATETIME NULL,
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

IF COL_LENGTH('dbo.cf_product_review', 'ImageUrls') IS NULL
    ALTER TABLE dbo.cf_product_review ADD ImageUrls NVARCHAR(MAX) NULL;
GO
IF COL_LENGTH('dbo.cf_product_review', 'HelpfulCount') IS NULL
    ALTER TABLE dbo.cf_product_review ADD HelpfulCount INT NOT NULL CONSTRAINT DF_cf_product_review_HelpfulCount DEFAULT (0);
GO
IF COL_LENGTH('dbo.cf_product_review', 'ReplyContent') IS NULL
    ALTER TABLE dbo.cf_product_review ADD ReplyContent NVARCHAR(MAX) NULL;
GO
IF COL_LENGTH('dbo.cf_product_review', 'ReplyAt') IS NULL
    ALTER TABLE dbo.cf_product_review ADD ReplyAt DATETIME NULL;
GO

IF COL_LENGTH('dbo.cf_shop_review', 'QualityRating') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD QualityRating INT NOT NULL CONSTRAINT DF_cf_shop_review_QualityRating DEFAULT (0);
GO
IF COL_LENGTH('dbo.cf_shop_review', 'DescriptionRating') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD DescriptionRating INT NOT NULL CONSTRAINT DF_cf_shop_review_DescriptionRating DEFAULT (0);
GO
IF COL_LENGTH('dbo.cf_shop_review', 'ShippingRating') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD ShippingRating INT NOT NULL CONSTRAINT DF_cf_shop_review_ShippingRating DEFAULT (0);
GO
IF COL_LENGTH('dbo.cf_shop_review', 'ServiceRating') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD ServiceRating INT NOT NULL CONSTRAINT DF_cf_shop_review_ServiceRating DEFAULT (0);
GO
IF COL_LENGTH('dbo.cf_shop_review', 'HelpfulCount') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD HelpfulCount INT NOT NULL CONSTRAINT DF_cf_shop_review_HelpfulCount DEFAULT (0);
GO
IF COL_LENGTH('dbo.cf_shop_review', 'ReplyContent') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD ReplyContent NVARCHAR(MAX) NULL;
GO
IF COL_LENGTH('dbo.cf_shop_review', 'ReplyAt') IS NULL
    ALTER TABLE dbo.cf_shop_review ADD ReplyAt DATETIME NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_review_product' AND object_id = OBJECT_ID('dbo.cf_product_review'))
    CREATE INDEX IX_cf_product_review_product ON dbo.cf_product_review(ProductId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_shop_review_shop' AND object_id = OBJECT_ID('dbo.cf_shop_review'))
    CREATE INDEX IX_cf_shop_review_shop ON dbo.cf_shop_review(ShopId);
GO
