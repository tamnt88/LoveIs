USE LoveIsDB;
GO

-- Cập nhật menu Đánh giá sang trang mới
UPDATE dbo.cf_menu
SET Url = N'/seller/product-reviews.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2039;

UPDATE dbo.cf_menu
SET Url = N'/seller/shop-reviews.aspx',
    UpdatedAt = GETDATE(),
    UpdatedBy = N'admin'
WHERE Id = 2040;
GO
