SET NOCOUNT ON;

DECLARE @ShopId INT = 1;

DECLARE @Statuses TABLE (Code NVARCHAR(50));
INSERT INTO @Statuses (Code)
VALUES (N'PENDING'), (N'APPROVED'), (N'REJECTED'), (N'PICKUP'), (N'RETURNED'), (N'REFUNDED'), (N'CLOSED');

DECLARE @ReturnCount INT = 12;
DECLARE @i INT = 1;

DECLARE @Orders TABLE (OrderId INT);
INSERT INTO @Orders (OrderId)
SELECT TOP (@ReturnCount) so.OrderId
FROM dbo.cf_shop_order so
WHERE so.ShopId = @ShopId AND so.Status = 1
ORDER BY so.CreatedAt DESC;

WHILE @i <= @ReturnCount
BEGIN
    DECLARE @OrderId INT = (SELECT OrderId FROM @Orders ORDER BY OrderId OFFSET (@i - 1) ROWS FETCH NEXT 1 ROWS ONLY);
    IF @OrderId IS NULL BREAK;

    DECLARE @StatusCode NVARCHAR(50) =
        (SELECT Code FROM @Statuses ORDER BY Code OFFSET ((@i - 1) % 7) ROWS FETCH NEXT 1 ROWS ONLY);

    INSERT INTO dbo.cf_return_request
    (OrderId, ShopId, Reason, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
    (@OrderId, @ShopId, N'Khách yêu cầu đổi trả', @StatusCode, DATEADD(DAY, -@i, GETDATE()), N'Seed', 0);

    DECLARE @ReturnRequestId INT = SCOPE_IDENTITY();

    DECLARE @OrderItemId INT = (
        SELECT TOP 1 oi.Id
        FROM dbo.cf_order_item oi
        WHERE oi.OrderId = @OrderId
        ORDER BY oi.Id
    );

    IF @OrderItemId IS NOT NULL
    BEGIN
        INSERT INTO dbo.cf_return_item
        (ReturnRequestId, OrderItemId, Quantity, Status, CreatedAt, CreatedBy, SortOrder)
        VALUES
        (@ReturnRequestId, @OrderItemId, 1, 1, GETDATE(), N'Seed', 0);
    END

    SET @i += 1;
END
