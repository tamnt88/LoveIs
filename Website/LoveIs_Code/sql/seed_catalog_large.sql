-- Large seed data for BeautyStory catalog
USE BeautyStoryDB;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c da')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c da', NULL, N'Danh m?c Ch?m s?c da', 1, GETDATE(), N'Seed', 1);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Trang ?i?m')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trang ?i?m', NULL, N'Danh m?c Trang ?i?m', 1, GETDATE(), N'Seed', 2);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c t?c')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c t?c', NULL, N'Danh m?c Ch?m s?c t?c', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c c? th?')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c c? th?', NULL, N'Danh m?c Ch?m s?c c? th?', 1, GETDATE(), N'Seed', 4);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa', NULL, N'Danh m?c N??c hoa', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng', NULL, N'Danh m?c Ch?ng n?ng', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c nam')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c nam', NULL, N'Danh m?c Ch?m s?c nam', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Thi?t b? l?m ??p')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thi?t b? l?m ??p', NULL, N'Danh m?c Thi?t b? l?m ??p', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c m? & b?')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c m? & b?', NULL, N'Danh m?c Ch?m s?c m? & b?', 1, GETDATE(), N'Seed', 9);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c r?ng mi?ng')
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c r?ng mi?ng', NULL, N'Danh m?c Ch?m s?c r?ng mi?ng', 1, GETDATE(), N'Seed', 10);


