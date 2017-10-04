// Create top menu

var my_queries_menu = $("#top-menu ul li a.my-queries-menu").parent();
var custom_queries_menu = $("#top-menu ul li a.custom-queries-menu").parent();

// @Forrest - 05 Jan, 2017. Fix when upgrade to Redmine 3.3.1

var my_ul = "";
var custom_ul = "";
var ul = null;

$("#custom_queries").children().each(function () {
	if (ul == null && $(this).html() == "My custom queries") {
		ul = "my_ul";
	} else if ($(this).html() == "Custom queries") {
		ul = "custom_ul";
	} else {
		if (ul === "my_ul") {
			my_ul += $(this).clone().wrap('<div>').parent().html();
		} else if (ul === "custom_ul") {
			custom_ul += $(this).clone().wrap('<div>').parent().html();
		}
	}
});

my_queries_menu.append(my_ul);
custom_queries_menu.append(custom_ul);

if (my_queries_menu.children().length <= 1) {
	my_queries_menu.hide();
} else {
	my_queries_menu.show();
}

// End Comment

$("#top-menu ul li a.my-queries-menu").html($("#top-menu ul li a.my-queries-menu").html() + " ▽");
$("#top-menu ul li a.custom-queries-menu").html($("#top-menu ul li a.custom-queries-menu").html() + " ▽");

$("a.query").each(function () {
	InsertIssueHref($(this));
})

function InsertIssueHref($element) {
	var href = "?" + $element.attr("href").split('?')[1];
	if (href.indexOf("/issues") === -1) {
		$element.attr("href", "/issues" + href)
	}
}

// @Forrest - 05 Jan, 2017. Fix when upgrade to Redmine 3.3.1
$('#top-menu ul').dropit({
	action: 'mouseover'
});
// End Comment

// Append header toggle button
var toggle_img = '<img id="toggle_img" src="/plugin_assets/redmine_homepage_custom_queries/images/navigation-up.png" style=" \
    position: absolute; \
    z-index: 99999; \
    right: 310px; \
    top: -3px; \
    width: 30px; \
    cursor: pointer \
	">';
$("#loggedas").html(toggle_img + $("#loggedas").html());

if ($.cookie && $.cookie("toggle_header") == "hide") {
	$("#toggle_img").attr("src", "/plugin_assets/redmine_homepage_custom_queries/images/navigation-down.png");
}

$("#toggle_img").click(function () {
	if ($.cookie("toggle_header") == "hide") {
		$("#header").css("visibility", "");
		$("#header").css("position", "");
		$("#toggle_img").attr("src", "/plugin_assets/redmine_homepage_custom_queries/images/navigation-up.png");
		$.removeCookie("toggle_header", {
			path: "/"
		});
	} else {
		$("#header").css("visibility", "hidden");
		$("#header").css("position", "absolute");
		$("#toggle_img").attr("src", "/plugin_assets/redmine_homepage_custom_queries/images/navigation-down.png");
		$.cookie("toggle_header", "hide", {
			path: "/"
		});
	}
});