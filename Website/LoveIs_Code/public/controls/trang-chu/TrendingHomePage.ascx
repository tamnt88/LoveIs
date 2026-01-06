<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TrendingHomePage.ascx.cs" Inherits="public_controls_trang_chu_TrendingHomePage" %>
<!--==================== Trending Products Section Start ====================-->
<div class="full-row">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <div class="section-head d-flex justify-content-between align-items-center pb-20">
                    <h3 class="font-700 text-secondary mb-0 down-line">Sản phẩm đang thịnh hành</h3>
                    <div class="woocommerce-tabs wc-tabs-wrapper ps-0 mt-0">
                        <ul class="nav nav-pills wc-tabs" id="pills-tab-three" role="tablist">
                            <asp:Repeater ID="TrendingTabRepeater" runat="server">
                                <ItemTemplate>
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link <%# (Container.ItemIndex == 0 ? "active" : string.Empty) %>" id="trend-tab-<%# Eval("CategoryId") %>-tab" data-bs-toggle="pill" href="#trend-tab-<%# Eval("CategoryId") %>" role="tab" aria-controls="trend-tab-<%# Eval("CategoryId") %>" aria-selected="<%# (Container.ItemIndex == 0 ? "true" : "false") %>"><%# Eval("CategoryName") %></a>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="woocommerce-tabs wc-tabs-wrapper mt-0">
                <div class="tab-content" id="pills-tabContent-three">
                    <asp:Repeater ID="TrendingPanelRepeater" runat="server" OnItemDataBound="TrendingPanelRepeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="tab-pane fade <%# (Container.ItemIndex == 0 ? "show active" : string.Empty) %> woocommerce-Tabs-panel woocommerce-Tabs-panel--description" id="trend-tab-<%# Eval("CategoryId") %>" role="tabpanel" aria-labelledby="trend-tab-<%# Eval("CategoryId") %>-tab">
                                <div class="row g-3 row-cols-lg-5 row-cols-md-3 row-cols-sm-2 row-cols-2 product-style-1 trending-grid e-image-bg-light e-hover-image-zoom">
                                    <asp:Repeater ID="TrendingProductRepeater" runat="server">
                                        <ItemTemplate>
                                            <div class="col">
                                                <div class="product type-product">
                                                    <div class="product-wrapper">
                                                        <div class="product-image">
                                                            <a href="<%# Eval("Url") %>" class="woocommerce-LoopProduct-link">
                                                                <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>">
                                                            </a>
                                                            <%# Eval("DiscountBadge") %>
                                                        </div>
                                                        <div class="product-info">
                                                            <h3 class="product-title"><a href="<%# Eval("Url") %>"><%# Eval("ProductName") %></a></h3>
                                                            <div class="product-price">
                                                                <div class="price"><%# Eval("PriceHtml") %></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</div>
