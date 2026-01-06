using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_social_link")]
public class CfSocialLink
{
    public int Id { get; set; }

    [StringLength(200)]
    public string DisplayName { get; set; }

    [StringLength(200)]
    public string IconClass { get; set; }

    [StringLength(500)]
    public string Url { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
