using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_post")]
public class CfPost
{
    public CfPost()
    {
        PostTags = new HashSet<CfPostTagMap>();
    }

    public int Id { get; set; }

    public int CategoryId { get; set; }

    [Required, StringLength(300)]
    public string Title { get; set; }

    [StringLength(500)]
    public string Summary { get; set; }

    public string Content { get; set; }

    [StringLength(300)]
    public string FeaturedImage { get; set; }

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

    [ForeignKey("CategoryId")]
    public virtual CfPostCategory Category { get; set; }

    public virtual ICollection<CfPostTagMap> PostTags { get; set; }
}
