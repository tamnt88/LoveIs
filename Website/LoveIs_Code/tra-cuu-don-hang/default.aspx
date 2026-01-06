<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="OrderLookup" MasterPageFile="~/public/Public.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" EnableEventValidation="false" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="SeoTitleLiteral" runat="server" />
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <asp:Literal ID="SeoMetaLiteral" runat="server" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="py-4">
        <div class="container">
            <div class="breadcrumb-wrapper mb-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Tra cứu đơn hàng</li>
                    </ol>
                </nav>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            <h3 class="mb-2">Tra cứu đơn hàng</h3>
                            <p class="text-muted mb-4">Nhập mã đơn và số điện thoại đã đặt hàng để xem chi tiết.</p>

                            <asp:Literal ID="MessageLiteral" runat="server" />

                            <div class="row g-3" id="tra_cuu_don_hang_content">
                                <div class="col-md-6">
                                    <label for="OrderCodeInput" class="form-label">Mã đơn hàng</label>
                                    <asp:TextBox ID="OrderCodeInput" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label for="PhoneInput" class="form-label">Số điện thoại</label>
                                    <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="d-flex gap-2 mt-4">
                                <asp:LinkButton ID="LookupButton" runat="server" CssClass="btn btn-dark px-4" OnClick="LookupButton_Click">
                                    <i class="fa-solid fa-magnifying-glass me-2"></i>Tra cứu
                                </asp:LinkButton>
                                <%--<a class="btn btn-outline-dark" href="/">Về trang chủ</a>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
