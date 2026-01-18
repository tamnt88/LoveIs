IF COL_LENGTH('dbo.cf_community_comment', 'ParentId') IS NULL
BEGIN
    ALTER TABLE dbo.cf_community_comment
    ADD ParentId INT NULL;
END

IF OBJECT_ID('dbo.cf_community_comment_like', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cf_community_comment_like (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CommentId INT NOT NULL,
        CustomerId INT NOT NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_community_comment_like_CreatedAt DEFAULT (GETDATE())
    );

    ALTER TABLE dbo.cf_community_comment_like
    ADD CONSTRAINT FK_cf_community_comment_like_comment FOREIGN KEY (CommentId) REFERENCES dbo.cf_community_comment(Id);

    ALTER TABLE dbo.cf_community_comment_like
    ADD CONSTRAINT FK_cf_community_comment_like_customer FOREIGN KEY (CustomerId) REFERENCES dbo.cf_customer(Id);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_cf_community_comment_like_comment_customer'
      AND object_id = OBJECT_ID('dbo.cf_community_comment_like')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_cf_community_comment_like_comment_customer
    ON dbo.cf_community_comment_like (CommentId, CustomerId);
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_cf_community_comment_like_comment'
      AND object_id = OBJECT_ID('dbo.cf_community_comment_like')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_cf_community_comment_like_comment
    ON dbo.cf_community_comment_like (CommentId, CreatedAt DESC);
END
