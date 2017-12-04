$(document).ready(function() {
	$('#issue_assigned_to_id').select2({
		width: '60%',
		allowClear: true,
		containerCssClass: "issue_assigned_container",
     	dropdownCssClass: "issue_assigned_dropdown"
	});
	
	$('#issue_custom_field_values_7').select2({
		width: '60%',
		containerCssClass: "issue_assigned_container",
     	dropdownCssClass: "issue_assigned_dropdown"		
	});
	
	$('#issue_custom_field_values_63').select2({
		width: '95%'
	});
}); 