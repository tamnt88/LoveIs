IF OBJECT_ID('dbo.cf_support_chat', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_chat (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SellerId INT NOT NULL,
        AdminId INT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_support_chat_CreatedAt DEFAULT (GETDATE()),
        LastMessageAt DATETIME NULL,
        LastMessageSender NVARCHAR(20) NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_support_chat_Status DEFAULT (1)
    );
END

IF OBJECT_ID('dbo.cf_support_chat_message', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_chat_message (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ChatId INT NOT NULL,
        SenderType NVARCHAR(20) NOT NULL,
        MessageType NVARCHAR(20) NOT NULL,
        Message NVARCHAR(MAX) NULL,
        ReadAt DATETIME NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_support_chat_message_CreatedAt DEFAULT (GETDATE())
    );
END

IF OBJECT_ID('dbo.cf_support_chat_message_file', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_support_chat_message_file (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        MessageId INT NOT NULL,
        FileUrl NVARCHAR(500) NOT NULL,
        FileName NVARCHAR(255) NULL,
        MimeType NVARCHAR(100) NULL,
        FileSize INT NULL,
        Status BIT NOT NULL CONSTRAINT DF_cf_support_chat_message_file_Status DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_support_chat_message_file_CreatedAt DEFAULT (GETDATE()),
        CreatedBy NVARCHAR(100) NULL
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_support_chat_message_chat')
BEGIN
    ALTER TABLE dbo.cf_support_chat_message
    ADD CONSTRAINT FK_cf_support_chat_message_chat
        FOREIGN KEY (ChatId) REFERENCES dbo.cf_support_chat(Id);
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cf_support_chat_message_file_message')
BEGIN
    ALTER TABLE dbo.cf_support_chat_message_file
    ADD CONSTRAINT FK_cf_support_chat_message_file_message
        FOREIGN KEY (MessageId) REFERENCES dbo.cf_support_chat_message(Id);
END
