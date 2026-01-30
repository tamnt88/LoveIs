using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

public partial class SellerSupportTickets : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCreateDropdowns();
            BindTickets();
        }

        SupportCreateModalStateLiteral.Text = ShouldOpenCreateModal()
            ? "<script>document.addEventListener('DOMContentLoaded',function(){var m=document.getElementById('SupportCreateModal'); if(m){m.style.display='flex';}});</script>"
            : string.Empty;
    }

    protected void CreateTicketButton_Click(object sender, EventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        var title = (CreateTitleInput.Text ?? string.Empty).Trim();
        var description = (CreateMessageInput.Text ?? string.Empty).Trim();
        var categoryId = ParseInt(CreateCategoryDropdown.SelectedValue);
        var priorityId = ParseInt(CreatePriorityDropdown.SelectedValue);

        if (string.IsNullOrWhiteSpace(title) || !categoryId.HasValue || !priorityId.HasValue)
        {
            CreateTicketMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng nhập đầy đủ tiêu đề, danh mục và mức độ ưu tiên.</div>";
            CreateTicketSuccessInput.Value = string.Empty;
            MarkCreateModalOpen();
            BindTickets();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var pendingStatusId = db.CfSupportTicketStatuses
                .Where(s => s.Status && s.Code == "pending")
                .Select(s => (int?)s.Id)
                .FirstOrDefault();
            if (!pendingStatusId.HasValue)
            {
                CreateTicketMessageLiteral.Text = "<div class=\"alert alert-danger mt-3\">Chưa cấu hình trạng thái ticket.</div>";
                CreateTicketSuccessInput.Value = string.Empty;
                MarkCreateModalOpen();
                BindTickets();
                return;
            }

            var now = DateTime.Now;
            var ticket = new CfSupportTicket
            {
                SellerId = sellerId.Value,
                Title = title,
                Description = description,
                CategoryId = categoryId.Value,
                StatusId = pendingStatusId.Value,
                PriorityId = priorityId.Value,
                CreatedAt = now,
                UpdatedAt = now
            };
            db.CfSupportTickets.Add(ticket);
            db.SaveChanges();

            db.CfSupportTicketMessages.Add(new CfSupportTicketMessage
            {
                TicketId = ticket.Id,
                SenderType = "seller",
                Message = string.IsNullOrWhiteSpace(description) ? title : description,
                CreatedAt = now
            });
            db.SaveChanges();
        }

        CreateTitleInput.Text = string.Empty;
        CreateMessageInput.Text = string.Empty;
        CreateCategoryDropdown.SelectedIndex = 0;
        CreatePriorityDropdown.SelectedIndex = 0;
        CreateTicketMessageLiteral.Text = string.Empty;
        CreateTicketSuccessInput.Value = "1";
        MarkCreateModalClose();

        BindTickets();
    }

    protected void CancelTicketButton_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        int ticketId;
        var arg = CancelTicketArgInput.Value;
        if (!int.TryParse(arg, out ticketId))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var pendingStatusId = db.CfSupportTicketStatuses
                .Where(s => s.Status && s.Code == "pending")
                .Select(s => (int?)s.Id)
                .FirstOrDefault();

            var ticket = db.CfSupportTickets.FirstOrDefault(t => t.Id == ticketId && t.SellerId == sellerId.Value);
            if (ticket == null || !pendingStatusId.HasValue || ticket.StatusId != pendingStatusId.Value)
            {
                return;
            }

            var messages = db.CfSupportTicketMessages.Where(m => m.TicketId == ticket.Id).ToList();
            foreach (var msg in messages)
            {
                db.CfSupportTicketMessages.Remove(msg);
            }
            db.SaveChanges();
            db.CfSupportTickets.Remove(ticket);
            db.SaveChanges();
        }

        BindTickets();
    }

    protected void ReplyTicketButton_Click(object sender, EventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        var ticketId = ParseInt(ReplyTicketIdInput.Value);
        var message = (ReplyMessageInput.Text ?? string.Empty).Trim();
        if (!ticketId.HasValue || string.IsNullOrWhiteSpace(message))
        {
            ReplyMessageLiteral.Text = "<div class=\"alert alert-warning mt-3\">Vui lòng nhập nội dung phản hồi.</div>";
            BindTickets();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var ticket = db.CfSupportTickets.FirstOrDefault(t => t.Id == ticketId.Value && t.SellerId == sellerId.Value);
            if (ticket == null)
            {
                return;
            }

            var processingStatusId = db.CfSupportTicketStatuses
                .Where(s => s.Status && s.Code == "processing")
                .Select(s => (int?)s.Id)
                .FirstOrDefault();

            db.CfSupportTicketMessages.Add(new CfSupportTicketMessage
            {
                TicketId = ticket.Id,
                SenderType = "seller",
                Message = message,
                CreatedAt = DateTime.Now
            });

            if (processingStatusId.HasValue)
            {
                ticket.StatusId = processingStatusId.Value;
            }
            ticket.UpdatedAt = DateTime.Now;
            db.SaveChanges();
        }

        ReplyMessageInput.Text = string.Empty;
        ReplyMessageLiteral.Text = "<div class=\"alert alert-success mt-3\">Đã gửi phản hồi.</div>";
        BindTickets();
    }

    private void BindCreateDropdowns()
    {
        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfSupportTicketCategories
                .Where(c => c.Status)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.Name)
                .ToList();
            CreateCategoryDropdown.DataSource = categories;
            CreateCategoryDropdown.DataTextField = "Name";
            CreateCategoryDropdown.DataValueField = "Id";
            CreateCategoryDropdown.DataBind();
            CreateCategoryDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Chọn danh mục", ""));

            var priorities = db.CfSupportTicketPriorities
                .Where(p => p.Status)
                .OrderBy(p => p.SortOrder)
                .ThenBy(p => p.Name)
                .ToList();
            CreatePriorityDropdown.DataSource = priorities;
            CreatePriorityDropdown.DataTextField = "Name";
            CreatePriorityDropdown.DataValueField = "Id";
            CreatePriorityDropdown.DataBind();
            CreatePriorityDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Chọn mức độ", ""));
        }
    }

    private void BindTickets()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfSupportTicketCategories
                .Where(c => c.Status)
                .ToList()
                .ToDictionary(c => c.Id, c => c.Name);

            var statuses = db.CfSupportTicketStatuses
                .Where(s => s.Status)
                .ToList()
                .ToDictionary(s => s.Id, s => s);

            var priorities = db.CfSupportTicketPriorities
                .Where(p => p.Status)
                .ToList()
                .ToDictionary(p => p.Id, p => p);

            var tickets = db.CfSupportTickets
                .Where(t => t.SellerId == sellerId.Value)
                .OrderByDescending(t => t.CreatedAt)
                .ToList();

            var ticketIds = tickets.Select(t => t.Id).ToList();
            var messages = db.CfSupportTicketMessages
                .Where(m => ticketIds.Contains(m.TicketId))
                .OrderByDescending(m => m.CreatedAt)
                .ToList();

            var latestAdminReply = messages
                .Where(m => string.Equals(m.SenderType, "admin", StringComparison.OrdinalIgnoreCase))
                .GroupBy(m => m.TicketId)
                .ToDictionary(g => g.Key, g => g.First().Message);

            var total = tickets.Count;
            var processingCount = tickets.Count(t =>
            {
                CfSupportTicketStatus status;
                return statuses.TryGetValue(t.StatusId, out status)
                    && string.Equals(status.Code, "processing", StringComparison.OrdinalIgnoreCase);
            });
            var resolvedCount = tickets.Count(t =>
            {
                CfSupportTicketStatus status;
                return statuses.TryGetValue(t.StatusId, out status)
                    && string.Equals(status.Code, "resolved", StringComparison.OrdinalIgnoreCase);
            });

            var avgHours = tickets
                .Where(t => t.UpdatedAt.HasValue)
                .Select(t => (t.UpdatedAt.Value - t.CreatedAt).TotalHours)
                .DefaultIfEmpty(0)
                .Average();

            TotalTicketLiteral.Text = total.ToString(CultureInfo.InvariantCulture);
            ProcessingTicketLiteral.Text = processingCount.ToString(CultureInfo.InvariantCulture);
            ResolvedTicketLiteral.Text = resolvedCount.ToString(CultureInfo.InvariantCulture);
            AverageTimeLiteral.Text = avgHours > 0 ? avgHours.ToString("0.0", CultureInfo.InvariantCulture) + "h" : "0h";

            var viewModels = tickets.Select(t =>
            {
                CfSupportTicketStatus status;
                statuses.TryGetValue(t.StatusId, out status);
                CfSupportTicketPriority priority;
                priorities.TryGetValue(t.PriorityId, out priority);

                var statusCode = status != null ? status.Code : "pending";
                var statusLabel = status != null ? status.Name : "Chờ xử lý";
                var priorityCode = priority != null ? priority.Code : "low";
                var priorityLabel = priority != null ? priority.Name : "Thấp";
                var categoryName = categories.ContainsKey(t.CategoryId) ? categories[t.CategoryId] : "-";
                var reply = latestAdminReply.ContainsKey(t.Id) ? latestAdminReply[t.Id] : "Chưa có phản hồi từ admin.";

                return new TicketRow
                {
                    Code = "SR" + t.Id.ToString("D3", CultureInfo.InvariantCulture),
                    Title = t.Title,
                    Category = categoryName,
                    CreatedAt = t.CreatedAt.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                    StatusLabel = statusLabel,
                    StatusClass = ResolveStatusClass(statusCode),
                    PriorityLabel = priorityLabel,
                    PriorityClass = ResolvePriorityClass(priorityCode),
                    Description = t.Description ?? t.Title,
                    AdminReply = reply,
                    TitleAttr = HttpUtility.HtmlAttributeEncode(t.Title ?? string.Empty),
                    DescAttr = HttpUtility.HtmlAttributeEncode(t.Description ?? t.Title ?? string.Empty),
                    ReplyAttr = HttpUtility.HtmlAttributeEncode(reply ?? string.Empty),
                    HasAdminReply = latestAdminReply.ContainsKey(t.Id),
                    CanCancel = string.Equals(statusCode, "pending", StringComparison.OrdinalIgnoreCase),
                    TicketId = t.Id
                };
            }).ToList();

            TicketRepeater.DataSource = viewModels;
            TicketRepeater.DataBind();
        }
    }

    private static string ResolveStatusClass(string code)
    {
        if (string.Equals(code, "resolved", StringComparison.OrdinalIgnoreCase))
        {
            return "success";
        }
        if (string.Equals(code, "processing", StringComparison.OrdinalIgnoreCase))
        {
            return "processing";
        }
        return "pending";
    }

    private static string ResolvePriorityClass(string code)
    {
        if (string.Equals(code, "high", StringComparison.OrdinalIgnoreCase))
        {
            return "high";
        }
        if (string.Equals(code, "medium", StringComparison.OrdinalIgnoreCase))
        {
            return "medium";
        }
        return "low";
    }

    private static int? ParseInt(string raw)
    {
        int value;
        return int.TryParse(raw, out value) ? (int?)value : null;
    }

    private class TicketRow
    {
        public string Code { get; set; }
        public string Title { get; set; }
        public string Category { get; set; }
        public string CreatedAt { get; set; }
        public string StatusLabel { get; set; }
        public string StatusClass { get; set; }
        public string PriorityLabel { get; set; }
        public string PriorityClass { get; set; }
        public string Description { get; set; }
        public string AdminReply { get; set; }
        public string TitleAttr { get; set; }
        public string DescAttr { get; set; }
        public string ReplyAttr { get; set; }
        public bool HasAdminReply { get; set; }
        public bool CanCancel { get; set; }
        public int TicketId { get; set; }
    }

    private void MarkCreateModalOpen()
    {
        ViewState["SupportCreateModalOpen"] = true;
    }

    private void MarkCreateModalClose()
    {
        ViewState["SupportCreateModalOpen"] = false;
    }

    private bool ShouldOpenCreateModal()
    {
        object value = ViewState["SupportCreateModalOpen"];
        return value is bool && (bool)value;
    }
}
