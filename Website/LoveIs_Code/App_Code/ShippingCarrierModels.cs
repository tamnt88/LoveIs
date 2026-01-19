using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_shipping_carrier")]
public class CfShippingCarrier
{
    public int Id { get; set; }

    [Required, StringLength(50)]
    public string Code { get; set; }

    [Required, StringLength(255)]
    public string Name { get; set; }

    [StringLength(1000)]
    public string Description { get; set; }

    [StringLength(255)]
    public string ContactName { get; set; }

    [StringLength(50)]
    public string ContactPhone { get; set; }

    [StringLength(255)]
    public string ContactEmail { get; set; }

    [StringLength(500)]
    public string LogoUrl { get; set; }

    [StringLength(255)]
    public string ClientId { get; set; }

    [StringLength(255)]
    public string ShopId { get; set; }

    [StringLength(255)]
    public string ApiToken { get; set; }

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

[Table("cf_shipping_carrier_method")]
public class CfShippingCarrierMethod
{
    public int Id { get; set; }

    public int CarrierId { get; set; }

    public int ShippingMethodId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }
}

[Table("cf_shop_shipping_config")]
public class CfShopShippingConfig
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int DefaultShippingMethodId { get; set; }

    public bool FreeShippingEnabled { get; set; }

    public decimal FreeShippingMinOrder { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public int? DefaultShippingCarrierId { get; set; }
}

[Table("cf_shop_shipping_carrier")]
public class CfShopShippingCarrier
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int CarrierId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }
}
