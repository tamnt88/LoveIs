using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_seller_kyc")]
public class SellerKyc
{
    public int Id { get; set; }

    public int SellerId { get; set; }

    [ForeignKey("SellerId")]
    public virtual CfSeller Seller { get; set; }

    [StringLength(200)]
    public string FullName { get; set; }

    public DateTime? BirthDate { get; set; }

    [StringLength(50)]
    public string IdNumber { get; set; }

    public DateTime? IdIssuedDate { get; set; }

    [StringLength(200)]
    public string IdIssuedPlace { get; set; }

    [Required, StringLength(20)]
    public string Status { get; set; }

    [ForeignKey("Status")]
    public virtual SellerKycStatus StatusRef { get; set; }

    [StringLength(500)]
    public string RejectedReason { get; set; }

    public DateTime? ReviewedAt { get; set; }

    [StringLength(100)]
    public string ReviewedBy { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public virtual ICollection<SellerKycFile> Files { get; set; }
}

[Table("cf_seller_kyc_file")]
public class SellerKycFile
{
    public int Id { get; set; }

    public int SellerKycId { get; set; }

    [ForeignKey("SellerKycId")]
    public virtual SellerKyc SellerKyc { get; set; }

    [Required, StringLength(50)]
    public string FileType { get; set; }

    [ForeignKey("FileType")]
    public virtual SellerKycFileType FileTypeRef { get; set; }

    [Required, StringLength(500)]
    public string FileUrl { get; set; }

    [StringLength(200)]
    public string FileName { get; set; }

    public int? FileSize { get; set; }

    [StringLength(100)]
    public string MimeType { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }
}

[Table("cf_shop_document")]
public class ShopDocument
{
    public int Id { get; set; }

    public int ShopId { get; set; }

    [ForeignKey("ShopId")]
    public virtual CfShop Shop { get; set; }

    [Required, StringLength(50)]
    public string DocType { get; set; }

    [ForeignKey("DocType")]
    public virtual ShopDocumentType DocTypeRef { get; set; }

    [StringLength(100)]
    public string DocNumber { get; set; }

    public DateTime? IssuedDate { get; set; }

    public DateTime? ExpiredDate { get; set; }

    [Required, StringLength(20)]
    public string Status { get; set; }

    [ForeignKey("Status")]
    public virtual ShopDocumentStatus StatusRef { get; set; }

    [StringLength(500)]
    public string RejectedReason { get; set; }

    public DateTime? ReviewedAt { get; set; }

    [StringLength(100)]
    public string ReviewedBy { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public virtual ICollection<ShopDocumentFile> Files { get; set; }
}

[Table("cf_shop_document_file")]
public class ShopDocumentFile
{
    public int Id { get; set; }

    public int ShopDocumentId { get; set; }

    [ForeignKey("ShopDocumentId")]
    public virtual ShopDocument ShopDocument { get; set; }

    [Required, StringLength(50)]
    public string FileType { get; set; }

    [ForeignKey("FileType")]
    public virtual ShopDocumentFileType FileTypeRef { get; set; }

    [Required, StringLength(500)]
    public string FileUrl { get; set; }

    [StringLength(200)]
    public string FileName { get; set; }

    public int? FileSize { get; set; }

    [StringLength(100)]
    public string MimeType { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }
}

[Table("cf_seller_kyc_status")]
public class SellerKycStatus
{
    [Key, StringLength(20)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    public int SortOrder { get; set; }

    public bool Status { get; set; }

    public virtual ICollection<SellerKyc> SellerKycs { get; set; }
}

[Table("cf_shop_document_status")]
public class ShopDocumentStatus
{
    [Key, StringLength(20)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    public int SortOrder { get; set; }

    public bool Status { get; set; }

    public virtual ICollection<ShopDocument> ShopDocuments { get; set; }
}

[Table("cf_seller_kyc_file_type")]
public class SellerKycFileType
{
    [Key, StringLength(50)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    public int SortOrder { get; set; }

    public bool Status { get; set; }

    public virtual ICollection<SellerKycFile> SellerKycFiles { get; set; }
}

[Table("cf_shop_document_type")]
public class ShopDocumentType
{
    [Key, StringLength(50)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    public int SortOrder { get; set; }

    public bool Status { get; set; }

    public virtual ICollection<ShopDocument> ShopDocuments { get; set; }
}

[Table("cf_shop_document_file_type")]
public class ShopDocumentFileType
{
    [Key, StringLength(50)]
    public string Code { get; set; }

    [Required, StringLength(200)]
    public string Name { get; set; }

    public int SortOrder { get; set; }

    public bool Status { get; set; }

    public virtual ICollection<ShopDocumentFile> ShopDocumentFiles { get; set; }
}

