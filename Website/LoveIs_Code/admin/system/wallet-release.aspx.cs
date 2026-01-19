using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminSystemWalletRelease : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request != null && Request.HttpMethod == "POST"
            && Request.Form["InlineUpload"] == "1"
            && Request.Files != null && Request.Files.Count > 0)
        {
            ProcessInlineUpload();
        }
    }

    protected void UploadProofButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        int payoutId;
        if (!int.TryParse(ProofPayoutId.Text, out payoutId))
        {
            FormMessage.Text = "Payout ID khong hop le.";
            return;
        }

        if (ProofUpload == null || !ProofUpload.HasFile)
        {
            FormMessage.Text = "Vui long chon file chung tu.";
            return;
        }

        var proofUrl = SaveUploadedFile(ProofUpload, "payout-proofs");
        if (string.IsNullOrWhiteSpace(proofUrl))
        {
            FormMessage.Text = "Khong the luu file.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            ShopWalletService.AddPayoutProof(db, payoutId, proofUrl, ProofUpload.FileName, actor);
            if (!ShopWalletService.MarkPayoutPaid(db, payoutId, actor, ProofNote.Text))
            {
                FormMessage.Text = "Khong the cap nhat trang thai chi tien.";
                return;
            }

            db.SaveChanges();
            FormMessage.CssClass = "text-success small d-block mb-2";
            FormMessage.Text = "Da upload chung tu va cap nhat trang thai.";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult ApproveRelease(int releaseId, string note)
    {
        if (!IsAdminSignedIn())
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            var ok = ShopWalletService.ApproveRelease(db, releaseId, actor, note);
            if (!ok)
            {
                return new ActionResult { Success = false, Message = "Khong the duyet giai ngan." };
            }

            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da duyet giai ngan." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult ReleaseToAvailable(int releaseId)
    {
        if (!IsAdminSignedIn())
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            var ok = ShopWalletService.ReleaseToAvailable(db, releaseId, actor);
            if (!ok)
            {
                return new ActionResult { Success = false, Message = "Khong the chuyen ve so du kha dung." };
            }

            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da chuyen ve so du kha dung." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult ApproveAndRelease(int releaseId, string note)
    {
        if (!IsAdminSignedIn())
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            if (!ShopWalletService.ApproveRelease(db, releaseId, actor, note))
            {
                return new ActionResult { Success = false, Message = "Khong the duyet giai ngan." };
            }

            if (!ShopWalletService.ReleaseToAvailable(db, releaseId, actor))
            {
                return new ActionResult { Success = false, Message = "Khong the chuyen ve so du kha dung." };
            }

            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da giai ngan thanh cong." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult ReleaseDue()
    {
        if (!IsAdminSignedIn())
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            var count = ShopWalletService.ReleaseDue(db, actor);
            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da giai ngan " + count + " dong." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult MarkPayoutPaid(int payoutRequestId, string note, string proofUrl, string proofName)
    {
        if (!IsAdminSignedIn())
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            if (!string.IsNullOrWhiteSpace(proofUrl))
            {
                ShopWalletService.AddPayoutProof(db, payoutRequestId, proofUrl, proofName, actor);
            }

            var ok = ShopWalletService.MarkPayoutPaid(db, payoutRequestId, actor, note);
            if (!ok)
            {
                return new ActionResult { Success = false, Message = "Khong the cap nhat trang thai chi tien." };
            }

            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da cap nhat trang thai chi tien." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult RejectPayout(int payoutRequestId, string note)
    {
        if (!IsAdminSignedIn())
        {
            return new ActionResult { Success = false, Message = "Vui long dang nhap lai." };
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            var ok = ShopWalletService.RejectPayoutRequest(db, payoutRequestId, actor, note);
            if (!ok)
            {
                return new ActionResult { Success = false, Message = "Khong the tu choi lenh rut." };
            }

            db.SaveChanges();
            return new ActionResult { Success = true, Message = "Da tu choi lenh rut." };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<WalletReleaseRow> GetReleases(string status)
    {
        if (!IsAdminSignedIn())
        {
            return new List<WalletReleaseRow>();
        }

        using (var db = new BeautyStoryContext())
        {
            var query = db.CfShopWalletReleases.AsQueryable();
            if (!string.IsNullOrWhiteSpace(status))
            {
                query = query.Where(r => r.Status == status);
            }

            var rows = (from r in query
                        join s in db.CfShops on r.ShopId equals s.Id
                        join o in db.CfOrders on r.OrderId equals o.Id into ro
                        from o in ro.DefaultIfEmpty()
                        orderby r.ReleaseAt descending, r.Id descending
                        select new WalletReleaseRow
                        {
                            Id = r.Id,
                            ShopId = r.ShopId,
                            ShopName = s.ShopName,
                            OrderCode = o != null ? o.OrderCode : "-",
                            Amount = r.Amount,
                            Status = r.Status,
                            ReleaseAt = r.ReleaseAt,
                            ApprovedAt = r.ApprovedAt,
                            ReleasedAt = r.ReleasedAt
                        }).ToList();

            return rows;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<PayoutRequestRow> GetPayoutRequests(string status)
    {
        if (!IsAdminSignedIn())
        {
            return new List<PayoutRequestRow>();
        }

        using (var db = new BeautyStoryContext())
        {
            var query = db.CfShopPayoutRequests.AsQueryable();
            if (!string.IsNullOrWhiteSpace(status))
            {
                query = query.Where(r => r.Status == status);
            }

            var rows = (from r in query
                        join s in db.CfShops on r.ShopId equals s.Id
                        join b in db.CfShopBanks on r.BankAccountId equals b.Id
                        orderby r.RequestedAt descending, r.Id descending
                        select new PayoutRequestRow
                        {
                            Id = r.Id,
                            ShopId = r.ShopId,
                            ShopName = s.ShopName,
                            Amount = r.Amount,
                            BankName = b.BankName,
                            BankAccount = b.AccountNumber,
                            Status = r.Status,
                            RequestedAt = r.RequestedAt,
                            PaidAt = r.PaidAt
                        }).ToList();

            return rows;
        }
    }

    private static bool IsAdminSignedIn()
    {
        var context = HttpContext.Current;
        return context != null && context.Session != null && context.Session["AdminUserId"] != null;
    }

    private static string GetAdminUsername()
    {
        var context = HttpContext.Current;
        if (context != null && context.Session != null && context.Session["AdminUsername"] != null)
        {
            return context.Session["AdminUsername"].ToString();
        }

        return "admin";
    }

    private static string SaveUploadedFile(System.Web.UI.WebControls.FileUpload upload, string folder)
    {
        if (upload == null || !upload.HasFile)
        {
            return string.Empty;
        }

        var extension = Path.GetExtension(upload.FileName);
        var fileName = Guid.NewGuid().ToString("N") + extension;
        var virtualFolder = string.Format("~/upload/{0}", folder.Trim('/'));
        var physicalFolder = HttpContext.Current.Server.MapPath(virtualFolder);
        if (!Directory.Exists(physicalFolder))
        {
            Directory.CreateDirectory(physicalFolder);
        }

        var physicalPath = Path.Combine(physicalFolder, fileName);
        upload.SaveAs(physicalPath);
        return string.Format("/upload/{0}/{1}", folder.Trim('/'), fileName);
    }

    private void ProcessInlineUpload()
    {
        FormMessage.Text = string.Empty;
        int payoutId;
        if (!int.TryParse(Request.Form["PayoutId"], out payoutId))
        {
            FormMessage.Text = "Payout ID khong hop le.";
            return;
        }

        var file = Request.Files["ProofFile"];
        if (file == null || file.ContentLength == 0)
        {
            FormMessage.Text = "Vui long chon file chung tu.";
            return;
        }

        var proofUrl = SaveUploadedFile(file, "payout-proofs");
        if (string.IsNullOrWhiteSpace(proofUrl))
        {
            FormMessage.Text = "Khong the luu file.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var actor = GetAdminUsername();
            var note = Request.Form["ProofNote"] ?? string.Empty;
            ShopWalletService.AddPayoutProof(db, payoutId, proofUrl, file.FileName, actor);
            if (!ShopWalletService.MarkPayoutPaid(db, payoutId, actor, note))
            {
                FormMessage.Text = "Khong the cap nhat trang thai chi tien.";
                return;
            }

            db.SaveChanges();
            FormMessage.CssClass = "text-success small d-block mb-2";
            FormMessage.Text = "Da upload chung tu va cap nhat trang thai.";
        }
    }

    private static string SaveUploadedFile(System.Web.HttpPostedFile upload, string folder)
    {
        if (upload == null || upload.ContentLength == 0)
        {
            return string.Empty;
        }

        var extension = Path.GetExtension(upload.FileName);
        var fileName = Guid.NewGuid().ToString("N") + extension;
        var virtualFolder = string.Format("~/upload/{0}", folder.Trim('/'));
        var physicalFolder = HttpContext.Current.Server.MapPath(virtualFolder);
        if (!Directory.Exists(physicalFolder))
        {
            Directory.CreateDirectory(physicalFolder);
        }

        var physicalPath = Path.Combine(physicalFolder, fileName);
        upload.SaveAs(physicalPath);
        return string.Format("/upload/{0}/{1}", folder.Trim('/'), fileName);
    }

    public class WalletReleaseRow
    {
        public int Id { get; set; }
        public int ShopId { get; set; }
        public string ShopName { get; set; }
        public string OrderCode { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; }
        public DateTime ReleaseAt { get; set; }
        public DateTime? ApprovedAt { get; set; }
        public DateTime? ReleasedAt { get; set; }
    }

    public class PayoutRequestRow
    {
        public int Id { get; set; }
        public int ShopId { get; set; }
        public string ShopName { get; set; }
        public decimal Amount { get; set; }
        public string BankName { get; set; }
        public string BankAccount { get; set; }
        public string Status { get; set; }
        public DateTime RequestedAt { get; set; }
        public DateTime? PaidAt { get; set; }
    }
}
