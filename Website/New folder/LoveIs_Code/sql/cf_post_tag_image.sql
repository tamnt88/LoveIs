IF COL_LENGTH('dbo.cf_post_tag', 'ImageUrl') IS NULL
BEGIN
    ALTER TABLE dbo.cf_post_tag
    ADD ImageUrl NVARCHAR(300) NULL;
END;
