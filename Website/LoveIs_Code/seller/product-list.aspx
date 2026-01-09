<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-list.aspx.cs" Inherits="SellerProducts" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Quản lý sản phẩm</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-products">
        <div class="product-header">
            <div>
                <h2>Quản lý sản phẩm</h2>
                <p class="order-subtitle">Quản lý tất cả sản phẩm đồ lót nữ của shop</p>
            </div>
            <div class="product-header-actions">
                <a class="btn-outline btn-import-template" href="/seller/product-import-template.xlsx" download>
                    <i class="fa-solid fa-download"></i>
                    Tải file mẫu
                </a>
                <button class="btn-outline btn-import" type="button" id="importFileTrigger">
                    <i class="fa-solid fa-file-arrow-up"></i>
                    Nhập file
                </button>
                <asp:FileUpload ID="ImportFileUpload" runat="server" Style="display:none;" accept=".xlsx" />
                <asp:Button ID="ImportSubmitButton" runat="server" CssClass="d-none" Text="Nhập file" OnClick="ImportSubmitButton_Click" />
                <a class="btn-primary btn-add" href="/seller/product-add.aspx">
                    <i class="fa-solid fa-plus"></i>
                    Thêm sản phẩm
                </a>
            </div>
        </div>
        <asp:Literal ID="ImportMessageLiteral" runat="server" />
        <div class="product-summary-grid">
            <div class="summary-card">
                <div class="summary-label">Tổng sản phẩm</div>
                <div class="summary-value"><asp:Literal ID="TotalProductLiteral" runat="server" /></div>
                <span class="summary-icon icon-blue"><i class="fa-solid fa-cube"></i></span>
            </div>
            <div class="summary-card">
                <div class="summary-label">Đang bán</div>
                <div class="summary-value text-approved"><asp:Literal ID="ActiveProductLiteral" runat="server" /></div>
                <span class="summary-icon icon-green"><i class="fa-regular fa-eye"></i></span>
            </div>
            <div class="summary-card">
                <div class="summary-label">Tạm ẩn</div>
                <div class="summary-value"><asp:Literal ID="HiddenProductLiteral" runat="server" /></div>
                <span class="summary-icon icon-gray"><i class="fa-regular fa-eye-slash"></i></span>
            </div>
            <div class="summary-card">
                <div class="summary-label">Hết hàng</div>
                <div class="summary-value text-rejected"><asp:Literal ID="OutOfStockLiteral" runat="server" /></div>
                <span class="summary-icon icon-red"><i class="fa-solid fa-cube"></i></span>
            </div>
        </div>
        <div class="product-tabs card">
            <div class="return-tabs product-tab-row">
                <a class="tab <%# GetTabClass("all") %>" href="/seller/product-list.aspx?status=all">Tất cả (<asp:Literal ID="TabAllLiteral" runat="server" />)</a>
                <a class="tab <%# GetTabClass("active") %>" href="/seller/product-list.aspx?status=active">Đang bán (<asp:Literal ID="TabActiveLiteral" runat="server" />)</a>
                <a class="tab <%# GetTabClass("hidden") %>" href="/seller/product-list.aspx?status=hidden">Tạm ẩn (<asp:Literal ID="TabHiddenLiteral" runat="server" />)</a>
                <a class="tab <%# GetTabClass("out") %>" href="/seller/product-list.aspx?status=out">Hết hàng (<asp:Literal ID="TabOutLiteral" runat="server" />)</a>
            </div>
            <div class="product-toolbar">
                <div class="return-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Tìm kiếm theo tên sản phẩm, SKU, danh mục..." />
                </div>
                <button class="btn-outline" type="button"><i class="fa-solid fa-filter"></i> Bộ lọc</button>
                <button class="btn-outline" type="button"><i class="fa-solid fa-download"></i> Xuất file</button>
            </div>
            <div class="product-table">
                <div class="product-table-head">
                    <div>Sản phẩm</div>
                    <div>Danh mục</div>
                    <div>Kho</div>
                    <div>Đã bán</div>
                    <div>Đánh giá</div>
                    <div>Lượt xem</div>
                    <div>Trạng thái</div>
                    <div>Thao tác</div>
                </div>
                <asp:Repeater ID="ProductRepeater" runat="server">
                    <ItemTemplate>
                        <div class="product-row">
                            <div class="product-cell">
                                <img class="product-thumb" src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" />
                                <div>
                                    <div class="product-name"><%# Eval("ProductName") %></div>
                                    <div class="product-sku">SKU: <%# Eval("Sku") %></div>
                                    <div class="product-price"><%# Eval("PriceLabel") %></div>
                                </div>
                            </div>
                            <div><%# Eval("CategoryName") %></div>
                            <div><%# Eval("StockLabel") %></div>
                            <div><%# Eval("SoldLabel") %></div>
                            <div class="product-rating">
                                <i class="fa-solid fa-star"></i>
                                <%# Eval("RatingLabel") %>
                                <div class="product-review"><%# Eval("ReviewLabel") %></div>
                            </div>
                            <div><%# Eval("ViewLabel") %></div>
                            <div><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("StatusLabel") %></span></div>
                            <div class="product-actions">
                                <a href="<%# Eval("ViewUrl") %>" title="Xem"><i class="fa-regular fa-eye"></i></a>
                                <a href="<%# Eval("EditUrl") %>" title="Sửa"><i class="fa-regular fa-pen-to-square"></i></a>
                                <a href="#" title="Xóa"><i class="fa-regular fa-trash-can"></i></a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <div class="seller-pagination">
            <div class="pagination-info"><asp:Literal ID="PaginationInfoLiteral" runat="server" /></div>
            <div class="pagination-links"><asp:Literal ID="PaginationLiteral" runat="server" /></div>
        </div>
    </div>
    <script>
        (function () {
            var trigger = document.getElementById('importFileTrigger');
            var input = document.getElementById('<%= ImportFileUpload.ClientID %>');
            var submit = document.getElementById('<%= ImportSubmitButton.ClientID %>');
            if (!trigger || !input || !submit) return;
            trigger.addEventListener('click', function () {
                input.click();
            });
            input.addEventListener('change', function () {
                if (input.files && input.files.length > 0) {
                    submit.click();
                }
            });
        })();
    </script>
</asp:Content>
