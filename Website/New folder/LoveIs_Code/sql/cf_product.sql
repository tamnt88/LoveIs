-- Product, variant, attribute, filter, and SEO schema for BeautyStory.
-- All tables use cf_ prefix and common columns as per rules.

USE BeautyStoryDB;
GO

IF OBJECT_ID('dbo.cf_stock_movement', 'U') IS NOT NULL DROP TABLE dbo.cf_stock_movement;
IF OBJECT_ID('dbo.cf_product_variant_attribute', 'U') IS NOT NULL DROP TABLE dbo.cf_product_variant_attribute;
IF OBJECT_ID('dbo.cf_variant_attribute_value', 'U') IS NOT NULL DROP TABLE dbo.cf_variant_attribute_value;
IF OBJECT_ID('dbo.cf_variant_attribute', 'U') IS NOT NULL DROP TABLE dbo.cf_variant_attribute;
IF OBJECT_ID('dbo.cf_product_filter', 'U') IS NOT NULL DROP TABLE dbo.cf_product_filter;
IF OBJECT_ID('dbo.cf_category_filter_group', 'U') IS NOT NULL DROP TABLE dbo.cf_category_filter_group;
IF OBJECT_ID('dbo.cf_filter_option', 'U') IS NOT NULL DROP TABLE dbo.cf_filter_option;
IF OBJECT_ID('dbo.cf_filter_group', 'U') IS NOT NULL DROP TABLE dbo.cf_filter_group;
IF OBJECT_ID('dbo.cf_product_image', 'U') IS NOT NULL DROP TABLE dbo.cf_product_image;
IF OBJECT_ID('dbo.cf_product_variant', 'U') IS NOT NULL DROP TABLE dbo.cf_product_variant;
IF OBJECT_ID('dbo.cf_product', 'U') IS NOT NULL DROP TABLE dbo.cf_product;
IF OBJECT_ID('dbo.cf_origin', 'U') IS NOT NULL DROP TABLE dbo.cf_origin;
IF OBJECT_ID('dbo.cf_brand', 'U') IS NOT NULL DROP TABLE dbo.cf_brand;
IF OBJECT_ID('dbo.cf_category', 'U') IS NOT NULL DROP TABLE dbo.cf_category;
IF OBJECT_ID('dbo.cf_seo_slug', 'U') IS NOT NULL DROP TABLE dbo.cf_seo_slug;
GO

CREATE TABLE dbo.cf_seo_slug (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EntityType NVARCHAR(50) NOT NULL,
    EntityId INT NOT NULL,
    SeoSlug NVARCHAR(200) NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_seo_slug_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_seo_slug_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_seo_slug_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_seo_slug_SeoSlug UNIQUE (SeoSlug)
);
GO

CREATE TABLE dbo.cf_category (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryName NVARCHAR(200) NOT NULL,
    ParentId INT NULL,
    Description NVARCHAR(MAX) NULL,
    IconUrl NVARCHAR(300) NULL,
    LogoUrl NVARCHAR(300) NULL,
    BannerUrl NVARCHAR(300) NULL,
    ViewCount INT NOT NULL CONSTRAINT DF_cf_category_ViewCount DEFAULT (0),
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_category_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_category_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_category_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_category_parent FOREIGN KEY (ParentId) REFERENCES dbo.cf_category(Id)
);
GO

CREATE TABLE dbo.cf_brand (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BrandName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    IconUrl NVARCHAR(300) NULL,
    LogoUrl NVARCHAR(300) NULL,
    BannerUrl NVARCHAR(300) NULL,
    ViewCount INT NOT NULL CONSTRAINT DF_cf_brand_ViewCount DEFAULT (0),
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_brand_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_brand_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_brand_SortOrder DEFAULT (0)
);
GO

CREATE TABLE dbo.cf_origin (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OriginName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    IconUrl NVARCHAR(300) NULL,
    LogoUrl NVARCHAR(300) NULL,
    BannerUrl NVARCHAR(300) NULL,
    ViewCount INT NOT NULL CONSTRAINT DF_cf_origin_ViewCount DEFAULT (0),
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_origin_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_origin_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_origin_SortOrder DEFAULT (0)
);
GO

CREATE TABLE dbo.cf_product (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductName NVARCHAR(300) NOT NULL,
    CategoryId INT NOT NULL,
    BrandId INT NULL,
    OriginId INT NULL,
    ShortDescription NVARCHAR(500) NULL,
    Description NVARCHAR(MAX) NULL,
    Specification NVARCHAR(MAX) NULL,
    Ingredients NVARCHAR(MAX) NULL,
    Usage NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_product_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_product_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_product_category FOREIGN KEY (CategoryId) REFERENCES dbo.cf_category(Id),
    CONSTRAINT FK_cf_product_brand FOREIGN KEY (BrandId) REFERENCES dbo.cf_brand(Id),
    CONSTRAINT FK_cf_product_origin FOREIGN KEY (OriginId) REFERENCES dbo.cf_origin(Id)
);
GO

CREATE TABLE dbo.cf_product_variant (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductId INT NOT NULL,
    VariantName NVARCHAR(200) NULL,
    Sku NVARCHAR(100) NULL,
    Price DECIMAL(18,2) NOT NULL CONSTRAINT DF_cf_product_variant_Price DEFAULT (0),
    SalePrice DECIMAL(18,2) NULL,
    StockQty INT NOT NULL CONSTRAINT DF_cf_product_variant_StockQty DEFAULT (0),
    Description NVARCHAR(MAX) NULL,
    Specification NVARCHAR(MAX) NULL,
    Ingredients NVARCHAR(MAX) NULL,
    Usage NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_product_variant_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_variant_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_product_variant_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_product_variant_product FOREIGN KEY (ProductId) REFERENCES dbo.cf_product(Id)
);
GO

