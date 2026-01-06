<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="StaticPageDefault" MasterPageFile="~/public/Public.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 static-page">
        <div class="row g-4">
            <aside class="col-lg-3 order-2 order-lg-1">
                <div class="static-page-menu">
                    <asp:Repeater ID="MenuGroupRepeater" runat="server" OnItemDataBound="MenuGroupRepeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="static-page-menu__group">
                                <div class="static-page-menu__title"><%# Eval("GroupName") %></div>
                                <ul class="static-page-menu__list">
                                    <asp:Repeater ID="MenuItemRepeater" runat="server">
                                        <ItemTemplate>
                                            <li class="static-page-menu__item">
                                                <a class="static-page-menu__link <%# Eval("IsActive") %>" href="<%# Eval("Url") %>">
                                                    <%# Eval("Title") %>
                                                </a>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </aside>
            <section class="col-lg-9 order-1 order-lg-2">
                <h1 class="mb-4"><asp:Literal ID="PageTitleLiteral" runat="server" /></h1>
                <div class="static-page-content">
                    <asp:Literal ID="ContentLiteral" runat="server" />
                </div>
            </section>
        </div>
    </main>
</asp:Content>
