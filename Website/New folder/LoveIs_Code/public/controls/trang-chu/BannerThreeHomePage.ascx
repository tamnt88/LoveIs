<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BannerThreeHomePage.ascx.cs" Inherits="public_controls_trang_chu_BannerThreeHomePage" %>
<!--==================== Banner Section Start ====================-->
<div class="full-row p-0 d-none d-sm-block">
    <div class="container">
        <div class="row row-cols-lg-2 row-cols-1 g-3">
            <asp:Repeater ID="BannerRepeater" runat="server">
                <ItemTemplate>
                    <div class="col">
                        <div class="banner-wrapper hover-img-zoom banner-one custom-class-112">
                            <div class="banner-image overflow-hidden transation">
                                <asp:PlaceHolder ID="LinkWrap" runat="server" Visible='<%# (bool)Eval("ShowLink") %>'>
                                    <a href="<%# Eval("LinkUrl") %>" title="<%# Eval("AltText") %>">
                                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>">
                                    </a>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="ImageOnly" runat="server" Visible='<%# !(bool)Eval("ShowLink") %>'>
                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>">
                                </asp:PlaceHolder>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</div>
<!--==================== Banner Section End ====================-->
