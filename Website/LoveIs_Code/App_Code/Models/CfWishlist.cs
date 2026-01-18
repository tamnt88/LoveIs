using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_wishlist")]
public class CfWishlist
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public int ProductId { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
