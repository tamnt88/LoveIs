IF OBJECT_ID('dbo.cf_community_post_image', 'U') IS NOT NULL DROP TABLE dbo.cf_community_post_image;
IF OBJECT_ID('dbo.cf_community_comment', 'U') IS NOT NULL DROP TABLE dbo.cf_community_comment;
IF OBJECT_ID('dbo.cf_community_like', 'U') IS NOT NULL DROP TABLE dbo.cf_community_like;
IF OBJECT_ID('dbo.cf_community_message', 'U') IS NOT NULL DROP TABLE dbo.cf_community_message;
IF OBJECT_ID('dbo.cf_community_room_member', 'U') IS NOT NULL DROP TABLE dbo.cf_community_room_member;
IF OBJECT_ID('dbo.cf_community_room', 'U') IS NOT NULL DROP TABLE dbo.cf_community_room;
IF OBJECT_ID('dbo.cf_community_notification', 'U') IS NOT NULL DROP TABLE dbo.cf_community_notification;
IF OBJECT_ID('dbo.cf_community_action_log', 'U') IS NOT NULL DROP TABLE dbo.cf_community_action_log;
IF OBJECT_ID('dbo.cf_community_post', 'U') IS NOT NULL DROP TABLE dbo.cf_community_post;

CREATE TABLE dbo.cf_community_post (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    LikeCount INT NOT NULL DEFAULT 0,
    CommentCount INT NOT NULL DEFAULT 0,
    Status BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME NULL
);
CREATE INDEX IX_cf_community_post_customer ON dbo.cf_community_post(CustomerId);
CREATE INDEX IX_cf_community_post_created ON dbo.cf_community_post(CreatedAt DESC);

CREATE TABLE dbo.cf_community_post_image (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PostId INT NOT NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    Status BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_post_image_post ON dbo.cf_community_post_image(PostId);

CREATE TABLE dbo.cf_community_comment (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PostId INT NOT NULL,
    CustomerId INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Status BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_comment_post ON dbo.cf_community_comment(PostId);
CREATE INDEX IX_cf_community_comment_customer ON dbo.cf_community_comment(CustomerId);

CREATE TABLE dbo.cf_community_like (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PostId INT NOT NULL,
    CustomerId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE UNIQUE INDEX UX_cf_community_like ON dbo.cf_community_like(PostId, CustomerId);

CREATE TABLE dbo.cf_community_room (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RoomName NVARCHAR(200) NULL,
    IsGroup BIT NOT NULL DEFAULT 0,
    CreatedBy INT NOT NULL,
    Status BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_room_created ON dbo.cf_community_room(CreatedAt DESC);

CREATE TABLE dbo.cf_community_room_member (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RoomId INT NOT NULL,
    CustomerId INT NOT NULL,
    Role NVARCHAR(50) NULL,
    Status BIT NOT NULL DEFAULT 1,
    JoinedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_room_member_room ON dbo.cf_community_room_member(RoomId);
CREATE UNIQUE INDEX UX_cf_community_room_member ON dbo.cf_community_room_member(RoomId, CustomerId);

CREATE TABLE dbo.cf_community_message (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RoomId INT NOT NULL,
    SenderId INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Status BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_message_room ON dbo.cf_community_message(RoomId);
CREATE INDEX IX_cf_community_message_created ON dbo.cf_community_message(CreatedAt DESC);

CREATE TABLE dbo.cf_community_notification (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    ReferenceId INT NULL,
    Message NVARCHAR(500) NOT NULL,
    IsRead BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_notification_customer ON dbo.cf_community_notification(CustomerId, IsRead, CreatedAt DESC);

CREATE TABLE dbo.cf_community_action_log (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    ActionType NVARCHAR(50) NOT NULL,
    Meta NVARCHAR(500) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_cf_community_action_log_customer ON dbo.cf_community_action_log(CustomerId, ActionType, CreatedAt DESC);
