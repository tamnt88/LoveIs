IF NOT EXISTS (SELECT 1 FROM dbo.cf_footer_menu)
BEGIN
    INSERT INTO dbo.cf_footer_menu (GroupName, GroupSortOrder, Title, Url, Status, CreatedAt, CreatedBy, SortOrder)
    VALUES
        (N'Dịch vụ', 1, N'Hướng dẫn mua hàng', N'/huong-dan-mua-hang', 1, GETDATE(), N'Seed', 1),
        (N'Dịch vụ', 1, N'Chính sách đổi trả', N'/chinh-sach-doi-tra', 1, GETDATE(), N'Seed', 2),
        (N'Dịch vụ', 1, N'Chính sách bảo mật', N'/chinh-sach-bao-mat', 1, GETDATE(), N'Seed', 3),
        (N'Dịch vụ', 1, N'Vận chuyển & giao hàng', N'/van-chuyen-giao-hang', 1, GETDATE(), N'Seed', 4),
        (N'Dịch vụ', 1, N'Chăm sóc khách hàng', N'/cham-soc-khach-hang', 1, GETDATE(), N'Seed', 5),

        (N'Trang website', 2, N'Về Beauty Story', N'/gioi-thieu', 1, GETDATE(), N'Seed', 1),
        (N'Trang website', 2, N'Thương hiệu', N'/thuong-hieu', 1, GETDATE(), N'Seed', 2),
        (N'Trang website', 2, N'Blog làm đẹp', N'/blog', 1, GETDATE(), N'Seed', 3),
        (N'Trang website', 2, N'Khuyến mãi', N'/khuyen-mai', 1, GETDATE(), N'Seed', 4),
        (N'Trang website', 2, N'Liên hệ', N'/lien-he', 1, GETDATE(), N'Seed', 5),

        (N'Hỗ trợ', 3, N'Tài khoản của tôi', N'/tai-khoan', 1, GETDATE(), N'Seed', 1),
        (N'Hỗ trợ', 3, N'Theo dõi đơn hàng', N'/tra-cuu-don-hang', 1, GETDATE(), N'Seed', 2),
        (N'Hỗ trợ', 3, N'Câu hỏi thường gặp', N'/faq', 1, GETDATE(), N'Seed', 3),
        (N'Hỗ trợ', 3, N'Điều khoản sử dụng', N'/dieu-khoan-su-dung', 1, GETDATE(), N'Seed', 4),
        (N'Hỗ trợ', 3, N'Liên hệ hỗ trợ', N'/ho-tro', 1, GETDATE(), N'Seed', 5);
END
