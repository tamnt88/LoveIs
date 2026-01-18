SET NOCOUNT ON;

DECLARE @ShopId INT = 1;

DECLARE @Products TABLE (Id INT, Name NVARCHAR(200));
INSERT INTO @Products (Id, Name)
VALUES
(21233, N'Corset định hình eo Nhẹ nhàng - LoveIs Grace 1233'),
(21234, N'Corset định hình eo Nhẹ nhàng - LoveIs Grace 1234'),
(21235, N'Corset định hình eo Nhẹ nhàng - LoveIs Grace 1235'),
(21236, N'Corset định hình eo Nhẹ nhàng - LoveIs Grace 1236'),
(21237, N'Corset định hình eo Nhẹ nhàng - LoveIs Grace 1237');

DECLARE @Statuses TABLE (Code NVARCHAR(20), Name NVARCHAR(50));
INSERT INTO @Statuses (Code, Name)
VALUES
(N'NEW', N'Đặt hàng'),
(N'CONFIRMED', N'Xác nhận'),
(N'SHIPPING', N'Đang giao'),
(N'COMPLETED', N'Hoàn tất'),
(N'CANCELLED', N'Đã hủy');

DECLARE @i INT = 1;

WHILE @i <= 12
BEGIN
    DECLARE @StatusCode NVARCHAR(20) = (SELECT Code FROM @Statuses WHERE Code = CASE 
        WHEN @i IN (1,2) THEN N'NEW'
        WHEN @i IN (3,4) THEN N'CONFIRMED'
        WHEN @i IN (5,6,7) THEN N'SHIPPING'
        WHEN @i IN (8,9,10) THEN N'COMPLETED'
        ELSE N'CANCELLED' END);

    DECLARE @StatusName NVARCHAR(50) = (SELECT Name FROM @Statuses WHERE Code = @StatusCode);

    DECLARE @CustomerName NVARCHAR(100) = N'Khách ' + CAST(@i AS NVARCHAR(10));
    DECLARE @OrderCode NVARCHAR(50) = N'DH' + FORMAT(GETDATE(), 'yyMMdd') + RIGHT('000' + CAST(@i AS NVARCHAR(10)), 3);

    DECLARE @Subtotal DECIMAL(18,2) = 0;
    DECLARE @Total DECIMAL(18,2) = 0;

    INSERT INTO cf_order
    (OrderCode, CustomerName, Phone, AddressLine, WardName, ProvinceName,
     ShippingMethod, ShippingFee, PaymentMethod, PaymentStatus, OrderStatus,
     Subtotal, Discount, Total, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (@OrderCode, @CustomerName, N'090000000' + RIGHT('0' + CAST(@i AS NVARCHAR(2)), 2),
     N'1 Đường Test', N'Phường 1', N'Hồ Chí Minh',
     N'Giao nhanh', 0, N'COD', N'COD', @StatusName,
     0, 0, 0, 1, DATEADD(MINUTE, -@i*15, GETDATE()), N'Seed', 0);

    DECLARE @OrderId INT = SCOPE_IDENTITY();

    -- 2 items mỗi đơn
    DECLARE @p1 INT = (SELECT TOP 1 Id FROM @Products ORDER BY NEWID());
    DECLARE @p2 INT = (SELECT TOP 1 Id FROM @Products ORDER BY NEWID());

    INSERT INTO cf_order_item
    (OrderId, ProductId, VariantId, ProductName, VariantName, Quantity, Price, SalePrice, LineTotal, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @OrderId, Id, 0, Name, N'Màu: Đen | Size: M', 1, 180000, NULL, 180000, 1, GETDATE(), N'Seed', 0
    FROM @Products WHERE Id = @p1;

    INSERT INTO cf_order_item
    (OrderId, ProductId, VariantId, ProductName, VariantName, Quantity, Price, SalePrice, LineTotal, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT @OrderId, Id, 0, Name, N'Màu: Nude | Size: L', 2, 160000, NULL, 320000, 1, GETDATE(), N'Seed', 0
    FROM @Products WHERE Id = @p2;

    SELECT @Subtotal = SUM(LineTotal) FROM cf_order_item WHERE OrderId = @OrderId;
    SET @Total = @Subtotal;

    UPDATE cf_order
    SET Subtotal = @Subtotal,
        Total = @Total
    WHERE Id = @OrderId;

    INSERT INTO cf_shop_order
    (OrderId, ShopId, ShippingMethod, ShippingFee, PaymentStatus, OrderStatus,
     Subtotal, Discount, Total, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (@OrderId, @ShopId, N'Giao nhanh', 0, N'COD', @StatusCode,
     @Subtotal, 0, @Total, 1, GETDATE(), N'Seed', 0);

    DECLARE @ShopOrderId INT = SCOPE_IDENTITY();

    INSERT INTO cf_shipping_tracking
    (ShopOrderId, Carrier, TrackingCode, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (@ShopOrderId, N'GHN', N'GHN' + RIGHT('0000000000' + CAST(@OrderId AS NVARCHAR(10)), 10), @StatusCode, GETDATE(), N'Seed', 0);

    SET @i += 1;
END
