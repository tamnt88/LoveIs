using System.Collections.Generic;

public class AdminMenuItem
{
    public int Id { get; set; }
    public string MenuName { get; set; }
    public string Url { get; set; }
    public string Icon { get; set; }
    public int SortOrder { get; set; }
    public bool Status { get; set; }
    public int? ParentId { get; set; }

    public AdminMenuItem()
    {
        Children = new List<AdminMenuItem>();
    }

    public List<AdminMenuItem> Children { get; set; }
}
