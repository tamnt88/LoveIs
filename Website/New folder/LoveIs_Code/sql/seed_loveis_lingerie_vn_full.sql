SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DELETE FROM dbo.cf_order_history;
    DELETE FROM dbo.cf_order_item;
    DELETE FROM dbo.cf_order;

    DELETE FROM dbo.cf_brand_showcase_banner;
    DELETE FROM dbo.cf_brand_showcase;

    DELETE FROM dbo.cf_product_filter;
    DELETE FROM dbo.cf_category_filter_group;
    DELETE FROM dbo.cf_filter_option;
    DELETE FROM dbo.cf_filter_group;
    DELETE FROM dbo.cf_product_variant_attribute;
    DELETE FROM dbo.cf_product_image;
    DELETE FROM dbo.cf_product_variant;
    DELETE FROM dbo.cf_product;
    DELETE FROM dbo.cf_variant_attribute_value;
    DELETE FROM dbo.cf_variant_attribute;
    DELETE FROM dbo.cf_brand;
    DELETE FROM dbo.cf_origin;
    DELETE FROM dbo.cf_category;

    DELETE FROM dbo.cf_seo_slug
    WHERE EntityType IN (N'Category', N'Brand', N'Origin', N'Product');

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    DECLARE @CatNu INT;
    DECLARE @CatNam INT;
    DECLARE @CatShapewear INT;
    DECLARE @CatSleepwear INT;
    DECLARE @CatPhuKien INT;
    DECLARE @CatDoNha INT;
    DECLARE @CatTheThao INT;
    DECLARE @CatMeBau INT;
    DECLARE @CatTreEm INT;
    DECLARE @CatSale INT;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ lót nữ', NULL, 1, @Now, @SeedBy, 1);
    SET @CatNu = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ lót nam', NULL, 1, @Now, @SeedBy, 2);
    SET @CatNam = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ định hình', NULL, 1, @Now, @SeedBy, 3);
    SET @CatShapewear = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ ngủ', NULL, 1, @Now, @SeedBy, 4);
    SET @CatSleepwear = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Phụ kiện', NULL, 1, @Now, @SeedBy, 5);
    SET @CatPhuKien = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ mặc nhà', NULL, 1, @Now, @SeedBy, 6);
    SET @CatDoNha = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ thể thao', NULL, 1, @Now, @SeedBy, 7);
    SET @CatTheThao = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ bầu & sau sinh', NULL, 1, @Now, @SeedBy, 8);
    SET @CatMeBau = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ lót trẻ em', NULL, 1, @Now, @SeedBy, 9);
    SET @CatTreEm = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sale & combo', NULL, 1, @Now, @SeedBy, 10);
    SET @CatSale = SCOPE_IDENTITY();

    DECLARE @CatBra INT;
    DECLARE @CatBralette INT;
    DECLARE @CatPanty INT;
    DECLARE @CatSet INT;
    DECLARE @CatThong INT;
    DECLARE @CatSeamless INT;
    DECLARE @CatSportBra INT;
    DECLARE @CatBraSpecial INT;
    DECLARE @CatMenBoxer INT;
    DECLARE @CatMenBrief INT;
    DECLARE @CatMenTank INT;
    DECLARE @CatMenSet INT;
    DECLARE @CatMenThermal INT;
    DECLARE @CatMenModal INT;
    DECLARE @CatShaperBodysuit INT;
    DECLARE @CatShaperCorset INT;
    DECLARE @CatShaperShort INT;
    DECLARE @CatShaperLegging INT;
    DECLARE @CatSleepDress INT;
    DECLARE @CatSleepSet INT;
    DECLARE @CatSleepKimono INT;
    DECLARE @CatSleepBaby INT;
    DECLARE @CatPhuKienDayAo INT;
    DECLARE @CatPhuKienMiengDan INT;
    DECLARE @CatPhuKienVo INT;
    DECLARE @CatPhuKienBoBao INT;
    DECLARE @CatPhuKienTuiGiat INT;
    DECLARE @CatDoNhaSet INT;
    DECLARE @CatDoNhaVay INT;
    DECLARE @CatDoNhaAoChoang INT;
    DECLARE @CatTheThaoBra INT;
    DECLARE @CatTheThaoSet INT;
    DECLARE @CatMeBauBra INT;
    DECLARE @CatMeBauQuan INT;
    DECLARE @CatTreEmNu INT;
    DECLARE @CatTreEmNam INT;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực', @CatNu, 1, @Now, @SeedBy, 1);
    SET @CatBra = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bralette', @CatNu, 1, @Now, @SeedBy, 2);
    SET @CatBralette = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần lót nữ', @CatNu, 1, @Now, @SeedBy, 3);
    SET @CatPanty = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ đồ lót', @CatNu, 1, @Now, @SeedBy, 4);
    SET @CatSet = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thong/G-String', @CatNu, 1, @Now, @SeedBy, 5);
    SET @CatThong = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Không đường may', @CatNu, 1, @Now, @SeedBy, 6);
    SET @CatSeamless = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực thể thao', @CatNu, 1, @Now, @SeedBy, 7);
    SET @CatSportBra = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực đặc biệt', @CatNu, 1, @Now, @SeedBy, 8);
    SET @CatBraSpecial = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Boxer nam', @CatNam, 1, @Now, @SeedBy, 1);
    SET @CatMenBoxer = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Brief nam', @CatNam, 1, @Now, @SeedBy, 2);
    SET @CatMenBrief = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo lót nam', @CatNam, 1, @Now, @SeedBy, 3);
    SET @CatMenTank = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ đồ lót nam', @CatNam, 1, @Now, @SeedBy, 4);
    SET @CatMenSet = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Giữ nhiệt nam', @CatNam, 1, @Now, @SeedBy, 5);
    SET @CatMenThermal = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Modal nam', @CatNam, 1, @Now, @SeedBy, 6);
    SET @CatMenModal = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bodysuit định hình', @CatShapewear, 1, @Now, @SeedBy, 1);
    SET @CatShaperBodysuit = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Corset định hình', @CatShapewear, 1, @Now, @SeedBy, 2);
    SET @CatShaperCorset = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần định hình', @CatShapewear, 1, @Now, @SeedBy, 3);
    SET @CatShaperShort = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Legging định hình', @CatShapewear, 1, @Now, @SeedBy, 4);
    SET @CatShaperLegging = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Váy ngủ', @CatSleepwear, 1, @Now, @SeedBy, 1);
    SET @CatSleepDress = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ ngủ', @CatSleepwear, 1, @Now, @SeedBy, 2);
    SET @CatSleepSet = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo choàng ngủ', @CatSleepwear, 1, @Now, @SeedBy, 3);
    SET @CatSleepKimono = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Baby doll', @CatSleepwear, 1, @Now, @SeedBy, 4);
    SET @CatSleepBaby = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dây áo', @CatPhuKien, 1, @Now, @SeedBy, 1);
    SET @CatPhuKienDayAo = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Miếng dán ngực', @CatPhuKien, 1, @Now, @SeedBy, 2);
    SET @CatPhuKienMiengDan = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vớ/Stocking', @CatPhuKien, 1, @Now, @SeedBy, 3);
    SET @CatPhuKienVo = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ bảo quản', @CatPhuKien, 1, @Now, @SeedBy, 4);
    SET @CatPhuKienBoBao = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Túi giặt đồ lót', @CatPhuKien, 1, @Now, @SeedBy, 5);
    SET @CatPhuKienTuiGiat = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ mặc nhà', @CatDoNha, 1, @Now, @SeedBy, 1);
    SET @CatDoNhaSet = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Váy mặc nhà', @CatDoNha, 1, @Now, @SeedBy, 2);
    SET @CatDoNhaVay = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo choàng', @CatDoNha, 1, @Now, @SeedBy, 3);
    SET @CatDoNhaAoChoang = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bra thể thao', @CatTheThao, 1, @Now, @SeedBy, 1);
    SET @CatTheThaoBra = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set thể thao', @CatTheThao, 1, @Now, @SeedBy, 2);
    SET @CatTheThaoSet = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực cho con bú', @CatMeBau, 1, @Now, @SeedBy, 1);
    SET @CatMeBauBra = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần bầu', @CatMeBau, 1, @Now, @SeedBy, 2);
    SET @CatMeBauQuan = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bé gái', @CatTreEm, 1, @Now, @SeedBy, 1);
    SET @CatTreEmNu = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bé trai', @CatTreEm, 1, @Now, @SeedBy, 2);
    SET @CatTreEmNam = SCOPE_IDENTITY();

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực push-up', @CatBra, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực không gọng', @CatBra, 1, @Now, @SeedBy, 2);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực ren', @CatBra, 1, @Now, @SeedBy, 3);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực nâng ngực', @CatBra, 1, @Now, @SeedBy, 4);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần lót bikini', @CatPanty, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần lót cạp cao', @CatPanty, 1, @Now, @SeedBy, 2);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần lót cotton', @CatPanty, 1, @Now, @SeedBy, 3);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quần lót ren', @CatPanty, 1, @Now, @SeedBy, 4);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thong ren', @CatThong, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thong trơn', @CatThong, 1, @Now, @SeedBy, 2);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thong cạp thấp', @CatThong, 1, @Now, @SeedBy, 3);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bodysuit full-body', @CatShaperBodysuit, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bodysuit nâng ngực', @CatShaperBodysuit, 1, @Now, @SeedBy, 2);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Corset định hình bụng', @CatShaperCorset, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Corset định hình eo', @CatShaperCorset, 1, @Now, @SeedBy, 2);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Váy ngủ lụa', @CatSleepDress, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Váy ngủ ren', @CatSleepDress, 1, @Now, @SeedBy, 2);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Váy ngủ satin', @CatSleepDress, 1, @Now, @SeedBy, 3);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ ngủ satin', @CatSleepSet, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bộ ngủ cotton', @CatSleepSet, 1, @Now, @SeedBy, 2);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bra thể thao nâng đỡ', @CatTheThaoBra, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bra thể thao không gọng', @CatTheThaoBra, 1, @Now, @SeedBy, 2);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực cho con bú cotton', @CatMeBauBra, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Áo ngực cho con bú không gọng', @CatMeBauBra, 1, @Now, @SeedBy, 2);

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ lót bé gái', @CatTreEmNu, 1, @Now, @SeedBy, 1);
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đồ lót bé trai', @CatTreEmNam, 1, @Now, @SeedBy, 1);

    INSERT INTO dbo.cf_brand (BrandName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'LoveIs', 1, @Now, @SeedBy, 1),
        (N'Lụa Mềm', 1, @Now, @SeedBy, 2),
        (N'Ren Nét', 1, @Now, @SeedBy, 3),
        (N'Form Chuẩn', 1, @Now, @SeedBy, 4),
        (N'GentleMan', 1, @Now, @SeedBy, 5),
        (N'Cloudy', 1, @Now, @SeedBy, 6),
        (N'Mượt Mà', 1, @Now, @SeedBy, 7),
        (N'Active Soft', 1, @Now, @SeedBy, 8),
        (N'Baby Soft', 1, @Now, @SeedBy, 9),
        (N'Comfort Pro', 1, @Now, @SeedBy, 10);

    INSERT INTO dbo.cf_origin (OriginName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Việt Nam', 1, @Now, @SeedBy, 1),
        (N'Thái Lan', 1, @Now, @SeedBy, 2),
        (N'Nhật Bản', 1, @Now, @SeedBy, 3),
        (N'Hàn Quốc', 1, @Now, @SeedBy, 4),
        (N'Trung Quốc', 1, @Now, @SeedBy, 5),
        (N'Pháp', 1, @Now, @SeedBy, 6),
        (N'Ý', 1, @Now, @SeedBy, 7),
        (N'Mỹ', 1, @Now, @SeedBy, 8),
        (N'Đức', 1, @Now, @SeedBy, 9),
        (N'Úc', 1, @Now, @SeedBy, 10);

    DECLARE @AttrSize INT;
    DECLARE @AttrCup INT;
    DECLARE @AttrColor INT;
    DECLARE @AttrMaterial INT;
    DECLARE @AttrStyle INT;

    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Kích cỡ', N'Kích cỡ sản phẩm', 1, @Now, @SeedBy, 1),
        (N'Cúp', N'Cỡ cúp áo ngực', 1, @Now, @SeedBy, 2),
        (N'Màu sắc', N'Màu sắc sản phẩm', 1, @Now, @SeedBy, 3),
        (N'Chất liệu', N'Chất liệu vải', 1, @Now, @SeedBy, 4),
        (N'Kiểu dáng', N'Kiểu dáng thiết kế', 1, @Now, @SeedBy, 5);

    SELECT @AttrSize = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Kích cỡ';
    SELECT @AttrCup = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Cúp';
    SELECT @AttrColor = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Màu sắc';
    SELECT @AttrMaterial = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Chất liệu';
    SELECT @AttrStyle = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Kiểu dáng';

    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@AttrSize, N'XS', 1, @Now, @SeedBy, 1),
        (@AttrSize, N'S', 1, @Now, @SeedBy, 2),
        (@AttrSize, N'M', 1, @Now, @SeedBy, 3),
        (@AttrSize, N'L', 1, @Now, @SeedBy, 4),
        (@AttrSize, N'XL', 1, @Now, @SeedBy, 5),
        (@AttrSize, N'XXL', 1, @Now, @SeedBy, 6),
        (@AttrCup, N'A', 1, @Now, @SeedBy, 1),
        (@AttrCup, N'B', 1, @Now, @SeedBy, 2),
        (@AttrCup, N'C', 1, @Now, @SeedBy, 3),
        (@AttrCup, N'D', 1, @Now, @SeedBy, 4),
        (@AttrCup, N'DD', 1, @Now, @SeedBy, 5),
        (@AttrCup, N'E', 1, @Now, @SeedBy, 6),
        (@AttrColor, N'Đen', 1, @Now, @SeedBy, 1),
        (@AttrColor, N'Trắng', 1, @Now, @SeedBy, 2),
        (@AttrColor, N'Nude', 1, @Now, @SeedBy, 3),
        (@AttrColor, N'Đỏ rượu', 1, @Now, @SeedBy, 4),
        (@AttrColor, N'Hồng phấn', 1, @Now, @SeedBy, 5),
        (@AttrColor, N'Xanh navy', 1, @Now, @SeedBy, 6),
        (@AttrColor, N'Xanh rêu', 1, @Now, @SeedBy, 7),
        (@AttrColor, N'Tím mận', 1, @Now, @SeedBy, 8),
        (@AttrColor, N'Be', 1, @Now, @SeedBy, 9),
        (@AttrColor, N'Nâu mocha', 1, @Now, @SeedBy, 10),
        (@AttrMaterial, N'Cotton', 1, @Now, @SeedBy, 1),
        (@AttrMaterial, N'Ren', 1, @Now, @SeedBy, 2),
        (@AttrMaterial, N'Lụa', 1, @Now, @SeedBy, 3),
        (@AttrMaterial, N'Satin', 1, @Now, @SeedBy, 4),
        (@AttrMaterial, N'Microfiber', 1, @Now, @SeedBy, 5),
        (@AttrMaterial, N'Lưới', 1, @Now, @SeedBy, 6),
        (@AttrStyle, N'Bralette', 1, @Now, @SeedBy, 1),
        (@AttrStyle, N'Push-up', 1, @Now, @SeedBy, 2),
        (@AttrStyle, N'Balconette', 1, @Now, @SeedBy, 3),
        (@AttrStyle, N'Full-coverage', 1, @Now, @SeedBy, 4),
        (@AttrStyle, N'Không gọng', 1, @Now, @SeedBy, 5),
        (@AttrStyle, N'Cạp cao', 1, @Now, @SeedBy, 6),
        (@AttrStyle, N'Thong', 1, @Now, @SeedBy, 7),
        (@AttrStyle, N'Brief', 1, @Now, @SeedBy, 8),
        (@AttrStyle, N'Boxer', 1, @Now, @SeedBy, 9),
        (@AttrStyle, N'Bikini', 1, @Now, @SeedBy, 10),
        (@AttrStyle, N'Boyshort', 1, @Now, @SeedBy, 11),
        (@AttrStyle, N'G-string', 1, @Now, @SeedBy, 12),
        (@AttrStyle, N'Váy ngủ', 1, @Now, @SeedBy, 13),
        (@AttrStyle, N'Bodysuit', 1, @Now, @SeedBy, 14),
        (@AttrStyle, N'Corset', 1, @Now, @SeedBy, 15);

    DECLARE @GroupSize INT;
    DECLARE @GroupCup INT;
    DECLARE @GroupColor INT;
    DECLARE @GroupMaterial INT;
    DECLARE @GroupStyle INT;

    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Kích cỡ', N'Lọc theo kích cỡ', 1, @Now, @SeedBy, 1),
        (N'Cúp', N'Lọc theo cúp', 1, @Now, @SeedBy, 2),
        (N'Màu sắc', N'Lọc theo màu', 1, @Now, @SeedBy, 3),
        (N'Chất liệu', N'Lọc theo chất liệu', 1, @Now, @SeedBy, 4),
        (N'Kiểu dáng', N'Lọc theo kiểu dáng', 1, @Now, @SeedBy, 5);

    SELECT @GroupSize = Id FROM dbo.cf_filter_group WHERE GroupName = N'Kích cỡ';
    SELECT @GroupCup = Id FROM dbo.cf_filter_group WHERE GroupName = N'Cúp';
    SELECT @GroupColor = Id FROM dbo.cf_filter_group WHERE GroupName = N'Màu sắc';
    SELECT @GroupMaterial = Id FROM dbo.cf_filter_group WHERE GroupName = N'Chất liệu';
    SELECT @GroupStyle = Id FROM dbo.cf_filter_group WHERE GroupName = N'Kiểu dáng';

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupSize, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrSize;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupCup, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrCup;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupColor, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrColor;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupMaterial, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrMaterial;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupStyle, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrStyle;

    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT c.Id,
           fg.Id,
           1,
           @Now,
           @SeedBy,
           fg.SortOrder
    FROM dbo.cf_category c
    JOIN dbo.cf_filter_group fg ON fg.Status = 1
    WHERE c.ParentId IS NOT NULL
      AND (c.CategoryName LIKE N'%Áo ngực%' OR c.CategoryName LIKE N'%Bralette%' OR c.CategoryName LIKE N'%Bộ đồ lót%')

    UNION ALL

    SELECT c.Id,
           fg.Id,
           1,
           @Now,
           @SeedBy,
           fg.SortOrder
    FROM dbo.cf_category c
    JOIN dbo.cf_filter_group fg ON fg.Status = 1
    WHERE c.ParentId IS NOT NULL
      AND fg.GroupName IN (N'Kích cỡ', N'Màu sắc', N'Chất liệu', N'Kiểu dáng')
      AND c.CategoryName NOT LIKE N'%Áo ngực%'
      AND c.CategoryName NOT LIKE N'%Bralette%'
      AND c.CategoryName NOT LIKE N'%Bộ đồ lót%';

    IF OBJECT_ID('tempdb..#NewProducts') IS NOT NULL DROP TABLE #NewProducts;
    CREATE TABLE #NewProducts (Id INT NOT NULL, CategoryId INT NOT NULL);

    ;WITH N AS (
        SELECT TOP (3000)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO dbo.cf_product
    (
        ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description,
        Specification, Ingredients, Usage, Status, CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.CategoryId INTO #NewProducts (Id, CategoryId)
    SELECT
        c.CategoryName + N' ' + RIGHT(N'0000' + CAST(n AS NVARCHAR(10)), 4),
        c.Id,
        b.Id,
        o.Id,
        N'Thiết kế ôm dáng, mềm mại và thoáng khí.',
        N'Mô tả sản phẩm đồ lót đang được cập nhật.',
        N'Thông số sản phẩm đang được cập nhật.',
        N'Chất liệu theo thuộc tính sản phẩm.',
        N'Hướng dẫn bảo quản đang được cập nhật.',
        1,
        DATEADD(MINUTE, -n, @Now),
        @SeedBy,
        n
    FROM N
    CROSS APPLY (
        SELECT TOP 1 Id, CategoryName FROM dbo.cf_category
        WHERE ParentId IS NOT NULL AND Status = 1
        ORDER BY NEWID()
    ) c
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_brand WHERE Status = 1 ORDER BY NEWID()) b
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_origin WHERE Status = 1 ORDER BY NEWID()) o;

    IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
    CREATE TABLE #NewVariants (VariantId INT NOT NULL, ProductId INT NOT NULL);

    INSERT INTO dbo.cf_product_variant
    (
        ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
        CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.ProductId INTO #NewVariants (VariantId, ProductId)
    SELECT
        p.Id,
        N'Tiêu chuẩn',
        N'LI-' + CAST(p.Id AS NVARCHAR(10)) + N'-01',
        CAST(ROUND(150000 + (ABS(CHECKSUM(NEWID())) % 650000), 0) AS DECIMAL(18,2)),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
             THEN CAST(ROUND(120000 + (ABS(CHECKSUM(NEWID())) % 450000), 0) AS DECIMAL(18,2))
             ELSE NULL END,
        20 + (ABS(CHECKSUM(NEWID())) % 200),
        1,
        DATEADD(MINUTE, -p.Id, @Now),
        @SeedBy,
        1
    FROM #NewProducts p;

    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT v.VariantId, a.AttributeId, a.AttributeValueId, 1, @Now, @SeedBy, a.SortOrder
    FROM #NewVariants v
    CROSS APPLY (
        SELECT TOP (1 + ABS(CHECKSUM(NEWID())) % 5)
            va.Id AS AttributeId,
            (SELECT TOP 1 Id FROM dbo.cf_variant_attribute_value WHERE AttributeId = va.Id ORDER BY NEWID()) AS AttributeValueId,
            ROW_NUMBER() OVER (ORDER BY NEWID()) AS SortOrder
        FROM dbo.cf_variant_attribute va
        ORDER BY NEWID()
    ) a;

    INSERT INTO dbo.cf_product_image
    (
        ProductId, VariantId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        p.Id,
        NULL,
        N'/upload/products/images/logo_loveis.png',
        CASE WHEN img.SortOrder = 1 THEN 1 ELSE 0 END,
        N'Sản phẩm ' + CAST(p.Id AS NVARCHAR(10)),
        1,
        @Now,
        @SeedBy,
        img.SortOrder
    FROM #NewProducts p
    CROSS APPLY (
        SELECT 1 AS SortOrder
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
    ) img;

    INSERT INTO dbo.cf_product_filter
    (
        ProductId, GroupId, OptionId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT DISTINCT
        v.ProductId,
        fg.Id,
        fo.Id,
        1,
        @Now,
        @SeedBy,
        0
    FROM #NewVariants v
    JOIN dbo.cf_product_variant_attribute pva ON pva.VariantId = v.VariantId
    JOIN dbo.cf_variant_attribute va ON va.Id = pva.AttributeId
    JOIN dbo.cf_variant_attribute_value vav ON vav.Id = pva.AttributeValueId
    JOIN dbo.cf_filter_group fg ON fg.GroupName = va.AttributeName
    JOIN dbo.cf_filter_option fo ON fo.GroupId = fg.Id AND fo.OptionName = vav.ValueName;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Category', c.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), c.CategoryName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(c.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_category c;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Brand', b.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), b.BrandName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(b.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_brand b;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Origin', o.Id,
           LOWER(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(200), o.OriginName) COLLATE Latin1_General_CI_AI, N' ', N'-'), NCHAR(39), N''), N'&', N'and'))
           + N'-' + CAST(o.Id AS NVARCHAR(20)),
           1, @Now, @SeedBy, 0
    FROM dbo.cf_origin o;

    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT N'Product', p.Id, N'san-pham-' + CAST(p.Id AS NVARCHAR(10)), 1, @Now, @SeedBy, 0
    FROM #NewProducts p;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
