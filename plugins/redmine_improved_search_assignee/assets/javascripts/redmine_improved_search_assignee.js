$(document).ready(function() {
	$('#issue_assigned_to_id').select2({
		width: '60%',
		containerCssClass: "issue_assigned_container",
     	dropdownCssClass: "issue_assigned_dropdown"
	});
	
	$('#issue_custom_field_values_7').select2({
		width: '60%',
		allowClear: true,
		containerCssClass: "issue_assigned_container",
     	dropdownCssClass: "issue_assigned_dropdown"		
	});
	
	$('#issue_custom_field_values_68').select2({
		width: '95%'
	});
	// Note: In PRO participants is 68, local 63
}); 