USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_return_request', 'RequestType') IS NULL
BEGIN
    ALTER TABLE dbo.cf_return_request
    ADD RequestType NVARCHAR(20) NULL;
END
GO

IF OBJECT_ID('dbo.cf_wishlist', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_wishlist
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CustomerId INT NOT NULL,
        ProductId INT NOT NULL,
        Status BIT NOT NULL DEFAULT (1),
        CreatedAt DATETIME NOT NULL DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL DEFAULT (0)
    );

    CREATE INDEX IX_cf_wishlist_Customer
        ON dbo.cf_wishlist (CustomerId, Status, CreatedAt DESC);

    CREATE INDEX IX_cf_wishlist_Product
        ON dbo.cf_wishlist (ProductId, Status);
END
GO
