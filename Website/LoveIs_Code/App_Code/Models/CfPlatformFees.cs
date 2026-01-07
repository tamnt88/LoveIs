using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_platform_fee_config")]
public class CfPlatformFeeConfig
{
    public int Id { get; set; }
    public decimal ShippingFeePercent { get; set; }
    public decimal PaymentFeePercent { get; set; }
    public decimal InfrastructureFee { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}

[Table("cf_platform_fee_category")]
public class CfPlatformFeeCategory
{
    public int Id { get; set; }
    public int CategoryId { get; set; }
    public decimal PlatformFeePercent { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}

[Table("cf_customer_order_limit")]
public class CfCustomerOrderLimit
{
    public int Id { get; set; }
    public decimal MinTotalSpent { get; set; }
    public decimal? MaxTotalSpent { get; set; }
    public int MaxItemsPerOrder { get; set; }
    public int MaxQtyPerItem { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
