<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PublicFooter.ascx.cs" Inherits="PublicFooter" %>

<div class="footer-benefits" style="display:none;">
    <div class="container">
        <div class="row g-3 align-items-center">
            <div class="col-lg-2 col-md-4 col-6">
                <div class="benefit-item">
                    <img src="<%= ResolveUrl("~/public/assets/icon/14.png") %>" alt="Thanh toán" />
                    <div>Thanh toán<br />khi nhận hàng</div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
                <div class="benefit-item">
                    <img src="<%= ResolveUrl("~/public/assets/icon/15.png") %>" alt="Giao nhanh" />
                    <div>Giao nhanh<br />miễn phí 2H</div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
                <div class="benefit-item">
                    <img src="<%= ResolveUrl("~/public/assets/icon/16.png") %>" alt="Đổi trả" />
                    <div>30 ngày đổi<br />trả miễn phí</div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
                <div class="benefit-item">
                    <img src="<%= ResolveUrl("~/public/assets/icon/17.png") %>" alt="Thương hiệu" />
                    <div>Thương hiệu<br />uy tín toàn cầu</div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
                <div class="benefit-action">
                    <div class="benefit-label"><i class="fa-solid fa-circle-question"></i> Hotline CSKH</div>
                    <a class="benefit-button" href="tel:0828409096">0828 409 096</a>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
                <div class="benefit-action">
                    <div class="benefit-label"><i class="fa-solid fa-location-dot"></i> Tìm chi nhánh</div>
                    <a class="benefit-button" href="#">Hệ thống LoveIs Store</a>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="full-row bg-dark">
    <div class="container">
        <div class="footer-main">
            <div class="footer-contact-col">
                <div class="footer-contact-card">
                    <div class="footer-logo mb-3">
                        <a href="<%= ResolveUrl("~/") %>"><img src="<%= GetContactLogoUrl() %>" alt="LoveIs Store" /></a>
                    </div>
                    <div class="footer-contact">
                        <span class="footer-contact__headline">Bạn cần tư vấn?</span>
                        <a class="footer-contact__phone" href="tel:<%= ContactHotlineTelText %>">
                            <i class="fa-solid fa-phone"></i>
                            <span><%= ContactHotlineText %></span>
                        </a>
                        <div class="footer-contact__item">
                            <i class="fa-solid fa-location-dot"></i>
                            <span><%= ContactAddressText %></span>
                        </div>
                        <div class="footer-contact__item">
                            <i class="fa-solid fa-envelope"></i>
                            <span><%= ContactEmailText %></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="footer-menu-col">
                <div class="row g-4">
                    <asp:Repeater ID="FooterGroupRepeater" runat="server" OnItemDataBound="FooterGroupRepeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="col-lg-3 col-md-6">
                                <div class="footer-widget category-widget footer-accordion">
                                    <button type="button" class="footer-accordion-toggle">
                                        <span><%# Eval("GroupName") %></span>
                                        <i class="fa-solid fa-chevron-down"></i>
                                    </button>
                                    <div class="footer-accordion-body">
                                        <ul>
                                            <asp:Repeater ID="FooterItemRepeater" runat="server">
                                                <ItemTemplate>
                                                    <li><a href="<%# GetFooterUrl(Eval("Url")) %>"><%# Eval("Title") %></a></li>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <div class="col-lg-3 col-md-6">
                        <div class="footer-widget category-widget footer-accordion">
                            <button type="button" class="footer-accordion-toggle">
                                <span>THANH TOÁN</span>
                                <i class="fa-solid fa-chevron-down"></i>
                            </button>
                            <div class="footer-accordion-body">
                                <div class="footer-payment-grid">
                                    <img src="<%= ResolveUrl("~/images/1.png") %>" alt="Thanh toán 1" />
                                    <img src="<%= ResolveUrl("~/images/2.png") %>" alt="Thanh toán 2" />
                                    <img src="<%= ResolveUrl("~/images/3.png") %>" alt="Thanh toán 3" />
                                    <img src="<%= ResolveUrl("~/images/4.png") %>" alt="Thanh toán 4" />
                                </div>
                                <div class="footer-shipping-title"><span>ĐƠN VỊ VẬN CHUYỂN</span>
                                <div class="footer-payment-grid">
                                    <img src="<%= ResolveUrl("~/images/8.png") %>" alt="Thanh toán 8" />
                                    <img src="<%= ResolveUrl("~/images/9.png") %>" alt="Thanh toán 9" />
                                    <img src="<%= ResolveUrl("~/images/10.png") %>" alt="Thanh toán 10" />
                                    <img src="<%= ResolveUrl("~/images/11.png") %>" alt="Thanh toán 11" />
                                    <img src="<%= ResolveUrl("~/images/12.png") %>" alt="Thanh toán 12" />
                                    <img src="<%= ResolveUrl("~/images/13.png") %>" alt="Thanh toán 13" />
                                    <img src="<%= ResolveUrl("~/images/14.png") %>" alt="Thanh toán 14" />
                                    <img src="<%= ResolveUrl("~/images/15.png") %>" alt="Thanh toán 15" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>

<div class="footer-bottom">
    <div class="container">
        <div class="footer-bottom-inner">
            <span class="footer-bottom-copy">Copyright © 2025 by LoveIs Store. All Rights Reserved</span>
            <div class="footer-bottom-social">
                <asp:Repeater ID="FooterSocialRepeater" runat="server">
                    <ItemTemplate>
                        <a class="footer-social-pill" href="<%# GetFooterUrl(Eval("Url")) %>" target="_blank" rel="noopener">
                            <i class="<%# Eval("IconClass") %>"></i>
                            <span><%# Eval("DisplayName") %></span>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</div>

<a href="#" class="bg-primary text-white" id="scroll"><i class="fa fa-angle-up"></i></a>

<script type="text/javascript">
    (function () {
        var toggles = document.querySelectorAll(".footer-accordion-toggle");
        if (!toggles || toggles.length === 0) {
            return;
        }
        for (var i = 0; i < toggles.length; i++) {
            toggles[i].addEventListener("click", function () {
                var parent = this.closest(".footer-accordion");
                if (!parent) {
                    return;
                }
                parent.classList.toggle("is-open");
            });
        }
    })();
</script>
