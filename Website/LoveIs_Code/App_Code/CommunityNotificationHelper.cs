using System;

public static class CommunityNotificationHelper
{
    public static void Notify(int customerId, string type, int? referenceId, string message)
    {
        using (var db = new BeautyStoryContext())
        {
            db.CfCommunityNotifications.Add(new CfCommunityNotification
            {
                CustomerId = customerId,
                Type = type,
                ReferenceId = referenceId,
                Message = message ?? string.Empty,
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            });
            db.SaveChanges();
        }
    }
}
