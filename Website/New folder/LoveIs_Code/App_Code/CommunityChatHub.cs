using System;
using System.Linq;
using System.Collections.Concurrent;
using Microsoft.AspNet.SignalR;

public class CommunityChatHub : Hub
{
    private static readonly ConcurrentDictionary<string, int> ConnectionUsers = new ConcurrentDictionary<string, int>();

    public void JoinRoom(string roomId, int customerId)
    {
        int parsedRoomId;
        if (string.IsNullOrWhiteSpace(roomId) || !int.TryParse(roomId, out parsedRoomId) || customerId <= 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var member = db.CfCommunityRoomMembers.FirstOrDefault(m => m.RoomId == parsedRoomId && m.CustomerId == customerId && m.Status);
            if (member == null)
            {
                return;
            }
        }

        ConnectionUsers[Context.ConnectionId] = customerId;
        Groups.Add(Context.ConnectionId, roomId);
        Clients.Caller.joinedRoom(roomId);
    }

    public void LeaveRoom(string roomId)
    {
        if (!string.IsNullOrWhiteSpace(roomId))
        {
            Groups.Remove(Context.ConnectionId, roomId);
        }
        int removed;
        ConnectionUsers.TryRemove(Context.ConnectionId, out removed);
    }

    public void SendMessage(int roomId, string message)
    {
        if (roomId <= 0 || string.IsNullOrWhiteSpace(message))
        {
            return;
        }

        int customerId;
        if (!ConnectionUsers.TryGetValue(Context.ConnectionId, out customerId))
        {
            return;
        }

        var safeMessage = (message ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(safeMessage))
        {
            return;
        }

        if (!CommunityHelper.HasOnlyWhitelistedLinks(safeMessage))
        {
            Clients.Caller.chatError("Nội dung chứa liên kết không được phép.");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var member = db.CfCommunityRoomMembers.FirstOrDefault(m => m.RoomId == roomId && m.CustomerId == customerId && m.Status);
            if (member == null)
            {
                return;
            }

            var chatMessage = new CfCommunityMessage
            {
                RoomId = roomId,
                SenderId = customerId,
                Content = safeMessage,
                Status = true,
                CreatedAt = DateTime.UtcNow
            };

            db.CfCommunityMessages.Add(chatMessage);
            db.SaveChanges();

            var senderName = db.CfCustomers.Where(c => c.Id == customerId)
                .Select(c => string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName)
                .FirstOrDefault();

            Clients.Group(roomId.ToString()).newMessage(new
            {
                RoomId = roomId,
                SenderId = customerId,
                SenderName = senderName ?? "User",
                Content = safeMessage,
                CreatedAt = chatMessage.CreatedAt.ToString("HH:mm")
            });

            var members = db.CfCommunityRoomMembers
                .Where(m => m.RoomId == roomId && m.Status)
                .Select(m => m.CustomerId)
                .ToList();
            foreach (var memberId in members.Where(id => id != customerId))
            {
                CommunityNotificationHelper.Notify(memberId, "message", chatMessage.Id, "Tin nhắn mới từ " + (senderName ?? "User"));
            }
        }
    }
}
