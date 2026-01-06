IF COL_LENGTH('dbo.cf_product', 'IsNewArrival') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
        ADD IsNewArrival BIT NOT NULL CONSTRAINT DF_cf_product_IsNewArrival DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'IsTrending') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
        ADD IsTrending BIT NOT NULL CONSTRAINT DF_cf_product_IsTrending DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'IsBestSelling') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
        ADD IsBestSelling BIT NOT NULL CONSTRAINT DF_cf_product_IsBestSelling DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'ViewCount') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
        ADD ViewCount INT NOT NULL CONSTRAINT DF_cf_product_ViewCount DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.cf_product', 'AddToCartCount') IS NULL
BEGIN
    ALTER TABLE dbo.cf_product
        ADD AddToCartCount INT NOT NULL CONSTRAINT DF_cf_product_AddToCartCount DEFAULT (0);
END
GO
