using System;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Configuration;

public partial class ContactDefault : System.Web.UI.Page
{
    protected string ContactHotlineText { get; private set; }
    protected string ContactHotlineTelText { get; private set; }
    protected string ContactEmailText { get; private set; }
    protected string ContactAddressText { get; private set; }
    protected string ContactMapUrl { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindContactInfo();
            BindSeoMeta();
        }
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        var fullName = (FullNameInput.Text ?? string.Empty).Trim();
        var phone = (PhoneInput.Text ?? string.Empty).Trim();
        var email = (EmailInput.Text ?? string.Empty).Trim();
        var subject = (SubjectInput.Text ?? string.Empty).Trim();
        var message = (MessageInput.Text ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(message))
        {
            FormMessage.Text = "<div class=\"alert alert-warning\">Vui lòng nhập họ tên, email và nội dung.</div>";
            return;
        }

        int messageId = 0;
        using (var db = new BeautyStoryContext())
        {
            var entity = new CfContactMessage
            {
                FullName = fullName,
                Phone = phone,
                Email = email,
                Subject = string.IsNullOrWhiteSpace(subject) ? "Liên hệ từ website" : subject,
                Message = message,
                Status = true,
                CreatedAt = DateTime.Now
            };
            db.CfContactMessages.Add(entity);
            db.SaveChanges();
            messageId = entity.Id;
        }

        var sendOk = SendEmailNotification(messageId, fullName, phone, email, subject, message);
        if (sendOk)
        {
            FormMessage.Text = "<div class=\"alert alert-success\">Yêu cầu của bạn đã được ghi nhận. Chúng tôi sẽ liên hệ trong thời gian sớm nhất.</div>";
            ClearForm();
        }
        else
        {
            FormMessage.Text = "<div class=\"alert alert-warning\">Chúng tôi đã ghi nhận thông tin. Email chưa thể gửi thành công, vui lòng thử lại sau.</div>";
        }
    }

    private bool SendEmailNotification(int messageId, string fullName, string phone, string email, string subject, string message)
    {
        try
        {
            var smtpSection = WebConfigurationManager.GetSection("system.net/mailSettings/smtp") as System.Net.Configuration.SmtpSection;
            if (smtpSection == null)
            {
                return false;
            }

            CfEmailAccount account;
            using (var db = new BeautyStoryContext())
            {
                account = db.CfEmailAccounts.Where(a => a.Status).OrderBy(a => a.SortOrder).ThenBy(a => a.Id).FirstOrDefault();
            }
            if (account == null || string.IsNullOrWhiteSpace(account.Email) || string.IsNullOrWhiteSpace(account.Password))
            {
                return false;
            }

            string recipient = account.ContactRecipientEmails;
            if (string.IsNullOrWhiteSpace(recipient))
            {
                return false;
            }

            var fromAddress = new MailAddress(account.Email, string.IsNullOrWhiteSpace(account.DisplayName) ? "LoveIs Store" : account.DisplayName);
                        var mailSubject = string.Format("Liên hệ: {0}", string.IsNullOrWhiteSpace(subject) ? "Không có chủ đề" : subject);

            var bodyBuilder = new StringBuilder();
            bodyBuilder.AppendLine("Tin nhan lien he tu website:");
            bodyBuilder.AppendLine("Mã tin nhắn: " + messageId);
            bodyBuilder.AppendLine("Họ & tên: " + fullName);
            bodyBuilder.AppendLine("Điện thoại: " + phone);
            bodyBuilder.AppendLine("Email: " + email);
            bodyBuilder.AppendLine("Chủ đề: " + subject);
            bodyBuilder.AppendLine("Nội dung:");
            bodyBuilder.AppendLine(message);

            using (var mail = new MailMessage())
            {
                mail.From = fromAddress;
                AddRecipients(mail, recipient);
                mail.Subject = mailSubject;
                mail.Body = bodyBuilder.ToString();
                mail.IsBodyHtml = false;

                using (var client = new SmtpClient(smtpSection.Network.Host, smtpSection.Network.Port))
                {
                    client.EnableSsl = smtpSection.Network.EnableSsl;
                    client.Credentials = new NetworkCredential(account.Email, account.Password);
                    client.Send(mail);
                }
            }

            return true;
        }
        catch
        {
            return false;
        }
    }

    private static void AddRecipients(MailMessage mail, string recipients)
    {
        if (mail == null || string.IsNullOrWhiteSpace(recipients))
        {
            return;
        }

        var items = recipients.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
        foreach (var item in items)
        {
            var address = item.Trim();
            if (!string.IsNullOrWhiteSpace(address))
            {
                mail.To.Add(address);
            }
        }
    }
    private void ClearForm()
    {
        FullNameInput.Text = string.Empty;
        PhoneInput.Text = string.Empty;
        EmailInput.Text = string.Empty;
        SubjectInput.Text = string.Empty;
        MessageInput.Text = string.Empty;
    }

    private void BindContactInfo()
    {
        using (var db = new BeautyStoryContext())
        {
            var info = db.CfContactInfos
                .Where(i => i.Status)
                .OrderBy(i => i.SortOrder)
                .ThenBy(i => i.Id)
                .FirstOrDefault();

            ContactHotlineText = info == null || string.IsNullOrWhiteSpace(info.Hotline) ? "0909 221 558" : info.Hotline.Trim();
            ContactHotlineTelText = ContactHotlineText.Replace(" ", string.Empty);
            ContactEmailText = info == null || string.IsNullOrWhiteSpace(info.Email) ? "beautystory0909@gmail.com" : info.Email.Trim();
            ContactAddressText = info == null || string.IsNullOrWhiteSpace(info.Address)
                ? "82 Ta Hien, Phuong Cat Lai, TP Ho Chi Minh"
                : info.Address.Trim();
        }

        var mapQuery = HttpUtility.UrlEncode(ContactAddressText);
        ContactMapUrl = "https://www.google.com/maps?q=" + mapQuery + "&output=embed";
    }

    private void BindSeoMeta()
    {
        string canonical = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Path) : string.Empty;
        SystemPageSeoApplier.Apply("contact", SeoTitleLiteral, SeoMetaLiteral, "Liên hệ với LoveIs Store | LoveIs Store", canonical);
    }
}







