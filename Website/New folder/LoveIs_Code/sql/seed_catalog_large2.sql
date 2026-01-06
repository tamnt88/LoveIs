-- Large seed data for BeautyStory catalog (UTF-8)
USE BeautyStoryDB;
GO

-- Categories (parents + children)
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc da' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc da', NULL, N'Danh mục Chăm sóc da', 1, GETDATE(), N'Seed', 1);

DECLARE @ParentId_1 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc da' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sữa rửa mặt', @ParentId_1, N'Danh mục Sữa rửa mặt', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tẩy trang' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tẩy trang', @ParentId_1, N'Danh mục Tẩy trang', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Toner/Nước cân bằng' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Toner/Nước cân bằng', @ParentId_1, N'Danh mục Toner/Nước cân bằng', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Serum' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Serum', @ParentId_1, N'Danh mục Serum', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem dưỡng', @ParentId_1, N'Danh mục Kem dưỡng', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Mặt nạ' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mặt nạ', @ParentId_1, N'Danh mục Mặt nạ', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tẩy tế bào chết', @ParentId_1, N'Danh mục Tẩy tế bào chết', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dưỡng mắt' AND ParentId = @ParentId_1)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dưỡng mắt', @ParentId_1, N'Danh mục Dưỡng mắt', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Trang điểm' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trang điểm', NULL, N'Danh mục Trang điểm', 1, GETDATE(), N'Seed', 2);

DECLARE @ParentId_2 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Trang điểm' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem nền' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem nền', @ParentId_2, N'Danh mục Kem nền', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Phấn phủ' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Phấn phủ', @ParentId_2, N'Danh mục Phấn phủ', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Son môi' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Son môi', @ParentId_2, N'Danh mục Son môi', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kẻ mắt' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kẻ mắt', @ParentId_2, N'Danh mục Kẻ mắt', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Mascara' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mascara', @ParentId_2, N'Danh mục Mascara', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Má hồng' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Má hồng', @ParentId_2, N'Danh mục Má hồng', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Che khuyết điểm' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Che khuyết điểm', @ParentId_2, N'Danh mục Che khuyết điểm', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Cọ trang điểm' AND ParentId = @ParentId_2)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Cọ trang điểm', @ParentId_2, N'Danh mục Cọ trang điểm', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc tóc' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc tóc', NULL, N'Danh mục Chăm sóc tóc', 1, GETDATE(), N'Seed', 3);

DECLARE @ParentId_3 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc tóc' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dầu gội' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dầu gội', @ParentId_3, N'Danh mục Dầu gội', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dầu xả' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dầu xả', @ParentId_3, N'Danh mục Dầu xả', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ủ tóc' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ủ tóc', @ParentId_3, N'Danh mục Ủ tóc', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tinh dầu dưỡng tóc' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tinh dầu dưỡng tóc', @ParentId_3, N'Danh mục Tinh dầu dưỡng tóc', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Xịt dưỡng' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Xịt dưỡng', @ParentId_3, N'Danh mục Xịt dưỡng', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tạo kiểu' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tạo kiểu', @ParentId_3, N'Danh mục Tạo kiểu', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Serum tóc' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Serum tóc', @ParentId_3, N'Danh mục Serum tóc', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Nhuộm tóc' AND ParentId = @ParentId_3)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhuộm tóc', @ParentId_3, N'Danh mục Nhuộm tóc', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc cơ thể' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc cơ thể', NULL, N'Danh mục Chăm sóc cơ thể', 1, GETDATE(), N'Seed', 4);

DECLARE @ParentId_4 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc cơ thể' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Sữa tắm' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sữa tắm', @ParentId_4, N'Danh mục Sữa tắm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tẩy tế bào chết body' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tẩy tế bào chết body', @ParentId_4, N'Danh mục Tẩy tế bào chết body', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dưỡng thể' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dưỡng thể', @ParentId_4, N'Danh mục Dưỡng thể', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Khử mùi' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Khử mùi', @ParentId_4, N'Danh mục Khử mùi', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc tay' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc tay', @ParentId_4, N'Danh mục Chăm sóc tay', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc chân' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc chân', @ParentId_4, N'Danh mục Chăm sóc chân', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dưỡng môi' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dưỡng môi', @ParentId_4, N'Danh mục Dưỡng môi', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chống nứt gót' AND ParentId = @ParentId_4)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chống nứt gót', @ParentId_4, N'Danh mục Chống nứt gót', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chống nắng' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chống nắng', NULL, N'Danh mục Chống nắng', 1, GETDATE(), N'Seed', 5);

DECLARE @ParentId_5 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chống nắng' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem chống nắng' AND ParentId = @ParentId_5)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem chống nắng', @ParentId_5, N'Danh mục Kem chống nắng', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Sữa chống nắng' AND ParentId = @ParentId_5)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sữa chống nắng', @ParentId_5, N'Danh mục Sữa chống nắng', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Xịt chống nắng' AND ParentId = @ParentId_5)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Xịt chống nắng', @ParentId_5, N'Danh mục Xịt chống nắng', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chống nắng body' AND ParentId = @ParentId_5)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chống nắng body', @ParentId_5, N'Danh mục Chống nắng body', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chống nắng nâng tông' AND ParentId = @ParentId_5)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chống nắng nâng tông', @ParentId_5, N'Danh mục Chống nắng nâng tông', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Nước hoa' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nước hoa', NULL, N'Danh mục Nước hoa', 1, GETDATE(), N'Seed', 6);

