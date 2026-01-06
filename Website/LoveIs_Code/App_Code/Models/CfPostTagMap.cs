using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_post_tag_map")]
public class CfPostTagMap
{
    public int Id { get; set; }

    public int PostId { get; set; }

    public int TagId { get; set; }

    public bool Status { get; set; }

    public DateTime CreatedAt { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public string UpdatedBy { get; set; }

    public int SortOrder { get; set; }

    [ForeignKey("PostId")]
    public virtual CfPost Post { get; set; }

    [ForeignKey("TagId")]
    public virtual CfPostTag Tag { get; set; }
}
