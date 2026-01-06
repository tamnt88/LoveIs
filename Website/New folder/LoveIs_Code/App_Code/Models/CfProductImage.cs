using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_product_image")]
public class CfProductImage
{
    public int Id { get; set; }

    public int ProductId { get; set; }

    public int? VariantId { get; set; }

    [Required, StringLength(300)]
    public string ImageUrl { get; set; }

    public bool IsPrimary { get; set; }

    [StringLength(200)]
    public string AltText { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("ProductId")]
    public virtual CfProduct Product { get; set; }

    [ForeignKey("VariantId")]
    public virtual CfProductVariant Variant { get; set; }
}
