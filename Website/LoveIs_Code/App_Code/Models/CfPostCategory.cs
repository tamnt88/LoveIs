using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_post_category")]
public class CfPostCategory
{
    public CfPostCategory()
    {
        Posts = new HashSet<CfPost>();
        Children = new HashSet<CfPostCategory>();
    }

    public int Id { get; set; }

    public int? ParentId { get; set; }

    [Required, StringLength(200)]
    public string CategoryName { get; set; }

    public string Description { get; set; }

    [StringLength(300)]
    public string ImageUrl { get; set; }

    [StringLength(300)]
    public string BannerUrl { get; set; }

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

    public int ViewCount { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<CfPost> Posts { get; set; }

    public virtual CfPostCategory Parent { get; set; }

    public virtual ICollection<CfPostCategory> Children { get; set; }
}
