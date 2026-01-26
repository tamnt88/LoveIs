using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using Microsoft.AspNet.SignalR;

public partial class SupportChatUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentType = "application/json";
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        if (Request.HttpMethod != "POST")
        {
            WriteJson(new { ok = false, message = "Invalid method" });
            return;
        }

        var senderType = (Request.Form["senderType"] ?? string.Empty).Trim().ToLowerInvariant();
        int chatId;
        if (!int.TryParse(Request.Form["chatId"], out chatId) || chatId <= 0)
        {
            WriteJson(new { ok = false, message = "Invalid chat" });
            return;
        }

        int senderId = GetSenderId(senderType);
        if (senderId <= 0)
        {
            WriteJson(new { ok = false, message = "Unauthorized" });
            return;
        }

        if (!IsAuthorized(chatId, senderType, senderId))
        {
            WriteJson(new { ok = false, message = "Forbidden" });
            return;
        }

        if (Request.Files == null || Request.Files.Count == 0)
        {
            WriteJson(new { ok = false, message = "No files" });
            return;
        }

        var uploadRoot = Server.MapPath("~/upload/chat");
        if (!Directory.Exists(uploadRoot))
        {
            Directory.CreateDirectory(uploadRoot);
        }

        var fileEntries = new List<CfSupportChatMessageFile>();
        using (var db = new BeautyStoryContext())
        {
            var chat = db.CfSupportChats.FirstOrDefault(c => c.Id == chatId && c.Status);
            if (chat == null)
            {
                WriteJson(new { ok = false, message = "Chat not found" });
                return;
            }

            var message = new CfSupportChatMessage
            {
                ChatId = chat.Id,
                SenderType = senderType,
                MessageType = "image",
                Message = string.Empty,
                CreatedAt = DateTime.Now
            };
            db.CfSupportChatMessages.Add(message);
            db.SaveChanges();

            for (int i = 0; i < Request.Files.Count; i++)
            {
                var file = Request.Files[i];
                if (file == null || file.ContentLength <= 0)
                {
                    continue;
                }

                if (string.IsNullOrWhiteSpace(file.ContentType) || !file.ContentType.StartsWith("image/", StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                var extension = Path.GetExtension(file.FileName);
                var fileName = string.Format("{0}_{1}{2}", message.Id, Guid.NewGuid().ToString("N"), extension);
                var physicalPath = Path.Combine(uploadRoot, fileName);
                file.SaveAs(physicalPath);

                var url = "/upload/chat/" + fileName;
                var entry = new CfSupportChatMessageFile
                {
                    MessageId = message.Id,
                    FileUrl = url,
                    FileName = Path.GetFileName(file.FileName),
                    MimeType = file.ContentType,
                    FileSize = file.ContentLength,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = senderType
                };
                db.CfSupportChatMessageFiles.Add(entry);
                fileEntries.Add(entry);
            }

            if (fileEntries.Count == 0)
            {
                db.CfSupportChatMessages.Remove(message);
                db.SaveChanges();
                WriteJson(new { ok = false, message = "No valid images" });
                return;
            }

            chat.LastMessageAt = DateTime.Now;
            chat.LastMessageSender = senderType;
            db.SaveChanges();

            NotifyClients(chatId, senderType, senderId, message.CreatedAt, fileEntries);
            WriteJson(new
            {
                ok = true,
                messageId = message.Id,
                createdAt = message.CreatedAt.ToString("HH:mm"),
                files = fileEntries.Select(f => new { url = f.FileUrl }).ToList()
            });
        }
    }

    private static int GetSenderId(string senderType)
    {
        if (senderType == "seller")
        {
            var sellerId = SellerAuth.GetSellerId();
            return sellerId.HasValue ? sellerId.Value : 0;
        }

        var adminIdObj = HttpContext.Current.Session["AdminUserId"];
        int adminId;
        return adminIdObj != null && int.TryParse(adminIdObj.ToString(), out adminId) ? adminId : 0;
    }

    private static bool IsAuthorized(int chatId, string senderType, int senderId)
    {
        if (chatId <= 0 || senderId <= 0)
        {
            return false;
        }

        using (var db = new BeautyStoryContext())
        {
            var chat = db.CfSupportChats.AsNoTracking().FirstOrDefault(c => c.Id == chatId && c.Status);
            if (chat == null)
            {
                return false;
            }

            if (senderType == "seller")
            {
                return chat.SellerId == senderId;
            }

            if (senderType == "admin")
            {
                return db.CfUsers.AsNoTracking().Any(u => u.Id == senderId && u.Status);
            }
        }

        return false;
    }

    private static void NotifyClients(int chatId, string senderType, int senderId, DateTime createdAt, List<CfSupportChatMessageFile> files)
    {
        var context = GlobalHost.ConnectionManager.GetHubContext<SupportChatHub>();
        if (context == null)
        {
            return;
        }

        context.Clients.Group("support-chat-" + chatId.ToString(System.Globalization.CultureInfo.InvariantCulture)).newMessage(new
        {
            ChatId = chatId,
            SenderType = senderType,
            SenderId = senderId,
            MessageType = "image",
            Message = string.Empty,
            CreatedAt = createdAt.ToString("HH:mm"),
            Files = files.Select(f => new { Url = f.FileUrl }).ToList()
        });
    }

    private void WriteJson(object payload)
    {
        var serializer = new JavaScriptSerializer();
        Response.Write(serializer.Serialize(payload));
        Response.End();
    }
}
