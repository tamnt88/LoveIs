using System;
using System.Linq;
using System.Collections.Concurrent;
using Microsoft.AspNet.SignalR;

public class ShopInquiryChatHub : Hub
{
    private class ConnectionContext
    {
        public string SenderType { get; set; }
        public int SenderId { get; set; }
    }

    private static readonly ConcurrentDictionary<string, ConnectionContext> ConnectionUsers = new ConcurrentDictionary<string, ConnectionContext>();

    public void JoinInquiry(string inquiryId, string senderType, int senderId)
    {
        int parsedInquiryId;
        if (string.IsNullOrWhiteSpace(inquiryId) || !int.TryParse(inquiryId, out parsedInquiryId))
        {
            return;
        }

        if (!IsAuthorized(parsedInquiryId, senderType, senderId))
        {
            return;
        }

        ConnectionUsers[Context.ConnectionId] = new ConnectionContext
        {
            SenderType = (senderType ?? string.Empty).ToLowerInvariant(),
            SenderId = senderId
        };

        Groups.Add(Context.ConnectionId, BuildGroup(parsedInquiryId));
        Clients.Caller.joinedInquiry(parsedInquiryId);
    }

    public void JoinSellerInquiries(int sellerId)
    {
        if (sellerId <= 0)
        {
            return;
        }

        ConnectionUsers[Context.ConnectionId] = new ConnectionContext
        {
            SenderType = "shop",
            SenderId = sellerId
        };

        Groups.Add(Context.ConnectionId, BuildSellerGroup(sellerId));
        Clients.Caller.joinedSeller(sellerId);
    }

    public void JoinCustomerInquiries(int customerId)
    {
        if (customerId <= 0)
        {
            return;
        }

        ConnectionUsers[Context.ConnectionId] = new ConnectionContext
        {
            SenderType = "customer",
            SenderId = customerId
        };

        Groups.Add(Context.ConnectionId, BuildCustomerGroup(customerId));
        Clients.Caller.joinedCustomer(customerId);
    }

    public void LeaveInquiry(string inquiryId)
    {
        int parsedInquiryId;
        if (int.TryParse(inquiryId, out parsedInquiryId))
        {
            Groups.Remove(Context.ConnectionId, BuildGroup(parsedInquiryId));
        }

        ConnectionContext removed;
        ConnectionUsers.TryRemove(Context.ConnectionId, out removed);
    }

    public void SendMessage(int inquiryId, string message)
    {
        if (inquiryId <= 0 || string.IsNullOrWhiteSpace(message))
        {
            return;
        }

        ConnectionContext context;
        if (!ConnectionUsers.TryGetValue(Context.ConnectionId, out context))
        {
            return;
        }

        var senderType = (context.SenderType ?? string.Empty).ToLowerInvariant();
        if (!IsAuthorized(inquiryId, senderType, context.SenderId))
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
            var inquiry = db.CfShopInquiries.FirstOrDefault(i => i.Id == inquiryId && i.Status);
            if (inquiry == null)
            {
                return;
            }

            var newMessage = new CfShopInquiryMessage
            {
                InquiryId = inquiry.Id,
                ShopId = inquiry.ShopId,
                CustomerId = inquiry.CustomerId,
                SenderType = senderType,
                MessageType = "text",
                Message = safeMessage,
                CreatedAt = DateTime.Now
            };

            db.CfShopInquiryMessages.Add(newMessage);

            if (senderType == "shop" && !inquiry.FirstReplyAt.HasValue)
            {
                inquiry.FirstReplyAt = DateTime.Now;
            }

            inquiry.LastReplyAt = DateTime.Now;
            inquiry.LastMessageAt = inquiry.LastReplyAt;
            inquiry.LastMessageSender = senderType;

            db.SaveChanges();

            Clients.Group(BuildGroup(inquiryId)).newMessage(new
            {
                InquiryId = inquiryId,
                SenderType = senderType,
                SenderId = context.SenderId,
                Message = safeMessage,
                MessageType = "text",
                CreatedAt = newMessage.CreatedAt.ToString("HH:mm")
            });

            var shop = db.CfShops.AsNoTracking().FirstOrDefault(s => s.Id == inquiry.ShopId);
            var sellerId = shop != null ? shop.SellerId : 0;
            var customer = db.CfCustomers.AsNoTracking().FirstOrDefault(c => c.Id == inquiry.CustomerId);
            var customerName = customer != null
                ? (!string.IsNullOrWhiteSpace(customer.DisplayName) ? customer.DisplayName : customer.Username)
                : ("Khach hang #" + inquiry.CustomerId);
            var shopName = shop != null ? shop.ShopName : ("Shop #" + inquiry.ShopId);
            var alertPayload = new
            {
                InquiryId = inquiryId,
                ShopId = inquiry.ShopId,
                CustomerId = inquiry.CustomerId,
                SenderType = senderType,
                SenderId = context.SenderId,
                Message = safeMessage,
                MessageType = "text",
                CreatedAt = newMessage.CreatedAt.ToString("HH:mm"),
                CustomerName = customerName,
                ShopName = shopName
            };
            if (sellerId > 0)
            {
                Clients.Group(BuildSellerGroup(sellerId)).newMessageAlert(alertPayload);
            }
            Clients.Group(BuildCustomerGroup(inquiry.CustomerId)).newMessageAlert(alertPayload);
        }
    }

    public void MarkRead(int inquiryId, string senderType, int senderId)
    {
        if (inquiryId <= 0)
        {
            return;
        }

        if (!IsAuthorized(inquiryId, senderType, senderId))
        {
            return;
        }

        var normalizedType = (senderType ?? string.Empty).ToLowerInvariant();
        using (var db = new BeautyStoryContext())
        {
            var unread = db.CfShopInquiryMessages
                .Where(m => m.InquiryId == inquiryId && m.SenderType != normalizedType && m.ReadAt == null)
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

    private static string BuildGroup(int inquiryId)
    {
        return "shop-inquiry-" + inquiryId.ToString(System.Globalization.CultureInfo.InvariantCulture);
    }

    private static string BuildSellerGroup(int sellerId)
    {
        return "shop-inquiry-seller-" + sellerId.ToString(System.Globalization.CultureInfo.InvariantCulture);
    }

    private static string BuildCustomerGroup(int customerId)
    {
        return "shop-inquiry-customer-" + customerId.ToString(System.Globalization.CultureInfo.InvariantCulture);
    }

    private static bool IsAuthorized(int inquiryId, string senderType, int senderId)
    {
        if (inquiryId <= 0 || senderId <= 0 || string.IsNullOrWhiteSpace(senderType))
        {
            return false;
        }

        var normalizedType = senderType.ToLowerInvariant();
        using (var db = new BeautyStoryContext())
        {
            var inquiry = db.CfShopInquiries.AsNoTracking().FirstOrDefault(i => i.Id == inquiryId && i.Status);
            if (inquiry == null)
            {
                return false;
            }

            if (normalizedType == "customer")
            {
                return inquiry.CustomerId == senderId;
            }

            if (normalizedType == "shop")
            {
                return db.CfShops.AsNoTracking().Any(s => s.Id == inquiry.ShopId && s.SellerId == senderId);
            }
        }

        return false;
    }
}
