$(document).ready(function () {
    // Re-arrange in home page
    $(".news.box").detach().appendTo('.splitcontentleft');

    // Add Select2 to project search
    $("#quick-search select").select2();

    // Remove DMSF upload button
    $(".dmsf_uploader").remove();
});
