-- Auth and authorization tables for admin users, roles, and permissions.
-- Target database: BeautyStoryDB

USE BeautyStoryDB;
GO

IF OBJECT_ID('dbo.cf_audit_log', 'U') IS NOT NULL
    DROP TABLE dbo.cf_audit_log;
GO

IF OBJECT_ID('dbo.cf_menu_permission', 'U') IS NOT NULL
    DROP TABLE dbo.cf_menu_permission;
GO

IF OBJECT_ID('dbo.cf_menu', 'U') IS NOT NULL
    DROP TABLE dbo.cf_menu;
GO

IF OBJECT_ID('dbo.cf_role_permission', 'U') IS NOT NULL
    DROP TABLE dbo.cf_role_permission;
GO

IF OBJECT_ID('dbo.cf_user_role', 'U') IS NOT NULL
    DROP TABLE dbo.cf_user_role;
GO

IF OBJECT_ID('dbo.cf_permission', 'U') IS NOT NULL
    DROP TABLE dbo.cf_permission;
GO

IF OBJECT_ID('dbo.cf_role', 'U') IS NOT NULL
    DROP TABLE dbo.cf_role;
GO

IF OBJECT_ID('dbo.cf_user', 'U') IS NOT NULL
    DROP TABLE dbo.cf_user;
GO

CREATE TABLE dbo.cf_user (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    DisplayName NVARCHAR(200) NULL,
    Email NVARCHAR(200) NULL,
    PasswordHash VARBINARY(64) NOT NULL,
    PasswordSalt VARBINARY(32) NOT NULL,
    PasswordIterations INT NOT NULL,
    LastLoginAt DATETIME NULL,
    LockedUntil DATETIME NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_user_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_user_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_user_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_user_Username UNIQUE (Username)
);
GO

CREATE TABLE dbo.cf_role (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RoleName NVARCHAR(100) NOT NULL,
    RoleDescription NVARCHAR(300) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_role_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_role_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_role_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_role_RoleName UNIQUE (RoleName)
);
GO

CREATE TABLE dbo.cf_permission (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MenuGroup NVARCHAR(100) NOT NULL,
    ActionName NVARCHAR(100) NOT NULL,
    PermissionName NVARCHAR(200) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_permission_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_permission_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_permission_SortOrder DEFAULT (0),
    CONSTRAINT UQ_cf_permission_MenuGroup_ActionName UNIQUE (MenuGroup, ActionName)
);
GO

CREATE TABLE dbo.cf_user_role (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_user_role_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_user_role_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_user_role_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_user_role_cf_user
        FOREIGN KEY (UserId) REFERENCES dbo.cf_user(Id),
    CONSTRAINT FK_cf_user_role_cf_role
        FOREIGN KEY (RoleId) REFERENCES dbo.cf_role(Id),
    CONSTRAINT UQ_cf_user_role_UserId_RoleId UNIQUE (UserId, RoleId)
);
GO

CREATE TABLE dbo.cf_role_permission (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RoleId INT NOT NULL,
    PermissionId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_role_permission_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_role_permission_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_role_permission_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_role_permission_cf_role
        FOREIGN KEY (RoleId) REFERENCES dbo.cf_role(Id),
    CONSTRAINT FK_cf_role_permission_cf_permission
        FOREIGN KEY (PermissionId) REFERENCES dbo.cf_permission(Id),
    CONSTRAINT UQ_cf_role_permission_RoleId_PermissionId UNIQUE (RoleId, PermissionId)
);
GO

CREATE TABLE dbo.cf_menu (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MenuName NVARCHAR(200) NOT NULL,
    MenuGroup NVARCHAR(100) NOT NULL,
    Url NVARCHAR(300) NULL,
    ParentId INT NULL,
    Icon NVARCHAR(100) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_menu_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_menu_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_menu_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_menu_parent
        FOREIGN KEY (ParentId) REFERENCES dbo.cf_menu(Id),
    CONSTRAINT UQ_cf_menu_MenuGroup_MenuName UNIQUE (MenuGroup, MenuName)
);
GO

CREATE TABLE dbo.cf_menu_permission (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MenuId INT NOT NULL,
    PermissionId INT NOT NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_menu_permission_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_menu_permission_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_menu_permission_SortOrder DEFAULT (0),
    CONSTRAINT FK_cf_menu_permission_cf_menu
        FOREIGN KEY (MenuId) REFERENCES dbo.cf_menu(Id),
    CONSTRAINT FK_cf_menu_permission_cf_permission
        FOREIGN KEY (PermissionId) REFERENCES dbo.cf_permission(Id),
    CONSTRAINT UQ_cf_menu_permission_MenuId_PermissionId UNIQUE (MenuId, PermissionId)
);
GO

CREATE TABLE dbo.cf_audit_log (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TableName NVARCHAR(200) NOT NULL,
    RecordId NVARCHAR(100) NOT NULL,
    ActionName NVARCHAR(50) NOT NULL,
    BeforeData NVARCHAR(MAX) NULL,
    AfterData NVARCHAR(MAX) NULL,
    ActorUserId INT NULL,
    ActorUsername NVARCHAR(100) NULL,
    ActorIp NVARCHAR(50) NULL,
    Status BIT NOT NULL CONSTRAINT DF_cf_audit_log_Status DEFAULT (1),
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_cf_audit_log_CreatedAt DEFAULT (GETDATE()),
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME NULL,
    UpdatedBy NVARCHAR(100) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_cf_audit_log_SortOrder DEFAULT (0)
);
GO

CREATE INDEX IX_cf_permission_MenuGroup ON dbo.cf_permission(MenuGroup);
GO

CREATE INDEX IX_cf_menu_MenuGroup ON dbo.cf_menu(MenuGroup);
GO

CREATE INDEX IX_cf_menu_permission_MenuId ON dbo.cf_menu_permission(MenuId);
GO

CREATE INDEX IX_cf_user_role_UserId ON dbo.cf_user_role(UserId);
GO

CREATE INDEX IX_cf_role_permission_RoleId ON dbo.cf_role_permission(RoleId);
GO
