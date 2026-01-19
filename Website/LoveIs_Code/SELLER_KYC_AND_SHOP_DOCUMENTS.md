# Seller KYC + Shop Documents (DB + quy uoc)

## Muc tieu
- Tach ho so nguoi ban (KYC) va ho so giay to shop de quan tri ro rang.
- Ho tro duyet ho so, ly do tu choi, nguoi duyet, thoi gian duyet.

## Bang du lieu

### seller_kyc
- Luu thong tin xac thuc nguoi ban.
- Cot chinh: SellerId, FullName, BirthDate, IdNumber, IdIssuedDate, IdIssuedPlace, Status, RejectedReason.
- Khoa ngoai: SellerId -> cf_seller.Id.

### seller_kyc_file
- Luu file KYC (CCCD mat truoc/mat sau, selfie neu co).
- Cot chinh: SellerKycId, FileType, FileUrl, FileName, FileSize, MimeType, Status.
- Khoa ngoai: SellerKycId -> seller_kyc.Id.

### shop_document
- Luu thong tin giay to cua shop (GPKD, MST, uy quyen, ...).
- Cot chinh: ShopId, DocType, DocNumber, IssuedDate, ExpiredDate, Status, RejectedReason.
- Khoa ngoai: ShopId -> cf_shop.Id.

### shop_document_file
- Luu file giay to cua shop.
- Cot chinh: ShopDocumentId, FileType, FileUrl, FileName, FileSize, MimeType, Status.
- Khoa ngoai: ShopDocumentId -> shop_document.Id.

## Trang thai dung chung
- Status (seller_kyc, shop_document): pending | approved | rejected

## Lookup de xuat (da tao trong SQL)
- seller_kyc_status
- shop_document_status
- seller_kyc_file_type
- shop_document_type
- shop_document_file_type

## FK lookup da bo sung
- seller_kyc.Status -> seller_kyc_status.Code
- seller_kyc_file.FileType -> seller_kyc_file_type.Code
- shop_document.Status -> shop_document_status.Code
- shop_document.DocType -> shop_document_type.Code
- shop_document_file.FileType -> shop_document_file_type.Code

## FileType goi y
- seller_kyc_file:
  - cccd_front
  - cccd_back
  - selfie_with_cccd (optional)
- shop_document_file:
  - business_license
  - tax_certificate
  - authorization_letter
  - lease_contract

## DocType goi y (shop_document)
- business_license
- tax_certificate
- authorization_letter
- lease_contract

## Ghi chu
- FileUrl luu duong dan file da upload (cdn/host).
- FileSize tinh theo bytes.
- MimeType luu duoi dang "image/jpeg", "application/pdf", ...
- Co the mo rong bang lookup/enum neu can.
