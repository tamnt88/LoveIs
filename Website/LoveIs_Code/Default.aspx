<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" MasterPageFile="~/public/Public.master" %>

<%@ Register Src="~/public/controls/trang-chu/BannerHomePage.ascx" TagPrefix="uc1" TagName="BannerHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BrandHomePage.ascx" TagPrefix="uc1" TagName="BrandHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/NewArrivalHomePage.ascx" TagPrefix="uc1" TagName="NewArrivalHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BannerTwoHomePage.ascx" TagPrefix="uc1" TagName="BannerTwoHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BannerHomeTwoNew.ascx" TagPrefix="uc1" TagName="BannerHomeTwoNew" %>
<%@ Register Src="~/public/controls/trang-chu/TrendingHomePage.ascx" TagPrefix="uc1" TagName="TrendingHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BannerThreeHomePage.ascx" TagPrefix="uc1" TagName="BannerThreeHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BestSellingHomePage.ascx" TagPrefix="uc1" TagName="BestSellingHomePage" %>
<%@ Register Src="~/public/controls/trang-chu/BannerFourHomePage.ascx" TagPrefix="uc1" TagName="BannerFourHomePage" %>









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

    <%--<uc1:BrandHomePage runat="server" ID="BrandHomePage" />

    <uc1:NewArrivalHomePage runat="server" ID="NewArrivalHomePage" />
        

    <uc1:BannerTwoHomePage runat="server" ID="BannerTwoHomePage" />

    <uc1:TrendingHomePage runat="server" ID="TrendingHomePage" />

    <uc1:BannerThreeHomePage runat="server" ID="BannerThreeHomePage" />

    <uc1:BestSellingHomePage runat="server" ID="BestSellingHomePage" />

    <uc1:BannerFourHomePage runat="server" ID="BannerFourHomePage" />--%>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/public/assets/vendor/swiper/swiper-bundle.min.js"></script>
    <script src="/public/assets/js/home.js"></script>
</asp:Content>
