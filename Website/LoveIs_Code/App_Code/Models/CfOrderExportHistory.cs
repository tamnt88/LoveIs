using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_order_export_history")]
public class CfOrderExportHistory
{
    public int Id { get; set; }

    public int SellerId { get; set; }

    [StringLength(50)]
    public string StatusKey { get; set; }

    [StringLength(100)]
    public string SearchCode { get; set; }

    public int? ShippingMethodId { get; set; }

    public int TotalOrders { get; set; }

    [StringLength(200)]
    public string FileName { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
