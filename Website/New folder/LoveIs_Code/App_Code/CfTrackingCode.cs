using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_tracking_code")]
public class CfTrackingCode
{
    public int Id { get; set; }

    public string HeaderCode { get; set; }
    public string BodyCode { get; set; }

    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
