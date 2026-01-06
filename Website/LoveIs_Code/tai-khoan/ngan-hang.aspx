<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ngan-hang.aspx.cs" Inherits="CustomerBankPage" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Register Src="~/public/controls/CustomerSidebar.ascx" TagPrefix="uc" TagName="CustomerSidebar" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Ngân hàng
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 account-page">
        <div class="row g-4">
            <div class="col-lg-3">
                <uc:CustomerSidebar ID="CustomerSidebar" runat="server" />
            </div>
            <div class="col-lg-9">
                <div class="account-card">
                    <div class="account-card-header account-card-header-row">
                        <div>
                            <h4>Tài khoản ngân hàng</h4>
                            <p>Quản lý tài khoản nhận hoàn tiền từ LoveIs</p>
                        </div>
                        <button type="button" class="btn btn-dark account-add-btn" data-bs-toggle="collapse" data-bs-target="#BankForm">+ Thêm tài khoản</button>
                    </div>

                    <asp:Label ID="StatusMessage" runat="server" CssClass="account-message" />

                    <div class="collapse account-form" id="BankForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Ngân hàng</label>
                                <asp:TextBox ID="BankNameInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Chủ tài khoản</label>
                                <asp:TextBox ID="AccountNameInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số tài khoản</label>
                                <asp:TextBox ID="AccountNumberInput" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Chi nhánh</label>
                                <asp:TextBox ID="BranchInput" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                        <asp:Button ID="SaveBankButton" runat="server" CssClass="btn btn-dark account-save" Text="Lưu tài khoản" OnClick="SaveBankButton_Click" />
                    </div>

                    <asp:Repeater ID="BankRepeater" runat="server" OnItemCommand="BankRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="account-list-item">
                                <div>
                                    <div class="account-list-title"><%# Eval("BankName") %></div>
                                    <div class="account-list-text"><%# Eval("AccountName") %> | <%# Eval("AccountNumber") %></div>
                                    <div class="account-list-text"><%# Eval("Branch") %></div>
                                    <asp:Literal ID="DefaultBadge" runat="server" Text='<%# (bool)Eval("IsDefault") ? "<span class=\"account-badge\">Mặc định</span>" : "" %>' />
                                </div>
                                <div class="account-list-actions">
                                    <asp:LinkButton ID="SetDefaultButton" runat="server" CommandName="set-default" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-outline-dark btn-sm">Thiết lập mặc định</asp:LinkButton>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CommandName="delete" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-link text-danger">Xóa</asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
