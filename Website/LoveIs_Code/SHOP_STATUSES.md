# Trạng thái shop (dùng chung)

Mục tiêu: thống nhất logic trạng thái shop để dùng chung trong admin, seller, và báo cáo.

## Danh sách trạng thái

- Active
  - Hiển thị: "Hoạt động"
  - Mô tả: Shop đang hoạt động bình thường, được phép hiển thị sản phẩm và nhận đơn hàng.
  - Màu gợi ý: xanh lá (status-success / status-shop).

- Pending
  - Hiển thị: "Chờ duyệt"
  - Mô tả: Shop đang chờ duyệt hồ sơ/kyc, chưa được phép bán hàng.
  - Màu gợi ý: vàng (status-warning).

- Inactive
  - Hiển thị: "Tạm dừng"
  - Mô tả: Shop tạm ngừng hoạt động (chủ shop tự tạm dừng hoặc admin tạm khóa).
  - Màu gợi ý: đỏ (status-danger).

## Quy tắc cập nhật

- Khóa nhà bán hàng:
  - CfSeller.Status = false
  - CfShop.Status = "Inactive"

- Mở khóa nhà bán hàng:
  - CfSeller.Status = true
  - CfShop.Status = "Active"

- Phê duyệt shop:
  - CfShop.Status = "Active"

## Ghi chú tích hợp

- Giá trị CfShop.Status lưu đúng chữ hoa đầu tiên: "Active", "Pending", "Inactive".
- Nếu shop chưa tạo hoặc chưa có bản ghi: hiển thị "-".
