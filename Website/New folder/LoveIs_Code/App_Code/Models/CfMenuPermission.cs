using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_menu_permission")]
public class CfMenuPermission
{
    public int Id { get; set; }

    public int MenuId { get; set; }

    public int PermissionId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
