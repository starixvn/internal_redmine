/**
 * @author qui.nguyen
 */

var normal_state = {},
	max_state = {},
	save_parent_states = [],
	maximized = false;

function issue_save_spm_state(){
	normal_state = {
		width: "",
		height: "260px"
	};	
	
	max_state = {
		top: "0px",
		left: "0px",
		width: $(document.body).width() + "px",
		height: $(window).height() + "px"
	};
}

function issue_spm_widgets_show() {
	$("#issue_spm_widgets").show();
	$("#issue_spm_toggle").html("Collapse");
	$("#issue_spm").css("height", "260px");
	$.cookie("issue_spm_toggle", "show", {path: "/"});		
}

function issue_spm_widgets_hide(){
	$("#issue_spm_widgets").hide();
	$("#issue_spm_toggle").html("Expand");
	$("#issue_spm").css("height", "30px");			
	$.removeCookie("issue_spm_toggle", {path: "/"});	
}	

function issue_spm_toggle(){
	if($.cookie("issue_spm_toggle")) {
		issue_spm_widgets_hide();
	}
	else {
		issue_spm_widgets_show();
	}
}

$(document).ready(function() {		
	$("#issue_spm_toggle").click(issue_spm_toggle);
	$("#issue_spm_max").click(issue_spm_maximize);
	issue_save_spm_state();
	
	if(location.href.indexOf("#spm") != -1){
		issue_spm_maximize();
	}
});

function issue_spm_set_state(state){
	var issue_spm = $("#issue_spm");
	issue_spm.width(state.width);
	issue_spm.height(state.height);
	
	$("#issue_spm_widgets").height((issue_spm.height() - 15) + "px");
	
	if (maximized){
		issue_spm.css({
			"position": "absolute",
			"z-index": "999999",
			"left": state.left,
			"top": state.top,
			"padding": "5px",
			"box-sizing": "border-box"
			});
	}
	else {			
		issue_spm.css({
			"position": "",
			"z-index": "",
			"left": "",
			"top": "",
			"width": "",
			"padding": "",
			"box-sizing": ""
			});
	}
}

function issue_spm_maximize(){
	maximized = !maximized;
	if(maximized === true) {
		issue_spm_set_state(max_state);
		$("#issue_spm_max").html("Minimize");
		$("#issue_spm_widgets").show();
		$("#spm_expand_section").hide();
		$("#issue_spm").parents().each(function(){
			var p = $(this);		
			if(p.prop("tagName") === "HTML") {
				
				p.data("save-style", {
					"position": p.css("position"),
					"z-index": p.css("z-index"),
					"width": p.css("width"),
					"height": p.css("height")
				});
				
				p.css({
					position: "fixed", 
					"z-index": "999999", 
					width: "0px", 
					height: "0px"
				});
			}
			else {
				p.data("save-style", {
					"position": p.css("position"),
					"z-index": p.css("z-index"),
					"overflow:": p.css("overflow:")
				});	
				
				p.css({
					position: "static", 
					"z-index": "999999", 
					overflow: "visible"
				});	
			}
		});
	}
	else {
		issue_spm_set_state(normal_state);
		issue_spm_widgets_show();
		$("#issue_spm_max").html("Maximize");
		$("#spm_expand_section").show();
		$("#issue_spm").parents().each(function(){
			var p = $(this);
			if(p.prop("tagName") === "HTML") {
				p.css(p.data("save-style"));
			}
			else {
				p.css(p.data("save-style"));
			}
		});
	}
}