DECLARE @ParentId_6 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Nước hoa' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Nước hoa nữ' AND ParentId = @ParentId_6)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nước hoa nữ', @ParentId_6, N'Danh mục Nước hoa nữ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Nước hoa nam' AND ParentId = @ParentId_6)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nước hoa nam', @ParentId_6, N'Danh mục Nước hoa nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Nước hoa unisex' AND ParentId = @ParentId_6)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nước hoa unisex', @ParentId_6, N'Danh mục Nước hoa unisex', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Xịt thơm body' AND ParentId = @ParentId_6)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Xịt thơm body', @ParentId_6, N'Danh mục Xịt thơm body', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Set quà nước hoa' AND ParentId = @ParentId_6)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set quà nước hoa', @ParentId_6, N'Danh mục Set quà nước hoa', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dược mỹ phẩm' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dược mỹ phẩm', NULL, N'Danh mục Dược mỹ phẩm', 1, GETDATE(), N'Seed', 7);

DECLARE @ParentId_7 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Dược mỹ phẩm' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Trị mụn' AND ParentId = @ParentId_7)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trị mụn', @ParentId_7, N'Danh mục Trị mụn', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Phục hồi da' AND ParentId = @ParentId_7)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Phục hồi da', @ParentId_7, N'Danh mục Phục hồi da', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Giảm kích ứng' AND ParentId = @ParentId_7)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Giảm kích ứng', @ParentId_7, N'Danh mục Giảm kích ứng', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Làm sáng da' AND ParentId = @ParentId_7)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Làm sáng da', @ParentId_7, N'Danh mục Làm sáng da', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dưỡng ẩm sâu' AND ParentId = @ParentId_7)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dưỡng ẩm sâu', @ParentId_7, N'Danh mục Dưỡng ẩm sâu', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc nam' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc nam', NULL, N'Danh mục Chăm sóc nam', 1, GETDATE(), N'Seed', 8);

DECLARE @ParentId_8 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc nam' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Sữa rửa mặt nam' AND ParentId = @ParentId_8)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sữa rửa mặt nam', @ParentId_8, N'Danh mục Sữa rửa mặt nam', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem dưỡng nam' AND ParentId = @ParentId_8)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem dưỡng nam', @ParentId_8, N'Danh mục Kem dưỡng nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tạo kiểu tóc nam' AND ParentId = @ParentId_8)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tạo kiểu tóc nam', @ParentId_8, N'Danh mục Tạo kiểu tóc nam', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Lăn khử mùi nam' AND ParentId = @ParentId_8)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Lăn khử mùi nam', @ParentId_8, N'Danh mục Lăn khử mùi nam', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Nước hoa nam' AND ParentId = @ParentId_8)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nước hoa nam', @ParentId_8, N'Danh mục Nước hoa nam', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Mẹ & bé' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mẹ & bé', NULL, N'Danh mục Mẹ & bé', 1, GETDATE(), N'Seed', 9);

DECLARE @ParentId_9 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Mẹ & bé' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tắm gội cho bé' AND ParentId = @ParentId_9)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tắm gội cho bé', @ParentId_9, N'Danh mục Tắm gội cho bé', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Dưỡng da cho bé' AND ParentId = @ParentId_9)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dưỡng da cho bé', @ParentId_9, N'Danh mục Dưỡng da cho bé', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chống hăm' AND ParentId = @ParentId_9)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chống hăm', @ParentId_9, N'Danh mục Chống hăm', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc mẹ bầu' AND ParentId = @ParentId_9)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chăm sóc mẹ bầu', @ParentId_9, N'Danh mục Chăm sóc mẹ bầu', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Khăn ướt' AND ParentId = @ParentId_9)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Khăn ướt', @ParentId_9, N'Danh mục Khăn ướt', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Thiết bị làm đẹp' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thiết bị làm đẹp', NULL, N'Danh mục Thiết bị làm đẹp', 1, GETDATE(), N'Seed', 10);

DECLARE @ParentId_10 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Thiết bị làm đẹp' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Máy rửa mặt' AND ParentId = @ParentId_10)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Máy rửa mặt', @ParentId_10, N'Danh mục Máy rửa mặt', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Máy đẩy tinh chất' AND ParentId = @ParentId_10)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Máy đẩy tinh chất', @ParentId_10, N'Danh mục Máy đẩy tinh chất', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Máy massage' AND ParentId = @ParentId_10)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Máy massage', @ParentId_10, N'Danh mục Máy massage', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Máy triệt lông' AND ParentId = @ParentId_10)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Máy triệt lông', @ParentId_10, N'Danh mục Máy triệt lông', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Máy sấy tóc' AND ParentId = @ParentId_10)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Máy sấy tóc', @ParentId_10, N'Danh mục Máy sấy tóc', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Máy uốn tóc' AND ParentId = @ParentId_10)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Máy uốn tóc', @ParentId_10, N'Danh mục Máy uốn tóc', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Thực phẩm bổ sung' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thực phẩm bổ sung', NULL, N'Danh mục Thực phẩm bổ sung', 1, GETDATE(), N'Seed', 11);

DECLARE @ParentId_11 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Thực phẩm bổ sung' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Collagen' AND ParentId = @ParentId_11)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Collagen', @ParentId_11, N'Danh mục Collagen', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Vitamin tổng hợp' AND ParentId = @ParentId_11)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vitamin tổng hợp', @ParentId_11, N'Danh mục Vitamin tổng hợp', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Viên uống đẹp da' AND ParentId = @ParentId_11)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Viên uống đẹp da', @ParentId_11, N'Danh mục Viên uống đẹp da', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Hỗ trợ tóc móng' AND ParentId = @ParentId_11)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hỗ trợ tóc móng', @ParentId_11, N'Danh mục Hỗ trợ tóc móng', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Hỗ trợ giấc ngủ' AND ParentId = @ParentId_11)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hỗ trợ giấc ngủ', @ParentId_11, N'Danh mục Hỗ trợ giấc ngủ', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Quà tặng & set' AND ParentId IS NULL)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Quà tặng & set', NULL, N'Danh mục Quà tặng & set', 1, GETDATE(), N'Seed', 12);

