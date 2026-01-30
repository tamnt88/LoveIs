IF OBJECT_ID('dbo.cf_support_ticket_category', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_ticket_category (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_support_ticket_category_SortOrder DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_support_ticket_category_Status DEFAULT (1)
    );
END

IF OBJECT_ID('dbo.cf_support_ticket_status', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_ticket_status (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_support_ticket_status_SortOrder DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_support_ticket_status_Status DEFAULT (1)
    );
END

IF OBJECT_ID('dbo.cf_support_ticket_priority', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_ticket_priority (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_cf_support_ticket_priority_SortOrder DEFAULT (0),
        Status BIT NOT NULL CONSTRAINT DF_cf_support_ticket_priority_Status DEFAULT (1)
    );
END

IF OBJECT_ID('dbo.cf_support_ticket', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_ticket (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SellerId INT NOT NULL,
        Title NVARCHAR(300) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        CategoryId INT NOT NULL,
        StatusId INT NOT NULL,
        PriorityId INT NOT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_support_ticket_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL
    );
END

IF OBJECT_ID('dbo.cf_support_ticket_message', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_ticket_message (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        TicketId INT NOT NULL,
        SenderType NVARCHAR(20) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_support_ticket_message_CreatedAt DEFAULT (GETDATE())
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_support_ticket_category')
BEGIN
    ALTER TABLE dbo.cf_support_ticket
    ADD CONSTRAINT FK_cf_support_ticket_category
        FOREIGN KEY (CategoryId) REFERENCES dbo.cf_support_ticket_category(Id);
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_support_ticket_status')
BEGIN
    ALTER TABLE dbo.cf_support_ticket
    ADD CONSTRAINT FK_cf_support_ticket_status
        FOREIGN KEY (StatusId) REFERENCES dbo.cf_support_ticket_status(Id);
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_support_ticket_priority')
BEGIN
    ALTER TABLE dbo.cf_support_ticket
    ADD CONSTRAINT FK_cf_support_ticket_priority
        FOREIGN KEY (PriorityId) REFERENCES dbo.cf_support_ticket_priority(Id);
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_support_ticket_message_ticket')
BEGIN
    ALTER TABLE dbo.cf_support_ticket_message
    ADD CONSTRAINT FK_cf_support_ticket_message_ticket
        FOREIGN KEY (TicketId) REFERENCES dbo.cf_support_ticket(Id);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_category WHERE Code = 'order_shipping')
BEGIN
    INSERT INTO dbo.cf_support_ticket_category (Code, Name, SortOrder, Status)
    VALUES ('order_shipping', N'Đơn hàng & Giao hàng', 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_category WHERE Code = 'payment_wallet')
BEGIN
    INSERT INTO dbo.cf_support_ticket_category (Code, Name, SortOrder, Status)
    VALUES ('payment_wallet', N'Thanh toán & Ví', 2, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_category WHERE Code = 'product_catalog')
BEGIN
    INSERT INTO dbo.cf_support_ticket_category (Code, Name, SortOrder, Status)
    VALUES ('product_catalog', N'Sản phẩm & Danh mục', 3, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_category WHERE Code = 'marketing')
BEGIN
    INSERT INTO dbo.cf_support_ticket_category (Code, Name, SortOrder, Status)
    VALUES ('marketing', N'Khuyến mãi & Marketing', 4, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_category WHERE Code = 'account_security')
BEGIN
    INSERT INTO dbo.cf_support_ticket_category (Code, Name, SortOrder, Status)
    VALUES ('account_security', N'Tài khoản & Bảo mật', 5, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_category WHERE Code = 'system')
BEGIN
    INSERT INTO dbo.cf_support_ticket_category (Code, Name, SortOrder, Status)
    VALUES ('system', N'Kỹ thuật hệ thống', 6, 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_status WHERE Code = 'pending')
BEGIN
    INSERT INTO dbo.cf_support_ticket_status (Code, Name, SortOrder, Status)
    VALUES ('pending', N'Chờ xử lý', 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_status WHERE Code = 'processing')
BEGIN
    INSERT INTO dbo.cf_support_ticket_status (Code, Name, SortOrder, Status)
    VALUES ('processing', N'Đang xử lý', 2, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_status WHERE Code = 'resolved')
BEGIN
    INSERT INTO dbo.cf_support_ticket_status (Code, Name, SortOrder, Status)
    VALUES ('resolved', N'Đã giải quyết', 3, 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_priority WHERE Code = 'low')
BEGIN
    INSERT INTO dbo.cf_support_ticket_priority (Code, Name, SortOrder, Status)
    VALUES ('low', N'Thấp', 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_priority WHERE Code = 'medium')
BEGIN
    INSERT INTO dbo.cf_support_ticket_priority (Code, Name, SortOrder, Status)
    VALUES ('medium', N'TB', 2, 1);
END
IF NOT EXISTS (SELECT 1 FROM dbo.cf_support_ticket_priority WHERE Code = 'high')
BEGIN
    INSERT INTO dbo.cf_support_ticket_priority (Code, Name, SortOrder, Status)
    VALUES ('high', N'Cao', 3, 1);
END
