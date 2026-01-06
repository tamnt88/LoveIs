<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CartDefault" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" EnableEventValidation="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 cart-page">
        <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
            <ol class="breadcrumb mb-2">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
            </ol>
        </nav>
        <div class="section-heading">
            <div>
                <h4>Giỏ hàng</h4>
                <p id="CartSubtitle" runat="server">Kiểm tra sản phẩm trước khi đặt hàng</p>
            </div>
        </div>

        <asp:Panel ID="EmptyCartPanel" runat="server" CssClass="cart-empty" Visible="false">
            <div class="cart-empty-card">
                <div class="cart-empty-icon">
                    <i class="fa-solid fa-basket-shopping"></i>
                </div>
                <h5>Giỏ hàng đang trống</h5>
                <p class="cart-empty-note">Hãy khám phá các sản phẩm mới và thêm vào giỏ hàng của bạn.</p>
                <a class="btn btn-dark btn-with-icon" href="/">
                    <i class="fa-solid fa-arrow-left-long"></i>
                    Tiếp tục mua sắm
                </a>
            </div>
        </asp:Panel>

        <asp:Panel ID="CartPanel" runat="server">
            <div class="cart-table">
                <div class="cart-header">
                    <div class="cart-check">
                        <asp:CheckBox ID="SelectAllCheckBox" runat="server" CssClass="cart-select-all" />
                    </div>
                    <div>Sản phẩm</div>
                    <div>Giá</div>
                    <div>Số lượng</div>
                    <div>Thành tiền</div>
                    <div></div>
                </div>
                <asp:Repeater ID="CartGroupRepeater" runat="server">
                    <ItemTemplate>
                        <div class="cart-group">
                            <div class="cart-group-header">
                                <div class="shop-name"><%# Eval("ShopName") %></div>
                                <a class="shop-link" href="<%# Eval("ShopUrl") %>">Xem cửa hàng</a>
                            </div>
                            <asp:Repeater ID="CartItemRepeater" runat="server" DataSource='<%# Eval("Items") %>' OnItemCommand="CartItemRepeater_ItemCommand">
                                <ItemTemplate>
                                    <div class="cart-row">
                                        <div class="cart-check">
                                            <asp:CheckBox ID="SelectItemCheckBox" runat="server" CssClass="cart-item-checkbox" />
                                        </div>
                                        <div class="cart-product">
                                            <a class="cart-thumb" href="/san-pham/<%# Eval("SeoSlug") %>">
                                                <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                            </a>
                                            <div>
                                                <a class="cart-title" href="/san-pham/<%# Eval("SeoSlug") %>"><%# Eval("ProductName") %></a>
                                                <div class="cart-variant"><%# Eval("VariantText") %></div>
                                            </div>
                                        </div>
                                        <div class="cart-price"><%# Eval("PriceHtml") %></div>
                                        <div class="cart-qty">
                                            <button type="button" class="qty-btn" data-action="minus" aria-label="Giảm số lượng">-</button>
                                            <asp:HiddenField ID="VariantIdField" runat="server" Value='<%# Eval("VariantId") %>' />
                                            <asp:TextBox ID="QtyTextBox" runat="server" CssClass="form-control form-control-sm qty-input" Text='<%# Eval("Quantity") %>' />
                                            <button type="button" class="qty-btn" data-action="plus" aria-label="Tăng số lượng">+</button>
                                        </div>
                                        <div class="cart-total"><%# Eval("LineTotal") %></div>
                                        <div>
                                            <asp:LinkButton ID="RemoveButton" runat="server" CommandName="remove" CommandArgument='<%# Eval("VariantId") %>' CssClass="btn btn-link text-danger p-0">
                                                <i class="fa-solid fa-trash"></i>
                                                <span>&nbsp;Xóa</span>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="cart-actions">
                <div class="cart-actions-left">
                    <asp:LinkButton ID="DeleteSelectedButton" runat="server" CssClass="btn btn-outline-danger btn-with-icon" OnClick="DeleteSelectedButton_Click">
                        <i class="fa-solid fa-trash"></i>
                        Xóa đã chọn
                    </asp:LinkButton>
                    <asp:LinkButton ID="UpdateCartButton" runat="server" CssClass="btn btn-outline-dark btn-with-icon" OnClick="UpdateCartButton_Click">
                        <i class="fa-solid fa-rotate-right"></i>
                        Cập nhật lại
                    </asp:LinkButton>
                    
                    <span id="CartUpdateTarget" data-cart-postback="<%= UpdateCartButton.UniqueID %>"></span>
                    <a class="btn btn-outline-dark btn-with-icon" href="/">
                        <i class="fa-solid fa-arrow-left"></i>
                        Tiếp tục mua sắm
                    </a>
                    <a class="btn btn-dark btn-with-icon" href="/thanh-toan">
                        <i class="fa-solid fa-credit-card"></i>
                        Thanh toán
                    </a>
                </div>
                <div class="cart-summary">
                    <div>Tạm tính</div>
                    <div class="cart-summary-total"><asp:Literal ID="CartTotalLiteral" runat="server" /></div>
                </div>
            </div>
        </asp:Panel>
    </main>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ResolveUrl("~/public/assets/js/public-search.js") %>"></script>
    <script src="<%= ResolveUrl("~/public/assets/js/cart.js") %>"></script>
</asp:Content>
