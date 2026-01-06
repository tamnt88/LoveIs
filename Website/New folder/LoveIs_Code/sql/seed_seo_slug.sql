-- Seed SEO slugs for category/brand/origin (global unique).

USE BeautyStoryDB;
GO

DELETE FROM dbo.cf_seo_slug WHERE EntityType IN (N'Category', N'Brand', N'Origin');
GO

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
SELECT N'Category' AS EntityType,
       c.Id AS EntityId,
       base_slug.Slug + N'-' + CAST(c.Id AS NVARCHAR(20)) AS SeoSlug,
       1 AS Status,
       GETDATE() AS CreatedAt,
       N'Seed' AS CreatedBy,
       0 AS SortOrder
FROM dbo.cf_category c
OUTER APPLY (
    SELECT LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), c.CategoryName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and')) AS Slug
) base_slug
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_seo_slug s WHERE s.EntityType = N'Category' AND s.EntityId = c.Id
);
GO

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
SELECT N'Brand' AS EntityType,
       b.Id AS EntityId,
       base_slug.Slug + N'-' + CAST(b.Id AS NVARCHAR(20)) AS SeoSlug,
       1 AS Status,
       GETDATE() AS CreatedAt,
       N'Seed' AS CreatedBy,
       0 AS SortOrder
FROM dbo.cf_brand b
OUTER APPLY (
    SELECT LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), b.BrandName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and')) AS Slug
) base_slug
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_seo_slug s WHERE s.EntityType = N'Brand' AND s.EntityId = b.Id
);
GO

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
SELECT N'Origin' AS EntityType,
       o.Id AS EntityId,
       base_slug.Slug + N'-' + CAST(o.Id AS NVARCHAR(20)) AS SeoSlug,
       1 AS Status,
       GETDATE() AS CreatedAt,
       N'Seed' AS CreatedBy,
       0 AS SortOrder
FROM dbo.cf_origin o
OUTER APPLY (
    SELECT LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), o.OriginName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and')) AS Slug
) base_slug
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.cf_seo_slug s WHERE s.EntityType = N'Origin' AND s.EntityId = o.Id
);
GO
