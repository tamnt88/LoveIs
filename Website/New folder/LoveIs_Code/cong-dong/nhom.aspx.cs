using System;
using System.Linq;

public partial class CommunityGroup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CommunityUserHelper.EnsureCommunityCustomerId().HasValue)
        {
            var returnUrl = Request.Url != null ? Request.Url.PathAndQuery : "/cong-dong/nhom.aspx";
            Response.Redirect("/tai-khoan/dang-nhap.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
            return;
        }

        if (!IsPostBack)
        {
            BindGroups();
        }
    }

    protected void CreateGroupButton_Click(object sender, EventArgs e)
    {
        GroupMessage.Text = string.Empty;
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        var name = (GroupNameInput.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(name))
        {
            GroupMessage.Text = "Vui lòng nhập tên nhóm.";
            return;
        }

        var usernames = (MemberInput.Text ?? string.Empty)
            .Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(x => x.Trim())
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();

        using (var db = new BeautyStoryContext())
        {
            var room = new CfCommunityRoom
            {
                RoomName = name,
                IsGroup = true,
                CreatedBy = customerId.Value,
                Status = true,
                CreatedAt = DateTime.UtcNow
            };
            db.CfCommunityRooms.Add(room);
            db.SaveChanges();

            db.CfCommunityRoomMembers.Add(new CfCommunityRoomMember
            {
                RoomId = room.Id,
                CustomerId = customerId.Value,
                Role = "owner",
                Status = true,
                JoinedAt = DateTime.UtcNow
            });

            foreach (var username in usernames)
            {
                var member = db.CfCustomers.FirstOrDefault(c => c.Username == username);
                if (member == null || member.Id == customerId.Value)
                {
                    continue;
                }

                db.CfCommunityRoomMembers.Add(new CfCommunityRoomMember
                {
                    RoomId = room.Id,
                    CustomerId = member.Id,
                    Role = "member",
                    Status = true,
                    JoinedAt = DateTime.UtcNow
                });

                CommunityNotificationHelper.Notify(member.Id, "group", room.Id, "Bạn được thêm vào nhóm chat: " + name);
            }

            db.SaveChanges();
        }

        GroupNameInput.Text = string.Empty;
        MemberInput.Text = string.Empty;
        BindGroups();
        GroupMessage.Text = "Đã tạo nhóm chat.";
    }

    private void BindGroups()
    {
        var customerId = CommunityUserHelper.EnsureCommunityCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var rooms = (from rm in db.CfCommunityRoomMembers
                         join r in db.CfCommunityRooms on rm.RoomId equals r.Id
                         where rm.CustomerId == customerId.Value && rm.Status && r.Status && r.IsGroup
                         orderby r.CreatedAt descending
                         select r).ToList();

            var view = rooms.Select(r => new
            {
                RoomId = r.Id,
                RoomName = string.IsNullOrWhiteSpace(r.RoomName) ? "Nhóm chat" : r.RoomName
            }).ToList();

            GroupRepeater.DataSource = view;
            GroupRepeater.DataBind();
        }
    }
}
