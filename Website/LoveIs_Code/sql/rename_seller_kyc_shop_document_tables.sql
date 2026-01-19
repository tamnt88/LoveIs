-- Rename legacy seller/shop document tables to cf_ prefixed names.
-- Run once after taking a backup.

IF OBJECT_ID('dbo.seller_kyc_status', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_seller_kyc_status', 'U') IS NULL
    EXEC sp_rename 'dbo.seller_kyc_status', 'cf_seller_kyc_status';

IF OBJECT_ID('dbo.seller_kyc_file_type', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_seller_kyc_file_type', 'U') IS NULL
    EXEC sp_rename 'dbo.seller_kyc_file_type', 'cf_seller_kyc_file_type';

IF OBJECT_ID('dbo.seller_kyc', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_seller_kyc', 'U') IS NULL
    EXEC sp_rename 'dbo.seller_kyc', 'cf_seller_kyc';

IF OBJECT_ID('dbo.seller_kyc_file', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_seller_kyc_file', 'U') IS NULL
    EXEC sp_rename 'dbo.seller_kyc_file', 'cf_seller_kyc_file';

IF OBJECT_ID('dbo.shop_document_status', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_shop_document_status', 'U') IS NULL
    EXEC sp_rename 'dbo.shop_document_status', 'cf_shop_document_status';

IF OBJECT_ID('dbo.shop_document_type', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_shop_document_type', 'U') IS NULL
    EXEC sp_rename 'dbo.shop_document_type', 'cf_shop_document_type';

IF OBJECT_ID('dbo.shop_document_file_type', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_shop_document_file_type', 'U') IS NULL
    EXEC sp_rename 'dbo.shop_document_file_type', 'cf_shop_document_file_type';

IF OBJECT_ID('dbo.shop_document', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_shop_document', 'U') IS NULL
    EXEC sp_rename 'dbo.shop_document', 'cf_shop_document';

IF OBJECT_ID('dbo.shop_document_file', 'U') IS NOT NULL AND OBJECT_ID('dbo.cf_shop_document_file', 'U') IS NULL
    EXEC sp_rename 'dbo.shop_document_file', 'cf_shop_document_file';

-- Optional: rename FK names to keep conventions consistent.
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql + N'EXEC sp_rename ''' + fk.name + ''', ''' + REPLACE(fk.name, 'FK_', 'FK_cf_') + ''', ''OBJECT'';'
FROM sys.foreign_keys fk
WHERE fk.name LIKE 'FK_seller_kyc%' OR fk.name LIKE 'FK_shop_document%';

IF LEN(@sql) > 0
    EXEC sp_executesql @sql;
