using System;
using System.Linq;
using System.Collections.Generic;

public partial class CommunityChat : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CommunityUserHelper.EnsureCommunityCustomerId().HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/cong-dong/chat.aspx";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        if (!IsPostBack)
        {
            BindRooms();
            BindMessages();
        }
    }

    private void BindRooms()
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var groupRooms = (from rm in db.CfCommunityRoomMembers
                              join r in db.CfCommunityRooms on rm.RoomId equals r.Id
                              where rm.CustomerId == customerId.Value && rm.Status && r.Status && r.IsGroup
                              orderby r.CreatedAt descending
                              select new
                              {
                                  r.Id,
                                  r.RoomName,
                                  r.CreatedAt
                              }).ToList();

            var directRooms = (from rm in db.CfCommunityRoomMembers
                               join r in db.CfCommunityRooms on rm.RoomId equals r.Id
                               join other in db.CfCommunityRoomMembers on r.Id equals other.RoomId
                               where rm.CustomerId == customerId.Value && rm.Status && other.Status
                                     && r.Status && !r.IsGroup
                                     && other.CustomerId != customerId.Value
                               select new
                               {
                                   RoomId = r.Id,
                                   r.CreatedAt,
                                   OtherId = other.CustomerId
                               }).ToList();

            var directLatest = directRooms
                .GroupBy(x => x.OtherId)
                .Select(g => g.OrderByDescending(x => x.CreatedAt).First())
                .ToList();

            int activeId = GetRoomId();
            var view = new List<object>();
            view.AddRange(groupRooms.Select(r => new
            {
                RoomId = r.Id,
                RoomName = string.IsNullOrWhiteSpace(r.RoomName) ? "Nhóm chat" : r.RoomName,
                ActiveClass = r.Id == activeId ? "active" : string.Empty,
                SortKey = r.CreatedAt
            }));
            view.AddRange(directLatest.Select(r => new
            {
                RoomId = r.RoomId,
                RoomName = GetRoomDisplayName(db, r.RoomId, false, customerId.Value),
                ActiveClass = r.RoomId == activeId ? "active" : string.Empty,
                SortKey = r.CreatedAt
            }));

            var sorted = view
                .OrderByDescending(v => (DateTime)((dynamic)v).SortKey)
                .Select(v => new
                {
                    RoomId = ((dynamic)v).RoomId,
                    RoomName = ((dynamic)v).RoomName,
                    ActiveClass = ((dynamic)v).ActiveClass
                })
                .ToList();

            RoomRepeater.DataSource = sorted;
            RoomRepeater.DataBind();
        }
    }

    private void BindMessages()
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        int roomId = GetRoomId();
        RoomIdField.Value = roomId.ToString();
        CurrentUserIdField.Value = customerId.Value.ToString();

        if (roomId <= 0)
        {
            ChatStatus.Text = "Chọn một cuộc trò chuyện để bắt đầu.";
            MessageRepeater.DataSource = null;
            MessageRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var member = db.CfCommunityRoomMembers.FirstOrDefault(m => m.RoomId == roomId && m.CustomerId == customerId.Value && m.Status);
            if (member == null)
            {
                ChatStatus.Text = "Bạn không có quyền truy cập phòng này.";
                MessageRepeater.DataSource = null;
                MessageRepeater.DataBind();
                return;
            }

            var messages = db.CfCommunityMessages
                .Where(m => m.RoomId == roomId && m.Status)
                .OrderBy(m => m.CreatedAt)
                .Take(200)
                .ToList();

            var senderLookup = db.CfCustomers.ToDictionary(c => c.Id, c => string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName);

            var view = messages.Select(m => new
            {
                SenderName = senderLookup.ContainsKey(m.SenderId) ? senderLookup[m.SenderId] : "User",
                Content = System.Web.HttpUtility.HtmlDecode(m.Content),
                CreatedAt = m.CreatedAt.ToString("HH:mm"),
                CssClass = m.SenderId == customerId.Value ? "me" : string.Empty
            }).ToList();

            MessageRepeater.DataSource = view;
            MessageRepeater.DataBind();
            var lastId = messages.Count > 0 ? messages.Max(m => m.Id) : 0;
            LastMessageIdField.Value = lastId.ToString();
        }
    }

    [System.Web.Services.WebMethod]
    public static List<ChatMessageDto> GetMessages(int roomId, int lastId)
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue || roomId <= 0)
        {
            return new List<ChatMessageDto>();
        }

        using (var db = new BeautyStoryContext())
        {
            var member = db.CfCommunityRoomMembers.FirstOrDefault(m => m.RoomId == roomId && m.CustomerId == customerId.Value && m.Status);
            if (member == null)
            {
                return new List<ChatMessageDto>();
            }

            var messages = db.CfCommunityMessages
                .Where(m => m.RoomId == roomId && m.Status && m.Id > lastId)
                .OrderBy(m => m.CreatedAt)
                .ToList();

            if (messages.Count == 0)
            {
                return new List<ChatMessageDto>();
            }

            var senderIds = messages.Select(m => m.SenderId).Distinct().ToList();
            var senderLookup = db.CfCustomers
                .Where(c => senderIds.Contains(c.Id))
                .ToDictionary(c => c.Id, c => string.IsNullOrWhiteSpace(c.DisplayName) ? c.Username : c.DisplayName);

            return messages.Select(m => new ChatMessageDto
            {
                Id = m.Id,
                SenderId = m.SenderId,
                SenderName = senderLookup.ContainsKey(m.SenderId) ? senderLookup[m.SenderId] : "User",
                Content = System.Web.HttpUtility.HtmlDecode(m.Content),
                CreatedAt = m.CreatedAt.ToString("HH:mm")
            }).ToList();
        }
    }

    public class ChatMessageDto
    {
        public int Id { get; set; }
        public int SenderId { get; set; }
        public string SenderName { get; set; }
        public string Content { get; set; }
        public string CreatedAt { get; set; }
    }

    private int GetRoomId()
    {
        int roomId;
        return int.TryParse(Request.QueryString["roomId"], out roomId) ? roomId : 0;
    }

    private string GetRoomDisplayName(BeautyStoryContext db, int roomId, bool isGroup, int currentCustomerId)
    {
        if (isGroup)
        {
            var room = db.CfCommunityRooms.FirstOrDefault(r => r.Id == roomId);
            return room != null && !string.IsNullOrWhiteSpace(room.RoomName) ? room.RoomName : "Nhóm chat";
        }

        var otherId = db.CfCommunityRoomMembers
            .Where(m => m.RoomId == roomId && m.CustomerId != currentCustomerId)
            .Select(m => m.CustomerId)
            .FirstOrDefault();

        var other = db.CfCustomers.FirstOrDefault(c => c.Id == otherId);
        return other != null
            ? (string.IsNullOrWhiteSpace(other.DisplayName) ? other.Username : other.DisplayName)
            : "Tin nhắn";
    }
}
