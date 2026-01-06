SET NOCOUNT ON;

DECLARE @Level2Names TABLE (Name NVARCHAR(200));
INSERT INTO @Level2Names (Name)
VALUES
    (N'Sữa rửa mặt'),
    (N'Toner/Nước cân bằng'),
    (N'Serum'),
    (N'Kem dưỡng'),
    (N'Mặt nạ'),
    (N'Tẩy tế bào chết'),
    (N'Chống nắng'),
    (N'Chăm sóc mắt'),
    (N'Chăm sóc môi'),
    (N'Chăm sóc tóc'),
    (N'Chăm sóc cơ thể'),
    (N'Trang điểm'),
    (N'Nước hoa'),
    (N'Phụ kiện làm đẹp'),
    (N'Dưỡng tay'),
    (N'Dưỡng chân'),
    (N'Tẩy trang'),
    (N'Mỹ phẩm nam'),
    (N'Mỹ phẩm mẹ & bé'),
    (N'Thiết bị làm đẹp'),
    (N'Sữa tắm'),
    (N'Dầu gội'),
    (N'Dầu xả'),
    (N'Ủ tóc'),
    (N'Tinh dầu dưỡng tóc'),
    (N'Serum tóc'),
    (N'Xịt dưỡng tóc'),
    (N'Set dưỡng da'),
    (N'Set trang điểm'),
    (N'Set chăm sóc tóc'),
    (N'Set cơ thể'),
    (N'Tinh chất đặc trị'),
    (N'Xịt khoáng'),
    (N'Kem chống nắng nâng tông'),
    (N'Kem chống nắng body'),
    (N'Sữa chống nắng'),
    (N'Xịt chống nắng'),
    (N'Kem nền'),
    (N'Phấn phủ'),
    (N'Phấn má'),
    (N'Mascara'),
    (N'Kẻ mắt'),
    (N'Chì kẻ mày'),
    (N'Son môi'),
    (N'Bảng phấn mắt'),
    (N'Khử mùi'),
    (N'Dưỡng thể'),
    (N'Tẩy tế bào chết body'),
    (N'Chăm sóc tay'),
    (N'Chăm sóc chân'),
    (N'Dưỡng môi'),
    (N'Kem mắt'),
    (N'Tẩy lông'),
    (N'Chăm sóc răng miệng'),
    (N'Nước súc miệng'),
    (N'Chăm sóc móng'),
    (N'Chăm sóc vùng kín'),
    (N'Chăm sóc bà bầu'),
    (N'Chăm sóc em bé'),
    (N'Chăm sóc da cho bé'),
    (N'Khăn ướt'),
    (N'Bông tẩy trang'),
    (N'Cọ trang điểm'),
    (N'Mút trang điểm'),
    (N'Băng đô & kẹp tóc'),
    (N'Nước hoa nữ'),
    (N'Nước hoa nam'),
    (N'Nước hoa unisex'),
    (N'Xịt thơm body'),
    (N'Set quà nước hoa'),
    (N'Collagen'),
    (N'Vitamin tổng hợp'),
    (N'Viên uống đẹp da'),
    (N'Hỗ trợ tóc móng'),
    (N'Hỗ trợ giấc ngủ'),
    (N'Chăm sóc nam'),
    (N'Tắm gội nam'),
    (N'Tạo kiểu tóc nam'),
    (N'Lăn khử mùi nam'),
    (N'Chăm sóc da mặt nam'),
    (N'Chăm sóc cơ thể nam'),
    (N'Máy rửa mặt'),
    (N'Máy đẩy tinh chất'),
    (N'Máy massage'),
    (N'Máy triệt lông'),
    (N'Máy sấy tóc'),
    (N'Máy uốn tóc'),
    (N'Máy tăm nước'),
    (N'Máy chăm sóc da'),
    (N'Thiết bị spa tại nhà'),
    (N'Chăm sóc sức khỏe'),
    (N'Thực phẩm bổ sung'),
    (N'Giảm cân'),
    (N'Tăng cường sức đề kháng'),
    (N'Thực phẩm cho mẹ & bé'),
    (N'Bộ quà tặng');

