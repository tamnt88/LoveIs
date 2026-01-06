using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_product")]
public class CfProduct
{
    public CfProduct()
    {
        Variants = new HashSet<CfProductVariant>();
        Images = new HashSet<CfProductImage>();
        Filters = new HashSet<CfProductFilter>();
    }

    public int Id { get; set; }

    [Required, StringLength(300)]
    public string ProductName { get; set; }

    public int CategoryId { get; set; }

    public int? BrandId { get; set; }

    public int? OriginId { get; set; }

    public int? ShopId { get; set; }

    [StringLength(500)]
    public string ShortDescription { get; set; }

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

    public bool IsNewArrival { get; set; }

    public bool IsTrending { get; set; }

    public bool IsBestSelling { get; set; }

    public int ViewCount { get; set; }

    public int AddToCartCount { get; set; }

    public int Sold30d { get; set; }

    public decimal RatingAvg { get; set; }

    public int RatingCount { get; set; }

    public int ContentScore { get; set; }

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

    [ForeignKey("BrandId")]
    public virtual CfBrand Brand { get; set; }

    [ForeignKey("OriginId")]
    public virtual CfOrigin Origin { get; set; }

    [ForeignKey("ShopId")]
    public virtual CfShop Shop { get; set; }

    public virtual ICollection<CfProductVariant> Variants { get; set; }

    public virtual ICollection<CfProductImage> Images { get; set; }

    public virtual ICollection<CfProductFilter> Filters { get; set; }
}
