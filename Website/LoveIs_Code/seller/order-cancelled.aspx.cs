using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;

public partial class SellerCancelledOrders : System.Web.UI.Page
{
    private const int PageSize = 10;
    private int _currentPage = 1;
    private string _searchText = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCancelledOrders();
        }
    }

    private void BindCancelledOrders()
    {
        _currentPage = ParsePage(Request.QueryString["page"]);
        _searchText = (Request.QueryString["q"] ?? string.Empty).Trim();

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var cancelStatusId = db.CfOrderStatuses
                .Where(s => s.Status && s.Code == "CANCELLED")
                .Select(s => (int?)s.Id)
                .FirstOrDefault();

            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                CancelTotalLiteral.Text = "0";
                CancelByCustomerLiteral.Text = "0";
                CancelByShopLiteral.Text = "0";
                CancelTotalAmountLiteral.Text = "0 đ";
                CancelRepeater.DataSource = new List<CancelRowViewModel>();
                CancelRepeater.DataBind();
                PaginationLiteral.Text = string.Empty;
                return;
            }

            var cancelledOrderIds = db.CfOrders
                .Where(o => o.Status && (
                    (cancelStatusId.HasValue && o.OrderStatusId == cancelStatusId.Value)
                    || o.OrderStatus == "CANCELLED"))
                .Select(o => o.Id)
                .ToList();

            var cancelledOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && cancelledOrderIds.Contains(o.OrderId))
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            if (!string.IsNullOrWhiteSpace(_searchText))
            {
                var orderQuery = db.CfOrders.AsQueryable();
                orderQuery = orderQuery.Where(o => o.OrderCode.Contains(_searchText) || o.CustomerName.Contains(_searchText));

                var matchedOrderIds = orderQuery.Select(o => o.Id).ToList();
                cancelledOrders = cancelledOrders.Where(o => matchedOrderIds.Contains(o.OrderId)).ToList();
            }

            var totalOrders = cancelledOrders.Count;
            var totalPages = (int)Math.Ceiling(totalOrders / (double)PageSize);
            if (_currentPage > totalPages && totalPages > 0)
            {
                _currentPage = totalPages;
            }

            var pagedOrders = cancelledOrders
                .Skip((_currentPage - 1) * PageSize)
                .Take(PageSize)
                .ToList();

            var pagedOrderIds = pagedOrders.Select(o => o.OrderId).Distinct().ToList();
            var orders = db.CfOrders
                .Where(o => pagedOrderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var orderItems = db.CfOrderItems
                .Where(i => pagedOrderIds.Contains(i.OrderId))
                .ToList();

            var historyLookup = db.CfOrderHistories
                .Where(h => h.Status && pagedOrderIds.Contains(h.OrderId))
                .ToList()
                .GroupBy(h => h.OrderId)
                .ToDictionary(g => g.Key, g => g.OrderByDescending(x => x.CreatedAt).FirstOrDefault());

            CancelTotalLiteral.Text = totalOrders.ToString();
            CancelByCustomerLiteral.Text = totalOrders.ToString();
            CancelByShopLiteral.Text = "0";
            CancelTotalAmountLiteral.Text = string.Format("{0:N0} đ", cancelledOrders.Sum(o => o.Total));

            var rows = new List<CancelRowViewModel>();
            foreach (var shopOrder in pagedOrders)
            {
                CfOrder order;
                orders.TryGetValue(shopOrder.OrderId, out order);
                var item = orderItems.FirstOrDefault(i => i.OrderId == shopOrder.OrderId);
                var history = historyLookup.ContainsKey(shopOrder.OrderId) ? historyLookup[shopOrder.OrderId] : null;
                var reason = history != null && !string.IsNullOrWhiteSpace(history.Note) ? history.Note : "-";
                var cancelledBy = ResolveCancelledBy(history != null ? history.CreatedBy : string.Empty);

                rows.Add(new CancelRowViewModel
                {
                    OrderCode = order != null ? order.OrderCode : "-",
                    CustomerName = order != null ? order.CustomerName : "-",
                    ProductName = item != null ? item.ProductName : "-",
                    Quantity = item != null ? item.Quantity.ToString() : "-",
                    TotalLabel = string.Format("{0:N0} đ", shopOrder.Total),
                    CancelledAt = shopOrder.CreatedAt.ToString("dd/MM/yyyy"),
                    Reason = reason,
                    CancelledBy = cancelledBy,
                    CancelledByClass = cancelledBy == "Shop" ? "cancel-seller" : "cancel-customer"
                });
            }

            CancelRepeater.DataSource = rows;
            CancelRepeater.DataBind();
            PaginationLiteral.Text = BuildPagination(totalPages);
            PaginationInfoLiteral.Text = BuildPaginationInfo(totalOrders);

            SearchTextBox.Text = _searchText;
        }
    }

    protected void ApplyFiltersButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(BuildFilterUrl(resetPage: true, clearFilters: false));
    }

    protected void ResetFiltersButton_Click(object sender, EventArgs e)
    {
        _searchText = string.Empty;
        Response.Redirect(BuildFilterUrl(resetPage: true, clearFilters: true));
    }

    protected void ExportButton_Click(object sender, EventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var cancelStatusId = db.CfOrderStatuses
                .Where(s => s.Status && s.Code == "CANCELLED")
                .Select(s => (int?)s.Id)
                .FirstOrDefault();

            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                return;
            }

            _searchText = (SearchTextBox.Text ?? string.Empty).Trim();

            var cancelledOrderIds = db.CfOrders
                .Where(o => o.Status && (
                    (cancelStatusId.HasValue && o.OrderStatusId == cancelStatusId.Value)
                    || o.OrderStatus == "CANCELLED"))
                .Select(o => o.Id)
                .ToList();

            var cancelledOrders = db.CfShopOrders
                .Where(o => o.Status && shopIds.Contains(o.ShopId) && cancelledOrderIds.Contains(o.OrderId))
                .OrderByDescending(o => o.CreatedAt)
                .ToList();

            if (!string.IsNullOrWhiteSpace(_searchText))
            {
                var orderQuery = db.CfOrders.AsQueryable();
                orderQuery = orderQuery.Where(o => o.OrderCode.Contains(_searchText) || o.CustomerName.Contains(_searchText));

                var matchedOrderIds = orderQuery.Select(o => o.Id).ToList();
                cancelledOrders = cancelledOrders.Where(o => matchedOrderIds.Contains(o.OrderId)).ToList();
            }

            var filteredOrderIds = cancelledOrders.Select(o => o.OrderId).Distinct().ToList();
            var orders = db.CfOrders
                .Where(o => filteredOrderIds.Contains(o.Id))
                .ToList()
                .ToDictionary(o => o.Id, o => o);

            var orderItems = db.CfOrderItems
                .Where(i => filteredOrderIds.Contains(i.OrderId))
                .ToList();

            var historyLookup = db.CfOrderHistories
                .Where(h => h.Status && filteredOrderIds.Contains(h.OrderId))
                .ToList()
                .GroupBy(h => h.OrderId)
                .ToDictionary(g => g.Key, g => g.OrderByDescending(x => x.CreatedAt).FirstOrDefault());

            var rows = new List<ExportRow>();
            foreach (var shopOrder in cancelledOrders)
            {
                CfOrder order;
                orders.TryGetValue(shopOrder.OrderId, out order);

                var items = orderItems.Where(i => i.OrderId == shopOrder.OrderId).ToList();
                if (items.Count == 0)
                {
                    items.Add(new CfOrderItem { ProductName = "-", Quantity = 0, LineTotal = shopOrder.Total });
                }

                var history = historyLookup.ContainsKey(shopOrder.OrderId) ? historyLookup[shopOrder.OrderId] : null;
                var reason = history != null && !string.IsNullOrWhiteSpace(history.Note) ? history.Note : "-";
                var cancelledBy = ResolveCancelledBy(history != null ? history.CreatedBy : string.Empty);

                foreach (var item in items)
                {
                    rows.Add(new ExportRow
                    {
                        OrderCode = order != null ? order.OrderCode : "-",
                        CustomerName = order != null ? order.CustomerName : "-",
                        ProductName = string.IsNullOrWhiteSpace(item.ProductName) ? "-" : item.ProductName,
                        Quantity = item.Quantity.ToString(CultureInfo.InvariantCulture),
                        TotalLabel = FormatCurrency(item.LineTotal > 0 ? item.LineTotal : shopOrder.Total),
                        CancelledAt = shopOrder.CreatedAt.ToString("dd/MM/yyyy"),
                        Reason = reason,
                        CancelledBy = cancelledBy
                    });
                }
            }

            var fileName = "don-huy-" + DateTime.Now.ToString("yyyyMMddHHmmss", CultureInfo.InvariantCulture) + ".xlsx";
            WriteXlsxResponse(rows, fileName);
        }
    }

    private static int ParsePage(string raw)
    {
        int page;
        if (int.TryParse(raw, out page) && page > 0)
        {
            return page;
        }
        return 1;
    }

    private string BuildPagination(int totalPages)
    {
        if (totalPages <= 1)
        {
            return string.Empty;
        }

        var links = new List<string>();
        var baseUrl = BuildFilterUrl(resetPage: false, clearFilters: false);

        links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&laquo;</a>", BuildPageUrl(baseUrl, 1)));
        if (_currentPage > 1)
        {
            links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&lsaquo;</a>", BuildPageUrl(baseUrl, _currentPage - 1)));
        }

        var start = Math.Max(1, _currentPage - 2);
        var end = Math.Min(totalPages, _currentPage + 2);
        for (int i = start; i <= end; i++)
        {
            if (i == _currentPage)
            {
                links.Add(string.Format("<span class=\"page-link active\">{0}</span>", i));
            }
            else
            {
                links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">{1}</a>", BuildPageUrl(baseUrl, i), i));
            }
        }

        if (_currentPage < totalPages)
        {
            links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&rsaquo;</a>", BuildPageUrl(baseUrl, _currentPage + 1)));
        }
        links.Add(string.Format("<a class=\"page-link\" href=\"{0}\">&raquo;</a>", BuildPageUrl(baseUrl, totalPages)));

        return string.Join("", links);
    }

    private string BuildPaginationInfo(int totalItems)
    {
        if (totalItems == 0)
        {
            return "Hiển thị 0 trong tổng số 0 đơn hủy";
        }
        int start = (_currentPage - 1) * PageSize + 1;
        int end = Math.Min(_currentPage * PageSize, totalItems);
        return string.Format("Hiển thị {0}-{1} trong tổng số {2} đơn hủy", start, end, totalItems);
    }

    private static string BuildPageUrl(string baseUrl, int page)
    {
        var separator = baseUrl.Contains("?") ? "&" : "?";
        return baseUrl + separator + "page=" + page;
    }

    private string BuildFilterUrl(bool resetPage, bool clearFilters)
    {
        var query = new List<string>();
        if (!clearFilters)
        {
            var search = (SearchTextBox.Text ?? string.Empty).Trim();
            if (!string.IsNullOrWhiteSpace(search))
            {
                query.Add("q=" + HttpUtility.UrlEncode(search));
            }
        }

        if (!resetPage && _currentPage > 1)
        {
            query.Add("page=" + _currentPage);
        }

        if (query.Count == 0)
        {
            return "/seller/order-cancelled.aspx";
        }

        return "/seller/order-cancelled.aspx?" + string.Join("&", query);
    }

    private static string ResolveCancelledBy(string createdBy)
    {
        if (string.IsNullOrWhiteSpace(createdBy))
        {
            return "Khách hàng";
        }

        var value = createdBy.ToLowerInvariant();
        if (value.Contains("shop") || value.Contains("seller") || value.Contains("admin"))
        {
            return "Shop";
        }

        if (value.Contains("customer") || value.Contains("khach"))
        {
            return "Khách hàng";
        }

        return "Khách hàng";
    }

    private static string FormatCurrency(decimal value)
    {
        return string.Format("{0:N0} đ", value);
    }

    private void WriteXlsxResponse(List<ExportRow> rows, string fileName)
    {
        var bytes = BuildXlsx(rows);
        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        Response.BinaryWrite(bytes);
        Response.End();
    }

    private static byte[] BuildXlsx(List<ExportRow> rows)
    {
        var headers = new[]
        {
            "Mã ĐH", "Khách Hàng", "Sản Phẩm", "SL", "Giá Trị", "Ngày Hủy", "Lý Do", "Hủy Bởi"
        };
        var data = new List<string[]>
        {
            headers
        };

        foreach (var row in rows)
        {
            data.Add(new[]
            {
                row.OrderCode ?? string.Empty,
                row.CustomerName ?? string.Empty,
                row.ProductName ?? string.Empty,
                row.Quantity ?? string.Empty,
                row.TotalLabel ?? string.Empty,
                row.CancelledAt ?? string.Empty,
                row.Reason ?? string.Empty,
                row.CancelledBy ?? string.Empty
            });
        }

        using (var stream = new MemoryStream())
        {
            using (var archive = new ZipArchive(stream, ZipArchiveMode.Create, true))
            {
                AddZipEntry(archive, "[Content_Types].xml", BuildContentTypesXml());
                AddZipEntry(archive, "_rels/.rels", BuildRootRelsXml());
                AddZipEntry(archive, "xl/workbook.xml", BuildWorkbookXml());
                AddZipEntry(archive, "xl/_rels/workbook.xml.rels", BuildWorkbookRelsXml());
                AddZipEntry(archive, "xl/worksheets/sheet1.xml", BuildWorksheetXml(data));
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
            + "<sheets><sheet name=\"CancelledOrders\" sheetId=\"1\" r:id=\"rId1\"/></sheets>"
            + "</workbook>";
    }

    private static string BuildWorkbookRelsXml()
    {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
            + "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"
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

    public class CancelRowViewModel
    {
        public string OrderCode { get; set; }
        public string CustomerName { get; set; }
        public string ProductName { get; set; }
        public string Quantity { get; set; }
        public string TotalLabel { get; set; }
        public string CancelledAt { get; set; }
        public string Reason { get; set; }
        public string CancelledBy { get; set; }
        public string CancelledByClass { get; set; }
    }

    private class ExportRow
    {
        public string OrderCode { get; set; }
        public string CustomerName { get; set; }
        public string ProductName { get; set; }
        public string Quantity { get; set; }
        public string TotalLabel { get; set; }
        public string CancelledAt { get; set; }
        public string Reason { get; set; }
        public string CancelledBy { get; set; }
    }
}