DECLARE @ParentId INT;
SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c da';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?a r?a m?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?a r?a m?t', @ParentId, N'S?a r?a m?t', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Toner' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Toner', @ParentId, N'Toner', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Serum' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Serum', @ParentId, N'Serum', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem d??ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem d??ng', @ParentId, N'Kem d??ng', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?t n?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?t n?', @ParentId, N'M?t n?', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'T?y t? b?o ch?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?y t? b?o ch?t', @ParentId, N'T?y t? b?o ch?t', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D??ng m?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D??ng m?t', @ParentId, N'D??ng m?t', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D??ng m?i' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D??ng m?i', @ParentId, N'D??ng m?i', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Trang ?i?m';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem n?n' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem n?n', @ParentId, N'Kem n?n', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ph?n ph?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ph?n ph?', @ParentId, N'Ph?n ph?', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Son m?i' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Son m?i', @ParentId, N'Son m?i', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M? h?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M? h?ng', @ParentId, N'M? h?ng', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'K? m?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'K? m?t', @ParentId, N'K? m?t', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Mascara' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mascara', @ParentId, N'Mascara', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'K? m?y' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'K? m?y', @ParentId, N'K? m?y', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Cushion' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Cushion', @ParentId, N'Cushion', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c t?c';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D?u g?i' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D?u g?i', @ParentId, N'D?u g?i', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D?u x?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D?u x?', @ParentId, N'D?u x?', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'? t?c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'? t?c', @ParentId, N'? t?c', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Serum d??ng t?c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Serum d??ng t?c', @ParentId, N'Serum d??ng t?c', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Thu?c nhu?m' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thu?c nhu?m', @ParentId, N'Thu?c nhu?m', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?n ph?m t?o ki?u' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?n ph?m t?o ki?u', @ParentId, N'S?n ph?m t?o ki?u', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'X?t d??ng t?c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'X?t d??ng t?c', @ParentId, N'X?t d??ng t?c', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'T?y da ch?t da ??u' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?y da ch?t da ??u', @ParentId, N'T?y da ch?t da ??u', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c c? th?';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?a t?m' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?a t?m', @ParentId, N'S?a t?m', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?a d??ng th?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?a d??ng th?', @ParentId, N'S?a d??ng th?', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'T?y t? b?o ch?t body' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?y t? b?o ch?t body', @ParentId, N'T?y t? b?o ch?t body', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kh? m?i' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kh? m?i', @ParentId, N'Kh? m?i', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem tay' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem tay', @ParentId, N'Kem tay', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c ch?n' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c ch?n', @ParentId, N'Ch?m s?c ch?n', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D??ng th? ban ??m' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D??ng th? ban ??m', @ParentId, N'D??ng th? ban ??m', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Body mist' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Body mist', @ParentId, N'Body mist', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'N??c hoa';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa n?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa n?', @ParentId, N'N??c hoa n?', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa nam', @ParentId, N'N??c hoa nam', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa unisex' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa unisex', @ParentId, N'N??c hoa unisex', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa mini' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa mini', @ParentId, N'N??c hoa mini', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa t?c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa t?c', @ParentId, N'N??c hoa t?c', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Gift set' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Gift set', @ParentId, N'Gift set', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Tinh d?u th?m' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tinh d?u th?m', @ParentId, N'Tinh d?u th?m', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'X?t th?m qu?n ?o' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'X?t th?m qu?n ?o', @ParentId, N'X?t th?m qu?n ?o', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem ch?ng n?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem ch?ng n?ng', @ParentId, N'Kem ch?ng n?ng', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'X?t ch?ng n?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'X?t ch?ng n?ng', @ParentId, N'X?t ch?ng n?ng', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng body' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng body', @ParentId, N'Ch?ng n?ng body', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng n?ng t?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng n?ng t?ng', @ParentId, N'Ch?ng n?ng n?ng t?ng', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng v?t l?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng v?t l?', @ParentId, N'Ch?ng n?ng v?t l?', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng ho? h?c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng ho? h?c', @ParentId, N'Ch?ng n?ng ho? h?c', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'After sun' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'After sun', @ParentId, N'After sun', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng d?ng s?a' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng d?ng s?a', @ParentId, N'Ch?ng n?ng d?ng s?a', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c nam';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?a r?a m?t nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?a r?a m?t nam', @ParentId, N'S?a r?a m?t nam', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem d??ng nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem d??ng nam', @ParentId, N'Kem d??ng nam', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng n?ng nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng n?ng nam', @ParentId, N'Ch?ng n?ng nam', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?p vu?t t?c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?p vu?t t?c', @ParentId, N'S?p vu?t t?c', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c hoa nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c hoa nam', @ParentId, N'N??c hoa nam', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D??ng r?u' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D??ng r?u', @ParentId, N'D??ng r?u', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'L?n kh? m?i nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'L?n kh? m?i nam', @ParentId, N'L?n kh? m?i nam', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'T?m g?i nam' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?m g?i nam', @ParentId, N'T?m g?i nam', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Thi?t b? l?m ??p';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y r?a m?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y r?a m?t', @ParentId, N'M?y r?a m?t', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y n?ng c?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y n?ng c?', @ParentId, N'M?y n?ng c?', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y ??y tinh ch?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y ??y tinh ch?t', @ParentId, N'M?y ??y tinh ch?t', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y tri?t l?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y tri?t l?ng', @ParentId, N'M?y tri?t l?ng', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y x?ng m?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y x?ng m?t', @ParentId, N'M?y x?ng m?t', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y massage m?t' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y massage m?t', @ParentId, N'M?y massage m?t', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Con l?n massage' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Con l?n massage', @ParentId, N'Con l?n massage', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'G??ng trang ?i?m' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'G??ng trang ?i?m', @ParentId, N'G??ng trang ?i?m', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c m? & b?';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem ch?ng r?n' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem ch?ng r?n', @ParentId, N'Kem ch?ng r?n', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?a t?m em b?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?a t?m em b?', @ParentId, N'S?a t?m em b?', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'D?u g?i em b?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D?u g?i em b?', @ParentId, N'D?u g?i em b?', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem d??ng em b?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem d??ng em b?', @ParentId, N'Kem d??ng em b?', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?ng h?m' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?ng h?m', @ParentId, N'Ch?ng h?m', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem n?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem n?', @ParentId, N'Kem n?', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'S?a d??ng m?' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?a d??ng m?', @ParentId, N'S?a d??ng m?', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c sau sinh' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch?m s?c sau sinh', @ParentId, N'Ch?m s?c sau sinh', 1, GETDATE(), N'Seed', 8);

