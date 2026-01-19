-- Shipping carriers and carrier-method mapping.
-- Keep cf_shipping_method as service definitions (standard/express).
-- Carriers (A/B/C) are defined in cf_shipping_carrier.

IF OBJECT_ID('dbo.cf_shipping_carrier', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shipping_carrier (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(255) NOT NULL,
        Description NVARCHAR(1000) NULL,
        ContactName NVARCHAR(255) NULL,
        ContactPhone NVARCHAR(50) NULL,
        ContactEmail NVARCHAR(255) NULL,
        LogoUrl NVARCHAR(500) NULL,
        ClientId NVARCHAR(255) NULL,
        ShopId NVARCHAR(255) NULL,
        ApiToken NVARCHAR(255) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_cf_shipping_carrier_IsDefault DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_shipping_carrier_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shipping_carrier_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_shipping_carrier_SortOrder DEFAULT (0),
        CONSTRAINT UQ_cf_shipping_carrier_Code UNIQUE (Code)
    );
END

IF OBJECT_ID('dbo.cf_shipping_carrier_method', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shipping_carrier_method (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CarrierId INT NOT NULL,
        ShippingMethodId INT NOT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shipping_carrier_method_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shipping_carrier_method_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        CONSTRAINT FK_cf_shipping_carrier_method_carrier FOREIGN KEY (CarrierId)
            REFERENCES dbo.cf_shipping_carrier(Id),
        CONSTRAINT FK_cf_shipping_carrier_method_method FOREIGN KEY (ShippingMethodId)
            REFERENCES dbo.cf_shipping_method(Id),
        CONSTRAINT UQ_cf_shipping_carrier_method UNIQUE (CarrierId, ShippingMethodId)
    );
END

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_cf_shipping_carrier_method_method'
      AND object_id = OBJECT_ID('dbo.cf_shipping_carrier_method')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shipping_carrier_method_method
    ON dbo.cf_shipping_carrier_method (ShippingMethodId, CarrierId);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_shipping_carrier WHERE Code = N'GHN')
BEGIN
    INSERT INTO dbo.cf_shipping_carrier (Code, Name, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'GHN', N'Giao hàng nhanh', N'Hãng giao hàng nhanh', 1, GETDATE(), N'Seed', 1);
END

UPDATE dbo.cf_shipping_carrier
SET IsDefault = 1
WHERE Code = N'GHN' AND IsDefault = 0;

IF NOT EXISTS (SELECT 1 FROM dbo.cf_shipping_carrier WHERE Code = N'VTPOST')
BEGIN
    INSERT INTO dbo.cf_shipping_carrier (Code, Name, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'VTPOST', N'Viettel Post', N'Hãng Viettel Post', 1, GETDATE(), N'Seed', 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_shipping_carrier WHERE Code = N'VNPOST')
BEGIN
    INSERT INTO dbo.cf_shipping_carrier (Code, Name, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'VNPOST', N'VN Post', N'Hãng VN Post', 1, GETDATE(), N'Seed', 3);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_shipping_carrier WHERE Code = N'GHTK')
BEGIN
    INSERT INTO dbo.cf_shipping_carrier (Code, Name, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'GHTK', N'Giao hàng tiết kiệm', N'Hãng giao hàng tiết kiệm', 1, GETDATE(), N'Seed', 4);
END

INSERT INTO dbo.cf_shipping_carrier_method (CarrierId, ShippingMethodId, Status, CreatedAt, CreatedBy)
SELECT c.Id, m.Id, 1, GETDATE(), N'Seed'
FROM dbo.cf_shipping_carrier c
CROSS JOIN dbo.cf_shipping_method m
WHERE c.Code IN (N'GHN', N'VTPOST', N'VNPOST', N'GHTK')
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.cf_shipping_carrier_method cm
      WHERE cm.CarrierId = c.Id
        AND cm.ShippingMethodId = m.Id
  );
