using System;

public static class ChatPresenceHelper
{
    public static bool IsOnline(DateTime? lastLoginAtUtc)
    {
        if (!lastLoginAtUtc.HasValue)
        {
            return false;
        }

        var now = DateTime.UtcNow;
        var last = DateTime.SpecifyKind(lastLoginAtUtc.Value, DateTimeKind.Utc);
        return (now - last).TotalMinutes <= 15;
    }

    public static string BuildStatusCssClass(string baseClass, DateTime? lastLoginAtUtc)
    {
        return IsOnline(lastLoginAtUtc) ? baseClass : (baseClass + " is-offline");
    }

    public static string BuildStatusText(DateTime? lastLoginAtUtc)
    {
        if (!lastLoginAtUtc.HasValue)
        {
            return "Offline";
        }

        var now = DateTime.UtcNow;
        var last = DateTime.SpecifyKind(lastLoginAtUtc.Value, DateTimeKind.Utc);
        var diff = now - last;
        if (diff.TotalMinutes <= 15)
        {
            return "Đang hoạt động";
        }

        if (diff.TotalMinutes < 1)
        {
            return "Offline • vừa xong";
        }

        if (diff.TotalHours < 1)
        {
            var minutes = Math.Max(1, (int)Math.Floor(diff.TotalMinutes));
            return "Offline • " + minutes + " phút trước";
        }

        if (diff.TotalDays < 1)
        {
            var hours = Math.Max(1, (int)Math.Floor(diff.TotalHours));
            return "Offline • " + hours + " giờ trước";
        }

        var days = Math.Max(1, (int)Math.Floor(diff.TotalDays));
        return "Offline • " + days + " ngày trước";
    }
}
