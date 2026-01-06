using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_system_setting")]
public class CfSystemSetting
{
    public int Id { get; set; }

    [Required, StringLength(200)]
    public string Key { get; set; }

    public string Value { get; set; }

    [StringLength(100)]
    public string Group { get; set; }

    [StringLength(500)]
    public string Description { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
