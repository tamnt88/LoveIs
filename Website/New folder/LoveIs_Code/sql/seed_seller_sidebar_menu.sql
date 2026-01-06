
USE LoveIsDB;
GO

DECLARE @Group NVARCHAR(100) = N'SellerSidebar';

-- Helper to insert parent and children
DECLARE @ParentId INT;

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Qu?n L? ??n H?ng')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Qu?n L? ??n H?ng', @Group, NULL, NULL, N'fa-regular fa-clipboard', 1, GETDATE(), N'Seed', 10);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Qu?n L? ??n H?ng';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'T?t c?')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?t c?', @Group, N'/seller/orders?status=all', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'??n H?y')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??n H?y', @Group, N'/seller/orders?status=cancelled', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Tr? H?ng/Ho?n Ti?n')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Tr? H?ng/Ho?n Ti?n', @Group, N'/seller/returns', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'??n ??i H?ng/H?ng ?o')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??n ??i H?ng/H?ng ?o', @Group, N'/seller/orders?status=swap', @ParentId, NULL, 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'B?o H? ??n H?y')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'B?o H? ??n H?y', @Group, N'/seller/orders?status=protect', @ParentId, NULL, 1, GETDATE(), N'Seed', 5);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'C?i ??t V?n Chuy?n')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'C?i ??t V?n Chuy?n', @Group, N'/seller/settings/shipping', @ParentId, NULL, 1, GETDATE(), N'Seed', 6);

-- Products
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Qu?n L? S?n Ph?m')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Qu?n L? S?n Ph?m', @Group, NULL, NULL, N'fa-solid fa-cube', 1, GETDATE(), N'Seed', 20);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Qu?n L? S?n Ph?m';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'T?t C? S?n Ph?m')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?t C? S?n Ph?m', @Group, N'/seller/products', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Th?m S?n Ph?m')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Th?m S?n Ph?m', @Group, N'/seller/products/create', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'S?n Ph?m B? Kh?a')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S?n Ph?m B? Kh?a', @Group, N'/seller/products?status=locked', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Vi Ph?m S?n Ph?m')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Vi Ph?m S?n Ph?m', @Group, N'/seller/products?status=violations', @ParentId, NULL, 1, GETDATE(), N'Seed', 4);

-- Reviews
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Qu?n L? ??nh Gi?')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Qu?n L? ??nh Gi?', @Group, NULL, NULL, N'fa-regular fa-star', 1, GETDATE(), N'Seed', 30);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Qu?n L? ??nh Gi?';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'??nh Gi? S?n Ph?m')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??nh Gi? S?n Ph?m', @Group, N'/seller/reviews/products', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'??nh Gi? Shop')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??nh Gi? Shop', @Group, N'/seller/reviews/shops', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);

-- Marketing
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'K?nh Marketing')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'K?nh Marketing', @Group, NULL, NULL, N'fa-solid fa-bullhorn', 1, GETDATE(), N'Seed', 40);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'K?nh Marketing';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'K?nh Marketing C?a T?i')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'K?nh Marketing C?a T?i', @Group, N'/seller/marketing/my', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Qu?ng C?o LoveIs')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Qu?ng C?o LoveIs', @Group, N'/seller/marketing/ads', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Chi?n D?ch Flash Sale')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chi?n D?ch Flash Sale', @Group, N'/seller/marketing/flash-sale', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'M? Gi?m Gi? C?a Shop')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'M? Gi?m Gi? C?a Shop', @Group, N'/seller/marketing/vouchers', @ParentId, NULL, 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Gian H?ng Add-on')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Gian H?ng Add-on', @Group, N'/seller/marketing/addon', @ParentId, NULL, 1, GETDATE(), N'Seed', 5);

-- Finance
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'T?i Ch?nh')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?i Ch?nh', @Group, NULL, NULL, N'fa-solid fa-wallet', 1, GETDATE(), N'Seed', 50);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'T?i Ch?nh';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Doanh Thu')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Doanh Thu', @Group, N'/seller/finance/revenue', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'S? D? T?i Kho?n')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'S? D? T?i Kho?n', @Group, N'/seller/finance/balance', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Th? Chi Ng??i B?n')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Th? Chi Ng??i B?n', @Group, N'/seller/finance/cashflow', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'B?o C?o T?i Ch?nh')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'B?o C?o T?i Ch?nh', @Group, N'/seller/finance/report', @ParentId, NULL, 1, GETDATE(), N'Seed', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Thi?t L?p T?i Kho?n Ng?n H?ng')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thi?t L?p T?i Kho?n Ng?n H?ng', @Group, N'/seller/finance/bank', @ParentId, NULL, 1, GETDATE(), N'Seed', 5);

