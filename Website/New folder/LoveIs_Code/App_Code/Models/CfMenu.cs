using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_menu")]
public class CfMenu
{
    public int Id { get; set; }

    [Required, StringLength(200)]
    public string MenuName { get; set; }

    [Required, StringLength(100)]
    public string MenuGroup { get; set; }

    [StringLength(300)]
    public string Url { get; set; }

    public int? ParentId { get; set; }

    [StringLength(100)]
    public string Icon { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
