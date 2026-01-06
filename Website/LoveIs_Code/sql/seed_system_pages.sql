IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_page WHERE PageKey = N'home')
BEGIN
    INSERT INTO dbo.cf_system_page (PageKey, PageName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'home', N'Trang chủ', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_page WHERE PageKey = N'contact')
BEGIN
    INSERT INTO dbo.cf_system_page (PageKey, PageName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'contact', N'Liên hệ', 1, GETDATE(), N'Seed', 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_page WHERE PageKey = N'cart')
BEGIN
    INSERT INTO dbo.cf_system_page (PageKey, PageName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'cart', N'Giỏ hàng', 1, GETDATE(), N'Seed', 3);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_page WHERE PageKey = N'checkout')
BEGIN
    INSERT INTO dbo.cf_system_page (PageKey, PageName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'checkout', N'Thanh toán', 1, GETDATE(), N'Seed', 4);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_page WHERE PageKey = N'order-tracking')
BEGIN
    INSERT INTO dbo.cf_system_page (PageKey, PageName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'order-tracking', N'Tra cứu đơn hàng', 1, GETDATE(), N'Seed', 5);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_system_page WHERE PageKey = N'search')
BEGIN
    INSERT INTO dbo.cf_system_page (PageKey, PageName, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'search', N'Tìm kiếm', 1, GETDATE(), N'Seed', 6);
END
