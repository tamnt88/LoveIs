IF COL_LENGTH('dbo.cf_email_account', 'ContactRecipientEmails') IS NULL
BEGIN
    ALTER TABLE dbo.cf_email_account
    ADD ContactRecipientEmails NVARCHAR(MAX) NULL;
END

IF COL_LENGTH('dbo.cf_email_account', 'OrderRecipientEmails') IS NULL
BEGIN
    ALTER TABLE dbo.cf_email_account
    ADD OrderRecipientEmails NVARCHAR(MAX) NULL;
END
