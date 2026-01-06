<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BannerTwoHomePage.ascx.cs" Inherits="public_controls_trang_chu_BannerTwoHomePage" %>
<!--==================== Special Offer Section Start ====================-->
<asp:Panel ID="BannerSection" runat="server" CssClass="full-row banner-two-section" Visible="false">
    <div class="container">
        <div class="row">
            <div class="col-lg-6">
                <div class="p-50 text-white bg-primary banner-two-card">
                    <div class="text-uppercase text-white font-500"><asp:Literal ID="TitleLine1Literal" runat="server"></asp:Literal></div>
                    <h1 class="text-white my-4"><asp:Literal ID="TitleLine2Literal" runat="server"></asp:Literal></h1>
                    <div class="font-medium w-75">
                        <p><asp:Literal ID="TitleLine3Literal" runat="server"></asp:Literal></p>
                    </div>
                    <asp:HyperLink ID="BannerLink" runat="server" CssClass="btn btn-dark mt-4" Visible="false">Xem thêm</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</asp:Panel>
<!--==================== Special Offer Section End ====================-->