DECLARE @Level3Names TABLE (Name NVARCHAR(200));
INSERT INTO @Level3Names (Name)
VALUES
    (N'Da dầu'),
    (N'Da khô'),
    (N'Da nhạy cảm'),
    (N'Da hỗn hợp'),
    (N'Phục hồi da'),
    (N'Giảm mụn'),
    (N'Làm sáng da'),
    (N'Dưỡng ẩm sâu'),
    (N'Trị thâm'),
    (N'Chống lão hóa'),
    (N'Kiềm dầu'),
    (N'Ngừa mụn'),
    (N'Dưỡng trắng'),
    (N'Tẩy tế bào chết hóa học'),
    (N'Tẩy tế bào chết vật lý'),
    (N'Kem chống nắng vật lý'),
    (N'Kem chống nắng hóa học'),
    (N'Chống nắng nâng tông'),
    (N'Xịt khoáng'),
    (N'Kem nền'),
    (N'Phấn phủ'),
    (N'Son môi'),
    (N'Mascara'),
    (N'Kẻ mắt'),
    (N'Má hồng'),
    (N'Khử mùi'),
    (N'Dưỡng thể'),
    (N'Sữa tắm'),
    (N'Dầu gội'),
    (N'Dầu xả'),
    (N'Tóc dầu'),
    (N'Tóc khô xơ'),
    (N'Tóc hư tổn'),
    (N'Tóc nhuộm'),
    (N'Chống rụng tóc'),
    (N'Kích thích mọc tóc'),
    (N'Dưỡng dài mi'),
    (N'Dưỡng mày'),
    (N'Loại da dầu mụn'),
    (N'Loại da hỗn hợp thiên dầu'),
    (N'Loại da hỗn hợp thiên khô'),
    (N'Loại da lão hóa'),
    (N'Loại da thường'),
    (N'Trẻ hóa da'),
    (N'Giảm nám'),
    (N'Giảm tàn nhang'),
    (N'Giảm đỏ'),
    (N'Chống kích ứng'),
    (N'Dịu nhẹ'),
    (N'Không hương liệu'),
    (N'Không cồn'),
    (N'Không paraben'),
    (N'Kiểm soát dầu'),
    (N'Giữ ẩm'),
    (N'Dưỡng sáng'),
    (N'Cấp nước'),
    (N'Chống nắng SPF30'),
    (N'Chống nắng SPF50+'),
    (N'Chống nắng PA+++'),
    (N'Chống nắng PA++++'),
    (N'Lâu trôi'),
    (N'Mềm mịn'),
    (N'Mịn lì'),
    (N'Bóng khỏe'),
    (N'Tự nhiên'),
    (N'Che phủ nhẹ'),
    (N'Che phủ trung bình'),
    (N'Che phủ cao'),
    (N'Chống thấm nước'),
    (N'Kiềm dầu lâu'),
    (N'Tông ấm'),
    (N'Tông lạnh'),
    (N'Tông trung tính'),
    (N'Cam đất'),
    (N'Hồng đất'),
    (N'Đỏ gạch'),
    (N'Đỏ rượu'),
    (N'Be'),
    (N'Trắng sáng'),
    (N'Nude'),
    (N'Trẻ em'),
    (N'Mẹ bầu'),
    (N'Nam'),
    (N'Nữ'),
    (N'Unisex'),
    (N'Hương hoa'),
    (N'Hương gỗ'),
    (N'Hương trái cây'),
    (N'Hương cam chanh'),
    (N'Hương vani'),
    (N'Hương phấn'),
    (N'Hương thảo mộc'),
    (N'Hương biển'),
    (N'Hương ấm'),
    (N'Hương mát'),
    (N'Hương ngọt'),
    (N'Hỗ trợ ngủ ngon'),
    (N'Hỗ trợ tiêu hóa'),
    (N'Hỗ trợ miễn dịch'),
    (N'Hỗ trợ xương khớp'),
    (N'Hỗ trợ tim mạch'),
    (N'Hỗ trợ đẹp da'),
    (N'Hỗ trợ tóc móng'),
    (N'Thải độc'),
    (N'Giảm cân'),
    (N'Tăng cân'),
    (N'Bổ sung collagen'),
    (N'Bổ sung vitamin C'),
    (N'Bổ sung vitamin D'),
    (N'Bổ sung biotin'),
    (N'Bổ sung kẽm'),
    (N'Bổ sung omega 3'),
    (N'Bổ sung probiotic');

DECLARE @ParentId INT;
DECLARE @Level2Id INT;
DECLARE @Count2 INT;
DECLARE @Count3 INT;

DECLARE ParentCursor CURSOR FOR
SELECT Id
FROM dbo.cf_category
WHERE ParentId IS NULL;

OPEN ParentCursor;
FETCH NEXT FROM ParentCursor INTO @ParentId;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count2 = 6 + ABS(CHECKSUM(NEWID())) % 7;

    INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT TOP (@Count2)
        n.Name,
        @ParentId,
        1,
        GETDATE(),
        N'Seed',
        ROW_NUMBER() OVER (ORDER BY NEWID())
    FROM @Level2Names n
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.cf_category c
        WHERE c.ParentId = @ParentId AND c.CategoryName = n.Name
    )
    ORDER BY NEWID();

    DECLARE Level2Cursor CURSOR FOR
    SELECT Id
    FROM dbo.cf_category
    WHERE ParentId = @ParentId;

    OPEN Level2Cursor;
    FETCH NEXT FROM Level2Cursor INTO @Level2Id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Count3 = ABS(CHECKSUM(NEWID())) % 11;

        IF @Count3 > 0
        BEGIN
            INSERT INTO dbo.cf_category (CategoryName, ParentId, Status, CreatedAt, CreatedBy, SortOrder)
            SELECT TOP (@Count3)
                n.Name,
                @Level2Id,
                1,
                GETDATE(),
                N'Seed',
                ROW_NUMBER() OVER (ORDER BY NEWID())
            FROM @Level3Names n
            WHERE NOT EXISTS (
                SELECT 1 FROM dbo.cf_category c
                WHERE c.ParentId = @Level2Id AND c.CategoryName = n.Name
            )
            ORDER BY NEWID();
        END

        FETCH NEXT FROM Level2Cursor INTO @Level2Id;
    END

    CLOSE Level2Cursor;
    DEALLOCATE Level2Cursor;

    FETCH NEXT FROM ParentCursor INTO @ParentId;
END

CLOSE ParentCursor;
DEALLOCATE ParentCursor;
