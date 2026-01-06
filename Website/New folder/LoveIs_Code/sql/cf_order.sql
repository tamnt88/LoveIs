IF OBJECT_ID('dbo.cf_order_history', 'U') IS NOT NULL
    DROP TABLE dbo.cf_order_history;
GO

IF OBJECT_ID('dbo.cf_order_item', 'U') IS NOT NULL
    DROP TABLE dbo.cf_order_item;
GO

IF OBJECT_ID('dbo.cf_order', 'U') IS NOT NULL
    DROP TABLE dbo.cf_order;
GO

CREATE TABLE dbo.cf_order (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderCode NVARCHAR(50) NOT NULL,
    CustomerName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    AddressLine NVARCHAR(300) NOT NULL,
    WardId INT NULL,
    ProvinceId INT NULL,
    WardName NVARCHAR(150) NULL,
    ProvinceName NVARCHAR(150) NULL,
    Note NVARCHAR(MAX) NULL,
    InvoiceRequired BIT NOT NULL CONSTRAINT DF_cf_order_InvoiceRequired DEFAULT (0),
    InvoiceCompanyName NVARCHAR(200) NULL,
    InvoiceTaxCode NVARCHAR(50) NULL,
    InvoiceEmail NVARCHAR(200) NULL,
    InvoiceAddress NVARCHAR(300) NULL,
    ShippingMethod NVARCHAR(100) NOT NULL,
    ShippingFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_order_ShippingFee DEFAULT (0),
    ShippingEta NVARCHAR(100) NULL,
    PaymentMethod NVARCHAR(100) NOT NULL,
    PaymentStatus NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_order_PaymentStatus DEFAULT (N'Pending'),
    OrderStatus NVARCHAR(50) NOT NULL CONSTRAINT DF_cf_order_OrderStatus DEFAULT (N'New'),
    Subtotal DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_order_Subtotal DEFAULT (0),
    Discount DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_order_Discount DEFAULT (0),
    Total DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_order_Total DEFAULT (0),
    Status BIT NOT NULL CONSTRAINT DF_cf_order_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_order_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_order_SortOrder DEFAULT (0)
);
GO

CREATE TABLE dbo.cf_order_item (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    VariantId INT NOT NULL,
    ProductName NVARCHAR(300) NOT NULL,
    VariantName NVARCHAR(300) NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_order_item_Price DEFAULT (0),
    SalePrice DECIMAL(18,2) NULL,
    LineTotal DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_order_item_LineTotal DEFAULT (0),
    Status BIT NOT NULL CONSTRAINT DF_cf_order_item_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_order_item_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_order_item_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_order_item_cf_order
        FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id)
);
GO

CREATE TABLE dbo.cf_order_history (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderId INT NOT NULL,
    Action NVARCHAR(200) NOT NULL,
    Note NVARCHAR(MAX) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_order_history_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_order_history_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_order_history_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_order_history_cf_order
        FOREIGN KEY (OrderId) REFERENCES dbo.cf_order(Id)
);
GO

CREATE UNIQUE INDEX IX_cf_order_OrderCode ON dbo.cf_order(OrderCode);
GO
