using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_system_page")]
public class CfSystemPage
{
    public int Id { get; set; }

    [StringLength(100)]
    public string PageKey { get; set; }

    [StringLength(255)]
    public string PageName { get; set; }

    public int? StaticPageId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("StaticPageId")]
    public virtual CfStaticPage StaticPage { get; set; }
}
