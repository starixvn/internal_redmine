$(document).ready(function () {
    $(".gravatar").removeAttr('alt');

    $(Start);

    $(".news.box").detach().appendTo('.splitcontentleft');

    //document.getElementsByClassName("cke_editable")[0].addEventListener('paste', handlePaste);
});

function Start() {

    var OldHtml = window.jQuery.fn.html;

    window.jQuery.fn.html = function () {
        var EnhancedHtml = OldHtml.apply(this, arguments);

        if (arguments.length && EnhancedHtml.find('.gravatar').length) {
            $(".gravatar").removeAttr('alt');
        }
    }
}