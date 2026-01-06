using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_banner")]
public class CfBanner
{
    public int Id { get; set; }

    [StringLength(200)]
    public string TitleLine1 { get; set; }

    [StringLength(200)]
    public string TitleLine2 { get; set; }

    [StringLength(200)]
    public string TitleLine3 { get; set; }

    [StringLength(500)]
    public string ImageUrl { get; set; }

    [StringLength(20)]
    public string MediaType { get; set; }

    [StringLength(500)]
    public string MediaUrl { get; set; }

    [StringLength(500)]
    public string PosterUrl { get; set; }

    [StringLength(500)]
    public string LinkUrl { get; set; }

    [StringLength(200)]
    public string LinkText { get; set; }

    public bool ShowLink { get; set; }

    [StringLength(100)]
    public string Position { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
