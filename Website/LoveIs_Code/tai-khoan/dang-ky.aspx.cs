using System;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Configuration;
using System.Web.Configuration;

public partial class CustomerRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (CustomerAuth.IsSignedIn())
        {
            Response.Redirect("/");
        }
    }

    protected void RegisterButton_Click(object sender, EventArgs e)
    {
        ErrorMessage.Text = string.Empty;

        string username = (UsernameInput.Text ?? string.Empty).Trim();
        string displayName = (DisplayNameInput.Text ?? string.Empty).Trim();
        string email = (EmailInput.Text ?? string.Empty).Trim();
        string phone = (PhoneInput.Text ?? string.Empty).Trim();
        string password = (PasswordInput.Text ?? string.Empty).Trim();
        string confirmPassword = (ConfirmPasswordInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(username)
            || string.IsNullOrWhiteSpace(email)
            || string.IsNullOrWhiteSpace(phone)
            || string.IsNullOrEmpty(password))
        {
            ErrorMessage.Text = "Vui lòng nhập đầy đủ thông tin bắt buộc.";
            return;
        }

        if (!string.Equals(password, confirmPassword, StringComparison.Ordinal))
        {
            ErrorMessage.Text = "Mật khẩu không khớp.";
            return;
        }

        if (password.Length < 6)
        {
            ErrorMessage.Text = "Mật khẩu tối thiểu 6 ký tự.";
            return;
        }

        string verifyToken = Guid.NewGuid().ToString("N");
        DateTime verifyExpiresAt = DateTime.UtcNow.AddHours(24);

        using (var db = new BeautyStoryContext())
        {
            if (db.CfCustomers.Any(c => c.Username == username))
            {
                ErrorMessage.Text = "Tên đăng nhập đã tồn tại.";
                return;
            }

            if (db.CfCustomers.Any(c => c.Email == email))
            {
                ErrorMessage.Text = "Email đã tồn tại.";
                return;
            }

            if (db.CfCustomers.Any(c => c.Phone == phone))
            {
                ErrorMessage.Text = "Số điện thoại đã tồn tại.";
                return;
            }

            byte[] salt;
            byte[] hash;
            int iterations = 100000;
            Pbkdf2Hasher.Create(password, iterations, out salt, out hash);

            var customer = new CfCustomer
            {
                Username = username,
                DisplayName = string.IsNullOrWhiteSpace(displayName) ? null : displayName,
                Email = string.IsNullOrWhiteSpace(email) ? null : email,
                Phone = string.IsNullOrWhiteSpace(phone) ? null : phone,
                PasswordSalt = salt,
                PasswordHash = hash,
                PasswordIterations = iterations,
                Status = true,
                EmailVerified = false,
                EmailVerifyToken = verifyToken,
                EmailVerifyExpiresAt = verifyExpiresAt,
                CreatedAt = DateTime.UtcNow,
                SortOrder = 0
            };

            db.CfCustomers.Add(customer);
            db.SaveChanges();
        }

        if (!TrySendVerificationEmail(email, verifyToken))
        {
            ErrorMessage.Text = "Không thể gửi email xác nhận. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.";
            return;
        }

        Response.Redirect("/tai-khoan/xac-nhan-email.aspx?sent=1");
    }

    private bool TrySendVerificationEmail(string toEmail, string token)
    {
        if (string.IsNullOrWhiteSpace(toEmail))
        {
            return false;
        }

        using (var db = new BeautyStoryContext())
        {
            var account = db.CfEmailAccounts
                .Where(a => a.Status)
                .OrderBy(a => a.SortOrder)
                .ThenBy(a => a.Id)
                .FirstOrDefault();

            if (account == null || string.IsNullOrWhiteSpace(account.Email) || string.IsNullOrWhiteSpace(account.Password))
            {
                return false;
            }

            var verifyUrl = string.Format("{0}://{1}/tai-khoan/xac-nhan-email.aspx?token={2}",
                Request.Url.Scheme,
                Request.Url.Authority,
                Uri.EscapeDataString(token));

            var smtpSection = (SmtpSection)WebConfigurationManager.GetSection("system.net/mailSettings/smtp");
            if (smtpSection == null)
            {
                return false;
            }

            try
            {
                using (var mail = new MailMessage())
                {
                    mail.From = new MailAddress(account.Email, account.DisplayName ?? "LoveIs");
                    mail.To.Add(new MailAddress(toEmail));
                    mail.Subject = "Xác nhận email đăng ký LoveIs";
                    mail.Body = string.Format(@"
                        <p>Chào bạn,</p>
                        <p>Cảm ơn bạn đã đăng ký LoveIs. Vui lòng xác nhận email bằng cách nhấn vào liên kết dưới đây:</p>
                        <p><a href=""{0}"">{0}</a></p>
                        <p>Liên kết có hiệu lực trong 24 giờ.</p>", verifyUrl);
                    mail.IsBodyHtml = true;

                    using (var client = new SmtpClient(smtpSection.Network.Host, smtpSection.Network.Port))
                    {
                        client.EnableSsl = smtpSection.Network.EnableSsl;
                        client.Credentials = new NetworkCredential(account.Email, account.Password);
                        client.Timeout = 10000;
                        client.Send(mail);
                    }
                }
            }
            catch
            {
                return false;
            }
        }

        return true;
    }
}
