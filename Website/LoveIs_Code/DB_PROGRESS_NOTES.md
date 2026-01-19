# Tong hop cau truc DB + tinh trang xu ly

Tai lieu nay tong hop cau truc DB (muc quan trong), cac thay doi gan day va nhung phan con thieu de team tiep tuc.

## Tong quan DB (theo nhom nghiep vu)
- Tham chieu day du: `DATABASE_SCHEMA.md` (LoveIsDB).
- Core commerce: category, product, variant, image, filter.
- Orders: order, order_item, order_history, payment/shipping method + status, shop_order.
- Orders: shipping carrier + mapping carrier-method.
- Marketplace: seller, shop, shop_user, return_request, payment_transaction, shipping_tracking, product/shop review.
- Buyer: customer, customer_address, customer_bank.
- CMS/System: menu, banner, static/system page, contact info/message, email/social, tracking code.
- Fees/limits: platform_fee_config, platform_fee_category, customer_order_limit.
- Discounts/coupons: cf_coupon, cf_coupon_usage.
- Auth/admin: cf_user, cf_role, cf_permission, cf_user_role, cf_role_permission, cf_menu_permission.

## KYC + giay to shop (da hoan thien)
- SQL tao bang + lookup + FK: `sql/create_seller_kyc_and_shop_documents.sql`
- Model: `App_Code/Models/SellerKycModels.cs`
- DbSet + mapping: `App_Code/BeautyStoryContext.cs`

Bang chinh:
- `cf_seller_kyc`
- `cf_seller_kyc_file`
- `cf_shop_document`
- `cf_shop_document_file`

Lookup:
- `cf_seller_kyc_status`
- `cf_shop_document_status`
- `cf_seller_kyc_file_type`
- `cf_shop_document_type`
- `cf_shop_document_file_type`

Quy uoc AddressType trong `cf_shop_address`:
- Tai lieu: `SHOP_ADDRESS_TYPES.md`

## cf_shop_address (da dieu chinh)
- Da them: `WardId`, `ProvinceId`
- Da bo: `DistrictName`
- Model cap nhat: `App_Code/Models/CfShopAddress.cs`
- SQL alter: `sql/alter_cf_shop_address_ward_province.sql`
- SQL schema cap nhat: `sql/cf_shop_address.sql`, `sql/script_update_18_01_2026.sql`

## Admin sellers edit (dang su dung DataTables)
- UI + filter san pham, shop, dia chi kho/tra hang, danh gia shop/san pham: `admin/sellers/edit.aspx`
- WebMethods + server side: `admin/sellers/edit.aspx.cs`
- Luu y: toan bo load data qua DataTables server-side (jQuery)

## Menu admin (da seed)
- Script menu: `sql/seed_admin_customer_seller_menu.sql`
- DB: `cf_menu`

## Luong checkout va van chuyen (UI/API + du lieu)
- **UI checkout (khach hang)**: khi chon san pham vao gio, he thong group theo `ShopId`.
- **API tinh phi**: backend lay config tu `cf_shop_shipping_config` (DefaultShippingMethodId + DefaultShippingCarrierId).
- **Fallback**: neu shop chua co config, lay `cf_shipping_method.IsDefault = 1` va carrier co `cf_shipping_carrier.IsDefault = 1`.
- **Fallback tiep**: neu chua co carrier default, chon carrier theo `SortOrder` tang dan.
- **Tinh phi theo hang**: su dung `ShippingFeeCalculator.CalculateFee(carrierCode, method, isInnerCity)` (dang tra phi gia lap, se thay bang API sau).
- **Tinh phi**: phi van chuyen duoc tinh theo method default (BaseFee/InnerCityFee) + ap dung FreeShipping (FreeShippingEnabled + FreeShippingMinOrder).
- **Luu don**: tao `cf_order`, `cf_shop_order`; luu `ShippingMethodId` va `ShippingCarrierId` tren `cf_shop_order`.
- **Shop order**: tinh phi theo tung shop (shop config -> method/carrier), luu `ShippingMethod`, `ShippingEta`, `ShippingCarrierId` tren `cf_shop_order`.
- **UI seller fulfill**: seller duoc phep doi `ShippingCarrierId` (hang van chuyen) neu can.
- **Cap nhat chenh lech**: neu doi hang lam doi phi, ghi vao `cf_shipping_fee_adjustment` (OldFee/NewFee/DeltaFee/Payer/OrderId/ShopId/ShopOrderId).
- **Tracking**: cap nhat `cf_shipping_tracking` theo `cf_shop_order`.

