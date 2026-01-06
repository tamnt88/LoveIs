SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @Now DATETIME = GETDATE();
    DECLARE @SeedBy NVARCHAR(100) = N'Seed';

    DECLARE @Adjectives TABLE (Value NVARCHAR(100));
    INSERT INTO @Adjectives (Value)
    VALUES
        (N'Thanh lịch'),
        (N'Quyến rũ'),
        (N'Tinh tế'),
        (N'Tối giản'),
        (N'Cao cấp'),
        (N'Mềm mại'),
        (N'Thoáng khí'),
        (N'Nhẹ nhàng'),
        (N'Gợi cảm'),
        (N'Thiết kế ôm dáng'),
        (N'Hiện đại'),
        (N'Trẻ trung');

    DECLARE @Collections TABLE (Value NVARCHAR(100));
    INSERT INTO @Collections (Value)
    VALUES
        (N'LoveIs Classic'),
        (N'LoveIs Grace'),
        (N'LoveIs Air'),
        (N'LoveIs Soft'),
        (N'LoveIs Lux'),
        (N'LoveIs Muse'),
        (N'LoveIs Satin'),
        (N'LoveIs Lace');

    DECLARE @Materials TABLE (Value NVARCHAR(100));
    INSERT INTO @Materials (Value)
    VALUES
        (N'cotton'),
        (N'ren'),
        (N'lụa'),
        (N'satin'),
        (N'microfiber'),
        (N'lưới');

    DECLARE @Care TABLE (Value NVARCHAR(200));
    INSERT INTO @Care (Value)
    VALUES
        (N'Giặt tay với nước mát, phơi nơi thoáng mát.'),
        (N'Giặt máy chế độ nhẹ, tránh sấy nhiệt cao.'),
        (N'Không dùng chất tẩy mạnh, ủi nhiệt thấp.'),
        (N'Giặt riêng đồ sáng màu, tránh kéo giãn.'),
        (N'Khuyến nghị dùng túi giặt đồ lót.');

    ;WITH Products AS (
        SELECT p.Id, p.CategoryId, c.CategoryName,
               p.ProductName
        FROM dbo.cf_product p
        JOIN dbo.cf_category c ON c.Id = p.CategoryId
    )
    UPDATE p
    SET p.ProductName = c.CategoryName + N' ' + adj.Value + N' - ' + col.Value + N' ' + RIGHT(N'0000' + CAST(p.Id AS NVARCHAR(10)), 4),
        p.ShortDescription = adj.Value + N' với chất liệu ' + mat.Value + N', ôm vừa vặn và tôn dáng.',
        p.Description = N'<p>' + adj.Value + N' dành cho cảm giác tự tin mỗi ngày. Thiết kế chú trọng độ nâng đỡ, thoáng khí và đường may mịn.</p>'
                      + N'<ul><li>Chất liệu: ' + mat.Value + N'</li>'
                      + N'<li>Độ co giãn tốt, form ôm vừa vặn</li>'
                      + N'<li>Phù hợp mặc hằng ngày hoặc dịp đặc biệt</li></ul>'
                      + N'<p>Phối hợp tinh tế giữa tính thẩm mỹ và sự thoải mái.</p>',
        p.Specification = N'<ul><li>Form: ôm dáng</li><li>Độ co giãn: tốt</li><li>Đường may: mịn</li></ul>',
        p.Ingredients = N'Chất liệu chính: ' + mat.Value,
        p.Usage = care.Value,
        p.SeoTitle = c.CategoryName + N' ' + adj.Value,
        p.SeoDescription = c.CategoryName + N' ' + adj.Value + N' thuộc bộ sưu tập ' + col.Value + N'.',
        p.SeoKeywords = c.CategoryName + N', ' + adj.Value + N', ' + mat.Value,
        p.UpdatedAt = @Now,
        p.UpdatedBy = @SeedBy
    FROM dbo.cf_product p
    JOIN Products c ON c.Id = p.Id
    CROSS APPLY (SELECT TOP 1 Value FROM @Adjectives ORDER BY NEWID()) adj
    CROSS APPLY (SELECT TOP 1 Value FROM @Collections ORDER BY NEWID()) col
    CROSS APPLY (SELECT TOP 1 Value FROM @Materials ORDER BY NEWID()) mat
    CROSS APPLY (SELECT TOP 1 Value FROM @Care ORDER BY NEWID()) care;

    ;WITH RankedImages AS (
        SELECT i.Id, i.ProductId,
               ROW_NUMBER() OVER (PARTITION BY i.ProductId ORDER BY NEWID()) AS rn
        FROM dbo.cf_product_image i
    )
    UPDATE i
    SET i.IsPrimary = CASE WHEN r.rn = 1 THEN 1 ELSE 0 END
    FROM dbo.cf_product_image i
    JOIN RankedImages r ON r.Id = i.Id;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
