using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_user")]
public class CfUser
{
    public int Id { get; set; }

    [Required, StringLength(100)]
    public string Username { get; set; }

    [StringLength(200)]
    public string DisplayName { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [Required]
    public byte[] PasswordHash { get; set; }

    [Required]
    public byte[] PasswordSalt { get; set; }

    public int PasswordIterations { get; set; }

    public DateTime? LastLoginAt { get; set; }

    public DateTime? LockedUntil { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