## Auth/admin (chua note truoc do)
- SQL cau truc: `sql/cf_auth.sql`
- Seed admin: `sql/seed_admin.sql`
- Bang: `cf_user`, `cf_role`, `cf_permission`, `cf_user_role`, `cf_role_permission`, `cf_menu_permission`

## Discount/Coupon (chua note truoc do)
- SQL tao bang: `sql/add_seller_commerce_features.sql`
- Bang: `cf_coupon`, `cf_coupon_usage`

## Vi shop + rut tien (moi them)
- SQL tao bang: `sql/create_shop_wallet_and_bank.sql`, `sql/create_shop_wallet_release.sql`
- SQL alter OnePay transaction: `sql/alter_cf_payment_transaction_bank.sql`
- Bang: `cf_shop_bank`, `cf_shop_wallet`, `cf_shop_wallet_txn`, `cf_shop_wallet_release`, `cf_shop_payout_request`, `cf_shop_payout_proof`
- Model: `App_Code/MarketplaceModels.cs`
- DbSet: `App_Code/BeautyStoryContext.cs`
- Hook OnePay: `thanh-toan/onepay-return.aspx.cs`, `thanh-toan/onepay-ipn.aspx.cs`
- Helper: `App_Code/ShopWalletService.cs` (ghi `PENDING_IN` va tao `cf_shop_wallet_release`)
- Config hold days: `cf_system_setting` key `WalletHoldDays` (default 7 neu chua co)
- Seed setting: `sql/seed_wallet_hold_days_setting.sql`
- Admin API: `admin/system/wallet-release.aspx` (ApproveRelease -> Released, ReleaseToAvailable -> Available, ReleaseDue).
- Seller API: `seller/finance-cashflow.aspx` (CreatePayoutRequest).

## Tinh trang da xu ly
- Bo District trong address + cap nhat WardId/ProvinceId.
- Them KYC + shop documents schema, models, mapping.
- Admin sellers edit da co tab, filter, va server-side DataTables.
- Bo sung carrier van chuyen: `sql/add_shipping_carriers.sql` (cf_shipping_carrier, cf_shipping_carrier_method) co contact + logo + API credentials.
- Shop-level carrier config: `sql/alter_shipping_carrier_config.sql` (DefaultShippingCarrierId + cf_shop_shipping_carrier + ShippingCarrierId on cf_shop_order).
- OnePay transaction: luu ngan hang/card + response code vao `cf_payment_transaction`.
- Vi shop: ghi `PENDING_IN` khi OnePay thanh toan thanh cong; tao release record de admin duyet.

## Tinh trang can lam tiep
- UI/flow KYC upload (seller/admin): UI upload CCCD mat truoc/mat sau + luong duyet/tu choi.
- UI/flow Shop documents upload (seller/admin): UI upload giay to shop + luong duyet/tu choi.
- UI/flow vi shop: man hinh so du + lich su giao dich (ledger).
- UI/flow rut tien: seller tao lenh rut, admin duyet + upload chung tu, cap nhat payout + wallet.
- Release engine: cron/admin action de chuyen `PendingBalance` -> `AvailableBalance` theo `cf_shop_wallet_release` (Pending -> Released -> Available).
- Normalize tieng Viet cho cac file SQL/HTML bi loi font (neu can).

## Note quan trong
- Khi drop column `DistrictName`, can chay script alter trong `sql/alter_cf_shop_address_ward_province.sql`.
- Lookup KYC/Shop documents co FK rang buoc, can dam bao du lieu dung ma Code khi insert.
