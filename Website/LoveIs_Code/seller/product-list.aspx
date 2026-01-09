<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product-list.aspx.cs" Inherits="SellerProducts" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Qu?n l? s?n ph?m    <script>
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
    </script>    <script>
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
    </script></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-products">
        <div class="product-header">
            <div>
                <h2>Qu?n l? s?n ph?m</h2>
                <p class="order-subtitle">Qu?n l? T?t c? S?n ph?m ð? lót n? c?a shop</p>
            </div>
            <div class="product-header-actions">
                <a class="btn-outline btn-import-template" href="/seller/product-import-template.csv" download>
                    <i class="fa-solid fa-download"></i>
                    Tai file mau
                </a>
                <button class="btn-outline btn-import" type="button" id="importFileTrigger">
                    <i class="fa-solid fa-file-arrow-up"></i>
                    Nhap file
                </button>
                <asp:FileUpload ID="ImportFileUpload" runat="server" Style="display:none;" accept=".csv" />
                <asp:Button ID="ImportSubmitButton" runat="server" CssClass="d-none" Text="Nhap file" OnClick="ImportSubmitButton_Click" />
            <div class="product-header-actions">
                <a class="btn-outline btn-import-template" href="/seller/product-import-template.csv" download>
                    <i class="fa-solid fa-download"></i>
                    Tai file mau
                </a>
                <button class="btn-outline btn-import" type="button" id="importFileTrigger">
                    <i class="fa-solid fa-file-arrow-up"></i>
                    Nhap file
                </button>
                <asp:FileUpload ID="ImportFileUpload" runat="server" Style="display:none;" accept=".csv" />
                <asp:Button ID="ImportSubmitButton" runat="server" CssClass="d-none" Text="Nhap file" OnClick="ImportSubmitButton_Click" />
                <a class="btn-primary btn-add" href="/seller/product-add.aspx">
                    <i class="fa-solid fa-plus"></i>
                    Thêm S?n ph?m
                </a>
            </div>
            </div>
        </div>
        <asp:Literal ID="ImportMessageLiteral" runat="server" />
        <div class="product-summary-grid">
            <div class="summary-card">
                <div class="summary-label">T?ng s?n ph?m</div>
                <div class="summary-value"><asp:Literal ID="TotalProductLiteral" runat="server" /></div>
                <span class="summary-icon icon-blue"><i class="fa-solid fa-cube"></i></span>
            </div>
            <div class="summary-card">
                <div class="summary-label">Ðang bán</div>
                <div class="summary-value text-approved"><asp:Literal ID="ActiveProductLiteral" runat="server" /></div>
                <span class="summary-icon icon-green"><i class="fa-regular fa-eye"></i></span>
            </div>
            <div class="summary-card">
                <div class="summary-label">T?m ?n</div>
                <div class="summary-value"><asp:Literal ID="HiddenProductLiteral" runat="server" /></div>
                <span class="summary-icon icon-gray"><i class="fa-regular fa-eye-slash"></i></span>
            </div>
            <div class="summary-card">
                <div class="summary-label">H?t hàng</div>
                <div class="summary-value text-rejected"><asp:Literal ID="OutOfStockLiteral" runat="server" /></div>
                <span class="summary-icon icon-red"><i class="fa-solid fa-cube"></i></span>
            </div>
        </div>
        <div class="product-tabs card">
            <div class="return-tabs product-tab-row">
                <a class="tab <%# GetTabClass("all") %>" href="/seller/product-list.aspx?status=all">T?t c? (<asp:Literal ID="TabAllLiteral" runat="server" />)</a>
                <a class="tab <%# GetTabClass("active") %>" href="/seller/product-list.aspx?status=active">Ðang bán (<asp:Literal ID="TabActiveLiteral" runat="server" />)</a>
                <a class="tab <%# GetTabClass("hidden") %>" href="/seller/product-list.aspx?status=hidden">T?m ?n (<asp:Literal ID="TabHiddenLiteral" runat="server" />)</a>
                <a class="tab <%# GetTabClass("out") %>" href="/seller/product-list.aspx?status=out">H?t hàng (<asp:Literal ID="TabOutLiteral" runat="server" />)</a>
            </div>
            <div class="product-toolbar">
                <div class="return-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="T?m ki?m theo tên S?n ph?m, SKU, Danh m?c..." />
                </div>
                <button class="btn-outline" type="button"><i class="fa-solid fa-filter"></i> B? l?c</button>
                <button class="btn-outline" type="button"><i class="fa-solid fa-download"></i> Xu?t file</button>
            </div>
            <div class="product-table">
                <div class="product-table-head">
                    <div>S?n ph?m</div>
                    <div>Danh m?c</div>
                    <div>Kho</div>
                    <div>Ð? bán</div>
                    <div>Ðánh giá</div>
                    <div>Lý?t xem</div>
                    <div>Tr?ng thái</div>
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
                                <a href="<%# Eval("EditUrl") %>" title="S?a"><i class="fa-regular fa-pen-to-square"></i></a>
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
    </script>    <script>
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
    </script></asp:Content>





