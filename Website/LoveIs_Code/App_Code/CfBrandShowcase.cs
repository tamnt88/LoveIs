using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_brand_showcase")]
public class CfBrandShowcase
{
    public int Id { get; set; }

    public int BrandId { get; set; }

    [StringLength(200)]
    public string Title { get; set; }

    [StringLength(500)]
    public string VideoUrl { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }

    public virtual ICollection<CfBrandShowcaseBanner> Banners { get; set; }
}
