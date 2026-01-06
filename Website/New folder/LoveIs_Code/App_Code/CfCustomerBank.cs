using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_customer_bank")]
public class CfCustomerBank
{
    public int Id { get; set; }
    public int CustomerId { get; set; }

    [StringLength(120)]
    public string BankName { get; set; }

    [StringLength(120)]
    public string AccountName { get; set; }

    [StringLength(50)]
    public string AccountNumber { get; set; }

    [StringLength(120)]
    public string Branch { get; set; }

    public bool IsDefault { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
