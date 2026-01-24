using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

public partial class SellerFinanceBank : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindShops();
            BindBanks();
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
        if (!int.TryParse(BankShopDropDown.SelectedValue, out shopId) || shopId <= 0)
        {
            BankMessageLiteral.Text = "<div class='text-danger small'>Vui lòng chọn shop.</div>";
            return;
        }

        var bankName = (BankNameInput.Text ?? string.Empty).Trim();
        var accountName = (AccountNameInput.Text ?? string.Empty).Trim();
        var accountNumber = (AccountNumberInput.Text ?? string.Empty).Trim();
        var branch = (BranchInput.Text ?? string.Empty).Trim();
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
                BankShopDropDown.SelectedValue = bank.ShopId.ToString(CultureInfo.InvariantCulture);
                BankNameInput.Text = bank.BankName;
                AccountNameInput.Text = bank.AccountName;
                AccountNumberInput.Text = bank.AccountNumber;
                BranchInput.Text = bank.Branch;
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

            BankShopDropDown.Items.Clear();
            foreach (var shop in shops)
            {
                BankShopDropDown.Items.Add(new System.Web.UI.WebControls.ListItem(shop.ShopName, shop.Id.ToString(CultureInfo.InvariantCulture)));
            }
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
                    AccountName = b.AccountName ?? "-",
                    AccountNumber = b.AccountNumber ?? "-",
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
        if (BankShopDropDown.Items.Count > 0)
        {
            BankShopDropDown.SelectedIndex = 0;
        }
        BankNameInput.Text = string.Empty;
        AccountNameInput.Text = string.Empty;
        AccountNumberInput.Text = string.Empty;
        BranchInput.Text = string.Empty;
        IsDefaultCheckBox.Checked = false;
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

    private class BankRow
    {
        public int Id { get; set; }
        public int ShopId { get; set; }
        public string BankName { get; set; }
        public string BankShort { get; set; }
        public string AccountName { get; set; }
        public string AccountNumber { get; set; }
        public string Branch { get; set; }
        public bool IsDefault { get; set; }
    }
}
