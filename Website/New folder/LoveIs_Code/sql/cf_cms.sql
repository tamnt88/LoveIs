IF OBJECT_ID('dbo.cf_post_tag_map', 'U') IS NOT NULL
    DROP TABLE dbo.cf_post_tag_map;
GO
IF OBJECT_ID('dbo.cf_post', 'U') IS NOT NULL
    DROP TABLE dbo.cf_post;
GO
IF OBJECT_ID('dbo.cf_post_tag', 'U') IS NOT NULL
    DROP TABLE dbo.cf_post_tag;
GO
IF OBJECT_ID('dbo.cf_post_category', 'U') IS NOT NULL
    DROP TABLE dbo.cf_post_category;
GO

CREATE TABLE dbo.cf_post_category (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ParentId INT NULL,
    CategoryName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ImageUrl NVARCHAR(300) NULL,
    BannerUrl NVARCHAR(300) NULL,
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
    ViewCount INT NOT NULL CONSTRAINT DF_cf_post_category_ViewCount DEFAULT (0),
    Status BIT NOT NULL CONSTRAINT DF_cf_post_category_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_post_category_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_post_category_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_post_category_parent
        FOREIGN KEY (ParentId) REFERENCES dbo.cf_post_category(Id)
);
GO

CREATE TABLE dbo.cf_post_tag (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TagName NVARCHAR(200) NOT NULL,
    ImageUrl NVARCHAR(300) NULL,
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
    ViewCount INT NOT NULL CONSTRAINT DF_cf_post_tag_ViewCount DEFAULT (0),
    Status BIT NOT NULL CONSTRAINT DF_cf_post_tag_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_post_tag_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_post_tag_SortOrder DEFAULT (0)
);
GO

CREATE TABLE dbo.cf_post (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryId INT NOT NULL,
    Title NVARCHAR(300) NOT NULL,
    Summary NVARCHAR(500) NULL,
    Content NVARCHAR(MAX) NULL,
    FeaturedImage NVARCHAR(300) NULL,
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
    ViewCount INT NOT NULL CONSTRAINT DF_cf_post_ViewCount DEFAULT (0),
    Status BIT NOT NULL CONSTRAINT DF_cf_post_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_post_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_post_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_post_cf_post_category
        FOREIGN KEY (CategoryId) REFERENCES dbo.cf_post_category(Id)
);
GO

CREATE TABLE dbo.cf_post_tag_map (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PostId INT NOT NULL,
    TagId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_post_tag_map_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_post_tag_map_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_post_tag_map_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_post_tag_map_post
        FOREIGN KEY (PostId) REFERENCES dbo.cf_post(Id),
    CONSTRAINT FK_cf_post_tag_map_tag
        FOREIGN KEY (TagId) REFERENCES dbo.cf_post_tag(Id),
    CONSTRAINT UQ_cf_post_tag_map UNIQUE (PostId, TagId)
);
GO

CREATE INDEX IX_cf_post_category_Status ON dbo.cf_post_category(Status);
CREATE INDEX IX_cf_post_category_SortOrder ON dbo.cf_post_category(SortOrder);
CREATE INDEX IX_cf_post_category_ParentId ON dbo.cf_post_category(ParentId);
CREATE INDEX IX_cf_post_tag_Status ON dbo.cf_post_tag(Status);
CREATE INDEX IX_cf_post_tag_SortOrder ON dbo.cf_post_tag(SortOrder);
CREATE INDEX IX_cf_post_Status ON dbo.cf_post(Status);
CREATE INDEX IX_cf_post_CategoryId ON dbo.cf_post(CategoryId);
CREATE INDEX IX_cf_post_SortOrder ON dbo.cf_post(SortOrder);
CREATE INDEX IX_cf_post_tag_map_PostId ON dbo.cf_post_tag_map(PostId);
CREATE INDEX IX_cf_post_tag_map_TagId ON dbo.cf_post_tag_map(TagId);
GO
