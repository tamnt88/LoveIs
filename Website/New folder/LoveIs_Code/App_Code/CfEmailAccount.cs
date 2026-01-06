using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_email_account")]
public class CfEmailAccount
{
    public int Id { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [StringLength(300)]
    public string Password { get; set; }

    [StringLength(200)]
    public string DisplayName { get; set; }

    public string ContactRecipientEmails { get; set; }

    public string OrderRecipientEmails { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
