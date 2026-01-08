using System;
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

    [Required]
    public byte[] PasswordHash { get; set; }

    [Required]
    public byte[] PasswordSalt { get; set; }

    public int PasswordIterations { get; set; }

    public DateTime? LastLoginAt { get; set; }

    public DateTime? LockedUntil { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
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

    [StringLength(300)]
    public string LogoUrl { get; set; }

    [StringLength(300)]
    public string BannerUrl { get; set; }

    public string Description { get; set; }

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

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
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
