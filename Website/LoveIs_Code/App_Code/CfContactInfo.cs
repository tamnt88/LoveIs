using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_contact_info")]
public class CfContactInfo
{
    public int Id { get; set; }

    [StringLength(200)]
    public string CompanyName { get; set; }

    [StringLength(100)]
    public string Hotline { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [StringLength(500)]
    public string Address { get; set; }

    [StringLength(500)]
    public string GoogleMapUrl { get; set; }

    public string GoogleMapEmbed { get; set; }

    [StringLength(500)]
    public string LogoHorizontalUrl { get; set; }

    [StringLength(500)]
    public string LogoVerticalUrl { get; set; }

    [StringLength(500)]
    public string FaviconUrl { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
