using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

public partial class SellerFinanceBalance : System.Web.UI.Page
{
    protected string BalanceTrendDataJson { get; private set; }
    protected int RangeDays { get; private set; }
    protected string SearchQuery { get; private set; }
    protected int TotalRows { get; private set; }
    protected int PageStart { get; private set; }
    protected int PageEnd { get; private set; }
    protected string PagerHtml { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        BalanceTrendDataJson = "[]";
        RangeDays = ParseRange(Request.QueryString["range"]);
        SearchQuery = (Request.QueryString["search"] ?? string.Empty).Trim();
        TotalRows = 0;
        PageStart = 0;
        PageEnd = 0;
        PagerHtml = string.Empty;

        if (!IsPostBack)
        {
            BindBalance();
            BindPayoutBanks();
            return;
        }

        if (BalanceModalOpenField != null && BalanceModalOpenField.Value == "1")
        {
            ClientScript.RegisterStartupScript(GetType(), "OpenBalanceModal", "document.getElementById('BalanceWithdrawModal') && document.getElementById('BalanceWithdrawModal').classList.add('open');", true);
        }
    }

    private void BindBalance()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        if (IsExportRequest())
        {
            ExportBalanceTrend(sellerId.Value, RangeDays);
            return;
        }

        var rangeStart = DateTime.Today.AddDays(-RangeDays + 1);
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                WalletBalanceLiteral.Text = "0 đ";
                WalletBalanceNoteLiteral.Text = "Chưa có dữ liệu";
                CashInLiteral.Text = "0 đ";
                CashOutLiteral.Text = "0 đ";
                WalletTxnRepeater.DataSource = new List<WalletTxnRow>();
                WalletTxnRepeater.DataBind();
                BalanceTrendDataJson = "[]";
                return;
            }

            var wallets = db.CfShopWallets
                .Where(w => shopIds.Contains(w.ShopId))
                .ToList();

            var totalBalance = wallets.Sum(w => w.Balance);
            WalletBalanceLiteral.Text = FormatMoney(totalBalance);
            WalletBalanceNoteLiteral.Text = "Số dư tổng của tất cả shop";
            var totalAvailable = wallets.Sum(w => w.AvailableBalance);
            AvailableBalanceNoteLiteral.Text = FormatMoney(totalAvailable);

            var txns = db.CfShopWalletTxns
                .Where(t => shopIds.Contains(t.ShopId) && t.CreatedAt >= rangeStart)
                .OrderByDescending(t => t.CreatedAt)
                .Take(300)
                .ToList();

            var cashInTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "PENDING_IN",
                "AVAILABLE_IN",
                "ADJUST_IN"
            };
            var cashOutTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "PAYOUT_OUT",
                "PAYOUT_HOLD"
            };

            var cashIn = txns.Where(t => cashInTypes.Contains(t.Type ?? string.Empty)).Sum(t => t.Amount);
            var cashOut = txns.Where(t => cashOutTypes.Contains(t.Type ?? string.Empty)).Sum(t => t.Amount);

            CashInLiteral.Text = FormatMoney(cashIn);
            CashOutLiteral.Text = FormatMoney(cashOut);

            var payoutTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "PAYOUT_HOLD",
                "PAYOUT_OUT"
            };

            var rows = txns
                .Where(t => payoutTypes.Contains(t.Type ?? string.Empty))
                .Select(t => new WalletTxnRow
                {
                    TxnCode = BuildTxnCode(t.Id),
                    CreatedAtText = t.CreatedAt.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture),
                    Description = ResolvePayoutDescription(t.Type, t.Note),
                    TypeLabel = "Tiền ra",
                    TypeBadgeClass = "txn-badge txn-badge-out",
                    AmountText = "-" + FormatMoney(t.Amount),
                    AmountClass = "text-danger",
                    BalanceAfterText = FormatMoney(t.BalanceAfter)
                }).ToList();

            if (!string.IsNullOrWhiteSpace(SearchQuery))
            {
                var keyword = SearchQuery.Trim();
                rows = rows.Where(r =>
                        (r.TxnCode ?? string.Empty).IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0
                        || (r.Description ?? string.Empty).IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0)
                    .ToList();
            }

            TotalRows = rows.Count;
            var pageIndex = ParsePage(Request.QueryString["page"]);
            var pageSize = 8;
            var startIndex = pageIndex * pageSize;
            if (startIndex < 0) startIndex = 0;
            if (startIndex > Math.Max(0, TotalRows - 1)) startIndex = Math.Max(0, TotalRows - 1);
            var paged = rows.Skip(startIndex).Take(pageSize).ToList();
            PageStart = TotalRows == 0 ? 0 : startIndex + 1;
            PageEnd = TotalRows == 0 ? 0 : Math.Min(startIndex + pageSize, TotalRows);
            PagerHtml = BuildPagerHtml(pageIndex, pageSize, TotalRows, RangeDays, SearchQuery);

            WalletTxnRepeater.DataSource = paged;
            WalletTxnRepeater.DataBind();

            var trend = BuildBalanceTrendData(db, shopIds, RangeDays);
            BalanceTrendDataJson = new JavaScriptSerializer().Serialize(trend);
        }
    }

    private void BindPayoutBanks()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var banks = (from b in db.CfShopBanks
                         join s in db.CfShops on b.ShopId equals s.Id
                         where b.Status && s.SellerId == sellerId.Value
                         orderby b.IsDefault descending, b.BankName
                         select new
                         {
                             b.Id,
                             b.BankName,
                             b.AccountNumber,
                             b.IsDefault
                         })
                .ToList();

            PayoutBankSelect.Items.Clear();
            if (banks.Count == 0)
            {
                PayoutBankSelect.Items.Add(new System.Web.UI.WebControls.ListItem("Chưa có tài khoản ngân hàng", "0"));
                return;
            }
            foreach (var bank in banks)
            {
                var item = new System.Web.UI.WebControls.ListItem(BuildBankLabel(bank.BankName, bank.AccountNumber), bank.Id.ToString(CultureInfo.InvariantCulture));
                PayoutBankSelect.Items.Add(item);
            }

            if (banks.Count > 0)
            {
                var defaultBank = banks.FirstOrDefault(b => b.IsDefault) ?? banks[0];
                PayoutBankSelect.SelectedValue = defaultBank.Id.ToString(CultureInfo.InvariantCulture);
            }
        }
    }

    protected void SubmitPayoutButton_Click(object sender, EventArgs e)
    {
        PayoutMessageLiteral.Text = string.Empty;
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            PayoutMessageLiteral.Text = "<div class='text-danger small'>Phiên đăng nhập đã hết hạn.</div>";
            return;
        }

        int bankId;
        if (!int.TryParse(PayoutBankSelect.SelectedValue, out bankId) || bankId <= 0)
        {
            PayoutMessageLiteral.Text = "<div class='text-danger small'>Vui lòng chọn tài khoản ngân hàng.</div>";
            return;
        }

        decimal amount;
        if (!decimal.TryParse((PayoutAmountInput.Text ?? string.Empty).Trim(), out amount) || amount <= 0)
        {
            PayoutMessageLiteral.Text = "<div class='text-danger small'>Giá trị yêu cầu chưa hợp lệ.</div>";
            return;
        }

        var note = (PayoutNoteInput.Text ?? string.Empty).Trim();

        using (var db = new BeautyStoryContext())
        {
            var bank = (from b in db.CfShopBanks
                        join s in db.CfShops on b.ShopId equals s.Id
                        where b.Id == bankId && b.Status && s.SellerId == sellerId.Value
                        select new { b.Id, b.ShopId }).FirstOrDefault();
            if (bank == null)
            {
                PayoutMessageLiteral.Text = "<div class='text-danger small'>Tài khoản ngân hàng không hợp lệ.</div>";
                return;
            }

            var wallet = db.CfShopWallets.FirstOrDefault(w => w.ShopId == bank.ShopId);
            if (wallet == null || wallet.AvailableBalance < amount)
            {
                PayoutMessageLiteral.Text = "<div class='text-danger small'>Không đủ số dư khả dụng.</div>";
                return;
            }

            var request = ShopWalletService.CreatePayoutRequest(db, bank.ShopId, bank.Id, amount, sellerId.Value.ToString(), note);
            if (request == null)
            {
                PayoutMessageLiteral.Text = "<div class='text-danger small'>Không thể tạo yêu cầu rút tiền.</div>";
                return;
            }

            db.SaveChanges();
        }

        PayoutAmountInput.Text = string.Empty;
        PayoutNoteInput.Text = string.Empty;
        PayoutMessageLiteral.Text = "<div class='text-success small'>Đã gửi yêu cầu rút tiền.</div>";
    }

    private static string ResolvePayoutDescription(string type, string note)
    {
        var code = (type ?? string.Empty).ToUpperInvariant();
        if (code == "PAYOUT_HOLD")
        {
            return "Tạo yêu cầu rút tiền";
        }
        if (code == "PAYOUT_OUT")
        {
            return "Rút tiền về tài khoản ngân hàng";
        }
        return string.IsNullOrWhiteSpace(note) ? "-" : note;
    }

    private static string BuildTxnCode(int id)
    {
        return "TXN" + id.ToString("D6", CultureInfo.InvariantCulture);
    }

    private static string BuildPagerHtml(int pageIndex, int pageSize, int totalRows, int rangeDays, string keyword)
    {
        if (totalRows <= pageSize)
        {
            return string.Empty;
        }

        var totalPages = (int)Math.Ceiling(totalRows / (double)pageSize);
        var current = Math.Max(0, Math.Min(pageIndex, totalPages - 1));
        var parts = new List<string>();

        var baseUrl = "/seller/finance-balance.aspx?range=" + rangeDays.ToString(CultureInfo.InvariantCulture);
        if (!string.IsNullOrWhiteSpace(keyword))
        {
            baseUrl += "&search=" + HttpUtility.UrlEncode(keyword);
        }

        var prevPage = current - 1;
        parts.Add(BuildPagerLink(baseUrl, "Trước", prevPage, prevPage < 0));

        var start = Math.Max(0, current - 2);
        var end = Math.Min(totalPages - 1, current + 2);
        for (var i = start; i <= end; i++)
        {
            var label = (i + 1).ToString(CultureInfo.InvariantCulture);
            parts.Add(BuildPagerLink(baseUrl, label, i, false, i == current));
        }

        var nextPage = current + 1;
        parts.Add(BuildPagerLink(baseUrl, "Sau", nextPage, nextPage >= totalPages));

        return string.Join("", parts);
    }

    private static string BuildPagerLink(string baseUrl, string label, int page, bool disabled, bool active = false)
    {
        var className = "pager-btn";
        if (active)
        {
            className += " active";
        }
        if (disabled)
        {
            className += " disabled";
            return "<span class='" + className + "'>" + HttpUtility.HtmlEncode(label) + "</span>";
        }
        var url = baseUrl + "&page=" + page.ToString(CultureInfo.InvariantCulture);
        return "<a class='" + className + "' href='" + url + "'>" + HttpUtility.HtmlEncode(label) + "</a>";
    }

    private static string FormatMoney(decimal amount)
    {
        return string.Format("{0:N0} đ", amount);
    }

    private static int ParseRange(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && (value == 7 || value == 30))
        {
            return value;
        }
        return 7;
    }

    private static int ParsePage(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && value > 0)
        {
            return value;
        }
        return 0;
    }

    private bool IsExportRequest()
    {
        return string.Equals(Request.QueryString["export"], "1", StringComparison.OrdinalIgnoreCase);
    }

    private static List<BalanceTrendPoint> BuildBalanceTrendData(BeautyStoryContext db, List<int> shopIds, int rangeDays)
    {
        var startDate = DateTime.Today.AddDays(-rangeDays + 1).Date;
        var endDate = DateTime.Today.AddDays(1).Date;

        var baseBalances = db.CfShopWalletTxns
            .Where(t => shopIds.Contains(t.ShopId) && t.CreatedAt < startDate)
            .GroupBy(t => t.ShopId)
            .Select(g => g.OrderByDescending(x => x.CreatedAt).Select(x => new { x.ShopId, x.BalanceAfter }).FirstOrDefault())
            .ToList();

        var currentBalances = baseBalances.ToDictionary(x => x.ShopId, x => x.BalanceAfter);
        foreach (var shopId in shopIds)
        {
            if (!currentBalances.ContainsKey(shopId))
            {
                currentBalances[shopId] = 0m;
            }
        }

        var rangeTxns = db.CfShopWalletTxns
            .Where(t => shopIds.Contains(t.ShopId) && t.CreatedAt >= startDate && t.CreatedAt < endDate)
            .Select(t => new { t.ShopId, t.CreatedAt, t.BalanceAfter })
            .ToList();

        var dailyUpdates = rangeTxns
            .GroupBy(t => new { t.ShopId, Date = t.CreatedAt.Date })
            .Select(g => new BalanceUpdate
            {
                ShopId = g.Key.ShopId,
                Date = g.Key.Date,
                BalanceAfter = g.OrderByDescending(x => x.CreatedAt).Select(x => x.BalanceAfter).FirstOrDefault()
            })
            .GroupBy(x => x.Date)
            .ToDictionary(
                g => g.Key,
                g => g.Select(x => new BalanceUpdate { ShopId = x.ShopId, BalanceAfter = x.BalanceAfter }).ToList());

        var points = new List<BalanceTrendPoint>();
        for (int i = 0; i < rangeDays; i++)
        {
            var date = startDate.AddDays(i).Date;
            List<BalanceUpdate> updates;
            if (dailyUpdates.TryGetValue(date, out updates))
            {
                foreach (var update in updates)
                {
                    currentBalances[update.ShopId] = update.BalanceAfter;
                }
            }

            var totalBalance = currentBalances.Values.Sum();
            points.Add(new BalanceTrendPoint
            {
                Day = date.ToString("dd/MM", CultureInfo.InvariantCulture),
                DateText = date.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                Amount = totalBalance
            });
        }

        return points;
    }

    private void ExportBalanceTrend(int sellerId, int rangeDays)
    {
        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId)
                .Select(s => s.Id)
                .ToList();

            var trend = BuildBalanceTrendData(db, shopIds, rangeDays);
            var fileName = "balance-trend-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx";

            var rows = new List<string[]>
            {
                new[] { "Ngày", "Số dư" }
            };

            foreach (var point in trend)
            {
                rows.Add(new[] { point.DateText, FormatMoney(point.Amount) });
            }

            WriteXlsxResponse(rows, fileName);
        }
    }

    private static void WriteXlsxResponse(List<string[]> rows, string fileName)
    {
        var bytes = BuildXlsx(rows);
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        HttpContext.Current.Response.BinaryWrite(bytes);
        HttpContext.Current.Response.End();
    }

    private static byte[] BuildXlsx(List<string[]> rows)
    {
        using (var stream = new MemoryStream())
        {
            using (var archive = new ZipArchive(stream, ZipArchiveMode.Create, true))
            {
                AddZipEntry(archive, "[Content_Types].xml", BuildContentTypesXml());
                AddZipEntry(archive, "_rels/.rels", BuildRootRelsXml());
                AddZipEntry(archive, "xl/workbook.xml", BuildWorkbookXml());
                AddZipEntry(archive, "xl/_rels/workbook.xml.rels", BuildWorkbookRelsXml());
                AddZipEntry(archive, "xl/worksheets/sheet1.xml", BuildWorksheetXml(rows));
            }

            return stream.ToArray();
        }
    }

    private static void AddZipEntry(ZipArchive archive, string path, string content)
    {
        var entry = archive.CreateEntry(path, CompressionLevel.Fastest);
        using (var writer = new StreamWriter(entry.Open(), Encoding.UTF8))
        {
            writer.Write(content);
        }
    }

    private static string BuildContentTypesXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">"
            + "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>"
            + "<Default Extension=\"xml\" ContentType=\"application/xml\"/>"
            + "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>"
            + "<Override PartName=\"/xl/worksheets/sheet1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>"
            + "</Types>";
    }

    private static string BuildRootRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorkbookXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" "
            + "xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">"
            + "<sheets><sheet name=\"Balance\" sheetId=\"1\" r:id=\"rId1\"/></sheets>"
            + "</workbook>";
    }

    private static string BuildWorkbookRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/package/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"
            + "</Relationships>";
    }

    private static string BuildWorksheetXml(List<string[]> rows)
    {
        var builder = new StringBuilder();
        builder.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        builder.Append("<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
        builder.Append("<sheetData>");

        for (var i = 0; i < rows.Count; i++)
        {
            var rowIndex = i + 1;
            builder.Append("<row r=\"").Append(rowIndex).Append("\">");
            var cols = rows[i];
            for (var c = 0; c < cols.Length; c++)
            {
                var cellRef = ColumnName(c) + rowIndex.ToString(CultureInfo.InvariantCulture);
                builder.Append("<c r=\"").Append(cellRef).Append("\" t=\"inlineStr\"><is><t xml:space=\"preserve\">");
                builder.Append(EscapeXml(cols[c] ?? string.Empty));
                builder.Append("</t></is></c>");
            }
            builder.Append("</row>");
        }

        builder.Append("</sheetData>");
        builder.Append("</worksheet>");
        return builder.ToString();
    }

    private static string ColumnName(int index)
    {
        var dividend = index + 1;
        var name = string.Empty;
        while (dividend > 0)
        {
            var modulo = (dividend - 1) % 26;
            name = Convert.ToChar(65 + modulo) + name;
            dividend = (dividend - modulo) / 26;
        }
        return name;
    }

    private static string EscapeXml(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return string.Empty;
        }

        return value
            .Replace("&", "&amp;")
            .Replace("<", "&lt;")
            .Replace(">", "&gt;")
            .Replace("\"", "&quot;")
            .Replace("'", "&apos;");
    }

    private sealed class WalletTxnRow
    {
        public string TxnCode { get; set; }
        public string CreatedAtText { get; set; }
        public string Description { get; set; }
        public string TypeLabel { get; set; }
        public string TypeBadgeClass { get; set; }
        public string AmountText { get; set; }
        public string AmountClass { get; set; }
        public string BalanceAfterText { get; set; }
    }

    private sealed class BalanceTrendPoint
    {
        public string Day { get; set; }
        public string DateText { get; set; }
        public decimal Amount { get; set; }
    }

    private sealed class BalanceUpdate
    {
        public int ShopId { get; set; }
        public DateTime Date { get; set; }
        public decimal BalanceAfter { get; set; }
    }

    private static string BuildBankLabel(string bankName, string accountNumber)
    {
        var name = string.IsNullOrWhiteSpace(bankName) ? "Ngân hàng" : bankName;
        var digits = new string((accountNumber ?? string.Empty).Where(char.IsDigit).ToArray());
        var tail = digits.Length > 4 ? digits.Substring(digits.Length - 4) : digits;
        return string.IsNullOrWhiteSpace(tail) ? name : name + " - ****" + tail;
    }
}
