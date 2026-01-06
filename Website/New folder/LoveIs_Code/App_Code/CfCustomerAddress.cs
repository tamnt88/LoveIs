using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_customer_address")]
public class CfCustomerAddress
{
    public int Id { get; set; }
    public int CustomerId { get; set; }

    [StringLength(200)]
    public string FullName { get; set; }

    [StringLength(30)]
    public string Phone { get; set; }

    [StringLength(300)]
    public string AddressLine { get; set; }

    public int? WardId { get; set; }
    public int? ProvinceId { get; set; }

    [StringLength(120)]
    public string WardName { get; set; }

    [StringLength(120)]
    public string ProvinceName { get; set; }

    public bool IsDefault { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
