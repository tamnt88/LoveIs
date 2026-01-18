# System Algorithms & Formulas

## 1) Category product ranking
Suggested weighting:
- BestSelling/Sold30d: 30%
- ViewCount: 20%
- AddToCartCount: 20%
- RatingAvg: 10%
- Recently updated: 20%

## 2) Product tracking
- ViewCount increments on product detail (once per session).
- AddToCartCount increments by quantity.
- Sold30d increments when order status becomes COMPLETED; decrements if reverted.

## 3) Platform fees (seller side)
Config tables:
- cf_platform_fee_config
  - ShippingFeePercent: 4.9%
  - PaymentFeePercent: 4.9%
  - InfrastructureFee: 3000/order
- cf_platform_fee_category
  - PlatformFeePercent by Level-1 CategoryId.

Formulas:
- feeBase = Subtotal + ShippingFee
- ShippingFeeAmount = feeBase * ShippingFeePercent
- PaymentFeeAmount = feeBase * PaymentFeePercent
- PlatformFeeAmount = sum(lineTotal * platformFeePercent)
- InfrastructureFee = fixed per order
- Saved on cf_order and cf_shop_order for reconciliation.

## 4) Order limits by total spent
Table: cf_customer_order_limit
- Total spent = sum of COMPLETED orders.
- Default tiers:
  - 0?2M: 5 items/order, max 2 per item
  - 2?10M: 10 items/order, max 3 per item
  - 10?30M: 20 items/order, max 5 per item
  - >30M: 50 items/order, max 10 per item

## 5) Shop order split
- cf_order is buyer order.
- cf_shop_order is per shop.
- Shipping/payment/infra fees allocated by subtotal ratio.

## 6) Community
- Posts can include images + YouTube video link.
- Chat uses SignalR, history persisted.
- Rate limits: 5 posts/5 minutes, 20 comments/5 minutes.
- External links must match whitelist.

## 7) Product ranking (current)
Ranking uses `App_Code/ProductRanking.cs` and cached fields refreshed by `App_Code/ProductRankingJob.cs`.

Signals in order (see code weights):
- Availability: `StockTotal` > 0 boost, <= 0 penalty.
- Price value: `MaxDiscountPercent`.
- Conversion proxy: `Sold30d / (ViewCount30d + 1)`.
- Quality penalties: `ReturnRate30d`, `CancelRate30d`, `IsViolation`, `Status`.
- Demand: `Sold30d`, `AddToCartCount`, `ViewCount`.
- Ratings: `RatingAvg`, `RatingCount`, shop `RatingAvg`, shop `RatingCount`.
- Content quality: `ContentScore`.
- Flags: `IsBestSelling`, `IsTrending`, `IsNewArrival`.
- Freshness: recent `CreatedAt`.

ContentScore formula (0-100, capped):
- Text length: `ShortDescription`, `Description`, `Specification` (HTML stripped).
- Extra fields: `Ingredients`, `Usage`.
- SEO: `SeoTitle`, `SeoDescription`, `SeoKeywords`.
- Social images: `OgImage`, `TwitterImage`.
- Media: product image count.
- Variants: variant count.

Notes:
- `ViewCount30d` currently falls back to `ViewCount` (no view log yet).
- Cancellation check uses `OrderStatus` contains "cancel" or "huy".

### Detailed formula (as of ProductRanking.cs)
Total score is the sum of all weighted signals below, then sorted by:
1) Score desc, 2) `CreatedAt` desc, 3) `Id` desc.

Score breakdown:
- Availability: `StockTotal > 0 ? +5 : -200`
- Discount value: `MaxDiscountPercent * 40`
- 30-day conversion proxy: `(Sold30d / (ViewCount30d + 1)) * 30`
- Return rate penalty: `ReturnRate30d * -50`
- Cancel rate penalty: `CancelRate30d * -30`
- Violations penalty: `IsViolation ? -500 : 0`
- Inactive product penalty: `Status ? 0 : -500`
- 30-day demand: `Sold30d * 5`
- Add-to-cart interest: `AddToCartCount * 2`
- Long-term views: `ViewCount * 0.1`
- Product rating: `RatingAvg * 20`
- Product rating count: `RatingCount * 0.5`
- Shop rating avg: `(Shop != null ? Shop.RatingAvg : 0) * 5`
- Shop rating count: `(Shop != null ? Shop.RatingCount : 0) * 0.2`
- Content quality: `ContentScore * 1`
- Flags:
  - `IsBestSelling ? +30 : 0`
  - `IsTrending ? +20 : 0`
  - `IsNewArrival ? +15 : 0`
- Freshness bonus (days since created):
  - `<= 7` days: `+15`
  - `<= 30` days: `+5`
  - `> 30` days: `+0`

Implementation reference: `App_Code/ProductRanking.cs`.

## 8) Product ranking refresh (scheduled job)
To refresh cached ranking fields periodically, schedule:
- Call `ProductRankingJob.RebuildAll()` from a background job (e.g., Windows Task Scheduler + console runner).
- Suggested frequency: every 6-12 hours; increase to hourly during high traffic.
- Ensure the job runs off-peak; it touches orders, returns, images, variants, and products.
# Seller Commerce Features (Pending)

## Collections
- cf_collection, cf_collection_item to group products by seller.
- Optional tracking via cf_collection_event or counters in cf_collection (LikeCount/ClickCount/ViewCount).

## Coupons
- cf_coupon (Scope: System/Seller) + cf_coupon_usage for checkout validation and reporting.
- Rules: min order, max discount, usage limits, date window.

## Shipping Configuration
- cf_shop_shipping_config for seller default carrier + free-shipping rules.
- cf_shop_shipping_method for allowed carriers per seller.
- Free shipping applies to all carriers for that seller when enabled and threshold met.

## Shipping Fee Delta Ledger
- cf_shipping_fee_adjustment to log carrier changes and fee differences for admin review.

## Bulk Promotions
- cf_shop_promotion + cf_shop_promotion_item for time-bound discount rules applied in listings.