DECLARE @ParentId_12 INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Quà tặng & set' AND ParentId IS NULL);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Set dưỡng da' AND ParentId = @ParentId_12)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set dưỡng da', @ParentId_12, N'Danh mục Set dưỡng da', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Set trang điểm' AND ParentId = @ParentId_12)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set trang điểm', @ParentId_12, N'Danh mục Set trang điểm', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Set chăm sóc tóc' AND ParentId = @ParentId_12)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set chăm sóc tóc', @ParentId_12, N'Danh mục Set chăm sóc tóc', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Set cơ thể' AND ParentId = @ParentId_12)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set cơ thể', @ParentId_12, N'Danh mục Set cơ thể', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Set mini travel' AND ParentId = @ParentId_12)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Set mini travel', @ParentId_12, N'Danh mục Set mini travel', 1, GETDATE(), N'Seed', 5);

-- Brands
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'L''Oréal')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'L''Oréal', N'Thương hiệu L''Oréal', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Maybelline')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Maybelline', N'Thương hiệu Maybelline', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Innisfree')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Innisfree', N'Thương hiệu Innisfree', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'The Face Shop')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'The Face Shop', N'Thương hiệu The Face Shop', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Laneige')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Laneige', N'Thương hiệu Laneige', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'La Roche-Posay', N'Thương hiệu La Roche-Posay', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Vichy')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vichy', N'Thương hiệu Vichy', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Eucerin')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Eucerin', N'Thương hiệu Eucerin', 1, GETDATE(), N'Seed', 8);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Bioderma')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bioderma', N'Thương hiệu Bioderma', 1, GETDATE(), N'Seed', 9);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Hada Labo')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hada Labo', N'Thương hiệu Hada Labo', 1, GETDATE(), N'Seed', 10);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Some By Mi')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Some By Mi', N'Thương hiệu Some By Mi', 1, GETDATE(), N'Seed', 11);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Anessa')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Anessa', N'Thương hiệu Anessa', 1, GETDATE(), N'Seed', 12);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Shiseido')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Shiseido', N'Thương hiệu Shiseido', 1, GETDATE(), N'Seed', 13);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'SK-II')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'SK-II', N'Thương hiệu SK-II', 1, GETDATE(), N'Seed', 14);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Kiehl''s')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kiehl''s', N'Thương hiệu Kiehl''s', 1, GETDATE(), N'Seed', 15);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Paula''s Choice')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Paula''s Choice', N'Thương hiệu Paula''s Choice', 1, GETDATE(), N'Seed', 16);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Neutrogena')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Neutrogena', N'Thương hiệu Neutrogena', 1, GETDATE(), N'Seed', 17);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Cetaphil')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Cetaphil', N'Thương hiệu Cetaphil', 1, GETDATE(), N'Seed', 18);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Simple')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Simple', N'Thương hiệu Simple', 1, GETDATE(), N'Seed', 19);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'The Ordinary')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'The Ordinary', N'Thương hiệu The Ordinary', 1, GETDATE(), N'Seed', 20);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'MAC')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'MAC', N'Thương hiệu MAC', 1, GETDATE(), N'Seed', 21);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Clinique')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Clinique', N'Thương hiệu Clinique', 1, GETDATE(), N'Seed', 22);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Dior')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dior', N'Thương hiệu Dior', 1, GETDATE(), N'Seed', 23);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Chanel')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chanel', N'Thương hiệu Chanel', 1, GETDATE(), N'Seed', 24);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Nivea')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nivea', N'Thương hiệu Nivea', 1, GETDATE(), N'Seed', 25);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Senka')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Senka', N'Thương hiệu Senka', 1, GETDATE(), N'Seed', 26);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'COSRX')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'COSRX', N'Thương hiệu COSRX', 1, GETDATE(), N'Seed', 27);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Nature Republic')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nature Republic', N'Thương hiệu Nature Republic', 1, GETDATE(), N'Seed', 28);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Garnier')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Garnier', N'Thương hiệu Garnier', 1, GETDATE(), N'Seed', 29);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'CeraVe')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'CeraVe', N'Thương hiệu CeraVe', 1, GETDATE(), N'Seed', 30);

-- Origins
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Hàn Quốc')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hàn Quốc', N'Xuất xứ Hàn Quốc', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Nhật Bản')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhật Bản', N'Xuất xứ Nhật Bản', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Pháp')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Pháp', N'Xuất xứ Pháp', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Mỹ')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mỹ', N'Xuất xứ Mỹ', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Đức')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đức', N'Xuất xứ Đức', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Thái Lan')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thái Lan', N'Xuất xứ Thái Lan', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Trung Quốc')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trung Quốc', N'Xuất xứ Trung Quốc', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Anh')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Anh', N'Xuất xứ Anh', 1, GETDATE(), N'Seed', 8);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Úc')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Úc', N'Xuất xứ Úc', 1, GETDATE(), N'Seed', 9);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Ý')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ý', N'Xuất xứ Ý', 1, GETDATE(), N'Seed', 10);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Canada')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Canada', N'Xuất xứ Canada', 1, GETDATE(), N'Seed', 11);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Tây Ban Nha')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tây Ban Nha', N'Xuất xứ Tây Ban Nha', 1, GETDATE(), N'Seed', 12);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Thụy Sĩ')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thụy Sĩ', N'Xuất xứ Thụy Sĩ', 1, GETDATE(), N'Seed', 13);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Hà Lan')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hà Lan', N'Xuất xứ Hà Lan', 1, GETDATE(), N'Seed', 14);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Việt Nam')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Việt Nam', N'Xuất xứ Việt Nam', 1, GETDATE(), N'Seed', 15);

