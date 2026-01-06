using System;

[System.ComponentModel.DataAnnotations.Schema.Table("cf_order_item")]
public class CfOrderItem
{
    public int Id { get; set; }
    public int OrderId { get; set; }
    public int ProductId { get; set; }
    public int VariantId { get; set; }
    public string ProductName { get; set; }
    public string VariantName { get; set; }
    public int Quantity { get; set; }
    public decimal Price { get; set; }
    public decimal? SalePrice { get; set; }
    public decimal LineTotal { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }

    public virtual CfOrder Order { get; set; }
}
