-- Add profile fields for customer.
-- Run on LoveIsDB.

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

IF COL_LENGTH('dbo.cf_customer', 'Gender') IS NULL
BEGIN
    ALTER TABLE dbo.cf_customer
    ADD Gender INT NULL;
END;
GO

IF COL_LENGTH('dbo.cf_customer', 'BirthDate') IS NULL
BEGIN
    ALTER TABLE dbo.cf_customer
    ADD BirthDate DATE NULL;
END;
GO
