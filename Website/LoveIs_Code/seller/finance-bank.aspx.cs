using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

public partial class SellerFinanceBank : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindShops();
            BindBanksDropdown();
            BindBanks();
            return;
        }

        if (BankModalOpenField != null && BankModalOpenField.Value == "1")
        {
            ClientScript.RegisterStartupScript(GetType(), "OpenBankModal", "document.getElementById('BankModal') && document.getElementById('BankModal').classList.add('open');", true);
        }
    }

    protected void SaveBankButton_Click(object sender, EventArgs e)
    {
        BankMessageLiteral.Text = string.Empty;
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            BankMessageLiteral.Text = "<div class='text-danger small'>Phiên đăng nhập đã hết hạn.</div>";
            return;
        }

        int shopId;
        if (!int.TryParse(BankShopIdField.Value, out shopId) || shopId <= 0)
        {
            BankMessageLiteral.Text = "<div class='text-danger small'>Vui lòng chọn shop.</div>";
            return;
        }

        var bankName = (BankNameDropDown.SelectedValue ?? string.Empty).Trim();
        var accountName = (AccountNameInput.Text ?? string.Empty).Trim();
        var accountNumber = (AccountNumberInput.Text ?? string.Empty).Trim();
        var branch = string.Empty;
        if (string.IsNullOrWhiteSpace(bankName) || string.IsNullOrWhiteSpace(accountName) || string.IsNullOrWhiteSpace(accountNumber))
        {
            BankMessageLiteral.Text = "<div class='text-danger small'>Vui lòng nhập đủ thông tin tài khoản.</div>";
            return;
        }

        int bankId;
        int.TryParse(BankIdField.Value, out bankId);

        using (var db = new BeautyStoryContext())
        {
            var ownsShop = db.CfShops.Any(s => s.Id == shopId && s.SellerId == sellerId.Value);
            if (!ownsShop)
            {
                BankMessageLiteral.Text = "<div class='text-danger small'>Shop không hợp lệ.</div>";
                return;
            }

            CfShopBank bank = null;
            if (bankId > 0)
            {
                bank = db.CfShopBanks.FirstOrDefault(b => b.Id == bankId && b.ShopId == shopId && b.Status);
            }

            if (bank == null)
            {
                bank = new CfShopBank
                {
                    ShopId = shopId,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture),
                    SortOrder = 0
                };
                db.CfShopBanks.Add(bank);
            }

            bank.BankName = bankName;
            bank.AccountName = accountName;
            bank.AccountNumber = accountNumber;
            bank.Branch = branch;
            bank.IsDefault = IsDefaultCheckBox.Checked;
            bank.UpdatedAt = DateTime.Now;
            bank.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);

            if (bank.IsDefault)
            {
                var others = db.CfShopBanks.Where(b => b.ShopId == shopId && b.Id != bank.Id);
                foreach (var item in others)
                {
                    item.IsDefault = false;
                }
            }

            db.SaveChanges();
        }

        ResetForm();
        BindBanks();
        BankMessageLiteral.Text = "<div class='text-success small'>Đã lưu tài khoản ngân hàng.</div>";
    }

    protected void ResetBankButton_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void BankRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        int bankId;
        if (!int.TryParse(e.CommandArgument as string, out bankId) || bankId <= 0)
        {
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var bank = (from b in db.CfShopBanks
                        join s in db.CfShops on b.ShopId equals s.Id
                        where b.Id == bankId && b.Status && s.SellerId == sellerId.Value
                        select b).FirstOrDefault();
            if (bank == null)
            {
                return;
            }

            if (string.Equals(e.CommandName, "DeleteBank", StringComparison.OrdinalIgnoreCase))
            {
                bank.Status = false;
                bank.UpdatedAt = DateTime.Now;
                bank.UpdatedBy = "Seller:" + sellerId.Value.ToString(CultureInfo.InvariantCulture);
                db.SaveChanges();
            }
            else if (string.Equals(e.CommandName, "SetDefault", StringComparison.OrdinalIgnoreCase))
            {
                var others = db.CfShopBanks.Where(b => b.ShopId == bank.ShopId);
                foreach (var item in others)
                {
                    item.IsDefault = item.Id == bank.Id;
                }
                db.SaveChanges();
            }
            else if (string.Equals(e.CommandName, "EditBank", StringComparison.OrdinalIgnoreCase))
            {
                BankIdField.Value = bank.Id.ToString(CultureInfo.InvariantCulture);
                BankShopIdField.Value = bank.ShopId.ToString(CultureInfo.InvariantCulture);
                BankNameDropDown.SelectedValue = bank.BankName;
                UpdateBankLogoPreview(bank.BankName);
                AccountNameInput.Text = bank.AccountName;
                AccountNumberInput.Text = bank.AccountNumber;
                IsDefaultCheckBox.Checked = bank.IsDefault;
            }
        }

        BindBanks();
    }

    private void BindShops()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var shops = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .OrderBy(s => s.ShopName)
                .Select(s => new { s.Id, s.ShopName })
                .ToList();

            var defaultShop = shops.FirstOrDefault();
            BankShopIdField.Value = defaultShop != null
                ? defaultShop.Id.ToString(CultureInfo.InvariantCulture)
                : string.Empty;
        }
    }

    private void BindBanks()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            Response.Redirect("/seller/login.aspx");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var rows = (from b in db.CfShopBanks
                        join s in db.CfShops on b.ShopId equals s.Id
                        where b.Status && s.SellerId == sellerId.Value
                        orderby b.IsDefault descending, b.BankName
                        select new
                        {
                            b.Id,
                            b.ShopId,
                            b.BankName,
                            b.AccountName,
                            b.AccountNumber,
                            b.Branch,
                            b.IsDefault
                        }).ToList()
                .Select(b => new BankRow
                {
                    Id = b.Id,
                    ShopId = b.ShopId,
                    BankName = b.BankName ?? "-",
                    BankShort = BuildBankShort(b.BankName),
                    AccountName = ToUpperNoAccent(b.AccountName ?? "-"),
                    AccountNumber = b.AccountNumber ?? "-",
                    MaskedAccountNumber = MaskAccountNumber(b.AccountNumber ?? string.Empty),
                    Branch = string.IsNullOrWhiteSpace(b.Branch) ? "-" : b.Branch,
                    IsDefault = b.IsDefault
                })
                .ToList();

            BankRepeater.DataSource = rows;
            BankRepeater.DataBind();
        }
    }

    private void ResetForm()
    {
        BankIdField.Value = string.Empty;
        if (BankNameDropDown.Items.Count > 0)
        {
            BankNameDropDown.SelectedIndex = 0;
            UpdateBankLogoPreview(BankNameDropDown.SelectedValue);
        }
        AccountNameInput.Text = string.Empty;
        AccountNumberInput.Text = string.Empty;
        IsDefaultCheckBox.Checked = false;
    }

    protected void CheckAccountButton_Click(object sender, EventArgs e)
    {
        BankMessageLiteral.Text = string.Empty;

        var accountNumber = (AccountNumberInput.Text ?? string.Empty).Trim();
        var digits = new string(accountNumber.Where(char.IsDigit).ToArray());
        if (digits.Length < 9 || digits.Length > 14)
        {
            BankMessageLiteral.Text = "<div class='text-danger small'>Số tài khoản chưa đúng định dạng.</div>";
            return;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            BankMessageLiteral.Text = "<div class='text-danger small'>Phiên đăng nhập đã hết hạn.</div>";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.AsNoTracking().FirstOrDefault(s => s.Id == sellerId.Value);
            var displayName = seller != null && !string.IsNullOrWhiteSpace(seller.DisplayName)
                ? seller.DisplayName
                : (seller != null ? seller.Username : string.Empty);

            AccountNameInput.Text = ToUpperNoAccent(displayName);
        }
    }

    private static string BuildBankShort(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return "BANK";
        }

        var parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
        var shortName = string.Join("", parts.Select(p => p[0])).ToUpperInvariant();
        return string.IsNullOrWhiteSpace(shortName) ? "BANK" : shortName;
    }

    private void BindBanksDropdown()
    {
        var banks = new List<BankOption>
        {
            new BankOption("Ngân hàng Vietcombank", "/images/noidia/bank/Vietcombank.png"),
            new BankOption("Ngân hàng Techcombank", "/images/noidia/bank/Techcombank.png"),
            new BankOption("Ngân hàng BIDV", "/images/noidia/bank/BIDV.png"),
            new BankOption("Ngân hàng Agribank", "/images/noidia/bank/Agribank.webp"),
            new BankOption("Ngân hàng MB", "/images/noidia/bank/MB.png"),
            new BankOption("Ngân hàng VPBank", "/images/noidia/bank/VPBank.png"),
            new BankOption("Ngân hàng TPBank", "/images/noidia/bank/TPBank.png"),
            new BankOption("Ngân hàng Sacombank", "/images/noidia/bank/Sacombank.png"),
            new BankOption("Ngân hàng VIB", "/images/noidia/bank/VIB.png"),
            new BankOption("Ngân hàng Đông Á", "/images/noidia/bank/DongA Bank.png")
        };

        BankNameDropDown.Items.Clear();
        foreach (var bank in banks)
        {
            var item = new System.Web.UI.WebControls.ListItem(bank.Name, bank.Name);
            item.Attributes["data-logo"] = bank.LogoUrl;
            BankNameDropDown.Items.Add(item);
        }

        if (banks.Count > 0)
        {
            BankNameDropDown.SelectedIndex = 0;
            UpdateBankLogoPreview(banks[0].Name);
        }
    }

    private void UpdateBankLogoPreview(string bankName)
    {
        if (BankNameDropDown == null)
        {
            return;
        }

        var selectedItem = BankNameDropDown.Items.FindByValue(bankName);
        var logo = selectedItem != null ? selectedItem.Attributes["data-logo"] : string.Empty;
        BankLogoPreview.ImageUrl = string.IsNullOrWhiteSpace(logo) ? "/images/fav.png" : logo;
    }

    private static string MaskAccountNumber(string accountNumber)
    {
        if (string.IsNullOrWhiteSpace(accountNumber))
        {
            return "****";
        }

        var digits = new string(accountNumber.Where(char.IsDigit).ToArray());
        if (digits.Length <= 4)
        {
            return "**** " + digits;
        }

        var last4 = digits.Substring(digits.Length - 4);
        return "**** **** **** " + last4;
    }

    private static string ToUpperNoAccent(string input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return string.Empty;
        }

        var normalized = input.Normalize(NormalizationForm.FormD);
        var builder = new StringBuilder();
        foreach (var ch in normalized)
        {
            var category = CharUnicodeInfo.GetUnicodeCategory(ch);
            if (category != UnicodeCategory.NonSpacingMark)
            {
                builder.Append(ch);
            }
        }

        return builder.ToString().Normalize(NormalizationForm.FormC).ToUpperInvariant();
    }

    private class BankRow
    {
        public int Id { get; set; }
        public int ShopId { get; set; }
        public string BankName { get; set; }
        public string BankShort { get; set; }
        public string AccountName { get; set; }
        public string AccountNumber { get; set; }
        public string MaskedAccountNumber { get; set; }
        public string Branch { get; set; }
        public bool IsDefault { get; set; }
    }

    private class BankOption
    {
        public BankOption(string name, string logoUrl)
        {
            Name = name;
            LogoUrl = logoUrl;
        }

        public string Name { get; set; }
        public string LogoUrl { get; set; }
    }
}
