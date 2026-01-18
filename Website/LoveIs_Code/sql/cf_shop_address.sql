CREATE TABLE [dbo].[cf_shop_address] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ShopId] INT NOT NULL,
    [Title] NVARCHAR(200) NULL,
    [AddressType] NVARCHAR(50) NULL,
    [ContactName] NVARCHAR(120) NULL,
    [Phone] NVARCHAR(30) NULL,
    [AddressLine] NVARCHAR(300) NULL,
    [WardName] NVARCHAR(120) NULL,
    [DistrictName] NVARCHAR(120) NULL,
    [ProvinceName] NVARCHAR(120) NULL,
    [IsDefault] BIT NOT NULL DEFAULT 0,
    [Status] BIT NOT NULL DEFAULT 1,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] NVARCHAR(100) NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] NVARCHAR(100) NULL,
    [SortOrder] INT NOT NULL DEFAULT 0
);
