<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="SearchDefault" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">
<head runat="server">
    <title>Tìm kiếm | BeautyStory</title>
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
                    <a class="btn btn-outline-dark" href="/gio-hang/default.aspx">
                        <i class="fa-solid fa-cart-shopping me-1"></i> Giỏ hàng
                    </a>
                    <a class="btn btn-outline-dark" href="/admin/login.aspx">
                        <i class="fa-solid fa-lock me-1"></i> Quản trị
                    </a>
                </div>
            </div>
        </header>

        <main class="container py-4 category-page">
            <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
                <ol class="breadcrumb mb-2">
                    <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Tìm kiếm</li>
                </ol>
            </nav>
            <div class="section-heading">
                <div>
                    <h4>Kết quả tìm kiếm</h4>
                    <p><asp:Literal ID="SearchSummary" runat="server" /></p>
                </div>
            </div>

            <asp:Panel ID="EmptyResultPanel" runat="server" Visible="false" CssClass="cart-empty">
                <p>Không tìm thấy sản phẩm phù hợp.</p>
                <a class="btn btn-outline-dark" href="/">Quay về trang chủ</a>
            </asp:Panel>

            <div class="row g-3">
                <asp:Repeater ID="SearchRepeater" runat="server">
                    <ItemTemplate>
                        <div class="col-6 col-md-4 col-lg-3">
                            <div class="product-card">
                                <div class="product-thumb">
                                    <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                </div>
                                <div class="product-body">
                                    <div class="product-category"><%# Eval("CategoryName") %></div>
                                    <h6 class="product-title"><%# Eval("ProductName") %></h6>
                                    <div class="product-price"><%# Eval("PriceLabel") %></div>
                                </div>
                                <div class="product-footer">
                                    <a class="btn btn-sm btn-dark w-100" href="/san-pham/default.aspx?slug=<%# Eval("SeoSlug") %>">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="mt-4">
                <asp:Literal ID="PaginationLiteral" runat="server" />
            </div>
        </main>
    </form>
    <script src="/public/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/public/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/public/assets/js/public-search.js"></script>
</body>
</html>
