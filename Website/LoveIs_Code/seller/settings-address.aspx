<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-address.aspx.cs" Inherits="SellerSettingsAddress" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Địa chỉ của tôi</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-addresses">
        <div class="address-header">
            <div>
                <h2>Địa Chỉ Của Tôi</h2>
                <p>Quản lý địa chỉ lấy hàng và giao hàng</p>
            </div>
            <asp:LinkButton ID="AddAddressButton" runat="server" CssClass="btn-address-primary" OnClick="AddAddressButton_Click">
                <i class="fa-solid fa-plus"></i>
                Thêm Địa Chỉ
            </asp:LinkButton>
        </div>

        <div class="address-summary-grid">
            <div class="address-summary-card address-pickup">
                <div class="address-summary-top">
                    <span class="address-summary-icon"><i class="fa-solid fa-house"></i></span>
                    <div>
                        <div class="address-summary-title">Địa Chỉ Lấy Hàng</div>
                        <div class="address-summary-sub">Kho/Shop của bạn</div>
                    </div>
                </div>
                <div class="address-summary-value"><asp:Literal ID="PickupCountLiteral" runat="server" /></div>
            </div>
            <div class="address-summary-card address-return">
                <div class="address-summary-top">
                    <span class="address-summary-icon"><i class="fa-solid fa-building"></i></span>
                    <div>
                        <div class="address-summary-title">Địa Chỉ Trả Hàng</div>
                        <div class="address-summary-sub">Nhận hàng hoàn trả</div>
                    </div>
                </div>
                <div class="address-summary-value"><asp:Literal ID="ReturnCountLiteral" runat="server" /></div>
            </div>
        </div>

        <asp:Repeater ID="AddressRepeater" runat="server" OnItemCommand="AddressRepeater_ItemCommand">
            <ItemTemplate>
                <div class="address-card <%# Eval("MainCardClass") %>">
                    <div class="address-card-head">
                        <div class="address-card-left">
                            <span class="address-card-icon"><i class="fa-solid fa-location-dot"></i></span>
                            <div>
                                <div class="address-card-title"><%# Eval("Title") %></div>
                                <div class="address-card-sub"><%# Eval("TypeLabel") %></div>
                            </div>
                            <span class="address-pill" <%# (bool)Eval("IsDefault") ? "" : "style=\"display:none;\"" %>>Mặc định</span>
                        </div>
                        <div class="address-actions">
                            <asp:LinkButton ID="SetDefaultButton" runat="server" CssClass="btn-address-outline" CommandName="SetDefault" CommandArgument='<%# Eval("Id") %>' Visible='<%# !(bool)Eval("IsDefault") %>'>Đặt Mặc Định</asp:LinkButton>
                            <asp:LinkButton ID="EditButton" runat="server" CssClass="address-icon-btn" CommandName="EditAddress" CommandArgument='<%# Eval("Id") %>'><i class="fa-regular fa-pen-to-square"></i></asp:LinkButton>
                            <asp:LinkButton ID="DeleteButton" runat="server" CssClass="address-icon-btn danger" CommandName="DeleteAddress" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Bạn có chắc muốn xóa địa chỉ này không?');"><i class="fa-regular fa-trash-can"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div class="address-card-body">
                        <div class="address-row"><span>Người liên hệ:</span> <%# Eval("ContactLine") %></div>
                        <div class="address-row"><span>Địa chỉ:</span> <%# Eval("AddressLine") %></div>
                        <div class="address-row"><span>Khu vực:</span> <%# Eval("AreaLine") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="AddressModal" runat="server" CssClass="address-modal" Visible="false">
        <div class="address-modal-card">
            <div class="address-modal-header">
                <div><asp:Literal ID="ModalTitleLiteral" runat="server" /></div>
                <asp:LinkButton ID="CloseModalButton" runat="server" CssClass="address-icon-btn" OnClick="CloseModalButton_Click"><i class="fa-solid fa-xmark"></i></asp:LinkButton>
            </div>
            <div class="address-modal-body">
                <asp:Literal ID="AddressFormAlertLiteral" runat="server" />
                <asp:HiddenField ID="AddressIdHidden" runat="server" />
                <asp:HiddenField ID="ShopIdHidden" runat="server" />
                <div class="address-form-grid">
                    <div class="form-group">
                        <label>Tên địa chỉ</label>
                        <asp:TextBox ID="TitleInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Loại địa chỉ</label>
                        <asp:DropDownList ID="TypeDropDown" runat="server" CssClass="form-control">
                            <asp:ListItem Value="pickup">Địa chỉ lấy hàng</asp:ListItem>
                            <asp:ListItem Value="return">Địa chỉ trả hàng</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Người liên hệ</label>
                        <asp:TextBox ID="ContactNameInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group form-group-full">
                        <label>Địa chỉ</label>
                        <asp:TextBox ID="AddressLineInput" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Phường/Xã</label>
                        <div class="select-search" data-select="WardDropDown">
                            <button type="button" class="select-search-btn" id="WardSelectBtn">-- Chọn phường/xã --</button>
                            <div class="select-search-menu" id="WardSelectMenu">
                                <input type="text" class="select-search-input" placeholder="Tìm phường/xã" />
                                <div class="select-search-options"></div>
                            </div>
                            <asp:DropDownList ID="WardDropDown" runat="server" CssClass="select-search-native" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Tỉnh/Thành phố</label>
                        <div class="select-search" data-select="ProvinceDropDown">
                            <button type="button" class="select-search-btn" id="ProvinceSelectBtn">-- Chọn tỉnh/thành phố --</button>
                            <div class="select-search-menu" id="ProvinceSelectMenu">
                                <input type="text" class="select-search-input" placeholder="Tìm tỉnh/thành phố" />
                                <div class="select-search-options"></div>
                            </div>
                            <asp:DropDownList ID="ProvinceDropDown" runat="server" CssClass="select-search-native" AutoPostBack="true" OnSelectedIndexChanged="ProvinceDropDown_SelectedIndexChanged" />
                        </div>
                    </div>
                    <div class="form-group form-group-full address-default-row">
                        <asp:CheckBox ID="DefaultCheckBox" runat="server" />
                        <label for="<%= DefaultCheckBox.ClientID %>">Đặt làm mặc định</label>
                    </div>
                </div>
            </div>
            <div class="address-modal-footer">
                <asp:LinkButton ID="CancelModalButton" runat="server" CssClass="btn-outline" OnClick="CloseModalButton_Click">Hủy</asp:LinkButton>
                <asp:LinkButton ID="SaveAddressButton" runat="server" CssClass="btn-primary" OnClick="SaveAddressButton_Click">Lưu địa chỉ</asp:LinkButton>
            </div>
        </div>
    </asp:Panel>
    <asp:Literal ID="ToastMessageLiteral" runat="server" />
    <div id="ToastHost" class="toast-host"></div>
    <script>
        (function () {
            function showToast(message, type) {
                var host = document.getElementById("ToastHost");
                if (!host) return;
                var toast = document.createElement("div");
                var tone = (type || "success").toLowerCase();
                toast.className = "toast-message " + tone;
                var title = tone === "error" ? "Lỗi" : "Thành công";
                toast.innerHTML = '<div class="toast-accent"></div>'
                    + '<div class="toast-body">'
                    + '<div class="toast-title">' + title + '</div>'
                    + '<div class="toast-text">' + (message || "") + '</div>'
                    + '</div>'
                    + '<button type="button" class="toast-close" aria-label="Close">&times;</button>';
                host.appendChild(toast);
                setTimeout(function () {
                    toast.classList.add("show");
                }, 10);
                var closeBtn = toast.querySelector(".toast-close");
                if (closeBtn) {
                    closeBtn.addEventListener("click", function () {
                        toast.classList.remove("show");
                        setTimeout(function () {
                            if (toast && toast.parentNode) {
                                toast.parentNode.removeChild(toast);
                            }
                        }, 200);
                    });
                }
                setTimeout(function () {
                    toast.classList.remove("show");
                    setTimeout(function () {
                        if (toast && toast.parentNode) {
                            toast.parentNode.removeChild(toast);
                        }
                    }, 300);
                }, 2600);
            }
            window.SellerToast = { show: showToast };
        })();

        (function () {
            function initSearchSelect(selectClientId, buttonId, menuId, uniqueId, triggerPostback) {
                var select = document.getElementById(selectClientId);
                var button = document.getElementById(buttonId);
                var menu = document.getElementById(menuId);
                if (!select || !button || !menu) return;
                var input = menu.querySelector('.select-search-input');
                var optionsWrap = menu.querySelector('.select-search-options');

                function buildOptions(keyword) {
                    if (!optionsWrap) return;
                    optionsWrap.innerHTML = '';
                    var textKey = (keyword || '').toLowerCase();
                    Array.prototype.slice.call(select.options).forEach(function (opt) {
                        if (!opt.value) return;
                        var text = opt.text || '';
                        if (textKey && text.toLowerCase().indexOf(textKey) === -1) return;
                        var item = document.createElement('button');
                        item.type = 'button';
                        item.className = 'select-search-option';
                        item.textContent = text;
                        item.addEventListener('click', function () {
                            select.value = opt.value;
                            button.textContent = text;
                            menu.classList.remove('open');
                            if (triggerPostback && window.__doPostBack) {
                                window.__doPostBack(uniqueId, '');
                            }
                        });
                        optionsWrap.appendChild(item);
                    });
                }

                function syncButton() {
                    var selected = select.options[select.selectedIndex];
                    if (selected && selected.value) {
                        button.textContent = selected.text;
                    }
                }

                button.addEventListener('click', function () {
                    menu.classList.toggle('open');
                    if (menu.classList.contains('open')) {
                        buildOptions('');
                        if (input) {
                            input.value = '';
                            input.focus();
                        }
                    }
                });

                document.addEventListener('click', function (event) {
                    if (!menu.classList.contains('open')) return;
                    if (menu.contains(event.target) || button.contains(event.target)) return;
                    menu.classList.remove('open');
                });

                if (input) {
                    input.addEventListener('input', function () {
                        buildOptions(input.value);
                    });
                }

                syncButton();
            }

            initSearchSelect('<%= WardDropDown.ClientID %>', 'WardSelectBtn', 'WardSelectMenu', '', false);
            initSearchSelect('<%= ProvinceDropDown.ClientID %>', 'ProvinceSelectBtn', 'ProvinceSelectMenu', '<%= ProvinceDropDown.UniqueID %>', true);
        })();
    </script>
</asp:Content>
