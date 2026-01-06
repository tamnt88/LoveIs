-- Large seed data for products/variants/images (UTF-8)
USE BeautyStoryDB;
GO

-- Products
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Sữa rửa mặt dịu nhẹ',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Cetaphil'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Sữa rửa mặt dịu nhẹ',
        N'Mô tả chi tiết cho Sữa rửa mặt dịu nhẹ',
        1, GETDATE(), N'Seed', 1
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Gel rửa mặt kiềm dầu',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Gel rửa mặt kiềm dầu',
        N'Mô tả chi tiết cho Gel rửa mặt kiềm dầu',
        1, GETDATE(), N'Seed', 2
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Nước tẩy trang micellar',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy trang'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Nước tẩy trang micellar',
        N'Mô tả chi tiết cho Nước tẩy trang micellar',
        1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Toner cân bằng da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Toner/Nước cân bằng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Simple'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Anh'),
        N'Sản phẩm Toner cân bằng da',
        N'Mô tả chi tiết cho Toner cân bằng da',
        1, GETDATE(), N'Seed', 4
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Serum vitamin C sáng da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Canada'),
        N'Sản phẩm Serum vitamin C sáng da',
        N'Mô tả chi tiết cho Serum vitamin C sáng da',
        1, GETDATE(), N'Seed', 5
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Serum phục hồi da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Serum phục hồi da',
        N'Mô tả chi tiết cho Serum phục hồi da',
        1, GETDATE(), N'Seed', 6
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ẩm ban đêm',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng ẩm ban đêm',
        N'Mô tả chi tiết cho Kem dưỡng ẩm ban đêm',
        1, GETDATE(), N'Seed', 7
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Mặt nạ dưỡng ẩm',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Mặt nạ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Mặt nạ dưỡng ẩm',
        N'Mô tả chi tiết cho Mặt nạ dưỡng ẩm',
        1, GETDATE(), N'Seed', 8
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tẩy tế bào chết dịu nhẹ',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Neutrogena'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Tẩy tế bào chết dịu nhẹ',
        N'Mô tả chi tiết cho Tẩy tế bào chết dịu nhẹ',
        1, GETDATE(), N'Seed', 9
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng mắt giảm thâm',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng mắt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Kiehl''s'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem dưỡng mắt giảm thâm',
        N'Mô tả chi tiết cho Kem dưỡng mắt giảm thâm',
        1, GETDATE(), N'Seed', 10
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem nền lâu trôi',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem nền'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Maybelline'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem nền lâu trôi',
        N'Mô tả chi tiết cho Kem nền lâu trôi',
        1, GETDATE(), N'Seed', 11
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Phấn phủ kiềm dầu',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Phấn phủ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Chanel'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Phấn phủ kiềm dầu',
        N'Mô tả chi tiết cho Phấn phủ kiềm dầu',
        1, GETDATE(), N'Seed', 12
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Son kem lì')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Son kem lì',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Son môi'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'MAC'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Son kem lì',
        N'Mô tả chi tiết cho Son kem lì',
        1, GETDATE(), N'Seed', 13
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Mascara dày mi',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Mascara'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Maybelline'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Mascara dày mi',
        N'Mô tả chi tiết cho Mascara dày mi',
        1, GETDATE(), N'Seed', 14
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Bút kẻ mắt chống nước',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kẻ mắt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Dior'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Bút kẻ mắt chống nước',
        N'Mô tả chi tiết cho Bút kẻ mắt chống nước',
        1, GETDATE(), N'Seed', 15
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Má hồng dạng kem',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Má hồng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Clinique'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Má hồng dạng kem',
        N'Mô tả chi tiết cho Má hồng dạng kem',
        1, GETDATE(), N'Seed', 16
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Che khuyết điểm đa năng',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Che khuyết điểm'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Che khuyết điểm đa năng',
        N'Mô tả chi tiết cho Che khuyết điểm đa năng',
        1, GETDATE(), N'Seed', 17
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Bộ cọ trang điểm cơ bản',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Cọ trang điểm'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Face Shop'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Bộ cọ trang điểm cơ bản',
        N'Mô tả chi tiết cho Bộ cọ trang điểm cơ bản',
        1, GETDATE(), N'Seed', 18
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Dầu gội phục hồi tóc',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dầu gội'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Garnier'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Dầu gội phục hồi tóc',
        N'Mô tả chi tiết cho Dầu gội phục hồi tóc',
        1, GETDATE(), N'Seed', 19
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Dầu xả suôn mượt',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dầu xả'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Garnier'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Dầu xả suôn mượt',
        N'Mô tả chi tiết cho Dầu xả suôn mượt',
        1, GETDATE(), N'Seed', 20
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Ủ tóc keratin',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Ủ tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Ủ tóc keratin',
        N'Mô tả chi tiết cho Ủ tóc keratin',
        1, GETDATE(), N'Seed', 21
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh dầu dưỡng tóc',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tinh dầu dưỡng tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Tinh dầu dưỡng tóc',
        N'Mô tả chi tiết cho Tinh dầu dưỡng tóc',
        1, GETDATE(), N'Seed', 22
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Xịt dưỡng tóc mềm mượt',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Xịt dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nature Republic'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Xịt dưỡng tóc mềm mượt',
        N'Mô tả chi tiết cho Xịt dưỡng tóc mềm mượt',
        1, GETDATE(), N'Seed', 23
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Gel tạo kiểu',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tạo kiểu'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Gel tạo kiểu',
        N'Mô tả chi tiết cho Gel tạo kiểu',
        1, GETDATE(), N'Seed', 24
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Serum tóc bóng khỏe',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Serum tóc bóng khỏe',
        N'Mô tả chi tiết cho Serum tóc bóng khỏe',
        1, GETDATE(), N'Seed', 25
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Màu nhuộm tóc tại nhà',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Nhuộm tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Màu nhuộm tóc tại nhà',
        N'Mô tả chi tiết cho Màu nhuộm tóc tại nhà',
        1, GETDATE(), N'Seed', 26
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Sữa tắm hương hoa',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa tắm'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Sữa tắm hương hoa',
        N'Mô tả chi tiết cho Sữa tắm hương hoa',
        1, GETDATE(), N'Seed', 27
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tẩy tế bào chết body',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết body'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Face Shop'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Tẩy tế bào chết body',
        N'Mô tả chi tiết cho Tẩy tế bào chết body',
        1, GETDATE(), N'Seed', 28
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng thể trắng da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem dưỡng thể trắng da',
        N'Mô tả chi tiết cho Kem dưỡng thể trắng da',
        1, GETDATE(), N'Seed', 29
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Lăn khử mùi',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Khử mùi'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Lăn khử mùi',
        N'Mô tả chi tiết cho Lăn khử mùi',
        1, GETDATE(), N'Seed', 30
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng da tay',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc tay'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Neutrogena'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem dưỡng da tay',
        N'Mô tả chi tiết cho Kem dưỡng da tay',
        1, GETDATE(), N'Seed', 31
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng gót chân',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc chân'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Eucerin'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem dưỡng gót chân',
        N'Mô tả chi tiết cho Kem dưỡng gót chân',
        1, GETDATE(), N'Seed', 32
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Son dưỡng môi',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng môi'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Son dưỡng môi',
        N'Mô tả chi tiết cho Son dưỡng môi',
        1, GETDATE(), N'Seed', 33
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem chống nứt gót',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chống nứt gót'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Eucerin'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem chống nứt gót',
        N'Mô tả chi tiết cho Kem chống nứt gót',
        1, GETDATE(), N'Seed', 34
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem chống nắng SPF50',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Anessa'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Kem chống nắng SPF50',
        N'Mô tả chi tiết cho Kem chống nắng SPF50',
        1, GETDATE(), N'Seed', 35
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Sữa chống nắng dịu nhẹ',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Senka'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Sữa chống nắng dịu nhẹ',
        N'Mô tả chi tiết cho Sữa chống nắng dịu nhẹ',
        1, GETDATE(), N'Seed', 36
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Xịt chống nắng tiện lợi',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Xịt chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Xịt chống nắng tiện lợi',
        N'Mô tả chi tiết cho Xịt chống nắng tiện lợi',
        1, GETDATE(), N'Seed', 37
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Chống nắng body')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Chống nắng body',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chống nắng body'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Chống nắng body',
        N'Mô tả chi tiết cho Chống nắng body',
        1, GETDATE(), N'Seed', 38
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Chống nắng nâng tông',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chống nắng nâng tông'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Chống nắng nâng tông',
        N'Mô tả chi tiết cho Chống nắng nâng tông',
        1, GETDATE(), N'Seed', 39
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Nước hoa nữ thanh lịch',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Nước hoa nữ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Chanel'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Nước hoa nữ thanh lịch',
        N'Mô tả chi tiết cho Nước hoa nữ thanh lịch',
        1, GETDATE(), N'Seed', 40
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Nước hoa nam mạnh mẽ',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Nước hoa nam'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Dior'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Nước hoa nam mạnh mẽ',
        N'Mô tả chi tiết cho Nước hoa nam mạnh mẽ',
        1, GETDATE(), N'Seed', 41
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Nước hoa unisex',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Nước hoa unisex'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Chanel'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Nước hoa unisex',
        N'Mô tả chi tiết cho Nước hoa unisex',
        1, GETDATE(), N'Seed', 42
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Xịt thơm body',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Xịt thơm body'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Xịt thơm body',
        N'Mô tả chi tiết cho Xịt thơm body',
        1, GETDATE(), N'Seed', 43
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Set quà nước hoa',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Set quà nước hoa'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Chanel'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Set quà nước hoa',
        N'Mô tả chi tiết cho Set quà nước hoa',
        1, GETDATE(), N'Seed', 44
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem trị mụn',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Trị mụn'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem trị mụn',
        N'Mô tả chi tiết cho Kem trị mụn',
        1, GETDATE(), N'Seed', 45
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem phục hồi da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Phục hồi da'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem phục hồi da',
        N'Mô tả chi tiết cho Kem phục hồi da',
        1, GETDATE(), N'Seed', 46
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Serum giảm kích ứng',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Giảm kích ứng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Serum giảm kích ứng',
        N'Mô tả chi tiết cho Serum giảm kích ứng',
        1, GETDATE(), N'Seed', 47
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất làm sáng da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Làm sáng da'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'SK-II'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Tinh chất làm sáng da',
        N'Mô tả chi tiết cho Tinh chất làm sáng da',
        1, GETDATE(), N'Seed', 48
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ẩm sâu',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng ẩm sâu'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem dưỡng ẩm sâu',
        N'Mô tả chi tiết cho Kem dưỡng ẩm sâu',
        1, GETDATE(), N'Seed', 49
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Sữa rửa mặt nam',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt nam'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Sữa rửa mặt nam',
        N'Mô tả chi tiết cho Sữa rửa mặt nam',
        1, GETDATE(), N'Seed', 50
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng nam',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng nam'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng nam',
        N'Mô tả chi tiết cho Kem dưỡng nam',
        1, GETDATE(), N'Seed', 51
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Sáp tạo kiểu tóc nam',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tạo kiểu tóc nam'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Sáp tạo kiểu tóc nam',
        N'Mô tả chi tiết cho Sáp tạo kiểu tóc nam',
        1, GETDATE(), N'Seed', 52
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Lăn khử mùi nam',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Lăn khử mùi nam'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Lăn khử mùi nam',
        N'Mô tả chi tiết cho Lăn khử mùi nam',
        1, GETDATE(), N'Seed', 53
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Nước hoa nam cá tính',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Nước hoa nam'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Dior'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Nước hoa nam cá tính',
        N'Mô tả chi tiết cho Nước hoa nam cá tính',
        1, GETDATE(), N'Seed', 54
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Sữa tắm gội cho bé',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tắm gội cho bé'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Cetaphil'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Sữa tắm gội cho bé',
        N'Mô tả chi tiết cho Sữa tắm gội cho bé',
        1, GETDATE(), N'Seed', 55
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng da cho bé',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng da cho bé'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng da cho bé',
        N'Mô tả chi tiết cho Kem dưỡng da cho bé',
        1, GETDATE(), N'Seed', 56
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem chống hăm',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chống hăm'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Eucerin'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem chống hăm',
        N'Mô tả chi tiết cho Kem chống hăm',
        1, GETDATE(), N'Seed', 57
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem chăm sóc mẹ bầu',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc mẹ bầu'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem chăm sóc mẹ bầu',
        N'Mô tả chi tiết cho Kem chăm sóc mẹ bầu',
        1, GETDATE(), N'Seed', 58
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Khăn ướt dịu nhẹ',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Khăn ướt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Cetaphil'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Khăn ướt dịu nhẹ',
        N'Mô tả chi tiết cho Khăn ướt dịu nhẹ',
        1, GETDATE(), N'Seed', 59
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Máy rửa mặt mini',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Máy rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Máy rửa mặt mini',
        N'Mô tả chi tiết cho Máy rửa mặt mini',
        1, GETDATE(), N'Seed', 60
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Máy đẩy tinh chất',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Máy đẩy tinh chất'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Máy đẩy tinh chất',
        N'Mô tả chi tiết cho Máy đẩy tinh chất',
        1, GETDATE(), N'Seed', 61
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Máy massage mặt',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Máy massage'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Máy massage mặt',
        N'Mô tả chi tiết cho Máy massage mặt',
        1, GETDATE(), N'Seed', 62
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Máy triệt lông',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Máy triệt lông'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Máy triệt lông',
        N'Mô tả chi tiết cho Máy triệt lông',
        1, GETDATE(), N'Seed', 63
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Máy sấy tóc',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Máy sấy tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Máy sấy tóc',
        N'Mô tả chi tiết cho Máy sấy tóc',
        1, GETDATE(), N'Seed', 64
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Máy uốn tóc',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Máy uốn tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Máy uốn tóc',
        N'Mô tả chi tiết cho Máy uốn tóc',
        1, GETDATE(), N'Seed', 65
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Viên uống collagen',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Collagen'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Shiseido'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Viên uống collagen',
        N'Mô tả chi tiết cho Viên uống collagen',
        1, GETDATE(), N'Seed', 66
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Vitamin tổng hợp',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Vitamin tổng hợp'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Úc'),
        N'Sản phẩm Vitamin tổng hợp',
        N'Mô tả chi tiết cho Vitamin tổng hợp',
        1, GETDATE(), N'Seed', 67
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Viên uống đẹp da',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Viên uống đẹp da'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Úc'),
        N'Sản phẩm Viên uống đẹp da',
        N'Mô tả chi tiết cho Viên uống đẹp da',
        1, GETDATE(), N'Seed', 68
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Viên hỗ trợ tóc móng',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Hỗ trợ tóc móng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Úc'),
        N'Sản phẩm Viên hỗ trợ tóc móng',
        N'Mô tả chi tiết cho Viên hỗ trợ tóc móng',
        1, GETDATE(), N'Seed', 69
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Viên hỗ trợ giấc ngủ',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Hỗ trợ giấc ngủ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Úc'),
        N'Sản phẩm Viên hỗ trợ giấc ngủ',
        N'Mô tả chi tiết cho Viên hỗ trợ giấc ngủ',
        1, GETDATE(), N'Seed', 70
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Set dưỡng da cơ bản',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Set dưỡng da'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Laneige'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Set dưỡng da cơ bản',
        N'Mô tả chi tiết cho Set dưỡng da cơ bản',
        1, GETDATE(), N'Seed', 71
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Set trang điểm cơ bản',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Set trang điểm'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Maybelline'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Set trang điểm cơ bản',
        N'Mô tả chi tiết cho Set trang điểm cơ bản',
        1, GETDATE(), N'Seed', 72
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Set chăm sóc tóc',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Set chăm sóc tóc'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'L''Oréal'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Set chăm sóc tóc',
        N'Mô tả chi tiết cho Set chăm sóc tóc',
        1, GETDATE(), N'Seed', 73
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Set chăm sóc cơ thể',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Set cơ thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Nivea'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Set chăm sóc cơ thể',
        N'Mô tả chi tiết cho Set chăm sóc cơ thể',
        1, GETDATE(), N'Seed', 74
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Set mini travel')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Set mini travel',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Set mini travel'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Set mini travel',
        N'Mô tả chi tiết cho Set mini travel',
        1, GETDATE(), N'Seed', 75
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 1',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Tinh chất dưỡng ẩm 1',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 1',
        1, GETDATE(), N'Seed', 76
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 2',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Tinh chất dưỡng ẩm 2',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 2',
        1, GETDATE(), N'Seed', 77
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 3',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Tinh chất dưỡng ẩm 3',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 3',
        1, GETDATE(), N'Seed', 78
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 4',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Tinh chất dưỡng ẩm 4',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 4',
        1, GETDATE(), N'Seed', 79
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 5',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Toner/Nước cân bằng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Tinh chất dưỡng ẩm 5',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 5',
        1, GETDATE(), N'Seed', 80
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 6',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Trị mụn'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Tinh chất dưỡng ẩm 6',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 6',
        1, GETDATE(), N'Seed', 81
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 7',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Tinh chất dưỡng ẩm 7',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 7',
        1, GETDATE(), N'Seed', 82
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 8',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Tinh chất dưỡng ẩm 8',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 8',
        1, GETDATE(), N'Seed', 83
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất dưỡng ẩm 9',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Mặt nạ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Tinh chất dưỡng ẩm 9',
        N'Mô tả chi tiết cho Tinh chất dưỡng ẩm 9',
        1, GETDATE(), N'Seed', 84
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 10',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Tinh chất phục hồi 10',
        N'Mô tả chi tiết cho Tinh chất phục hồi 10',
        1, GETDATE(), N'Seed', 85
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 11',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Tinh chất phục hồi 11',
        N'Mô tả chi tiết cho Tinh chất phục hồi 11',
        1, GETDATE(), N'Seed', 86
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 12',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Tinh chất phục hồi 12',
        N'Mô tả chi tiết cho Tinh chất phục hồi 12',
        1, GETDATE(), N'Seed', 87
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 13',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Tinh chất phục hồi 13',
        N'Mô tả chi tiết cho Tinh chất phục hồi 13',
        1, GETDATE(), N'Seed', 88
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 14',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Toner/Nước cân bằng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Tinh chất phục hồi 14',
        N'Mô tả chi tiết cho Tinh chất phục hồi 14',
        1, GETDATE(), N'Seed', 89
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 15',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Trị mụn'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Tinh chất phục hồi 15',
        N'Mô tả chi tiết cho Tinh chất phục hồi 15',
        1, GETDATE(), N'Seed', 90
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 16',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Tinh chất phục hồi 16',
        N'Mô tả chi tiết cho Tinh chất phục hồi 16',
        1, GETDATE(), N'Seed', 91
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 17',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Tinh chất phục hồi 17',
        N'Mô tả chi tiết cho Tinh chất phục hồi 17',
        1, GETDATE(), N'Seed', 92
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Tinh chất phục hồi 18',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Mặt nạ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Tinh chất phục hồi 18',
        N'Mô tả chi tiết cho Tinh chất phục hồi 18',
        1, GETDATE(), N'Seed', 93
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 19',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Kem dưỡng ban ngày 19',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 19',
        1, GETDATE(), N'Seed', 94
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 20',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Kem dưỡng ban ngày 20',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 20',
        1, GETDATE(), N'Seed', 95
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 21',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng ban ngày 21',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 21',
        1, GETDATE(), N'Seed', 96
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 22',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem dưỡng ban ngày 22',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 22',
        1, GETDATE(), N'Seed', 97
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 23',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Toner/Nước cân bằng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem dưỡng ban ngày 23',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 23',
        1, GETDATE(), N'Seed', 98
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 24',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Trị mụn'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Kem dưỡng ban ngày 24',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 24',
        1, GETDATE(), N'Seed', 99
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 25',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Kem dưỡng ban ngày 25',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 25',
        1, GETDATE(), N'Seed', 100
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 26',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng ban ngày 26',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 26',
        1, GETDATE(), N'Seed', 101
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban ngày 27',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Mặt nạ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem dưỡng ban ngày 27',
        N'Mô tả chi tiết cho Kem dưỡng ban ngày 27',
        1, GETDATE(), N'Seed', 102
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 28',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem dưỡng ban đêm 28',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 28',
        1, GETDATE(), N'Seed', 103
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 29',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Kem dưỡng ban đêm 29',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 29',
        1, GETDATE(), N'Seed', 104
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 30',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Kem dưỡng ban đêm 30',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 30',
        1, GETDATE(), N'Seed', 105
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 31',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng ban đêm 31',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 31',
        1, GETDATE(), N'Seed', 106
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 32',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Toner/Nước cân bằng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Kem dưỡng ban đêm 32',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 32',
        1, GETDATE(), N'Seed', 107
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 33',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Trị mụn'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Kem dưỡng ban đêm 33',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 33',
        1, GETDATE(), N'Seed', 108
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 34',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem chống nắng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Kem dưỡng ban đêm 34',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 34',
        1, GETDATE(), N'Seed', 109
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 35',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'CeraVe'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Kem dưỡng ban đêm 35',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 35',
        1, GETDATE(), N'Seed', 110
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Kem dưỡng ban đêm 36',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Mặt nạ'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Innisfree'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Pháp'),
        N'Sản phẩm Kem dưỡng ban đêm 36',
        N'Mô tả chi tiết cho Kem dưỡng ban đêm 36',
        1, GETDATE(), N'Seed', 111
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Gel tẩy tế bào chết 37',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Serum'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'The Ordinary'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Mỹ'),
        N'Sản phẩm Gel tẩy tế bào chết 37',
        N'Mô tả chi tiết cho Gel tẩy tế bào chết 37',
        1, GETDATE(), N'Seed', 112
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Gel tẩy tế bào chết 38',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Vichy'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Đức'),
        N'Sản phẩm Gel tẩy tế bào chết 38',
        N'Mô tả chi tiết cho Gel tẩy tế bào chết 38',
        1, GETDATE(), N'Seed', 113
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Gel tẩy tế bào chết 39',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản'),
        N'Sản phẩm Gel tẩy tế bào chết 39',
        N'Mô tả chi tiết cho Gel tẩy tế bào chết 39',
        1, GETDATE(), N'Seed', 114
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40')
    INSERT INTO dbo.cf_product (ProductName, CategoryId, BrandId, OriginId, ShortDescription, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        N'Gel tẩy tế bào chết 40',
        (SELECT TOP 1 Id FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể'),
        (SELECT TOP 1 Id FROM dbo.cf_brand WHERE BrandName = N'Bioderma'),
        (SELECT TOP 1 Id FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc'),
        N'Sản phẩm Gel tẩy tế bào chết 40',
        N'Mô tả chi tiết cho Gel tẩy tế bào chết 40',
        1, GETDATE(), N'Seed', 115
    );

-- Variants
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'),
        N'30ml', N'SKU-0001-1', 126000, 116000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'),
        N'50ml', N'SKU-0001-2', 131000, 121000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'),
        N'100ml', N'SKU-0001-3', 136000, 126000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'),
        N'30ml', N'SKU-0002-1', 127000, 117000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'),
        N'50ml', N'SKU-0002-2', 132000, 122000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'),
        N'100ml', N'SKU-0002-3', 137000, 127000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'),
        N'30ml', N'SKU-0003-1', 128000, 118000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'),
        N'50ml', N'SKU-0003-2', 133000, 123000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'),
        N'100ml', N'SKU-0003-3', 138000, 128000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'),
        N'30ml', N'SKU-0004-1', 129000, 119000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'),
        N'50ml', N'SKU-0004-2', 134000, 124000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'),
        N'100ml', N'SKU-0004-3', 139000, 129000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'),
        N'30ml', N'SKU-0005-1', 130000, 120000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'),
        N'50ml', N'SKU-0005-2', 135000, 125000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'),
        N'100ml', N'SKU-0005-3', 140000, 130000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'),
        N'30ml', N'SKU-0006-1', 131000, 121000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'),
        N'50ml', N'SKU-0006-2', 136000, 126000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'),
        N'100ml', N'SKU-0006-3', 141000, 131000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'),
        N'30ml', N'SKU-0007-1', 132000, 122000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'),
        N'50ml', N'SKU-0007-2', 137000, 127000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'),
        N'100ml', N'SKU-0007-3', 142000, 132000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'),
        N'30ml', N'SKU-0008-1', 133000, 123000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'),
        N'50ml', N'SKU-0008-2', 138000, 128000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'),
        N'100ml', N'SKU-0008-3', 143000, 133000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'),
        N'30ml', N'SKU-0009-1', 134000, 124000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'),
        N'50ml', N'SKU-0009-2', 139000, 129000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'),
        N'100ml', N'SKU-0009-3', 144000, 134000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'),
        N'30ml', N'SKU-0010-1', 135000, 125000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'),
        N'50ml', N'SKU-0010-2', 140000, 130000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'),
        N'100ml', N'SKU-0010-3', 145000, 135000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'),
        N'30ml', N'SKU-0011-1', 136000, 126000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'),
        N'50ml', N'SKU-0011-2', 141000, 131000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'),
        N'100ml', N'SKU-0011-3', 146000, 136000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'),
        N'30ml', N'SKU-0012-1', 137000, 127000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'),
        N'50ml', N'SKU-0012-2', 142000, 132000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'),
        N'100ml', N'SKU-0012-3', 147000, 137000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'),
        N'30ml', N'SKU-0013-1', 138000, 128000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'),
        N'50ml', N'SKU-0013-2', 143000, 133000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'),
        N'100ml', N'SKU-0013-3', 148000, 138000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'),
        N'30ml', N'SKU-0014-1', 139000, 129000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'),
        N'50ml', N'SKU-0014-2', 144000, 134000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'),
        N'100ml', N'SKU-0014-3', 149000, 139000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'),
        N'30ml', N'SKU-0015-1', 140000, 130000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'),
        N'50ml', N'SKU-0015-2', 145000, 135000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'),
        N'100ml', N'SKU-0015-3', 150000, 140000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'),
        N'30ml', N'SKU-0016-1', 141000, 131000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'),
        N'50ml', N'SKU-0016-2', 146000, 136000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'),
        N'100ml', N'SKU-0016-3', 151000, 141000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'),
        N'30ml', N'SKU-0017-1', 142000, 132000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'),
        N'50ml', N'SKU-0017-2', 147000, 137000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'),
        N'100ml', N'SKU-0017-3', 152000, 142000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'),
        N'30ml', N'SKU-0018-1', 143000, 133000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'),
        N'50ml', N'SKU-0018-2', 148000, 138000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'),
        N'100ml', N'SKU-0018-3', 153000, 143000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'),
        N'30ml', N'SKU-0019-1', 144000, 134000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'),
        N'50ml', N'SKU-0019-2', 149000, 139000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'),
        N'100ml', N'SKU-0019-3', 154000, 144000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'),
        N'30ml', N'SKU-0020-1', 145000, 135000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'),
        N'50ml', N'SKU-0020-2', 150000, 140000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'),
        N'100ml', N'SKU-0020-3', 155000, 145000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'),
        N'30ml', N'SKU-0021-1', 146000, 136000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'),
        N'50ml', N'SKU-0021-2', 151000, 141000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'),
        N'100ml', N'SKU-0021-3', 156000, 146000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'),
        N'30ml', N'SKU-0022-1', 147000, 137000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'),
        N'50ml', N'SKU-0022-2', 152000, 142000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'),
        N'100ml', N'SKU-0022-3', 157000, 147000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'),
        N'30ml', N'SKU-0023-1', 148000, 138000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'),
        N'50ml', N'SKU-0023-2', 153000, 143000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'),
        N'100ml', N'SKU-0023-3', 158000, 148000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'),
        N'30ml', N'SKU-0024-1', 149000, 139000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'),
        N'50ml', N'SKU-0024-2', 154000, 144000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'),
        N'100ml', N'SKU-0024-3', 159000, 149000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'),
        N'30ml', N'SKU-0025-1', 150000, 140000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'),
        N'50ml', N'SKU-0025-2', 155000, 145000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'),
        N'100ml', N'SKU-0025-3', 160000, 150000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'),
        N'30ml', N'SKU-0026-1', 151000, 141000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'),
        N'50ml', N'SKU-0026-2', 156000, 146000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'),
        N'100ml', N'SKU-0026-3', 161000, 151000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'),
        N'30ml', N'SKU-0027-1', 152000, 142000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'),
        N'50ml', N'SKU-0027-2', 157000, 147000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'),
        N'100ml', N'SKU-0027-3', 162000, 152000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'),
        N'30ml', N'SKU-0028-1', 153000, 143000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'),
        N'50ml', N'SKU-0028-2', 158000, 148000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'),
        N'100ml', N'SKU-0028-3', 163000, 153000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'),
        N'30ml', N'SKU-0029-1', 154000, 144000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'),
        N'50ml', N'SKU-0029-2', 159000, 149000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'),
        N'100ml', N'SKU-0029-3', 164000, 154000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'),
        N'30ml', N'SKU-0030-1', 155000, 145000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'),
        N'50ml', N'SKU-0030-2', 160000, 150000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'),
        N'100ml', N'SKU-0030-3', 165000, 155000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'),
        N'30ml', N'SKU-0031-1', 156000, 146000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'),
        N'50ml', N'SKU-0031-2', 161000, 151000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'),
        N'100ml', N'SKU-0031-3', 166000, 156000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'),
        N'30ml', N'SKU-0032-1', 157000, 147000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'),
        N'50ml', N'SKU-0032-2', 162000, 152000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'),
        N'100ml', N'SKU-0032-3', 167000, 157000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'),
        N'30ml', N'SKU-0033-1', 158000, 148000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'),
        N'50ml', N'SKU-0033-2', 163000, 153000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'),
        N'100ml', N'SKU-0033-3', 168000, 158000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'),
        N'30ml', N'SKU-0034-1', 159000, 149000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'),
        N'50ml', N'SKU-0034-2', 164000, 154000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'),
        N'100ml', N'SKU-0034-3', 169000, 159000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'),
        N'30ml', N'SKU-0035-1', 160000, 150000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'),
        N'50ml', N'SKU-0035-2', 165000, 155000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'),
        N'100ml', N'SKU-0035-3', 170000, 160000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'),
        N'30ml', N'SKU-0036-1', 161000, 151000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'),
        N'50ml', N'SKU-0036-2', 166000, 156000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'),
        N'100ml', N'SKU-0036-3', 171000, 161000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'),
        N'30ml', N'SKU-0037-1', 162000, 152000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'),
        N'50ml', N'SKU-0037-2', 167000, 157000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'),
        N'100ml', N'SKU-0037-3', 172000, 162000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'),
        N'30ml', N'SKU-0038-1', 163000, 153000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'),
        N'50ml', N'SKU-0038-2', 168000, 158000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'),
        N'100ml', N'SKU-0038-3', 173000, 163000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'),
        N'30ml', N'SKU-0039-1', 164000, 154000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'),
        N'50ml', N'SKU-0039-2', 169000, 159000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'),
        N'100ml', N'SKU-0039-3', 174000, 164000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'),
        N'30ml', N'SKU-0040-1', 165000, 155000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'),
        N'50ml', N'SKU-0040-2', 170000, 160000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'),
        N'100ml', N'SKU-0040-3', 175000, 165000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'),
        N'30ml', N'SKU-0041-1', 166000, 156000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'),
        N'50ml', N'SKU-0041-2', 171000, 161000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'),
        N'100ml', N'SKU-0041-3', 176000, 166000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'),
        N'30ml', N'SKU-0042-1', 167000, 157000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'),
        N'50ml', N'SKU-0042-2', 172000, 162000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'),
        N'100ml', N'SKU-0042-3', 177000, 167000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'),
        N'30ml', N'SKU-0043-1', 168000, 158000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'),
        N'50ml', N'SKU-0043-2', 173000, 163000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'),
        N'100ml', N'SKU-0043-3', 178000, 168000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'),
        N'30ml', N'SKU-0044-1', 169000, 159000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'),
        N'50ml', N'SKU-0044-2', 174000, 164000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'),
        N'100ml', N'SKU-0044-3', 179000, 169000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'),
        N'30ml', N'SKU-0045-1', 170000, 160000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'),
        N'50ml', N'SKU-0045-2', 175000, 165000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'),
        N'100ml', N'SKU-0045-3', 180000, 170000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'),
        N'30ml', N'SKU-0046-1', 171000, 161000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'),
        N'50ml', N'SKU-0046-2', 176000, 166000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'),
        N'100ml', N'SKU-0046-3', 181000, 171000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'),
        N'30ml', N'SKU-0047-1', 172000, 162000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'),
        N'50ml', N'SKU-0047-2', 177000, 167000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'),
        N'100ml', N'SKU-0047-3', 182000, 172000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'),
        N'30ml', N'SKU-0048-1', 173000, 163000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'),
        N'50ml', N'SKU-0048-2', 178000, 168000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'),
        N'100ml', N'SKU-0048-3', 183000, 173000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'),
        N'30ml', N'SKU-0049-1', 174000, 164000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'),
        N'50ml', N'SKU-0049-2', 179000, 169000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'),
        N'100ml', N'SKU-0049-3', 184000, 174000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'),
        N'30ml', N'SKU-0050-1', 175000, 165000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'),
        N'50ml', N'SKU-0050-2', 180000, 170000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'),
        N'100ml', N'SKU-0050-3', 185000, 175000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'),
        N'30ml', N'SKU-0051-1', 176000, 166000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'),
        N'50ml', N'SKU-0051-2', 181000, 171000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'),
        N'100ml', N'SKU-0051-3', 186000, 176000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'),
        N'30ml', N'SKU-0052-1', 177000, 167000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'),
        N'50ml', N'SKU-0052-2', 182000, 172000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'),
        N'100ml', N'SKU-0052-3', 187000, 177000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'),
        N'30ml', N'SKU-0053-1', 178000, 168000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'),
        N'50ml', N'SKU-0053-2', 183000, 173000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'),
        N'100ml', N'SKU-0053-3', 188000, 178000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'),
        N'30ml', N'SKU-0054-1', 179000, 169000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'),
        N'50ml', N'SKU-0054-2', 184000, 174000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'),
        N'100ml', N'SKU-0054-3', 189000, 179000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'),
        N'30ml', N'SKU-0055-1', 180000, 170000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'),
        N'50ml', N'SKU-0055-2', 185000, 175000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'),
        N'100ml', N'SKU-0055-3', 190000, 180000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'),
        N'30ml', N'SKU-0056-1', 181000, 171000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'),
        N'50ml', N'SKU-0056-2', 186000, 176000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'),
        N'100ml', N'SKU-0056-3', 191000, 181000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'),
        N'30ml', N'SKU-0057-1', 182000, 172000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'),
        N'50ml', N'SKU-0057-2', 187000, 177000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'),
        N'100ml', N'SKU-0057-3', 192000, 182000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'),
        N'30ml', N'SKU-0058-1', 183000, 173000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'),
        N'50ml', N'SKU-0058-2', 188000, 178000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'),
        N'100ml', N'SKU-0058-3', 193000, 183000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'),
        N'30ml', N'SKU-0059-1', 184000, 174000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'),
        N'50ml', N'SKU-0059-2', 189000, 179000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'),
        N'100ml', N'SKU-0059-3', 194000, 184000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'),
        N'30ml', N'SKU-0060-1', 185000, 175000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'),
        N'50ml', N'SKU-0060-2', 190000, 180000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'),
        N'100ml', N'SKU-0060-3', 195000, 185000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'),
        N'30ml', N'SKU-0061-1', 186000, 176000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'),
        N'50ml', N'SKU-0061-2', 191000, 181000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'),
        N'100ml', N'SKU-0061-3', 196000, 186000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'),
        N'30ml', N'SKU-0062-1', 187000, 177000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'),
        N'50ml', N'SKU-0062-2', 192000, 182000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'),
        N'100ml', N'SKU-0062-3', 197000, 187000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'),
        N'30ml', N'SKU-0063-1', 188000, 178000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'),
        N'50ml', N'SKU-0063-2', 193000, 183000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'),
        N'100ml', N'SKU-0063-3', 198000, 188000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'),
        N'30ml', N'SKU-0064-1', 189000, 179000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'),
        N'50ml', N'SKU-0064-2', 194000, 184000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'),
        N'100ml', N'SKU-0064-3', 199000, 189000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'),
        N'30ml', N'SKU-0065-1', 190000, 180000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'),
        N'50ml', N'SKU-0065-2', 195000, 185000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'),
        N'100ml', N'SKU-0065-3', 200000, 190000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'),
        N'30ml', N'SKU-0066-1', 191000, 181000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'),
        N'50ml', N'SKU-0066-2', 196000, 186000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'),
        N'100ml', N'SKU-0066-3', 201000, 191000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'),
        N'30ml', N'SKU-0067-1', 192000, 182000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'),
        N'50ml', N'SKU-0067-2', 197000, 187000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'),
        N'100ml', N'SKU-0067-3', 202000, 192000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'),
        N'30ml', N'SKU-0068-1', 193000, 183000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'),
        N'50ml', N'SKU-0068-2', 198000, 188000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'),
        N'100ml', N'SKU-0068-3', 203000, 193000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'),
        N'30ml', N'SKU-0069-1', 194000, 184000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'),
        N'50ml', N'SKU-0069-2', 199000, 189000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'),
        N'100ml', N'SKU-0069-3', 204000, 194000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'),
        N'30ml', N'SKU-0070-1', 195000, 185000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'),
        N'50ml', N'SKU-0070-2', 200000, 190000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'),
        N'100ml', N'SKU-0070-3', 205000, 195000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'),
        N'30ml', N'SKU-0071-1', 196000, 186000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'),
        N'50ml', N'SKU-0071-2', 201000, 191000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'),
        N'100ml', N'SKU-0071-3', 206000, 196000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'),
        N'30ml', N'SKU-0072-1', 197000, 187000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'),
        N'50ml', N'SKU-0072-2', 202000, 192000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'),
        N'100ml', N'SKU-0072-3', 207000, 197000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'),
        N'30ml', N'SKU-0073-1', 198000, 188000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'),
        N'50ml', N'SKU-0073-2', 203000, 193000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'),
        N'100ml', N'SKU-0073-3', 208000, 198000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'),
        N'30ml', N'SKU-0074-1', 199000, 189000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'),
        N'50ml', N'SKU-0074-2', 204000, 194000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'),
        N'100ml', N'SKU-0074-3', 209000, 199000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'),
        N'30ml', N'SKU-0075-1', 200000, 190000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'),
        N'50ml', N'SKU-0075-2', 205000, 195000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'),
        N'100ml', N'SKU-0075-3', 210000, 200000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'),
        N'30ml', N'SKU-0076-1', 201000, 191000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'),
        N'50ml', N'SKU-0076-2', 206000, 196000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'),
        N'100ml', N'SKU-0076-3', 211000, 201000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'),
        N'30ml', N'SKU-0077-1', 202000, 192000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'),
        N'50ml', N'SKU-0077-2', 207000, 197000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'),
        N'100ml', N'SKU-0077-3', 212000, 202000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'),
        N'30ml', N'SKU-0078-1', 203000, 193000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'),
        N'50ml', N'SKU-0078-2', 208000, 198000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'),
        N'100ml', N'SKU-0078-3', 213000, 203000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'),
        N'30ml', N'SKU-0079-1', 204000, 194000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'),
        N'50ml', N'SKU-0079-2', 209000, 199000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'),
        N'100ml', N'SKU-0079-3', 214000, 204000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'),
        N'30ml', N'SKU-0080-1', 205000, 195000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'),
        N'50ml', N'SKU-0080-2', 210000, 200000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'),
        N'100ml', N'SKU-0080-3', 215000, 205000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'),
        N'30ml', N'SKU-0081-1', 206000, 196000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'),
        N'50ml', N'SKU-0081-2', 211000, 201000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'),
        N'100ml', N'SKU-0081-3', 216000, 206000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'),
        N'30ml', N'SKU-0082-1', 207000, 197000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'),
        N'50ml', N'SKU-0082-2', 212000, 202000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'),
        N'100ml', N'SKU-0082-3', 217000, 207000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'),
        N'30ml', N'SKU-0083-1', 208000, 198000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'),
        N'50ml', N'SKU-0083-2', 213000, 203000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'),
        N'100ml', N'SKU-0083-3', 218000, 208000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'),
        N'30ml', N'SKU-0084-1', 209000, 199000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'),
        N'50ml', N'SKU-0084-2', 214000, 204000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'),
        N'100ml', N'SKU-0084-3', 219000, 209000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'),
        N'30ml', N'SKU-0085-1', 210000, 200000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'),
        N'50ml', N'SKU-0085-2', 215000, 205000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'),
        N'100ml', N'SKU-0085-3', 220000, 210000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'),
        N'30ml', N'SKU-0086-1', 211000, 201000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'),
        N'50ml', N'SKU-0086-2', 216000, 206000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'),
        N'100ml', N'SKU-0086-3', 221000, 211000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'),
        N'30ml', N'SKU-0087-1', 212000, 202000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'),
        N'50ml', N'SKU-0087-2', 217000, 207000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'),
        N'100ml', N'SKU-0087-3', 222000, 212000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'),
        N'30ml', N'SKU-0088-1', 213000, 203000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'),
        N'50ml', N'SKU-0088-2', 218000, 208000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'),
        N'100ml', N'SKU-0088-3', 223000, 213000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'),
        N'30ml', N'SKU-0089-1', 214000, 204000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'),
        N'50ml', N'SKU-0089-2', 219000, 209000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'),
        N'100ml', N'SKU-0089-3', 224000, 214000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'),
        N'30ml', N'SKU-0090-1', 215000, 205000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'),
        N'50ml', N'SKU-0090-2', 220000, 210000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'),
        N'100ml', N'SKU-0090-3', 225000, 215000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'),
        N'30ml', N'SKU-0091-1', 216000, 206000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'),
        N'50ml', N'SKU-0091-2', 221000, 211000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'),
        N'100ml', N'SKU-0091-3', 226000, 216000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'),
        N'30ml', N'SKU-0092-1', 217000, 207000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'),
        N'50ml', N'SKU-0092-2', 222000, 212000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'),
        N'100ml', N'SKU-0092-3', 227000, 217000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'),
        N'30ml', N'SKU-0093-1', 218000, 208000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'),
        N'50ml', N'SKU-0093-2', 223000, 213000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'),
        N'100ml', N'SKU-0093-3', 228000, 218000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'),
        N'30ml', N'SKU-0094-1', 219000, 209000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'),
        N'50ml', N'SKU-0094-2', 224000, 214000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'),
        N'100ml', N'SKU-0094-3', 229000, 219000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'),
        N'30ml', N'SKU-0095-1', 220000, 210000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'),
        N'50ml', N'SKU-0095-2', 225000, 215000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'),
        N'100ml', N'SKU-0095-3', 230000, 220000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'),
        N'30ml', N'SKU-0096-1', 221000, 211000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'),
        N'50ml', N'SKU-0096-2', 226000, 216000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'),
        N'100ml', N'SKU-0096-3', 231000, 221000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'),
        N'30ml', N'SKU-0097-1', 222000, 212000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'),
        N'50ml', N'SKU-0097-2', 227000, 217000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'),
        N'100ml', N'SKU-0097-3', 232000, 222000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'),
        N'30ml', N'SKU-0098-1', 223000, 213000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'),
        N'50ml', N'SKU-0098-2', 228000, 218000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'),
        N'100ml', N'SKU-0098-3', 233000, 223000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'),
        N'30ml', N'SKU-0099-1', 224000, 214000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'),
        N'50ml', N'SKU-0099-2', 229000, 219000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'),
        N'100ml', N'SKU-0099-3', 234000, 224000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'),
        N'30ml', N'SKU-0100-1', 225000, 215000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'),
        N'50ml', N'SKU-0100-2', 230000, 220000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'),
        N'100ml', N'SKU-0100-3', 235000, 225000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'),
        N'30ml', N'SKU-0101-1', 226000, 216000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'),
        N'50ml', N'SKU-0101-2', 231000, 221000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'),
        N'100ml', N'SKU-0101-3', 236000, 226000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'),
        N'30ml', N'SKU-0102-1', 227000, 217000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'),
        N'50ml', N'SKU-0102-2', 232000, 222000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'),
        N'100ml', N'SKU-0102-3', 237000, 227000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'),
        N'30ml', N'SKU-0103-1', 228000, 218000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'),
        N'50ml', N'SKU-0103-2', 233000, 223000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'),
        N'100ml', N'SKU-0103-3', 238000, 228000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'),
        N'30ml', N'SKU-0104-1', 229000, 219000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'),
        N'50ml', N'SKU-0104-2', 234000, 224000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'),
        N'100ml', N'SKU-0104-3', 239000, 229000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'),
        N'30ml', N'SKU-0105-1', 230000, 220000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'),
        N'50ml', N'SKU-0105-2', 235000, 225000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'),
        N'100ml', N'SKU-0105-3', 240000, 230000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'),
        N'30ml', N'SKU-0106-1', 231000, 221000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'),
        N'50ml', N'SKU-0106-2', 236000, 226000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'),
        N'100ml', N'SKU-0106-3', 241000, 231000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'),
        N'30ml', N'SKU-0107-1', 232000, 222000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'),
        N'50ml', N'SKU-0107-2', 237000, 227000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'),
        N'100ml', N'SKU-0107-3', 242000, 232000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'),
        N'30ml', N'SKU-0108-1', 233000, 223000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'),
        N'50ml', N'SKU-0108-2', 238000, 228000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'),
        N'100ml', N'SKU-0108-3', 243000, 233000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'),
        N'30ml', N'SKU-0109-1', 234000, 224000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'),
        N'50ml', N'SKU-0109-2', 239000, 229000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'),
        N'100ml', N'SKU-0109-3', 244000, 234000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'),
        N'30ml', N'SKU-0110-1', 235000, 225000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'),
        N'50ml', N'SKU-0110-2', 240000, 230000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'),
        N'100ml', N'SKU-0110-3', 245000, 235000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'),
        N'30ml', N'SKU-0111-1', 236000, 226000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'),
        N'50ml', N'SKU-0111-2', 241000, 231000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'),
        N'100ml', N'SKU-0111-3', 246000, 236000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'),
        N'30ml', N'SKU-0112-1', 237000, 227000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'),
        N'50ml', N'SKU-0112-2', 242000, 232000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'),
        N'100ml', N'SKU-0112-3', 247000, 237000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'),
        N'30ml', N'SKU-0113-1', 238000, 228000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'),
        N'50ml', N'SKU-0113-2', 243000, 233000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'),
        N'100ml', N'SKU-0113-3', 248000, 238000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'),
        N'30ml', N'SKU-0114-1', 239000, 229000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'),
        N'50ml', N'SKU-0114-2', 244000, 234000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'),
        N'100ml', N'SKU-0114-3', 249000, 239000, 65, 1, GETDATE(), N'Seed', 3
    );

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40') AND VariantName = N'30ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'),
        N'30ml', N'SKU-0115-1', 240000, 230000, 55, 1, GETDATE(), N'Seed', 1
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40') AND VariantName = N'50ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'),
        N'50ml', N'SKU-0115-2', 245000, 235000, 60, 1, GETDATE(), N'Seed', 2
    );
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_variant WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40') AND VariantName = N'100ml')
    INSERT INTO dbo.cf_product_variant (ProductId, VariantName, Sku, Price, SalePrice, StockQty, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (
        (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'),
        N'100ml', N'SKU-0115-3', 250000, 240000, 65, 1, GETDATE(), N'Seed', 3
    );

-- Product images
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0001-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'), N'/images/products/seed/p0001-1.jpg', 1, N'Sữa rửa mặt dịu nhẹ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0001-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'), N'/images/products/seed/p0001-2.jpg', 0, N'Sữa rửa mặt dịu nhẹ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0001-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'), N'/images/products/seed/p0001-3.jpg', 0, N'Sữa rửa mặt dịu nhẹ', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu') AND ImageUrl = N'/images/products/seed/p0002-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'), N'/images/products/seed/p0002-1.jpg', 1, N'Gel rửa mặt kiềm dầu', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu') AND ImageUrl = N'/images/products/seed/p0002-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'), N'/images/products/seed/p0002-2.jpg', 0, N'Gel rửa mặt kiềm dầu', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu') AND ImageUrl = N'/images/products/seed/p0002-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'), N'/images/products/seed/p0002-3.jpg', 0, N'Gel rửa mặt kiềm dầu', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar') AND ImageUrl = N'/images/products/seed/p0003-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'), N'/images/products/seed/p0003-1.jpg', 1, N'Nước tẩy trang micellar', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar') AND ImageUrl = N'/images/products/seed/p0003-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'), N'/images/products/seed/p0003-2.jpg', 0, N'Nước tẩy trang micellar', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar') AND ImageUrl = N'/images/products/seed/p0003-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'), N'/images/products/seed/p0003-3.jpg', 0, N'Nước tẩy trang micellar', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da') AND ImageUrl = N'/images/products/seed/p0004-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'), N'/images/products/seed/p0004-1.jpg', 1, N'Toner cân bằng da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da') AND ImageUrl = N'/images/products/seed/p0004-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'), N'/images/products/seed/p0004-2.jpg', 0, N'Toner cân bằng da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da') AND ImageUrl = N'/images/products/seed/p0004-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'), N'/images/products/seed/p0004-3.jpg', 0, N'Toner cân bằng da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da') AND ImageUrl = N'/images/products/seed/p0005-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'), N'/images/products/seed/p0005-1.jpg', 1, N'Serum vitamin C sáng da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da') AND ImageUrl = N'/images/products/seed/p0005-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'), N'/images/products/seed/p0005-2.jpg', 0, N'Serum vitamin C sáng da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da') AND ImageUrl = N'/images/products/seed/p0005-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'), N'/images/products/seed/p0005-3.jpg', 0, N'Serum vitamin C sáng da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da') AND ImageUrl = N'/images/products/seed/p0006-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'), N'/images/products/seed/p0006-1.jpg', 1, N'Serum phục hồi da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da') AND ImageUrl = N'/images/products/seed/p0006-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'), N'/images/products/seed/p0006-2.jpg', 0, N'Serum phục hồi da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da') AND ImageUrl = N'/images/products/seed/p0006-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'), N'/images/products/seed/p0006-3.jpg', 0, N'Serum phục hồi da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm') AND ImageUrl = N'/images/products/seed/p0007-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'), N'/images/products/seed/p0007-1.jpg', 1, N'Kem dưỡng ẩm ban đêm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm') AND ImageUrl = N'/images/products/seed/p0007-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'), N'/images/products/seed/p0007-2.jpg', 0, N'Kem dưỡng ẩm ban đêm', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm') AND ImageUrl = N'/images/products/seed/p0007-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'), N'/images/products/seed/p0007-3.jpg', 0, N'Kem dưỡng ẩm ban đêm', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm') AND ImageUrl = N'/images/products/seed/p0008-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'), N'/images/products/seed/p0008-1.jpg', 1, N'Mặt nạ dưỡng ẩm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm') AND ImageUrl = N'/images/products/seed/p0008-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'), N'/images/products/seed/p0008-2.jpg', 0, N'Mặt nạ dưỡng ẩm', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm') AND ImageUrl = N'/images/products/seed/p0008-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'), N'/images/products/seed/p0008-3.jpg', 0, N'Mặt nạ dưỡng ẩm', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0009-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'), N'/images/products/seed/p0009-1.jpg', 1, N'Tẩy tế bào chết dịu nhẹ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0009-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'), N'/images/products/seed/p0009-2.jpg', 0, N'Tẩy tế bào chết dịu nhẹ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0009-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'), N'/images/products/seed/p0009-3.jpg', 0, N'Tẩy tế bào chết dịu nhẹ', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm') AND ImageUrl = N'/images/products/seed/p0010-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'), N'/images/products/seed/p0010-1.jpg', 1, N'Kem dưỡng mắt giảm thâm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm') AND ImageUrl = N'/images/products/seed/p0010-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'), N'/images/products/seed/p0010-2.jpg', 0, N'Kem dưỡng mắt giảm thâm', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm') AND ImageUrl = N'/images/products/seed/p0010-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'), N'/images/products/seed/p0010-3.jpg', 0, N'Kem dưỡng mắt giảm thâm', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi') AND ImageUrl = N'/images/products/seed/p0011-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'), N'/images/products/seed/p0011-1.jpg', 1, N'Kem nền lâu trôi', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi') AND ImageUrl = N'/images/products/seed/p0011-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'), N'/images/products/seed/p0011-2.jpg', 0, N'Kem nền lâu trôi', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi') AND ImageUrl = N'/images/products/seed/p0011-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'), N'/images/products/seed/p0011-3.jpg', 0, N'Kem nền lâu trôi', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu') AND ImageUrl = N'/images/products/seed/p0012-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'), N'/images/products/seed/p0012-1.jpg', 1, N'Phấn phủ kiềm dầu', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu') AND ImageUrl = N'/images/products/seed/p0012-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'), N'/images/products/seed/p0012-2.jpg', 0, N'Phấn phủ kiềm dầu', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu') AND ImageUrl = N'/images/products/seed/p0012-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'), N'/images/products/seed/p0012-3.jpg', 0, N'Phấn phủ kiềm dầu', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì') AND ImageUrl = N'/images/products/seed/p0013-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'), N'/images/products/seed/p0013-1.jpg', 1, N'Son kem lì', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì') AND ImageUrl = N'/images/products/seed/p0013-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'), N'/images/products/seed/p0013-2.jpg', 0, N'Son kem lì', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì') AND ImageUrl = N'/images/products/seed/p0013-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'), N'/images/products/seed/p0013-3.jpg', 0, N'Son kem lì', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi') AND ImageUrl = N'/images/products/seed/p0014-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'), N'/images/products/seed/p0014-1.jpg', 1, N'Mascara dày mi', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi') AND ImageUrl = N'/images/products/seed/p0014-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'), N'/images/products/seed/p0014-2.jpg', 0, N'Mascara dày mi', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi') AND ImageUrl = N'/images/products/seed/p0014-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'), N'/images/products/seed/p0014-3.jpg', 0, N'Mascara dày mi', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước') AND ImageUrl = N'/images/products/seed/p0015-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'), N'/images/products/seed/p0015-1.jpg', 1, N'Bút kẻ mắt chống nước', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước') AND ImageUrl = N'/images/products/seed/p0015-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'), N'/images/products/seed/p0015-2.jpg', 0, N'Bút kẻ mắt chống nước', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước') AND ImageUrl = N'/images/products/seed/p0015-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'), N'/images/products/seed/p0015-3.jpg', 0, N'Bút kẻ mắt chống nước', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem') AND ImageUrl = N'/images/products/seed/p0016-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'), N'/images/products/seed/p0016-1.jpg', 1, N'Má hồng dạng kem', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem') AND ImageUrl = N'/images/products/seed/p0016-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'), N'/images/products/seed/p0016-2.jpg', 0, N'Má hồng dạng kem', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem') AND ImageUrl = N'/images/products/seed/p0016-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'), N'/images/products/seed/p0016-3.jpg', 0, N'Má hồng dạng kem', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng') AND ImageUrl = N'/images/products/seed/p0017-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'), N'/images/products/seed/p0017-1.jpg', 1, N'Che khuyết điểm đa năng', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng') AND ImageUrl = N'/images/products/seed/p0017-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'), N'/images/products/seed/p0017-2.jpg', 0, N'Che khuyết điểm đa năng', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng') AND ImageUrl = N'/images/products/seed/p0017-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'), N'/images/products/seed/p0017-3.jpg', 0, N'Che khuyết điểm đa năng', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản') AND ImageUrl = N'/images/products/seed/p0018-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'), N'/images/products/seed/p0018-1.jpg', 1, N'Bộ cọ trang điểm cơ bản', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản') AND ImageUrl = N'/images/products/seed/p0018-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'), N'/images/products/seed/p0018-2.jpg', 0, N'Bộ cọ trang điểm cơ bản', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản') AND ImageUrl = N'/images/products/seed/p0018-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'), N'/images/products/seed/p0018-3.jpg', 0, N'Bộ cọ trang điểm cơ bản', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc') AND ImageUrl = N'/images/products/seed/p0019-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'), N'/images/products/seed/p0019-1.jpg', 1, N'Dầu gội phục hồi tóc', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc') AND ImageUrl = N'/images/products/seed/p0019-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'), N'/images/products/seed/p0019-2.jpg', 0, N'Dầu gội phục hồi tóc', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc') AND ImageUrl = N'/images/products/seed/p0019-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'), N'/images/products/seed/p0019-3.jpg', 0, N'Dầu gội phục hồi tóc', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt') AND ImageUrl = N'/images/products/seed/p0020-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'), N'/images/products/seed/p0020-1.jpg', 1, N'Dầu xả suôn mượt', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt') AND ImageUrl = N'/images/products/seed/p0020-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'), N'/images/products/seed/p0020-2.jpg', 0, N'Dầu xả suôn mượt', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt') AND ImageUrl = N'/images/products/seed/p0020-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'), N'/images/products/seed/p0020-3.jpg', 0, N'Dầu xả suôn mượt', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin') AND ImageUrl = N'/images/products/seed/p0021-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'), N'/images/products/seed/p0021-1.jpg', 1, N'Ủ tóc keratin', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin') AND ImageUrl = N'/images/products/seed/p0021-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'), N'/images/products/seed/p0021-2.jpg', 0, N'Ủ tóc keratin', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin') AND ImageUrl = N'/images/products/seed/p0021-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'), N'/images/products/seed/p0021-3.jpg', 0, N'Ủ tóc keratin', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc') AND ImageUrl = N'/images/products/seed/p0022-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'), N'/images/products/seed/p0022-1.jpg', 1, N'Tinh dầu dưỡng tóc', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc') AND ImageUrl = N'/images/products/seed/p0022-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'), N'/images/products/seed/p0022-2.jpg', 0, N'Tinh dầu dưỡng tóc', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc') AND ImageUrl = N'/images/products/seed/p0022-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'), N'/images/products/seed/p0022-3.jpg', 0, N'Tinh dầu dưỡng tóc', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt') AND ImageUrl = N'/images/products/seed/p0023-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'), N'/images/products/seed/p0023-1.jpg', 1, N'Xịt dưỡng tóc mềm mượt', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt') AND ImageUrl = N'/images/products/seed/p0023-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'), N'/images/products/seed/p0023-2.jpg', 0, N'Xịt dưỡng tóc mềm mượt', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt') AND ImageUrl = N'/images/products/seed/p0023-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'), N'/images/products/seed/p0023-3.jpg', 0, N'Xịt dưỡng tóc mềm mượt', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu') AND ImageUrl = N'/images/products/seed/p0024-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'), N'/images/products/seed/p0024-1.jpg', 1, N'Gel tạo kiểu', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu') AND ImageUrl = N'/images/products/seed/p0024-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'), N'/images/products/seed/p0024-2.jpg', 0, N'Gel tạo kiểu', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu') AND ImageUrl = N'/images/products/seed/p0024-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'), N'/images/products/seed/p0024-3.jpg', 0, N'Gel tạo kiểu', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe') AND ImageUrl = N'/images/products/seed/p0025-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'), N'/images/products/seed/p0025-1.jpg', 1, N'Serum tóc bóng khỏe', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe') AND ImageUrl = N'/images/products/seed/p0025-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'), N'/images/products/seed/p0025-2.jpg', 0, N'Serum tóc bóng khỏe', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe') AND ImageUrl = N'/images/products/seed/p0025-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'), N'/images/products/seed/p0025-3.jpg', 0, N'Serum tóc bóng khỏe', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà') AND ImageUrl = N'/images/products/seed/p0026-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'), N'/images/products/seed/p0026-1.jpg', 1, N'Màu nhuộm tóc tại nhà', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà') AND ImageUrl = N'/images/products/seed/p0026-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'), N'/images/products/seed/p0026-2.jpg', 0, N'Màu nhuộm tóc tại nhà', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà') AND ImageUrl = N'/images/products/seed/p0026-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'), N'/images/products/seed/p0026-3.jpg', 0, N'Màu nhuộm tóc tại nhà', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa') AND ImageUrl = N'/images/products/seed/p0027-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'), N'/images/products/seed/p0027-1.jpg', 1, N'Sữa tắm hương hoa', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa') AND ImageUrl = N'/images/products/seed/p0027-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'), N'/images/products/seed/p0027-2.jpg', 0, N'Sữa tắm hương hoa', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa') AND ImageUrl = N'/images/products/seed/p0027-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'), N'/images/products/seed/p0027-3.jpg', 0, N'Sữa tắm hương hoa', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body') AND ImageUrl = N'/images/products/seed/p0028-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'), N'/images/products/seed/p0028-1.jpg', 1, N'Tẩy tế bào chết body', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body') AND ImageUrl = N'/images/products/seed/p0028-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'), N'/images/products/seed/p0028-2.jpg', 0, N'Tẩy tế bào chết body', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body') AND ImageUrl = N'/images/products/seed/p0028-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'), N'/images/products/seed/p0028-3.jpg', 0, N'Tẩy tế bào chết body', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da') AND ImageUrl = N'/images/products/seed/p0029-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'), N'/images/products/seed/p0029-1.jpg', 1, N'Kem dưỡng thể trắng da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da') AND ImageUrl = N'/images/products/seed/p0029-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'), N'/images/products/seed/p0029-2.jpg', 0, N'Kem dưỡng thể trắng da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da') AND ImageUrl = N'/images/products/seed/p0029-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'), N'/images/products/seed/p0029-3.jpg', 0, N'Kem dưỡng thể trắng da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi') AND ImageUrl = N'/images/products/seed/p0030-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'), N'/images/products/seed/p0030-1.jpg', 1, N'Lăn khử mùi', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi') AND ImageUrl = N'/images/products/seed/p0030-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'), N'/images/products/seed/p0030-2.jpg', 0, N'Lăn khử mùi', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi') AND ImageUrl = N'/images/products/seed/p0030-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'), N'/images/products/seed/p0030-3.jpg', 0, N'Lăn khử mùi', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay') AND ImageUrl = N'/images/products/seed/p0031-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'), N'/images/products/seed/p0031-1.jpg', 1, N'Kem dưỡng da tay', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay') AND ImageUrl = N'/images/products/seed/p0031-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'), N'/images/products/seed/p0031-2.jpg', 0, N'Kem dưỡng da tay', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay') AND ImageUrl = N'/images/products/seed/p0031-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'), N'/images/products/seed/p0031-3.jpg', 0, N'Kem dưỡng da tay', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân') AND ImageUrl = N'/images/products/seed/p0032-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'), N'/images/products/seed/p0032-1.jpg', 1, N'Kem dưỡng gót chân', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân') AND ImageUrl = N'/images/products/seed/p0032-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'), N'/images/products/seed/p0032-2.jpg', 0, N'Kem dưỡng gót chân', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân') AND ImageUrl = N'/images/products/seed/p0032-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'), N'/images/products/seed/p0032-3.jpg', 0, N'Kem dưỡng gót chân', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi') AND ImageUrl = N'/images/products/seed/p0033-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'), N'/images/products/seed/p0033-1.jpg', 1, N'Son dưỡng môi', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi') AND ImageUrl = N'/images/products/seed/p0033-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'), N'/images/products/seed/p0033-2.jpg', 0, N'Son dưỡng môi', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi') AND ImageUrl = N'/images/products/seed/p0033-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'), N'/images/products/seed/p0033-3.jpg', 0, N'Son dưỡng môi', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót') AND ImageUrl = N'/images/products/seed/p0034-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'), N'/images/products/seed/p0034-1.jpg', 1, N'Kem chống nứt gót', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót') AND ImageUrl = N'/images/products/seed/p0034-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'), N'/images/products/seed/p0034-2.jpg', 0, N'Kem chống nứt gót', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót') AND ImageUrl = N'/images/products/seed/p0034-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'), N'/images/products/seed/p0034-3.jpg', 0, N'Kem chống nứt gót', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50') AND ImageUrl = N'/images/products/seed/p0035-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'), N'/images/products/seed/p0035-1.jpg', 1, N'Kem chống nắng SPF50', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50') AND ImageUrl = N'/images/products/seed/p0035-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'), N'/images/products/seed/p0035-2.jpg', 0, N'Kem chống nắng SPF50', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50') AND ImageUrl = N'/images/products/seed/p0035-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'), N'/images/products/seed/p0035-3.jpg', 0, N'Kem chống nắng SPF50', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0036-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'), N'/images/products/seed/p0036-1.jpg', 1, N'Sữa chống nắng dịu nhẹ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0036-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'), N'/images/products/seed/p0036-2.jpg', 0, N'Sữa chống nắng dịu nhẹ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0036-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'), N'/images/products/seed/p0036-3.jpg', 0, N'Sữa chống nắng dịu nhẹ', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi') AND ImageUrl = N'/images/products/seed/p0037-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'), N'/images/products/seed/p0037-1.jpg', 1, N'Xịt chống nắng tiện lợi', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi') AND ImageUrl = N'/images/products/seed/p0037-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'), N'/images/products/seed/p0037-2.jpg', 0, N'Xịt chống nắng tiện lợi', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi') AND ImageUrl = N'/images/products/seed/p0037-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'), N'/images/products/seed/p0037-3.jpg', 0, N'Xịt chống nắng tiện lợi', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body') AND ImageUrl = N'/images/products/seed/p0038-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'), N'/images/products/seed/p0038-1.jpg', 1, N'Chống nắng body', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body') AND ImageUrl = N'/images/products/seed/p0038-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'), N'/images/products/seed/p0038-2.jpg', 0, N'Chống nắng body', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body') AND ImageUrl = N'/images/products/seed/p0038-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'), N'/images/products/seed/p0038-3.jpg', 0, N'Chống nắng body', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông') AND ImageUrl = N'/images/products/seed/p0039-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'), N'/images/products/seed/p0039-1.jpg', 1, N'Chống nắng nâng tông', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông') AND ImageUrl = N'/images/products/seed/p0039-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'), N'/images/products/seed/p0039-2.jpg', 0, N'Chống nắng nâng tông', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông') AND ImageUrl = N'/images/products/seed/p0039-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'), N'/images/products/seed/p0039-3.jpg', 0, N'Chống nắng nâng tông', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch') AND ImageUrl = N'/images/products/seed/p0040-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'), N'/images/products/seed/p0040-1.jpg', 1, N'Nước hoa nữ thanh lịch', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch') AND ImageUrl = N'/images/products/seed/p0040-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'), N'/images/products/seed/p0040-2.jpg', 0, N'Nước hoa nữ thanh lịch', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch') AND ImageUrl = N'/images/products/seed/p0040-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'), N'/images/products/seed/p0040-3.jpg', 0, N'Nước hoa nữ thanh lịch', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ') AND ImageUrl = N'/images/products/seed/p0041-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'), N'/images/products/seed/p0041-1.jpg', 1, N'Nước hoa nam mạnh mẽ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ') AND ImageUrl = N'/images/products/seed/p0041-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'), N'/images/products/seed/p0041-2.jpg', 0, N'Nước hoa nam mạnh mẽ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ') AND ImageUrl = N'/images/products/seed/p0041-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'), N'/images/products/seed/p0041-3.jpg', 0, N'Nước hoa nam mạnh mẽ', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex') AND ImageUrl = N'/images/products/seed/p0042-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'), N'/images/products/seed/p0042-1.jpg', 1, N'Nước hoa unisex', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex') AND ImageUrl = N'/images/products/seed/p0042-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'), N'/images/products/seed/p0042-2.jpg', 0, N'Nước hoa unisex', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex') AND ImageUrl = N'/images/products/seed/p0042-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'), N'/images/products/seed/p0042-3.jpg', 0, N'Nước hoa unisex', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body') AND ImageUrl = N'/images/products/seed/p0043-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'), N'/images/products/seed/p0043-1.jpg', 1, N'Xịt thơm body', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body') AND ImageUrl = N'/images/products/seed/p0043-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'), N'/images/products/seed/p0043-2.jpg', 0, N'Xịt thơm body', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body') AND ImageUrl = N'/images/products/seed/p0043-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'), N'/images/products/seed/p0043-3.jpg', 0, N'Xịt thơm body', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa') AND ImageUrl = N'/images/products/seed/p0044-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'), N'/images/products/seed/p0044-1.jpg', 1, N'Set quà nước hoa', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa') AND ImageUrl = N'/images/products/seed/p0044-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'), N'/images/products/seed/p0044-2.jpg', 0, N'Set quà nước hoa', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa') AND ImageUrl = N'/images/products/seed/p0044-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'), N'/images/products/seed/p0044-3.jpg', 0, N'Set quà nước hoa', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn') AND ImageUrl = N'/images/products/seed/p0045-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'), N'/images/products/seed/p0045-1.jpg', 1, N'Kem trị mụn', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn') AND ImageUrl = N'/images/products/seed/p0045-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'), N'/images/products/seed/p0045-2.jpg', 0, N'Kem trị mụn', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn') AND ImageUrl = N'/images/products/seed/p0045-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'), N'/images/products/seed/p0045-3.jpg', 0, N'Kem trị mụn', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da') AND ImageUrl = N'/images/products/seed/p0046-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'), N'/images/products/seed/p0046-1.jpg', 1, N'Kem phục hồi da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da') AND ImageUrl = N'/images/products/seed/p0046-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'), N'/images/products/seed/p0046-2.jpg', 0, N'Kem phục hồi da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da') AND ImageUrl = N'/images/products/seed/p0046-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'), N'/images/products/seed/p0046-3.jpg', 0, N'Kem phục hồi da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng') AND ImageUrl = N'/images/products/seed/p0047-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'), N'/images/products/seed/p0047-1.jpg', 1, N'Serum giảm kích ứng', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng') AND ImageUrl = N'/images/products/seed/p0047-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'), N'/images/products/seed/p0047-2.jpg', 0, N'Serum giảm kích ứng', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng') AND ImageUrl = N'/images/products/seed/p0047-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'), N'/images/products/seed/p0047-3.jpg', 0, N'Serum giảm kích ứng', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da') AND ImageUrl = N'/images/products/seed/p0048-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'), N'/images/products/seed/p0048-1.jpg', 1, N'Tinh chất làm sáng da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da') AND ImageUrl = N'/images/products/seed/p0048-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'), N'/images/products/seed/p0048-2.jpg', 0, N'Tinh chất làm sáng da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da') AND ImageUrl = N'/images/products/seed/p0048-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'), N'/images/products/seed/p0048-3.jpg', 0, N'Tinh chất làm sáng da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu') AND ImageUrl = N'/images/products/seed/p0049-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'), N'/images/products/seed/p0049-1.jpg', 1, N'Kem dưỡng ẩm sâu', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu') AND ImageUrl = N'/images/products/seed/p0049-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'), N'/images/products/seed/p0049-2.jpg', 0, N'Kem dưỡng ẩm sâu', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu') AND ImageUrl = N'/images/products/seed/p0049-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'), N'/images/products/seed/p0049-3.jpg', 0, N'Kem dưỡng ẩm sâu', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam') AND ImageUrl = N'/images/products/seed/p0050-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'), N'/images/products/seed/p0050-1.jpg', 1, N'Sữa rửa mặt nam', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam') AND ImageUrl = N'/images/products/seed/p0050-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'), N'/images/products/seed/p0050-2.jpg', 0, N'Sữa rửa mặt nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam') AND ImageUrl = N'/images/products/seed/p0050-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'), N'/images/products/seed/p0050-3.jpg', 0, N'Sữa rửa mặt nam', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam') AND ImageUrl = N'/images/products/seed/p0051-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'), N'/images/products/seed/p0051-1.jpg', 1, N'Kem dưỡng nam', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam') AND ImageUrl = N'/images/products/seed/p0051-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'), N'/images/products/seed/p0051-2.jpg', 0, N'Kem dưỡng nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam') AND ImageUrl = N'/images/products/seed/p0051-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'), N'/images/products/seed/p0051-3.jpg', 0, N'Kem dưỡng nam', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam') AND ImageUrl = N'/images/products/seed/p0052-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'), N'/images/products/seed/p0052-1.jpg', 1, N'Sáp tạo kiểu tóc nam', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam') AND ImageUrl = N'/images/products/seed/p0052-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'), N'/images/products/seed/p0052-2.jpg', 0, N'Sáp tạo kiểu tóc nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam') AND ImageUrl = N'/images/products/seed/p0052-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'), N'/images/products/seed/p0052-3.jpg', 0, N'Sáp tạo kiểu tóc nam', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam') AND ImageUrl = N'/images/products/seed/p0053-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'), N'/images/products/seed/p0053-1.jpg', 1, N'Lăn khử mùi nam', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam') AND ImageUrl = N'/images/products/seed/p0053-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'), N'/images/products/seed/p0053-2.jpg', 0, N'Lăn khử mùi nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam') AND ImageUrl = N'/images/products/seed/p0053-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'), N'/images/products/seed/p0053-3.jpg', 0, N'Lăn khử mùi nam', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính') AND ImageUrl = N'/images/products/seed/p0054-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'), N'/images/products/seed/p0054-1.jpg', 1, N'Nước hoa nam cá tính', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính') AND ImageUrl = N'/images/products/seed/p0054-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'), N'/images/products/seed/p0054-2.jpg', 0, N'Nước hoa nam cá tính', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính') AND ImageUrl = N'/images/products/seed/p0054-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'), N'/images/products/seed/p0054-3.jpg', 0, N'Nước hoa nam cá tính', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé') AND ImageUrl = N'/images/products/seed/p0055-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'), N'/images/products/seed/p0055-1.jpg', 1, N'Sữa tắm gội cho bé', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé') AND ImageUrl = N'/images/products/seed/p0055-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'), N'/images/products/seed/p0055-2.jpg', 0, N'Sữa tắm gội cho bé', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé') AND ImageUrl = N'/images/products/seed/p0055-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'), N'/images/products/seed/p0055-3.jpg', 0, N'Sữa tắm gội cho bé', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé') AND ImageUrl = N'/images/products/seed/p0056-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'), N'/images/products/seed/p0056-1.jpg', 1, N'Kem dưỡng da cho bé', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé') AND ImageUrl = N'/images/products/seed/p0056-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'), N'/images/products/seed/p0056-2.jpg', 0, N'Kem dưỡng da cho bé', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé') AND ImageUrl = N'/images/products/seed/p0056-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'), N'/images/products/seed/p0056-3.jpg', 0, N'Kem dưỡng da cho bé', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm') AND ImageUrl = N'/images/products/seed/p0057-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'), N'/images/products/seed/p0057-1.jpg', 1, N'Kem chống hăm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm') AND ImageUrl = N'/images/products/seed/p0057-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'), N'/images/products/seed/p0057-2.jpg', 0, N'Kem chống hăm', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm') AND ImageUrl = N'/images/products/seed/p0057-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'), N'/images/products/seed/p0057-3.jpg', 0, N'Kem chống hăm', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu') AND ImageUrl = N'/images/products/seed/p0058-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'), N'/images/products/seed/p0058-1.jpg', 1, N'Kem chăm sóc mẹ bầu', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu') AND ImageUrl = N'/images/products/seed/p0058-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'), N'/images/products/seed/p0058-2.jpg', 0, N'Kem chăm sóc mẹ bầu', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu') AND ImageUrl = N'/images/products/seed/p0058-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'), N'/images/products/seed/p0058-3.jpg', 0, N'Kem chăm sóc mẹ bầu', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0059-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'), N'/images/products/seed/p0059-1.jpg', 1, N'Khăn ướt dịu nhẹ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0059-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'), N'/images/products/seed/p0059-2.jpg', 0, N'Khăn ướt dịu nhẹ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ') AND ImageUrl = N'/images/products/seed/p0059-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'), N'/images/products/seed/p0059-3.jpg', 0, N'Khăn ướt dịu nhẹ', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini') AND ImageUrl = N'/images/products/seed/p0060-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'), N'/images/products/seed/p0060-1.jpg', 1, N'Máy rửa mặt mini', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini') AND ImageUrl = N'/images/products/seed/p0060-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'), N'/images/products/seed/p0060-2.jpg', 0, N'Máy rửa mặt mini', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini') AND ImageUrl = N'/images/products/seed/p0060-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'), N'/images/products/seed/p0060-3.jpg', 0, N'Máy rửa mặt mini', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất') AND ImageUrl = N'/images/products/seed/p0061-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'), N'/images/products/seed/p0061-1.jpg', 1, N'Máy đẩy tinh chất', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất') AND ImageUrl = N'/images/products/seed/p0061-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'), N'/images/products/seed/p0061-2.jpg', 0, N'Máy đẩy tinh chất', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất') AND ImageUrl = N'/images/products/seed/p0061-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'), N'/images/products/seed/p0061-3.jpg', 0, N'Máy đẩy tinh chất', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt') AND ImageUrl = N'/images/products/seed/p0062-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'), N'/images/products/seed/p0062-1.jpg', 1, N'Máy massage mặt', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt') AND ImageUrl = N'/images/products/seed/p0062-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'), N'/images/products/seed/p0062-2.jpg', 0, N'Máy massage mặt', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt') AND ImageUrl = N'/images/products/seed/p0062-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'), N'/images/products/seed/p0062-3.jpg', 0, N'Máy massage mặt', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông') AND ImageUrl = N'/images/products/seed/p0063-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'), N'/images/products/seed/p0063-1.jpg', 1, N'Máy triệt lông', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông') AND ImageUrl = N'/images/products/seed/p0063-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'), N'/images/products/seed/p0063-2.jpg', 0, N'Máy triệt lông', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông') AND ImageUrl = N'/images/products/seed/p0063-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'), N'/images/products/seed/p0063-3.jpg', 0, N'Máy triệt lông', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc') AND ImageUrl = N'/images/products/seed/p0064-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'), N'/images/products/seed/p0064-1.jpg', 1, N'Máy sấy tóc', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc') AND ImageUrl = N'/images/products/seed/p0064-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'), N'/images/products/seed/p0064-2.jpg', 0, N'Máy sấy tóc', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc') AND ImageUrl = N'/images/products/seed/p0064-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'), N'/images/products/seed/p0064-3.jpg', 0, N'Máy sấy tóc', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc') AND ImageUrl = N'/images/products/seed/p0065-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'), N'/images/products/seed/p0065-1.jpg', 1, N'Máy uốn tóc', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc') AND ImageUrl = N'/images/products/seed/p0065-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'), N'/images/products/seed/p0065-2.jpg', 0, N'Máy uốn tóc', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc') AND ImageUrl = N'/images/products/seed/p0065-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'), N'/images/products/seed/p0065-3.jpg', 0, N'Máy uốn tóc', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen') AND ImageUrl = N'/images/products/seed/p0066-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'), N'/images/products/seed/p0066-1.jpg', 1, N'Viên uống collagen', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen') AND ImageUrl = N'/images/products/seed/p0066-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'), N'/images/products/seed/p0066-2.jpg', 0, N'Viên uống collagen', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen') AND ImageUrl = N'/images/products/seed/p0066-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'), N'/images/products/seed/p0066-3.jpg', 0, N'Viên uống collagen', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp') AND ImageUrl = N'/images/products/seed/p0067-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'), N'/images/products/seed/p0067-1.jpg', 1, N'Vitamin tổng hợp', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp') AND ImageUrl = N'/images/products/seed/p0067-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'), N'/images/products/seed/p0067-2.jpg', 0, N'Vitamin tổng hợp', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp') AND ImageUrl = N'/images/products/seed/p0067-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'), N'/images/products/seed/p0067-3.jpg', 0, N'Vitamin tổng hợp', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da') AND ImageUrl = N'/images/products/seed/p0068-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'), N'/images/products/seed/p0068-1.jpg', 1, N'Viên uống đẹp da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da') AND ImageUrl = N'/images/products/seed/p0068-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'), N'/images/products/seed/p0068-2.jpg', 0, N'Viên uống đẹp da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da') AND ImageUrl = N'/images/products/seed/p0068-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'), N'/images/products/seed/p0068-3.jpg', 0, N'Viên uống đẹp da', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng') AND ImageUrl = N'/images/products/seed/p0069-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'), N'/images/products/seed/p0069-1.jpg', 1, N'Viên hỗ trợ tóc móng', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng') AND ImageUrl = N'/images/products/seed/p0069-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'), N'/images/products/seed/p0069-2.jpg', 0, N'Viên hỗ trợ tóc móng', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng') AND ImageUrl = N'/images/products/seed/p0069-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'), N'/images/products/seed/p0069-3.jpg', 0, N'Viên hỗ trợ tóc móng', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ') AND ImageUrl = N'/images/products/seed/p0070-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'), N'/images/products/seed/p0070-1.jpg', 1, N'Viên hỗ trợ giấc ngủ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ') AND ImageUrl = N'/images/products/seed/p0070-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'), N'/images/products/seed/p0070-2.jpg', 0, N'Viên hỗ trợ giấc ngủ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ') AND ImageUrl = N'/images/products/seed/p0070-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'), N'/images/products/seed/p0070-3.jpg', 0, N'Viên hỗ trợ giấc ngủ', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản') AND ImageUrl = N'/images/products/seed/p0071-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'), N'/images/products/seed/p0071-1.jpg', 1, N'Set dưỡng da cơ bản', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản') AND ImageUrl = N'/images/products/seed/p0071-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'), N'/images/products/seed/p0071-2.jpg', 0, N'Set dưỡng da cơ bản', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản') AND ImageUrl = N'/images/products/seed/p0071-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'), N'/images/products/seed/p0071-3.jpg', 0, N'Set dưỡng da cơ bản', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản') AND ImageUrl = N'/images/products/seed/p0072-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'), N'/images/products/seed/p0072-1.jpg', 1, N'Set trang điểm cơ bản', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản') AND ImageUrl = N'/images/products/seed/p0072-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'), N'/images/products/seed/p0072-2.jpg', 0, N'Set trang điểm cơ bản', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản') AND ImageUrl = N'/images/products/seed/p0072-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'), N'/images/products/seed/p0072-3.jpg', 0, N'Set trang điểm cơ bản', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc') AND ImageUrl = N'/images/products/seed/p0073-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'), N'/images/products/seed/p0073-1.jpg', 1, N'Set chăm sóc tóc', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc') AND ImageUrl = N'/images/products/seed/p0073-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'), N'/images/products/seed/p0073-2.jpg', 0, N'Set chăm sóc tóc', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc') AND ImageUrl = N'/images/products/seed/p0073-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'), N'/images/products/seed/p0073-3.jpg', 0, N'Set chăm sóc tóc', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể') AND ImageUrl = N'/images/products/seed/p0074-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'), N'/images/products/seed/p0074-1.jpg', 1, N'Set chăm sóc cơ thể', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể') AND ImageUrl = N'/images/products/seed/p0074-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'), N'/images/products/seed/p0074-2.jpg', 0, N'Set chăm sóc cơ thể', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể') AND ImageUrl = N'/images/products/seed/p0074-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'), N'/images/products/seed/p0074-3.jpg', 0, N'Set chăm sóc cơ thể', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel') AND ImageUrl = N'/images/products/seed/p0075-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'), N'/images/products/seed/p0075-1.jpg', 1, N'Set mini travel', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel') AND ImageUrl = N'/images/products/seed/p0075-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'), N'/images/products/seed/p0075-2.jpg', 0, N'Set mini travel', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel') AND ImageUrl = N'/images/products/seed/p0075-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'), N'/images/products/seed/p0075-3.jpg', 0, N'Set mini travel', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1') AND ImageUrl = N'/images/products/seed/p0076-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'), N'/images/products/seed/p0076-1.jpg', 1, N'Tinh chất dưỡng ẩm 1', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1') AND ImageUrl = N'/images/products/seed/p0076-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'), N'/images/products/seed/p0076-2.jpg', 0, N'Tinh chất dưỡng ẩm 1', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1') AND ImageUrl = N'/images/products/seed/p0076-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'), N'/images/products/seed/p0076-3.jpg', 0, N'Tinh chất dưỡng ẩm 1', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2') AND ImageUrl = N'/images/products/seed/p0077-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'), N'/images/products/seed/p0077-1.jpg', 1, N'Tinh chất dưỡng ẩm 2', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2') AND ImageUrl = N'/images/products/seed/p0077-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'), N'/images/products/seed/p0077-2.jpg', 0, N'Tinh chất dưỡng ẩm 2', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2') AND ImageUrl = N'/images/products/seed/p0077-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'), N'/images/products/seed/p0077-3.jpg', 0, N'Tinh chất dưỡng ẩm 2', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3') AND ImageUrl = N'/images/products/seed/p0078-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'), N'/images/products/seed/p0078-1.jpg', 1, N'Tinh chất dưỡng ẩm 3', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3') AND ImageUrl = N'/images/products/seed/p0078-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'), N'/images/products/seed/p0078-2.jpg', 0, N'Tinh chất dưỡng ẩm 3', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3') AND ImageUrl = N'/images/products/seed/p0078-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'), N'/images/products/seed/p0078-3.jpg', 0, N'Tinh chất dưỡng ẩm 3', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4') AND ImageUrl = N'/images/products/seed/p0079-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'), N'/images/products/seed/p0079-1.jpg', 1, N'Tinh chất dưỡng ẩm 4', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4') AND ImageUrl = N'/images/products/seed/p0079-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'), N'/images/products/seed/p0079-2.jpg', 0, N'Tinh chất dưỡng ẩm 4', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4') AND ImageUrl = N'/images/products/seed/p0079-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'), N'/images/products/seed/p0079-3.jpg', 0, N'Tinh chất dưỡng ẩm 4', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5') AND ImageUrl = N'/images/products/seed/p0080-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'), N'/images/products/seed/p0080-1.jpg', 1, N'Tinh chất dưỡng ẩm 5', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5') AND ImageUrl = N'/images/products/seed/p0080-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'), N'/images/products/seed/p0080-2.jpg', 0, N'Tinh chất dưỡng ẩm 5', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5') AND ImageUrl = N'/images/products/seed/p0080-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'), N'/images/products/seed/p0080-3.jpg', 0, N'Tinh chất dưỡng ẩm 5', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6') AND ImageUrl = N'/images/products/seed/p0081-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'), N'/images/products/seed/p0081-1.jpg', 1, N'Tinh chất dưỡng ẩm 6', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6') AND ImageUrl = N'/images/products/seed/p0081-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'), N'/images/products/seed/p0081-2.jpg', 0, N'Tinh chất dưỡng ẩm 6', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6') AND ImageUrl = N'/images/products/seed/p0081-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'), N'/images/products/seed/p0081-3.jpg', 0, N'Tinh chất dưỡng ẩm 6', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7') AND ImageUrl = N'/images/products/seed/p0082-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'), N'/images/products/seed/p0082-1.jpg', 1, N'Tinh chất dưỡng ẩm 7', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7') AND ImageUrl = N'/images/products/seed/p0082-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'), N'/images/products/seed/p0082-2.jpg', 0, N'Tinh chất dưỡng ẩm 7', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7') AND ImageUrl = N'/images/products/seed/p0082-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'), N'/images/products/seed/p0082-3.jpg', 0, N'Tinh chất dưỡng ẩm 7', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8') AND ImageUrl = N'/images/products/seed/p0083-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'), N'/images/products/seed/p0083-1.jpg', 1, N'Tinh chất dưỡng ẩm 8', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8') AND ImageUrl = N'/images/products/seed/p0083-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'), N'/images/products/seed/p0083-2.jpg', 0, N'Tinh chất dưỡng ẩm 8', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8') AND ImageUrl = N'/images/products/seed/p0083-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'), N'/images/products/seed/p0083-3.jpg', 0, N'Tinh chất dưỡng ẩm 8', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9') AND ImageUrl = N'/images/products/seed/p0084-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'), N'/images/products/seed/p0084-1.jpg', 1, N'Tinh chất dưỡng ẩm 9', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9') AND ImageUrl = N'/images/products/seed/p0084-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'), N'/images/products/seed/p0084-2.jpg', 0, N'Tinh chất dưỡng ẩm 9', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9') AND ImageUrl = N'/images/products/seed/p0084-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'), N'/images/products/seed/p0084-3.jpg', 0, N'Tinh chất dưỡng ẩm 9', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10') AND ImageUrl = N'/images/products/seed/p0085-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'), N'/images/products/seed/p0085-1.jpg', 1, N'Tinh chất phục hồi 10', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10') AND ImageUrl = N'/images/products/seed/p0085-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'), N'/images/products/seed/p0085-2.jpg', 0, N'Tinh chất phục hồi 10', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10') AND ImageUrl = N'/images/products/seed/p0085-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'), N'/images/products/seed/p0085-3.jpg', 0, N'Tinh chất phục hồi 10', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11') AND ImageUrl = N'/images/products/seed/p0086-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'), N'/images/products/seed/p0086-1.jpg', 1, N'Tinh chất phục hồi 11', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11') AND ImageUrl = N'/images/products/seed/p0086-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'), N'/images/products/seed/p0086-2.jpg', 0, N'Tinh chất phục hồi 11', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11') AND ImageUrl = N'/images/products/seed/p0086-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'), N'/images/products/seed/p0086-3.jpg', 0, N'Tinh chất phục hồi 11', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12') AND ImageUrl = N'/images/products/seed/p0087-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'), N'/images/products/seed/p0087-1.jpg', 1, N'Tinh chất phục hồi 12', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12') AND ImageUrl = N'/images/products/seed/p0087-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'), N'/images/products/seed/p0087-2.jpg', 0, N'Tinh chất phục hồi 12', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12') AND ImageUrl = N'/images/products/seed/p0087-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'), N'/images/products/seed/p0087-3.jpg', 0, N'Tinh chất phục hồi 12', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13') AND ImageUrl = N'/images/products/seed/p0088-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'), N'/images/products/seed/p0088-1.jpg', 1, N'Tinh chất phục hồi 13', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13') AND ImageUrl = N'/images/products/seed/p0088-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'), N'/images/products/seed/p0088-2.jpg', 0, N'Tinh chất phục hồi 13', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13') AND ImageUrl = N'/images/products/seed/p0088-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'), N'/images/products/seed/p0088-3.jpg', 0, N'Tinh chất phục hồi 13', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14') AND ImageUrl = N'/images/products/seed/p0089-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'), N'/images/products/seed/p0089-1.jpg', 1, N'Tinh chất phục hồi 14', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14') AND ImageUrl = N'/images/products/seed/p0089-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'), N'/images/products/seed/p0089-2.jpg', 0, N'Tinh chất phục hồi 14', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14') AND ImageUrl = N'/images/products/seed/p0089-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'), N'/images/products/seed/p0089-3.jpg', 0, N'Tinh chất phục hồi 14', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15') AND ImageUrl = N'/images/products/seed/p0090-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'), N'/images/products/seed/p0090-1.jpg', 1, N'Tinh chất phục hồi 15', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15') AND ImageUrl = N'/images/products/seed/p0090-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'), N'/images/products/seed/p0090-2.jpg', 0, N'Tinh chất phục hồi 15', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15') AND ImageUrl = N'/images/products/seed/p0090-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'), N'/images/products/seed/p0090-3.jpg', 0, N'Tinh chất phục hồi 15', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16') AND ImageUrl = N'/images/products/seed/p0091-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'), N'/images/products/seed/p0091-1.jpg', 1, N'Tinh chất phục hồi 16', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16') AND ImageUrl = N'/images/products/seed/p0091-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'), N'/images/products/seed/p0091-2.jpg', 0, N'Tinh chất phục hồi 16', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16') AND ImageUrl = N'/images/products/seed/p0091-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'), N'/images/products/seed/p0091-3.jpg', 0, N'Tinh chất phục hồi 16', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17') AND ImageUrl = N'/images/products/seed/p0092-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'), N'/images/products/seed/p0092-1.jpg', 1, N'Tinh chất phục hồi 17', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17') AND ImageUrl = N'/images/products/seed/p0092-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'), N'/images/products/seed/p0092-2.jpg', 0, N'Tinh chất phục hồi 17', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17') AND ImageUrl = N'/images/products/seed/p0092-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'), N'/images/products/seed/p0092-3.jpg', 0, N'Tinh chất phục hồi 17', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18') AND ImageUrl = N'/images/products/seed/p0093-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'), N'/images/products/seed/p0093-1.jpg', 1, N'Tinh chất phục hồi 18', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18') AND ImageUrl = N'/images/products/seed/p0093-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'), N'/images/products/seed/p0093-2.jpg', 0, N'Tinh chất phục hồi 18', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18') AND ImageUrl = N'/images/products/seed/p0093-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'), N'/images/products/seed/p0093-3.jpg', 0, N'Tinh chất phục hồi 18', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19') AND ImageUrl = N'/images/products/seed/p0094-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'), N'/images/products/seed/p0094-1.jpg', 1, N'Kem dưỡng ban ngày 19', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19') AND ImageUrl = N'/images/products/seed/p0094-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'), N'/images/products/seed/p0094-2.jpg', 0, N'Kem dưỡng ban ngày 19', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19') AND ImageUrl = N'/images/products/seed/p0094-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'), N'/images/products/seed/p0094-3.jpg', 0, N'Kem dưỡng ban ngày 19', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20') AND ImageUrl = N'/images/products/seed/p0095-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'), N'/images/products/seed/p0095-1.jpg', 1, N'Kem dưỡng ban ngày 20', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20') AND ImageUrl = N'/images/products/seed/p0095-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'), N'/images/products/seed/p0095-2.jpg', 0, N'Kem dưỡng ban ngày 20', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20') AND ImageUrl = N'/images/products/seed/p0095-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'), N'/images/products/seed/p0095-3.jpg', 0, N'Kem dưỡng ban ngày 20', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21') AND ImageUrl = N'/images/products/seed/p0096-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'), N'/images/products/seed/p0096-1.jpg', 1, N'Kem dưỡng ban ngày 21', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21') AND ImageUrl = N'/images/products/seed/p0096-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'), N'/images/products/seed/p0096-2.jpg', 0, N'Kem dưỡng ban ngày 21', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21') AND ImageUrl = N'/images/products/seed/p0096-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'), N'/images/products/seed/p0096-3.jpg', 0, N'Kem dưỡng ban ngày 21', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22') AND ImageUrl = N'/images/products/seed/p0097-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'), N'/images/products/seed/p0097-1.jpg', 1, N'Kem dưỡng ban ngày 22', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22') AND ImageUrl = N'/images/products/seed/p0097-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'), N'/images/products/seed/p0097-2.jpg', 0, N'Kem dưỡng ban ngày 22', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22') AND ImageUrl = N'/images/products/seed/p0097-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'), N'/images/products/seed/p0097-3.jpg', 0, N'Kem dưỡng ban ngày 22', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23') AND ImageUrl = N'/images/products/seed/p0098-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'), N'/images/products/seed/p0098-1.jpg', 1, N'Kem dưỡng ban ngày 23', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23') AND ImageUrl = N'/images/products/seed/p0098-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'), N'/images/products/seed/p0098-2.jpg', 0, N'Kem dưỡng ban ngày 23', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23') AND ImageUrl = N'/images/products/seed/p0098-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'), N'/images/products/seed/p0098-3.jpg', 0, N'Kem dưỡng ban ngày 23', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24') AND ImageUrl = N'/images/products/seed/p0099-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'), N'/images/products/seed/p0099-1.jpg', 1, N'Kem dưỡng ban ngày 24', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24') AND ImageUrl = N'/images/products/seed/p0099-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'), N'/images/products/seed/p0099-2.jpg', 0, N'Kem dưỡng ban ngày 24', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24') AND ImageUrl = N'/images/products/seed/p0099-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'), N'/images/products/seed/p0099-3.jpg', 0, N'Kem dưỡng ban ngày 24', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25') AND ImageUrl = N'/images/products/seed/p0100-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'), N'/images/products/seed/p0100-1.jpg', 1, N'Kem dưỡng ban ngày 25', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25') AND ImageUrl = N'/images/products/seed/p0100-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'), N'/images/products/seed/p0100-2.jpg', 0, N'Kem dưỡng ban ngày 25', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25') AND ImageUrl = N'/images/products/seed/p0100-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'), N'/images/products/seed/p0100-3.jpg', 0, N'Kem dưỡng ban ngày 25', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26') AND ImageUrl = N'/images/products/seed/p0101-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'), N'/images/products/seed/p0101-1.jpg', 1, N'Kem dưỡng ban ngày 26', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26') AND ImageUrl = N'/images/products/seed/p0101-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'), N'/images/products/seed/p0101-2.jpg', 0, N'Kem dưỡng ban ngày 26', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26') AND ImageUrl = N'/images/products/seed/p0101-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'), N'/images/products/seed/p0101-3.jpg', 0, N'Kem dưỡng ban ngày 26', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27') AND ImageUrl = N'/images/products/seed/p0102-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'), N'/images/products/seed/p0102-1.jpg', 1, N'Kem dưỡng ban ngày 27', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27') AND ImageUrl = N'/images/products/seed/p0102-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'), N'/images/products/seed/p0102-2.jpg', 0, N'Kem dưỡng ban ngày 27', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27') AND ImageUrl = N'/images/products/seed/p0102-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'), N'/images/products/seed/p0102-3.jpg', 0, N'Kem dưỡng ban ngày 27', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28') AND ImageUrl = N'/images/products/seed/p0103-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'), N'/images/products/seed/p0103-1.jpg', 1, N'Kem dưỡng ban đêm 28', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28') AND ImageUrl = N'/images/products/seed/p0103-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'), N'/images/products/seed/p0103-2.jpg', 0, N'Kem dưỡng ban đêm 28', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28') AND ImageUrl = N'/images/products/seed/p0103-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'), N'/images/products/seed/p0103-3.jpg', 0, N'Kem dưỡng ban đêm 28', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29') AND ImageUrl = N'/images/products/seed/p0104-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'), N'/images/products/seed/p0104-1.jpg', 1, N'Kem dưỡng ban đêm 29', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29') AND ImageUrl = N'/images/products/seed/p0104-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'), N'/images/products/seed/p0104-2.jpg', 0, N'Kem dưỡng ban đêm 29', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29') AND ImageUrl = N'/images/products/seed/p0104-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'), N'/images/products/seed/p0104-3.jpg', 0, N'Kem dưỡng ban đêm 29', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30') AND ImageUrl = N'/images/products/seed/p0105-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'), N'/images/products/seed/p0105-1.jpg', 1, N'Kem dưỡng ban đêm 30', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30') AND ImageUrl = N'/images/products/seed/p0105-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'), N'/images/products/seed/p0105-2.jpg', 0, N'Kem dưỡng ban đêm 30', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30') AND ImageUrl = N'/images/products/seed/p0105-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'), N'/images/products/seed/p0105-3.jpg', 0, N'Kem dưỡng ban đêm 30', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31') AND ImageUrl = N'/images/products/seed/p0106-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'), N'/images/products/seed/p0106-1.jpg', 1, N'Kem dưỡng ban đêm 31', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31') AND ImageUrl = N'/images/products/seed/p0106-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'), N'/images/products/seed/p0106-2.jpg', 0, N'Kem dưỡng ban đêm 31', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31') AND ImageUrl = N'/images/products/seed/p0106-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'), N'/images/products/seed/p0106-3.jpg', 0, N'Kem dưỡng ban đêm 31', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32') AND ImageUrl = N'/images/products/seed/p0107-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'), N'/images/products/seed/p0107-1.jpg', 1, N'Kem dưỡng ban đêm 32', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32') AND ImageUrl = N'/images/products/seed/p0107-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'), N'/images/products/seed/p0107-2.jpg', 0, N'Kem dưỡng ban đêm 32', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32') AND ImageUrl = N'/images/products/seed/p0107-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'), N'/images/products/seed/p0107-3.jpg', 0, N'Kem dưỡng ban đêm 32', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33') AND ImageUrl = N'/images/products/seed/p0108-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'), N'/images/products/seed/p0108-1.jpg', 1, N'Kem dưỡng ban đêm 33', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33') AND ImageUrl = N'/images/products/seed/p0108-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'), N'/images/products/seed/p0108-2.jpg', 0, N'Kem dưỡng ban đêm 33', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33') AND ImageUrl = N'/images/products/seed/p0108-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'), N'/images/products/seed/p0108-3.jpg', 0, N'Kem dưỡng ban đêm 33', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34') AND ImageUrl = N'/images/products/seed/p0109-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'), N'/images/products/seed/p0109-1.jpg', 1, N'Kem dưỡng ban đêm 34', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34') AND ImageUrl = N'/images/products/seed/p0109-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'), N'/images/products/seed/p0109-2.jpg', 0, N'Kem dưỡng ban đêm 34', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34') AND ImageUrl = N'/images/products/seed/p0109-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'), N'/images/products/seed/p0109-3.jpg', 0, N'Kem dưỡng ban đêm 34', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35') AND ImageUrl = N'/images/products/seed/p0110-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'), N'/images/products/seed/p0110-1.jpg', 1, N'Kem dưỡng ban đêm 35', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35') AND ImageUrl = N'/images/products/seed/p0110-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'), N'/images/products/seed/p0110-2.jpg', 0, N'Kem dưỡng ban đêm 35', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35') AND ImageUrl = N'/images/products/seed/p0110-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'), N'/images/products/seed/p0110-3.jpg', 0, N'Kem dưỡng ban đêm 35', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36') AND ImageUrl = N'/images/products/seed/p0111-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'), N'/images/products/seed/p0111-1.jpg', 1, N'Kem dưỡng ban đêm 36', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36') AND ImageUrl = N'/images/products/seed/p0111-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'), N'/images/products/seed/p0111-2.jpg', 0, N'Kem dưỡng ban đêm 36', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36') AND ImageUrl = N'/images/products/seed/p0111-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'), N'/images/products/seed/p0111-3.jpg', 0, N'Kem dưỡng ban đêm 36', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37') AND ImageUrl = N'/images/products/seed/p0112-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'), N'/images/products/seed/p0112-1.jpg', 1, N'Gel tẩy tế bào chết 37', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37') AND ImageUrl = N'/images/products/seed/p0112-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'), N'/images/products/seed/p0112-2.jpg', 0, N'Gel tẩy tế bào chết 37', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37') AND ImageUrl = N'/images/products/seed/p0112-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'), N'/images/products/seed/p0112-3.jpg', 0, N'Gel tẩy tế bào chết 37', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38') AND ImageUrl = N'/images/products/seed/p0113-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'), N'/images/products/seed/p0113-1.jpg', 1, N'Gel tẩy tế bào chết 38', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38') AND ImageUrl = N'/images/products/seed/p0113-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'), N'/images/products/seed/p0113-2.jpg', 0, N'Gel tẩy tế bào chết 38', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38') AND ImageUrl = N'/images/products/seed/p0113-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'), N'/images/products/seed/p0113-3.jpg', 0, N'Gel tẩy tế bào chết 38', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39') AND ImageUrl = N'/images/products/seed/p0114-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'), N'/images/products/seed/p0114-1.jpg', 1, N'Gel tẩy tế bào chết 39', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39') AND ImageUrl = N'/images/products/seed/p0114-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'), N'/images/products/seed/p0114-2.jpg', 0, N'Gel tẩy tế bào chết 39', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39') AND ImageUrl = N'/images/products/seed/p0114-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'), N'/images/products/seed/p0114-3.jpg', 0, N'Gel tẩy tế bào chết 39', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40') AND ImageUrl = N'/images/products/seed/p0115-1.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'), N'/images/products/seed/p0115-1.jpg', 1, N'Gel tẩy tế bào chết 40', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40') AND ImageUrl = N'/images/products/seed/p0115-2.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'), N'/images/products/seed/p0115-2.jpg', 0, N'Gel tẩy tế bào chết 40', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_product_image WHERE ProductId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40') AND ImageUrl = N'/images/products/seed/p0115-3.jpg')
    INSERT INTO dbo.cf_product_image (ProductId, ImageUrl, IsPrimary, AltText, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES ((SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'), N'/images/products/seed/p0115-3.jpg', 0, N'Gel tẩy tế bào chết 40', 1, GETDATE(), N'Seed', 3);

-- SEO slug for products (no diacritics)
IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt dịu nhẹ'), N'sua-rua-mat-diu-nhe-0001', 1, GETDATE(), N'Seed', 1);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel rửa mặt kiềm dầu'), N'gel-rua-mat-kiem-dau-0002', 1, GETDATE(), N'Seed', 2);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước tẩy trang micellar'), N'nuoc-tay-trang-micellar-0003', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Toner cân bằng da'), N'toner-can-bang-da-0004', 1, GETDATE(), N'Seed', 4);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum vitamin C sáng da'), N'serum-vitamin-c-sang-da-0005', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum phục hồi da'), N'serum-phuc-hoi-da-0006', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm ban đêm'), N'kem-duong-am-ban-em-0007', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mặt nạ dưỡng ẩm'), N'mat-na-duong-am-0008', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết dịu nhẹ'), N'tay-te-bao-chet-diu-nhe-0009', 1, GETDATE(), N'Seed', 9);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng mắt giảm thâm'), N'kem-duong-mat-giam-tham-0010', 1, GETDATE(), N'Seed', 10);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem nền lâu trôi'), N'kem-nen-lau-troi-0011', 1, GETDATE(), N'Seed', 11);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Phấn phủ kiềm dầu'), N'phan-phu-kiem-dau-0012', 1, GETDATE(), N'Seed', 12);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son kem lì'), N'son-kem-li-0013', 1, GETDATE(), N'Seed', 13);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Mascara dày mi'), N'mascara-day-mi-0014', 1, GETDATE(), N'Seed', 14);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bút kẻ mắt chống nước'), N'but-ke-mat-chong-nuoc-0015', 1, GETDATE(), N'Seed', 15);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Má hồng dạng kem'), N'ma-hong-dang-kem-0016', 1, GETDATE(), N'Seed', 16);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Che khuyết điểm đa năng'), N'che-khuyet-iem-a-nang-0017', 1, GETDATE(), N'Seed', 17);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Bộ cọ trang điểm cơ bản'), N'bo-co-trang-iem-co-ban-0018', 1, GETDATE(), N'Seed', 18);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu gội phục hồi tóc'), N'dau-goi-phuc-hoi-toc-0019', 1, GETDATE(), N'Seed', 19);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Dầu xả suôn mượt'), N'dau-xa-suon-muot-0020', 1, GETDATE(), N'Seed', 20);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Ủ tóc keratin'), N'u-toc-keratin-0021', 1, GETDATE(), N'Seed', 21);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh dầu dưỡng tóc'), N'tinh-dau-duong-toc-0022', 1, GETDATE(), N'Seed', 22);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt dưỡng tóc mềm mượt'), N'xit-duong-toc-mem-muot-0023', 1, GETDATE(), N'Seed', 23);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tạo kiểu'), N'gel-tao-kieu-0024', 1, GETDATE(), N'Seed', 24);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum tóc bóng khỏe'), N'serum-toc-bong-khoe-0025', 1, GETDATE(), N'Seed', 25);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Màu nhuộm tóc tại nhà'), N'mau-nhuom-toc-tai-nha-0026', 1, GETDATE(), N'Seed', 26);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm hương hoa'), N'sua-tam-huong-hoa-0027', 1, GETDATE(), N'Seed', 27);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tẩy tế bào chết body'), N'tay-te-bao-chet-body-0028', 1, GETDATE(), N'Seed', 28);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng thể trắng da'), N'kem-duong-the-trang-da-0029', 1, GETDATE(), N'Seed', 29);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi'), N'lan-khu-mui-0030', 1, GETDATE(), N'Seed', 30);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da tay'), N'kem-duong-da-tay-0031', 1, GETDATE(), N'Seed', 31);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng gót chân'), N'kem-duong-got-chan-0032', 1, GETDATE(), N'Seed', 32);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Son dưỡng môi'), N'son-duong-moi-0033', 1, GETDATE(), N'Seed', 33);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nứt gót'), N'kem-chong-nut-got-0034', 1, GETDATE(), N'Seed', 34);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống nắng SPF50'), N'kem-chong-nang-spf50-0035', 1, GETDATE(), N'Seed', 35);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa chống nắng dịu nhẹ'), N'sua-chong-nang-diu-nhe-0036', 1, GETDATE(), N'Seed', 36);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt chống nắng tiện lợi'), N'xit-chong-nang-tien-loi-0037', 1, GETDATE(), N'Seed', 37);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng body'), N'chong-nang-body-0038', 1, GETDATE(), N'Seed', 38);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Chống nắng nâng tông'), N'chong-nang-nang-tong-0039', 1, GETDATE(), N'Seed', 39);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nữ thanh lịch'), N'nuoc-hoa-nu-thanh-lich-0040', 1, GETDATE(), N'Seed', 40);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam mạnh mẽ'), N'nuoc-hoa-nam-manh-me-0041', 1, GETDATE(), N'Seed', 41);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa unisex'), N'nuoc-hoa-unisex-0042', 1, GETDATE(), N'Seed', 42);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Xịt thơm body'), N'xit-thom-body-0043', 1, GETDATE(), N'Seed', 43);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set quà nước hoa'), N'set-qua-nuoc-hoa-0044', 1, GETDATE(), N'Seed', 44);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem trị mụn'), N'kem-tri-mun-0045', 1, GETDATE(), N'Seed', 45);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem phục hồi da'), N'kem-phuc-hoi-da-0046', 1, GETDATE(), N'Seed', 46);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Serum giảm kích ứng'), N'serum-giam-kich-ung-0047', 1, GETDATE(), N'Seed', 47);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất làm sáng da'), N'tinh-chat-lam-sang-da-0048', 1, GETDATE(), N'Seed', 48);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ẩm sâu'), N'kem-duong-am-sau-0049', 1, GETDATE(), N'Seed', 49);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa rửa mặt nam'), N'sua-rua-mat-nam-0050', 1, GETDATE(), N'Seed', 50);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng nam'), N'kem-duong-nam-0051', 1, GETDATE(), N'Seed', 51);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sáp tạo kiểu tóc nam'), N'sap-tao-kieu-toc-nam-0052', 1, GETDATE(), N'Seed', 52);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Lăn khử mùi nam'), N'lan-khu-mui-nam-0053', 1, GETDATE(), N'Seed', 53);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Nước hoa nam cá tính'), N'nuoc-hoa-nam-ca-tinh-0054', 1, GETDATE(), N'Seed', 54);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Sữa tắm gội cho bé'), N'sua-tam-goi-cho-be-0055', 1, GETDATE(), N'Seed', 55);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng da cho bé'), N'kem-duong-da-cho-be-0056', 1, GETDATE(), N'Seed', 56);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chống hăm'), N'kem-chong-ham-0057', 1, GETDATE(), N'Seed', 57);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem chăm sóc mẹ bầu'), N'kem-cham-soc-me-bau-0058', 1, GETDATE(), N'Seed', 58);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Khăn ướt dịu nhẹ'), N'khan-uot-diu-nhe-0059', 1, GETDATE(), N'Seed', 59);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy rửa mặt mini'), N'may-rua-mat-mini-0060', 1, GETDATE(), N'Seed', 60);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy đẩy tinh chất'), N'may-ay-tinh-chat-0061', 1, GETDATE(), N'Seed', 61);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy massage mặt'), N'may-massage-mat-0062', 1, GETDATE(), N'Seed', 62);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy triệt lông'), N'may-triet-long-0063', 1, GETDATE(), N'Seed', 63);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy sấy tóc'), N'may-say-toc-0064', 1, GETDATE(), N'Seed', 64);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Máy uốn tóc'), N'may-uon-toc-0065', 1, GETDATE(), N'Seed', 65);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống collagen'), N'vien-uong-collagen-0066', 1, GETDATE(), N'Seed', 66);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Vitamin tổng hợp'), N'vitamin-tong-hop-0067', 1, GETDATE(), N'Seed', 67);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên uống đẹp da'), N'vien-uong-ep-da-0068', 1, GETDATE(), N'Seed', 68);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ tóc móng'), N'vien-ho-tro-toc-mong-0069', 1, GETDATE(), N'Seed', 69);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Viên hỗ trợ giấc ngủ'), N'vien-ho-tro-giac-ngu-0070', 1, GETDATE(), N'Seed', 70);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set dưỡng da cơ bản'), N'set-duong-da-co-ban-0071', 1, GETDATE(), N'Seed', 71);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set trang điểm cơ bản'), N'set-trang-iem-co-ban-0072', 1, GETDATE(), N'Seed', 72);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc tóc'), N'set-cham-soc-toc-0073', 1, GETDATE(), N'Seed', 73);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set chăm sóc cơ thể'), N'set-cham-soc-co-the-0074', 1, GETDATE(), N'Seed', 74);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Set mini travel'), N'set-mini-travel-0075', 1, GETDATE(), N'Seed', 75);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 1'), N'tinh-chat-duong-am-1-0076', 1, GETDATE(), N'Seed', 76);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 2'), N'tinh-chat-duong-am-2-0077', 1, GETDATE(), N'Seed', 77);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 3'), N'tinh-chat-duong-am-3-0078', 1, GETDATE(), N'Seed', 78);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 4'), N'tinh-chat-duong-am-4-0079', 1, GETDATE(), N'Seed', 79);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 5'), N'tinh-chat-duong-am-5-0080', 1, GETDATE(), N'Seed', 80);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 6'), N'tinh-chat-duong-am-6-0081', 1, GETDATE(), N'Seed', 81);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 7'), N'tinh-chat-duong-am-7-0082', 1, GETDATE(), N'Seed', 82);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 8'), N'tinh-chat-duong-am-8-0083', 1, GETDATE(), N'Seed', 83);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất dưỡng ẩm 9'), N'tinh-chat-duong-am-9-0084', 1, GETDATE(), N'Seed', 84);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 10'), N'tinh-chat-phuc-hoi-10-0085', 1, GETDATE(), N'Seed', 85);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 11'), N'tinh-chat-phuc-hoi-11-0086', 1, GETDATE(), N'Seed', 86);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 12'), N'tinh-chat-phuc-hoi-12-0087', 1, GETDATE(), N'Seed', 87);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 13'), N'tinh-chat-phuc-hoi-13-0088', 1, GETDATE(), N'Seed', 88);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 14'), N'tinh-chat-phuc-hoi-14-0089', 1, GETDATE(), N'Seed', 89);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 15'), N'tinh-chat-phuc-hoi-15-0090', 1, GETDATE(), N'Seed', 90);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 16'), N'tinh-chat-phuc-hoi-16-0091', 1, GETDATE(), N'Seed', 91);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 17'), N'tinh-chat-phuc-hoi-17-0092', 1, GETDATE(), N'Seed', 92);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Tinh chất phục hồi 18'), N'tinh-chat-phuc-hoi-18-0093', 1, GETDATE(), N'Seed', 93);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 19'), N'kem-duong-ban-ngay-19-0094', 1, GETDATE(), N'Seed', 94);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 20'), N'kem-duong-ban-ngay-20-0095', 1, GETDATE(), N'Seed', 95);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 21'), N'kem-duong-ban-ngay-21-0096', 1, GETDATE(), N'Seed', 96);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 22'), N'kem-duong-ban-ngay-22-0097', 1, GETDATE(), N'Seed', 97);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 23'), N'kem-duong-ban-ngay-23-0098', 1, GETDATE(), N'Seed', 98);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 24'), N'kem-duong-ban-ngay-24-0099', 1, GETDATE(), N'Seed', 99);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 25'), N'kem-duong-ban-ngay-25-0100', 1, GETDATE(), N'Seed', 100);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 26'), N'kem-duong-ban-ngay-26-0101', 1, GETDATE(), N'Seed', 101);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban ngày 27'), N'kem-duong-ban-ngay-27-0102', 1, GETDATE(), N'Seed', 102);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 28'), N'kem-duong-ban-em-28-0103', 1, GETDATE(), N'Seed', 103);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 29'), N'kem-duong-ban-em-29-0104', 1, GETDATE(), N'Seed', 104);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 30'), N'kem-duong-ban-em-30-0105', 1, GETDATE(), N'Seed', 105);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 31'), N'kem-duong-ban-em-31-0106', 1, GETDATE(), N'Seed', 106);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 32'), N'kem-duong-ban-em-32-0107', 1, GETDATE(), N'Seed', 107);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 33'), N'kem-duong-ban-em-33-0108', 1, GETDATE(), N'Seed', 108);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 34'), N'kem-duong-ban-em-34-0109', 1, GETDATE(), N'Seed', 109);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 35'), N'kem-duong-ban-em-35-0110', 1, GETDATE(), N'Seed', 110);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Kem dưỡng ban đêm 36'), N'kem-duong-ban-em-36-0111', 1, GETDATE(), N'Seed', 111);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 37'), N'gel-tay-te-bao-chet-37-0112', 1, GETDATE(), N'Seed', 112);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 38'), N'gel-tay-te-bao-chet-38-0113', 1, GETDATE(), N'Seed', 113);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 39'), N'gel-tay-te-bao-chet-39-0114', 1, GETDATE(), N'Seed', 114);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_seo_slug WHERE EntityType = N'Product' AND EntityId = (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'))
    INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Product', (SELECT Id FROM dbo.cf_product WHERE ProductName = N'Gel tẩy tế bào chết 40'), N'gel-tay-te-bao-chet-40-0115', 1, GETDATE(), N'Seed', 115);

