# LoveIs Store - Project Summary

## Overview
- Goal: upgrade LoveIs into a multi-role e-commerce system (buyer/seller/admin) for lingerie.
- Stack: ASP.NET WebForms + SQL Server.
- Database: LoveIsDB.
- Main theme color: #3a0517 (public + seller).

## Implemented
### 1) Core data
- 3-level category tree (Level 1/2/3).
- Filters/variants: size, cup, color, material, style.
- Large sample catalog + images.
- Products assigned to shops (ShopId in cf_product).

### 2) Accounts & roles
- Buyer login required to place orders.
- Email verification on registration.
- OAuth Google/Facebook.
- Seller portal: `/seller`.
- cf_customer + cf_seller mapping:
  - cf_customer stores SellerId + IsSeller.
  - Seller username mirrored into cf_customer.Username.

### 3) UI/UX
- Buyer/Seller login pages follow design.
- Seller dashboard + DB-driven menu.
- Public theme uses #3a0517, footer payment/shipping logos.
- Home page: category slider, banners, best-selling swiper, new-product grid.

### 4) Cart & checkout
- Cart grouped by shop + bulk delete checkbox.
- Checkout uses address book and auto-fill default.
- Auto-save address if customer has none.

### 5) Marketplace
- Split shop orders (cf_shop_order).
- Product/shop reviews.
- Tracking: ViewCount / AddToCartCount / Sold30d.

### 6) Community
- Newsfeed: post, like, comment.
- 1-1 & group chat (SignalR) with persistent history.
- Notifications dropdown.
- Rate limit + whitelist domains.

### 7) Performance
- Query optimizations for key pages.
- Indexes for core tables.

## In progress
- Community modal: image/emoji/video + preview UX refinement.
- Seller/buyer display name & avatar mapping consistency.
- Vietnamese text encoding still inconsistent in some UI templates.
- Fee configuration UI for admin (fees already stored & calculated).

## Not done yet
- Real payment & shipping integration (VNPay/MoMo/GHN).
- Promotions/vouchers/flash sale.
- Full return/refund workflows.
- Seller payout & reconciliation reports.
- Advanced monitoring/logging.

## Important files
- REQUIRED_READING.md
- SYSTEM_ALGORITHMS.md
- DATABASE_SCHEMA.md

## Community documentation
- COMMUNITY_SPEC.md (detailed flow + data model)
