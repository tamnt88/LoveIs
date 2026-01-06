-- Seed sample catalog data for cosmetics/beauty products.

USE BeautyStoryDB;
GO

-- Categories (2 levels)
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc da')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc da', NULL, N'Danh mục chăm sóc da', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc tóc')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc tóc', NULL, N'Danh mục chăm sóc tóc', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Trang điểm')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trang điểm', NULL, N'Danh mục trang điểm', 1, GETDATE(), N'Seed', 3);
GO

DECLARE @SkincareId INT;
SELECT @SkincareId = Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc da';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sữa rửa mặt', @SkincareId, N'Sản phẩm làm sạch da', 1, GETDATE(), N'Seed', 1);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Toner')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Toner', @SkincareId, N'Cân bằng da', 1, GETDATE(), N'Seed', 2);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Serum')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Serum', @SkincareId, N'Dưỡng chuyên sâu', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem dưỡng', @SkincareId, N'Khoá ẩm và phục hồi', 1, GETDATE(), N'Seed', 4);
GO

-- Brands
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Beauty Story')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Beauty Story', N'Thương hiệu nội bộ', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Innisfree')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Innisfree', N'Mỹ phẩm thiên nhiên Hàn Quốc', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'La Roche-Posay', N'Dược mỹ phẩm Pháp', 1, GETDATE(), N'Seed', 3);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'The Ordinary')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'The Ordinary', N'Hoạt chất tối giản', 1, GETDATE(), N'Seed', 4);
GO

-- Origins
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hàn Quốc', N'Xuất xứ Hàn Quốc', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhật Bản', N'Xuất xứ Nhật Bản', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Pháp')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Pháp', N'Xuất xứ Pháp', 1, GETDATE(), N'Seed', 3);
GO

-- Variant attributes
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung tích')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dung tích', N'Ml / g', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Mùi hương')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mùi hương', N'Hương sản phẩm', 1, GETDATE(), N'Seed', 2);
GO

DECLARE @VolumeAttrId INT;
SELECT @VolumeAttrId = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung tích';

IF @VolumeAttrId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @VolumeAttrId AND ValueName = N'30ml')
        INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@VolumeAttrId, N'30ml', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @VolumeAttrId AND ValueName = N'50ml')
        INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@VolumeAttrId, N'50ml', 1, GETDATE(), N'Seed', 2);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @VolumeAttrId AND ValueName = N'100ml')
        INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@VolumeAttrId, N'100ml', 1, GETDATE(), N'Seed', 3);
END
GO

-- Filter groups
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dòng sản phẩm', N'Dòng sản phẩm', 1, GETDATE(), N'Seed', 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Vấn đề da')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vấn đề da', N'Vấn đề về da', 1, GETDATE(), N'Seed', 2);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thành phần nổi bật', N'Thành phần nổi bật', 1, GETDATE(), N'Seed', 3);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Loại da')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Loại da', N'Loại da', 1, GETDATE(), N'Seed', 4);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Công dụng chính', N'Công dụng chính', 1, GETDATE(), N'Seed', 5);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Giới tính', N'Giới tính', 1, GETDATE(), N'Seed', 6);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đặc tính', N'Đặc tính', 1, GETDATE(), N'Seed', 7);
GO

-- Filter options (sample)
DECLARE @SkinConcernId INT, @SkinTypeId INT, @BenefitId INT, @GenderId INT, @FeatureId INT, @LineId INT, @IngredientId INT;
SELECT @LineId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm';
SELECT @SkinConcernId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Vấn đề da';
SELECT @IngredientId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật';
SELECT @SkinTypeId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại da';
SELECT @BenefitId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính';
SELECT @GenderId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính';
SELECT @FeatureId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính';

IF @LineId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @LineId AND OptionName = N'Hydrating')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@LineId, N'Hydrating', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @LineId AND OptionName = N'Brightening')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@LineId, N'Brightening', 1, GETDATE(), N'Seed', 2);
END

IF @SkinConcernId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @SkinConcernId AND OptionName = N'Mụn')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@SkinConcernId, N'Mụn', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @SkinConcernId AND OptionName = N'Thâm')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@SkinConcernId, N'Thâm', 1, GETDATE(), N'Seed', 2);
END

IF @IngredientId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @IngredientId AND OptionName = N'Niacinamide')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@IngredientId, N'Niacinamide', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @IngredientId AND OptionName = N'Hyaluronic Acid')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@IngredientId, N'Hyaluronic Acid', 1, GETDATE(), N'Seed', 2);
END

IF @SkinTypeId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @SkinTypeId AND OptionName = N'Da dầu')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@SkinTypeId, N'Da dầu', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @SkinTypeId AND OptionName = N'Da khô')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@SkinTypeId, N'Da khô', 1, GETDATE(), N'Seed', 2);
END

IF @BenefitId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @BenefitId AND OptionName = N'Cấp ẩm')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@BenefitId, N'Cấp ẩm', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @BenefitId AND OptionName = N'Làm sáng')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@BenefitId, N'Làm sáng', 1, GETDATE(), N'Seed', 2);
END

IF @GenderId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GenderId AND OptionName = N'Unisex')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@GenderId, N'Unisex', 1, GETDATE(), N'Seed', 1);
END

IF @FeatureId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @FeatureId AND OptionName = N'Thuần chay')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@FeatureId, N'Thuần chay', 1, GETDATE(), N'Seed', 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @FeatureId AND OptionName = N'Không paraben')
        INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES (@FeatureId, N'Không paraben', 1, GETDATE(), N'Seed', 2);
END
GO

-- Map filter groups to skincare category
DECLARE @SkincareId2 INT;
SELECT @SkincareId2 = Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc da';

IF @SkincareId2 IS NOT NULL
BEGIN
    DECLARE @GroupId INT;
    DECLARE group_cursor CURSOR FOR
        SELECT Id FROM dbo.cf_filter_group;
    OPEN group_cursor;
    FETCH NEXT FROM group_cursor INTO @GroupId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @SkincareId2 AND GroupId = @GroupId)
            INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
            VALUES (@SkincareId2, @GroupId, 1, GETDATE(), N'Seed', 0);
        FETCH NEXT FROM group_cursor INTO @GroupId;
    END
    CLOSE group_cursor;
    DEALLOCATE group_cursor;
END
GO
