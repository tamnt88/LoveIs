using System;
using System.Linq;

public partial class CustomerChangePassword : CustomerPageBase
{
    protected void ChangePasswordButton_Click(object sender, EventArgs e)
    {
        StatusMessage.Text = string.Empty;

        var customerId = CustomerAuth.GetCustomerId();
        if (!customerId.HasValue)
        {
            return;
        }

        var currentPassword = (CurrentPasswordInput.Text ?? string.Empty).Trim();
        var newPassword = (NewPasswordInput.Text ?? string.Empty).Trim();
        var confirmPassword = (ConfirmPasswordInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(currentPassword) || string.IsNullOrWhiteSpace(newPassword))
        {
            StatusMessage.Text = "Vui lòng nhập đầy đủ thông tin.";
            return;
        }

        if (newPassword.Length < 6)
        {
            StatusMessage.Text = "Mật khẩu mới tối thiểu 6 ký tự.";
            return;
        }

        if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
        {
            StatusMessage.Text = "Xác nhận mật khẩu không khớp.";
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var customer = db.CfCustomers.FirstOrDefault(c => c.Id == customerId.Value);
            if (customer == null)
            {
                StatusMessage.Text = "Không tìm thấy tài khoản.";
                return;
            }

            if (!Pbkdf2Hasher.Verify(currentPassword, customer.PasswordSalt, customer.PasswordHash, customer.PasswordIterations))
            {
                StatusMessage.Text = "Mật khẩu hiện tại không đúng.";
                return;
            }

            byte[] salt;
            byte[] hash;
            int iterations = customer.PasswordIterations > 0 ? customer.PasswordIterations : 100000;
            Pbkdf2Hasher.Create(newPassword, iterations, out salt, out hash);

            customer.PasswordSalt = salt;
            customer.PasswordHash = hash;
            customer.PasswordIterations = iterations;
            customer.UpdatedAt = DateTime.UtcNow;
            db.SaveChanges();
        }

        StatusMessage.Text = "Đã cập nhật mật khẩu mới.";
        CurrentPasswordInput.Text = string.Empty;
        NewPasswordInput.Text = string.Empty;
        ConfirmPasswordInput.Text = string.Empty;
    }
}
