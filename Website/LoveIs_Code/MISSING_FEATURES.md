# Missing items for a full e-commerce website

## 1) Real payments & shipping
- OnePay da co flow co ban (DOMESTIC/INTERNATIONAL/EWALLET) can kiem thu va cau hinh production.
- VNPay/MoMo/ZaloPay integration.
- GHN/GHTK/VTPost integration.
- Webhooks for status sync.

## 2) Inventory & logistics
- Variant-level stock deduction.
- Restock on cancel/return.
- Low-stock alerts.

## 3) Promotions
- Vouchers/flash sale.
- Rule engine for promo eligibility.

## 4) Seller reconciliation
- Payout cycles.
- Settlement reports.
- Shop wallet UI (Balance/Available/Pending) + ledger view.
- Payout request flow UI (seller) + admin approval UI + proof upload UI. (da co UI co ban, can refine UX + validation)
- Release workflow UI (Pending -> Released -> Available) based on hold days or admin approval.
- Inner city config UI (set `cf_ward.IsInnerCity`) + data seeding theo phuong.

## 5) Community moderation
- Report/ban content.
- Keyword filtering.

## 6) Security
- reCAPTCHA.
- Anti-spam & anti-fraud.
- Audit logs.

## 7) SEO & marketing
- Sitemap automation.
- Rich schema.
- Email marketing.

## 8) UX features
- Wishlist.
- Compare products.
- Advanced search.

## 9) Seller collections, promos, and shipping rules
- Seller collections with product attachments.
- Collection tracking (likes, clicks, views) and reporting.
- Seller/admin coupons with validation at checkout.
- Seller shipping configuration (default carrier + allowed carriers).
- Seller free-shipping rules (global or threshold-based).
- Shipping fee delta ledger for admin review when carriers change.
- Seller bulk promotions with time windows applied in listings.

## 10) Tong hop da thong nhat (Viet)
- Bo suu tap thoi trang (Collection): seller tao bo suu tap va gan san pham (cf_collection, cf_collection_item); tracking like/click/view (luu count nhanh trong cf_collection hoac log cf_collection_event + batch).
- Ma giam gia (Coupon): seller + admin tao, dung luc checkout (cf_coupon, cf_coupon_usage); rule gioi han luot dung, don toi thieu, pham vi theo shop/san pham/danh muc.
- Cau hinh van chuyen theo seller: he thong co danh sach hang (cf_shipping_method); seller cau hinh hang mac dinh + hang duoc phep (cf_shop_shipping_config); checkout tinh phi theo default cua seller (fallback system default); cho phep doi hang khi fulfill; phi chenhlech uu tien giu phi khach va seller chiu phan chenhlech.
- De xuat tach hang van chuyen: cf_shipping_carrier + cf_shipping_carrier_method (A/B/C) -> method (giao nhanh/giao chuan), luu contact + logo + API credentials.
- Them shop-level carrier: DefaultShippingCarrierId trong cf_shop_shipping_config + cf_shop_shipping_carrier + ShippingCarrierId trong cf_shop_order + IsDefault trong cf_shipping_carrier.
- Shop order luu carrier/method theo shop de doi hang khi fulfill.
- Can tich hop API thuc te de tinh phi van chuyen (hien dang dung gia lap).
- Ledger phi van chuyen: cf_shipping_fee_adjustment ghi OldFee/NewFee/Delta/Payer/OrderId/ShopId; admin co bao cao theo shop/hang/thoi gian.
- Mien phi van chuyen: FreeShippingEnabled/FreeShippingMinOrder theo shop; neu dat nguong thi fee = 0 nhung van luu fee goc de doi soat.
- Khuyen mai dong loat theo thoi gian (Bulk promo): cf_shop_promotion (DiscountType, DiscountValue, StartAt, EndAt, AppliesTo); ap dung gia khuyen mai neu con hieu luc.