CREATE TABLE dbo.cf_product_image (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductId INT NOT NULL,
    VariantId INT NULL,
    ImageUrl NVARCHAR(300) NOT NULL,
    IsPrimary BIT NOT NULL CONSTRAINT DF_cf_product_image_IsPrimary DEFAULT (0),
    AltText NVARCHAR(200) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_product_image_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_image_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_product_image_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_product_image_product FOREIGN KEY (ProductId) REFERENCES dbo.cf_product(Id),
    CONSTRAINT FK_cf_product_image_variant FOREIGN KEY (VariantId) REFERENCES dbo.cf_product_variant(Id)
);
GO

CREATE TABLE dbo.cf_variant_attribute (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AttributeName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_variant_attribute_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_variant_attribute_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_variant_attribute_SortOrder DEFAULT (0)
);
GO

CREATE TABLE dbo.cf_variant_attribute_value (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AttributeId INT NOT NULL,
    ValueName NVARCHAR(200) NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_variant_attribute_value_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_variant_attribute_value_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_variant_attribute_value_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_variant_attribute_value_attribute FOREIGN KEY (AttributeId) REFERENCES dbo.cf_variant_attribute(Id)
);
GO

CREATE TABLE dbo.cf_product_variant_attribute (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VariantId INT NOT NULL,
    AttributeId INT NOT NULL,
    AttributeValueId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_product_variant_attribute_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_variant_attribute_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_product_variant_attribute_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_product_variant_attribute_variant FOREIGN KEY (VariantId) REFERENCES dbo.cf_product_variant(Id),
    CONSTRAINT FK_cf_product_variant_attribute_attr FOREIGN KEY (AttributeId) REFERENCES dbo.cf_variant_attribute(Id),
    CONSTRAINT FK_cf_product_variant_attribute_value FOREIGN KEY (AttributeValueId) REFERENCES dbo.cf_variant_attribute_value(Id)
);
GO

CREATE TABLE dbo.cf_filter_group (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    GroupName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_filter_group_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_filter_group_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_filter_group_SortOrder DEFAULT (0)
);
GO

CREATE TABLE dbo.cf_filter_option (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    GroupId INT NOT NULL,
    OptionName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(500) NULL,
    SeoKeywords NVARCHAR(300) NULL,
    OgTitle NVARCHAR(200) NULL,
    OgDescription NVARCHAR(500) NULL,
    OgImage NVARCHAR(300) NULL,
    OgType NVARCHAR(50) NULL,
    TwitterTitle NVARCHAR(200) NULL,
    TwitterDescription NVARCHAR(500) NULL,
    TwitterImage NVARCHAR(300) NULL,
    CanonicalUrl NVARCHAR(300) NULL,
    Robots NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_filter_option_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_filter_option_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_filter_option_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_filter_option_group FOREIGN KEY (GroupId) REFERENCES dbo.cf_filter_group(Id)
);
GO

CREATE TABLE dbo.cf_category_filter_group (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryId INT NOT NULL,
    GroupId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_category_filter_group_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_category_filter_group_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_category_filter_group_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_category_filter_group_category FOREIGN KEY (CategoryId) REFERENCES dbo.cf_category(Id),
    CONSTRAINT FK_cf_category_filter_group_group FOREIGN KEY (GroupId) REFERENCES dbo.cf_filter_group(Id),
    CONSTRAINT UQ_cf_category_filter_group UNIQUE (CategoryId, GroupId)
);
GO

CREATE TABLE dbo.cf_product_filter (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductId INT NOT NULL,
    GroupId INT NOT NULL,
    OptionId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_product_filter_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_product_filter_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_product_filter_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_product_filter_product FOREIGN KEY (ProductId) REFERENCES dbo.cf_product(Id),
    CONSTRAINT FK_cf_product_filter_group FOREIGN KEY (GroupId) REFERENCES dbo.cf_filter_group(Id),
    CONSTRAINT FK_cf_product_filter_option FOREIGN KEY (OptionId) REFERENCES dbo.cf_filter_option(Id)
);
GO

CREATE TABLE dbo.cf_stock_movement (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VariantId INT NOT NULL,
    MovementType NVARCHAR(50) NOT NULL, -- In / Out / Adjust
    Quantity INT NOT NULL,
    Note NVARCHAR(300) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_stock_movement_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_stock_movement_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_stock_movement_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_stock_movement_variant FOREIGN KEY (VariantId) REFERENCES dbo.cf_product_variant(Id)
);
GO

CREATE INDEX IX_cf_product_category ON dbo.cf_product(CategoryId);
CREATE INDEX IX_cf_product_variant_product ON dbo.cf_product_variant(ProductId);
CREATE INDEX IX_cf_product_variant_sku ON dbo.cf_product_variant(Sku);
CREATE INDEX IX_cf_product_image_product ON dbo.cf_product_image(ProductId);
CREATE INDEX IX_cf_variant_attribute_value_attr ON dbo.cf_variant_attribute_value(AttributeId);
CREATE INDEX IX_cf_product_filter_product ON dbo.cf_product_filter(ProductId);
CREATE INDEX IX_cf_stock_movement_variant ON dbo.cf_stock_movement(VariantId);
GO
