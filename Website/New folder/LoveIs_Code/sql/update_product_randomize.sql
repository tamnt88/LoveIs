SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#Cats') IS NOT NULL DROP TABLE #Cats;
IF OBJECT_ID('tempdb..#Brands') IS NOT NULL DROP TABLE #Brands;
IF OBJECT_ID('tempdb..#Origins') IS NOT NULL DROP TABLE #Origins;

SELECT
    ROW_NUMBER() OVER (ORDER BY Id) AS RowNum,
    Id,
    CategoryName
INTO #Cats
FROM dbo.cf_category
WHERE Status = 1;

SELECT
    ROW_NUMBER() OVER (ORDER BY Id) AS RowNum,
    Id,
    BrandName
INTO #Brands
FROM dbo.cf_brand
WHERE Status = 1;

SELECT
    ROW_NUMBER() OVER (ORDER BY Id) AS RowNum,
    Id,
    OriginName
INTO #Origins
FROM dbo.cf_origin
WHERE Status = 1;

DECLARE @CatCount INT = (SELECT COUNT(1) FROM #Cats);
DECLARE @BrandCount INT = (SELECT COUNT(1) FROM #Brands);
DECLARE @OriginCount INT = (SELECT COUNT(1) FROM #Origins);

;WITH ProductRows AS (
    SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS RowNum
    FROM dbo.cf_product
)
UPDATE pr
SET
    CategoryId = c.Id,
    BrandId = b.Id,
    OriginId = o.Id
FROM dbo.cf_product pr
JOIN ProductRows r ON r.Id = pr.Id
JOIN #Cats c ON c.RowNum = ((r.RowNum - 1) % @CatCount) + 1
JOIN #Brands b ON b.RowNum = ((r.RowNum - 1) % @BrandCount) + 1
JOIN #Origins o ON o.RowNum = ((r.RowNum - 1) % @OriginCount) + 1;

;WITH ProductRows AS (
    SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS RowNum
    FROM dbo.cf_product
),
Mapped AS (
    SELECT
        r.Id,
        c.CategoryName,
        b.BrandName,
        o.OriginName,
        r.RowNum
    FROM ProductRows r
    JOIN dbo.cf_product pr ON pr.Id = r.Id
    JOIN dbo.cf_category c ON c.Id = pr.CategoryId
    JOIN dbo.cf_brand b ON b.Id = pr.BrandId
    JOIN dbo.cf_origin o ON o.Id = pr.OriginId
)
UPDATE pr
SET ProductName = CASE (m.RowNum % 8)
        WHEN 0 THEN N'Sữa rửa mặt dịu nhẹ ' + m.BrandName + N' - ' + m.OriginName
        WHEN 1 THEN N'Serum phục hồi da ' + m.BrandName + N' - ' + m.OriginName
        WHEN 2 THEN N'Kem dưỡng ẩm sâu ' + m.BrandName + N' - ' + m.OriginName
        WHEN 3 THEN N'Toner cân bằng da ' + m.BrandName + N' - ' + m.OriginName
        WHEN 4 THEN N'Chống nắng hàng ngày ' + m.BrandName + N' - ' + m.OriginName
        WHEN 5 THEN N'Mặt nạ cấp ẩm ' + m.BrandName + N' - ' + m.OriginName
        WHEN 6 THEN N'Tẩy trang sạch sâu ' + m.BrandName + N' - ' + m.OriginName
        ELSE N'Dưỡng da cơ bản ' + m.BrandName + N' - ' + m.OriginName
    END
    + N' | ' + m.CategoryName
FROM dbo.cf_product pr
JOIN Mapped m ON m.Id = pr.Id;
