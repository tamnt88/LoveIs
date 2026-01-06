$(function () {
  $(".icon-btn").on("click", function (e) {
    e.preventDefault();
    $(this).toggleClass("active");
  });
});
