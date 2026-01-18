-- Seed admin menus for customer and seller management.
-- Run with UTF-8 encoding to preserve Vietnamese labels.

USE LoveIsDB;
GO

DECLARE @CustomerParentId INT;
SELECT @CustomerParentId = Id
FROM dbo.cf_menu
WHERE MenuName = N'Khách hàng' AND ParentId IS NULL;

IF @CustomerParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Khách hàng', N'Admin', NULL, NULL, N'fa-solid fa-user-group', 1, GETDATE(), N'Seed', 40);
    SET @CustomerParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Danh sách khách hàng' AND ParentId = @CustomerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Danh sách khách hàng', N'Admin', N'/admin/customers/default.aspx', @CustomerParentId, N'fa-solid fa-users', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Đơn hàng của khách' AND ParentId = @CustomerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đơn hàng của khách', N'Admin', N'/admin/orders/default.aspx', @CustomerParentId, N'fa-solid fa-receipt', 1, GETDATE(), N'Seed', 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Khiếu nại & hoàn trả' AND ParentId = @CustomerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Khiếu nại & hoàn trả', N'Admin', N'/admin/returns/default.aspx', @CustomerParentId, N'fa-solid fa-rotate-left', 1, GETDATE(), N'Seed', 3);
END

DECLARE @SellerParentId INT;
SELECT @SellerParentId = Id
FROM dbo.cf_menu
WHERE MenuName = N'Nhà bán hàng' AND ParentId IS NULL;

IF @SellerParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Nhà bán hàng', N'Admin', NULL, NULL, N'fa-solid fa-store', 1, GETDATE(), N'Seed', 41);
    SET @SellerParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Danh sách nhà bán hàng' AND ParentId = @SellerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Danh sách nhà bán hàng', N'Admin', N'/admin/sellers/default.aspx', @SellerParentId, N'fa-solid fa-store', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Chờ duyệt' AND ParentId = @SellerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chờ duyệt', N'Admin', N'/admin/sellers/pending.aspx', @SellerParentId, N'fa-solid fa-user-check', 1, GETDATE(), N'Seed', 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Sản phẩm của shop' AND ParentId = @SellerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Sản phẩm của shop', N'Admin', N'/admin/products/default.aspx', @SellerParentId, N'fa-solid fa-box', 1, GETDATE(), N'Seed', 3);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Đơn hàng của shop' AND ParentId = @SellerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đơn hàng của shop', N'Admin', N'/admin/orders/default.aspx', @SellerParentId, N'fa-solid fa-clipboard-list', 1, GETDATE(), N'Seed', 4);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Đối soát & doanh thu' AND ParentId = @SellerParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đối soát & doanh thu', N'Admin', N'/admin/settlements/default.aspx', @SellerParentId, N'fa-solid fa-chart-line', 1, GETDATE(), N'Seed', 5);
END

DECLARE @ReviewParentId INT;
SELECT @ReviewParentId = Id
FROM dbo.cf_menu
WHERE MenuName = N'Đánh giá' AND ParentId IS NULL;

IF @ReviewParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đánh giá', N'Admin', NULL, NULL, N'fa-solid fa-star', 1, GETDATE(), N'Seed', 42);
    SET @ReviewParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Đánh giá shop' AND ParentId = @ReviewParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đánh giá shop', N'Admin', N'/admin/reviews/shops/default.aspx', @ReviewParentId, N'fa-solid fa-store', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Đánh giá sản phẩm' AND ParentId = @ReviewParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Đánh giá sản phẩm', N'Admin', N'/admin/reviews/products/default.aspx', @ReviewParentId, N'fa-solid fa-box-open', 1, GETDATE(), N'Seed', 2);
END

DECLARE @DiscountParentId INT;
SELECT @DiscountParentId = Id
FROM dbo.cf_menu
WHERE MenuName = N'Mã giảm giá' AND ParentId IS NULL;

IF @DiscountParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mã giảm giá', N'Admin', NULL, NULL, N'fa-solid fa-ticket', 1, GETDATE(), N'Seed', 43);
    SET @DiscountParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Mã giảm giá của admin' AND ParentId = @DiscountParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mã giảm giá của admin', N'Admin', N'/admin/discounts/admin/default.aspx', @DiscountParentId, N'fa-solid fa-shield', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Mã giảm giá của nhà bán hàng' AND ParentId = @DiscountParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Mã giảm giá của nhà bán hàng', N'Admin', N'/admin/discounts/sellers/default.aspx', @DiscountParentId, N'fa-solid fa-store', 1, GETDATE(), N'Seed', 2);
END

DECLARE @IntegrationParentId INT;
SELECT @IntegrationParentId = Id
FROM dbo.cf_menu
WHERE MenuName = N'Tích hợp' AND ParentId IS NULL;

IF @IntegrationParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tích hợp', N'Admin', NULL, NULL, N'fa-solid fa-plug', 1, GETDATE(), N'Seed', 44);
    SET @IntegrationParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Tích hợp vận chuyển' AND ParentId = @IntegrationParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tích hợp vận chuyển', N'Admin', N'/admin/integrations/shipping/default.aspx', @IntegrationParentId, N'fa-solid fa-truck', 1, GETDATE(), N'Seed', 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Tích hợp thanh toán' AND ParentId = @IntegrationParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tích hợp thanh toán', N'Admin', N'/admin/integrations/payments/default.aspx', @IntegrationParentId, N'fa-solid fa-credit-card', 1, GETDATE(), N'Seed', 2);
END

DECLARE @PlatformFeeParentId INT;
SELECT @PlatformFeeParentId = Id
FROM dbo.cf_menu
WHERE MenuName = N'Phí sàn' AND ParentId IS NULL;

IF @PlatformFeeParentId IS NULL
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Phí sàn', N'Admin', NULL, NULL, N'fa-solid fa-percent', 1, GETDATE(), N'Seed', 45);
    SET @PlatformFeeParentId = SCOPE_IDENTITY();
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuName = N'Cấu hình phí sàn' AND ParentId = @PlatformFeeParentId)
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Cấu hình phí sàn', N'Admin', N'/admin/system/platform-fees/default.aspx', @PlatformFeeParentId, N'fa-solid fa-sliders', 1, GETDATE(), N'Seed', 1);
END
GO
