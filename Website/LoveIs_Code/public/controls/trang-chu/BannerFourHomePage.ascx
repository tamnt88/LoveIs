<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BannerFourHomePage.ascx.cs" Inherits="public_controls_trang_chu_BannerFourHomePage" %>
<div class="full-row pb-0">
    <div class="container-fluid p-0">
        <div class="row g-0">
            <div class="col-md-12">
                <div class="owl-carousel dot-disable nav-disable six-carousel">
                    <asp:Repeater ID="BannerRepeater" runat="server">
                        <ItemTemplate>
                            <div class="item">
                                <div class="hover-img-zoom overflow-hidden transation">
                                    <asp:PlaceHolder ID="LinkWrap" runat="server" Visible='<%# (bool)Eval("ShowLink") %>'>
                                        <a href="<%# Eval("LinkUrl") %>" title="<%# Eval("LinkText") %>">
                                            <img class="transation" src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>">
                                        </a>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder ID="ImageOnly" runat="server" Visible='<%# !(bool)Eval("ShowLink") %>'>
                                        <img class="transation" src="<%# Eval("ImageUrl") %>" alt="<%# Eval("AltText") %>">
                                    </asp:PlaceHolder>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</div>
