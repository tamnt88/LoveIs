<%@ Page Language="C#" AutoEventWireup="true" CodeFile="settings-account.aspx.cs" Inherits="SellerSettingsAccount" MasterPageFile="~/seller/Seller.master" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">Thông tin cửa hàng</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="seller-account-settings">
        <div class="settings-header">
            <div>
                <h2>Thông tin cửa hàng</h2>
                <p>Quản lý thông tin cửa hàng của bạn</p>
            </div>
        </div>

        <div class="card settings-card">
            <div class="settings-card-title">
                <i class="fa-solid fa-house"></i>
                Thông tin cửa hàng
            </div>
            <asp:Literal ID="AccountMessageLiteral" runat="server" />
            <div class="settings-grid">
                <div class="form-group">
                    <label>Tên shop</label>
                    <asp:TextBox ID="ShopNameInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group form-group-full">
                    <label>Mô tả shop</label>
                    <asp:TextBox ID="DescriptionInput" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <asp:TextBox ID="PhoneInput" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" TextMode="Email" />
                </div>
            </div>
            <div class="settings-card-title mt-4">
                <i class="fa-regular fa-images"></i>
                Logo &amp; hình ảnh
            </div>
            <div class="settings-grid logo-grid">
                <div class="form-group">
                    <label>Logo shop</label>
                    <div class="image-upload-card">
                        <asp:Image ID="LogoPreview" runat="server" CssClass="image-preview square" />
                        <asp:FileUpload ID="LogoUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="LogoUploadTrigger">Tải lên logo</button>
                    </div>
                </div>
                <div class="form-group">
                    <label>Banner shop</label>
                    <div class="image-upload-card wide">
                        <asp:Image ID="BannerPreview" runat="server" CssClass="image-preview wide" />
                        <asp:FileUpload ID="BannerUpload" runat="server" CssClass="d-none" accept="image/*" />
                        <button type="button" class="btn-address-outline" id="BannerUploadTrigger">Tải lên banner</button>
                    </div>
                </div>
            </div>
            <div class="settings-card-title mt-4">
                <i class="fa-regular fa-file-lines"></i>
                Thông tin kinh doanh
            </div>
            <div class="settings-grid">
                <div class="form-group">
                    <label>Loại hình kinh doanh</label>
                    <asp:DropDownList ID="BusinessTypeDropDown" runat="server" CssClass="form-control">
                        <asp:ListItem Value="individual">Cá nhân</asp:ListItem>
                        <asp:ListItem Value="company">Doanh nghiệp</asp:ListItem>
                        <asp:ListItem Value="household">Hộ kinh doanh</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Mã số thuế</label>
                    <asp:TextBox ID="TaxCodeInput" runat="server" CssClass="form-control" Placeholder="Nhập mã số thuế (nếu có)" />
                </div>
            </div>
            <div class="settings-actions account-actions">
                <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn-address-primary" OnClick="SaveButton_Click">Lưu thay đổi</asp:LinkButton>
            </div>
        </div>

        <div class="card settings-card account-security-card">
            <div class="settings-card-title">
                <i class="fa-solid fa-shield-halved"></i>
                Bảo mật tài khoản
            </div>
            <asp:Literal ID="PasswordMessageLiteral" runat="server" />
            <asp:Literal ID="KycMessageLiteral" runat="server" />
            <div class="security-item kyc-status-item">
                <div class="security-icon kyc" id="KycStatusIcon" runat="server">
                    <asp:Literal ID="KycStatusIconLiteral" runat="server" />
                </div>
                <div class="security-info">
                    <div class="security-title"><asp:Literal ID="KycStatusTitleLiteral" runat="server" /></div>
                    <div class="security-subtitle"><asp:Literal ID="KycStatusDescLiteral" runat="server" /></div>
                </div>
                <button type="button" class="btn-address-outline" id="OpenKycFlow" runat="server">Xác thực ngay</button>
                <span class="kyc-status-pill pending" id="KycPendingPill" runat="server" visible="false">Đang xét duyệt</span>
                <div class="kyc-rejected-actions inline" id="KycRejectedActionsInline" runat="server" visible="false">
                    <button type="button" class="btn-address-primary" id="KycResubmitBtnInline">Gửi lại hồ sơ</button>
                    <button type="button" class="btn-address-outline" id="KycRejectReasonBtnInline">Lý do từ chối</button>
                </div>
            </div>
            <div class="kyc-status-banner approved" id="KycApprovedBanner" runat="server" visible="false">
                Tài khoản đã được xác thực.
            </div>
            <div class="kyc-modal" id="KycModal">
                <div class="kyc-modal-overlay" data-kyc-close="kyc"></div>
                <div class="kyc-modal-content">
                    <div class="kyc-modal-header">
                        <div class="kyc-modal-title">Xác thực người bán</div>
                        <button type="button" class="kyc-modal-close" data-kyc-close="kyc">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                    <div class="kyc-progress">
                        <div class="kyc-progress-steps">
                            <div class="kyc-progress-step active" data-step="1">
                                <span class="step-dot">1</span>
                                <span class="step-label">Thông tin định danh</span>
                            </div>
                            <div class="kyc-progress-step" data-step="2">
                                <span class="step-dot">2</span>
                                <span class="step-label">Hình ảnh CCCD</span>
                            </div>
                            <div class="kyc-progress-step" data-step="3">
                                <span class="step-dot">3</span>
                                <span class="step-label">Ảnh bổ sung</span>
                            </div>
                        </div>
                    </div>
                    <div class="kyc-step kyc-step-active" data-step="1">
                        <div class="kyc-step-title">Thông tin định danh</div>
                        <div class="settings-grid">
                            <div class="form-group">
                                <label>Họ và tên</label>
                                <asp:TextBox ID="KycFullNameInput" runat="server" CssClass="form-control kyc-uppercase" />
                                <div class="field-error" id="KycFullNameError"></div>
                            </div>
                            <div class="form-group">
                                <label>Số CCCD</label>
                                <asp:TextBox ID="KycIdNumberInput" runat="server" CssClass="form-control" inputmode="numeric" />
                                <div class="field-error" id="KycIdNumberError"></div>
                            </div>
                            <div class="form-group">
                                <label>Ngày sinh</label>
                                <asp:TextBox ID="KycBirthDateInput" runat="server" CssClass="form-control" TextMode="Date" />
                                <div class="field-error" id="KycBirthDateError"></div>
                            </div>
                            <div class="form-group">
                                <label>Ngày cấp</label>
                                <asp:TextBox ID="KycIdIssuedDateInput" runat="server" CssClass="form-control" TextMode="Date" />
                                <div class="field-error" id="KycIdIssuedDateError"></div>
                            </div>
                            <div class="form-group form-group-full">
                                <label>Nơi cấp</label>
                                <asp:TextBox ID="KycIdIssuedPlaceInput" runat="server" CssClass="form-control" />
                                <div class="field-error" id="KycIdIssuedPlaceError"></div>
                            </div>
                        </div>
                        <div class="settings-actions">
                            <button type="button" class="btn-address-primary" id="KycStep1Next">Tiếp tục</button>
                        </div>
                    </div>
                    <div class="kyc-step" data-step="2">
                        <div class="kyc-step-title">Hình ảnh CCCD</div>
                        <div class="kyc-upload-grid">
                            <div class="kyc-upload-card" data-kyc-upload="front">
                                <div class="kyc-upload-frame">
                                    <asp:Image ID="KycFrontPreview" runat="server" CssClass="kyc-preview" />
                                    <button type="button" class="kyc-remove-btn" data-kyc-remove="front" title="Xóa ảnh">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                    <div class="kyc-upload-empty">
                                        <i class="fa-regular fa-id-card"></i>
                                        <div class="kyc-upload-title">Tải lên mặt trước CCCD</div>
                                        <div class="kyc-upload-sub">Hỗ trợ JPG, PNG. Tối đa 5MB</div>
                                    </div>
                                </div>
                                <button type="button" class="btn-address-outline kyc-change-btn" data-kyc-change="front">Chọn ảnh khác</button>
                                <asp:FileUpload ID="KycFrontUpload" runat="server" CssClass="d-none" accept="image/*" />
                                <asp:HiddenField ID="KycFrontExistingInput" runat="server" />
                            </div>
                            <div class="kyc-upload-card" data-kyc-upload="back">
                                <div class="kyc-upload-frame">
                                    <asp:Image ID="KycBackPreview" runat="server" CssClass="kyc-preview" />
                                    <button type="button" class="kyc-remove-btn" data-kyc-remove="back" title="Xóa ảnh">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                    <div class="kyc-upload-empty">
                                        <i class="fa-regular fa-id-card"></i>
                                        <div class="kyc-upload-title">Tải lên mặt sau CCCD</div>
                                        <div class="kyc-upload-sub">Hỗ trợ JPG, PNG. Tối đa 5MB</div>
                                    </div>
                                </div>
                                <button type="button" class="btn-address-outline kyc-change-btn" data-kyc-change="back">Chọn ảnh khác</button>
                                <asp:FileUpload ID="KycBackUpload" runat="server" CssClass="d-none" accept="image/*" />
                                <asp:HiddenField ID="KycBackExistingInput" runat="server" />
                            </div>
                        </div>
                        <div class="settings-actions">
                            <button type="button" class="btn-address-outline" data-kyc-prev="1">Quay lại</button>
                            <button type="button" class="btn-address-primary" id="KycStep2Next" disabled>Tiếp tục</button>
                        </div>
                    </div>
                    <div class="kyc-step" data-step="3">
                        <div class="kyc-step-title">
                            Ảnh xác thực bổ sung
                            <span class="kyc-optional-tag">Không bắt buộc</span>
                        </div>
                        <div class="kyc-upload-card compact" data-kyc-upload="selfie">
                            <div class="kyc-upload-frame">
                                <asp:Image ID="KycSelfiePreview" runat="server" CssClass="kyc-preview" />
                                <button type="button" class="kyc-remove-btn" data-kyc-remove="selfie" title="Xóa ảnh">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                                <div class="kyc-upload-empty">
                                    <i class="fa-solid fa-user-shield"></i>
                                    <div class="kyc-upload-title">Tải lên ảnh chân dung bạn đang cầm mặt trước CCCD.</div>
                                </div>
                            </div>
                            <button type="button" class="btn-address-outline kyc-change-btn" data-kyc-change="selfie">Chọn ảnh khác</button>
                            <asp:FileUpload ID="KycSelfieUpload" runat="server" CssClass="d-none" accept="image/*" />
                            <asp:HiddenField ID="KycSelfieExistingInput" runat="server" />
                        </div>
                        <div class="settings-actions">
                            <button type="button" class="btn-address-outline" data-kyc-prev="2">Quay lại</button>
                            <asp:LinkButton ID="SubmitKycButton" runat="server" CssClass="btn-address-primary" OnClick="SubmitKycButton_Click">Gửi hồ sơ</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
            <div class="kyc-modal" id="KycReasonModal">
                <div class="kyc-modal-overlay" data-kyc-close="reason"></div>
                <div class="kyc-modal-content">
                    <div class="kyc-modal-header">
                        <div class="kyc-modal-title">Lý do từ chối</div>
                        <button type="button" class="kyc-modal-close" data-kyc-close="reason">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                    <div class="kyc-reason-text"><asp:Literal ID="KycRejectedReasonLiteral" runat="server" /></div>
                    <div class="kyc-reason-list">
                        <div class="kyc-reason-section">
                            <div class="kyc-reason-title">Thông tin định danh</div>
                            <div><strong>Họ và tên:</strong> <asp:Literal ID="KycReviewNameLiteral" runat="server" /></div>
                            <div><strong>Số CCCD:</strong> <asp:Literal ID="KycReviewIdLiteral" runat="server" /></div>
                            <div><strong>Ngày sinh:</strong> <asp:Literal ID="KycReviewBirthLiteral" runat="server" /></div>
                            <div><strong>Ngày cấp:</strong> <asp:Literal ID="KycReviewIssuedLiteral" runat="server" /></div>
                            <div><strong>Nơi cấp:</strong> <asp:Literal ID="KycReviewPlaceLiteral" runat="server" /></div>
                        </div>
                        <div class="kyc-reason-section">
                            <div class="kyc-reason-title">Hình ảnh CCCD</div>
                            <div class="kyc-review-images">
                                <div class="kyc-review-card">
                                    <div class="kyc-review-label">Mặt trước</div>
                                    <asp:Image ID="KycReviewFrontPreview" runat="server" CssClass="kyc-review-preview" />
                                </div>
                                <div class="kyc-review-card">
                                    <div class="kyc-review-label">Mặt sau</div>
                                    <asp:Image ID="KycReviewBackPreview" runat="server" CssClass="kyc-review-preview" />
                                </div>
                            </div>
                        </div>
                        <div class="kyc-reason-section">
                            <div class="kyc-reason-title">Ảnh xác thực bổ sung</div>
                            <div class="kyc-review-card">
                                <div class="kyc-review-label">Selfie cầm CCCD</div>
                                <asp:Image ID="KycReviewSelfiePreview" runat="server" CssClass="kyc-review-preview" />
                                <div class="kyc-review-empty" id="KycReviewSelfieEmpty" runat="server">Chưa tải ảnh</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="security-item">
                <div class="security-icon password">
                    <i class="fa-solid fa-key"></i>
                </div>
                <div class="security-info">
                    <div class="security-title">Mật khẩu</div>
                    <div class="security-subtitle">
                        Thay đổi lần cuối: <asp:Literal ID="PasswordChangedAtLiteral" runat="server" />
                    </div>
                </div>
                <button type="button" class="btn-address-outline" id="TogglePasswordForm">Đổi mật khẩu</button>
            </div>
            <div class="security-form" id="PasswordForm">
                <div class="settings-grid">
                    <div class="form-group">
                        <label>Mật khẩu hiện tại</label>
                        <asp:TextBox ID="CurrentPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <asp:TextBox ID="NewPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu mới</label>
                        <asp:TextBox ID="ConfirmPasswordInput" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                </div>
                <div class="settings-actions account-actions">
                    <asp:LinkButton ID="ChangePasswordButton" runat="server" CssClass="btn-address-primary" OnClick="ChangePasswordButton_Click">Cập nhật mật khẩu</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <script>
        (function () {
            var logoInput = document.getElementById('<%= LogoUpload.ClientID %>');
            var bannerInput = document.getElementById('<%= BannerUpload.ClientID %>');
            var saveButton = document.getElementById('<%= SaveButton.ClientID %>');
            if (!saveButton) return;

            function bindUpload(input) {
                if (!input) return;
                input.addEventListener('change', function () {
                    if (input.files && input.files.length > 0) {
                        saveButton.click();
                    }
                });
            }

            bindUpload(logoInput);
            bindUpload(bannerInput);

            var logoTrigger = document.getElementById('LogoUploadTrigger');
            var bannerTrigger = document.getElementById('BannerUploadTrigger');
            if (logoTrigger && logoInput) {
                logoTrigger.addEventListener('click', function () {
                    logoInput.click();
                });
            }
            if (bannerTrigger && bannerInput) {
                bannerTrigger.addEventListener('click', function () {
                    bannerInput.click();
                });
            }

            var passwordToggle = document.getElementById('TogglePasswordForm');
            var passwordForm = document.getElementById('PasswordForm');
            if (passwordForm) {
                passwordForm.classList.remove('open');
            }
            if (passwordToggle && passwordForm) {
                passwordToggle.addEventListener('click', function () {
                    passwordForm.classList.toggle('open');
                });
            }
            if (passwordForm && window.location.hash === '#password') {
                passwordForm.classList.add('open');
                passwordForm.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }

            var kycModal = document.getElementById('KycModal');
            var kycToggle = document.getElementById('<%= OpenKycFlow.ClientID %>');
            var kycResubmitBtn = document.getElementById('KycResubmitBtnInline');
            var kycReasonBtn = document.getElementById('KycRejectReasonBtnInline');
            var kycReasonModal = document.getElementById('KycReasonModal');

            function openModal(modal) {
                if (!modal) return;
                modal.classList.add('open');
                clearKycErrors();
            }

            function closeModal(modal) {
                if (!modal) return;
                modal.classList.remove('open');
            }

            if (kycToggle) {
                kycToggle.addEventListener('click', function () {
                    openModal(kycModal);
                    showStep(1);
                });
            }

            if (kycResubmitBtn) {
                kycResubmitBtn.addEventListener('click', function () {
                    openModal(kycModal);
                    showStep(1);
                });
            }

            if (kycReasonBtn) {
                kycReasonBtn.addEventListener('click', function () {
                    openModal(kycReasonModal);
                });
            }

            document.querySelectorAll('[data-kyc-close]').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var target = btn.getAttribute('data-kyc-close');
                    if (target === 'kyc') {
                        closeModal(kycModal);
                    } else if (target === 'reason') {
                        closeModal(kycReasonModal);
                    }
                });
            });

            var stepNext1 = document.getElementById('KycStep1Next');
            var stepNext2 = document.getElementById('KycStep2Next');
            var steps = document.querySelectorAll('.kyc-step');
            var stepDots = document.querySelectorAll('.kyc-progress-step');

            function showStep(index) {
                steps.forEach(function (step) {
                    step.classList.toggle('kyc-step-active', step.getAttribute('data-step') === index.toString());
                });
                stepDots.forEach(function (dot) {
                    var stepIndex = parseInt(dot.getAttribute('data-step'), 10);
                    dot.classList.toggle('active', stepIndex === index);
                    dot.classList.toggle('completed', stepIndex < index);
                });
            }

            document.querySelectorAll('[data-kyc-prev]').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var target = parseInt(btn.getAttribute('data-kyc-prev'), 10);
                    showStep(target);
                });
            });

            if (stepNext2) {
                stepNext2.addEventListener('click', function () {
                    showStep(3);
                });
            }

            var fullNameInput = document.getElementById('<%= KycFullNameInput.ClientID %>');
            var idNumberInput = document.getElementById('<%= KycIdNumberInput.ClientID %>');
            var birthDateInput = document.getElementById('<%= KycBirthDateInput.ClientID %>');
            var issuedDateInput = document.getElementById('<%= KycIdIssuedDateInput.ClientID %>');
            var issuedPlaceInput = document.getElementById('<%= KycIdIssuedPlaceInput.ClientID %>');
            var errors = {
                fullName: document.getElementById('KycFullNameError'),
                idNumber: document.getElementById('KycIdNumberError'),
                birthDate: document.getElementById('KycBirthDateError'),
                issuedDate: document.getElementById('KycIdIssuedDateError'),
                issuedPlace: document.getElementById('KycIdIssuedPlaceError')
            };

            function clearKycErrors() {
                Object.keys(errors).forEach(function (key) {
                    if (errors[key]) {
                        errors[key].textContent = '';
                    }
                });
            }

            function normalizeName(value) {
                var text = (value || '').replace(/\s+/g, ' ').trim();
                if (!text) return '';
                return text.toUpperCase();
            }

            function formatIdNumber(value) {
                var digits = (value || '').replace(/\D/g, '').slice(0, 12);
                return digits.replace(/(\d{3})(?=\d)/g, '$1 ').trim();
            }

            function validateStep1(showErrors) {
                var fullName = normalizeName(fullNameInput ? fullNameInput.value : '');
                var idNumber = formatIdNumber(idNumberInput ? idNumberInput.value : '');
                var birthDate = birthDateInput ? birthDateInput.value : '';
                var issuedDate = issuedDateInput ? issuedDateInput.value : '';
                var issuedPlace = issuedPlaceInput ? issuedPlaceInput.value.trim() : '';

                if (fullNameInput) {
                    fullNameInput.value = fullName;
                }
                if (idNumberInput) {
                    idNumberInput.value = idNumber;
                }

                var rawDigits = idNumber.replace(/\s/g, '');

                if (showErrors) {
                    if (errors.fullName) {
                        errors.fullName.textContent = fullName ? '' : 'Vui lòng nhập họ và tên.';
                    }
                    if (errors.idNumber) {
                        errors.idNumber.textContent = rawDigits.length === 12 ? '' : 'Số CCCD gồm 12 số.';
                    }
                    if (errors.birthDate) {
                        errors.birthDate.textContent = birthDate ? '' : 'Vui lòng chọn ngày sinh.';
                    }
                    if (errors.issuedDate) {
                        errors.issuedDate.textContent = issuedDate ? '' : 'Vui lòng chọn ngày cấp.';
                    }
                    if (errors.issuedPlace) {
                        errors.issuedPlace.textContent = issuedPlace ? '' : 'Vui lòng nhập nơi cấp.';
                    }
                }

                var isValid = fullName && rawDigits.length === 12 && birthDate && issuedDate && issuedPlace;
                return isValid;
            }

            if (stepNext1) {
                stepNext1.addEventListener('click', function () {
                    var ok = validateStep1(true);
                    if (!ok) return;
                    showStep(2);
                });
            }

            [fullNameInput, idNumberInput, birthDateInput, issuedDateInput, issuedPlaceInput].forEach(function (input) {
                if (!input) return;
                input.addEventListener('input', function () {
                    validateStep1(false);
                });
            });

            function bindUpload(kind, inputId, existingId) {
                var input = document.getElementById(inputId);
                var existingInput = document.getElementById(existingId);
                var card = document.querySelector('[data-kyc-upload="' + kind + '"]');
                if (!card || !input) return;
                var changeBtn = card.querySelector('[data-kyc-change="' + kind + '"]');
                var removeBtn = card.querySelector('[data-kyc-remove="' + kind + '"]');
                var preview = card.querySelector('.kyc-preview');

                function updateState(hasImage) {
                    card.classList.toggle('has-image', hasImage);
                }

                function updatePreview(file) {
                    if (!preview) return;
                    if (!file) return;
                    var reader = new FileReader();
                    reader.onload = function (evt) {
                        preview.src = evt.target.result;
                        updateState(true);
                        updateStep2();
                    };
                    reader.readAsDataURL(file);
                }

                if (changeBtn) {
                    changeBtn.addEventListener('click', function () {
                        input.click();
                    });
                }

                if (removeBtn) {
                    removeBtn.addEventListener('click', function () {
                        if (preview) {
                            preview.src = '';
                        }
                        input.value = '';
                        if (existingInput) {
                            existingInput.value = '';
                        }
                        updateState(false);
                        updateStep2();
                    });
                }

                input.addEventListener('change', function () {
                    var file = input.files && input.files[0];
                    if (file) {
                        updatePreview(file);
                    }
                });

                var hasExisting = existingInput && existingInput.value;
                if (hasExisting && preview && preview.getAttribute('src')) {
                    updateState(true);
                } else {
                    updateState(false);
                }
            }

            function updateStep2() {
                if (!stepNext2) return;
                var hasFront = false;
                var hasBack = false;
                var frontCard = document.querySelector('[data-kyc-upload="front"]');
                var backCard = document.querySelector('[data-kyc-upload="back"]');
                if (frontCard) {
                    hasFront = frontCard.classList.contains('has-image');
                }
                if (backCard) {
                    hasBack = backCard.classList.contains('has-image');
                }
                stepNext2.disabled = !(hasFront && hasBack);
            }

            bindUpload('front', '<%= KycFrontUpload.ClientID %>', '<%= KycFrontExistingInput.ClientID %>');
            bindUpload('back', '<%= KycBackUpload.ClientID %>', '<%= KycBackExistingInput.ClientID %>');
            bindUpload('selfie', '<%= KycSelfieUpload.ClientID %>', '<%= KycSelfieExistingInput.ClientID %>');
            updateStep2();
        })();
    </script>
</asp:Content>
