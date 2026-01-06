using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_filter_group")]
public class CfFilterGroup
{
    public CfFilterGroup()
    {
        Options = new HashSet<CfFilterOption>();
        CategoryFilterGroups = new HashSet<CfCategoryFilterGroup>();
        ProductFilters = new HashSet<CfProductFilter>();
    }

    public int Id { get; set; }

    [Required, StringLength(200)]
    public string GroupName { get; set; }

    public string Description { get; set; }

    [StringLength(200)]
    public string SeoTitle { get; set; }

    [StringLength(500)]
    public string SeoDescription { get; set; }

    [StringLength(300)]
    public string SeoKeywords { get; set; }

    [StringLength(200)]
    public string OgTitle { get; set; }

    [StringLength(500)]
    public string OgDescription { get; set; }

    [StringLength(300)]
    public string OgImage { get; set; }

    [StringLength(50)]
    public string OgType { get; set; }

    [StringLength(200)]
    public string TwitterTitle { get; set; }

    [StringLength(500)]
    public string TwitterDescription { get; set; }

    [StringLength(300)]
    public string TwitterImage { get; set; }

    [StringLength(300)]
    public string CanonicalUrl { get; set; }

    [StringLength(50)]
    public string Robots { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<CfFilterOption> Options { get; set; }

    public virtual ICollection<CfCategoryFilterGroup> CategoryFilterGroups { get; set; }

    public virtual ICollection<CfProductFilter> ProductFilters { get; set; }
}
