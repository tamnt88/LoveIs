SET NOCOUNT ON;

DECLARE @ProductParentId INT;
SELECT @ProductParentId = Id FROM dbo.cf_menu WHERE MenuName = N'Sản phẩm' AND ParentId IS NULL;

IF @ProductParentId IS NULL AND EXISTS (SELECT 1 FROM dbo.cf_menu WHERE Id = 11)
    SET @ProductParentId = 11;

IF @ProductParentId IS NULL
BEGIN
    RAISERROR(N'Không tìm thấy menu cha "Sản phẩm".', 16, 1);
    RETURN;
END

-- Chuẩn hóa lại tên menu theo URL để tránh lỗi font
UPDATE dbo.cf_menu
SET MenuName = N'Danh mục', Icon = N'fa-solid fa-sitemap'
WHERE ParentId = @ProductParentId AND Url = N'/admin/products/categories/default.aspx';

UPDATE dbo.cf_menu
SET MenuName = N'Thương hiệu', Icon = N'fa-solid fa-award'
WHERE ParentId = @ProductParentId AND Url = N'/admin/products/brands/default.aspx';

UPDATE dbo.cf_menu
SET MenuName = N'Xuất xứ', Icon = N'fa-solid fa-flag'
WHERE ParentId = @ProductParentId AND Url = N'/admin/products/origins/default.aspx';

-- Xóa các bản ghi bị lỗi font (có ký tự '?') trùng URL
DELETE m
FROM dbo.cf_menu m
WHERE m.ParentId = @ProductParentId
  AND m.MenuName LIKE N'%?%'
  AND m.Url IN (
        N'/admin/products/categories/default.aspx',
        N'/admin/products/brands/default.aspx',
        N'/admin/products/origins/default.aspx'
      );

-- Giữ lại tối đa 1 menu cho mỗi URL (xóa trùng)
;WITH Duplicates AS (
    SELECT Id,
           Url,
           ROW_NUMBER() OVER (PARTITION BY Url ORDER BY Id DESC) AS rn
    FROM dbo.cf_menu
    WHERE ParentId = @ProductParentId
      AND Url IN (
            N'/admin/products/categories/default.aspx',
            N'/admin/products/brands/default.aspx',
            N'/admin/products/origins/default.aspx'
          )
)
DELETE FROM Duplicates WHERE rn > 1;
