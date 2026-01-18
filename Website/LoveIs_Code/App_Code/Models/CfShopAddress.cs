using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_shop_address")]
public class CfShopAddress
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    public int? WardId { get; set; }

    public int? ProvinceId { get; set; }

    [StringLength(200)]
    public string Title { get; set; }

    [StringLength(50)]
    public string AddressType { get; set; }

    [StringLength(120)]
    public string ContactName { get; set; }

    [StringLength(30)]
    public string Phone { get; set; }

    [StringLength(300)]
    public string AddressLine { get; set; }

    [StringLength(120)]
    public string WardName { get; set; }

    [StringLength(120)]
    public string ProvinceName { get; set; }

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
