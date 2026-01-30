using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_seller")]
public class CfSeller
{
    public int Id { get; set; }

    [Required, StringLength(100)]
    public string Username { get; set; }

    [StringLength(200)]
    public string DisplayName { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [StringLength(30)]
    public string Phone { get; set; }

    public DateTime? BirthDate { get; set; }

    [StringLength(300)]
    public string AvatarUrl { get; set; }

    [Required]
    public byte[] PasswordHash { get; set; }

    [Required]
    public byte[] PasswordSalt { get; set; }

    public int PasswordIterations { get; set; }

    public DateTime? LastLoginAt { get; set; }

    public DateTime? PasswordChangedAt { get; set; }

    public DateTime? LockedUntil { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<SellerKyc> SellerKycs { get; set; }
}

[Table("cf_shop")]
public class CfShop
{
    public int Id { get; set; }

    public int SellerId { get; set; }

    [Required, StringLength(50)]
    public string ShopCode { get; set; }

    [Required, StringLength(200)]
    public string ShopName { get; set; }

    [StringLength(30)]
    public string Phone { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [StringLength(300)]
    public string LogoUrl { get; set; }

    [StringLength(300)]
    public string BannerUrl { get; set; }

    public string Description { get; set; }

    [StringLength(100)]
    public string BusinessType { get; set; }

    [StringLength(50)]
    public string TaxCode { get; set; }

    [StringLength(300)]
    public string AddressLine { get; set; }

    public int? WardId { get; set; }

    public int? ProvinceId { get; set; }

    [StringLength(150)]
    public string WardName { get; set; }

    [StringLength(150)]
    public string ProvinceName { get; set; }

    [StringLength(50)]
    public string Status { get; set; }

    public decimal RatingAvg { get; set; }

    public int RatingCount { get; set; }

    public int CompletedOrders { get; set; }
    public decimal? ResponseRate { get; set; }
    public int? ResponseTimeMinutes { get; set; }
    public int FollowerCount { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<ShopDocument> ShopDocuments { get; set; }
}

[Table("cf_shop_follow")]
public class CfShopFollow
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int CustomerId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }
}

[Table("cf_shop_inquiry")]
public class CfShopInquiry
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int CustomerId { get; set; }

    public int? ProductId { get; set; }

    public int? VariantId { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime? FirstReplyAt { get; set; }

    public DateTime? LastReplyAt { get; set; }

    public DateTime? LastMessageAt { get; set; }

    [StringLength(20)]
    public string LastMessageSender { get; set; }

    public bool Status { get; set; }
}

[Table("cf_product_import_batch")]
public class CfProductImportBatch
{
    public int Id { get; set; }
    public int SellerId { get; set; }
    public string FileName { get; set; }
    public int TotalItems { get; set; }
    public int CompletedItems { get; set; }
    public string Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

[Table("cf_product_import_item")]
public class CfProductImportItem
{
    public int Id { get; set; }
    public int BatchId { get; set; }
    public int RowIndex { get; set; }
    public string ProductName { get; set; }
    public string Description { get; set; }
    public int? CategoryId { get; set; }
    public int? BrandId { get; set; }
    public int? OriginId { get; set; }
    public string BaseSku { get; set; }
    public decimal? BasePrice { get; set; }
    public decimal? BaseSalePrice { get; set; }
    public int? BaseStock { get; set; }
    public string VariantData { get; set; }
    public decimal? PackageWeightGrams { get; set; }
    public decimal? PackageLengthCm { get; set; }
    public decimal? PackageWidthCm { get; set; }
    public decimal? PackageHeightCm { get; set; }
    public string ImageUrls { get; set; }
    public string VideoUrl { get; set; }
    public bool IsCompleted { get; set; }
    public bool IsDuplicatedSku { get; set; }
    public int? DuplicatedProductId { get; set; }
    public DateTime? LastSavedAt { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_support_ticket_category")]
public class CfSupportTicketCategory
{
    public int Id { get; set; }
    public string Code { get; set; }
    public string Name { get; set; }
    public int SortOrder { get; set; }
    public bool Status { get; set; }
}

[Table("cf_support_ticket_status")]
public class CfSupportTicketStatus
{
    public int Id { get; set; }
    public string Code { get; set; }
    public string Name { get; set; }
    public int SortOrder { get; set; }
    public bool Status { get; set; }
}

[Table("cf_support_ticket_priority")]
public class CfSupportTicketPriority
{
    public int Id { get; set; }
    public string Code { get; set; }
    public string Name { get; set; }
    public int SortOrder { get; set; }
    public bool Status { get; set; }
}

[Table("cf_support_ticket")]
public class CfSupportTicket
{
    public int Id { get; set; }
    public int SellerId { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public int CategoryId { get; set; }
    public int StatusId { get; set; }
    public int PriorityId { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

[Table("cf_support_ticket_message")]
public class CfSupportTicketMessage
{
    public int Id { get; set; }
    public int TicketId { get; set; }
    public string SenderType { get; set; }
    public string Message { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_shop_inquiry_message")]
public class CfShopInquiryMessage
{
    public int Id { get; set; }

    public int InquiryId { get; set; }

    public int ShopId { get; set; }

    public int CustomerId { get; set; }

    [StringLength(20)]
    public string SenderType { get; set; }

    [StringLength(20)]
    public string MessageType { get; set; }

    public string Message { get; set; }

    public DateTime? ReadAt { get; set; }

    public DateTime CreatedAt { get; set; }
}

[Table("cf_shop_inquiry_message_file")]
public class CfShopInquiryMessageFile
{
    public int Id { get; set; }

    public int MessageId { get; set; }

    [StringLength(500)]
    public string FileUrl { get; set; }

    [StringLength(255)]
    public string FileName { get; set; }

    [StringLength(100)]
    public string MimeType { get; set; }

    public int? FileSize { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }
}

[Table("cf_shop_user")]
public class CfShopUser
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int SellerId { get; set; }

    [StringLength(50)]
    public string UserRole { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_support_chat")]
public class CfSupportChat
{
    public int Id { get; set; }

    public int SellerId { get; set; }

    public int? AdminId { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime? LastMessageAt { get; set; }

    [StringLength(20)]
    public string LastMessageSender { get; set; }

    public bool Status { get; set; }
}

[Table("cf_support_chat_message")]
public class CfSupportChatMessage
{
    public int Id { get; set; }

    public int ChatId { get; set; }

    [StringLength(20)]
    public string SenderType { get; set; }

    [StringLength(20)]
    public string MessageType { get; set; }

    public string Message { get; set; }

    public DateTime? ReadAt { get; set; }

    public DateTime CreatedAt { get; set; }
}

[Table("cf_support_chat_message_file")]
public class CfSupportChatMessageFile
{
    public int Id { get; set; }

    public int MessageId { get; set; }

    [StringLength(500)]
    public string FileUrl { get; set; }

    [StringLength(255)]
    public string FileName { get; set; }

    [StringLength(100)]
    public string MimeType { get; set; }

    public int? FileSize { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }
}

[Table("cf_shop_order")]
public class CfShopOrder
{
    public int Id { get; set; }

    public int OrderId { get; set; }

    public int ShopId { get; set; }

    [StringLength(100)]
    public string ShippingMethod { get; set; }

    public decimal ShippingFee { get; set; }
    public decimal? ShippingFeePercent { get; set; }
    public decimal? ShippingFeeAmount { get; set; }

    [StringLength(100)]
    public string ShippingEta { get; set; }

    [StringLength(50)]
    public string PaymentStatus { get; set; }
    public decimal? PaymentFeePercent { get; set; }
    public decimal? PaymentFeeAmount { get; set; }

    [StringLength(50)]
    public string OrderStatus { get; set; }

    public int? ShippingCarrierId { get; set; }

    public decimal Subtotal { get; set; }

    public decimal Discount { get; set; }
    public decimal? PlatformFeePercent { get; set; }
    public decimal? PlatformFeeAmount { get; set; }
    public decimal? InfrastructureFee { get; set; }

    public decimal Total { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_order_history")]
public class CfShopOrderHistory
{
    public int Id { get; set; }

    public int ShopOrderId { get; set; }

    [Required, StringLength(200)]
    public string Action { get; set; }

    public string Note { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_return_request")]
public class CfReturnRequest
{
    public int Id { get; set; }

    public int OrderId { get; set; }

    public int ShopId { get; set; }

    [StringLength(20)]
    public string RequestType { get; set; }

    [StringLength(300)]
    public string Reason { get; set; }

    [StringLength(50)]
    public string Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_return_item")]
public class CfReturnItem
{
    public int Id { get; set; }

    public int ReturnRequestId { get; set; }

    public int OrderItemId { get; set; }

    public int Quantity { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_return_status")]
public class CfReturnStatus
{
    public int Id { get; set; }

    [Required, StringLength(50)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    [StringLength(500)]
    public string Description { get; set; }

    public bool IsDefault { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_payment_transaction")]
public class CfPaymentTransaction
{
    public int Id { get; set; }

    public int OrderId { get; set; }

    [StringLength(50)]
    public string Provider { get; set; }

    [StringLength(100)]
    public string ProviderRef { get; set; }

    [StringLength(50)]
    public string Status { get; set; }

    [StringLength(50)]
    public string BankCode { get; set; }

    [StringLength(255)]
    public string BankName { get; set; }

    [StringLength(50)]
    public string CardType { get; set; }

    [StringLength(50)]
    public string CardNumber { get; set; }

    [StringLength(20)]
    public string ResponseCode { get; set; }

    public decimal Amount { get; set; }

    public string MetaJson { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_bank")]
public class CfShopBank
{
    public int Id { get; set; }
    public int ShopId { get; set; }

    [StringLength(255)]
    public string BankName { get; set; }

    [StringLength(255)]
    public string AccountName { get; set; }

    [StringLength(100)]
    public string AccountNumber { get; set; }

    [StringLength(255)]
    public string Branch { get; set; }

    public bool IsDefault { get; set; }
    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_wallet")]
public class CfShopWallet
{
    public int Id { get; set; }
    public int ShopId { get; set; }
    public decimal Balance { get; set; }
    public decimal AvailableBalance { get; set; }
    public decimal PendingBalance { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_wallet_txn")]
public class CfShopWalletTxn
{
    public int Id { get; set; }
    public int ShopId { get; set; }
    public int? OrderId { get; set; }
    public int? ShopOrderId { get; set; }

    [StringLength(50)]
    public string Type { get; set; }

    public decimal Amount { get; set; }
    public decimal BalanceBefore { get; set; }
    public decimal BalanceAfter { get; set; }
    public decimal AvailableBefore { get; set; }
    public decimal AvailableAfter { get; set; }
    public decimal PendingBefore { get; set; }
    public decimal PendingAfter { get; set; }

    public string Note { get; set; }
    public string MetaJson { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }
}

[Table("cf_shop_wallet_release")]
public class CfShopWalletRelease
{
    public int Id { get; set; }
    public int ShopId { get; set; }
    public int? OrderId { get; set; }
    public int? ShopOrderId { get; set; }
    public decimal Amount { get; set; }
    public DateTime ReleaseAt { get; set; }

    [StringLength(50)]
    public string Status { get; set; }

    public string Note { get; set; }
    public DateTime? ApprovedAt { get; set; }

    [StringLength(100)]
    public string ApprovedBy { get; set; }

    public DateTime? ReleasedAt { get; set; }

    [StringLength(100)]
    public string ReleasedBy { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_payout_request")]
public class CfShopPayoutRequest
{
    public int Id { get; set; }
    public int ShopId { get; set; }
    public int BankAccountId { get; set; }
    public decimal Amount { get; set; }

    [StringLength(50)]
    public string Status { get; set; }

    public string Note { get; set; }
    public DateTime RequestedAt { get; set; }

    [StringLength(100)]
    public string RequestedBy { get; set; }

    public DateTime? ApprovedAt { get; set; }

    [StringLength(100)]
    public string ApprovedBy { get; set; }

    public DateTime? PaidAt { get; set; }

    [StringLength(100)]
    public string PaidBy { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_payout_proof")]
public class CfShopPayoutProof
{
    public int Id { get; set; }
    public int PayoutRequestId { get; set; }

    [StringLength(1000)]
    public string FileUrl { get; set; }

    [StringLength(255)]
    public string FileName { get; set; }

    public DateTime UploadedAt { get; set; }

    [StringLength(100)]
    public string UploadedBy { get; set; }

    public bool Status { get; set; }
}

[Table("cf_shipping_tracking")]
public class CfShippingTracking
{
    public int Id { get; set; }

    public int ShopOrderId { get; set; }

    [StringLength(100)]
    public string Carrier { get; set; }

    [StringLength(100)]
    public string TrackingCode { get; set; }

    [StringLength(50)]
    public string Status { get; set; }

    public string MetaJson { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_product_review")]
public class CfProductReview
{
    public int Id { get; set; }

    public int ProductId { get; set; }

    public int? OrderId { get; set; }

    public int CustomerId { get; set; }

    public int Rating { get; set; }

    public string Content { get; set; }

    public string ImageUrls { get; set; }

    public int HelpfulCount { get; set; }

    public string ReplyContent { get; set; }

    public DateTime? ReplyAt { get; set; }

    public bool IsVerified { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}

[Table("cf_shop_review")]
public class CfShopReview
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int CustomerId { get; set; }

    public int Rating { get; set; }

    public string Content { get; set; }

    public int QualityRating { get; set; }

    public int DescriptionRating { get; set; }

    public int ShippingRating { get; set; }

    public int ServiceRating { get; set; }

    public int HelpfulCount { get; set; }

    public string ReplyContent { get; set; }

    public DateTime? ReplyAt { get; set; }

    public bool IsVerified { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
[Table("cf_coupon")]
public class CfCoupon
{
    public int Id { get; set; }

    [Required, StringLength(50)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    public string Description { get; set; }

    [Required, StringLength(20)]
    public string Scope { get; set; }

    public int? ShopId { get; set; }

    [Required, StringLength(20)]
    public string DiscountType { get; set; }

    public decimal DiscountValue { get; set; }

    public decimal MinOrder { get; set; }

    public decimal? MaxDiscount { get; set; }

    public DateTime? StartAt { get; set; }

    public DateTime? EndAt { get; set; }

    public int? UsageLimit { get; set; }

    public int? UsagePerUser { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(50)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(50)]
    public string UpdatedBy { get; set; }
}

[Table("cf_coupon_usage")]
public class CfCouponUsage
{
    public int Id { get; set; }

    public int CouponId { get; set; }

    public int OrderId { get; set; }

    public int CustomerId { get; set; }

    public decimal DiscountAmount { get; set; }

    public DateTime CreatedAt { get; set; }
}

