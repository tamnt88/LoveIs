using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_role_permission")]
public class CfRolePermission
{
    public int Id { get; set; }

    public int RoleId { get; set; }

    public int PermissionId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