SELECT @ParentId = Id FROM dbo.cf_category WHERE CategoryName = N'Ch?m s?c r?ng mi?ng';
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Kem ??nh r?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kem ??nh r?ng', @ParentId, N'Kem ??nh r?ng', 1, GETDATE(), N'Seed', 1);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'B?n ch?i' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'B?n ch?i', @ParentId, N'B?n ch?i', 1, GETDATE(), N'Seed', 2);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'N??c s?c mi?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'N??c s?c mi?ng', @ParentId, N'N??c s?c mi?ng', 1, GETDATE(), N'Seed', 3);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Ch? nha khoa' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch? nha khoa', @ParentId, N'Ch? nha khoa', 1, GETDATE(), N'Seed', 4);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'M?y t?m n??c' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?y t?m n??c', @ParentId, N'M?y t?m n??c', 1, GETDATE(), N'Seed', 5);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'X?t th?m mi?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'X?t th?m mi?ng', @ParentId, N'X?t th?m mi?ng', 1, GETDATE(), N'Seed', 6);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'Mi?ng d?n tr?ng r?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mi?ng d?n tr?ng r?ng', @ParentId, N'Mi?ng d?n tr?ng r?ng', 1, GETDATE(), N'Seed', 7);
IF @ParentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_category WHERE CategoryName = N'B?t t?y tr?ng' AND ParentId = @ParentId)
    INSERT INTO dbo.cf_category (CategoryName, ParentId, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'B?t t?y tr?ng', @ParentId, N'B?t t?y tr?ng', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Beauty Story')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Beauty Story', N'Th??ng hi?u Beauty Story', 1, GETDATE(), N'Seed', 1);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Innisfree')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Innisfree', N'Th??ng hi?u Innisfree', 1, GETDATE(), N'Seed', 2);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'La Roche-Posay')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'La Roche-Posay', N'Th??ng hi?u La Roche-Posay', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'The Ordinary')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'The Ordinary', N'Th??ng hi?u The Ordinary', 1, GETDATE(), N'Seed', 4);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Bioderma')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Bioderma', N'Th??ng hi?u Bioderma', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Anessa')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Anessa', N'Th??ng hi?u Anessa', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Laneige')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Laneige', N'Th??ng hi?u Laneige', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'3CE')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'3CE', N'Th??ng hi?u 3CE', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'MAC')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'MAC', N'Th??ng hi?u MAC', 1, GETDATE(), N'Seed', 9);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Maybelline')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Maybelline', N'Th??ng hi?u Maybelline', 1, GETDATE(), N'Seed', 10);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Cetaphil')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Cetaphil', N'Th??ng hi?u Cetaphil', 1, GETDATE(), N'Seed', 11);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'CeraVe')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'CeraVe', N'Th??ng hi?u CeraVe', 1, GETDATE(), N'Seed', 12);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Kiehl''s')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Kiehl''s', N'Th??ng hi?u Kiehl''s', 1, GETDATE(), N'Seed', 13);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Hada Labo')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hada Labo', N'Th??ng hi?u Hada Labo', 1, GETDATE(), N'Seed', 14);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'L''Oreal')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'L''Oreal', N'Th??ng hi?u L''Oreal', 1, GETDATE(), N'Seed', 15);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Nivea')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nivea', N'Th??ng hi?u Nivea', 1, GETDATE(), N'Seed', 16);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Dove')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dove', N'Th??ng hi?u Dove', 1, GETDATE(), N'Seed', 17);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Vichy')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vichy', N'Th??ng hi?u Vichy', 1, GETDATE(), N'Seed', 18);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'SK-II')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'SK-II', N'Th??ng hi?u SK-II', 1, GETDATE(), N'Seed', 19);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_brand WHERE BrandName = N'Paula''s Choice')
    INSERT INTO dbo.cf_brand (BrandName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Paula''s Choice', N'Th??ng hi?u Paula''s Choice', 1, GETDATE(), N'Seed', 20);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'H?n Qu?c')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'H?n Qu?c', N'Xu?t x? H?n Qu?c', 1, GETDATE(), N'Seed', 1);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Nh?t B?n')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nh?t B?n', N'Xu?t x? Nh?t B?n', 1, GETDATE(), N'Seed', 2);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Ph?p')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ph?p', N'Xu?t x? Ph?p', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'M?')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?', N'Xu?t x? M?', 1, GETDATE(), N'Seed', 4);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Anh')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Anh', N'Xu?t x? Anh', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'??c')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??c', N'Xu?t x? ??c', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'?')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'?', N'Xu?t x? ?', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'?c')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'?c', N'Xu?t x? ?c', 1, GETDATE(), N'Seed', 8);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Th?i Lan')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Th?i Lan', N'Xu?t x? Th?i Lan', 1, GETDATE(), N'Seed', 9);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Trung Qu?c')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trung Qu?c', N'Xu?t x? Trung Qu?c', 1, GETDATE(), N'Seed', 10);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Vi?t Nam')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vi?t Nam', N'Xu?t x? Vi?t Nam', 1, GETDATE(), N'Seed', 11);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_origin WHERE OriginName = N'Canada')
    INSERT INTO dbo.cf_origin (OriginName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Canada', N'Xu?t x? Canada', 1, GETDATE(), N'Seed', 12);

DECLARE @AttrId INT;
IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung t?ch')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Dung t?ch', N'Dung t?ch', 1, GETDATE(), N'Seed', 0);
SELECT @AttrId = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Dung t?ch';
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'10ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'10ml', 1, GETDATE(), N'Seed', 1);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'20ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'20ml', 1, GETDATE(), N'Seed', 2);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'30ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'30ml', 1, GETDATE(), N'Seed', 3);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'50ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'50ml', 1, GETDATE(), N'Seed', 4);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'100ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'100ml', 1, GETDATE(), N'Seed', 5);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'150ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'150ml', 1, GETDATE(), N'Seed', 6);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'200ml')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'200ml', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'M?i h??ng')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?i h??ng', N'M?i h??ng', 1, GETDATE(), N'Seed', 0);
SELECT @AttrId = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'M?i h??ng';
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Kh?ng m?i')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Kh?ng m?i', 1, GETDATE(), N'Seed', 1);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'H??ng hoa')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'H??ng hoa', 1, GETDATE(), N'Seed', 2);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'H??ng tr?i c?y')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'H??ng tr?i c?y', 1, GETDATE(), N'Seed', 3);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'H??ng g?')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'H??ng g?', 1, GETDATE(), N'Seed', 4);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'H??ng th?o m?c')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'H??ng th?o m?c', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'Lo?i')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Lo?i', N'Lo?i', 1, GETDATE(), N'Seed', 0);
SELECT @AttrId = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'Lo?i';
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Gel')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Gel', 1, GETDATE(), N'Seed', 1);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Cream')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Cream', 1, GETDATE(), N'Seed', 2);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Lotion')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Lotion', 1, GETDATE(), N'Seed', 3);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Foam')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Foam', 1, GETDATE(), N'Seed', 4);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Oil')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Oil', 1, GETDATE(), N'Seed', 5);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Mist')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Mist', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'M?u s?c')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M?u s?c', N'M?u s?c', 1, GETDATE(), N'Seed', 0);
SELECT @AttrId = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'M?u s?c';
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Tr?ng')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Tr?ng', 1, GETDATE(), N'Seed', 1);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'H?ng')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'H?ng', 1, GETDATE(), N'Seed', 2);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'??')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'??', 1, GETDATE(), N'Seed', 3);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Nude')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Nude', 1, GETDATE(), N'Seed', 4);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'Cam')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'Cam', 1, GETDATE(), N'Seed', 5);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'N?u')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'N?u', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute WHERE AttributeName = N'K?t c?u')
    INSERT INTO dbo.cf_variant_attribute (AttributeName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'K?t c?u', N'K?t c?u', 1, GETDATE(), N'Seed', 0);
