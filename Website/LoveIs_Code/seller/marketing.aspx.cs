using System;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SellerMarketing : Page
{
    private string VoucherTab
    {
        get { return (ViewState["VoucherTab"] as string) ?? "active"; }
        set { ViewState["VoucherTab"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ToastMessageLiteral.Text = string.Empty;
        BindVoucherData();
        ShowToastFromSession();
    }

    protected void TabButton_Click(object sender, EventArgs e)
    {
        var button = sender as Button;
        VoucherTab = button != null ? button.CommandArgument : "active";
        BindVoucherData();
    }

    protected void OpenVoucherModalButton_Click(object sender, EventArgs e)
    {
        ResetVoucherForm();
        VoucherModalTitleLiteral.Text = "Tạo mã giảm giá";
        ToggleVoucherTypeUi();
        VoucherModalPanel.Visible = true;
    }

    protected void CloseVoucherModalButton_Click(object sender, EventArgs e)
    {
        VoucherModalPanel.Visible = false;
    }

    protected void VoucherRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int voucherId;
        if (!int.TryParse(Convert.ToString(e.CommandArgument, CultureInfo.InvariantCulture), out voucherId)) return;

        if (string.Equals(e.CommandName, "Edit", StringComparison.OrdinalIgnoreCase))
        {
            using (var db = new BeautyStoryContext())
            {
                var shopId = GetShopId(db);
                if (!shopId.HasValue) return;

                var voucher = db.CfCoupons.FirstOrDefault(x => x.Id == voucherId && x.ShopId == shopId.Value && x.Scope == "Shop");
                if (voucher == null) return;

                EditingVoucherIdHidden.Value = voucher.Id.ToString(CultureInfo.InvariantCulture);
                VoucherCodeInput.Text = voucher.Code;
                VoucherNameInput.Text = voucher.Name;
                VoucherDescriptionInput.Text = voucher.Description ?? string.Empty;
                VoucherTypeInput.SelectedValue = voucher.DiscountType == "Percent" ? "Percent" : "Fixed";
                VoucherValueInput.Text = voucher.DiscountValue.ToString("0.##", CultureInfo.InvariantCulture);
                VoucherMinOrderInput.Text = voucher.MinOrder.ToString("0.##", CultureInfo.InvariantCulture);
                VoucherMaxDiscountInput.Text = (voucher.MaxDiscount ?? 0).ToString("0.##", CultureInfo.InvariantCulture);
                VoucherStartAtInput.Text = voucher.StartAt.HasValue ? voucher.StartAt.Value.ToString("yyyy-MM-dd") : string.Empty;
                VoucherEndAtInput.Text = voucher.EndAt.HasValue ? voucher.EndAt.Value.ToString("yyyy-MM-dd") : string.Empty;
                VoucherUsageLimitInput.Text = (voucher.UsageLimit ?? 0).ToString(CultureInfo.InvariantCulture);
                VoucherUsagePerUserInput.Text = (voucher.UsagePerUser ?? 1).ToString(CultureInfo.InvariantCulture);
            }

            VoucherModalTitleLiteral.Text = "Chỉnh sửa mã giảm giá";
            VoucherFormErrorLiteral.Text = string.Empty;
            ToggleVoucherTypeUi();
            VoucherModalPanel.Visible = true;
            return;
        }

        if (string.Equals(e.CommandName, "Delete", StringComparison.OrdinalIgnoreCase))
        {
            return;
        }
    }

    protected void VoucherTypeInput_SelectedIndexChanged(object sender, EventArgs e)
    {
        ToggleVoucherTypeUi();
        VoucherModalPanel.Visible = true;
    }

    protected void SaveVoucherButton_Click(object sender, EventArgs e)
    {
        decimal discountValue;
        decimal minOrder;
        decimal maxDiscount;
        int usageLimit;
        int usagePerUser;
        DateTime startAt;
        DateTime endAt;

        if (string.IsNullOrWhiteSpace(VoucherCodeInput.Text) || string.IsNullOrWhiteSpace(VoucherNameInput.Text))
        {
            SetVoucherError("Vui lòng nhập mã và tên voucher.");
            return;
        }

        if (!decimal.TryParse(VoucherMaxDiscountInput.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out maxDiscount) || maxDiscount < 0)
        {
            SetVoucherError("Giảm tối đa không hợp lệ.");
            return;
        }

        if (VoucherTypeInput.SelectedValue == "Percent")
        {
            if (!decimal.TryParse(VoucherValueInput.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out discountValue) || discountValue <= 0 || discountValue >= 100)
            {
                SetVoucherError("Với loại giảm %, giá trị giảm phải trong khoảng (0,100).");
                return;
            }
        }
        else
        {
            discountValue = maxDiscount;
        }

        if (!decimal.TryParse(VoucherMinOrderInput.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out minOrder) || minOrder < 0)
        {
            SetVoucherError("Đơn tối thiểu không hợp lệ.");
            return;
        }

        if (!int.TryParse(VoucherUsageLimitInput.Text, out usageLimit) || usageLimit < 1)
        {
            SetVoucherError("Giới hạn lượt dùng không hợp lệ.");
            return;
        }

        if (!int.TryParse(VoucherUsagePerUserInput.Text, out usagePerUser) || usagePerUser < 1)
        {
            SetVoucherError("Giới hạn mỗi người dùng không hợp lệ.");
            return;
        }

        if (!DateTime.TryParse(VoucherStartAtInput.Text, out startAt) || !DateTime.TryParse(VoucherEndAtInput.Text, out endAt) || startAt > endAt)
        {
            SetVoucherError("Thời gian áp dụng không hợp lệ.");
            return;
        }

        var isNew = true;
        using (var db = new BeautyStoryContext())
        {
            var shopId = GetShopId(db);
            if (!shopId.HasValue)
            {
                SetVoucherError("Không xác định được shop.");
                return;
            }

            int editingId;
            int.TryParse(EditingVoucherIdHidden.Value, out editingId);
            var code = VoucherCodeInput.Text.Trim().ToUpperInvariant();

            var duplicateCode = db.CfCoupons.Any(x => x.Id != editingId && x.Code == code);
            if (duplicateCode)
            {
                SetVoucherError("Mã voucher đã tồn tại.");
                return;
            }

            var voucher = editingId > 0
                ? db.CfCoupons.FirstOrDefault(x => x.Id == editingId && x.ShopId == shopId.Value && x.Scope == "Shop")
                : null;

            if (voucher == null)
            {
                voucher = new CfCoupon
                {
                    Code = code,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "Seller:" + shopId.Value.ToString(CultureInfo.InvariantCulture),
                    Scope = "Shop",
                    ShopId = shopId.Value,
                    Status = true
                };
                db.CfCoupons.Add(voucher);
                isNew = true;
            }
            else
            {
                isNew = false;
            }

            voucher.Code = code;
            voucher.Name = VoucherNameInput.Text.Trim();
            voucher.Description = VoucherDescriptionInput.Text.Trim();
            voucher.DiscountType = VoucherTypeInput.SelectedValue;
            voucher.DiscountValue = discountValue;
            voucher.MinOrder = minOrder;
            voucher.MaxDiscount = maxDiscount;
            voucher.StartAt = startAt;
            voucher.EndAt = endAt;
            voucher.UsageLimit = usageLimit;
            voucher.UsagePerUser = usagePerUser;
            voucher.UpdatedAt = DateTime.Now;
            voucher.UpdatedBy = "Seller:" + shopId.Value.ToString(CultureInfo.InvariantCulture);

            db.SaveChanges();
        }

        VoucherModalPanel.Visible = false;
        var toastMessage = isNew ? "Tạo voucher thành công." : "Cập nhật voucher thành công.";
        SetToastSession(toastMessage, "success");
        Response.Redirect(Request.RawUrl);
    }

    private void BindVoucherData()
    {
        using (var db = new BeautyStoryContext())
        {
            var shopId = GetShopId(db);
            if (!shopId.HasValue)
            {
                VoucherRepeater.DataSource = new object[0];
                VoucherRepeater.DataBind();
                return;
            }

            var couponQuery = db.CfCoupons.Where(x => x.Scope == "Shop" && x.ShopId == shopId.Value && x.Status);
            var usageAgg = db.CfCouponUsages.GroupBy(x => x.CouponId)
                .Select(g => new { CouponId = g.Key, Used = g.Count(), Revenue = g.Sum(x => (decimal?)x.DiscountAmount) ?? 0m })
                .ToList();

            var now = DateTime.Now;
            var data = couponQuery.ToList()
                .Select(x =>
                {
                    var usage = usageAgg.FirstOrDefault(u => u.CouponId == x.Id);
                    var used = usage != null ? usage.Used : 0;
                    var revenue = usage != null ? usage.Revenue : 0m;
                    var isScheduled = x.StartAt.HasValue && x.StartAt.Value > now;
                    var isExpired = x.EndAt.HasValue && x.EndAt.Value < now;
                    var isActive = !isScheduled && !isExpired;

                    return new
                    {
                        x.Id,
                        x.Code,
                        Title = x.Name,
                        BadgeText = x.DiscountType == "Percent" ? (x.DiscountValue.ToString("0") + "%") : x.DiscountValue.ToString("N0") + " đ",
                        StatusText = isActive ? "Đang hoạt động" : (isScheduled ? "Đã lên lịch" : "Đã hết hạn"),
                        TypeText = x.DiscountType == "Percent" ? "Giảm %" : "Giảm cố định",
                        DateText = (x.StartAt.HasValue ? x.StartAt.Value.ToString("dd/MM/yyyy") : "--") + " - " + (x.EndAt.HasValue ? x.EndAt.Value.ToString("dd/MM/yyyy") : "--"),
                        MinOrderText = x.MinOrder.ToString("N0") + " đ",
                        MaxDiscountText = (x.MaxDiscount ?? 0m).ToString("N0") + " đ",
                        UsedText = used.ToString("N0") + "/" + (x.UsageLimit ?? 0).ToString("N0"),
                        RemainingText = Math.Max((x.UsageLimit ?? 0) - used, 0).ToString("N0"),
                        RevenueText = revenue.ToString("N0") + " đ",
                        ProgressPercent = (x.UsageLimit.HasValue && x.UsageLimit.Value > 0) ? Math.Min((used * 100) / x.UsageLimit.Value, 100) : 0,
                        IsActive = isActive,
                        IsScheduled = isScheduled,
                        IsExpired = isExpired
                    };
                });

            if (VoucherTab == "scheduled") data = data.Where(x => x.IsScheduled);
            else if (VoucherTab == "expired") data = data.Where(x => x.IsExpired);
            else data = data.Where(x => x.IsActive);

            var list = data.ToList();
            VoucherRepeater.DataSource = list;
            VoucherRepeater.DataBind();

            var all = couponQuery.ToList();
            var allIds = all.Select(c => c.Id).ToList();
            VoucherTotalLiteral.Text = all.Count.ToString("N0");
            VoucherUsageLiteral.Text = db.CfCouponUsages.Count(x => allIds.Contains(x.CouponId)).ToString("N0");
            VoucherOrderLiteral.Text = VoucherUsageLiteral.Text;
            VoucherRevenueLiteral.Text = db.CfCouponUsages.Where(x => allIds.Contains(x.CouponId)).Sum(x => (decimal?)x.DiscountAmount).GetValueOrDefault().ToString("N0") + " đ";

            TabActiveButton.CssClass = "voucher-tab" + (VoucherTab == "active" ? " is-active" : string.Empty);
            TabScheduledButton.CssClass = "voucher-tab" + (VoucherTab == "scheduled" ? " is-active" : string.Empty);
            TabExpiredButton.CssClass = "voucher-tab" + (VoucherTab == "expired" ? " is-active" : string.Empty);
        }
    }

    private int? GetShopId(BeautyStoryContext db)
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue) return null;
        return db.CfShops.Where(s => s.SellerId == sellerId.Value).Select(s => (int?)s.Id).FirstOrDefault();
    }

    private void ResetVoucherForm()
    {
        EditingVoucherIdHidden.Value = string.Empty;
        VoucherCodeInput.Text = string.Empty;
        VoucherNameInput.Text = string.Empty;
        VoucherDescriptionInput.Text = string.Empty;
        VoucherTypeInput.SelectedValue = "Percent";
        VoucherValueInput.Text = string.Empty;
        VoucherMinOrderInput.Text = string.Empty;
        VoucherMaxDiscountInput.Text = string.Empty;
        VoucherStartAtInput.Text = string.Empty;
        VoucherEndAtInput.Text = string.Empty;
        VoucherUsageLimitInput.Text = string.Empty;
        VoucherUsagePerUserInput.Text = string.Empty;
        VoucherFormErrorLiteral.Text = string.Empty;
        VoucherStartAtInput.Text = DateTime.Now.ToString("yyyy-MM-dd");
        VoucherEndAtInput.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");
        ToggleVoucherTypeUi();
    }

    private void SetVoucherError(string message)
    {
        VoucherFormErrorLiteral.Text = "<div class='alert alert-warning'>" + message + "</div>";
        VoucherModalPanel.Visible = true;
    }

    private void ToggleVoucherTypeUi()
    {
        var isPercent = VoucherTypeInput.SelectedValue == "Percent";
        VoucherValueWrap.Visible = isPercent;
    }

    private void ShowToast(string message, string type)
    {
        var safeMessage = HttpUtility.JavaScriptStringEncode(message ?? string.Empty);
        var safeType = HttpUtility.JavaScriptStringEncode(type ?? "success");
        ToastMessageLiteral.Text = "<script>(function(){var t=0;function tryShow(){if(window.SellerToast){window.SellerToast.show('" + safeMessage + "', '" + safeType + "');return;}t++;if(t<10){setTimeout(tryShow,80);}}tryShow();})();</script>";
    }

    private void SetToastSession(string message, string type)
    {
        Session["VoucherToastMessage"] = message;
        Session["VoucherToastType"] = type;
    }

    private void ShowToastFromSession()
    {
        var message = Session["VoucherToastMessage"] as string;
        if (string.IsNullOrWhiteSpace(message))
        {
            return;
        }

        var type = Session["VoucherToastType"] as string;
        Session.Remove("VoucherToastMessage");
        Session.Remove("VoucherToastType");
        ShowToast(message, string.IsNullOrWhiteSpace(type) ? "success" : type);
    }
}
