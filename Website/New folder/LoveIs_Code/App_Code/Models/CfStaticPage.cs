using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_static_page")]
public class CfStaticPage
{
    public CfStaticPage()
    {
        SystemPages = new HashSet<CfSystemPage>();
    }

    public int Id { get; set; }

    [StringLength(255)]
    public string PageName { get; set; }

    public string Content { get; set; }

    [StringLength(255)]
    public string SeoTitle { get; set; }

    [StringLength(500)]
    public string SeoDescription { get; set; }

    [StringLength(500)]
    public string SeoKeywords { get; set; }

    [StringLength(500)]
    public string CanonicalUrl { get; set; }

    [StringLength(200)]
    public string Robots { get; set; }

    [StringLength(255)]
    public string OgTitle { get; set; }

    [StringLength(500)]
    public string OgDescription { get; set; }

    [StringLength(500)]
    public string OgImage { get; set; }

    [StringLength(50)]
    public string OgType { get; set; }

    [StringLength(255)]
    public string TwitterTitle { get; set; }

    [StringLength(500)]
    public string TwitterDescription { get; set; }

    [StringLength(500)]
    public string TwitterImage { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<CfSystemPage> SystemPages { get; set; }
}
