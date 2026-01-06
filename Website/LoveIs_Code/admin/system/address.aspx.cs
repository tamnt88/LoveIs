using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class AdminSystemAddress : AdminBasePage
{
    public string ActiveTab = "province";

    protected void Page_Load(object sender, EventArgs e)
    {
        ActiveTab = string.Equals(Request.QueryString["tab"], "ward", StringComparison.OrdinalIgnoreCase) ? "ward" : "province";
        ActiveTabInput.Value = ActiveTab;

        if (!IsPostBack)
        {
            BindProvinceInputs();
            BindWardFilters();
            LoadEditProvince();
            LoadEditWard();
        }
    }

    private void BindProvinceInputs()
    {
        using (var db = new BeautyStoryContext())
        {
            var provinces = db.CfProvinces.OrderBy(p => p.SortOrder).ThenBy(p => p.ProvinceName).ToList();
            WardProvinceInput.Items.Clear();
            WardProvinceInput.Items.Add(new ListItem("-- Chọn tỉnh --", ""));
            foreach (var province in provinces)
            {
                WardProvinceInput.Items.Add(new ListItem(province.ProvinceName, province.Id.ToString()));
            }
        }
    }

    private void BindWardFilters()
    {
        using (var db = new BeautyStoryContext())
        {
            var provinces = db.CfProvinces.OrderBy(p => p.SortOrder).ThenBy(p => p.ProvinceName).ToList();
            WardProvinceFilterRepeater.DataSource = provinces;
            WardProvinceFilterRepeater.DataBind();
        }
    }

    private void LoadEditProvince()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0 || ActiveTab != "province")
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var province = db.CfProvinces.FirstOrDefault(p => p.Id == id);
            if (province == null)
            {
                return;
            }

            ProvinceIdInput.Value = province.Id.ToString();
            ProvinceNameInput.Text = province.ProvinceName;
            ProvinceSortOrderInput.Text = province.SortOrder.ToString();
            ProvinceStatusInput.Checked = province.Status;
        }
    }

    private void LoadEditWard()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0 || ActiveTab != "ward")
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var ward = db.CfWards.FirstOrDefault(w => w.Id == id);
            if (ward == null)
            {
                return;
            }

            WardIdInput.Value = ward.Id.ToString();
            WardNameInput.Text = ward.WardName;
            WardSortOrderInput.Text = ward.SortOrder.ToString();
            WardStatusInput.Checked = ward.Status;
            WardProvinceInput.SelectedValue = ward.ProvinceId.ToString();
        }
    }

    protected void ProvinceSaveButton_Click(object sender, EventArgs e)
    {
        int id;
        int sortOrder;
        int.TryParse(ProvinceIdInput.Value, out id);
        int.TryParse(ProvinceSortOrderInput.Text, out sortOrder);

        if (string.IsNullOrWhiteSpace(ProvinceNameInput.Text))
        {
            ProvinceMessage.CssClass = "text-danger small d-block mb-2";
            ProvinceMessage.Text = "Vui lòng nhập tên tỉnh.";
            return;
        }

        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            CfProvince province;
            if (id > 0)
            {
                province = db.CfProvinces.FirstOrDefault(p => p.Id == id);
                if (province == null)
                {
                    return;
                }
            }
            else
            {
                province = new CfProvince
                {
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy
                };
                db.CfProvinces.Add(province);
            }

            province.ProvinceName = ProvinceNameInput.Text.Trim();
            province.SortOrder = sortOrder;
            province.Status = ProvinceStatusInput.Checked;
            province.UpdatedAt = DateTime.Now;
            province.UpdatedBy = updatedBy;
            db.SaveChanges();
        }

        Response.Redirect("/admin/system/address.aspx?tab=province");
    }

    protected void WardSaveButton_Click(object sender, EventArgs e)
    {
        int id;
        int sortOrder;
        int provinceId;
        int.TryParse(WardIdInput.Value, out id);
        int.TryParse(WardSortOrderInput.Text, out sortOrder);
        int.TryParse(WardProvinceInput.SelectedValue, out provinceId);

        if (provinceId <= 0)
        {
            WardMessage.CssClass = "text-danger small d-block mb-2";
            WardMessage.Text = "Vui lòng chọn tỉnh.";
            return;
        }

        if (string.IsNullOrWhiteSpace(WardNameInput.Text))
        {
            WardMessage.CssClass = "text-danger small d-block mb-2";
            WardMessage.Text = "Vui lòng nhập tên phường.";
            return;
        }

        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            CfWard ward;
            if (id > 0)
            {
                ward = db.CfWards.FirstOrDefault(w => w.Id == id);
                if (ward == null)
                {
                    return;
                }
            }
            else
            {
                ward = new CfWard
                {
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy
                };
                db.CfWards.Add(ward);
            }

            ward.ProvinceId = provinceId;
            ward.WardName = WardNameInput.Text.Trim();
            ward.SortOrder = sortOrder;
            ward.Status = WardStatusInput.Checked;
            ward.UpdatedAt = DateTime.Now;
            ward.UpdatedBy = updatedBy;
            db.SaveChanges();
        }

        Response.Redirect("/admin/system/address.aspx?tab=ward");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static DataTableResult<ProvinceRow> GetProvinces(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var provinces = db.CfProvinces.ToList();
            var rows = provinces
                .Select(p => new ProvinceRow
                {
                    Id = p.Id,
                    ProvinceName = p.ProvinceName,
                    SortOrder = p.SortOrder,
                    StatusValue = p.Status ? 1 : 0,
                    StatusHtml = p.Status ? "<span class=\"status-tag status-on\">Hiển thị</span>" : "<span class=\"status-tag status-off\">Ẩn</span>",
                    ActionsHtml = string.Format(
                        "<div class=\"menu-actions justify-content-end\">" +
                        "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/system/address.aspx?tab=province&id={0}\">" +
                        "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteProvince({0});\">" +
                        "<i class=\"fa-solid fa-trash\"></i> Xóa</button></div>", p.Id)
                })
                .ToList();

            var total = rows.Count;

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.ProvinceName) && r.ProvinceName.ToLowerInvariant().Contains(keyword)).ToList();
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.ProvinceName) && r.ProvinceName.ToLowerInvariant().Contains(keyword)).ToList();
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter).ToList();
            }

            var filtered = rows.Count;
            rows = ApplyProvinceOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length)
                .ToList();

            return new DataTableResult<ProvinceRow>
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
    public static DataTableResult<WardRow> GetWards(int draw, int start, int length, string search, int orderColumn, string orderDir, string name, string provinceId, string status)
    {
        using (var db = new BeautyStoryContext())
        {
            var wards = db.CfWards.ToList();
            var provinces = db.CfProvinces.ToDictionary(p => p.Id, p => p.ProvinceName);

            var rows = wards.Select(w => new WardRow
            {
                Id = w.Id,
                WardName = w.WardName,
                ProvinceId = w.ProvinceId,
                ProvinceName = provinces.ContainsKey(w.ProvinceId) ? provinces[w.ProvinceId] : "-",
                SortOrder = w.SortOrder,
                StatusValue = w.Status ? 1 : 0,
                StatusHtml = w.Status ? "<span class=\"status-tag status-on\">Hiển thị</span>" : "<span class=\"status-tag status-off\">Ẩn</span>",
                ActionsHtml = string.Format(
                    "<div class=\"menu-actions justify-content-end\">" +
                    "<a class=\"btn btn-sm btn-outline-primary btn-with-icon\" href=\"/admin/system/address.aspx?tab=ward&id={0}\">" +
                    "<i class=\"fa-solid fa-pen\"></i> Sửa</a>" +
                    "<button type=\"button\" class=\"btn btn-sm btn-outline-danger btn-with-icon\" onclick=\"deleteWard({0});\">" +
                    "<i class=\"fa-solid fa-trash\"></i> Xóa</button></div>", w.Id)
            }).ToList();

            var total = rows.Count;

            if (!string.IsNullOrWhiteSpace(search))
            {
                var keyword = search.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.WardName) && r.WardName.ToLowerInvariant().Contains(keyword)).ToList();
            }

            if (!string.IsNullOrWhiteSpace(name))
            {
                var keyword = name.Trim().ToLowerInvariant();
                rows = rows.Where(r => !string.IsNullOrWhiteSpace(r.WardName) && r.WardName.ToLowerInvariant().Contains(keyword)).ToList();
            }

            int provinceFilter;
            if (!string.IsNullOrWhiteSpace(provinceId) && int.TryParse(provinceId, out provinceFilter))
            {
                rows = rows.Where(r => r.ProvinceId == provinceFilter).ToList();
            }

            int statusFilter;
            if (!string.IsNullOrWhiteSpace(status) && int.TryParse(status, out statusFilter))
            {
                rows = rows.Where(r => r.StatusValue == statusFilter).ToList();
            }

            var filtered = rows.Count;
            rows = ApplyWardOrdering(rows, orderColumn, orderDir)
                .Skip(start)
                .Take(length)
                .ToList();

            return new DataTableResult<WardRow>
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
    public static ActionResult DeleteProvince(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var province = db.CfProvinces.FirstOrDefault(p => p.Id == id);
            if (province == null)
            {
                return new ActionResult { Success = false, Message = "Tỉnh không tồn tại." };
            }

            bool hasWards = db.CfWards.Any(w => w.ProvinceId == id);
            if (hasWards)
            {
                return new ActionResult { Success = false, Message = "Không thể xóa tỉnh đang có phường." };
            }

            db.CfProvinces.Remove(province);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResult DeleteWard(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var ward = db.CfWards.FirstOrDefault(w => w.Id == id);
            if (ward == null)
            {
                return new ActionResult { Success = false, Message = "Phường không tồn tại." };
            }

            db.CfWards.Remove(ward);
            db.SaveChanges();
        }

        return new ActionResult { Success = true, Message = "Xóa thành công." };
    }

    private static IEnumerable<ProvinceRow> ApplyProvinceOrdering(IEnumerable<ProvinceRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.ProvinceName) : rows.OrderBy(r => r.ProvinceName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }

    private static IEnumerable<WardRow> ApplyWardOrdering(IEnumerable<WardRow> rows, int orderColumn, string orderDir)
    {
        bool desc = string.Equals(orderDir, "desc", StringComparison.OrdinalIgnoreCase);
        switch (orderColumn)
        {
            case 0:
                return desc ? rows.OrderByDescending(r => r.WardName) : rows.OrderBy(r => r.WardName);
            case 1:
                return desc ? rows.OrderByDescending(r => r.ProvinceName) : rows.OrderBy(r => r.ProvinceName);
            case 2:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
            default:
                return desc ? rows.OrderByDescending(r => r.SortOrder) : rows.OrderBy(r => r.SortOrder);
        }
    }
}

public class ProvinceRow
{
    public int Id { get; set; }
    public string ProvinceName { get; set; }
    public int SortOrder { get; set; }
    public string StatusHtml { get; set; }
    public int StatusValue { get; set; }
    public string ActionsHtml { get; set; }
}

public class WardRow
{
    public int Id { get; set; }
    public int ProvinceId { get; set; }
    public string ProvinceName { get; set; }
    public string WardName { get; set; }
    public int SortOrder { get; set; }
    public string StatusHtml { get; set; }
    public int StatusValue { get; set; }
    public string ActionsHtml { get; set; }
}
