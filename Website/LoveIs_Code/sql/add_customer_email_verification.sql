-- Add email verification columns for customers.
-- Run on LoveIsDB.

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

IF COL_LENGTH('dbo.cf_customer', 'EmailVerified') IS NULL
BEGIN
    ALTER TABLE dbo.cf_customer
    ADD EmailVerified BIT NOT NULL CONSTRAINT DF_cf_customer_EmailVerified DEFAULT (0);
END;
GO

IF COL_LENGTH('dbo.cf_customer', 'EmailVerifyToken') IS NULL
BEGIN
    ALTER TABLE dbo.cf_customer
    ADD EmailVerifyToken NVARCHAR(200) NULL;
END;
GO

IF COL_LENGTH('dbo.cf_customer', 'EmailVerifyExpiresAt') IS NULL
BEGIN
    ALTER TABLE dbo.cf_customer
    ADD EmailVerifyExpiresAt DATETIME NULL;
END;
GO

-- Mark existing accounts as verified to avoid locking out current users.
UPDATE dbo.cf_customer
SET EmailVerified = 1
WHERE EmailVerified = 0 AND CreatedAt < DATEADD(MINUTE, -1, GETUTCDATE());
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_customer_EmailVerifyToken'
      AND object_id = OBJECT_ID('dbo.cf_customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_customer_EmailVerifyToken
    ON dbo.cf_customer (EmailVerifyToken);
END;
