using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_product_variant")]
public class CfProductVariant
{
    public CfProductVariant()
    {
        Images = new HashSet<CfProductImage>();
        VariantAttributes = new HashSet<CfProductVariantAttribute>();
        StockMovements = new HashSet<CfStockMovement>();
    }

    public int Id { get; set; }

    public int ProductId { get; set; }

    [StringLength(200)]
    public string VariantName { get; set; }

    [StringLength(100)]
    public string Sku { get; set; }

    public decimal Price { get; set; }

    public decimal? SalePrice { get; set; }

    public int StockQty { get; set; }

    public string Description { get; set; }

    public string Specification { get; set; }

    public string Ingredients { get; set; }

    public string Usage { get; set; }

    [StringLength(200)]
    public string SeoTitle { get; set; }

    [StringLength(500)]
    public string SeoDescription { get; set; }

    [StringLength(300)]
    public string SeoKeywords { get; set; }

    [StringLength(200)]
    public string OgTitle { get; set; }

    [StringLength(500)]
    public string OgDescription { get; set; }

    [StringLength(300)]
    public string OgImage { get; set; }

    [StringLength(50)]
    public string OgType { get; set; }

    [StringLength(200)]
    public string TwitterTitle { get; set; }

    [StringLength(500)]
    public string TwitterDescription { get; set; }

    [StringLength(300)]
    public string TwitterImage { get; set; }

    [StringLength(300)]
    public string CanonicalUrl { get; set; }

    [StringLength(50)]
    public string Robots { get; set; }

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

    public virtual ICollection<CfProductImage> Images { get; set; }

    public virtual ICollection<CfProductVariantAttribute> VariantAttributes { get; set; }

    public virtual ICollection<CfStockMovement> StockMovements { get; set; }
}
