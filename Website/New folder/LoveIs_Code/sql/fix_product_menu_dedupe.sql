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

DECLARE @IdByName INT;
DECLARE @IdByUrl INT;
DECLARE @KeepId INT;

-- Danh mục
SELECT @IdByName = Id FROM dbo.cf_menu WHERE MenuGroup = N'Admin' AND MenuName = N'Danh mục';
SELECT @IdByUrl = Id FROM dbo.cf_menu WHERE Url = N'/admin/products/categories/default.aspx';
SET @KeepId = COALESCE(@IdByUrl, @IdByName);

IF @KeepId IS NOT NULL
BEGIN
    DELETE FROM dbo.cf_menu WHERE Id <> @KeepId AND (MenuName = N'Danh mục' OR Url = N'/admin/products/categories/default.aspx');
    UPDATE dbo.cf_menu
    SET MenuName = N'Danh mục',
        MenuGroup = N'Admin',
        Url = N'/admin/products/categories/default.aspx',
        ParentId = @ProductParentId,
        Icon = N'fa-solid fa-sitemap'
    WHERE Id = @KeepId;
END

-- Thương hiệu
SELECT @IdByName = Id FROM dbo.cf_menu WHERE MenuGroup = N'Admin' AND MenuName = N'Thương hiệu';
SELECT @IdByUrl = Id FROM dbo.cf_menu WHERE Url = N'/admin/products/brands/default.aspx';
SET @KeepId = COALESCE(@IdByUrl, @IdByName);

IF @KeepId IS NOT NULL
BEGIN
    DELETE FROM dbo.cf_menu WHERE Id <> @KeepId AND (MenuName = N'Thương hiệu' OR Url = N'/admin/products/brands/default.aspx');
    UPDATE dbo.cf_menu
    SET MenuName = N'Thương hiệu',
        MenuGroup = N'Admin',
        Url = N'/admin/products/brands/default.aspx',
        ParentId = @ProductParentId,
        Icon = N'fa-solid fa-award'
    WHERE Id = @KeepId;
END

-- Xuất xứ
SELECT @IdByName = Id FROM dbo.cf_menu WHERE MenuGroup = N'Admin' AND MenuName = N'Xuất xứ';
SELECT @IdByUrl = Id FROM dbo.cf_menu WHERE Url = N'/admin/products/origins/default.aspx';
SET @KeepId = COALESCE(@IdByUrl, @IdByName);

IF @KeepId IS NOT NULL
BEGIN
    DELETE FROM dbo.cf_menu WHERE Id <> @KeepId AND (MenuName = N'Xuất xứ' OR Url = N'/admin/products/origins/default.aspx');
    UPDATE dbo.cf_menu
    SET MenuName = N'Xuất xứ',
        MenuGroup = N'Admin',
        Url = N'/admin/products/origins/default.aspx',
        ParentId = @ProductParentId,
        Icon = N'fa-solid fa-flag'
    WHERE Id = @KeepId;
END

-- Xóa các bản ghi lỗi font còn sót (chỉ trong nhóm sản phẩm)
DELETE FROM dbo.cf_menu
WHERE ParentId = @ProductParentId
  AND MenuName LIKE N'%?%';
