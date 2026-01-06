using System;

[System.ComponentModel.DataAnnotations.Schema.Table("cf_order_history")]
public class CfOrderHistory
{
    public int Id { get; set; }
    public int OrderId { get; set; }
    public string Action { get; set; }
    public string Note { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }

    public virtual CfOrder Order { get; set; }
}