SELECT @AttrId = Id FROM dbo.cf_variant_attribute WHERE AttributeName = N'K?t c?u';
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'M?ng nh?')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'M?ng nh?', 1, GETDATE(), N'Seed', 1);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'??c')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'??c', 1, GETDATE(), N'Seed', 2);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'D?ng n??c')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'D?ng n??c', 1, GETDATE(), N'Seed', 3);
IF @AttrId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_variant_attribute_value WHERE AttributeId = @AttrId AND ValueName = N'D?ng s?p')
    INSERT INTO dbo.cf_variant_attribute_value (AttributeId, ValueName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@AttrId, N'D?ng s?p', 1, GETDATE(), N'Seed', 4);

DECLARE @GroupId INT;
IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'D?ng s?n ph?m')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D?ng s?n ph?m', N'D?ng s?n ph?m', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'D?ng s?n ph?m';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Hydrating')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Hydrating', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Brightening')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Brightening', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Anti-Aging')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Anti-Aging', 1, GETDATE(), N'Seed', 3);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Acne Care')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Acne Care', 1, GETDATE(), N'Seed', 4);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Sensitive Care')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Sensitive Care', 1, GETDATE(), N'Seed', 5);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Whitening')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Whitening', 1, GETDATE(), N'Seed', 6);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Repair')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Repair', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'V?n ?? da')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'V?n ?? da', N'V?n ?? da', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'V?n ?? da';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'M?n')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'M?n', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Th?m')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Th?m', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'N?m')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'N?m', 1, GETDATE(), N'Seed', 3);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'L?o h?a')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'L?o h?a', 1, GETDATE(), N'Seed', 4);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'L? ch?n l?ng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'L? ch?n l?ng', 1, GETDATE(), N'Seed', 5);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Kh? r?p')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Kh? r?p', 1, GETDATE(), N'Seed', 6);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'?? r?t')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'?? r?t', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Th?nh ph?n n?i b?t')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Th?nh ph?n n?i b?t', N'Th?nh ph?n n?i b?t', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Th?nh ph?n n?i b?t';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Niacinamide')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Niacinamide', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Hyaluronic Acid')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Hyaluronic Acid', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Vitamin C')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Vitamin C', 1, GETDATE(), N'Seed', 3);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Retinol')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Retinol', 1, GETDATE(), N'Seed', 4);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'AHA/BHA')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'AHA/BHA', 1, GETDATE(), N'Seed', 5);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Ceramide')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Ceramide', 1, GETDATE(), N'Seed', 6);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Peptide')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Peptide', 1, GETDATE(), N'Seed', 7);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Lo?i da')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Lo?i da', N'Lo?i da', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Lo?i da';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Da d?u')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Da d?u', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Da kh?')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Da kh?', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Da h?n h?p')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Da h?n h?p', 1, GETDATE(), N'Seed', 3);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Da nh?y c?m')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Da nh?y c?m', 1, GETDATE(), N'Seed', 4);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Da th??ng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Da th??ng', 1, GETDATE(), N'Seed', 5);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'C?ng d?ng ch?nh')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'C?ng d?ng ch?nh', N'C?ng d?ng ch?nh', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'C?ng d?ng ch?nh';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'C?p ?m')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'C?p ?m', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'L?m s?ng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'L?m s?ng', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Gi?m m?n')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Gi?m m?n', 1, GETDATE(), N'Seed', 3);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Ph?c h?i')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Ph?c h?i', 1, GETDATE(), N'Seed', 4);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Ch?ng l?o ho?')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Ch?ng l?o ho?', 1, GETDATE(), N'Seed', 5);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Ch?ng n?ng')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Ch?ng n?ng', 1, GETDATE(), N'Seed', 6);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'Gi?i t?nh')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Gi?i t?nh', N'Gi?i t?nh', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'Gi?i t?nh';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Nam')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Nam', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'N?')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'N?', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Unisex')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Unisex', 1, GETDATE(), N'Seed', 3);

