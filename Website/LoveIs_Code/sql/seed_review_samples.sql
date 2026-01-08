USE LoveIsDB;
GO

DECLARE @ProductCount INT = (SELECT COUNT(*) FROM dbo.cf_product);
DECLARE @CustomerCount INT = (SELECT COUNT(*) FROM dbo.cf_customer);
DECLARE @ShopCount INT = (SELECT COUNT(*) FROM dbo.cf_shop);

IF @ProductCount = 0 OR @CustomerCount = 0
BEGIN
    PRINT 'Không đủ dữ liệu sản phẩm hoặc khách hàng để seed cf_product_review.';
END
ELSE
BEGIN
    ;WITH N AS (
        SELECT TOP (12) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.objects
    ),
    P AS (
        SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS rn
        FROM dbo.cf_product
    ),
    C AS (
        SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS rn
        FROM dbo.cf_customer
    )
    INSERT INTO dbo.cf_product_review
        (ProductId, CustomerId, Rating, Content, ImageUrls, HelpfulCount, ReplyContent, ReplyAt, IsVerified, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT
        P.Id,
        C.Id,
        CASE WHEN N.n % 5 = 0 THEN 4 ELSE 5 END AS Rating,
        CASE N.n
            WHEN 1 THEN N'Sản phẩm chất lượng tốt, đóng gói cẩn thận.'
            WHEN 2 THEN N'Giao hàng nhanh, đúng mô tả.'
            WHEN 3 THEN N'Đáng tiền, sẽ ủng hộ lần sau.'
            WHEN 4 THEN N'Sản phẩm đẹp, dùng rất ổn.'
            WHEN 5 THEN N'Chất lượng ổn, shop phục vụ tốt.'
            ELSE N'Hài lòng với sản phẩm.'
        END AS Content,
        CASE WHEN N.n % 3 = 0 THEN N'https://placehold.co/120x120/png;https://placehold.co/120x120/png' ELSE NULL END AS ImageUrls,
        (N.n * 2) AS HelpfulCount,
        CASE WHEN N.n % 2 = 0 THEN N'Cảm ơn bạn đã đánh giá sản phẩm!' ELSE NULL END AS ReplyContent,
        CASE WHEN N.n % 2 = 0 THEN DATEADD(DAY, -N.n + 1, GETDATE()) ELSE NULL END AS ReplyAt,
        1,
        1,
        DATEADD(DAY, -N.n, GETDATE()),
        N'seed',
        N.n
    FROM N
    JOIN P ON P.rn = ((N.n - 1) % @ProductCount) + 1
    JOIN C ON C.rn = ((N.n - 1) % @CustomerCount) + 1;
END

IF @ShopCount = 0 OR @CustomerCount = 0
BEGIN
    PRINT 'Không đủ dữ liệu shop hoặc khách hàng để seed cf_shop_review.';
END
ELSE
BEGIN
    ;WITH N AS (
        SELECT TOP (12) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.objects
    ),
    S AS (
        SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS rn
        FROM dbo.cf_shop
    ),
    C AS (
        SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS rn
        FROM dbo.cf_customer
    )
    INSERT INTO dbo.cf_shop_review
        (ShopId, CustomerId, Rating, Content, QualityRating, DescriptionRating, ShippingRating, ServiceRating, HelpfulCount, ReplyContent, ReplyAt, IsVerified, Status, CreatedAt, CreatedBy, SortOrder)
    SELECT
        S.Id,
        C.Id,
        5,
        CASE N.n
            WHEN 1 THEN N'Shop nhiệt tình, tư vấn nhanh.'
            WHEN 2 THEN N'Sản phẩm đúng mô tả, giao hàng nhanh.'
            WHEN 3 THEN N'Thái độ phục vụ tốt, sẽ quay lại.'
            WHEN 4 THEN N'Giá cả hợp lý, đóng gói cẩn thận.'
            WHEN 5 THEN N'Rất hài lòng với dịch vụ.'
            ELSE N'Đánh giá tốt.'
        END AS Content,
        5,
        5,
        CASE WHEN N.n % 4 = 0 THEN 4 ELSE 5 END AS ShippingRating,
        5,
        (N.n * 2) AS HelpfulCount,
        CASE WHEN N.n % 3 = 0 THEN N'Cảm ơn bạn đã ủng hộ shop!' ELSE NULL END AS ReplyContent,
        CASE WHEN N.n % 3 = 0 THEN DATEADD(DAY, -N.n + 2, GETDATE()) ELSE NULL END AS ReplyAt,
        1,
        1,
        DATEADD(DAY, -N.n, GETDATE()),
        N'seed',
        N.n
    FROM N
    JOIN S ON S.rn = ((N.n - 1) % @ShopCount) + 1
    JOIN C ON C.rn = ((N.n - 1) % @CustomerCount) + 1;
END
