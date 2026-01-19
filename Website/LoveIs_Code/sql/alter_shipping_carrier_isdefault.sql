-- Add IsDefault for shipping carriers after initial deploy.

IF COL_LENGTH('dbo.cf_shipping_carrier', 'IsDefault') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shipping_carrier
    ADD IsDefault BIT NOT NULL CONSTRAINT DF_cf_shipping_carrier_IsDefault DEFAULT (0);
END

UPDATE dbo.cf_shipping_carrier
SET IsDefault = 1
WHERE Code = N'GHN';
