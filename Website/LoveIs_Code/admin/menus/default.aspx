<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="AdminMenusDefault" MasterPageFile="~/admin/admin.master" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="server">
    Menu admin
</asp:Content>
<asp:Content ID="HeadingContent" ContentPlaceHolderID="PageHeading" runat="server">
    Menu admin
</asp:Content>
<asp:Content ID="SubHeadingContent" ContentPlaceHolderID="PageSubHeading" runat="server">
    Quản lý menu hiển thị trong hệ thống
</asp:Content>
<asp:Content ID="BreadcrumbContent" ContentPlaceHolderID="PageBreadcrumb" runat="server">
    <li class="breadcrumb-item"><a href="/admin/default.aspx">Trang chủ</a></li>
    <li class="breadcrumb-item active" aria-current="page">Menu admin</li>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3">
        <div class="col-lg-4">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Thêm / Sửa menu</h6>
                <asp:Label ID="FormMessage" runat="server" CssClass="text-danger small d-block mb-2"></asp:Label>
                <asp:HiddenField ID="MenuId" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Menu cha</label>
                    <asp:DropDownList ID="ParentMenuId" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tên menu</label>
                    <asp:TextBox ID="MenuNameInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <asp:HiddenField ID="MenuGroupInput" runat="server" Value="Admin" />
                <div class="mb-3">
                    <label class="form-label">URL</label>
                    <asp:TextBox ID="UrlInput" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Icon (class)</label>
                    <asp:TextBox ID="IconInput" runat="server" CssClass="form-control" placeholder="fa-solid fa-bars"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thứ tự</label>
                    <asp:TextBox ID="SortOrderInput" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="StatusInput" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label" for="<%= StatusInput.ClientID %>">Hiển thị</label>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary btn-with-icon" OnClick="SaveButton_Click">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetButton" runat="server" CssClass="btn btn-outline-secondary btn-with-icon" OnClick="ResetButton_Click">
                        <i class="fa-solid fa-rotate-right"></i> Làm mới
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-kpi p-3 bg-white">
                <h6 class="mb-3 section-title">Danh sách menu</h6>
                <asp:HiddenField ID="SortPayload" runat="server" />
                <asp:Repeater ID="MenuRepeater" runat="server" OnItemDataBound="MenuRepeater_ItemDataBound" OnItemCommand="MenuRepeater_ItemCommand">
                    <HeaderTemplate>
                        <div class="menu-table" id="menuTable">
                            <div class="menu-row menu-header">
                                <div>Tên menu</div>
                                <div>URL</div>
                                <div>Icon</div>
                                <div>Thứ tự</div>
                                <div>Trạng thái</div>
                                <div>Thao tác</div>
                            </div>
                            <div id="menuRows">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="menu-row" data-id="<%# Eval("Id") %>" data-parent="0">
                            <div class="menu-name">
                                <strong><%# Eval("MenuName") %></strong>
                            </div>
                            <div><%# Eval("Url") %></div>
                            <div><%# Eval("Icon") %></div>
                            <div><%# Eval("SortOrder") %></div>
                            <div>
                                <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                    <%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %>
                                </span>
                            </div>
                            <div class="menu-actions">
                                <asp:LinkButton ID="EditButton" runat="server" CommandName="EditMenu" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </asp:LinkButton>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteMenu" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('Xóa menu này?');">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </asp:LinkButton>
                            </div>
                        </div>
                        <asp:Repeater ID="ChildRepeater" runat="server" OnItemCommand="ChildRepeater_ItemCommand">
                            <ItemTemplate>
                                <div class="menu-row menu-child" data-id="<%# Eval("Id") %>" data-parent="<%# Eval("ParentId") %>">
                                    <div class="menu-name">
                                        <span class="menu-child-bullet">-</span> <%# Eval("MenuName") %>
                                    </div>
                                    <div><%# Eval("Url") %></div>
                                    <div><%# Eval("Icon") %></div>
                                    <div><%# Eval("SortOrder") %></div>
                                    <div>
                                        <span class="status-tag <%# (bool)Eval("Status") ? "status-on" : "status-off" %>">
                                            <%# (bool)Eval("Status") ? "Hiển thị" : "Ẩn" %>
                                        </span>
                                    </div>
                                    <div class="menu-actions">
                                        <asp:LinkButton ID="EditButton" runat="server" CommandName="EditMenu" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary btn-with-icon">
                                            <i class="fa-solid fa-pen"></i> Sửa
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteMenu" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger btn-with-icon" OnClientClick="return confirm('Xóa menu này?');">
                                            <i class="fa-solid fa-trash"></i> Xóa
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ItemTemplate>
                    <FooterTemplate>
                            </div>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
                <div class="mt-3">
                    <asp:LinkButton ID="SaveSortButton" runat="server" CssClass="btn btn-outline-primary btn-with-icon" OnClick="SaveSortButton_Click">
                        <i class="fa-solid fa-arrows-up-down"></i> Lưu thứ tự
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="/admin/assets/vendor/jquery/jquery.min.js"></script>
    <script src="/admin/assets/vendor/jquery/jquery-ui.min.js"></script>
    <script>
        (function () {
            var $rows = $("#menuRows");
            if ($rows.length) {
                $rows.sortable({
                    items: ".menu-row",
                    placeholder: "menu-row menu-placeholder",
                    update: function () {
                        var payload = [];
                        $rows.children(".menu-row").each(function (index) {
                            payload.push({
                                id: $(this).data("id"),
                                parentId: $(this).data("parent"),
                                sortOrder: index + 1
                            });
                        });
                        $("#<%= SortPayload.ClientID %>").val(JSON.stringify(payload));
                    }
                });
            }
        })();
    </script>
</asp:Content>
