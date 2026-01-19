-- Seller KYC + Shop documents schema
USE LoveIsDB;
GO

IF OBJECT_ID('dbo.cf_seller_kyc_status', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_seller_kyc_status
    (
        Code NVARCHAR(20) NOT NULL PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL DEFAULT(0),
        Status BIT NOT NULL DEFAULT(1)
    );

    INSERT INTO dbo.cf_seller_kyc_status (Code, Name, SortOrder, Status)
    VALUES (N'pending', N'Ch? duy?t', 1, 1),
           (N'approved', N'Ðã duy?t', 2, 1),
           (N'rejected', N'T? ch?i', 3, 1);
END
GO

IF OBJECT_ID('dbo.cf_shop_document_status', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_document_status
    (
        Code NVARCHAR(20) NOT NULL PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL DEFAULT(0),
        Status BIT NOT NULL DEFAULT(1)
    );

    INSERT INTO dbo.cf_shop_document_status (Code, Name, SortOrder, Status)
    VALUES (N'pending', N'Ch? duy?t', 1, 1),
           (N'approved', N'Ðã duy?t', 2, 1),
           (N'rejected', N'T? ch?i', 3, 1);
END
GO

IF OBJECT_ID('dbo.cf_seller_kyc_file_type', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_seller_kyc_file_type
    (
        Code NVARCHAR(50) NOT NULL PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL DEFAULT(0),
        Status BIT NOT NULL DEFAULT(1)
    );

    INSERT INTO dbo.cf_seller_kyc_file_type (Code, Name, SortOrder, Status)
    VALUES (N'cccd_front', N'CCCD m?t tru?c', 1, 1),
           (N'cccd_back', N'CCCD m?t sau', 2, 1),
           (N'selfie_with_cccd', N'Selfie c?m CCCD', 3, 1);
END
GO

IF OBJECT_ID('dbo.cf_shop_document_type', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_document_type
    (
        Code NVARCHAR(50) NOT NULL PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL DEFAULT(0),
        Status BIT NOT NULL DEFAULT(1)
    );

    INSERT INTO dbo.cf_shop_document_type (Code, Name, SortOrder, Status)
    VALUES (N'business_license', N'Gi?y phép kinh doanh', 1, 1),
           (N'tax_certificate', N'Mã s? thu?', 2, 1),
           (N'authorization_letter', N'Gi?y ?y quy?n', 3, 1),
           (N'lease_contract', N'H?p d?ng thuê', 4, 1);
END
GO

IF OBJECT_ID('dbo.cf_shop_document_file_type', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_document_file_type
    (
        Code NVARCHAR(50) NOT NULL PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        SortOrder INT NOT NULL DEFAULT(0),
        Status BIT NOT NULL DEFAULT(1)
    );

    INSERT INTO dbo.cf_shop_document_file_type (Code, Name, SortOrder, Status)
    VALUES (N'business_license', N'Gi?y phép kinh doanh', 1, 1),
           (N'tax_certificate', N'Mã s? thu?', 2, 1),
           (N'authorization_letter', N'Gi?y ?y quy?n', 3, 1),
           (N'lease_contract', N'H?p d?ng thuê', 4, 1);
END
GO

IF OBJECT_ID('dbo.cf_seller_kyc', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_seller_kyc
    (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SellerId INT NOT NULL,
        FullName NVARCHAR(200) NULL,
        BirthDate DATE NULL,
        IdNumber NVARCHAR(50) NULL,
        IdIssuedDate DATE NULL,
        IdIssuedPlace NVARCHAR(200) NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT(N'pending'),
        RejectedReason NVARCHAR(500) NULL,
        ReviewedAt DATETIME NULL,
        ReviewedBy NVARCHAR(100) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL
    );

    CREATE INDEX IX_cf_seller_kyc_SellerId ON dbo.cf_seller_kyc (SellerId);
END
GO

IF OBJECT_ID('dbo.FK_cf_seller_kyc_seller', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller_kyc
    ADD CONSTRAINT FK_cf_seller_kyc_seller
        FOREIGN KEY (SellerId) REFERENCES dbo.cf_seller(Id);
END
GO

IF OBJECT_ID('dbo.cf_seller_kyc_file', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_seller_kyc_file
    (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SellerKycId INT NOT NULL,
        FileType NVARCHAR(50) NOT NULL,
        FileUrl NVARCHAR(500) NOT NULL,
        FileName NVARCHAR(200) NULL,
        FileSize INT NULL,
        MimeType NVARCHAR(100) NULL,
        Status BIT NOT NULL DEFAULT(1),
        CreatedAt DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL
    );

    CREATE INDEX IX_cf_seller_kyc_file_KycId ON dbo.cf_seller_kyc_file (SellerKycId);
END
GO

IF OBJECT_ID('dbo.FK_cf_seller_kyc_file_kyc', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller_kyc_file
    ADD CONSTRAINT FK_cf_seller_kyc_file_kyc
        FOREIGN KEY (SellerKycId) REFERENCES dbo.cf_seller_kyc(Id);
END
GO

IF OBJECT_ID('dbo.cf_shop_document', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_document
    (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopId INT NOT NULL,
        DocType NVARCHAR(50) NOT NULL,
        DocNumber NVARCHAR(100) NULL,
        IssuedDate DATE NULL,
        ExpiredDate DATE NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT(N'pending'),
        RejectedReason NVARCHAR(500) NULL,
        ReviewedAt DATETIME NULL,
        ReviewedBy NVARCHAR(100) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL
    );

    CREATE INDEX IX_cf_shop_document_ShopId ON dbo.cf_shop_document (ShopId);
END
GO

IF OBJECT_ID('dbo.FK_cf_shop_document_shop', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_document
    ADD CONSTRAINT FK_cf_shop_document_shop
        FOREIGN KEY (ShopId) REFERENCES dbo.cf_shop(Id);
END
GO

IF OBJECT_ID('dbo.cf_shop_document_file', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_shop_document_file
    (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ShopDocumentId INT NOT NULL,
        FileType NVARCHAR(50) NOT NULL,
        FileUrl NVARCHAR(500) NOT NULL,
        FileName NVARCHAR(200) NULL,
        FileSize INT NULL,
        MimeType NVARCHAR(100) NULL,
        Status BIT NOT NULL DEFAULT(1),
        CreatedAt DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy NVARCHAR(100) NULL,
        UpdatedAt DATETIME NULL,
        UpdatedBy NVARCHAR(100) NULL
    );

    CREATE INDEX IX_cf_shop_document_file_DocId ON dbo.cf_shop_document_file (ShopDocumentId);
END
GO

IF OBJECT_ID('dbo.FK_cf_shop_document_file_doc', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_document_file
    ADD CONSTRAINT FK_cf_shop_document_file_doc
        FOREIGN KEY (ShopDocumentId) REFERENCES dbo.cf_shop_document(Id);
END
GO
IF OBJECT_ID('dbo.FK_cf_seller_kyc_status', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller_kyc
    ADD CONSTRAINT FK_cf_seller_kyc_status
        FOREIGN KEY (Status) REFERENCES dbo.cf_seller_kyc_status(Code);
END
GO

IF OBJECT_ID('dbo.FK_cf_seller_kyc_file_type', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_seller_kyc_file
    ADD CONSTRAINT FK_cf_seller_kyc_file_type
        FOREIGN KEY (FileType) REFERENCES dbo.cf_seller_kyc_file_type(Code);
END
GO

IF OBJECT_ID('dbo.FK_cf_shop_document_status', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_document
    ADD CONSTRAINT FK_cf_shop_document_status
        FOREIGN KEY (Status) REFERENCES dbo.cf_shop_document_status(Code);
END
GO

IF OBJECT_ID('dbo.FK_cf_shop_document_type', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_document
    ADD CONSTRAINT FK_cf_shop_document_type
        FOREIGN KEY (DocType) REFERENCES dbo.cf_shop_document_type(Code);
END
GO

IF OBJECT_ID('dbo.FK_cf_shop_document_file_type', 'F') IS NULL
BEGIN
    ALTER TABLE dbo.cf_shop_document_file
    ADD CONSTRAINT FK_cf_shop_document_file_type
        FOREIGN KEY (FileType) REFERENCES dbo.cf_shop_document_file_type(Code);
END
GO

