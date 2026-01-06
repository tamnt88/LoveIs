using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_permission")]
public class CfPermission
{
    public int Id { get; set; }

    [Required, StringLength(100)]
    public string MenuGroup { get; set; }

    [Required, StringLength(100)]
    public string ActionName { get; set; }

    [StringLength(200)]
    public string PermissionName { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
