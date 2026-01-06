SET NOCOUNT ON;

DECLARE @Source TABLE (
    CategoryId INT NOT NULL,
    CategoryName NVARCHAR(200) NOT NULL
);

INSERT INTO @Source (CategoryId, CategoryName)
SELECT c.Id, c.CategoryName
FROM dbo.cf_category c
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_seo_slug s
    WHERE s.EntityType = N'Category' AND s.EntityId = c.Id
);

DECLARE @From NVARCHAR(200) = N'àáảãạâầấẩẫậăằắẳẵặèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';
DECLARE @To NVARCHAR(200) = N'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
SELECT
    N'Category',
    s.CategoryId,
    CONCAT(
        LOWER(
            LTRIM(RTRIM(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                    TRANSLATE(s.CategoryName, @From, @To),
                N'/', N'-'), N'&', N''), N',', N''), N'.', N''), N'(', N''), N')', N''), N'  ', N' '), N' ', N'-')
            ))
        ),
        N'-',
        s.CategoryId
    ),
    1,
    GETDATE(),
    N'Seed',
    0
FROM @Source s;
