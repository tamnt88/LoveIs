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
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card checkout-card">
                        <div class="card-body">
                            <h5 class="card-title">Giỏ hàng</h5>

                            <asp:Repeater ID="SummaryRepeater" runat="server">
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

                            <div class="checkout-total">
                                <div class="checkout-total-row">
                                    <span>Tạm tính</span>
                                    <strong><span id="SubtotalValue" runat="server"><asp:Literal ID="SubtotalLiteral" runat="server" /></span></strong>
                                </div>
                                <div class="checkout-total-row">
                                    <span>Phí vận chuyển (tạm tính)</span>
                                    <strong><span id="ShippingFeeValue" runat="server"><asp:Literal ID="ShippingFeeLiteral" runat="server" /></span></strong>
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
                    } else if (method === "GetShippingSummary") {
                        PageMethods.GetShippingSummary(data.provinceId, data.shippingMethodId, onSuccess);
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

            function updateSummary() {
                var provinceId = parseInt($("#<%= ProvinceDropDown.ClientID %>").val(), 10) || 0;
                var shippingMethodId = parseInt($("#<%= ShippingMethodList.ClientID %> input:checked").val(), 10) || 0;

                if (!shippingMethodId) {
                    return;
                }

                callPageMethod("GetShippingSummary", { provinceId: provinceId, shippingMethodId: shippingMethodId }, function (result) {
                    if (!result) {
                        return;
                    }
                    $("#<%= ShippingFeeValue.ClientID %>").text(result.ShippingFeeText || "");
                    $("#<%= TotalValue.ClientID %>").text(result.TotalText || "");
                });
            }

            function loadWards() {
                var provinceId = parseInt($("#<%= ProvinceDropDown.ClientID %>").val(), 10) || 0;
                var $ward = $("#<%= WardDropDown.ClientID %>");
                $ward.empty();
                $ward.append($("<option></option>").val("").text("-- Chọn phường/xã --"));

                if (!provinceId) {
                    updateSummary();
                    return;
                }

                callPageMethod("GetWards", { provinceId: provinceId }, function (items) {
                    if (Array.isArray(items)) {
                        items.forEach(function (item) {
                            $ward.append($("<option></option>").val(item.Id).text(item.Name));
                        });
                    }
                    updateSummary();
                });
            }

            $(document).on("change", "#<%= ProvinceDropDown.ClientID %>", loadWards);
            $(document).on("change", "#<%= ShippingMethodList.ClientID %> input[type='radio']", updateSummary);
            updateSummary();
        })();
    </script>
</asp:Content>







