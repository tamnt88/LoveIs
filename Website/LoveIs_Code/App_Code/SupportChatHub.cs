using System;
using System.Linq;
using System.Collections.Concurrent;
using Microsoft.AspNet.SignalR;

public class SupportChatHub : Hub
{
    private class ConnectionContext
    {
        public string SenderType { get; set; }
        public int SenderId { get; set; }
    }

    private static readonly ConcurrentDictionary<string, ConnectionContext> ConnectionUsers = new ConcurrentDictionary<string, ConnectionContext>();

    public void JoinChat(string chatId, string senderType, int senderId)
    {
        int parsedChatId;
        if (string.IsNullOrWhiteSpace(chatId) || !int.TryParse(chatId, out parsedChatId))
        {
            return;
        }

        if (!IsAuthorized(parsedChatId, senderType, senderId))
        {
            return;
        }

        ConnectionUsers[Context.ConnectionId] = new ConnectionContext
        {
            SenderType = (senderType ?? string.Empty).ToLowerInvariant(),
            SenderId = senderId
        };

        Groups.Add(Context.ConnectionId, BuildGroup(parsedChatId));
        Clients.Caller.joinedChat(parsedChatId);
    }

    public void LeaveChat(string chatId)
    {
        int parsedChatId;
        if (int.TryParse(chatId, out parsedChatId))
        {
            Groups.Remove(Context.ConnectionId, BuildGroup(parsedChatId));
        }

        ConnectionContext removed;
        ConnectionUsers.TryRemove(Context.ConnectionId, out removed);
    }

    public void SendMessage(int chatId, string message)
    {
        if (chatId <= 0 || string.IsNullOrWhiteSpace(message))
        {
            return;
        }

        ConnectionContext context;
        if (!ConnectionUsers.TryGetValue(Context.ConnectionId, out context))
        {
            return;
        }

        var senderType = (context.SenderType ?? string.Empty).ToLowerInvariant();
        if (!IsAuthorized(chatId, senderType, context.SenderId))
        {
            return;
        }

        var safeMessage = (message ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(safeMessage))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var chat = db.CfSupportChats.FirstOrDefault(c => c.Id == chatId && c.Status);
            if (chat == null)
            {
                return;
            }

            var newMessage = new CfSupportChatMessage
            {
                ChatId = chat.Id,
                SenderType = senderType,
                MessageType = "text",
                Message = safeMessage,
                CreatedAt = DateTime.Now
            };

            db.CfSupportChatMessages.Add(newMessage);
            chat.LastMessageAt = newMessage.CreatedAt;
            chat.LastMessageSender = senderType;
            db.SaveChanges();

            Clients.Group(BuildGroup(chatId)).newMessage(new
            {
                ChatId = chatId,
                SenderType = senderType,
                SenderId = context.SenderId,
                Message = safeMessage,
                MessageType = "text",
                CreatedAt = newMessage.CreatedAt.ToString("HH:mm")
            });
        }
    }

    public void MarkRead(int chatId, string senderType, int senderId)
    {
        if (chatId <= 0)
        {
            return;
        }

        if (!IsAuthorized(chatId, senderType, senderId))
        {
            return;
        }

        var normalizedType = (senderType ?? string.Empty).ToLowerInvariant();
        using (var db = new BeautyStoryContext())
        {
            var unread = db.CfSupportChatMessages
                .Where(m => m.ChatId == chatId && m.SenderType != normalizedType && m.ReadAt == null)
                .ToList();

            if (unread.Count == 0)
            {
                return;
            }

            var now = DateTime.Now;
            foreach (var msg in unread)
            {
                msg.ReadAt = now;
            }

            db.SaveChanges();
        }
    }

    private static string BuildGroup(int chatId)
    {
        return "support-chat-" + chatId.ToString(System.Globalization.CultureInfo.InvariantCulture);
    }

    private static bool IsAuthorized(int chatId, string senderType, int senderId)
    {
        if (chatId <= 0 || senderId <= 0 || string.IsNullOrWhiteSpace(senderType))
        {
            return false;
        }

        var normalizedType = senderType.ToLowerInvariant();
        using (var db = new BeautyStoryContext())
        {
            var chat = db.CfSupportChats.AsNoTracking().FirstOrDefault(c => c.Id == chatId && c.Status);
            if (chat == null)
            {
                return false;
            }

            if (normalizedType == "seller")
            {
                return chat.SellerId == senderId;
            }

            if (normalizedType == "admin")
            {
                return db.CfUsers.AsNoTracking().Any(u => u.Id == senderId && u.Status);
            }
        }

        return false;
    }
}
