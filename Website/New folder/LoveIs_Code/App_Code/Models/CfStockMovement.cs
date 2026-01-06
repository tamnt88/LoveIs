using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_stock_movement")]
public class CfStockMovement
{
    public int Id { get; set; }

    public int VariantId { get; set; }

    [Required, StringLength(50)]
    public string MovementType { get; set; }

    public int Quantity { get; set; }

    [StringLength(300)]
    public string Note { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("VariantId")]
    public virtual CfProductVariant Variant { get; set; }
}
