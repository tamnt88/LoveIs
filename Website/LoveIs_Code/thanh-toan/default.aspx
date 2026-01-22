<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="CheckoutDefault" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" EnableEventValidation="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 checkout-page">
        <nav class="breadcrumb-wrapper" aria-label="breadcrumb">
            <ol class="breadcrumb mb-2">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="/gio-hang">Giỏ hàng</a></li>
                <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
            </ol>
        </nav>
        <div class="section-heading">
            <div>
                <h4>Thanh toán</h4>
                <p>Hoàn tất thông tin của bạn để đặt hàng.</p>
            </div>
        </div>

        <asp:Panel ID="CheckoutEmptyPanel" runat="server" CssClass="cart-empty" Visible="false">
            <p>Giỏ hàng của bạn đang trống.</p>
            <a class="btn btn-outline-dark" href="/">Tiếp tục mua sắm</a>
        </asp:Panel>

        <asp:UpdatePanel ID="CheckoutUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
        <asp:Panel ID="CheckoutPanel" runat="server">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card checkout-card">
                        <div class="card-body">
                            <h5 class="card-title">Thông tin giao hàng</h5>

<asp:Panel ID="AddressBookPanel" runat="server" CssClass="mb-3" Visible="false">
    <label class="form-label">Sổ địa chỉ</label>
    <asp:DropDownList ID="AddressSelect" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="AddressSelect_SelectedIndexChanged" />
    <small class="text-muted d-block mt-2">Chọn địa chỉ để đặt hàng.</small>
