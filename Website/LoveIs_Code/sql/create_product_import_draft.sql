IF OBJECT_ID('dbo.cf_product_import_batch', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_product_import_batch (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SellerId INT NOT NULL,
        FileName NVARCHAR(255) NULL,
        TotalItems INT NOT NULL CONSTRAINT DF_cf_product_import_batch_TotalItems DEFAULT (0),
        CompletedItems INT NOT NULL CONSTRAINT DF_cf_product_import_batch_CompletedItems DEFAULT (0),
        Status NVARCHAR(30) NOT NULL CONSTRAINT DF_cf_product_import_batch_Status DEFAULT ('draft'),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_import_batch_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL
    );
END

IF OBJECT_ID('dbo.cf_product_import_item', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_product_import_item (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        BatchId INT NOT NULL,
        RowIndex INT NOT NULL,
        ProductName NVARCHAR(255) NULL,
        Description NVARCHAR(MAX) NULL,
        CategoryId INT NULL,
        BrandId INT NULL,
        OriginId INT NULL,
        BaseSku NVARCHAR(100) NULL,
        BasePrice DECIMAL(18,2) NULL,
        BaseSalePrice DECIMAL(18,2) NULL,
        BaseStock INT NULL,
        VariantData NVARCHAR(MAX) NULL,
        PackageWeightGrams DECIMAL(18,2) NULL,
        PackageLengthCm DECIMAL(18,2) NULL,
        PackageWidthCm DECIMAL(18,2) NULL,
        PackageHeightCm DECIMAL(18,2) NULL,
        ImageUrls NVARCHAR(MAX) NULL,
        VideoUrl NVARCHAR(300) NULL,
        IsCompleted BIT NOT NULL CONSTRAINT DF_cf_product_import_item_IsCompleted DEFAULT (0),
        IsDuplicatedSku BIT NOT NULL CONSTRAINT DF_cf_product_import_item_IsDuplicatedSku DEFAULT (0),
        DuplicatedProductId INT NULL,
        LastSavedAt DATETIME NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_import_item_CreatedAt DEFAULT (GETDATE())
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_product_import_item_batch')
BEGIN
    ALTER TABLE dbo.cf_product_import_item
    ADD CONSTRAINT FK_cf_product_import_item_batch
        FOREIGN KEY (BatchId) REFERENCES dbo.cf_product_import_batch(Id);
END
