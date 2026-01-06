using System;
using System.Linq;

public partial class AdminSystemEmail : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            using (var db = new BeautyStoryContext())
            {
                var account = db.CfEmailAccounts.FirstOrDefault();
                if (account != null)
                {
                    SenderEmailInput.Text = account.Email;
                    SenderPasswordInput.Text = account.Password;
                    SenderNameInput.Text = account.DisplayName;
                    ContactRecipientInput.Text = account.ContactRecipientEmails;
                    OrderRecipientInput.Text = account.OrderRecipientEmails;
                }
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        var updatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "admin";
        using (var db = new BeautyStoryContext())
        {
            var account = db.CfEmailAccounts.FirstOrDefault();
            if (account == null)
            {
                account = new CfEmailAccount
                {
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = updatedBy,
                    SortOrder = 0
                };
                db.CfEmailAccounts.Add(account);
            }

            account.Email = SenderEmailInput.Text.Trim();
            account.Password = SenderPasswordInput.Text;
            account.DisplayName = SenderNameInput.Text.Trim();
            account.ContactRecipientEmails = (ContactRecipientInput.Text ?? string.Empty).Trim();
            account.OrderRecipientEmails = (OrderRecipientInput.Text ?? string.Empty).Trim();
            account.UpdatedAt = DateTime.Now;
            account.UpdatedBy = updatedBy;
            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
    }
}