</asp:Panel>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Họ & tên</label>
                                    <asp:TextBox ID="CustomerNameInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Số điện thoại</label>
                                    <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Địa chỉ (Số nhà  + Tên đường)</label>
                                    <asp:TextBox ID="AddressInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Tỉnh/thành phố</label>
                                    <asp:DropDownList ID="ProvinceDropDown" runat="server" CssClass="form-select" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phường/xã</label>
                                    <asp:DropDownList ID="WardDropDown" runat="server" CssClass="form-select" />
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Ghi chú</label>
                                    <asp:TextBox ID="NoteInput" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card checkout-card mt-4">
                        <div class="card-body">
                            <h5 class="card-title">Hóa đơn công ty (tùy chọn)</h5>


                            <div class="form-check mb-3">
                                <asp:CheckBox ID="InvoiceCheckBox" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="MainContent_InvoiceCheckBox">Xuất hóa đơn công ty</label>
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tên công ty</label>
                                    <asp:TextBox ID="InvoiceCompanyInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Mã số thuế</label>
                                    <asp:TextBox ID="InvoiceTaxInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email nhận hóa đơn</label>
                                    <asp:TextBox ID="InvoiceEmailInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Địa chỉ xuất hóa đơn</label>
                                    <asp:TextBox ID="InvoiceAddressInput" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card checkout-card mt-4">
                        <div class="card-body">
                            <h5 class="card-title">Vận chuyển</h5>


                            <asp:RadioButtonList ID="ShippingMethodList" runat="server" CssClass="checkout-radio" RepeatLayout="Flow" />
                            <div class="checkout-hint">Phí vận chuyển được tính theo tỉnh/phường.</div>
                        </div>
                    </div>

                    <div class="card checkout-card mt-4">
                        <div class="card-body">
                            <h5 class="card-title">Thanh toán</h5>


                            <asp:RadioButtonList ID="PaymentMethodList" runat="server" CssClass="checkout-radio" RepeatLayout="Flow" />
                            <asp:HiddenField ID="OnlinePaymentMethodId" runat="server" />
                            <div id="OnePayChannelSection" class="checkout-online-options" style="display:none;">
                                <label class="form-label">Chọn hình thức thanh toán online bạn yêu thích</label>
                                <div id="OnePayTabs" class="onepay-tabs" role="tablist" aria-label="OnePay channels"></div>
                                <div id="OnePayPanels" class="onepay-panels"></div>
                                <asp:RadioButtonList ID="OnePayChannelList" runat="server" CssClass="checkout-radio onepay-hidden" RepeatLayout="Flow" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card checkout-card">
                        <div class="card-body">
                            <h5 class="card-title">Giỏ hàng</h5>


                            <asp:Repeater ID="SummaryGroupRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="checkout-shop-group">
                                        <div class="checkout-shop-name"><%# Eval("ShopName") %></div>
                                        <asp:Repeater ID="SummaryItemRepeater" runat="server" DataSource='<%# Eval("Items") %>'>
                                            <ItemTemplate>
                                                <div class="checkout-item">
                                                    <div>
                                                        <div class="checkout-item-name"><%# Eval("ProductName") %></div>
                                                        <div class="checkout-item-variant"><%# Eval("VariantText") %></div>
                                                    </div>
                                                    <div class="checkout-item-price"><%# Eval("LineTotal") %></div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <div class="checkout-coupon mt-3">
                                <label class="form-label">Mã giảm giá</label>
                                <div class="coupon-divider">Chọn mã giảm giá bạn yêu thích</div>
                                <div class="coupon-list">
                                    <asp:Repeater ID="CouponRepeater" runat="server">
                                        <ItemTemplate>
                                            <label class="coupon-card">
                                                <input type="checkbox" class="coupon-check" value="<%# Eval("Id") %>" data-code="<%# Eval("Code") %>" <%# (bool)Eval("IsSelected") ? "checked=\"checked\"" : "" %> />
                                                <span class="coupon-badge">
                                                    <span class="coupon-badge-label">Moi</span>
                                                    <span class="coupon-badge-value"><%# Eval("BadgeValue") %></span>
                                                    <span class="coupon-badge-sub"><%# Eval("BadgeSub") %></span>
                                                </span>
                                                <span class="coupon-content">
                                                    <span class="coupon-shop"><%# Eval("ShopLabel") %></span>
                                                    <span class="coupon-code">Ma: <%# Eval("Code") %></span>
                                                    <span class="coupon-meta"><%# Eval("MetaText") %></span>
                                                </span>
                                                <span class="coupon-radio"></span>
                                            </label>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:HiddenField ID="SelectedCouponIds" runat="server" />
                                </div>
                            </div>

                            <div class="checkout-total">
                                <div class="checkout-total-row">
                                    <span>Tạm tính</span>
                                    <strong><span id="SubtotalValue" runat="server"><asp:Literal ID="SubtotalLiteral" runat="server" /></span></strong>
                                </div>
                                <div class="checkout-total-row">
                                    <span>Phí vận chuyển</span>
                                    <strong><span id="ShippingFeeValue" runat="server"><asp:Literal ID="ShippingFeeLiteral" runat="server" /></span></strong>
                                </div>
                                <div id="ShippingFeeBreakdown" class="checkout-shipping-breakdown">
                                    <asp:Repeater ID="ShippingFeeRepeater" runat="server">
                                        <ItemTemplate>
                                            <div class="shipping-breakdown-item">
                                                <span><%# Eval("ShopName") %></span>
                                                <span><%# Eval("ShippingFeeText") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                                </div>
                                <div class="checkout-total-row">
                                    <span>Giảm giá</span>
                                    <strong><span id="DiscountValue" runat="server"><asp:Literal ID="DiscountLiteral" runat="server" /></span></strong>
                                </div>
                                <div class="checkout-total-row total">
                                    <span>Tổng cộng</span>
                                    <strong><span id="TotalValue" runat="server"><asp:Literal ID="TotalLiteral" runat="server" /></span></strong>
                                </div>
                            </div>

                            <asp:Label ID="CheckoutMessage" runat="server" CssClass="text-danger" />
                            <asp:Button ID="PlaceOrderButton" runat="server" Text="Xác nhận đặt hàng" CssClass="btn btn-dark w-100 mt-3" OnClick="PlaceOrderButton_Click" />
                            <a class="btn btn-outline-dark w-100 mt-2" href="/gio-hang">Quay lại giỏ hàng</a>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="PlaceOrderButton" />
            </Triggers>
        </asp:UpdatePanel>
    </main>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        (function () {
            function callPageMethod(method, data, onSuccess) {
                if (typeof PageMethods !== "undefined" && typeof PageMethods[method] === "function") {
                    if (method === "GetWards") {
                        PageMethods.GetWards(data.provinceId, onSuccess);
                    } else if (method === "GetCheckoutSummary") {
                        PageMethods.GetCheckoutSummary(data.provinceId, data.wardId, data.shippingMethodId, data.couponIds, onSuccess);
                    }
                    return;
                }
                $.ajax({
                    type: "POST",
                    url: "/thanh-toan/default.aspx/" + method,
                    data: JSON.stringify(data),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        onSuccess(res.d);
                    }
                });
            }

            function toggleOnlinePaymentOptions() {
                var onlineId = parseInt($("#<%= OnlinePaymentMethodId.ClientID %>").val(), 10) || 0;
                var selectedPaymentId = parseInt($("#<%= PaymentMethodList.ClientID %> input:checked").val(), 10) || 0;
                if (onlineId > 0 && selectedPaymentId === onlineId) {
                    $("#OnePayChannelSection").show();
                } else {
                    $("#OnePayChannelSection").hide();
                }
            }

            function decorateOnePayOptions() {
                var container = document.getElementById("<%= OnePayChannelList.ClientID %>");
                var tabs = document.getElementById("OnePayTabs");
                var panels = document.getElementById("OnePayPanels");
                if (!container) {
                    return;
                }
                var inputs = container.querySelectorAll("input[type='radio']");
                var domesticFiles = ["10_logo_full.svg"/*, "11_logo_full.svg"*//*, "12_logo_full.svg"*/, "14_logo_full.svg"/*, "15_logo_full.svg"*/, "16_logo_full.svg"/*, "17_logo_full.svg"*/, "18_logo_full.svg", "19_logo_full.svg", "1_logo_full.svg"/*, "20_logo_full.svg"*/, "22_logo_full.svg"/*, "23_logo_full.svg"*/, "24_logo_full.svg", "25_logo_full.svg"/*, "27_logo_full.svg"*/, "2_logo_full.svg"/*, "30_logo_full.svg"*//*, "31_logo_full.svg"*/, "33_logo_full.svg", "34_logo_full.svg", "35_logo_full.svg", "36_logo_full.svg", "37_logo_full.svg", "38_logo_full.svg", "39_logo_full.svg", "3_logo_full.svg", "40_logo_full.svg", "41_logo_full.svg", "42_logo_full.svg", "43_logo_full.svg", "44_logo_full.svg", "45_logo_full.svg", "46_logo_full.svg"/*, "47_logo_full.svg"*//*, "48_logo_full.svg"*/, "49_logo_full.svg"/*, "4_logo_full.svg"*/, "50_logo_full.svg"/*, "51_logo_full.svg"*/, "52_logo_full.svg"/*, "57_logo_full.svg"*/, "58_logo_full.svg"/*, "59_logo_full.svg"*/, "5_logo_full.svg", "60_logo_full.svg"/*, "61_logo_full.svg"*//*, "62_logo_full.svg"*//*, "63_logo_full.svg"*/, "64_logo_full.svg", "65_logo_full.svg", "66_logo_full.svg"/*, "67_logo_full.svg"*/, "68_logo_full.svg"/*, "69_logo_full.svg"*/, "6_logo_full.svg"/*, "70_logo_full.svg"*/, "71_logo_full.svg", "72_logo_full.svg", "73_logo_full.svg", "74_logo_full.svg", "75_logo_full.svg", "7_logo_full.svg"/*, "80_logo_full.svg"*//*, "8_logo_full.svg"*/, "999_logo_full.svg", "9_logo_full.svg", "vietqr_logo_full.svg"];
                var internationalFiles = ["amex.svg", "CUP.svg", "JC.svg", "MC.svg", "UnionPAY.svg", "VS.svg"];
                var qrFiles = ["qr-9pay.svg", "qr-abbank.svg", "qr-acb.svg", "qr-agribank.svg", "qr-appota.svg", "qr-bacabank.svg", "qr-baoviet.svg", "qr-bidcvn.svg", "qr-bidv.svg", "qr-bidvpayplus.svg", "qr-bidvsmartbanking.svg", "qr-cbbank.svg", "qr-coopbank.svg", "qr-eximbank.svg", "qr-foxpay.svg", "qr-grabpay.svg", "qr-hdbank.svg", "qr-ivbmobile.svg", "qr-kienlongbank.svg", "qr-mbbank.svg", "qr-momo.svg", "qr-mpayvn.svg", "qr-msb.svg", "qr-msbmbank.svg", "qr-myvib.svg", "qr-namabank.svg", "qr-ncbsmart.svg", "qr-ocb.svg", "qr-ocbomni.svg", "qr-oceanbankeasy.svg", "qr-payme.svg", "qr-pgbank.svg", "qr-publicbank.svg", "qr-pvcombank.svg", "qr-pvmobilebanking.svg", "qr-sacombank.svg", "qr-sacombankpay.svg", "qr-saigonbank.svg", "qr-scbmobile.svg", "qr-seamobile.svg", "qr-shbmobile.svg", "qr-shopeepay.svg", "qr-smartpay.svg", "qr-solvn.svg", "qr-techcombank.svg", "qr-ting.svg", "qr-tpbank.svg", "qr-tpbankquickpay.svg", "qr-truemoney.svg", "qr-unionpay.svg", "qr-vbsp.svg", "qr-vcbpay.svg", "qr-vietabank.svg", "qr-vietbankdigital.svg", "qr-vietcapitalbank.svg", "qr-vietcombank.svg", "qr-vietcredit.svg", "qr-vietin.svg", "qr-vietinbankipay.svg", "qr-viettelpay.svg", "qr-vinid.svg", "qr-viviet.svg", "qr-vivimass.svg", "qr-vivnpay.svg", "qr-vnptpay.svg", "qr-vpbankneo.svg", "qr-vpbankonline.svg", "qr-vtcpay.svg", "qr-wooribank.svg", "qr-yolo.svg", "qr-zalopay.svg"];
                var appleFiles = ["applepay.svg"];
                var samsungFiles = ["samsungpay.svg"];
                var googleFiles = ["googlepay.png"];

                if (!tabs || !panels) {
                    return;
                }
                if (tabs.childNodes.length || panels.childNodes.length) {
                    return;
                }

                function buildLogoGrid(files, basePath, altText) {
                    var grid = document.createElement("div");
                    grid.className = "onepay-panel-logos";
                    files.forEach(function (fileName) {
                        var img = document.createElement("img");
                        img.src = basePath + fileName;
                        img.alt = altText;
                        grid.appendChild(img);
                    });
                    return grid;
                }

                function setActive(value) {
                    var activeInput = container.querySelector("input[value='" + value + "']");
                    if (activeInput) {
                        activeInput.checked = true;
                    }
                    tabs.querySelectorAll(".onepay-tab").forEach(function (tab) {
                        tab.classList.toggle("is-active", tab.getAttribute("data-value") === value);
                    });
                    panels.querySelectorAll(".onepay-panel").forEach(function (panel) {
                        panel.classList.toggle("is-active", panel.getAttribute("data-value") === value);
                    });
                }

                inputs.forEach(function (input) {
                    var label = container.querySelector("label[for='" + input.id + "']");
                    if (!label) {
                        return;
                    }
                    var optionText = label.textContent || "";
                    var tab = document.createElement("button");
                    tab.type = "button";
                    tab.className = "onepay-tab";
                    tab.setAttribute("data-value", input.value);
                    tab.textContent = optionText.trim();
                    tab.addEventListener("click", function () {
                        setActive(input.value);
                    });
                    tabs.appendChild(tab);

                    var panel = document.createElement("div");
                    panel.className = "onepay-panel";
                    panel.setAttribute("data-value", input.value);
                    var title = document.createElement("div");
                    title.className = "onepay-panel-title";
                    title.textContent = optionText.trim();
                    panel.appendChild(title);

                    if (input.value === "INTERNATIONAL") {
                        panel.appendChild(buildLogoGrid(internationalFiles, "/images/internation/", "International card"));
                    } else if (input.value === "DOMESTIC") {
                        panel.appendChild(buildLogoGrid(domesticFiles, "/images/noidia/", "Domestic card"));
                    } else if (input.value === "EWALLET") {
                        panel.appendChild(buildLogoGrid(qrFiles, "/images/qr-app/", "QR payment"));
                    } else if (input.value === "APPLEPAY") {
                        panel.appendChild(buildLogoGrid(appleFiles, "/images/mobile-wallet/", "Apple Pay"));
                    } else if (input.value === "SAMSUNGPAY") {
                        panel.appendChild(buildLogoGrid(samsungFiles, "/images/mobile-wallet/", "Samsung Pay"));
                    } else if (input.value === "GOOGLEPAY") {
                        panel.appendChild(buildLogoGrid(googleFiles, "/images/mobile-wallet/", "Google Pay"));
                    }
                    panels.appendChild(panel);
                });

                var initial = container.querySelector("input[type='radio']:checked");
                setActive(initial ? initial.value : (inputs.length ? inputs[0].value : ""));
            }

            function updateSummary() {
                var provinceId = parseInt($("#<%= ProvinceDropDown.ClientID %>").val(), 10) || 0;
                var wardId = parseInt($("#<%= WardDropDown.ClientID %>").val(), 10) || 0;
                var shippingMethodId = parseInt($("#<%= ShippingMethodList.ClientID %> input:checked").val(), 10) || 0;
                var couponIds = $(".coupon-list .coupon-check:checked").map(function () {
                    return parseInt(this.value, 10);
                }).get();
                $("#<%= SelectedCouponIds.ClientID %>").val(couponIds.join(","));

                callPageMethod("GetCheckoutSummary", {
                    provinceId: provinceId,
                    wardId: wardId,
                    shippingMethodId: shippingMethodId,
                    couponIds: couponIds
                }, function (summary) {
                    if (!summary) {
                        return;
                    }
                    $("#<%= ShippingFeeValue.ClientID %>").text(summary.ShippingFeeText || "");
                    var breakdown = document.getElementById("ShippingFeeBreakdown");
                    if (breakdown) {
                        breakdown.innerHTML = "";
                        if (summary.ShopFees && summary.ShopFees.length) {
                            summary.ShopFees.forEach(function (item) {
                                var row = document.createElement("div");
                                row.className = "shipping-breakdown-item";
                                var name = document.createElement("span");
                                name.textContent = item.ShopName || "Shop";
                                var fee = document.createElement("span");
                                fee.textContent = item.ShippingFeeText || "";
                                row.appendChild(name);
                                row.appendChild(fee);
                                breakdown.appendChild(row);
                            });
                        }
                    }
                    $("#<%= DiscountValue.ClientID %>").text(summary.DiscountText || "");
                    $("#<%= TotalValue.ClientID %>").text(summary.TotalText || "");
                });
            }

            function loadWards() {
                var provinceId = parseInt($("#<%= ProvinceDropDown.ClientID %>").val(), 10) || 0;
                var $ward = $("#<%= WardDropDown.ClientID %>");
                $ward.empty();
                $ward.append($("<option></option>").val("").text("-- Chọn phường/xã --"));

                if (!provinceId) {
                    toggleOnlinePaymentOptions();
            updateSummary();
                    return;
                }

                callPageMethod("GetWards", { provinceId: provinceId }, function (items) {
                    if (Array.isArray(items)) {
                        items.forEach(function (item) {
                            $ward.append($("<option></option>").val(item.Id).text(item.Name));
                        });
                    }
                    toggleOnlinePaymentOptions();
            updateSummary();
                });
            }

            $(document).on("change", "#<%= ProvinceDropDown.ClientID %>", loadWards);
            $(document).on("change", "#<%= ShippingMethodList.ClientID %> input[type='radio']", updateSummary);
            $(document).on("change", "#<%= PaymentMethodList.ClientID %> input[type='radio']", toggleOnlinePaymentOptions);
            $(document).on("change", ".coupon-list .coupon-check", updateSummary);

            toggleOnlinePaymentOptions();
            decorateOnePayOptions();
            updateSummary();
        })();
    </script>
</asp:Content>
































