-- Add carrier configuration for shop-level shipping.
-- Keeps existing method configuration intact.

IF COL_LENGTH('dbo.cf_shop_shipping_config', 'DefaultShippingCarrierId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_shipping_config
    ADD DefaultShippingCarrierId INT NULL;

    ALTER TABLE dbo.cf_shop_shipping_config
    ADD CONSTRAINT FK_cf_shop_shipping_config_carrier
        FOREIGN KEY (DefaultShippingCarrierId) REFERENCES dbo.cf_shipping_carrier(Id);
END

IF OBJECT_ID('dbo.cf_shop_shipping_carrier', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_shipping_carrier (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        ShopId INT NOT NULL,
        CarrierId INT NOT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_shipping_carrier_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_shipping_carrier_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        CONSTRAINT FK_cf_shop_shipping_carrier_shop FOREIGN KEY (ShopId)
            REFERENCES dbo.cf_shop(Id),
        CONSTRAINT FK_cf_shop_shipping_carrier_carrier FOREIGN KEY (CarrierId)
            REFERENCES dbo.cf_shipping_carrier(Id),
        CONSTRAINT UQ_cf_shop_shipping_carrier UNIQUE (ShopId, CarrierId)
    );
END

IF COL_LENGTH('dbo.cf_shop_order', 'ShippingCarrierId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_order
    ADD ShippingCarrierId INT NULL;

    ALTER TABLE dbo.cf_shop_order
    ADD CONSTRAINT FK_cf_shop_order_shipping_carrier
        FOREIGN KEY (ShippingCarrierId) REFERENCES dbo.cf_shipping_carrier(Id);
END
