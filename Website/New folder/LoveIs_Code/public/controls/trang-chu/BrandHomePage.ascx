<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BrandHomePage.ascx.cs" Inherits="public_controls_trang_chu_BrandHomePage" %>

<!--==================== Brand Showcase Section Start ====================-->
<div class="full-row pb-0 brand-showcase-section">
    <div class="container">
        
        <asp:Repeater ID="ShowcaseRepeater" runat="server" OnItemDataBound="ShowcaseRepeater_ItemDataBound">
            <ItemTemplate>
                <div class="brand-showcase-item mb-4">
                    <%--<div class="brand-showcase-title">
                    </div>--%>

                    <div class="row">
            <div class="col-12">
                <div class="section-head d-flex justify-content-between align-items-center pb-20">
                    <h3 class="text-secondary mb-0">Thương hiệu <span class="brand-title"><%# Eval("BrandName") %></span></h3>
                </div>
            </div>
        </div>


                    <div class="row g-3">
                        <div class="col-lg-4 col-md-5">
                            <div class="brand-video-card">
                                <asp:PlaceHolder ID="VideoWrap" runat="server" Visible='<%# (bool)Eval("HasVideo") %>'>
                                    <video class="brand-video" data-autoposter="1" src='<%# Eval("VideoUrl") %>' poster='<%# Eval("PosterUrl") %>' preload="metadata" autoplay controls muted playsinline loop></video>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="VideoFallback" runat="server" Visible='<%# !(bool)Eval("HasVideo") %>'>
                                    <img class="brand-video-fallback" src='<%# Eval("PosterUrl") %>' alt='<%# Eval("BrandName") %>' />
                                </asp:PlaceHolder>
                            </div>
                        </div>
                        <div class="col-lg-8 col-md-7">
                            <div class="row g-3">
                                <asp:Repeater ID="ShowcaseBannerRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="col-md-6">
                                            <a class="brand-banner" href='<%# Eval("LinkUrl") %>'>
                                                <img src='<%# Eval("ImageUrl") %>' alt="">
                                            </a>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
<!--==================== Brand Showcase Section End ====================-->

<script type="text/javascript">
(function () {
    function capturePoster(video) {
        if (video.dataset.posterCaptured === "1") {
            return;
        }

        var onReady = function () {
            var canvas = document.createElement("canvas");
            canvas.width = video.videoWidth || 1;
            canvas.height = video.videoHeight || 1;
            var ctx = canvas.getContext("2d");
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            try {
                video.setAttribute("poster", canvas.toDataURL("image/jpeg", 0.92));
                video.dataset.posterCaptured = "1";
            } catch (err) {
                // If the video is cross-origin without CORS, keep existing poster.
            }
        };

        var onSeeked = function () {
            video.removeEventListener("seeked", onSeeked);
            onReady();
        };

        if (video.readyState >= 2) {
            try {
                video.currentTime = Math.min(0.1, video.duration || 0.1);
                video.addEventListener("seeked", onSeeked);
            } catch (err) {
                onReady();
            }
        } else {
            video.addEventListener("loadeddata", function () {
                try {
                    video.currentTime = Math.min(0.1, video.duration || 0.1);
                    video.addEventListener("seeked", onSeeked);
                } catch (err) {
                    onReady();
                }
            });
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        var videos = document.querySelectorAll(".brand-video[data-autoposter='1']");
        for (var i = 0; i < videos.length; i++) {
            capturePoster(videos[i]);
        }
    });
})();
</script>



