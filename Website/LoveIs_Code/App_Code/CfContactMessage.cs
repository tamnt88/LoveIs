using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_contact_message")]
public class CfContactMessage
{
    public int Id { get; set; }

    [StringLength(200)]
    public string FullName { get; set; }

    [StringLength(50)]
    public string Phone { get; set; }

    [StringLength(200)]
    public string Email { get; set; }

    [StringLength(300)]
    public string Subject { get; set; }

    public string Message { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
}
