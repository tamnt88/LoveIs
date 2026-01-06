using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_customer")]
public class CfCustomer
{
    public int Id { get; set; }

    [Required, StringLength(100)]
    public string Username { get; set; }

    [StringLength(200)]
    public string DisplayName { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [StringLength(30)]
    public string Phone { get; set; }

    [Required]
    public byte[] PasswordHash { get; set; }

    [Required]
    public byte[] PasswordSalt { get; set; }

    public int PasswordIterations { get; set; }

    public DateTime? LastLoginAt { get; set; }

    public DateTime? LockedUntil { get; set; }

    public bool Status { get; set; }

    public bool EmailVerified { get; set; }

    [StringLength(200)]
    public string EmailVerifyToken { get; set; }

    public DateTime? EmailVerifyExpiresAt { get; set; }

    public int? Gender { get; set; }

    public DateTime? BirthDate { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    public bool IsSeller { get; set; }

    public int? SellerId { get; set; }
}
