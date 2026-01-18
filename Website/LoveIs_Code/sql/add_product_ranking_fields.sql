IF COL_LENGTH('dbo.cf_product', 'StockTotal') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD StockTotal INT NOT NULL CONSTRAINT DF_cf_product_StockTotal DEFAULT (0);
END

IF COL_LENGTH('dbo.cf_product', 'MaxDiscountPercent') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD MaxDiscountPercent DECIMAL(6,4) NOT NULL CONSTRAINT DF_cf_product_MaxDiscountPercent DEFAULT (0);
END

IF COL_LENGTH('dbo.cf_product', 'ReturnRate30d') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD ReturnRate30d DECIMAL(6,4) NOT NULL CONSTRAINT DF_cf_product_ReturnRate30d DEFAULT (0);
END

IF COL_LENGTH('dbo.cf_product', 'CancelRate30d') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD CancelRate30d DECIMAL(6,4) NOT NULL CONSTRAINT DF_cf_product_CancelRate30d DEFAULT (0);
END

IF COL_LENGTH('dbo.cf_product', 'ViewCount30d') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD ViewCount30d INT NOT NULL CONSTRAINT DF_cf_product_ViewCount30d DEFAULT (0);
END

IF COL_LENGTH('dbo.cf_product', 'IsViolation') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
    ADD IsViolation BIT NOT NULL CONSTRAINT DF_cf_product_IsViolation DEFAULT (0);
END
