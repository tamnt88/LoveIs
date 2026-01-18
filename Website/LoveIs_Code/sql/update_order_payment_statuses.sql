USE LoveIsDB;
GO

-- Order status standardization (keep old rows, add missing, disable obsolete)
IF EXISTS (SELECT 1 FROM dbo.cf_order_status)
BEGIN
    -- Update known codes
    UPDATE dbo.cf_order_status
    SET Name = N'Đơn mới', Description = N'Đơn hàng vừa tạo', Status = 1
    WHERE Code = N'NEW';

    UPDATE dbo.cf_order_status
    SET Name = N'Đã xác nhận', Description = N'Nhà bán hàng đã xác nhận', Status = 1
    WHERE Code = N'CONFIRMED';

    UPDATE dbo.cf_order_status
    SET Name = N'Hoàn tất', Description = N'Đơn hàng hoàn tất', Status = 1
    WHERE Code = N'COMPLETED';

    UPDATE dbo.cf_order_status
    SET Name = N'Đã hủy', Description = N'Đơn hàng đã hủy', Status = 1
    WHERE Code IN (N'CANCELLED', N'CANCELED');

    -- Disable legacy SHIPPING if present
    UPDATE dbo.cf_order_status
    SET Status = 0
    WHERE Code = N'SHIPPING';
END
GO

-- Insert missing order statuses
IF NOT EXISTS (SELECT 1 FROM dbo.cf_order_status WHERE Code = N'PACKING')
BEGIN
    INSERT INTO dbo.cf_order_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'PACKING', N'Đang đóng gói', N'Đang chuẩn bị hàng', 0, 1, GETDATE(), N'Seed', 3);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_order_status WHERE Code = N'READY_TO_SHIP')
BEGIN
    INSERT INTO dbo.cf_order_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'READY_TO_SHIP', N'Sẵn sàng giao', N'Đã đóng gói, chờ bàn giao', 0, 1, GETDATE(), N'Seed', 4);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_order_status WHERE Code = N'SHIPPED')
BEGIN
    INSERT INTO dbo.cf_order_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'SHIPPED', N'Đã bàn giao', N'Đã bàn giao cho đơn vị vận chuyển', 0, 1, GETDATE(), N'Seed', 5);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_order_status WHERE Code = N'DELIVERING')
BEGIN
    INSERT INTO dbo.cf_order_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'DELIVERING', N'Đang giao', N'Đang vận chuyển tới khách hàng', 0, 1, GETDATE(), N'Seed', 6);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_order_status WHERE Code = N'DELIVERED')
BEGIN
    INSERT INTO dbo.cf_order_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'DELIVERED', N'Đã giao', N'Đã giao cho khách hàng', 0, 1, GETDATE(), N'Seed', 7);
END
GO

-- Ensure NEW is default
UPDATE dbo.cf_order_status SET IsDefault = 0 WHERE IsDefault = 1;
UPDATE dbo.cf_order_status SET IsDefault = 1 WHERE Code = N'NEW';
GO

-- Payment status standardization
IF EXISTS (SELECT 1 FROM dbo.cf_payment_status)
BEGIN
    -- Disable legacy PENDING if present
    UPDATE dbo.cf_payment_status SET Status = 0 WHERE Code = N'PENDING';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_status WHERE Code = N'UNPAID')
BEGIN
    INSERT INTO dbo.cf_payment_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'UNPAID', N'Chưa thanh toán', N'Chưa thanh toán', 1, 1, GETDATE(), N'Seed', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_status WHERE Code = N'PAID')
BEGIN
    INSERT INTO dbo.cf_payment_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'PAID', N'Đã thanh toán', N'Đã thanh toán', 0, 1, GETDATE(), N'Seed', 2);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_status WHERE Code = N'REFUND_PENDING')
BEGIN
    INSERT INTO dbo.cf_payment_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'REFUND_PENDING', N'Chờ hoàn tiền', N'Yêu cầu hoàn tiền', 0, 1, GETDATE(), N'Seed', 3);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_status WHERE Code = N'REFUNDED')
BEGIN
    INSERT INTO dbo.cf_payment_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'REFUNDED', N'Đã hoàn tiền', N'Hoàn tiền thành công', 0, 1, GETDATE(), N'Seed', 4);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cf_payment_status WHERE Code = N'FAILED')
BEGIN
    INSERT INTO dbo.cf_payment_status (Code, Name, Description, IsDefault, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'FAILED', N'Thanh toán thất bại', N'Thanh toán thất bại', 0, 1, GETDATE(), N'Seed', 5);
END
GO
