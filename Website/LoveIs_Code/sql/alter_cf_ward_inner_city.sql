-- Add IsInnerCity flag for ward-level inner-city configuration.
-- Run with UTF-8 encoding to preserve Vietnamese labels.

USE LoveIsDB;
GO

IF COL_LENGTH('dbo.cf_ward', 'IsInnerCity') IS NULL
BEGIN
    ALTER TABLE dbo.cf_ward
    ADD IsInnerCity BIT NOT NULL CONSTRAINT DF_cf_ward_IsInnerCity DEFAULT (0);
END
GO
