CREATE TABLE [dbo].[cf_order_export_history] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [SellerId] INT NOT NULL,
    [StatusKey] NVARCHAR(50) NULL,
    [SearchCode] NVARCHAR(100) NULL,
    [ShippingMethodId] INT NULL,
    [TotalOrders] INT NOT NULL DEFAULT 0,
    [FileName] NVARCHAR(200) NULL,
    [Status] BIT NOT NULL DEFAULT 1,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] NVARCHAR(100) NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] NVARCHAR(100) NULL,
    [SortOrder] INT NOT NULL DEFAULT 0
);
