using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_product_variant_attribute")]
public class CfProductVariantAttribute
{
    public int Id { get; set; }

    public int VariantId { get; set; }

    public int AttributeId { get; set; }

    public int AttributeValueId { get; set; }

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

    [ForeignKey("AttributeId")]
    public virtual CfVariantAttribute Attribute { get; set; }

    [ForeignKey("AttributeValueId")]
    public virtual CfVariantAttributeValue AttributeValue { get; set; }
}
