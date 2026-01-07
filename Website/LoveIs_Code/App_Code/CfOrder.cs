using System;
using System.Collections.Generic;

[System.ComponentModel.DataAnnotations.Schema.Table("cf_order")]
public class CfOrder
{
    public int Id { get; set; }
    public string OrderCode { get; set; }
    public int? CustomerId { get; set; }
    public string CustomerName { get; set; }
    public string Phone { get; set; }
    public string AddressLine { get; set; }
    public int? WardId { get; set; }
    public int? ProvinceId { get; set; }
    public string WardName { get; set; }
    public string ProvinceName { get; set; }
    public string Note { get; set; }
    public bool InvoiceRequired { get; set; }
    public string InvoiceCompanyName { get; set; }
    public string InvoiceTaxCode { get; set; }
    public string InvoiceEmail { get; set; }
    public string InvoiceAddress { get; set; }
    public int? ShippingMethodId { get; set; }
    public string ShippingMethod { get; set; }
    public decimal ShippingFee { get; set; }
    public decimal? ShippingFeePercent { get; set; }
    public decimal? ShippingFeeAmount { get; set; }
    public string ShippingEta { get; set; }
    public int? PaymentMethodId { get; set; }
    public string PaymentMethod { get; set; }
    public int? PaymentStatusId { get; set; }
    public string PaymentStatus { get; set; }
    public decimal? PaymentFeePercent { get; set; }
    public decimal? PaymentFeeAmount { get; set; }
    public int? OrderStatusId { get; set; }
    public string OrderStatus { get; set; }
    public decimal Subtotal { get; set; }
    public decimal Discount { get; set; }
    public decimal? PlatformFeePercent { get; set; }
    public decimal? PlatformFeeAmount { get; set; }
    public decimal? InfrastructureFee { get; set; }
    public decimal Total { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }

    public virtual ICollection<CfOrderItem> Items { get; set; }
    public virtual ICollection<CfOrderHistory> Histories { get; set; }
}
