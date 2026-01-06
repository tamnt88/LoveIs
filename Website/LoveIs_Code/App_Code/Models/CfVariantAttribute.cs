using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_variant_attribute")]
public class CfVariantAttribute
{
    public CfVariantAttribute()
    {
        Values = new HashSet<CfVariantAttributeValue>();
        ProductVariantAttributes = new HashSet<CfProductVariantAttribute>();
    }

    public int Id { get; set; }

    [Required, StringLength(200)]
    public string AttributeName { get; set; }

    public string Description { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<CfVariantAttributeValue> Values { get; set; }

    public virtual ICollection<CfProductVariantAttribute> ProductVariantAttributes { get; set; }
}
