using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_audit_log")]
public class CfAuditLog
{
    public int Id { get; set; }

    [Required, StringLength(200)]
    public string TableName { get; set; }

    [Required, StringLength(100)]
    public string RecordId { get; set; }

    [Required, StringLength(50)]
    public string ActionName { get; set; }

    public string BeforeData { get; set; }

    public string AfterData { get; set; }

    public int? ActorUserId { get; set; }

    [StringLength(100)]
    public string ActorUsername { get; set; }

    [StringLength(50)]
    public string ActorIp { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    [StringLength(100)]
    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [StringLength(100)]
    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }
}
