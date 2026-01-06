-- Seed admin user with PBKDF2 hash (SHA256).
-- Generated from password: 0902232378

USE BeautyStoryDB;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_user WHERE Username = N'admin')
BEGIN
    INSERT INTO dbo.cf_user (
        Username,
        DisplayName,
        PasswordHash,
        PasswordSalt,
        PasswordIterations,
        Status,
        CreatedAt,
        CreatedBy,
        SortOrder
    )
    VALUES (
        N'admin',
        N'Administrator',
        0x3B7468322AA43F47CB21BD70609847810962404FC235D5406410517CDF937726,
        0x15CD3AA004640C6B2FA3A46ABED4AE96,
        100000,
        1,
        GETDATE(),
        N'Seed',
        0
    );
END
GO
