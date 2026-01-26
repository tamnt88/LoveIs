using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

public partial class SellerSettingsAddress : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProvinces();
            BindAddresses();
        }
    }

    protected void AddAddressButton_Click(object sender, EventArgs e)
    {
        ShowModal(null);
    }

    protected void CloseModalButton_Click(object sender, EventArgs e)
    {
        AddressModal.Visible = false;
    }

    protected void SaveAddressButton_Click(object sender, EventArgs e)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        var addressId = ParseInt(AddressIdHidden.Value);
        var shopId = ParseInt(ShopIdHidden.Value);
        if (shopId == 0)
        {
            using (var db = new BeautyStoryContext())
            {
                var shop = db.CfShops.FirstOrDefault(s => s.SellerId == sellerId.Value);
                if (shop != null)
                {
                    shopId = shop.Id;
                }
            }
        }

        if (shopId == 0)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            CfShopAddress address = null;
            if (addressId > 0)
            {
                address = db.CfShopAddresses.FirstOrDefault(a => a.Id == addressId && a.ShopId == shopId && a.Status);
            }

            if (address == null)
            {
                address = new CfShopAddress
                {
                    ShopId = shopId,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture),
                    Status = true,
                    SortOrder = 0
                };
                db.CfShopAddresses.Add(address);
            }
            else
            {
                address.UpdatedAt = DateTime.Now;
                address.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
            }

            address.Title = (TitleInput.Text ?? string.Empty).Trim();
            address.AddressType = TypeDropDown.SelectedValue;
            address.ContactName = (ContactNameInput.Text ?? string.Empty).Trim();
            address.Phone = (PhoneInput.Text ?? string.Empty).Trim();
            address.AddressLine = (AddressLineInput.Text ?? string.Empty).Trim();
            address.ProvinceId = ParseNullableInt(ProvinceDropDown.SelectedValue);
            address.WardId = ParseNullableInt(WardDropDown.SelectedValue);
            address.ProvinceName = ProvinceDropDown.SelectedItem != null ? ProvinceDropDown.SelectedItem.Text : string.Empty;
            address.WardName = WardDropDown.SelectedItem != null ? WardDropDown.SelectedItem.Text : string.Empty;

            if (DefaultCheckBox.Checked)
            {
                var existing = db.CfShopAddresses
                    .Where(a => a.ShopId == shopId && a.Status && a.AddressType == address.AddressType)
                    .ToList();
                foreach (var item in existing)
                {
                    item.IsDefault = false;
                }
            }

            address.IsDefault = DefaultCheckBox.Checked;

            db.SaveChanges();
        }

        AddressModal.Visible = false;
        BindAddresses();
    }

    protected void AddressRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        var id = ParseInt(e.CommandArgument as string);
        if (id == 0)
        {
            return;
        }

        if (e.CommandName == "EditAddress")
        {
            ShowModal(id);
            return;
        }

        if (e.CommandName == "DeleteAddress")
        {
            DeleteAddress(id);
            return;
        }

        if (e.CommandName == "SetDefault")
        {
            SetDefaultAddress(id);
        }
    }

    private void BindAddresses()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopIds = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => s.Id)
                .ToList();

            if (shopIds.Count == 0)
            {
                PickupCountLiteral.Text = "0";
                ReturnCountLiteral.Text = "0";
                AddressRepeater.DataSource = new List<AddressViewModel>();
                AddressRepeater.DataBind();
                return;
            }

            var addresses = db.CfShopAddresses
                .Where(a => a.Status && shopIds.Contains(a.ShopId))
                .OrderByDescending(a => a.IsDefault)
                .ThenBy(a => a.SortOrder)
                .ThenByDescending(a => a.Id)
                .ToList();

            var pickupCount = addresses.Count(a => string.Equals(a.AddressType, "pickup", StringComparison.OrdinalIgnoreCase));
            var returnCount = addresses.Count(a => string.Equals(a.AddressType, "return", StringComparison.OrdinalIgnoreCase));

            PickupCountLiteral.Text = pickupCount.ToString(CultureInfo.InvariantCulture);
            ReturnCountLiteral.Text = returnCount.ToString(CultureInfo.InvariantCulture);

            var models = addresses.Select(a => new AddressViewModel
            {
                Id = a.Id,
                Title = string.IsNullOrWhiteSpace(a.Title) ? "Địa chỉ" : a.Title,
                TypeLabel = string.Equals(a.AddressType, "return", StringComparison.OrdinalIgnoreCase) ? "Địa chỉ trả hàng" : "Địa chỉ lấy hàng",
                ContactLine = string.Format("{0} | {1}",
                    string.IsNullOrWhiteSpace(a.ContactName) ? "-" : a.ContactName,
                    string.IsNullOrWhiteSpace(a.Phone) ? "-" : a.Phone),
                AddressLine = string.IsNullOrWhiteSpace(a.AddressLine) ? "-" : a.AddressLine,
                AreaLine = BuildAreaLine(a),
                IsDefault = a.IsDefault,
                MainCardClass = a.IsDefault ? "address-card-main" : string.Empty
            }).ToList();

            AddressRepeater.DataSource = models;
            AddressRepeater.DataBind();
        }
    }

    private void ShowModal(int? addressId)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shop = db.CfShops.FirstOrDefault(s => s.SellerId == sellerId.Value);
            if (shop == null)
            {
                return;
            }

            AddressIdHidden.Value = addressId.HasValue ? addressId.Value.ToString(CultureInfo.InvariantCulture) : string.Empty;
            ShopIdHidden.Value = shop.Id.ToString(CultureInfo.InvariantCulture);

            if (addressId.HasValue)
            {
                var address = db.CfShopAddresses.FirstOrDefault(a => a.Id == addressId.Value && a.ShopId == shop.Id && a.Status);
                if (address == null)
                {
                    return;
                }

                ModalTitleLiteral.Text = "Cập nhật địa chỉ";
                TitleInput.Text = address.Title;
                TypeDropDown.SelectedValue = string.IsNullOrWhiteSpace(address.AddressType) ? "pickup" : address.AddressType;
                ContactNameInput.Text = address.ContactName;
                PhoneInput.Text = address.Phone;
                AddressLineInput.Text = address.AddressLine;
                BindProvinces();
                if (address.ProvinceId.HasValue)
                {
                    ProvinceDropDown.SelectedValue = address.ProvinceId.Value.ToString(CultureInfo.InvariantCulture);
                }
                else if (!string.IsNullOrWhiteSpace(address.ProvinceName))
                {
                    SetSelectedByText(ProvinceDropDown, address.ProvinceName);
                }
                BindWards(ParseNullableInt(ProvinceDropDown.SelectedValue));
                if (address.WardId.HasValue)
                {
                    WardDropDown.SelectedValue = address.WardId.Value.ToString(CultureInfo.InvariantCulture);
                }
                else if (!string.IsNullOrWhiteSpace(address.WardName))
                {
                    SetSelectedByText(WardDropDown, address.WardName);
                }
                DefaultCheckBox.Checked = address.IsDefault;
            }
            else
            {
                ModalTitleLiteral.Text = "Thêm địa chỉ";
                TitleInput.Text = string.Empty;
                TypeDropDown.SelectedValue = "pickup";
                ContactNameInput.Text = string.Empty;
                PhoneInput.Text = string.Empty;
                AddressLineInput.Text = string.Empty;
                BindProvinces();
                BindWards(ParseNullableInt(ProvinceDropDown.SelectedValue));
                DefaultCheckBox.Checked = false;
            }
        }

        AddressModal.Visible = true;
    }

    private void DeleteAddress(int id)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var address = db.CfShopAddresses.FirstOrDefault(a => a.Id == id && a.Status);
            if (address == null)
            {
                return;
            }

            var shop = db.CfShops.FirstOrDefault(s => s.Id == address.ShopId && s.SellerId == sellerId.Value);
            if (shop == null)
            {
                return;
            }

            address.Status = false;
            address.UpdatedAt = DateTime.Now;
            address.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
            db.SaveChanges();
        }

        BindAddresses();
    }

    private void SetDefaultAddress(int id)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var address = db.CfShopAddresses.FirstOrDefault(a => a.Id == id && a.Status);
            if (address == null)
            {
                return;
            }

            var shop = db.CfShops.FirstOrDefault(s => s.Id == address.ShopId && s.SellerId == sellerId.Value);
            if (shop == null)
            {
                return;
            }

            var existing = db.CfShopAddresses
                .Where(a => a.ShopId == address.ShopId && a.Status && a.AddressType == address.AddressType)
                .ToList();
            foreach (var item in existing)
            {
                item.IsDefault = false;
            }

            address.IsDefault = true;
            address.UpdatedAt = DateTime.Now;
            address.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
            db.SaveChanges();
        }

        BindAddresses();
    }

    private static int ParseInt(string raw)
    {
        int value;
        if (int.TryParse(raw, out value))
        {
            return value;
        }
        return 0;
    }

    private static int? ParseNullableInt(string raw)
    {
        int value;
        if (int.TryParse(raw, out value) && value > 0)
        {
            return value;
        }
        return null;
    }

    private static string BuildAreaLine(CfShopAddress address)
    {
        var parts = new List<string>();
        if (!string.IsNullOrWhiteSpace(address.WardName))
        {
            parts.Add(address.WardName);
        }
        if (!string.IsNullOrWhiteSpace(address.ProvinceName))
        {
            parts.Add(address.ProvinceName);
        }
        return parts.Count == 0 ? "-" : string.Join(", ", parts);
    }

    protected void ProvinceDropDown_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindWards(ParseNullableInt(ProvinceDropDown.SelectedValue));
        AddressModal.Visible = true;
    }

    private void BindProvinces()
    {
        using (var db = new BeautyStoryContext())
        {
            var provinces = db.CfProvinces
                .OrderBy(p => p.ProvinceName)
                .Select(p => new { p.Id, p.ProvinceName })
                .ToList();

            ProvinceDropDown.DataSource = provinces;
            ProvinceDropDown.DataTextField = "ProvinceName";
            ProvinceDropDown.DataValueField = "Id";
            ProvinceDropDown.DataBind();
            ProvinceDropDown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Chọn tỉnh/thành phố --", ""));
        }
    }

    private void BindWards(int? provinceId)
    {
        using (var db = new BeautyStoryContext())
        {
            var wardsQuery = db.CfWards.AsQueryable();
            if (provinceId.HasValue)
            {
                wardsQuery = wardsQuery.Where(w => w.ProvinceId == provinceId.Value);
            }

            var wards = wardsQuery
                .OrderBy(w => w.WardName)
                .Select(w => new { w.Id, w.WardName })
                .ToList();

            WardDropDown.DataSource = wards;
            WardDropDown.DataTextField = "WardName";
            WardDropDown.DataValueField = "Id";
            WardDropDown.DataBind();
            WardDropDown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Chọn phường/xã --", ""));
        }
    }

    private static void SetSelectedByText(System.Web.UI.WebControls.DropDownList list, string text)
    {
        if (list == null || string.IsNullOrWhiteSpace(text))
        {
            return;
        }

        foreach (System.Web.UI.WebControls.ListItem item in list.Items)
        {
            if (string.Equals(item.Text, text, StringComparison.OrdinalIgnoreCase))
            {
                list.ClearSelection();
                item.Selected = true;
                return;
            }
        }
    }

    private class AddressViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string TypeLabel { get; set; }
        public string ContactLine { get; set; }
        public string AddressLine { get; set; }
        public string AreaLine { get; set; }
        public bool IsDefault { get; set; }
        public string MainCardClass { get; set; }
    }
}
