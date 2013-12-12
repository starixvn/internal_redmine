var my_queries_menu = $("#top-menu ul li a.my-queries-menu").parent();
var custom_queries_menu = $("#top-menu ul li a.custom-queries-menu").parent();

var my_ul = "<ul>";
var custom_ul = "<ul>";
var ul = null;

$("#custom_queries").children().each(function() {
	if(ul == null && $(this).prop("tagName") == "H3") {
		ul = "my_ul";
	}
	else if($(this).prop("tagName") == "H3") {
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

my_queries_menu.append(my_ul);
custom_queries_menu.append(custom_ul);

if(my_ul == "<ul></ul>") {
	my_queries_menu.hide();
}

$("#top-menu ul li a.my-queries-menu").html($("#top-menu ul li a.my-queries-menu").html() + " ▽");
$("#top-menu ul li a.custom-queries-menu").html($("#top-menu ul li a.custom-queries-menu").html() + " ▽");

$('#top-menu ul').dropit();