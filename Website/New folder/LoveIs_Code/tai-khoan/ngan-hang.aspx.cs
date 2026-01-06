using System;
using System.Linq;

public partial class CustomerBankPage : CustomerPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindBanks();
        }
    }

    protected void SaveBankButton_Click(object sender, EventArgs e)
    {
        StatusMessage.Text = string.Empty;

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        var bankName = (BankNameInput.Text ?? string.Empty).Trim();
        var accountName = (AccountNameInput.Text ?? string.Empty).Trim();
        var accountNumber = (AccountNumberInput.Text ?? string.Empty).Trim();
        var branch = (BranchInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(bankName) || string.IsNullOrWhiteSpace(accountName) || string.IsNullOrWhiteSpace(accountNumber))
        {
            StatusMessage.Text = "Vui lòng nhập đầy đủ thông tin ngân hàng.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var hasDefault = db.CfCustomerBanks.Any(b => b.CustomerId == customerId.Value && b.IsDefault);
            var entity = new CfCustomerBank
            {
                CustomerId = customerId.Value,
                BankName = bankName,
                AccountName = accountName,
                AccountNumber = accountNumber,
                Branch = branch,
                IsDefault = !hasDefault,
                Status = true,
                CreatedAt = DateTime.UtcNow
            };
            db.CfCustomerBanks.Add(entity);
            db.SaveChanges();
        }

        StatusMessage.Text = "Đã thêm tài khoản ngân hàng.";
        ClearForm();
        BindBanks();
    }

    protected void BankRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
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
            var bank = db.CfCustomerBanks.FirstOrDefault(a => a.Id == id && a.CustomerId == customerId.Value);
            if (bank == null)
            {
                return;
            }

            if (e.CommandName == "delete")
            {
                db.CfCustomerBanks.Remove(bank);
            }
            else if (e.CommandName == "set-default")
            {
                var items = db.CfCustomerBanks.Where(a => a.CustomerId == customerId.Value).ToList();
                foreach (var item in items)
                {
                    item.IsDefault = item.Id == bank.Id;
                }
            }

            db.SaveChanges();
        }

        BindBanks();
    }

    private void BindBanks()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var items = db.CfCustomerBanks
                .Where(a => a.CustomerId == customerId.Value)
                .OrderByDescending(a => a.IsDefault)
                .ThenByDescending(a => a.Id)
                .ToList();
            BankRepeater.DataSource = items;
            BankRepeater.DataBind();
        }
    }

    private void ClearForm()
    {
        BankNameInput.Text = string.Empty;
        AccountNameInput.Text = string.Empty;
        AccountNumberInput.Text = string.Empty;
        BranchInput.Text = string.Empty;
    }
}