-- Variant attributes & values
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Hương')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hương', N'Thuộc tính Hương', 1, GETDATE(), N'Seed', 1);
DECLARE @AttrId_1 INT = (SELECT Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Hương');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_1 AND ValueName = N'Hoa cỏ')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_1, N'Hoa cỏ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_1 AND ValueName = N'Trái cây')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_1, N'Trái cây', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_1 AND ValueName = N'Gỗ')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_1, N'Gỗ', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_1 AND ValueName = N'Xạ hương')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_1, N'Xạ hương', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_1 AND ValueName = N'Không mùi')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_1, N'Không mùi', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Kích thước')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kích thước', N'Thuộc tính Kích thước', 1, GETDATE(), N'Seed', 2);
DECLARE @AttrId_2 INT = (SELECT Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_2 AND ValueName = N'Mini')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_2, N'Mini', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_2 AND ValueName = N'Vừa')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_2, N'Vừa', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_2 AND ValueName = N'Lớn')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_2, N'Lớn', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Màu sắc')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Màu sắc', N'Thuộc tính Màu sắc', 1, GETDATE(), N'Seed', 3);
DECLARE @AttrId_3 INT = (SELECT Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_3 AND ValueName = N'Đỏ')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_3, N'Đỏ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_3 AND ValueName = N'Hồng')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_3, N'Hồng', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_3 AND ValueName = N'Cam')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_3, N'Cam', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_3 AND ValueName = N'Nude')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_3, N'Nude', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_3 AND ValueName = N'Nâu')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_3, N'Nâu', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_3 AND ValueName = N'Đen')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_3, N'Đen', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Gói')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Gói', N'Thuộc tính Gói', 1, GETDATE(), N'Seed', 4);
DECLARE @AttrId_4 INT = (SELECT Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Gói');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_4 AND ValueName = N'1 sản phẩm')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_4, N'1 sản phẩm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_4 AND ValueName = N'Set 2')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_4, N'Set 2', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_4 AND ValueName = N'Set 3')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_4, N'Set 3', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_4 AND ValueName = N'Combo')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_4, N'Combo', 1, GETDATE(), N'Seed', 4);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Tông da')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tông da', N'Thuộc tính Tông da', 1, GETDATE(), N'Seed', 5);
DECLARE @AttrId_5 INT = (SELECT Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Tông da');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_5 AND ValueName = N'Sáng')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_5, N'Sáng', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_5 AND ValueName = N'Trung bình')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_5, N'Trung bình', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_5 AND ValueName = N'Ngăm')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_5, N'Ngăm', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung tích')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dung tích', N'Thuộc tính Dung tích', 1, GETDATE(), N'Seed', 6);
DECLARE @AttrId_6 INT = (SELECT Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'5ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'5ml', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'10ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'10ml', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'15ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'15ml', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'30ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'30ml', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'50ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'50ml', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'100ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'100ml', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId_6 AND ValueName = N'200ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId_6, N'200ml', 1, GETDATE(), N'Seed', 7);

-- Filter groups & options
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Kết cấu')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kết cấu', N'Nhóm lọc Kết cấu', 1, GETDATE(), N'Seed', 1);
DECLARE @GroupId_1 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Kết cấu');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_1 AND OptionName = N'Gel')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_1, N'Gel', N'Tùy chọn Gel', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_1 AND OptionName = N'Kem')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_1, N'Kem', N'Tùy chọn Kem', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_1 AND OptionName = N'Sữa')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_1, N'Sữa', N'Tùy chọn Sữa', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_1 AND OptionName = N'Lỏng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_1, N'Lỏng', N'Tùy chọn Lỏng', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_1 AND OptionName = N'Dạng xịt')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_1, N'Dạng xịt', N'Tùy chọn Dạng xịt', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_1 AND OptionName = N'Dạng bọt')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_1, N'Dạng bọt', N'Tùy chọn Dạng bọt', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Mùi hương')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mùi hương', N'Nhóm lọc Mùi hương', 1, GETDATE(), N'Seed', 2);
DECLARE @GroupId_2 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Mùi hương');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_2 AND OptionName = N'Hương hoa')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_2, N'Hương hoa', N'Tùy chọn Hương hoa', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_2 AND OptionName = N'Hương trái cây')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_2, N'Hương trái cây', N'Tùy chọn Hương trái cây', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_2 AND OptionName = N'Hương gỗ')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_2, N'Hương gỗ', N'Tùy chọn Hương gỗ', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_2 AND OptionName = N'Hương phấn')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_2, N'Hương phấn', N'Tùy chọn Hương phấn', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_2 AND OptionName = N'Hương tươi mát')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_2, N'Hương tươi mát', N'Tùy chọn Hương tươi mát', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Loại tóc')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Loại tóc', N'Nhóm lọc Loại tóc', 1, GETDATE(), N'Seed', 3);
DECLARE @GroupId_3 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại tóc');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_3 AND OptionName = N'Tóc dầu')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_3, N'Tóc dầu', N'Tùy chọn Tóc dầu', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_3 AND OptionName = N'Tóc khô')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_3, N'Tóc khô', N'Tùy chọn Tóc khô', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_3 AND OptionName = N'Tóc hư tổn')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_3, N'Tóc hư tổn', N'Tùy chọn Tóc hư tổn', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_3 AND OptionName = N'Tóc nhuộm')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_3, N'Tóc nhuộm', N'Tùy chọn Tóc nhuộm', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_3 AND OptionName = N'Tóc rụng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_3, N'Tóc rụng', N'Tùy chọn Tóc rụng', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Công dụng chính', N'Nhóm lọc Công dụng chính', 1, GETDATE(), N'Seed', 4);
DECLARE @GroupId_4 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Dưỡng ẩm')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Dưỡng ẩm', N'Tùy chọn Dưỡng ẩm', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Làm sáng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Làm sáng', N'Tùy chọn Làm sáng', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Chống lão hóa')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Chống lão hóa', N'Tùy chọn Chống lão hóa', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Trị mụn')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Trị mụn', N'Tùy chọn Trị mụn', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Phục hồi')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Phục hồi', N'Tùy chọn Phục hồi', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Kiềm dầu')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Kiềm dầu', N'Tùy chọn Kiềm dầu', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_4 AND OptionName = N'Chống nắng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_4, N'Chống nắng', N'Tùy chọn Chống nắng', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Loại da')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Loại da', N'Nhóm lọc Loại da', 1, GETDATE(), N'Seed', 5);
DECLARE @GroupId_5 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại da');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_5 AND OptionName = N'Da khô')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_5, N'Da khô', N'Tùy chọn Da khô', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_5 AND OptionName = N'Da dầu')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_5, N'Da dầu', N'Tùy chọn Da dầu', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_5 AND OptionName = N'Da hỗn hợp')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_5, N'Da hỗn hợp', N'Tùy chọn Da hỗn hợp', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_5 AND OptionName = N'Da thường')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_5, N'Da thường', N'Tùy chọn Da thường', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_5 AND OptionName = N'Da nhạy cảm')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_5, N'Da nhạy cảm', N'Tùy chọn Da nhạy cảm', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Độ chống nắng')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Độ chống nắng', N'Nhóm lọc Độ chống nắng', 1, GETDATE(), N'Seed', 6);
DECLARE @GroupId_6 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Độ chống nắng');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_6 AND OptionName = N'SPF30')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_6, N'SPF30', N'Tùy chọn SPF30', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_6 AND OptionName = N'SPF50')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_6, N'SPF50', N'Tùy chọn SPF50', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_6 AND OptionName = N'PA++')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_6, N'PA++', N'Tùy chọn PA++', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_6 AND OptionName = N'PA+++')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_6, N'PA+++', N'Tùy chọn PA+++', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_6 AND OptionName = N'PA++++')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_6, N'PA++++', N'Tùy chọn PA++++', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Vấn đề về da')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vấn đề về da', N'Nhóm lọc Vấn đề về da', 1, GETDATE(), N'Seed', 7);
DECLARE @GroupId_7 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Vấn đề về da');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Mụn')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Mụn', N'Tùy chọn Mụn', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Thâm nám')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Thâm nám', N'Tùy chọn Thâm nám', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Lão hóa')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Lão hóa', N'Tùy chọn Lão hóa', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Da khô')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Da khô', N'Tùy chọn Da khô', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Da dầu')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Da dầu', N'Tùy chọn Da dầu', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Da nhạy cảm')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Da nhạy cảm', N'Tùy chọn Da nhạy cảm', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Lỗ chân lông')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Lỗ chân lông', N'Tùy chọn Lỗ chân lông', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_7 AND OptionName = N'Xỉn màu')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_7, N'Xỉn màu', N'Tùy chọn Xỉn màu', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Giới tính', N'Nhóm lọc Giới tính', 1, GETDATE(), N'Seed', 8);
DECLARE @GroupId_8 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_8 AND OptionName = N'Nữ')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_8, N'Nữ', N'Tùy chọn Nữ', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_8 AND OptionName = N'Nam')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_8, N'Nam', N'Tùy chọn Nam', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_8 AND OptionName = N'Unisex')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_8, N'Unisex', N'Tùy chọn Unisex', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thành phần nổi bật', N'Nhóm lọc Thành phần nổi bật', 1, GETDATE(), N'Seed', 9);
DECLARE @GroupId_9 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Vitamin C')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Vitamin C', N'Tùy chọn Vitamin C', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Retinol')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Retinol', N'Tùy chọn Retinol', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Niacinamide')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Niacinamide', N'Tùy chọn Niacinamide', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Hyaluronic Acid')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Hyaluronic Acid', N'Tùy chọn Hyaluronic Acid', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Ceramide')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Ceramide', N'Tùy chọn Ceramide', 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'AHA/BHA')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'AHA/BHA', N'Tùy chọn AHA/BHA', 1, GETDATE(), N'Seed', 6);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Peptide')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Peptide', N'Tùy chọn Peptide', 1, GETDATE(), N'Seed', 7);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_9 AND OptionName = N'Arbutin')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_9, N'Arbutin', N'Tùy chọn Arbutin', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Phong cách trang điểm')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Phong cách trang điểm', N'Nhóm lọc Phong cách trang điểm', 1, GETDATE(), N'Seed', 10);
DECLARE @GroupId_10 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Phong cách trang điểm');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_10 AND OptionName = N'Tự nhiên')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_10, N'Tự nhiên', N'Tùy chọn Tự nhiên', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_10 AND OptionName = N'Hàn Quốc')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_10, N'Hàn Quốc', N'Tùy chọn Hàn Quốc', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_10 AND OptionName = N'Cá tính')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_10, N'Cá tính', N'Tùy chọn Cá tính', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_10 AND OptionName = N'Sang trọng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_10, N'Sang trọng', N'Tùy chọn Sang trọng', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_10 AND OptionName = N'Dạ tiệc')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_10, N'Dạ tiệc', N'Tùy chọn Dạ tiệc', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dòng sản phẩm', N'Nhóm lọc Dòng sản phẩm', 1, GETDATE(), N'Seed', 11);
DECLARE @GroupId_11 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_11 AND OptionName = N'Cao cấp')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_11, N'Cao cấp', N'Tùy chọn Cao cấp', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_11 AND OptionName = N'Phổ thông')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_11, N'Phổ thông', N'Tùy chọn Phổ thông', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_11 AND OptionName = N'Thiên nhiên')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_11, N'Thiên nhiên', N'Tùy chọn Thiên nhiên', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_11 AND OptionName = N'Hữu cơ')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_11, N'Hữu cơ', N'Tùy chọn Hữu cơ', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_11 AND OptionName = N'Dành cho da nhạy cảm')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_11, N'Dành cho da nhạy cảm', N'Tùy chọn Dành cho da nhạy cảm', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đặc tính', N'Nhóm lọc Đặc tính', 1, GETDATE(), N'Seed', 12);
DECLARE @GroupId_12 INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_12 AND OptionName = N'Không paraben')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_12, N'Không paraben', N'Tùy chọn Không paraben', 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_12 AND OptionName = N'Không cồn')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_12, N'Không cồn', N'Tùy chọn Không cồn', 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_12 AND OptionName = N'Không hương liệu')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_12, N'Không hương liệu', N'Tùy chọn Không hương liệu', 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_12 AND OptionName = N'Thuần chay')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_12, N'Thuần chay', N'Tùy chọn Thuần chay', 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId_12 AND OptionName = N'Không thử nghiệm trên động vật')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId_12, N'Không thử nghiệm trên động vật', N'Tùy chọn Không thử nghiệm trên động vật', 1, GETDATE(), N'Seed', 5);

