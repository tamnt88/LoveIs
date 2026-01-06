<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="ContactDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="contact-page">
        <div class="contact-map">
            <iframe
                src="<%= ContactMapUrl %>"
                loading="lazy"
                referrerpolicy="no-referrer-when-downgrade"
                aria-label="Ban do Beauty Story">
            </iframe>
        </div>

        <div class="container py-4">
            <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
                <ol class="breadcrumb mb-2">
                    <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Liên hệ</li>
                </ol>
            </nav>

            <div class="section-heading">
                <div>
                    <h4>Liên hệ với Beauty Story</h4>
                    <p>Vui lòng cho chúng tôi biết bạn cần hỗ trợ gì. Đội ngũ của chúng tôi sẽ phản hồi sớm nhất có thể.</p>
                </div>
            </div>

            <asp:Literal ID="FormMessage" runat="server" />

            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="contact-card">
                        <h5 class="contact-card-title">Gửi tin nhắn</h5>
                        <asp:Panel ID="ContactFormPanel" runat="server" CssClass="contact-form" DefaultButton="SubmitButton">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Họ và tên</label>
                                    <asp:TextBox ID="FullNameInput" runat="server" CssClass="form-control" placeholder="Nhập họ và tên" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Điện thoại</label>
                                    <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" placeholder="Nhập số điện thoại" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email</label>
                                    <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" placeholder="Nhập email" TextMode="Email" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Chủ đề</label>
                                    <asp:TextBox ID="SubjectInput" runat="server" CssClass="form-control" placeholder="Nhập chủ đền" />
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Nội dung</label>
                                    <asp:TextBox ID="MessageInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Bạn cần hỗ trợ gì?" />
                                </div>
                            </div>
                            <div class="contact-actions">
                                <asp:Button ID="SubmitButton" runat="server" CssClass="btn btn-dark" Text="Gửi tin nhắn" OnClick="SubmitButton_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="contact-card contact-info">
                        <h5 class="contact-card-title">Thông tin liên hệ</h5>
                        <p class="contact-note">Chúng tôi sẵn sàng hỗ trợ mọi thắc mắc về sản phẩm và đơn hàng.</p>
                        <div class="contact-info-item">
                            <i class="fa-solid fa-location-dot"></i>
                            <div>
                                <div class="contact-info-label">Địa chỉ</div>
                                <div class="contact-info-value"><%= ContactAddressText %></div>
                            </div>
                        </div>
                        <div class="contact-info-item">
                            <i class="fa-solid fa-phone"></i>
                            <div>
                                <div class="contact-info-label">Hotline</div>
                                <a class="contact-info-value" href="tel:<%= ContactHotlineTelText %>"><%= ContactHotlineText %></a>
                            </div>
                        </div>
                        <div class="contact-info-item">
                            <i class="fa-solid fa-envelope"></i>
                            <div>
                                <div class="contact-info-label">Email</div>
                                <a class="contact-info-value" href="mailto:<%= ContactEmailText %>"><%= ContactEmailText %></a>
                            </div>
                        </div>
                        <div class="contact-hours">
                            <div class="contact-info-label">Giờ làm việc</div>
                            <div class="contact-info-value">Thứ 2 - 6: 08.00 am - 17.00 pm</div>
                            <div class="contact-info-value">Thứ 7: 08.00 am - 12.00 am</div>
                            <div class="contact-info-value">Chủ nhật: Nghĩ</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
