using System;
using System.Linq;
using System.Text.RegularExpressions;

public partial class CustomerAddressPage : CustomerPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProvinces();
            BindAddresses();
            return;
        }

        EnsureAddressFormOpen();
    }

    protected void SaveAddressButton_Click(object sender, EventArgs e)
    {
        StatusMessage.Text = string.Empty;

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        var fullName = (FullNameInput.Text ?? string.Empty).Trim();
        var phone = (PhoneInput.Text ?? string.Empty).Trim();
        var address = (AddressInput.Text ?? string.Empty).Trim();
        var provinceId = SafeInt(ProvinceSelect.SelectedValue);
        var wardId = SafeInt(WardSelect.SelectedValue);

        if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(phone) || string.IsNullOrWhiteSpace(address))
        {
            StatusMessage.Text = "Vui lòng nhập đầy đủ họ tên, số điện thoại và địa chỉ.";
            return;
        }

        if (!IsValidPhone(phone))
        {
            StatusMessage.Text = "Số điện thoại không đúng định dạng.";
            return;
        }

        if (!provinceId.HasValue || !wardId.HasValue)
        {
            StatusMessage.Text = "Vui lòng chọn Tỉnh/Thành phố và Phường/Xã.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var hasDefault = db.CfCustomerAddresses.Any(a => a.CustomerId == customerId.Value && a.IsDefault);
            var province = db.CfProvinces.FirstOrDefault(p => p.Id == provinceId.Value);
            var ward = db.CfWards.FirstOrDefault(w => w.Id == wardId.Value);

            var entity = new CfCustomerAddress
            {
                CustomerId = customerId.Value,
                FullName = fullName,
                Phone = phone,
                AddressLine = address,
                ProvinceId = provinceId,
                WardId = wardId,
                ProvinceName = province != null ? province.ProvinceName : null,
                WardName = ward != null ? ward.WardName : null,
                IsDefault = !hasDefault,
                Status = true,
                CreatedAt = DateTime.UtcNow
            };
            db.CfCustomerAddresses.Add(entity);
            db.SaveChanges();
        }

        StatusMessage.Text = "Đã thêm địa chỉ mới.";
        ClearForm();
        BindAddresses();
    }

    protected void AddressRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        int id;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out id))
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var address = db.CfCustomerAddresses.FirstOrDefault(a => a.Id == id && a.CustomerId == customerId.Value);
            if (address == null)
            {
                return;
            }

            if (e.CommandName == "delete")
            {
                db.CfCustomerAddresses.Remove(address);
            }
            else if (e.CommandName == "set-default")
            {
                var items = db.CfCustomerAddresses.Where(a => a.CustomerId == customerId.Value).ToList();
                foreach (var item in items)
                {
                    item.IsDefault = item.Id == address.Id;
                }
            }

            db.SaveChanges();

            var remaining = db.CfCustomerAddresses
                .Where(a => a.CustomerId == customerId.Value)
                .ToList();
            if (remaining.Count > 0 && !remaining.Any(a => a.IsDefault))
            {
                remaining[0].IsDefault = true;
                db.SaveChanges();
            }
        }

        BindAddresses();
    }

    protected void ProvinceSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        EnsureAddressFormOpen();
        BindWards(SafeInt(ProvinceSelect.SelectedValue));
    }

    private void BindAddresses()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfCustomerAddresses
                .Where(a => a.CustomerId == customerId.Value)
                .OrderByDescending(a => a.IsDefault)
                .ThenByDescending(a => a.Id)
                .ToList();
            AddressRepeater.DataSource = items;
            AddressRepeater.DataBind();
        }
    }

    private void ClearForm()
    {
        FullNameInput.Text = string.Empty;
        PhoneInput.Text = string.Empty;
        AddressInput.Text = string.Empty;
        if (ProvinceSelect.Items.Count > 0)
        {
            ProvinceSelect.SelectedIndex = 0;
        }
        BindWards(SafeInt(ProvinceSelect.SelectedValue));
    }

    private void EnsureAddressFormOpen()
    {
        if (AddressForm == null)
        {
            return;
        }

        var current = AddressForm.Attributes["class"] ?? string.Empty;
        if (!current.Contains("show"))
        {
            AddressForm.Attributes["class"] = (current + " show").Trim();
        }
    }

    private void BindProvinces()
    {
        using (var db = new BeautyStoryContext())
        {
            var items = db.CfProvinces
                .Where(p => p.Status)
                .OrderBy(p => p.SortOrder)
                .ThenBy(p => p.ProvinceName)
                .ToList();
            ProvinceSelect.DataSource = items;
            ProvinceSelect.DataTextField = "ProvinceName";
            ProvinceSelect.DataValueField = "Id";
            ProvinceSelect.DataBind();
        }

        ProvinceSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Chọn tỉnh/thành phố --", ""));
        BindWards(null);
    }

    private void BindWards(int? provinceId)
    {
        WardSelect.Items.Clear();
        if (!provinceId.HasValue)
        {
            WardSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Chọn phường/xã --", ""));
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfWards
                .Where(w => w.Status && w.ProvinceId == provinceId.Value)
                .OrderBy(w => w.SortOrder)
                .ThenBy(w => w.WardName)
                .ToList();
            WardSelect.DataSource = items;
            WardSelect.DataTextField = "WardName";
            WardSelect.DataValueField = "Id";
            WardSelect.DataBind();
        }

        WardSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Chọn phường/xã --", ""));
    }

    private static int? SafeInt(string value)
    {
        int parsed;
        return int.TryParse(value, out parsed) ? (int?)parsed : null;
    }

    private static bool IsValidPhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone))
        {
            return false;
        }

        return Regex.IsMatch(phone, @"^(0|\+84)(\d{9,10})$");
    }
}
