USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_order', 'CustomerId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_order ADD CustomerId INT NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_order_customer')
BEGIN
    ALTER TABLE dbo.cf_order
    ADD CONSTRAINT FK_cf_order_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END
GO
