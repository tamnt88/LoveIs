<%@ Page Language="C#" AutoEventWireup="true" CodeFile="support-tickets.aspx.cs" Inherits="SellerSupportTickets" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" ValidateRequest="false" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Yêu cầu hỗ trợ</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-support">
        <div class="support-header support-header-split">
            <div>
                <h2>Yêu Cầu Hỗ Trợ</h2>
                <p>Gửi yêu cầu hỗ trợ chi tiết</p>
            </div>
            <button class="btn-support-primary" type="button" id="SupportCreateTrigger">
                <i class="fa-solid fa-plus"></i>
                Tạo Yêu Cầu Mới
            </button>
        </div>

        <div class="support-summary-grid">
            <div class="card support-summary-card">
                <div class="support-summary-icon info-blue"><i class="fa-regular fa-circle-question"></i></div>
                <div class="support-summary-label">Tổng Yêu Cầu</div>
                <div class="support-summary-value"><asp:Literal ID="TotalTicketLiteral" runat="server" /></div>
            </div>
            <div class="card support-summary-card">
                <div class="support-summary-icon info-yellow"><i class="fa-regular fa-clock"></i></div>
                <div class="support-summary-label">Đang Xử Lý</div>
                <div class="support-summary-value"><asp:Literal ID="ProcessingTicketLiteral" runat="server" /></div>
            </div>
            <div class="card support-summary-card">
                <div class="support-summary-icon info-green"><i class="fa-regular fa-circle-check"></i></div>
                <div class="support-summary-label">Đã Giải Quyết</div>
                <div class="support-summary-value"><asp:Literal ID="ResolvedTicketLiteral" runat="server" /></div>
            </div>
            <div class="card support-summary-card">
                <div class="support-summary-icon info-purple"><i class="fa-regular fa-hourglass"></i></div>
                <div class="support-summary-label">Thời Gian TB</div>
                <div class="support-summary-value"><asp:Literal ID="AverageTimeLiteral" runat="server" /></div>
            </div>
        </div>

        <div class="card support-table">
            <div class="support-table-title">Lịch Sử Yêu Cầu</div>
            <div class="support-table-head">
                <div>Mã YC</div>
                <div>Tiêu Đề</div>
                <div>Danh Mục</div>
                <div>Ngày Tạo</div>
                <div>Trạng Thái</div>
                <div>Ưu Tiên</div>
                <div>Thao tác</div>
            </div>
            <asp:Repeater ID="TicketRepeater" runat="server">
                <ItemTemplate>
                    <div class="support-row">
                        <div><%# Eval("Code") %></div>
                        <div><%# Eval("Title") %></div>
                        <div><%# Eval("Category") %></div>
                        <div><%# Eval("CreatedAt") %></div>
                        <div><span class="support-status <%# Eval("StatusClass") %>"><%# Eval("StatusLabel") %></span></div>
                        <div><span class="support-priority <%# Eval("PriorityClass") %>"><%# Eval("PriorityLabel") %></span></div>
                        <div>
                            <button class="btn-primary btn-support-detail" type="button"
                                data-code="<%# Eval("Code") %>"
                                data-status="<%# Eval("StatusLabel") %>"
                                data-title="<%# Eval("TitleAttr") %>"
                                data-desc="<%# Eval("DescAttr") %>"
                                data-reply="<%# Eval("ReplyAttr") %>"
                                data-has-reply="<%# Eval("HasAdminReply") %>"
                                data-ticket-id="<%# Eval("TicketId") %>"
                                data-can-cancel="<%# Eval("CanCancel") %>">Chi tiết</button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <div class="modal-overlay" id="SupportCreateModal" style="display:none;">
        <div class="modal-card support-modal">
            <div class="modal-header">
                <h4>Tạo yêu cầu hỗ trợ mới</h4>
                <button type="button" class="modal-close" data-modal-close>&times;</button>
            </div>
            <div class="form-group">
                <label>Tiêu đề</label>
                <asp:TextBox ID="CreateTitleInput" runat="server" CssClass="form-control" placeholder="Nhập tiêu đề" />
            </div>
            <div class="form-group">
                <label>Danh mục</label>
                <asp:DropDownList ID="CreateCategoryDropdown" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label>Mức độ ưu tiên</label>
                <asp:DropDownList ID="CreatePriorityDropdown" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label>Nội dung</label>
                <asp:TextBox ID="CreateMessageInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Mô tả chi tiết vấn đề" />
            </div>
            <asp:Literal ID="CreateTicketMessageLiteral" runat="server" />
            <asp:HiddenField ID="CreateTicketSuccessInput" runat="server" />
            <div class="modal-actions">
                <button type="button" class="btn-outline" data-modal-close>Hủy</button>
                <asp:Button ID="CreateTicketButton" runat="server" CssClass="btn-primary" Text="Gửi yêu cầu" OnClick="CreateTicketButton_Click" />
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="SupportDetailModal" style="display:none;">
        <div class="modal-card support-modal wide">
            <div class="modal-header">
                <h4>Chi tiết yêu cầu</h4>
                <button type="button" class="modal-close" data-modal-close>&times;</button>
            </div>
            <div class="support-detail-meta">
                <div><strong>Mã YC:</strong> <span id="SupportDetailCode">SR001</span></div>
                <div><strong>Trạng thái:</strong> <span class="support-status success" id="SupportDetailStatus">Đã giải quyết</span></div>
            </div>
            <div class="support-detail-section">
                <h5>Nội dung yêu cầu</h5>
                <p id="SupportDetailDesc">Không thể xuất Excel báo cáo doanh thu.</p>
            </div>
            <div class="support-detail-section">
                <h5>Phản hồi của admin</h5>
                <div class="support-detail-reply" id="SupportDetailReply">
                    Vui lòng thử xuất lại sau khi tải lại trang. Nếu vẫn lỗi, hãy cung cấp ảnh chụp màn hình.
                </div>
            </div>
            <div class="support-detail-section" id="SupportDetailReplySection" style="display:none;">
                <h5>Phản hồi lại admin</h5>
                <asp:HiddenField ID="ReplyTicketIdInput" runat="server" />
                <asp:TextBox ID="ReplyMessageInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Nhập phản hồi của bạn" />
                <asp:Literal ID="ReplyMessageLiteral" runat="server" />
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-outline" data-modal-close>Đóng</button>
                <asp:Button ID="ReplyTicketButton" runat="server" CssClass="btn-outline" Text="Gửi phản hồi" OnClick="ReplyTicketButton_Click" />
                <asp:LinkButton ID="CancelTicketButton" runat="server" CssClass="btn-outline btn-support-cancel"
                    OnCommand="CancelTicketButton_Command" CommandArgument="<%# CancelTicketArgInput.Value %>"
                    OnClientClick="return confirm('Bạn có chắc chắn muốn hủy yêu cầu này?');">Hủy</asp:LinkButton>
                <button type="button" class="btn-primary" id="SupportDetailCreate">Tạo ticket mới</button>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="CancelTicketArgInput" runat="server" />

    <asp:Literal ID="ToastMessageLiteral" runat="server" />
    <div id="ToastHost" class="toast-host"></div>
    <asp:Literal ID="SupportCreateModalStateLiteral" runat="server" />
    <script src="/admin/assets/vendor/ckeditor/ckeditor.js"></script>
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
            var createTrigger = document.getElementById('SupportCreateTrigger');
            var createModal = document.getElementById('SupportCreateModal');
            var detailModal = document.getElementById('SupportDetailModal');
            var detailButtons = document.querySelectorAll('.btn-support-detail');
            var createFromDetail = document.getElementById('SupportDetailCreate');
            var replySection = document.getElementById('SupportDetailReplySection');
            var replyInput = document.getElementById('<%= ReplyTicketIdInput.ClientID %>');
            var cancelBtn = document.getElementById('<%= CancelTicketButton.ClientID %>');
            var cancelArg = document.getElementById('<%= CancelTicketArgInput.ClientID %>');
            var createSuccess = document.getElementById('<%= CreateTicketSuccessInput.ClientID %>');
            var replyBtn = document.getElementById('<%= ReplyTicketButton.ClientID %>');

            function openModal(modal) {
                if (modal) {
                    modal.style.display = 'flex';
                }
            }

            function closeModal(modal) {
                if (modal) {
                    modal.style.display = 'none';
                }
            }

            if (createTrigger) {
                createTrigger.addEventListener('click', function () {
                    openModal(createModal);
                });
            }

            if (detailButtons.length) {
                detailButtons.forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        var code = btn.getAttribute('data-code') || 'SR';
                        var status = btn.getAttribute('data-status') || 'Chờ xử lý';
                        var title = btn.getAttribute('data-title') || '';
                        var desc = btn.getAttribute('data-desc') || '';
                        var reply = btn.getAttribute('data-reply') || 'Chưa có phản hồi từ admin.';
                        var hasReply = btn.getAttribute('data-has-reply') === 'true';
                        var ticketId = btn.getAttribute('data-ticket-id') || '';
                        var canCancel = btn.getAttribute('data-can-cancel') === 'True' || btn.getAttribute('data-can-cancel') === 'true';
                        var codeBox = document.getElementById('SupportDetailCode');
                        var statusBox = document.getElementById('SupportDetailStatus');
                        var descBox = document.getElementById('SupportDetailDesc');
                        var replyBox = document.getElementById('SupportDetailReply');
                        if (codeBox) codeBox.textContent = code;
                        if (statusBox) statusBox.textContent = status;
                        if (descBox) descBox.textContent = desc || title;
                        if (replyBox) replyBox.textContent = reply;
                        if (replyInput) replyInput.value = ticketId;
                        if (cancelBtn) {
                            cancelBtn.style.display = canCancel ? 'inline-flex' : 'none';
                            if (cancelArg) cancelArg.value = ticketId;
                        }
                        if (replySection) {
                            replySection.style.display = hasReply ? 'block' : 'none';
                        }
                        if (replyBtn) {
                            replyBtn.style.display = hasReply ? 'inline-flex' : 'none';
                        }
                        if (createFromDetail) {
                            createFromDetail.style.display = hasReply ? 'inline-flex' : 'none';
                        }
                        openModal(detailModal);
                    });
                });
            }

            if (createFromDetail) {
                createFromDetail.addEventListener('click', function () {
                    closeModal(detailModal);
                    openModal(createModal);
                });
            }

            document.addEventListener('click', function (event) {
                if (!event.target) return;
                if (event.target.matches('[data-modal-close]')) {
                    closeModal(createModal);
                    closeModal(detailModal);
                }
                if (event.target === createModal) {
                    closeModal(createModal);
                }
                if (event.target === detailModal) {
                    closeModal(detailModal);
                }
            });

            if (createSuccess && createSuccess.value === '1') {
                closeModal(createModal);
                createSuccess.value = '';
            }

            if (window.CKEDITOR) {
                CKEDITOR.config.versionCheck = false;
                CKEDITOR.replace('<%= CreateMessageInput.ClientID %>', {
                    height: 180,
                    removeButtons: 'Image,Table,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,Flash,Smiley,SpecialChar,PageBreak,Iframe,About'
                });
            }
        })();
    </script>
</asp:Content>



