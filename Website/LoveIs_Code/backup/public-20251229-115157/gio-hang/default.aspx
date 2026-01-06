<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CartDefault" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">
<head runat="server">
    <title>Giỏ hàng | BeautyStory</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="/public/assets/css/roboto.css" rel="stylesheet" />
    <link href="/public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/public/assets/vendor/fontawesome/css/all.min.css" rel="stylesheet" />
    <link href="/public/assets/vendor/flaticon/css/all.css" rel="stylesheet" />
    <link href="/public/assets/css/public.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <header class="site-header">
            <div class="container header-top">
                <a class="brand" href="/">
                    <img src="/images/logo_ngang.png" alt="BeautyStory" />
                    <div class="brand-text">Mỹ phẩm &amp; làm đẹp chính hãng</div>
                </a>
                <div class="header-actions">
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" class="js-search-input" placeholder="Tìm sản phẩm..." autocomplete="off" />
                        <div class="search-suggest"></div>
                    </div>
                    <a class="btn btn-outline-dark" href="/admin/login.aspx">
                        <i class="fa-solid fa-lock me-1"></i> Quản trị
                    </a>
                </div>
            </div>
        </header>

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
                    <p>Kiểm tra sản phẩm trước khi đặt hàng</p>
                </div>
            </div>

            <asp:Panel ID="EmptyCartPanel" runat="server" CssClass="cart-empty" Visible="false">
                <p>Giỏ hàng đang trống.</p>
                <a class="btn btn-outline-dark" href="/">Tiếp tục mua sắm</a>
            </asp:Panel>

            <asp:Panel ID="CartPanel" runat="server">
                <div class="cart-table">
                    <div class="cart-header">
                        <div>Sản phẩm</div>
                        <div>Giá</div>
                        <div>Số lượng</div>
                        <div>Thành tiền</div>
                        <div></div>
                    </div>
                    <asp:Repeater ID="CartRepeater" runat="server" OnItemCommand="CartRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="cart-row">
                                <div class="cart-product">
                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                    <div>
                                        <div class="cart-title"><%# Eval("ProductName") %></div>
                                        <div class="cart-variant"><%# Eval("VariantText") %></div>
                                    </div>
                                </div>
                                <div class="cart-price"><%# Eval("Price") %></div>
                                <div class="cart-qty">
                                    <asp:HiddenField ID="VariantIdField" runat="server" Value='<%# Eval("VariantId") %>' />
                                    <asp:TextBox ID="QtyTextBox" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("Quantity") %>' />
                                </div>
                                <div class="cart-total"><%# Eval("LineTotal") %></div>
                                <div>
                                    <asp:LinkButton ID="RemoveButton" runat="server" CommandName="remove" CommandArgument='<%# Eval("VariantId") %>' CssClass="btn btn-link text-danger p-0">Xóa</asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="cart-actions">
                    <asp:Button ID="UpdateCartButton" runat="server" CssClass="btn btn-outline-dark" Text="Cập nhật giỏ hàng" OnClick="UpdateCartButton_Click" />
                    <div class="cart-summary">
                        <div>Tạm tính</div>
                        <div class="cart-summary-total"><asp:Literal ID="CartTotalLiteral" runat="server" /></div>
                    </div>
                </div>
            </asp:Panel>
        </main>
    </form>
    <script src="/public/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/public/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/public/assets/js/public-search.js"></script>
</body>
</html>
