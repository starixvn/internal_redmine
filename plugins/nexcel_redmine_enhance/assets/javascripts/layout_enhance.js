function showMenuContext() {
    var contextMenu = $('#allowed_status_context');
    var statusPosition = $('.status .arrow-down').offset().left;
    contextMenu.css('left', statusPosition);
    contextMenu.show();
}


function closeMenuContextWhenClickOutside() {
    $(document).mousedown(function (e) {
        var container = $('#allowed_status_context');

        // if the target of the click isn't the container nor a descendant of the container
        if (!container.is(e.target) && container.has(e.target).length === 0) {
            container.hide();
        }
    });
}

$(document).ready(function () {
    // Re-arrange in home page
    $(".news.box").detach().appendTo('.splitcontentleft');

    // Add Select2 to project search
    $("#quick-search select").select2();
    closeMenuContextWhenClickOutside();

    // Remove DMSF upload button
    // $(".dmsf_uploader").remove();


});


