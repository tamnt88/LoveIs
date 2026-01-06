using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

public partial class AdminSystemBannersDefault : AdminBasePage
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<BannerRow> GetBanners(int draw, int start, int length, string search, int orderColumn, string orderDir, string title, string position, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var banners = db.CfBanners.ToList();
            var rows = banners.Select(b => new BannerRow
            {
                Id = b.Id,
                Title = string.Join(" ", new[] { b.TitleLine1, b.TitleLine2, b.TitleLine3 }.Where(s => !string.IsNullOrWhiteSpace(s))),
                ImageHtml = string.IsNullOrWhiteSpace(b.ImageUrl) ? "-" : string.Format("<img src=\"{0}\" class=\"table-thumb\" alt=\"banner\" />", b.ImageUrl),
                PositionLabel = GetPositionLabel(b.Position),
                SortOrder = b.SortOrder,
                StatusValue = b.Status ? 1 : 0,
                StatusHtml = b.Status ? "<span class=\"status-tag status-on\">Hiển thị</span>" : "<span class=\"status-tag status-off\">Ẩn</span>",
                ActionsHtml = string.Format(
                    "<div class=\"menu-actions justify-content-end\">" +
                    "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/system/banners/edit.aspx?id={0}\">" +
                    "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                    "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteBanner({0});\">" +
                    "<i class=\"fa-solid fa-trash\"></i> Xóa</button></div>", b.Id)
            }).ToList();

            var total = rows.Count;

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.Title) && r.Title.ToLowerInvariant().Contains(keyword)).ToList();
            }

            if (!string.IsNullOrWhiteSpace(title))
            {
                var keyword = title.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.Title) && r.Title.ToLowerInvariant().Contains(keyword)).ToList();
            }

            if (!string.IsNullOrWhiteSpace(position))
            {
                rows = rows.Where(r => string.Equals(r.PositionLabel, GetPositionLabel(position), StringComparison.OrdinalIgnoreCase)).ToList();
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter).ToList();
            }

            var filtered = rows.Count;
            rows = ApplyOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length)
                .ToList();

            return new DataTableResult<BannerRow>
            {
                draw = draw,
                recordsTotal = total,
                recordsFiltered = filtered,
                data = rows
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult DeleteBanner(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var banner = db.CfBanners.FirstOrDefault(b => b.Id == id);
            if (banner == null)
            {
                return new ActionResult { Success = false, Message = "Banner không tồn tại." };
            }

            db.CfBanners.Remove(banner);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }

    private static IEnumerable<BannerRow> ApplyOrdering(IEnumerable<BannerRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 1:
                return desc ? rows.OrderByDescending(r => r.Title) : rows.OrderBy(r => r.Title);
            case 2:
                return desc ? rows.OrderByDescending(r => r.PositionLabel) : rows.OrderBy(r => r.PositionLabel);
            case 3:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }

    private static string GetPositionLabel(string position)
    {
        if (string.IsNullOrWhiteSpace(position))
        {
            return "-";
        }

        int pos;
        if (int.TryParse(position, out pos) && pos >= 1 && pos <= 6)
        {
            return string.Format("Vị trí {0}", pos);
        }

        return position;
    }
}

public class BannerRow
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string ImageHtml { get; set; }
    public string PositionLabel { get; set; }
    public int SortOrder { get; set; }
    public string StatusHtml { get; set; }
    public int StatusValue { get; set; }
    public string ActionsHtml { get; set; }
}
