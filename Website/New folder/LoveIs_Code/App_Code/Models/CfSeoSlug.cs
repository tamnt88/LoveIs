using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_seo_slug")]
public class CfSeoSlug
{
    public int Id { get; set; }

    [Required, StringLength(50)]
    public string EntityType { get; set; }

    public int EntityId { get; set; }

    [Required, StringLength(200)]
    public string SeoSlug { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
