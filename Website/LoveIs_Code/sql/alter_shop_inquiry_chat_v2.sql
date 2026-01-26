-- Add product context to inquiries + message metadata + attachments.

IF COL_LENGTH('dbo.cf_shop_inquiry', 'ProductId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_inquiry ADD ProductId INT NULL;
END

IF COL_LENGTH('dbo.cf_shop_inquiry', 'VariantId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_inquiry ADD VariantId INT NULL;
END

IF COL_LENGTH('dbo.cf_shop_inquiry', 'LastMessageAt') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_inquiry ADD LastMessageAt DATETIME NULL;
END

IF COL_LENGTH('dbo.cf_shop_inquiry', 'LastMessageSender') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_inquiry ADD LastMessageSender NVARCHAR(20) NULL;
END

IF COL_LENGTH('dbo.cf_shop_inquiry_message', 'MessageType') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_inquiry_message ADD MessageType NVARCHAR(20) NULL;
END

IF COL_LENGTH('dbo.cf_shop_inquiry_message', 'ReadAt') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_inquiry_message ADD ReadAt DATETIME NULL;
END

IF OBJECT_ID('dbo.cf_shop_inquiry_message_file', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_inquiry_message_file (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        MessageId INT NOT NULL,
        FileUrl NVARCHAR(500) NOT NULL,
        FileName NVARCHAR(255) NULL,
        MimeType NVARCHAR(100) NULL,
        FileSize INT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_shop_inquiry_message_file_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_shop_inquiry_message_file_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL
    );

    ALTER TABLE dbo.cf_shop_inquiry_message_file
    ADD CONSTRAINT FK_cf_shop_inquiry_message_file_message
        FOREIGN KEY (MessageId) REFERENCES dbo.cf_shop_inquiry_message(Id);
END
