-- Add bank/card tracking fields for payment transactions.
-- Run once after taking a backup.

USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_payment_transaction', 'BankCode') IS NULL
BEGIN
    ALTER TABLE dbo.cf_payment_transaction
    ADD BankCode NVARCHAR(50) NULL;
END

IF COL_LENGTH('dbo.cf_payment_transaction', 'BankName') IS NULL
BEGIN
    ALTER TABLE dbo.cf_payment_transaction
    ADD BankName NVARCHAR(255) NULL;
END

IF COL_LENGTH('dbo.cf_payment_transaction', 'CardType') IS NULL
BEGIN
    ALTER TABLE dbo.cf_payment_transaction
    ADD CardType NVARCHAR(50) NULL;
END

IF COL_LENGTH('dbo.cf_payment_transaction', 'CardNumber') IS NULL
BEGIN
    ALTER TABLE dbo.cf_payment_transaction
    ADD CardNumber NVARCHAR(50) NULL;
END

IF COL_LENGTH('dbo.cf_payment_transaction', 'ResponseCode') IS NULL
BEGIN
    ALTER TABLE dbo.cf_payment_transaction
    ADD ResponseCode NVARCHAR(20) NULL;
END
GO
