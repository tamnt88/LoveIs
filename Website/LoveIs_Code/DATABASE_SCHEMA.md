# LoveIsDB Schema Overview

## Core commerce
- cf_category (3-level taxonomy).
- cf_product (ShopId, tracking: ViewCount/AddToCartCount/Sold30d).
- cf_product_variant.
- cf_product_variant_attribute, cf_variant_attribute, cf_variant_attribute_value.
- cf_product_image.
- cf_product_filter, cf_filter_group, cf_filter_option, cf_category_filter_group.

## Orders
- cf_order, cf_order_item, cf_order_history.
- cf_payment_method, cf_payment_status, cf_shipping_method, cf_order_status.
- cf_shop_order, cf_shop_order_history.

## Marketplace
- cf_seller, cf_shop, cf_shop_user.
- cf_return_request, cf_return_item.
- cf_payment_transaction, cf_shipping_tracking.
- cf_product_review, cf_shop_review.

## Buyer
- cf_customer, cf_customer_address, cf_customer_bank.

## Community
- cf_community_post, cf_community_post_image.
- cf_community_comment, cf_community_like.
- cf_community_room, cf_community_room_member, cf_community_message.
- cf_community_notification, cf_community_action_log.

## CMS/System
- cf_menu, cf_menu_permission.
- cf_banner, cf_brand_showcase, cf_brand_showcase_banner.
- cf_static_page, cf_system_page.
- cf_contact_info, cf_contact_message.
- cf_email_account, cf_social_link.
- cf_tracking_code.

## Fees & limits
- cf_platform_fee_config.
- cf_platform_fee_category.
- cf_customer_order_limit.

## Key scripts
- sql/add_platform_fees_and_limits.sql
- sql/alter_cf_product_package_dimensions.sql
- sql/add_performance_indexes.sql
