using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_category_filter_group")]
public class CfCategoryFilterGroup
{
    public int Id { get; set; }

    public int CategoryId { get; set; }

    public int GroupId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("CategoryId")]
    public virtual CfCategory Category { get; set; }

    [ForeignKey("GroupId")]
    public virtual CfFilterGroup Group { get; set; }
}
