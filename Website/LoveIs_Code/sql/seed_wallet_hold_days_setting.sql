-- Seed system setting for wallet hold days.
-- Run once after cf_system_setting exists.

USE LoveIsDB;
GO

IF OBJECT_ID('dbo.cf_system_setting', 'U') IS NULL
BEGIN
    RAISERROR('Missing table cf_system_setting.', 16, 1);
    RETURN;
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_setting WHERE [Key] = N'WalletHoldDays')
BEGIN
    INSERT INTO dbo.cf_system_setting ([Key], [Value], [Group], [Description], Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'WalletHoldDays', N'7', N'Wallet', N'Số ngày giữ tiền trước khi giải ngân cho shop', 1, GETDATE(), N'Seed', 10);
END
GO
