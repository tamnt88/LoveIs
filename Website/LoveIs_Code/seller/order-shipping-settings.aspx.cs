using System;
using System.Globalization;
using System.Linq;
using System.Web;

public partial class SellerOrderShippingSettings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPage();
        }
    }

    private void BindPage()
    {
        ShippingMessageLiteral.Text = string.Empty;

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            ShippingMessageLiteral.Text = "<div class='alert alert-danger'>Phiên đăng nhập đã hết hạn.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopId = db.CfShops.AsNoTracking()
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => (int?)s.Id)
                .FirstOrDefault();

            if (!shopId.HasValue)
            {
                ShippingMessageLiteral.Text = "<div class='alert alert-danger'>Không tìm thấy cửa hàng.</div>";
                return;
            }

            var config = db.CfShopShippingConfigs.AsNoTracking()
                .FirstOrDefault(c => c.ShopId == shopId.Value && c.Status);

            BindShippingMethods(db, config);
            BindCarriers(db, shopId.Value, config);
            BindPickupAddress(db, shopId.Value);

            if (config != null)
            {
                FreeShippingToggle.Checked = config.FreeShippingEnabled;
                FreeShippingMinOrderInput.Text = config.FreeShippingMinOrder > 0
                    ? config.FreeShippingMinOrder.ToString("0.##", CultureInfo.InvariantCulture)
                    : string.Empty;
            }
        }
    }

    private void BindShippingMethods(BeautyStoryContext db, CfShopShippingConfig config)
    {
        var methods = db.CfShippingMethods.AsNoTracking()
            .Where(m => m.Status)
            .OrderByDescending(m => m.IsDefault)
            .ThenBy(m => m.SortOrder)
            .ThenBy(m => m.Id)
            .ToList();

        ShippingMethodDropDown.Items.Clear();
        ShippingMethodDropDown.Items.Add(new System.Web.UI.WebControls.ListItem("-- Chọn phương thức --", ""));
        foreach (var method in methods)
        {
            ShippingMethodDropDown.Items.Add(new System.Web.UI.WebControls.ListItem(method.Name, method.Id.ToString(CultureInfo.InvariantCulture)));
        }

        var selectedId = 0;
        if (config != null && config.DefaultShippingMethodId > 0)
        {
            selectedId = config.DefaultShippingMethodId;
        }
        else
        {
            var defaultMethod = methods.FirstOrDefault(m => m.IsDefault);
            if (defaultMethod != null)
            {
                selectedId = defaultMethod.Id;
            }
        }

        if (selectedId > 0)
        {
            ShippingMethodDropDown.SelectedValue = selectedId.ToString(CultureInfo.InvariantCulture);
        }
    }

    private void BindCarriers(BeautyStoryContext db, int shopId, CfShopShippingConfig config)
    {
        var carriers = db.CfShippingCarriers.AsNoTracking()
            .Where(c => c.Status)
            .OrderByDescending(c => c.IsDefault)
            .ThenBy(c => c.SortOrder)
            .ThenBy(c => c.Id)
            .ToList();

        var enabledCarrierIds = db.CfShopShippingCarriers.AsNoTracking()
            .Where(c => c.ShopId == shopId && c.Status)
            .Select(c => c.CarrierId)
            .ToList();

        var hasEnabled = enabledCarrierIds.Count > 0;
        var defaultCarrierId = config != null ? config.DefaultShippingCarrierId : null;

        var view = carriers.Select(c => new
        {
            c.Id,
            c.Name,
            Description = string.IsNullOrWhiteSpace(c.Description) ? "Phí theo cấu hình hệ thống" : c.Description,
            IsEnabled = hasEnabled ? enabledCarrierIds.Contains(c.Id) : true,
            IsDefault = defaultCarrierId.HasValue ? defaultCarrierId.Value == c.Id : c.IsDefault
        }).ToList();

        if (!view.Any(v => v.IsDefault) && view.Count > 0)
        {
            view[0] = new
            {
                view[0].Id,
                view[0].Name,
                view[0].Description,
                view[0].IsEnabled,
                IsDefault = true
            };
        }

        CarrierRepeater.DataSource = view;
        CarrierRepeater.DataBind();
    }

    private void BindPickupAddress(BeautyStoryContext db, int shopId)
    {
        var pickup = db.CfShopAddresses.AsNoTracking()
            .Where(a => a.ShopId == shopId && a.Status && a.AddressType == "pickup")
            .OrderByDescending(a => a.IsDefault)
            .ThenBy(a => a.SortOrder)
            .ThenBy(a => a.Id)
            .FirstOrDefault();

        if (pickup == null)
        {
            PickupAddressPanel.Visible = false;
            PickupEmptyPanel.Visible = true;
            return;
        }

        PickupEmptyPanel.Visible = false;
        PickupAddressPanel.Visible = true;

        var title = string.IsNullOrWhiteSpace(pickup.Title) ? "Địa chỉ lấy hàng" : pickup.Title.Trim();
        PickupAddressTitleLiteral.Text = HttpUtility.HtmlEncode(title);
        PickupAddressLineLiteral.Text = HttpUtility.HtmlEncode(BuildAddressLine(pickup));
        PickupAddressPhoneLiteral.Text = HttpUtility.HtmlEncode(pickup.Phone ?? string.Empty);
        PickupDefaultPill.Visible = pickup.IsDefault;
    }

    private static string BuildAddressLine(CfShopAddress address)
    {
        var parts = new System.Collections.Generic.List<string>();
        if (!string.IsNullOrWhiteSpace(address.AddressLine))
        {
            parts.Add(address.AddressLine.Trim());
        }
        if (!string.IsNullOrWhiteSpace(address.WardName))
        {
            parts.Add(address.WardName.Trim());
        }
        if (!string.IsNullOrWhiteSpace(address.ProvinceName))
        {
            parts.Add(address.ProvinceName.Trim());
        }
        return string.Join(", ", parts);
    }

    protected void SaveShippingButton_Click(object sender, EventArgs e)
    {
        ShippingMessageLiteral.Text = string.Empty;

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            ShippingMessageLiteral.Text = "<div class='alert alert-danger'>Phiên đăng nhập đã hết hạn.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shopId = db.CfShops.AsNoTracking()
                .Where(s => s.SellerId == sellerId.Value)
                .Select(s => (int?)s.Id)
                .FirstOrDefault();

            if (!shopId.HasValue)
            {
                ShippingMessageLiteral.Text = "<div class='alert alert-danger'>Không tìm thấy cửa hàng.</div>";
                return;
            }

            var carrierIdsRaw = Request.Form.GetValues("carrierIds") ?? new string[0];
            var carrierIds = carrierIdsRaw
                .Select(x => ParseInt(x))
                .Where(x => x > 0)
                .Distinct()
                .ToList();

            if (carrierIds.Count == 0)
            {
                ShippingMessageLiteral.Text = "<div class='alert alert-danger'>Vui lòng chọn ít nhất một hãng vận chuyển.</div>";
                return;
            }

            var defaultCarrierId = ParseInt(Request.Form["defaultCarrier"]);
            if (!carrierIds.Contains(defaultCarrierId))
            {
                defaultCarrierId = carrierIds[0];
            }

            var methodId = ParseInt(ShippingMethodDropDown.SelectedValue);
            if (methodId <= 0)
            {
                ShippingMessageLiteral.Text = "<div class='alert alert-danger'>Vui lòng chọn phương thức vận chuyển.</div>";
                return;
            }

            var config = db.CfShopShippingConfigs.FirstOrDefault(c => c.ShopId == shopId.Value && c.Status);
            if (config == null)
            {
                config = new CfShopShippingConfig
                {
                    ShopId = shopId.Value,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture)
                };
                db.CfShopShippingConfigs.Add(config);
            }

            config.DefaultShippingMethodId = methodId;
            config.DefaultShippingCarrierId = defaultCarrierId;
            config.FreeShippingEnabled = FreeShippingToggle.Checked;
            config.FreeShippingMinOrder = ParseDecimal(FreeShippingMinOrderInput.Text);

            var existingCarriers = db.CfShopShippingCarriers.Where(c => c.ShopId == shopId.Value).ToList();
            if (existingCarriers.Count > 0)
            {
                db.CfShopShippingCarriers.RemoveRange(existingCarriers);
            }

            foreach (var carrierId in carrierIds)
            {
                db.CfShopShippingCarriers.Add(new CfShopShippingCarrier
                {
                    ShopId = shopId.Value,
                    CarrierId = carrierId,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture)
                });
            }

            db.SaveChanges();
        }

        ShippingMessageLiteral.Text = "<div class='alert alert-success'>Đã lưu cài đặt vận chuyển.</div>";
        BindPage();
    }

    private static int ParseInt(string value)
    {
        int result;
        return int.TryParse(value, out result) ? result : 0;
    }

    private static decimal ParseDecimal(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return 0m;
        }

        var raw = value.Replace(".", "").Replace(",", "");
        decimal result;
        if (decimal.TryParse(raw, NumberStyles.Any, CultureInfo.InvariantCulture, out result))
        {
            return result;
        }

        return 0m;
    }
}

