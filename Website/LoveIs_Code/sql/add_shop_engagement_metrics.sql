IF COL_LENGTH('dbo.cf_shop', 'ResponseRate') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop
    ADD ResponseRate DECIMAL(5,2) NULL;
END

IF COL_LENGTH('dbo.cf_shop', 'ResponseTimeMinutes') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop
    ADD ResponseTimeMinutes INT NULL;
END

IF COL_LENGTH('dbo.cf_shop', 'FollowerCount') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop
    ADD FollowerCount INT NOT NULL CONSTRAINT DF_cf_shop_FollowerCount DEFAULT (0);
END

IF OBJECT_ID('dbo.cf_shop_follow', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_follow (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        CustomerId INT NOT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_follow_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_follow_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL
    );

    ALTER TABLE dbo.cf_shop_follow
    ADD CONSTRAINT FK_cf_shop_follow_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);

    ALTER TABLE dbo.cf_shop_follow
    ADD CONSTRAINT FK_cf_shop_follow_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_shop_follow_shop_customer'
      AND object_id = OBJECT_ID('dbo.cf_shop_follow')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_shop_follow_shop_customer
    ON dbo.cf_shop_follow (ShopId, CustomerId);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_shop_follow_shop_status'
      AND object_id = OBJECT_ID('dbo.cf_shop_follow')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shop_follow_shop_status
    ON dbo.cf_shop_follow (ShopId, Status, CreatedAt DESC);
END

IF OBJECT_ID('dbo.cf_shop_inquiry', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_inquiry (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        CustomerId INT NOT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_inquiry_CreatedAt DEFAULT (GETDATE()),
        FirstReplyAt DATETIME NULL,
        LastReplyAt DATETIME NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_inquiry_Status DEFAULT (1)
    );

    ALTER TABLE dbo.cf_shop_inquiry
    ADD CONSTRAINT FK_cf_shop_inquiry_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);

    ALTER TABLE dbo.cf_shop_inquiry
    ADD CONSTRAINT FK_cf_shop_inquiry_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_shop_inquiry_shop_created'
      AND object_id = OBJECT_ID('dbo.cf_shop_inquiry')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shop_inquiry_shop_created
    ON dbo.cf_shop_inquiry (ShopId, CreatedAt DESC);
END

IF OBJECT_ID('dbo.cf_shop_inquiry_message', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_inquiry_message (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        InquiryId INT NOT NULL,
        ShopId INT NOT NULL,
        CustomerId INT NOT NULL,
        SenderType NVARCHAR(20) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_inquiry_message_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_shop_inquiry_message
    ADD CONSTRAINT FK_cf_shop_inquiry_message_inquiry FOREIGN KEY (InquiryId) REFERENCES dbo.cf_shop_inquiry(Id);

    ALTER TABLE dbo.cf_shop_inquiry_message
    ADD CONSTRAINT FK_cf_shop_inquiry_message_shop FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);

    ALTER TABLE dbo.cf_shop_inquiry_message
    ADD CONSTRAINT FK_cf_shop_inquiry_message_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_shop_inquiry_message_inquiry_created'
      AND object_id = OBJECT_ID('dbo.cf_shop_inquiry_message')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_shop_inquiry_message_inquiry_created
    ON dbo.cf_shop_inquiry_message (InquiryId, CreatedAt DESC);
END

IF NOT EXISTS (
    SELECT 1
    FROM dbo.cf_menu
    WHERE MenuGroup = 'SellerSidebar' AND MenuName = 'Chat'
)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ('Chat', 'SellerSidebar', NULL, NULL, 'fa-regular fa-comments', 1, GETDATE(), 'Seed', 15);
END

DECLARE @SellerChatMenuId INT;
SELECT @SellerChatMenuId = Id
FROM dbo.cf_menu
WHERE MenuGroup = 'SellerSidebar' AND MenuName = 'Chat';

IF @SellerChatMenuId IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM dbo.cf_menu
    WHERE MenuGroup = 'SellerSidebar' AND MenuName = 'Chat voi khach hang'
)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ('Chat voi khach hang', 'SellerSidebar', '/seller/chat.aspx', @SellerChatMenuId, NULL, 1, GETDATE(), 'Seed', 1);
END