-- Map filter groups to parent categories
DECLARE @CategoryId_Ch_m_s_c_da INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc da' AND ParentId IS NULL);
DECLARE @GroupId_Ch_m_s_c_da_D_ng_s_n_ph_m INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da_D_ng_s_n_ph_m IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da_D_ng_s_n_ph_m
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da_D_ng_s_n_ph_m, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_da_V_n_v_da INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Vấn đề về da');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da_V_n_v_da IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da_V_n_v_da
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da_V_n_v_da, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_da_Th_nh_ph_n_n_i_b_t INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da_Th_nh_ph_n_n_i_b_t IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da_Th_nh_ph_n_n_i_b_t
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da_Th_nh_ph_n_n_i_b_t, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_da_Lo_i_da INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại da');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da_Lo_i_da IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da_Lo_i_da
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da_Lo_i_da, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_da_C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da_C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da_C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da_C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_da__c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da__c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da__c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da__c_t_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_da_K_t_c_u INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Kết cấu');
IF @CategoryId_Ch_m_s_c_da IS NOT NULL AND @GroupId_Ch_m_s_c_da_K_t_c_u IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_da AND GroupId = @GroupId_Ch_m_s_c_da_K_t_c_u
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_da, @GroupId_Ch_m_s_c_da_K_t_c_u, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_D_c_m_ph_m INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Dược mỹ phẩm' AND ParentId IS NULL);
DECLARE @GroupId_D_c_m_ph_m_V_n_v_da INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Vấn đề về da');
IF @CategoryId_D_c_m_ph_m IS NOT NULL AND @GroupId_D_c_m_ph_m_V_n_v_da IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_D_c_m_ph_m AND GroupId = @GroupId_D_c_m_ph_m_V_n_v_da
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_D_c_m_ph_m, @GroupId_D_c_m_ph_m_V_n_v_da, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_D_c_m_ph_m_Th_nh_ph_n_n_i_b_t INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật');
IF @CategoryId_D_c_m_ph_m IS NOT NULL AND @GroupId_D_c_m_ph_m_Th_nh_ph_n_n_i_b_t IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_D_c_m_ph_m AND GroupId = @GroupId_D_c_m_ph_m_Th_nh_ph_n_n_i_b_t
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_D_c_m_ph_m, @GroupId_D_c_m_ph_m_Th_nh_ph_n_n_i_b_t, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_D_c_m_ph_m_Lo_i_da INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại da');
IF @CategoryId_D_c_m_ph_m IS NOT NULL AND @GroupId_D_c_m_ph_m_Lo_i_da IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_D_c_m_ph_m AND GroupId = @GroupId_D_c_m_ph_m_Lo_i_da
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_D_c_m_ph_m, @GroupId_D_c_m_ph_m_Lo_i_da, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_D_c_m_ph_m_C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_D_c_m_ph_m IS NOT NULL AND @GroupId_D_c_m_ph_m_C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_D_c_m_ph_m AND GroupId = @GroupId_D_c_m_ph_m_C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_D_c_m_ph_m, @GroupId_D_c_m_ph_m_C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Ch_ng_n_ng INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chống nắng' AND ParentId IS NULL);
DECLARE @GroupId_Ch_ng_n_ng__ch_ng_n_ng INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Độ chống nắng');
IF @CategoryId_Ch_ng_n_ng IS NOT NULL AND @GroupId_Ch_ng_n_ng__ch_ng_n_ng IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_ng_n_ng AND GroupId = @GroupId_Ch_ng_n_ng__ch_ng_n_ng
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_ng_n_ng, @GroupId_Ch_ng_n_ng__ch_ng_n_ng, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_ng_n_ng_Lo_i_da INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại da');
IF @CategoryId_Ch_ng_n_ng IS NOT NULL AND @GroupId_Ch_ng_n_ng_Lo_i_da IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_ng_n_ng AND GroupId = @GroupId_Ch_ng_n_ng_Lo_i_da
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_ng_n_ng, @GroupId_Ch_ng_n_ng_Lo_i_da, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_ng_n_ng_K_t_c_u INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Kết cấu');
IF @CategoryId_Ch_ng_n_ng IS NOT NULL AND @GroupId_Ch_ng_n_ng_K_t_c_u IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_ng_n_ng AND GroupId = @GroupId_Ch_ng_n_ng_K_t_c_u
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_ng_n_ng, @GroupId_Ch_ng_n_ng_K_t_c_u, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_ng_n_ng__c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_Ch_ng_n_ng IS NOT NULL AND @GroupId_Ch_ng_n_ng__c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_ng_n_ng AND GroupId = @GroupId_Ch_ng_n_ng__c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_ng_n_ng, @GroupId_Ch_ng_n_ng__c_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_M_b_ INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Mẹ & bé' AND ParentId IS NULL);
DECLARE @GroupId_M_b__D_ng_s_n_ph_m INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm');
IF @CategoryId_M_b_ IS NOT NULL AND @GroupId_M_b__D_ng_s_n_ph_m IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_M_b_ AND GroupId = @GroupId_M_b__D_ng_s_n_ph_m
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_M_b_, @GroupId_M_b__D_ng_s_n_ph_m, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_M_b___c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_M_b_ IS NOT NULL AND @GroupId_M_b___c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_M_b_ AND GroupId = @GroupId_M_b___c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_M_b_, @GroupId_M_b___c_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Trang_i_m INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Trang điểm' AND ParentId IS NULL);
DECLARE @GroupId_Trang_i_m_Phong_c_ch_trang_i_m INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Phong cách trang điểm');
IF @CategoryId_Trang_i_m IS NOT NULL AND @GroupId_Trang_i_m_Phong_c_ch_trang_i_m IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Trang_i_m AND GroupId = @GroupId_Trang_i_m_Phong_c_ch_trang_i_m
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Trang_i_m, @GroupId_Trang_i_m_Phong_c_ch_trang_i_m, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Trang_i_m_K_t_c_u INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Kết cấu');
IF @CategoryId_Trang_i_m IS NOT NULL AND @GroupId_Trang_i_m_K_t_c_u IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Trang_i_m AND GroupId = @GroupId_Trang_i_m_K_t_c_u
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Trang_i_m, @GroupId_Trang_i_m_K_t_c_u, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Trang_i_m_Gi_i_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính');
IF @CategoryId_Trang_i_m IS NOT NULL AND @GroupId_Trang_i_m_Gi_i_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Trang_i_m AND GroupId = @GroupId_Trang_i_m_Gi_i_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Trang_i_m, @GroupId_Trang_i_m_Gi_i_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Ch_m_s_c_nam INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc nam' AND ParentId IS NULL);
DECLARE @GroupId_Ch_m_s_c_nam_C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_Ch_m_s_c_nam IS NOT NULL AND @GroupId_Ch_m_s_c_nam_C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_nam AND GroupId = @GroupId_Ch_m_s_c_nam_C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_nam, @GroupId_Ch_m_s_c_nam_C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_nam__c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_Ch_m_s_c_nam IS NOT NULL AND @GroupId_Ch_m_s_c_nam__c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_nam AND GroupId = @GroupId_Ch_m_s_c_nam__c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_nam, @GroupId_Ch_m_s_c_nam__c_t_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_nam_M_i_h_ng INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Mùi hương');
IF @CategoryId_Ch_m_s_c_nam IS NOT NULL AND @GroupId_Ch_m_s_c_nam_M_i_h_ng IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_nam AND GroupId = @GroupId_Ch_m_s_c_nam_M_i_h_ng
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_nam, @GroupId_Ch_m_s_c_nam_M_i_h_ng, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_N_c_hoa INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Nước hoa' AND ParentId IS NULL);
DECLARE @GroupId_N_c_hoa_M_i_h_ng INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Mùi hương');
IF @CategoryId_N_c_hoa IS NOT NULL AND @GroupId_N_c_hoa_M_i_h_ng IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_N_c_hoa AND GroupId = @GroupId_N_c_hoa_M_i_h_ng
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_N_c_hoa, @GroupId_N_c_hoa_M_i_h_ng, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_N_c_hoa_Gi_i_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính');
IF @CategoryId_N_c_hoa IS NOT NULL AND @GroupId_N_c_hoa_Gi_i_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_N_c_hoa AND GroupId = @GroupId_N_c_hoa_Gi_i_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_N_c_hoa, @GroupId_N_c_hoa_Gi_i_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Qu_t_ng_set INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Quà tặng & set' AND ParentId IS NULL);
DECLARE @GroupId_Qu_t_ng_set_D_ng_s_n_ph_m INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm');
IF @CategoryId_Qu_t_ng_set IS NOT NULL AND @GroupId_Qu_t_ng_set_D_ng_s_n_ph_m IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Qu_t_ng_set AND GroupId = @GroupId_Qu_t_ng_set_D_ng_s_n_ph_m
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Qu_t_ng_set, @GroupId_Qu_t_ng_set_D_ng_s_n_ph_m, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Qu_t_ng_set_Gi_i_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Giới tính');
IF @CategoryId_Qu_t_ng_set IS NOT NULL AND @GroupId_Qu_t_ng_set_Gi_i_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Qu_t_ng_set AND GroupId = @GroupId_Qu_t_ng_set_Gi_i_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Qu_t_ng_set, @GroupId_Qu_t_ng_set_Gi_i_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Th_c_ph_m_b_sung INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Thực phẩm bổ sung' AND ParentId IS NULL);
DECLARE @GroupId_Th_c_ph_m_b_sung_C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_Th_c_ph_m_b_sung IS NOT NULL AND @GroupId_Th_c_ph_m_b_sung_C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Th_c_ph_m_b_sung AND GroupId = @GroupId_Th_c_ph_m_b_sung_C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Th_c_ph_m_b_sung, @GroupId_Th_c_ph_m_b_sung_C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Th_c_ph_m_b_sung__c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_Th_c_ph_m_b_sung IS NOT NULL AND @GroupId_Th_c_ph_m_b_sung__c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Th_c_ph_m_b_sung AND GroupId = @GroupId_Th_c_ph_m_b_sung__c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Th_c_ph_m_b_sung, @GroupId_Th_c_ph_m_b_sung__c_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Thi_t_b_l_m_p INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Thiết bị làm đẹp' AND ParentId IS NULL);
DECLARE @GroupId_Thi_t_b_l_m_p_C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_Thi_t_b_l_m_p IS NOT NULL AND @GroupId_Thi_t_b_l_m_p_C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Thi_t_b_l_m_p AND GroupId = @GroupId_Thi_t_b_l_m_p_C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Thi_t_b_l_m_p, @GroupId_Thi_t_b_l_m_p_C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Ch_m_s_c_t_c INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc tóc' AND ParentId IS NULL);
DECLARE @GroupId_Ch_m_s_c_t_c_Lo_i_t_c INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Loại tóc');
IF @CategoryId_Ch_m_s_c_t_c IS NOT NULL AND @GroupId_Ch_m_s_c_t_c_Lo_i_t_c IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_t_c AND GroupId = @GroupId_Ch_m_s_c_t_c_Lo_i_t_c
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_t_c, @GroupId_Ch_m_s_c_t_c_Lo_i_t_c, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_t_c_Th_nh_ph_n_n_i_b_t INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật');
IF @CategoryId_Ch_m_s_c_t_c IS NOT NULL AND @GroupId_Ch_m_s_c_t_c_Th_nh_ph_n_n_i_b_t IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_t_c AND GroupId = @GroupId_Ch_m_s_c_t_c_Th_nh_ph_n_n_i_b_t
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_t_c, @GroupId_Ch_m_s_c_t_c_Th_nh_ph_n_n_i_b_t, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_t_c_C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_Ch_m_s_c_t_c IS NOT NULL AND @GroupId_Ch_m_s_c_t_c_C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_t_c AND GroupId = @GroupId_Ch_m_s_c_t_c_C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_t_c, @GroupId_Ch_m_s_c_t_c_C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_t_c__c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_Ch_m_s_c_t_c IS NOT NULL AND @GroupId_Ch_m_s_c_t_c__c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_t_c AND GroupId = @GroupId_Ch_m_s_c_t_c__c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_t_c, @GroupId_Ch_m_s_c_t_c__c_t_nh, 1, GETDATE(), N'Seed', 0);

