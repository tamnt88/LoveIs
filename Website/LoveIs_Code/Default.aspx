<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" MasterPageFile="~/public/Public.master" %>

<%@ Register Src="~/public/controls/trang-chu/BannerHomePage.ascx" TagPrefix="uc1" TagName="BannerHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BannerHomeTwoNew.ascx" TagPrefix="uc1" TagName="BannerHomeTwoNew" %>
<%@ Register Src="~/public/controls/trang-chu/BestSellingHomePageNew.ascx" TagPrefix="uc1" TagName="BestSellingHomePageNew" %>
<%@ Register Src="~/public/controls/trang-chu/BannerHomeThreeNew.ascx" TagPrefix="uc1" TagName="BannerHomeThreeNew" %>
<%@ Register Src="~/public/controls/trang-chu/NewProductHomePage.ascx" TagPrefix="uc1" TagName="NewProductHomePage" %>


<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/public/assets/vendor/swiper/swiper-bundle.min.css" />
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
        <uc1:BannerHomePage runat="server" ID="BannerHomePage" />
        <uc1:BannerHomeTwoNew runat="server" ID="BannerHomeTwoNew" />
<uc1:BestSellingHomePageNew runat="server" ID="BestSellingHomePageNew" />
    <uc1:BannerHomeThreeNew runat="server" ID="BannerHomeThreeNew" />
    <uc1:NewProductHomePage runat="server" ID="NewProductHomePage" />
    
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/public/assets/vendor/swiper/swiper-bundle.min.js"></script>
    <script src="/public/assets/js/home.js"></script>
</asp:Content>
