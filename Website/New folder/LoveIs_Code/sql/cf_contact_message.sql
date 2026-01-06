IF OBJECT_ID('dbo.cf_contact_message', 'U') IS NOT NULL
    DROP TABLE dbo.cf_contact_message;

CREATE TABLE dbo.cf_contact_message (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FullName NVARCHAR(200) NULL,
    Phone NVARCHAR(50) NULL,
    Email NVARCHAR(200) NULL,
    Subject NVARCHAR(300) NULL,
    Message NVARCHAR(MAX) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_contact_message_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_contact_message_CreatedAt DEFAULT (GETDATE())
);