DECLARE @CategoryId_Ch_m_s_c_c_th_ INT = (SELECT Id FROM dbo.cf_category WHERE CategoryName = N'Chăm sóc cơ thể' AND ParentId IS NULL);
DECLARE @GroupId_Ch_m_s_c_c_th__D_ng_s_n_ph_m INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Dòng sản phẩm');
IF @CategoryId_Ch_m_s_c_c_th_ IS NOT NULL AND @GroupId_Ch_m_s_c_c_th__D_ng_s_n_ph_m IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_c_th_ AND GroupId = @GroupId_Ch_m_s_c_c_th__D_ng_s_n_ph_m
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_c_th_, @GroupId_Ch_m_s_c_c_th__D_ng_s_n_ph_m, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_c_th__Th_nh_ph_n_n_i_b_t INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Thành phần nổi bật');
IF @CategoryId_Ch_m_s_c_c_th_ IS NOT NULL AND @GroupId_Ch_m_s_c_c_th__Th_nh_ph_n_n_i_b_t IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_c_th_ AND GroupId = @GroupId_Ch_m_s_c_c_th__Th_nh_ph_n_n_i_b_t
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_c_th_, @GroupId_Ch_m_s_c_c_th__Th_nh_ph_n_n_i_b_t, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_c_th__C_ng_d_ng_ch_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Công dụng chính');
IF @CategoryId_Ch_m_s_c_c_th_ IS NOT NULL AND @GroupId_Ch_m_s_c_c_th__C_ng_d_ng_ch_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_c_th_ AND GroupId = @GroupId_Ch_m_s_c_c_th__C_ng_d_ng_ch_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_c_th_, @GroupId_Ch_m_s_c_c_th__C_ng_d_ng_ch_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_c_th___c_t_nh INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Đặc tính');
IF @CategoryId_Ch_m_s_c_c_th_ IS NOT NULL AND @GroupId_Ch_m_s_c_c_th___c_t_nh IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_c_th_ AND GroupId = @GroupId_Ch_m_s_c_c_th___c_t_nh
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_c_th_, @GroupId_Ch_m_s_c_c_th___c_t_nh, 1, GETDATE(), N'Seed', 0);
DECLARE @GroupId_Ch_m_s_c_c_th__M_i_h_ng INT = (SELECT Id FROM dbo.cf_filter_group WHERE GroupName = N'Mùi hương');
IF @CategoryId_Ch_m_s_c_c_th_ IS NOT NULL AND @GroupId_Ch_m_s_c_c_th__M_i_h_ng IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CategoryId_Ch_m_s_c_c_th_ AND GroupId = @GroupId_Ch_m_s_c_c_th__M_i_h_ng
)
    INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@CategoryId_Ch_m_s_c_c_th_, @GroupId_Ch_m_s_c_c_th__M_i_h_ng, 1, GETDATE(), N'Seed', 0);

