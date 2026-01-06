using System;
using System.Linq;

public static class SystemSettingHelper
{
    public static string GetValue(string key, string defaultValue = "")
    {
        using (var db = new BeautyStoryContext())
        {
            var setting = db.CfSystemSettings.FirstOrDefault(s => s.Key == key && s.Status);
            return setting != null ? setting.Value : defaultValue;
        }
    }

    public static void SetValue(string key, string value, string group, string description, string updatedBy)
    {
        using (var db = new BeautyStoryContext())
        {
            var setting = db.CfSystemSettings.FirstOrDefault(s => s.Key == key);
            if (setting == null)
            {
                setting = new CfSystemSetting
                {
                    Key = key,
                    Group = group,
                    Description = description,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    SortOrder = 0
                };
                db.CfSystemSettings.Add(setting);
            }

            setting.Value = value;
            setting.UpdatedAt = DateTime.Now;
            setting.UpdatedBy = updatedBy;
            db.SaveChanges();
        }
    }
}
