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
