-- Seed shop shipping config and coupons.
-- Run with UTF-8 encoding to preserve Vietnamese labels.

USE LoveIsDB;
GO

DECLARE @DefaultMethodId INT;
DECLARE @DefaultCarrierId INT;

SELECT TOP 1 @DefaultMethodId = Id
FROM dbo.cf_shipping_method
WHERE Status = 1
ORDER BY IsDefault DESC, SortOrder, Id;

SELECT TOP 1 @DefaultCarrierId = Id
FROM dbo.cf_shipping_carrier
WHERE Status = 1
ORDER BY IsDefault DESC, SortOrder, Id;

IF @DefaultMethodId IS NULL
BEGIN
    RAISERROR('Missing default shipping method in cf_shipping_method.', 16, 1);
    RETURN;
END

IF OBJECT_ID('dbo.cf_shop_shipping_config', 'U') IS NULL
BEGIN
    RAISERROR('Missing table cf_shop_shipping_config.', 16, 1);
    RETURN;
END

IF COL_LENGTH('dbo.cf_shop_shipping_config', 'CreatedBy') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_shipping_config
    ADD CreatedBy NVARCHAR(100) NULL;
END

IF COL_LENGTH('dbo.cf_shop_shipping_config', 'SortOrder') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_shipping_config
    ADD SortOrder INT NOT NULL CONSTRAINT DF_cf_shop_shipping_config_SortOrder DEFAULT (0);
END
GO

DECLARE @DefaultMethodId INT;
DECLARE @DefaultCarrierId INT;

SELECT TOP 1 @DefaultMethodId = Id
FROM dbo.cf_shipping_method
WHERE Status = 1
ORDER BY IsDefault DESC, SortOrder, Id;

SELECT TOP 1 @DefaultCarrierId = Id
FROM dbo.cf_shipping_carrier
WHERE Status = 1
ORDER BY IsDefault DESC, SortOrder, Id;

IF @DefaultMethodId IS NULL
BEGIN
    RAISERROR('Missing default shipping method in cf_shipping_method.', 16, 1);
    RETURN;
END

INSERT INTO dbo.cf_shop_shipping_config
    (ShopId, DefaultShippingMethodId, DefaultShippingCarrierId, FreeShippingEnabled, FreeShippingMinOrder, Status, CreatedAt, CreatedBy, SortOrder)
SELECT s.Id, @DefaultMethodId, @DefaultCarrierId, 0, 0, 1, GETDATE(), N'Seed', 0
FROM dbo.cf_shop s
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_shop_shipping_config c WHERE c.ShopId = s.Id
);

-- Admin coupon: fixed 15,000.
IF NOT EXISTS (SELECT 1 FROM dbo.cf_coupon WHERE Code = N'ADMIN15000')
BEGIN
    INSERT INTO dbo.cf_coupon
        (Code, Name, Description, Scope, ShopId, DiscountType, DiscountValue, MinOrder, MaxDiscount, StartAt, EndAt,
         UsageLimit, UsagePerUser, Status, CreatedAt, CreatedBy)
    VALUES
        (N'ADMIN15000', N'Giảm 15.000', N'Mã giảm giá 15.000 do admin tạo',
         N'System', NULL, N'Amount', 15000, 0, NULL, NULL, NULL,
         NULL, NULL, 1, GETDATE(), N'AdminSeed');
END

;WITH RandomShops AS (
    SELECT TOP (5) s.Id
    FROM dbo.cf_shop s
    ORDER BY NEWID()
)
INSERT INTO dbo.cf_coupon
    (Code, Name, Description, Scope, ShopId, DiscountType, DiscountValue, MinOrder, MaxDiscount, StartAt, EndAt,
     UsageLimit, UsagePerUser, Status, CreatedAt, CreatedBy)
SELECT
    N'SHOP' + RIGHT(CONVERT(VARCHAR(12), ABS(CHECKSUM(NEWID()))), 6),
    N'Mã giảm giá shop',
    N'Mã giảm giá do shop tạo ngẫu nhiên',
    N'Shop',
    rs.Id,
    N'Amount',
    CAST((ABS(CHECKSUM(NEWID())) % 80001) + 20000 AS DECIMAL(18,2)),
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    GETDATE(),
    N'Seed'
FROM RandomShops rs
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_coupon c WHERE c.ShopId = rs.Id AND c.Scope = N'Shop'
);
GO
