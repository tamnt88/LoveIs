using System.Collections.Generic;

public class ActionResult
{
    public bool Success { get; set; }
    public string Message { get; set; }
}

public class DataTableResult<T>
{
    public int draw { get; set; }
    public int recordsTotal { get; set; }
    public int recordsFiltered { get; set; }
    public List<T> data { get; set; }
}
