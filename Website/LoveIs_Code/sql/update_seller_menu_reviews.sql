USE LoveIsDB;
GO

-- Cập nhật menu Đánh giá sang trang mới
UPDATE dbo.cf_menu
SET Url = N'/seller/review-products.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2039;

UPDATE dbo.cf_menu
SET Url = N'/seller/review-shops.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2040;
GO
