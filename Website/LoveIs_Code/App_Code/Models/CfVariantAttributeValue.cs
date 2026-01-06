using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_variant_attribute_value")]
public class CfVariantAttributeValue
{
    public CfVariantAttributeValue()
    {
        ProductVariantAttributes = new HashSet<CfProductVariantAttribute>();
    }

    public int Id { get; set; }

    public int AttributeId { get; set; }

    [Required, StringLength(200)]
    public string ValueName { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("AttributeId")]
    public virtual CfVariantAttribute Attribute { get; set; }

    public virtual ICollection<CfProductVariantAttribute> ProductVariantAttributes { get; set; }
}