-- Data
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'D? Li?u')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D? Li?u', @Group, NULL, NULL, N'fa-solid fa-chart-line', 1, GETDATE(), N'Seed', 60);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'D? Li?u';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Ph?n T?ch B?n H?ng')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ph?n T?ch B?n H?ng', @Group, N'/seller/analytics/sales', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Hi?u Qu? Ho?t ??ng')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Hi?u Qu? Ho?t ??ng', @Group, N'/seller/analytics/performance', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Ph?n T?ch S?n Ph?m')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ph?n T?ch S?n Ph?m', @Group, N'/seller/analytics/products', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Ph?n T?ch Marketing')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ph?n T?ch Marketing', @Group, N'/seller/analytics/marketing', @ParentId, NULL, 1, GETDATE(), N'Seed', 4);

-- Livestream
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Livestream')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Livestream', @Group, NULL, NULL, N'fa-solid fa-video', 1, GETDATE(), N'Seed', 70);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Livestream';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Livestream C?a T?i')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Livestream C?a T?i', @Group, N'/seller/livestream', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'T?o Livestream M?i')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?o Livestream M?i', @Group, N'/seller/livestream/create', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);

-- Support channels
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'K?nh H? Tr? Tr?c Ti?p')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'K?nh H? Tr? Tr?c Ti?p', @Group, N'/seller/support/live', NULL, N'fa-solid fa-headset', 1, GETDATE(), N'Seed', 80);
END

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'D?ch V? Ch?nh Th?c LoveIs')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'D?ch V? Ch?nh Th?c LoveIs', @Group, NULL, NULL, N'fa-solid fa-truck', 1, GETDATE(), N'Seed', 90);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'D?ch V? Ch?nh Th?c LoveIs';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'LoveIs B?o H?nh')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'LoveIs B?o H?nh', @Group, N'/seller/service/warranty', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Ch??ng Tr?nh Mi?n Ph? V?n Chuy?n')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Ch??ng Tr?nh Mi?n Ph? V?n Chuy?n', @Group, N'/seller/service/free-shipping', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);

-- Support
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'H? Tr?')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'H? Tr?', @Group, NULL, NULL, N'fa-regular fa-circle-question', 1, GETDATE(), N'Seed', 100);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'H? Tr?';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Trung T?m H? Tr?')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Trung T?m H? Tr?', @Group, N'/seller/support', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Chat V?i LoveIs')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Chat V?i LoveIs', @Group, N'/seller/support/chat', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Y?u C?u H? Tr?')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Y?u C?u H? Tr?', @Group, N'/seller/support/ticket', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);

-- Shop settings
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Thi?t L?p Shop')
BEGIN
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Thi?t L?p Shop', @Group, NULL, NULL, N'fa-solid fa-gear', 1, GETDATE(), N'Seed', 110);
END
SELECT @ParentId = Id FROM dbo.cf_menu WHERE MenuGroup = @Group AND MenuName = N'Thi?t L?p Shop';

IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'??a Ch? C?a T?i')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'??a Ch? C?a T?i', @Group, N'/seller/settings/address', @ParentId, NULL, 1, GETDATE(), N'Seed', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'C?i ??t Shop')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'C?i ??t Shop', @Group, N'/seller/settings', @ParentId, NULL, 1, GETDATE(), N'Seed', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'T?i Kho?n')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'T?i Kho?n', @Group, N'/seller/settings/account', @ParentId, NULL, 1, GETDATE(), N'Seed', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.cf_menu WHERE ParentId = @ParentId AND MenuName = N'Th?ng B?o')
    INSERT INTO dbo.cf_menu (MenuName, MenuGroup, Url, ParentId, Icon, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES (N'Th?ng B?o', @Group, N'/seller/settings/notifications', @ParentId, NULL, 1, GETDATE(), N'Seed', 4);
