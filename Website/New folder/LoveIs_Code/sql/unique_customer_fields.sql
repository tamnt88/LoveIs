-- Enforce uniqueness for customer username, email, and phone.
-- Run on LoveIsDB.

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

-- Clean duplicates before applying these constraints if any exist.

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_CfCustomer_Username'
      AND object_id = OBJECT_ID('dbo.cf_customer')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_CfCustomer_Username
    ON dbo.cf_customer (Username);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_CfCustomer_Email'
      AND object_id = OBJECT_ID('dbo.cf_customer')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_CfCustomer_Email
    ON dbo.cf_customer (Email)
    WHERE Email IS NOT NULL AND Email <> '';
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_CfCustomer_Phone'
      AND object_id = OBJECT_ID('dbo.cf_customer')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_CfCustomer_Phone
    ON dbo.cf_customer (Phone)
    WHERE Phone IS NOT NULL AND Phone <> '';
END;
