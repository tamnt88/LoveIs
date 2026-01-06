using System;
using System.Linq;

public partial class CustomerProfile : CustomerPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProfile();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        StatusMessage.Text = string.Empty;

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        var displayName = (DisplayNameInput.Text ?? string.Empty).Trim();
        var birthDateText = (BirthDateInput.Text ?? string.Empty).Trim();
        DateTime? birthDate = null;
        if (!string.IsNullOrWhiteSpace(birthDateText))
        {
            DateTime parsed;
            if (DateTime.TryParse(birthDateText, out parsed))
            {
                birthDate = parsed.Date;
            }
            else
            {
                StatusMessage.Text = "Ngày sinh không hợp lệ.";
                return;
            }
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId.Value);
            if (customer == null)
            {
                StatusMessage.Text = "Không tìm thấy tài khoản.";
                return;
            }

            customer.DisplayName = string.IsNullOrWhiteSpace(displayName) ? null : displayName;
            customer.Gender = GetSelectedGender();
            customer.BirthDate = birthDate;
            customer.UpdatedAt = DateTime.UtcNow;
            db.SaveChanges();

            CustomerAuth.SignIn(customer);
        }

        StatusMessage.Text = "Đã cập nhật thông tin.";
        BindProfile();
    }

    private void BindProfile()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId.Value);
            if (customer == null)
            {
                return;
            }

            UsernameValueLiteral.Text = customer.Username;
            DisplayNameInput.Text = customer.DisplayName ?? string.Empty;
            EmailLiteral.Text = MaskEmail(customer.Email);
            PhoneLiteral.Text = MaskPhone(customer.Phone);
            SetSelectedGender(customer.Gender);
            BirthDateInput.Text = customer.BirthDate.HasValue ? customer.BirthDate.Value.ToString("yyyy-MM-dd") : string.Empty;
        }
    }

    private int GetSelectedGender()
    {
        if (GenderFemale.Checked)
        {
            return 2;
        }
        if (GenderOther.Checked)
        {
            return 3;
        }
        return 1;
    }

    private void SetSelectedGender(int? gender)
    {
        var value = gender.HasValue ? gender.Value : 1;
        GenderMale.Checked = value == 1;
        GenderFemale.Checked = value == 2;
        GenderOther.Checked = value == 3;
    }

    private static string MaskEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email) || !email.Contains("@"))
        {
            return "Chưa cập nhật";
        }

        var parts = email.Split('@');
        if (parts[0].Length <= 2)
        {
            return "****@" + parts[1];
        }

        return parts[0].Substring(0, 2) + "******@" + parts[1];
    }

    private static string MaskPhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone) || phone.Length < 4)
        {
            return "Chưa cập nhật";
        }

        return new string('*', Math.Max(0, phone.Length - 3)) + phone.Substring(phone.Length - 3);
    }
}
