using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_product_filter")]
public class CfProductFilter
{
    public int Id { get; set; }

    public int ProductId { get; set; }

    public int GroupId { get; set; }

    public int OptionId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("ProductId")]
    public virtual CfProduct Product { get; set; }

    [ForeignKey("GroupId")]
    public virtual CfFilterGroup Group { get; set; }

    [ForeignKey("OptionId")]
    public virtual CfFilterOption Option { get; set; }
}
