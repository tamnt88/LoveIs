SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    IF OBJECT_ID('dbo.cf_shipping_tracking', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shipping_tracking;
    IF OBJECT_ID('dbo.cf_shipping_fee_adjustment', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shipping_fee_adjustment;
    IF OBJECT_ID('dbo.cf_shop_order_history', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_order_history;
    IF OBJECT_ID('dbo.cf_shop_order', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_order;
    IF OBJECT_ID('dbo.cf_order_history', 'U') IS NOT NULL
        DELETE FROM dbo.cf_order_history;
    IF OBJECT_ID('dbo.cf_order_item', 'U') IS NOT NULL
        DELETE FROM dbo.cf_order_item;
    IF OBJECT_ID('dbo.cf_order', 'U') IS NOT NULL
        DELETE FROM dbo.cf_order;

    IF OBJECT_ID('dbo.cf_product_review', 'U') IS NOT NULL
        DELETE FROM dbo.cf_product_review;
    IF OBJECT_ID('dbo.cf_shop_review', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_review;

    IF OBJECT_ID('dbo.cf_shop_follow', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_follow;
    IF OBJECT_ID('dbo.cf_shop_inquiry_message', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_inquiry_message;
    IF OBJECT_ID('dbo.cf_shop_inquiry', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_inquiry;
    IF OBJECT_ID('dbo.cf_shop_promotion_item', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_promotion_item;
    IF OBJECT_ID('dbo.cf_shop_promotion', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_promotion;
    IF OBJECT_ID('dbo.cf_shop_shipping_method', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_shipping_method;
    IF OBJECT_ID('dbo.cf_shop_shipping_config', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_shipping_config;

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

    IF OBJECT_ID('dbo.cf_shop_user', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop_user;
    IF OBJECT_ID('dbo.cf_shop', 'U') IS NOT NULL
        DELETE FROM dbo.cf_shop;
    IF OBJECT_ID('dbo.cf_seller', 'U') IS NOT NULL
        DELETE FROM dbo.cf_seller;

    DELETE FROM dbo.cf_variant_attribute_value;
    DELETE FROM dbo.cf_variant_attribute;
    DELETE FROM dbo.cf_brand;
    DELETE FROM dbo.cf_origin;
    DELETE FROM dbo.cf_category;

    DELETE FROM dbo.cf_seo_slug
    WHERE EntityType IN (N'Category', N'Brand', N'Origin', N'Product');

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    DECLARE @CatAo INT = 4529;
    DECLARE @CatQuan INT = 4530;
    DECLARE @CatChanVay INT = 4532;
    DECLARE @CatPhuKien INT = 4538;
    DECLARE @CatTuiXach INT = 4539;
    DECLARE @CatGiayDep INT = 4540;

    DECLARE @CatVayDam INT;
    DECLARE @CatAoKhoac INT;
    DECLARE @CatSet INT;
    DECLARE @CatDoNgu INT;
    DECLARE @CatDoTheThao INT;
    DECLARE @CatDoBoi INT;
    DECLARE @CatSaleCombo INT;

    SET IDENTITY_INSERT dbo.cf_category ON;

    INSERT INTO dbo.cf_category (Id, CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@CatAo, N'Áo', NULL, 1, @Now, @SeedBy, 1),
        (@CatQuan, N'Quần', NULL, 1, @Now, @SeedBy, 2),
        (@CatChanVay, N'Chân váy', NULL, 1, @Now, @SeedBy, 4),
        (@CatPhuKien, N'Phụ kiện', NULL, 1, @Now, @SeedBy, 10),
        (@CatTuiXach, N'Túi xách', NULL, 1, @Now, @SeedBy, 11),
        (@CatGiayDep, N'Giày dép', NULL, 1, @Now, @SeedBy, 12);

    SET IDENTITY_INSERT dbo.cf_category OFF;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Váy & Đầm', NULL, 1, @Now, @SeedBy, 3),
        (N'Áo khoác', NULL, 1, @Now, @SeedBy, 5),
        (N'Set đồ', NULL, 1, @Now, @SeedBy, 6),
        (N'Đồ ngủ', NULL, 1, @Now, @SeedBy, 7),
        (N'Đồ thể thao', NULL, 1, @Now, @SeedBy, 8),
        (N'Đồ bơi', NULL, 1, @Now, @SeedBy, 9),
        (N'Sale & combo', NULL, 1, @Now, @SeedBy, 13);

    SELECT @CatVayDam = Id FROM dbo.cf_category WHERE CategoryName = N'Váy & Đầm' AND ParentId IS NULL;
    SELECT @CatAoKhoac = Id FROM dbo.cf_category WHERE CategoryName = N'Áo khoác' AND ParentId IS NULL;
    SELECT @CatSet = Id FROM dbo.cf_category WHERE CategoryName = N'Set đồ' AND ParentId IS NULL;
    SELECT @CatDoNgu = Id FROM dbo.cf_category WHERE CategoryName = N'Đồ ngủ' AND ParentId IS NULL;
    SELECT @CatDoTheThao = Id FROM dbo.cf_category WHERE CategoryName = N'Đồ thể thao' AND ParentId IS NULL;
    SELECT @CatDoBoi = Id FROM dbo.cf_category WHERE CategoryName = N'Đồ bơi' AND ParentId IS NULL;
    SELECT @CatSaleCombo = Id FROM dbo.cf_category WHERE CategoryName = N'Sale & combo' AND ParentId IS NULL;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Áo thun', @CatAo, 1, @Now, @SeedBy, 1),
        (N'Áo sơ mi', @CatAo, 1, @Now, @SeedBy, 2),
        (N'Áo kiểu', @CatAo, 1, @Now, @SeedBy, 3),
        (N'Áo len', @CatAo, 1, @Now, @SeedBy, 4),
        (N'Quần jeans', @CatQuan, 1, @Now, @SeedBy, 1),
        (N'Quần tây', @CatQuan, 1, @Now, @SeedBy, 2),
        (N'Quần short', @CatQuan, 1, @Now, @SeedBy, 3),
        (N'Quần culottes', @CatQuan, 1, @Now, @SeedBy, 4),
        (N'Đầm dự tiệc', @CatVayDam, 1, @Now, @SeedBy, 1),
        (N'Đầm công sở', @CatVayDam, 1, @Now, @SeedBy, 2),
        (N'Váy maxi', @CatVayDam, 1, @Now, @SeedBy, 3),
        (N'Váy mini', @CatVayDam, 1, @Now, @SeedBy, 4),
        (N'Chân váy chữ A', @CatChanVay, 1, @Now, @SeedBy, 1),
        (N'Chân váy bút chì', @CatChanVay, 1, @Now, @SeedBy, 2),
        (N'Chân váy xếp ly', @CatChanVay, 1, @Now, @SeedBy, 3),
        (N'Áo khoác blazer', @CatAoKhoac, 1, @Now, @SeedBy, 1),
        (N'Áo khoác dạ', @CatAoKhoac, 1, @Now, @SeedBy, 2),
        (N'Áo khoác jean', @CatAoKhoac, 1, @Now, @SeedBy, 3),
        (N'Set công sở', @CatSet, 1, @Now, @SeedBy, 1),
        (N'Set dạo phố', @CatSet, 1, @Now, @SeedBy, 2),
        (N'Pijama', @CatDoNgu, 1, @Now, @SeedBy, 1),
        (N'Váy ngủ', @CatDoNgu, 1, @Now, @SeedBy, 2),
        (N'Áo bra thể thao', @CatDoTheThao, 1, @Now, @SeedBy, 1),
        (N'Quần legging', @CatDoTheThao, 1, @Now, @SeedBy, 2),
        (N'Đồ bơi 1 mảnh', @CatDoBoi, 1, @Now, @SeedBy, 1),
        (N'Bikini', @CatDoBoi, 1, @Now, @SeedBy, 2),
        (N'Thắt lưng', @CatPhuKien, 1, @Now, @SeedBy, 1),
        (N'Mũ & nón', @CatPhuKien, 1, @Now, @SeedBy, 2),
        (N'Khăn choàng', @CatPhuKien, 1, @Now, @SeedBy, 3),
        (N'Túi tote', @CatTuiXach, 1, @Now, @SeedBy, 1),
        (N'Túi đeo chéo', @CatTuiXach, 1, @Now, @SeedBy, 2),
        (N'Giày cao gót', @CatGiayDep, 1, @Now, @SeedBy, 1),
        (N'Giày bệt', @CatGiayDep, 1, @Now, @SeedBy, 2),
        (N'Sandal', @CatGiayDep, 1, @Now, @SeedBy, 3);

    DECLARE @CatAoThun INT;
    DECLARE @CatAoSoMi INT;
    DECLARE @CatQuanJeans INT;
    DECLARE @CatDamCongSo INT;
    DECLARE @CatVayMaxi INT;
    DECLARE @CatDoBoiMotManh INT;
    DECLARE @CatTuiTote INT;
    DECLARE @CatGiayCaoGot INT;
    DECLARE @CatAoKieu INT;
    DECLARE @CatAoLen INT;
    DECLARE @CatQuanTay INT;
    DECLARE @CatQuanShort INT;
    DECLARE @CatQuanCulottes INT;
    DECLARE @CatDamDuTiec INT;
    DECLARE @CatVayMini INT;
    DECLARE @CatChanVayXepLy INT;
    DECLARE @CatAoKhoacBlazer INT;
    DECLARE @CatAoKhoacDa INT;
    DECLARE @CatAoKhoacJean INT;
    DECLARE @CatSetCongSo INT;
    DECLARE @CatSetDaoPho INT;
    DECLARE @CatPijama INT;
    DECLARE @CatVayNgu INT;
    DECLARE @CatBraTheThao INT;
    DECLARE @CatLegging INT;
    DECLARE @CatBikini INT;
    DECLARE @CatThatLung INT;
    DECLARE @CatMuNon INT;
    DECLARE @CatKhanChoang INT;
    DECLARE @CatTuiDeoCheo INT;
    DECLARE @CatGiayBet INT;
    DECLARE @CatSandal INT;

    SELECT @CatAoThun = Id FROM dbo.cf_category WHERE CategoryName = N'Áo thun' AND ParentId = @CatAo;
    SELECT @CatAoSoMi = Id FROM dbo.cf_category WHERE CategoryName = N'Áo sơ mi' AND ParentId = @CatAo;
    SELECT @CatQuanJeans = Id FROM dbo.cf_category WHERE CategoryName = N'Quần jeans' AND ParentId = @CatQuan;
    SELECT @CatDamCongSo = Id FROM dbo.cf_category WHERE CategoryName = N'Đầm công sở' AND ParentId = @CatVayDam;
    SELECT @CatVayMaxi = Id FROM dbo.cf_category WHERE CategoryName = N'Váy maxi' AND ParentId = @CatVayDam;
    SELECT @CatDoBoiMotManh = Id FROM dbo.cf_category WHERE CategoryName = N'Đồ bơi 1 mảnh' AND ParentId = @CatDoBoi;
    SELECT @CatTuiTote = Id FROM dbo.cf_category WHERE CategoryName = N'Túi tote' AND ParentId = @CatTuiXach;
    SELECT @CatGiayCaoGot = Id FROM dbo.cf_category WHERE CategoryName = N'Giày cao gót' AND ParentId = @CatGiayDep;
    SELECT @CatAoKieu = Id FROM dbo.cf_category WHERE CategoryName = N'Áo kiểu' AND ParentId = @CatAo;
    SELECT @CatAoLen = Id FROM dbo.cf_category WHERE CategoryName = N'Áo len' AND ParentId = @CatAo;
    SELECT @CatQuanTay = Id FROM dbo.cf_category WHERE CategoryName = N'Quần tây' AND ParentId = @CatQuan;
    SELECT @CatQuanShort = Id FROM dbo.cf_category WHERE CategoryName = N'Quần short' AND ParentId = @CatQuan;
    SELECT @CatQuanCulottes = Id FROM dbo.cf_category WHERE CategoryName = N'Quần culottes' AND ParentId = @CatQuan;
    SELECT @CatDamDuTiec = Id FROM dbo.cf_category WHERE CategoryName = N'Đầm dự tiệc' AND ParentId = @CatVayDam;
    SELECT @CatVayMini = Id FROM dbo.cf_category WHERE CategoryName = N'Váy mini' AND ParentId = @CatVayDam;
    SELECT @CatChanVayXepLy = Id FROM dbo.cf_category WHERE CategoryName = N'Chân váy xếp ly' AND ParentId = @CatChanVay;
    SELECT @CatAoKhoacBlazer = Id FROM dbo.cf_category WHERE CategoryName = N'Áo khoác blazer' AND ParentId = @CatAoKhoac;
    SELECT @CatAoKhoacDa = Id FROM dbo.cf_category WHERE CategoryName = N'Áo khoác dạ' AND ParentId = @CatAoKhoac;
    SELECT @CatAoKhoacJean = Id FROM dbo.cf_category WHERE CategoryName = N'Áo khoác jean' AND ParentId = @CatAoKhoac;
    SELECT @CatSetCongSo = Id FROM dbo.cf_category WHERE CategoryName = N'Set công sở' AND ParentId = @CatSet;
    SELECT @CatSetDaoPho = Id FROM dbo.cf_category WHERE CategoryName = N'Set dạo phố' AND ParentId = @CatSet;
    SELECT @CatPijama = Id FROM dbo.cf_category WHERE CategoryName = N'Pijama' AND ParentId = @CatDoNgu;
    SELECT @CatVayNgu = Id FROM dbo.cf_category WHERE CategoryName = N'Váy ngủ' AND ParentId = @CatDoNgu;
    SELECT @CatBraTheThao = Id FROM dbo.cf_category WHERE CategoryName = N'Áo bra thể thao' AND ParentId = @CatDoTheThao;
    SELECT @CatLegging = Id FROM dbo.cf_category WHERE CategoryName = N'Quần legging' AND ParentId = @CatDoTheThao;
    SELECT @CatBikini = Id FROM dbo.cf_category WHERE CategoryName = N'Bikini' AND ParentId = @CatDoBoi;
    SELECT @CatThatLung = Id FROM dbo.cf_category WHERE CategoryName = N'Thắt lưng' AND ParentId = @CatPhuKien;
    SELECT @CatMuNon = Id FROM dbo.cf_category WHERE CategoryName = N'Mũ & nón' AND ParentId = @CatPhuKien;
    SELECT @CatKhanChoang = Id FROM dbo.cf_category WHERE CategoryName = N'Khăn choàng' AND ParentId = @CatPhuKien;
    SELECT @CatTuiDeoCheo = Id FROM dbo.cf_category WHERE CategoryName = N'Túi đeo chéo' AND ParentId = @CatTuiXach;
    SELECT @CatGiayBet = Id FROM dbo.cf_category WHERE CategoryName = N'Giày bệt' AND ParentId = @CatGiayDep;
    SELECT @CatSandal = Id FROM dbo.cf_category WHERE CategoryName = N'Sandal' AND ParentId = @CatGiayDep;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Áo thun trơn', @CatAoThun, 1, @Now, @SeedBy, 1),
        (N'Áo thun in hình', @CatAoThun, 1, @Now, @SeedBy, 2),
        (N'Áo sơ mi tay ngắn', @CatAoSoMi, 1, @Now, @SeedBy, 1),
        (N'Áo sơ mi tay dài', @CatAoSoMi, 1, @Now, @SeedBy, 2),
        (N'Quần jeans skinny', @CatQuanJeans, 1, @Now, @SeedBy, 1),
        (N'Quần jeans ống rộng', @CatQuanJeans, 1, @Now, @SeedBy, 2),
        (N'Đầm công sở chữ A', @CatDamCongSo, 1, @Now, @SeedBy, 1),
        (N'Đầm công sở ôm', @CatDamCongSo, 1, @Now, @SeedBy, 2),
        (N'Váy maxi trơn', @CatVayMaxi, 1, @Now, @SeedBy, 1),
        (N'Váy maxi họa tiết', @CatVayMaxi, 1, @Now, @SeedBy, 2),
        (N'Đồ bơi 1 mảnh cơ bản', @CatDoBoiMotManh, 1, @Now, @SeedBy, 1),
        (N'Đồ bơi 1 mảnh cắt xẻ', @CatDoBoiMotManh, 1, @Now, @SeedBy, 2),
        (N'Túi tote canvas', @CatTuiTote, 1, @Now, @SeedBy, 1),
        (N'Túi tote da', @CatTuiTote, 1, @Now, @SeedBy, 2),
        (N'Giày cao gót mũi nhọn', @CatGiayCaoGot, 1, @Now, @SeedBy, 1),
        (N'Giày cao gót mũi vuông', @CatGiayCaoGot, 1, @Now, @SeedBy, 2),
        (N'Áo kiểu bèo', @CatAoKieu, 1, @Now, @SeedBy, 1),
        (N'Áo kiểu peplum', @CatAoKieu, 1, @Now, @SeedBy, 2),
        (N'Áo len cổ lọ', @CatAoLen, 1, @Now, @SeedBy, 1),
        (N'Áo len cardigan', @CatAoLen, 1, @Now, @SeedBy, 2),
        (N'Quần tây ống đứng', @CatQuanTay, 1, @Now, @SeedBy, 1),
        (N'Quần tây ống suông', @CatQuanTay, 1, @Now, @SeedBy, 2),
        (N'Quần short kaki', @CatQuanShort, 1, @Now, @SeedBy, 1),
        (N'Quần short jean', @CatQuanShort, 1, @Now, @SeedBy, 2),
        (N'Quần culottes xếp ly', @CatQuanCulottes, 1, @Now, @SeedBy, 1),
        (N'Quần culottes trơn', @CatQuanCulottes, 1, @Now, @SeedBy, 2),
        (N'Đầm dự tiệc ren', @CatDamDuTiec, 1, @Now, @SeedBy, 1),
        (N'Đầm dự tiệc lệch vai', @CatDamDuTiec, 1, @Now, @SeedBy, 2),
        (N'Váy mini chữ A', @CatVayMini, 1, @Now, @SeedBy, 1),
        (N'Váy mini xòe', @CatVayMini, 1, @Now, @SeedBy, 2),
        (N'Chân váy xếp ly dài', @CatChanVayXepLy, 1, @Now, @SeedBy, 1),
        (N'Chân váy xếp ly ngắn', @CatChanVayXepLy, 1, @Now, @SeedBy, 2),
        (N'Áo khoác blazer dáng ngắn', @CatAoKhoacBlazer, 1, @Now, @SeedBy, 1),
        (N'Áo khoác blazer oversize', @CatAoKhoacBlazer, 1, @Now, @SeedBy, 2),
        (N'Áo khoác dạ dáng dài', @CatAoKhoacDa, 1, @Now, @SeedBy, 1),
        (N'Áo khoác dạ dáng ngắn', @CatAoKhoacDa, 1, @Now, @SeedBy, 2),
        (N'Áo khoác jean trơn', @CatAoKhoacJean, 1, @Now, @SeedBy, 1),
        (N'Áo khoác jean wash', @CatAoKhoacJean, 1, @Now, @SeedBy, 2),
        (N'Set công sở chân váy', @CatSetCongSo, 1, @Now, @SeedBy, 1),
        (N'Set công sở quần tây', @CatSetCongSo, 1, @Now, @SeedBy, 2),
        (N'Set dạo phố casual', @CatSetDaoPho, 1, @Now, @SeedBy, 1),
        (N'Set dạo phố năng động', @CatSetDaoPho, 1, @Now, @SeedBy, 2),
        (N'Pijama ngắn tay', @CatPijama, 1, @Now, @SeedBy, 1),
        (N'Pijama dài tay', @CatPijama, 1, @Now, @SeedBy, 2),
        (N'Váy ngủ hai dây', @CatVayNgu, 1, @Now, @SeedBy, 1),
        (N'Váy ngủ tay ngắn', @CatVayNgu, 1, @Now, @SeedBy, 2),
        (N'Áo bra thể thao mỏng', @CatBraTheThao, 1, @Now, @SeedBy, 1),
        (N'Áo bra thể thao nâng đỡ', @CatBraTheThao, 1, @Now, @SeedBy, 2),
        (N'Quần legging trơn', @CatLegging, 1, @Now, @SeedBy, 1),
        (N'Quần legging họa tiết', @CatLegging, 1, @Now, @SeedBy, 2),
        (N'Bikini bandeau', @CatBikini, 1, @Now, @SeedBy, 1),
        (N'Bikini tam giác', @CatBikini, 1, @Now, @SeedBy, 2),
        (N'Thắt lưng bản nhỏ', @CatThatLung, 1, @Now, @SeedBy, 1),
        (N'Thắt lưng bản to', @CatThatLung, 1, @Now, @SeedBy, 2),
        (N'Mũ lưỡi trai', @CatMuNon, 1, @Now, @SeedBy, 1),
        (N'Mũ beret', @CatMuNon, 1, @Now, @SeedBy, 2),
        (N'Khăn choàng len', @CatKhanChoang, 1, @Now, @SeedBy, 1),
        (N'Khăn choàng lụa', @CatKhanChoang, 1, @Now, @SeedBy, 2),
        (N'Túi đeo chéo mini', @CatTuiDeoCheo, 1, @Now, @SeedBy, 1),
        (N'Túi đeo chéo da', @CatTuiDeoCheo, 1, @Now, @SeedBy, 2),
        (N'Giày bệt mũi nhọn', @CatGiayBet, 1, @Now, @SeedBy, 1),
        (N'Giày bệt mũi tròn', @CatGiayBet, 1, @Now, @SeedBy, 2),
        (N'Sandal quai mảnh', @CatSandal, 1, @Now, @SeedBy, 1),
        (N'Sandal đế xuồng', @CatSandal, 1, @Now, @SeedBy, 2);

    INSERT INTO dbo.cf_brand (BrandName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Lụa Việt', 1, @Now, @SeedBy, 1),
        (N'Phong Cách', 1, @Now, @SeedBy, 2),
        (N'Thanh Lịch', 1, @Now, @SeedBy, 3),
        (N'Nữ Tính', 1, @Now, @SeedBy, 4),
        (N'Mây Mềm', 1, @Now, @SeedBy, 5),
        (N'Đường Phố', 1, @Now, @SeedBy, 6),
        (N'Ánh Nắng', 1, @Now, @SeedBy, 7),
        (N'LoveIs', 1, @Now, @SeedBy, 8);

    INSERT INTO dbo.cf_origin (OriginName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Việt Nam', 1, @Now, @SeedBy, 1),
        (N'Thái Lan', 1, @Now, @SeedBy, 2),
        (N'Nhật Bản', 1, @Now, @SeedBy, 3),
        (N'Hàn Quốc', 1, @Now, @SeedBy, 4),
        (N'Trung Quốc', 1, @Now, @SeedBy, 5),
        (N'Pháp', 1, @Now, @SeedBy, 6),
        (N'Ý', 1, @Now, @SeedBy, 7),
        (N'Mỹ', 1, @Now, @SeedBy, 8);

    DECLARE @AttrSize INT;
    DECLARE @AttrColor INT;
    DECLARE @AttrMaterial INT;

    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Kích cỡ', N'Kích cỡ sản phẩm', 1, @Now, @SeedBy, 1),
        (N'Màu sắc', N'Màu sắc sản phẩm', 1, @Now, @SeedBy, 2),
        (N'Chất liệu', N'Chất liệu vải', 1, @Now, @SeedBy, 3);

    SELECT @AttrSize = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Kích cỡ';
    SELECT @AttrColor = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Màu sắc';
    SELECT @AttrMaterial = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Chất liệu';

    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (@AttrSize, N'XS', 1, @Now, @SeedBy, 1),
        (@AttrSize, N'S', 1, @Now, @SeedBy, 2),
        (@AttrSize, N'M', 1, @Now, @SeedBy, 3),
        (@AttrSize, N'L', 1, @Now, @SeedBy, 4),
        (@AttrSize, N'XL', 1, @Now, @SeedBy, 5),
        (@AttrSize, N'XXL', 1, @Now, @SeedBy, 6),
        (@AttrColor, N'Đen', 1, @Now, @SeedBy, 1),
        (@AttrColor, N'Trắng', 1, @Now, @SeedBy, 2),
        (@AttrColor, N'Kem', 1, @Now, @SeedBy, 3),
        (@AttrColor, N'Hồng phấn', 1, @Now, @SeedBy, 4),
        (@AttrColor, N'Xanh navy', 1, @Now, @SeedBy, 5),
        (@AttrColor, N'Be', 1, @Now, @SeedBy, 6),
        (@AttrColor, N'Đỏ rượu', 1, @Now, @SeedBy, 7),
        (@AttrColor, N'Xanh rêu', 1, @Now, @SeedBy, 8),
        (@AttrMaterial, N'Cotton', 1, @Now, @SeedBy, 1),
        (@AttrMaterial, N'Lụa', 1, @Now, @SeedBy, 2),
        (@AttrMaterial, N'Len', 1, @Now, @SeedBy, 3),
        (@AttrMaterial, N'Denim', 1, @Now, @SeedBy, 4),
        (@AttrMaterial, N'Chiffon', 1, @Now, @SeedBy, 5);

    DECLARE @GroupSize INT;
    DECLARE @GroupColor INT;
    DECLARE @GroupMaterial INT;

    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Kích cỡ', N'Lọc theo kích cỡ', 1, @Now, @SeedBy, 1),
        (N'Màu sắc', N'Lọc theo màu', 1, @Now, @SeedBy, 2),
        (N'Chất liệu', N'Lọc theo chất liệu', 1, @Now, @SeedBy, 3);

    SELECT @GroupSize = Id FROM dbo.cf_filter_group WHERE GroupName = N'Kích cỡ';
    SELECT @GroupColor = Id FROM dbo.cf_filter_group WHERE GroupName = N'Màu sắc';
    SELECT @GroupMaterial = Id FROM dbo.cf_filter_group WHERE GroupName = N'Chất liệu';

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupSize, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrSize;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupColor, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrColor;

    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @GroupMaterial, ValueName, 1, @Now, @SeedBy, SortOrder
    FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrMaterial;

    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT c.Id, g.Id, 1, @Now, @SeedBy, g.SortOrder
    FROM dbo.cf_category c
    CROSS JOIN dbo.cf_filter_group g
    WHERE c.ParentId IS NOT NULL;

    IF OBJECT_ID('tempdb..#SeedSellers') IS NOT NULL DROP TABLE #SeedSellers;
    CREATE TABLE #SeedSellers (
        Username NVARCHAR(100) NOT NULL,
        DisplayName NVARCHAR(200) NOT NULL,
        Email NVARCHAR(200) NULL,
        Phone NVARCHAR(30) NULL,
        ShopCode NVARCHAR(50) NOT NULL,
        ShopName NVARCHAR(200) NOT NULL,
        ProvinceName NVARCHAR(150) NULL
    );

    INSERT INTO #SeedSellers (Username, DisplayName, Email, Phone, ShopCode, ShopName, ProvinceName)
    VALUES
        (N'ao-nu', N'Thảo Mai', N'thaomai@loveis.vn', N'0900000001', N'ao-nu', N'Thời Trang Áo Nữ', N'Hồ Chí Minh'),
        (N'quan-nu', N'Minh Châu', N'minhchau@loveis.vn', N'0900000002', N'quan-nu', N'Thời Trang Quần Nữ', N'Hà Nội'),
        (N'chan-vay', N'Khánh Linh', N'khanhlinh@loveis.vn', N'0900000003', N'chan-vay', N'Chân Váy Nữ', N'Đà Nẵng'),
        (N'phu-kien', N'Ngọc Anh', N'ngocanh@loveis.vn', N'0900000004', N'phu-kien', N'Phụ Kiện Nữ', N'Hồ Chí Minh'),
        (N'tui-xach', N'Thùy Dương', N'thuyduong@loveis.vn', N'0900000005', N'tui-xach', N'Túi Xách Nữ', N'Hà Nội'),
        (N'giay-dep', N'Bảo Trân', N'baotran@loveis.vn', N'0900000006', N'giay-dep', N'Giày Dép Nữ', N'Hải Phòng');

    INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT
        s.Username,
        s.DisplayName,
        s.Email,
        s.Phone,
        HASHBYTES('SHA2_512', CONVERT(NVARCHAR(200), NEWID())),
        HASHBYTES('SHA2_256', CONVERT(NVARCHAR(200), NEWID())),
        12000,
        1,
        @Now,
        @SeedBy,
        0
    FROM #SeedSellers s;

    INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, LogoUrl, BannerUrl, Description, AddressLine, ProvinceName, Status, RatingAvg, RatingCount, CompletedOrders, CreatedAt, CreatedBy, SortOrder)
    SELECT
        se.Id,
        s.ShopCode,
        s.ShopName,
        N'/upload/shops/logo-default.png',
        N'/upload/shops/banner-default.png',
        N'Thời trang nữ chính hãng, mẫu mã cập nhật mỗi ngày.',
        N'Địa chỉ đang cập nhật',
        s.ProvinceName,
        N'Active',
        0,
        0,
        0,
        @Now,
        @SeedBy,
        0
    FROM #SeedSellers s
    JOIN dbo.cf_seller se ON se.Username = s.Username;

    IF OBJECT_ID('tempdb..#NewProducts') IS NOT NULL DROP TABLE #NewProducts;
    CREATE TABLE #NewProducts (Id INT NOT NULL, CategoryId INT NOT NULL, ShopId INT NOT NULL);

    ;WITH N AS (
        SELECT TOP (300)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO dbo.cf_product
    (
        ProductName, CategoryId, BrandId, OriginId, ShopId,
        ShortDescription, Description, Specification, Ingredients, Usage,
        Status, CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.CategoryId, inserted.ShopId INTO #NewProducts (Id, CategoryId, ShopId)
    SELECT
        c.CategoryName + N' nữ ' + RIGHT(N'0000' + CAST(n AS NVARCHAR(10)), 4),
        c.Id,
        b.Id,
        o.Id,
        s.Id,
        N'Thiết kế hiện đại, chất liệu dễ chịu.',
        N'Mô tả sản phẩm thời trang nữ đang được cập nhật.',
        N'Thông số sản phẩm đang được cập nhật.',
        N'Thành phần chất liệu theo thuộc tính.',
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
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_origin WHERE Status = 1 ORDER BY NEWID()) o
    OUTER APPLY (SELECT TOP 1 Id FROM dbo.cf_shop WHERE Status = N'Active' ORDER BY NEWID()) s;

    IF OBJECT_ID('tempdb..#CategoryRoot') IS NOT NULL DROP TABLE #CategoryRoot;
    ;WITH C AS (
        SELECT Id, ParentId, Id AS RootId
        FROM dbo.cf_category
        WHERE ParentId IS NULL
        UNION ALL
        SELECT c.Id, c.ParentId, p.RootId
        FROM dbo.cf_category c
        JOIN C p ON c.ParentId = p.Id
    )
    SELECT Id AS CategoryId, RootId
    INTO #CategoryRoot
    FROM C;

    IF OBJECT_ID('tempdb..#ProductAttrConfig') IS NOT NULL DROP TABLE #ProductAttrConfig;
    CREATE TABLE #ProductAttrConfig (
        ProductId INT NOT NULL PRIMARY KEY,
        IncludeMaterial BIT NOT NULL
    );

    INSERT INTO #ProductAttrConfig (ProductId, IncludeMaterial)
    SELECT Id, CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 1 ELSE 0 END
    FROM #NewProducts;

    IF OBJECT_ID('tempdb..#PlannedVariants') IS NOT NULL DROP TABLE #PlannedVariants;
    CREATE TABLE #PlannedVariants (
        ProductId INT NOT NULL,
        VariantIndex INT NOT NULL,
        SizeValueId INT NOT NULL,
        ColorValueId INT NOT NULL,
        MaterialValueId INT NOT NULL
    );

    ;WITH VariantCount AS (
        SELECT p.Id AS ProductId,
               2 + (ABS(CHECKSUM(NEWID())) % 2) AS VariantCount
        FROM #NewProducts p
    ),
    SizePick AS (
        SELECT p.Id AS ProductId, v.Id AS ValueId,
               ROW_NUMBER() OVER (PARTITION BY p.Id ORDER BY NEWID()) AS rn
        FROM #NewProducts p
        CROSS JOIN dbo.cf_variant_attribute_value v
        WHERE v.AttributeId = @AttrSize
    ),
    ColorPick AS (
        SELECT p.Id AS ProductId, v.Id AS ValueId,
               ROW_NUMBER() OVER (PARTITION BY p.Id ORDER BY NEWID()) AS rn
        FROM #NewProducts p
        CROSS JOIN dbo.cf_variant_attribute_value v
        WHERE v.AttributeId = @AttrColor
    ),
    MaterialPick AS (
        SELECT p.Id AS ProductId, v.Id AS ValueId,
               ROW_NUMBER() OVER (PARTITION BY p.Id ORDER BY NEWID()) AS rn
        FROM #NewProducts p
        CROSS JOIN dbo.cf_variant_attribute_value v
        WHERE v.AttributeId = @AttrMaterial
    )
    INSERT INTO #PlannedVariants (ProductId, VariantIndex, SizeValueId, ColorValueId, MaterialValueId)
    SELECT
        p.Id,
        sp.rn,
        sp.ValueId,
        cp.ValueId,
        mp.ValueId
    FROM #NewProducts p
    JOIN VariantCount vc ON vc.ProductId = p.Id
    JOIN SizePick sp ON sp.ProductId = p.Id AND sp.rn <= vc.VariantCount
    JOIN ColorPick cp ON cp.ProductId = p.Id AND cp.rn = sp.rn
    JOIN MaterialPick mp ON mp.ProductId = p.Id AND mp.rn = sp.rn;

    IF OBJECT_ID('tempdb..#NewVariants') IS NOT NULL DROP TABLE #NewVariants;
    CREATE TABLE #NewVariants (
        VariantId INT NOT NULL,
        ProductId INT NOT NULL,
        VariantIndex INT NOT NULL,
        SizeValueId INT NULL,
        ColorValueId INT NULL,
        MaterialValueId INT NULL
    );

    INSERT INTO dbo.cf_product_variant
    (
        ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status,
        CreatedAt, CreatedBy, SortOrder
    )
    OUTPUT inserted.Id, inserted.ProductId, inserted.SortOrder
    INTO #NewVariants (VariantId, ProductId, VariantIndex)
    SELECT
        pv.ProductId,
        N'Phiên bản ' + CAST(pv.VariantIndex AS NVARCHAR(10)),
        N'LI-' + CAST(pv.ProductId AS NVARCHAR(10)) + N'-' + RIGHT(N'0' + CAST(pv.VariantIndex AS NVARCHAR(10)), 2),
        CAST(ROUND(150000 + (ABS(CHECKSUM(NEWID())) % 650000), 0) AS DECIMAL(18,2)),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0
             THEN CAST(ROUND(120000 + (ABS(CHECKSUM(NEWID())) % 450000), 0) AS DECIMAL(18,2))
             ELSE NULL END,
        20 + (ABS(CHECKSUM(NEWID())) % 200),
        1,
        DATEADD(MINUTE, -pv.ProductId, @Now),
        @SeedBy,
        pv.VariantIndex
    FROM #PlannedVariants pv;

    UPDATE v
    SET
        v.SizeValueId = pv.SizeValueId,
        v.ColorValueId = pv.ColorValueId,
        v.MaterialValueId = pv.MaterialValueId
    FROM #NewVariants v
    JOIN #PlannedVariants pv
        ON pv.ProductId = v.ProductId
        AND pv.VariantIndex = v.VariantIndex;

    INSERT INTO dbo.cf_product_variant_attribute
    (
        VariantId, AttributeId, AttributeValueId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT VariantId, @AttrSize, SizeValueId, 1, @Now, @SeedBy, 1
    FROM #NewVariants
    UNION ALL
    SELECT VariantId, @AttrColor, ColorValueId, 1, @Now, @SeedBy, 2
    FROM #NewVariants
    UNION ALL
    SELECT v.VariantId, @AttrMaterial, v.MaterialValueId, 1, @Now, @SeedBy, 3
    FROM #NewVariants v
    JOIN #ProductAttrConfig c ON c.ProductId = v.ProductId
    WHERE c.IncludeMaterial = 1;

    ;WITH ImageNumbers AS (
        SELECT v.Number
        FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10)) v(Number)
    )
    INSERT INTO dbo.cf_product_image
    (
        ProductId, VariantId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
        p.Id,
        NULL,
        N'/upload/products/images/' + CAST(img.ImageRootId AS NVARCHAR(10)) + N'/' + CAST(n.Number AS NVARCHAR(10)) + N'.webp',
        CASE WHEN n.rn = 1 THEN 1 ELSE 0 END,
        N'Sản phẩm ' + CAST(p.Id AS NVARCHAR(10)),
        1,
        @Now,
        @SeedBy,
        n.rn
    FROM #NewProducts p
    JOIN #CategoryRoot r ON r.CategoryId = p.CategoryId
    CROSS APPLY (
        SELECT CASE
            WHEN r.RootId IN (@CatAo, @CatQuan, @CatChanVay, @CatPhuKien, @CatTuiXach, @CatGiayDep)
                THEN r.RootId
            ELSE @CatAo
        END AS ImageRootId
    ) img
    CROSS APPLY (
        SELECT TOP 3 Number, ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
        FROM ImageNumbers
        ORDER BY NEWID()
    ) n;

    INSERT INTO dbo.cf_product_filter
    (
        ProductId, GroupId, OptionId, Status, CreatedAt, CreatedBy, SortOrder
    )
    SELECT
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
