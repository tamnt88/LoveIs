using System;

public static class ProductTagHelper
{
    public static string FormatTag(string value, string className)
    {
        if (string.IsNullOrWhiteSpace(value) || value == "-")
        {
            return "-";
        }

        return string.Format("<span class=\"info-tag {0}\">{1}</span>", className, value);
    }
}
