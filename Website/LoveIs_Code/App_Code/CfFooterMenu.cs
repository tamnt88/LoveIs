using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_footer_menu")]
public class CfFooterMenu
{
    public int Id { get; set; }
    public string GroupName { get; set; }
    public int GroupSortOrder { get; set; }
    public string Title { get; set; }
    public string Url { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    public int SortOrder { get; set; }
}
