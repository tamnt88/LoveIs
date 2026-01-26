using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using Microsoft.AspNet.SignalR;

public partial class ChatUpload : System.Web.UI.Page
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
        int inquiryId;
        if (!int.TryParse(Request.Form["inquiryId"], out inquiryId) || inquiryId <= 0)
        {
            WriteJson(new { ok = false, message = "Invalid inquiry" });
            return;
        }

        int senderId = GetSenderId(senderType);
        if (senderId <= 0)
        {
            WriteJson(new { ok = false, message = "Unauthorized" });
            return;
        }

        if (!IsAuthorized(inquiryId, senderType, senderId))
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

        var fileEntries = new List<CfShopInquiryMessageFile>();
        using (var db = new BeautyStoryContext())
        {
            var inquiry = db.CfShopInquiries.FirstOrDefault(i => i.Id == inquiryId && i.Status);
            if (inquiry == null)
            {
                WriteJson(new { ok = false, message = "Inquiry not found" });
                return;
            }

            var message = new CfShopInquiryMessage
            {
                InquiryId = inquiry.Id,
                ShopId = inquiry.ShopId,
                CustomerId = inquiry.CustomerId,
                SenderType = senderType,
                MessageType = "image",
                Message = string.Empty,
                CreatedAt = DateTime.Now
            };
            db.CfShopInquiryMessages.Add(message);
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
                var entry = new CfShopInquiryMessageFile
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
                db.CfShopInquiryMessageFiles.Add(entry);
                fileEntries.Add(entry);
            }

            if (fileEntries.Count == 0)
            {
                db.CfShopInquiryMessages.Remove(message);
                db.SaveChanges();
                WriteJson(new { ok = false, message = "No valid images" });
                return;
            }

            if (senderType == "shop" && !inquiry.FirstReplyAt.HasValue)
            {
                inquiry.FirstReplyAt = DateTime.Now;
            }

            inquiry.LastReplyAt = DateTime.Now;
            inquiry.LastMessageAt = inquiry.LastReplyAt;
            inquiry.LastMessageSender = senderType;
            db.SaveChanges();

            NotifyClients(inquiryId, senderType, senderId, message.CreatedAt, fileEntries);
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
        if (senderType == "shop")
        {
            var sellerId = SellerAuth.GetSellerId();
            return sellerId.HasValue ? sellerId.Value : 0;
        }

        var customerId = CustomerAuth.GetCustomerId();
        return customerId.HasValue ? customerId.Value : 0;
    }

    private static bool IsAuthorized(int inquiryId, string senderType, int senderId)
    {
        if (inquiryId <= 0 || senderId <= 0)
        {
            return false;
        }

        using (var db = new BeautyStoryContext())
        {
            var inquiry = db.CfShopInquiries.AsNoTracking().FirstOrDefault(i => i.Id == inquiryId && i.Status);
            if (inquiry == null)
            {
                return false;
            }

            if (senderType == "customer")
            {
                return inquiry.CustomerId == senderId;
            }

            if (senderType == "shop")
            {
                return db.CfShops.AsNoTracking().Any(s => s.Id == inquiry.ShopId && s.SellerId == senderId);
            }
        }

        return false;
    }

    private static void NotifyClients(int inquiryId, string senderType, int senderId, DateTime createdAt, List<CfShopInquiryMessageFile> files)
    {
        var context = GlobalHost.ConnectionManager.GetHubContext<ShopInquiryChatHub>();
        if (context == null)
        {
            return;
        }

        context.Clients.Group("shop-inquiry-" + inquiryId.ToString(System.Globalization.CultureInfo.InvariantCulture)).newMessage(new
        {
            InquiryId = inquiryId,
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
