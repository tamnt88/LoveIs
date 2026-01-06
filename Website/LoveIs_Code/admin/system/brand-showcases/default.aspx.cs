using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.Script.Services;

public partial class AdminSystemBrandShowcasesDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBrands();
        }
    }

    private void BindBrands()
    {
        using (var db = new BeautyStoryContext())
        {
            var brands = db.CfBrands
                .OrderBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();

            BrandFilter.Items.Clear();
            BrandFilter.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả thương hiệu", ""));
            foreach (var brand in brands)
            {
                BrandFilter.Items.Add(new System.Web.UI.WebControls.ListItem(brand.BrandName, brand.Id.ToString()));
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ShowcaseRow> GetShowcases(int draw, int start, int length, string search, int orderColumn, string orderDir, string brandId, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var query = from showcase in db.CfBrandShowcases
                        join brand in db.CfBrands on showcase.BrandId equals brand.Id into brandGroup
                        from brand in brandGroup.DefaultIfEmpty()
                        select new
                        {
                            showcase,
                            BrandName = brand != null ? brand.BrandName : ""
                        };

            int brandFilterId;
            if (int.TryParse(brandId, out brandFilterId) && brandFilterId > 0)
            {
                query = query.Where(x => x.showcase.BrandId == brandFilterId);
            }

            if (!string.IsNullOrWhiteSpace(status))
            {
                bool statusValue = status == "1";
                query = query.Where(x => x.showcase.Status == statusValue);
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(x => x.BrandName.Contains(search) || x.showcase.Title.Contains(search));
            }

            int recordsTotal = query.Count();

            switch (orderColumn)
            {
                case 0:
                    query = orderDir == "desc" ? query.OrderByDescending(x => x.BrandName) : query.OrderBy(x => x.BrandName);
                    break;
                case 1:
                    query = orderDir == "desc" ? query.OrderByDescending(x => x.showcase.Title) : query.OrderBy(x => x.showcase.Title);
                    break;
                case 3:
                    query = orderDir == "desc" ? query.OrderByDescending(x => x.showcase.SortOrder) : query.OrderBy(x => x.showcase.SortOrder);
                    break;
                default:
                    query = query.OrderBy(x => x.showcase.SortOrder).ThenBy(x => x.showcase.Id);
                    break;
            }

            var data = query.Skip(start).Take(length).ToList();

            var rows = data.Select(x => new ShowcaseRow
            {
                Id = x.showcase.Id,
                BrandName = string.IsNullOrWhiteSpace(x.BrandName) ? "(Chưa có)" : x.BrandName,
                Title = string.IsNullOrWhiteSpace(x.showcase.Title) ? "-" : x.showcase.Title,
                VideoHtml = string.IsNullOrWhiteSpace(x.showcase.VideoUrl) ? "<span class='text-muted'>Không có</span>" : "<span class='badge bg-success'>Có</span>",
                SortOrder = x.showcase.SortOrder,
                StatusHtml = x.showcase.Status ? "<span class='status-tag status-on'>Hiển thị</span>" : "<span class='status-tag status-off'>Ẩn</span>",
                ActionsHtml = string.Format("<div class='menu-actions justify-content-end'>" +
                                            "<a class='btn btn-sm btn-outline-primary btn-with-icon' href='/admin/system/brand-showcases/edit.aspx?id={0}'><i class='fa-solid fa-pen'></i> Sửa</a>" +
                                            "<button type='button' class='btn btn-sm btn-outline-danger btn-with-icon' onclick='deleteShowcase({0})'><i class='fa-solid fa-trash'></i> Xóa</button>" +
                                            "</div>", x.showcase.Id)
            }).ToList();

            return new DataTableResult<ShowcaseRow>
            {
                draw = draw,
                recordsTotal = recordsTotal,
                recordsFiltered = recordsTotal,
                data = rows
            };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult DeleteShowcase(int id)
    {
        if (id <= 0)
        {
            return new ActionResult { Success = false, Message = "Dữ liệu không hợp lệ." };
        }

        using (var db = new BeautyStoryContext())
        {
            var showcase = db.CfBrandShowcases.FirstOrDefault(s => s.Id == id);
            if (showcase == null)
            {
                return new ActionResult { Success = false, Message = "Không tìm thấy dữ liệu." };
            }

            var banners = db.CfBrandShowcaseBanners.Where(b => b.ShowcaseId == id).ToList();
            if (banners.Count > 0)
            {
                db.CfBrandShowcaseBanners.RemoveRange(banners);
            }

            db.CfBrandShowcases.Remove(showcase);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Đã xóa thương hiệu tiêu biểu." };
    }

    public class ShowcaseRow
    {
        public int Id { get; set; }
        public string BrandName { get; set; }
        public string Title { get; set; }
        public string VideoHtml { get; set; }
        public int SortOrder { get; set; }
        public string StatusHtml { get; set; }
        public string ActionsHtml { get; set; }
    }
}
