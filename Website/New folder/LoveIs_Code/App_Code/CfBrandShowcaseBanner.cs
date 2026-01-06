using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_brand_showcase_banner")]
public class CfBrandShowcaseBanner
{
    public int Id { get; set; }

    public int ShowcaseId { get; set; }

    public virtual CfBrandShowcase Showcase { get; set; }

    [StringLength(200)]
    public string TitleLine1 { get; set; }

    [StringLength(200)]
    public string TitleLine2 { get; set; }

    [StringLength(200)]
    public string TitleLine3 { get; set; }

    [StringLength(500)]
    public string ImageUrl { get; set; }

    [StringLength(500)]
    public string LinkUrl { get; set; }

    [StringLength(200)]
    public string LinkText { get; set; }

    public bool ShowLink { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
