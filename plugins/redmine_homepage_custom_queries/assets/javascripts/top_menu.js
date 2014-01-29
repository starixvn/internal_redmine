// Create top menu

var my_queries_menu = $("#top-menu ul li a.my-queries-menu").parent();
var custom_queries_menu = $("#top-menu ul li a.custom-queries-menu").parent();

var my_ul = "<ul>";
var custom_ul = "<ul>";
var ul = null;

$("#custom_queries").children().each(function() {
	if(ul == null && $(this).html() == "My custom queries") {
		ul = "my_ul";
	}
	else if($(this).html() == "Custom queries") {
		ul = "custom_ul";
	}
	else {
		if(ul === "my_ul") {
			my_ul += "<li>" + $(this).clone().wrap('<div>').parent().html() + "</li>";
		}
		else if(ul === "custom_ul") {
			custom_ul += "<li>" + $(this).clone().wrap('<div>').parent().html() + "</li>";
		}
	}			
});

my_ul += "</ul>";
custom_ul += "</ul>";

if($('#top-menu ul').dropit){
	my_queries_menu.append(my_ul);
	custom_queries_menu.append(custom_ul);	
}
else {
	custom_queries_menu.hide();
	my_queries_menu.hide();		
}

if(my_ul == "<ul></ul>") {
	my_queries_menu.hide();
}

$("#top-menu ul li a.my-queries-menu").html($("#top-menu ul li a.my-queries-menu").html() + " ▽");
$("#top-menu ul li a.custom-queries-menu").html($("#top-menu ul li a.custom-queries-menu").html() + " ▽");

if($('#top-menu ul').dropit){
	$('#top-menu ul').dropit({ action: 'hover' });
}

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

if($.cookie && $.cookie("toggle_header") == "hide") {
	$("#toggle_img").attr("src", "/plugin_assets/redmine_homepage_custom_queries/images/navigation-down.png");
}

$("#toggle_img").click(function(){
	if($.cookie("toggle_header") == "hide"){
		$("#header").css("visibility", "");
		$("#header").css("position", "");
		$("#toggle_img").attr("src", "/plugin_assets/redmine_homepage_custom_queries/images/navigation-up.png");
		$.removeCookie("toggle_header", {path: "/"});
	}
	else {
		$("#header").css("visibility", "hidden");
		$("#header").css("position", "absolute");
		$("#toggle_img").attr("src", "/plugin_assets/redmine_homepage_custom_queries/images/navigation-down.png");
		$.cookie("toggle_header", "hide", {path: "/"});
	}		
});


