-- Shop bank accounts, wallet, payout requests, and wallet ledger.
-- Run once after taking a backup.

USE LoveIsDB;
GO

IF OBJECT_ID('dbo.cf_shop_bank', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_bank (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        BankName NVARCHAR(255) NOT NULL,
        AccountName NVARCHAR(255) NOT NULL,
        AccountNumber NVARCHAR(100) NOT NULL,
        Branch NVARCHAR(255) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_shop_bank_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_bank_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_bank_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_bank_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_bank_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id)
    );
END
GO

IF OBJECT_ID('dbo.cf_shop_wallet', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_wallet (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        Balance DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_Balance DEFAULT (0),
        AvailableBalance DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_AvailableBalance DEFAULT (0),
        PendingBalance DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_PendingBalance DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_wallet_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_wallet_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_wallet_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_wallet_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id),
        CONSTRAINT UQ_cf_shop_wallet_shop UNIQUE (ShopId)
    );
END
GO

IF OBJECT_ID('dbo.cf_shop_wallet_txn', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_wallet_txn (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        OrderId INT NULL,
        ShopOrderId INT NULL,
        Type NVARCHAR(50) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_Amount DEFAULT (0),
        BalanceBefore DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_BalanceBefore DEFAULT (0),
        BalanceAfter DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_BalanceAfter DEFAULT (0),
        AvailableBefore DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_AvailableBefore DEFAULT (0),
        AvailableAfter DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_AvailableAfter DEFAULT (0),
        PendingBefore DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_PendingBefore DEFAULT (0),
        PendingAfter DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_PendingAfter DEFAULT (0),
        Note NVARCHAR(1000) NULL,
        MetaJson NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_wallet_txn_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        CONSTRAINT FK_cf_shop_wallet_txn_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id),
        CONSTRAINT FK_cf_shop_wallet_txn_order FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id),
        CONSTRAINT FK_cf_shop_wallet_txn_shop_order FOREIGN KEY (ShopOrderId) REFERENCES dbo.cf_shop_order(Id)
    );
END
GO

IF OBJECT_ID('dbo.cf_shop_payout_request', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_payout_request (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        BankAccountId INT NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_shop_payout_request_Status DEFAULT (N'Requested'),
        Note NVARCHAR(1000) NULL,
        RequestedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_payout_request_RequestedAt DEFAULT (GETDATE()),
        RequestedBy NVARCHAR(100) NULL,
        ApprovedAt DATETIME NULL,
        ApprovedBy NVARCHAR(100) NULL,
        PaidAt DATETIME NULL,
        PaidBy NVARCHAR(100) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_payout_request_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_payout_request_SortOrder DEFAULT (0),
        CONSTRAINT FK_cf_shop_payout_request_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id),
        CONSTRAINT FK_cf_shop_payout_request_bank FOREIGN KEY (BankAccountId) REFERENCES dbo.cf_shop_bank(Id)
    );
END
GO

IF OBJECT_ID('dbo.cf_shop_payout_proof', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_payout_proof (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PayoutRequestId INT NOT NULL,
        FileUrl NVARCHAR(1000) NOT NULL,
        FileName NVARCHAR(255) NULL,
        UploadedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_payout_proof_UploadedAt DEFAULT (GETDATE()),
        UploadedBy NVARCHAR(100) NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_payout_proof_Status DEFAULT (1),
        CONSTRAINT FK_cf_shop_payout_proof_request FOREIGN KEY (PayoutRequestId) REFERENCES dbo.cf_shop_payout_request(Id)
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_cf_shop_wallet_txn_shop'
      AND object_id = OBJECT_ID('dbo.cf_shop_wallet_txn')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shop_wallet_txn_shop
    ON dbo.cf_shop_wallet_txn (ShopId, CreatedAt);
END
GO
