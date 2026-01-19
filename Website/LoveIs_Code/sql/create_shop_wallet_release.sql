-- Wallet release tracking for admin approvals or scheduled release.
-- Run once after taking a backup.

USE LoveIsDB;
GO

IF OBJECT_ID('dbo.cf_shop_wallet_release', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_wallet_release (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        OrderId INT NULL,
        ShopOrderId INT NULL,
        Amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_release_Amount DEFAULT (0),
        ReleaseAt DATETIME NOT NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shop_wallet_release_Status DEFAULT (N'Pending'),
        Note NVARCHAR(1000) NULL,
        ApprovedAt DATETIME NULL,
        ApprovedBy NVARCHAR(100) NULL,
        ReleasedAt DATETIME NULL,
        ReleasedBy NVARCHAR(100) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_wallet_release_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_wallet_release_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_wallet_release_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id),
        CONSTRAINT FK_cf_shop_wallet_release_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id),
        CONSTRAINT FK_cf_shop_wallet_release_shop_order FOREIGN KEY (ShopOrderId) REFERENCES dbo.cf_shop_order(Id)
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_cf_shop_wallet_release_status'
      AND object_id = OBJECT_ID('dbo.cf_shop_wallet_release')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shop_wallet_release_status
    ON dbo.cf_shop_wallet_release (Status, ReleaseAt);
END
GO