IF NOT EXISTS (SELECT 1 FROM dbo.cf_filter_group WHERE GroupName = N'??c t?nh')
    INSERT INTO dbo.cf_filter_group (GroupName, Description, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??c t?nh', N'??c t?nh', 1, GETDATE(), N'Seed', 0);
SELECT @GroupId = Id FROM dbo.cf_filter_group WHERE GroupName = N'??c t?nh';
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Thu?n chay')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Thu?n chay', 1, GETDATE(), N'Seed', 1);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Kh?ng paraben')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Kh?ng paraben', 1, GETDATE(), N'Seed', 2);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Kh?ng c?n')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Kh?ng c?n', 1, GETDATE(), N'Seed', 3);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Kh?ng h??ng li?u')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Kh?ng h??ng li?u', 1, GETDATE(), N'Seed', 4);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'D?u nh?')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'D?u nh?', 1, GETDATE(), N'Seed', 5);
IF @GroupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.cf_filter_option WHERE GroupId = @GroupId AND OptionName = N'Kh?ng d?u')
    INSERT INTO dbo.cf_filter_option (GroupId, OptionName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (@GroupId, N'Kh?ng d?u', 1, GETDATE(), N'Seed', 6);

DECLARE @CatId INT;
DECLARE cat_cursor CURSOR FOR SELECT Id FROM dbo.cf_category WHERE ParentId IS NULL;
OPEN cat_cursor;
FETCH NEXT FROM cat_cursor INTO @CatId;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE grp_cursor CURSOR FOR SELECT Id FROM dbo.cf_filter_group;
    OPEN grp_cursor;
    FETCH NEXT FROM grp_cursor INTO @GroupId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.cf_category_filter_group WHERE CategoryId = @CatId AND GroupId = @GroupId)
            INSERT INTO dbo.cf_category_filter_group (CategoryId, GroupId, Status, CreatedAt, CreatedBy, SortOrder)
            VALUES (@CatId, @GroupId, 1, GETDATE(), N'Seed', 0);
        FETCH NEXT FROM grp_cursor INTO @GroupId;
    END
    CLOSE grp_cursor;
    DEALLOCATE grp_cursor;
    FETCH NEXT FROM cat_cursor INTO @CatId;
END
CLOSE cat_cursor;
DEALLOCATE cat_cursor;
GO